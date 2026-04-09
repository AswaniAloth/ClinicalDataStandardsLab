/*****************************************************************************************
 Program:        adint_lb.sas
 Purpose:        Create Intermediate ADaM Laboratory Dataset (ADINT_LB)
                 Based on SDTM LB domains from PHUSE Test Data Factory (TDF_SDTM)
                 Following derivation patterns inspired by CDISC ADaM Oncology Examples

 Inputs:         lbch.xpt, lbhe.xpt, lbur.xpt  (SDTM LB split domains)
                 dm.xpt                        (Demographics)
                 ex.xpt                        (Exposure – for TRTSDT)
                 sv.xpt                        (Subject Visits – for windowing)

 Outputs:        adint_lb.sas7bdat

 Key Derivations:
    - Combine LB split domains
    - Convert SDTM dates → ADT / ADTM
    - Derive ADY (study day)
    - Visit windowing → AVISIT / AVISITN
    - Baseline identification (ABLFL)
    - Imputation flags
    - Harmonized units (if applicable)
    - Traceability variables

******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load SDTM domains
----------------------------------------------------------------------------------------*/

libname sdtm_ch xport "path/TDF_SDTM/lbch.xpt";
libname sdtm_he xport "path/TDF_SDTM/lbhe.xpt";
libname sdtm_ur xport "path/TDF_SDTM/lbur.xpt";
libname sdtm_dm xport "path/TDF_SDTM/dm.xpt";
libname sdtm_ex xport "path/TDF_SDTM/ex.xpt";
libname sdtm_sv xport "path/TDF_SDTM/sv.xpt";

/* Combine LB split domains */
data lb_raw;
    set sdtm_ch.lbch
        sdtm_he.lbhe
        sdtm_ur.lbur;
run;

/* DM */
data dm;
    set sdtm_dm.dm;
run;

/* EX */
data ex;
    set sdtm_ex.ex;
run;

/* SV */
data sv;
    set sdtm_sv.sv;
run;

/*----------------------------------------------------------------------------------------
  2. Derive Treatment Start Date (TRTSDT)
----------------------------------------------------------------------------------------*/

proc sql;
    create table trt as
    select usubjid,
           min(input(exstdtc, yymmdd10.)) as trtsdt format=yymmdd10.
    from ex
    group by usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. Merge LB with TRTSDT and DM
----------------------------------------------------------------------------------------*/

proc sql;
    create table lb1 as
    select a.*, b.trtsdt, c.arm, c.sex, c.age
    from lb_raw as a
    left join trt as b on a.usubjid = b.usubjid
    left join dm  as c on a.usubjid = c.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  4. Convert SDTM datetime → ADT / ADTM
----------------------------------------------------------------------------------------*/

data lb2;
    set lb1;

    /* ADT: Analysis Date */
    if not missing(lbdtc) then adt = input(substr(lbdtc,1,10), yymmdd10.);

    /* ADTM: Analysis Datetime */
    if length(lbdtc) >= 16 then adtm = input(lbdtc, e8601dt.);
    format adt yymmdd10. adtm e8601dt.;
run;

/*----------------------------------------------------------------------------------------
  5. Derive Study Day (ADY)
----------------------------------------------------------------------------------------*/

data lb3;
    set lb2;
    if not missing(adt) and not missing(trtsdt) then do;
        ady = adt - trtsdt + (adt >= trtsdt);
    end;
run;

/*----------------------------------------------------------------------------------------
  6. Visit Windowing (AVISIT / AVISITN)
----------------------------------------------------------------------------------------*/

proc sql;
    create table sv2 as
    select usubjid,
           visitnum,
           visit,
           input(svstdtc, yymmdd10.) as svstdt
    from sv;
quit;

/* Map LB to nearest visit within ±3 days */
proc sql;
    create table lb4 as
    select a.*, 
           b.visit as avisit,
           b.visitnum as avisitn
    from lb3 as a
    left join sv2 as b
      on a.usubjid = b.usubjid
     and abs(a.adt - b.svstdt) <= 3
    order by usubjid, lbtestcd, adt;
quit;

/*----------------------------------------------------------------------------------------
  7. Baseline Identification (ABLFL)
     Baseline = last non-missing value prior to TRTSDT
----------------------------------------------------------------------------------------*/

proc sort data=lb4; by usubjid lbtestcd adt; run;

data lb5;
    set lb4;
    by usubjid lbtestcd;

    if first.lbtestcd then ablfl_temp = "";

    if not missing(adt) and adt < trtsdt then ablfl_temp = "Y";

    retain ablfl_temp;
run;

/* Keep only last baseline record per test */
data baseline;
    set lb5;
    if ablfl_temp = "Y";
run;

proc sort data=baseline; 
    by usubjid lbtestcd descending adt; 
run;

data baseline_final;
    set baseline;
    by usubjid lbtestcd;
    if first.lbtestcd;
run;

/* Merge baseline flag back */
proc sql;
    create table lb6 as
    select a.*,
           case when a.usubjid=b.usubjid 
                 and a.lbtestcd=b.lbtestcd 
                 and a.adt=b.adt 
                then "Y" else "" end as ablfl
    from lb5 as a
    left join baseline_final as b
    on a.usubjid=b.usubjid 
       and a.lbtestcd=b.lbtestcd 
       and a.adt=b.adt;
quit;

/*----------------------------------------------------------------------------------------
  8. Imputation Flags
----------------------------------------------------------------------------------------*/

data lb7;
    set lb6;
    if missing(ady) and not missing(adt) then impute_ady = "Y";
run;

/*----------------------------------------------------------------------------------------
  9. Harmonize Units (example only)
----------------------------------------------------------------------------------------*/

data lb8;
    set lb7;

    /* Example: ALT always in U/L */
    if lbtestcd = "ALT" and lbstresu = "U/L" then aval = lbstresn;

    /* Add more rules as needed */
run;

/*----------------------------------------------------------------------------------------
  10. Final ADINT_LB Dataset
----------------------------------------------------------------------------------------*/

data adint_lb;
    set lb8;

    keep usubjid lbtestcd lbtest lbstresn lbstresu
         adt adtm ady avisit avisitn
         ablfl impute_ady trtsdt arm sex age;
run;

proc datasets lib=work nolist;
    delete lb: sv2 baseline:;
quit;

/*****************************************************************************************
 End of Program
*****************************************************************************************/
