/*****************************************************************************************
 Program:        adint_vs.sas
 Purpose:        Create Intermediate ADaM Vital Signs Dataset (ADINT_VS)
                 Based on SDTM VS from PHUSE Test Data Factory (TDF_SDTM)
                 Using patterns inspired by CDISC ADaM Oncology Examples

 Inputs:         vs.xpt      (Vital Signs)
                 dm.xpt      (Demographics)
                 ex.xpt      (Exposure – for TRTSDT)
                 sv.xpt      (Subject Visits – for windowing)

 Output:         adint_vs.sas7bdat

 Key Derivations:
    - ADT / ADTM from VSDTC
    - ADY (study day) from TRTSDT
    - AVISIT / AVISITN via SV windowing
    - Baseline flag (ABLFL)
    - Simple imputation flag for ADY
    - Unit harmonization placeholder
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load SDTM domains
----------------------------------------------------------------------------------------*/

libname sdtm_vs xport "path/TDF_SDTM/vs.xpt";
libname sdtm_dm xport "path/TDF_SDTM/dm.xpt";
libname sdtm_ex xport "path/TDF_SDTM/ex.xpt";
libname sdtm_sv xport "path/TDF_SDTM/sv.xpt";

data vs_raw;
    set sdtm_vs.vs;
run;

data dm;
    set sdtm_dm.dm;
run;

data ex;
    set sdtm_ex.ex;
run;

data sv;
    set sdtm_sv.sv;
run;

/*----------------------------------------------------------------------------------------
  2. Derive Treatment Start Date (TRTSDT) from EX
----------------------------------------------------------------------------------------*/

proc sql;
    create table trt as
    select usubjid,
           min(input(exstdtc, yymmdd10.)) as trtsdt format=yymmdd10.
    from ex
    group by usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. Merge VS with TRTSDT and DM
----------------------------------------------------------------------------------------*/

proc sql;
    create table vs1 as
    select a.*, b.trtsdt, c.arm, c.sex, c.age
    from vs_raw as a
    left join trt as b on a.usubjid = b.usubjid
    left join dm  as c on a.usubjid = c.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  4. Convert VSDTC → ADT / ADTM
----------------------------------------------------------------------------------------*/

data vs2;
    set vs1;

    if not missing(vsdtc) then adt = input(substr(vsdtc,1,10), yymmdd10.);
    if length(vsdtc) >= 16 then adtm = input(vsdtc, e8601dt.);

    format adt yymmdd10. adtm e8601dt.;
run;

/*----------------------------------------------------------------------------------------
  5. Derive Study Day (ADY)
----------------------------------------------------------------------------------------*/

data vs3;
    set vs2;
    if not missing(adt) and not missing(trtsdt) then
        ady = adt - trtsdt + (adt >= trtsdt);
run;

/*----------------------------------------------------------------------------------------
  6. Visit Windowing (AVISIT / AVISITN) using SV
----------------------------------------------------------------------------------------*/

proc sql;
    create table sv2 as
    select usubjid,
           visitnum,
           visit,
           input(svstdtc, yymmdd10.) as svstdt
    from sv;
quit;

proc sql;
    create table vs4 as
    select a.*,
           b.visit    as avisit,
           b.visitnum as avisitn
    from vs3 as a
    left join sv2 as b
      on a.usubjid = b.usubjid
     and abs(a.adt - b.svstdt) <= 3
    order by usubjid, vstestcd, adt;
quit;

/*----------------------------------------------------------------------------------------
  7. Baseline Identification (ABLFL)
     Baseline = last non-missing value prior to TRTSDT per test
----------------------------------------------------------------------------------------*/

proc sort data=vs4; by usubjid vstestcd adt; run;

data vs5;
    set vs4;
    by usubjid vstestcd;

    if first.vstestcd then ablfl_temp = "";

    if not missing(adt) and adt < trtsdt then ablfl_temp = "Y";

    retain ablfl_temp;
run;

data baseline;
    set vs5;
    if ablfl_temp = "Y";
run;

proc sort data=baseline;
    by usubjid vstestcd descending adt;
run;

data baseline_final;
    set baseline;
    by usubjid vstestcd;
    if first.vstestcd;
run;

proc sql;
    create table vs6 as
    select a.*,
           case when a.usubjid=b.usubjid
                 and a.vstestcd=b.vstestcd
                 and a.adt=b.adt
                then "Y" else "" end as ablfl
    from vs5 as a
    left join baseline_final as b
      on a.usubjid=b.usubjid
     and a.vstestcd=b.vstestcd
     and a.adt=b.adt;
quit;

/*----------------------------------------------------------------------------------------
  8. Imputation Flags
----------------------------------------------------------------------------------------*/

data vs7;
    set vs6;
    if missing(ady) and not missing(adt) then impute_ady = "Y";
run;

/*----------------------------------------------------------------------------------------
  9. Unit Harmonization Placeholder
----------------------------------------------------------------------------------------*/

data vs8;
    set vs7;

    /* Example: Systolic BP (SYSBP) in mmHg */
    if vstestcd = "SYSBP" and vsstresu = "mmHg" then aval = vsstresn;

    /* Add more harmonization rules as needed */
run;

/*----------------------------------------------------------------------------------------
  10. Final ADINT_VS Dataset
----------------------------------------------------------------------------------------*/

data adint_vs;
    set vs8;

    keep usubjid vstestcd vstest vsstresn vsstresu
         adt adtm ady avisit avisitn
         ablfl impute_ady trtsdt arm sex age;
run;

proc datasets lib=work nolist;
    delete vs: sv2 baseline:;
quit;

/*****************************************************************************************
 End of Program
*****************************************************************************************/
