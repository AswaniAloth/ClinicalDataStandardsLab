/*****************************************************************************************
 Program:        adeg.sas
 Purpose:        Create Final ADaM ECG Dataset (ADEG)
                 Based on ADINT_EG + ADSL
                 Following ADaM IG and Oncology Examples patterns

 Inputs:         adint_eg.sas7bdat
                 adsl.sas7bdat

 Output:         adeg.sas7bdat

 Key Derivations:
    - PARAM / PARAMCD (QT, QTcF, PR, QRS, HR)
    - AVAL / AVALC
    - BASE / CHG / PCHG
    - AVISIT / AVISITN (from ADINT)
    - ADT / ADTM / ADY (from ADINT)
    - Traceability (SRC = "EG")
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load ADINT and ADSL
----------------------------------------------------------------------------------------*/

libname adam "path/adam";

data adint_eg;
    set adam.adint_eg;
run;

data adsl;
    set adam.adsl;
run;

/*----------------------------------------------------------------------------------------
  2. Merge ADINT_EG with ADSL
----------------------------------------------------------------------------------------*/

proc sql;
    create table eg1 as
    select a.*,
           b.studyid, b.subjid, b.siteid,
           b.arm, b.armcd,
           b.saffl, b.fasfl, b.ittfl
    from adint_eg as a
    left join adsl as b
      on a.usubjid = b.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. PARAM / PARAMCD
----------------------------------------------------------------------------------------*/

data eg2;
    set eg1;

    length param $200 paramcd $20;

    param   = strip(egtest) || " (" || strip(egstresu) || ")";
    paramcd = strip(egtestcd);
run;

/*----------------------------------------------------------------------------------------
  4. AVAL / AVALC
----------------------------------------------------------------------------------------*/

data eg3;
    set eg2;

    aval  = egstresn;
    avalc = egstresc;
run;

/*----------------------------------------------------------------------------------------
  5. Baseline Value (BASE)
----------------------------------------------------------------------------------------*/

proc sql;
    create table base as
    select usubjid, paramcd, aval as base
    from eg3
    where ablfl = "Y";
quit;

proc sql;
    create table eg4 as
    select a.*, b.base
    from eg3 as a
    left join base as b
      on a.usubjid = b.usubjid
     and a.paramcd = b.paramcd;
quit;

/*----------------------------------------------------------------------------------------
  6. Change from Baseline (CHG) and Percent Change (PCHG)
----------------------------------------------------------------------------------------*/

data eg5;
    set eg4;

    if not missing(aval) and not missing(base) then chg = aval - base;
    if not missing(aval) and not missing(base) and base ne 0 then
        pchg = ((aval - base) / base) * 100;
run;

/*----------------------------------------------------------------------------------------
  7. Traceability
----------------------------------------------------------------------------------------*/

data eg6;
    set eg5;
    src = "EG";
run;

/*----------------------------------------------------------------------------------------
  8. Final ADEG Dataset
----------------------------------------------------------------------------------------*/

data adam.adeg;
    set eg6;

    keep studyid usubjid subjid siteid
         arm armcd saffl fasfl ittfl
         param paramcd
         aval avalc base chg pchg
         adt adtm ady
         avisit avisitn
         ablfl impute_ady
         egstresn egstresu egstresc
         src;
run;

/*****************************************************************************************
 End of Program
******************************************************************************************/
