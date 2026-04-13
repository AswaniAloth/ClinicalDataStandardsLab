/*****************************************************************************************
 Program:        advs.sas
 Purpose:        Create Final ADaM Vital Signs Dataset (ADVS)
                 Based on ADINT_VS + ADSL
                 Following ADaM IG and Oncology Examples patterns

 Inputs:         adint_vs.sas7bdat
                 adsl.sas7bdat

 Output:         advs.sas7bdat

 Key Derivations:
    - PARAM / PARAMCD
    - AVAL / AVALC
    - BASE / CHG / PCHG
    - ABLFL (from ADINT)
    - AVISIT / AVISITN (from ADINT)
    - Traceability (SRC = "VS")
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load ADINT and ADSL
----------------------------------------------------------------------------------------*/

libname adam "path/adam";

data adint_vs;
    set adam.adint_vs;
run;

data adsl;
    set adam.adsl;
run;

/*----------------------------------------------------------------------------------------
  2. Merge ADINT_VS with ADSL
----------------------------------------------------------------------------------------*/

proc sql;
    create table vs1 as
    select a.*,
           b.studyid, b.subjid, b.siteid,
           b.arm, b.armcd,
           b.saffl, b.fasfl, b.ittfl
    from adint_vs as a
    left join adsl as b
      on a.usubjid = b.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. PARAM / PARAMCD
----------------------------------------------------------------------------------------*/

data vs2;
    set vs1;

    length param $200 paramcd $20;

    param   = strip(vstest) || " (" || strip(vsstresu) || ")";
    paramcd = strip(vstestcd);
run;

/*----------------------------------------------------------------------------------------
  4. AVAL / AVALC
----------------------------------------------------------------------------------------*/

data vs3;
    set vs2;

    aval  = vsstresn;
    avalc = vsstresc;
run;

/*----------------------------------------------------------------------------------------
  5. Baseline Value (BASE)
----------------------------------------------------------------------------------------*/

proc sql;
    create table base as
    select usubjid, paramcd, aval as base
    from vs3
    where ablfl = "Y";
quit;

proc sql;
    create table vs4 as
    select a.*, b.base
    from vs3 as a
    left join base as b
      on a.usubjid = b.usubjid
     and a.paramcd = b.paramcd;
quit;

/*----------------------------------------------------------------------------------------
  6. Change from Baseline (CHG) and Percent Change (PCHG)
----------------------------------------------------------------------------------------*/

data vs5;
    set vs4;

    if not missing(aval) and not missing(base) then chg = aval - base;
    if not missing(aval) and not missing(base) and base ne 0 then
        pchg = ((aval - base) / base) * 100;
run;

/*----------------------------------------------------------------------------------------
  7. Traceability
----------------------------------------------------------------------------------------*/

data vs6;
    set vs5;
    src = "VS";
run;

/*----------------------------------------------------------------------------------------
  8. Final ADVS Dataset
----------------------------------------------------------------------------------------*/

data adam.advs;
    set vs6;

    keep studyid usubjid subjid siteid
         arm armcd saffl fasfl ittfl
         param paramcd
         aval avalc base chg pchg
         adt adtm ady
         avisit avisitn
         ablfl impute_ady
         vsstresn vsstresu vsstresc
         src;
run;

/*****************************************************************************************
 End of Program
******************************************************************************************/
