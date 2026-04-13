/*****************************************************************************************
 Program:        adlb.sas
 Purpose:        Create Final ADaM Laboratory Dataset (ADLB)
                 Based on ADINT_LB + ADSL
                 Following ADaM IG and Oncology Examples patterns

 Inputs:         adint_lb.sas7bdat
                 adsl.sas7bdat

 Output:         adlb.sas7bdat

 Key Derivations:
    - PARAM / PARAMCD
    - AVAL / AVALC
    - BASE / CHG / PCHG
    - ABLFL (from ADINT)
    - AVISIT / AVISITN (from ADINT)
    - Traceability (SRC = "LB")
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load ADINT and ADSL
----------------------------------------------------------------------------------------*/

libname adam "path/adam";

data adint_lb;
    set adam.adint_lb;
run;

data adsl;
    set adam.adsl;
run;

/*----------------------------------------------------------------------------------------
  2. Merge ADINT_LB with ADSL
----------------------------------------------------------------------------------------*/

proc sql;
    create table lb1 as
    select a.*, 
           b.studyid, b.subjid, b.siteid,
           b.arm, b.armcd,
           b.saffl, b.fasfl, b.ittfl
    from adint_lb as a
    left join adsl as b
      on a.usubjid = b.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. PARAM / PARAMCD
----------------------------------------------------------------------------------------*/

data lb2;
    set lb1;

    length param $200 paramcd $20;

    param   = strip(lbtest) || " (" || strip(lbstresu) || ")";
    paramcd = strip(lbtestcd);
run;

/*----------------------------------------------------------------------------------------
  4. AVAL / AVALC
----------------------------------------------------------------------------------------*/

data lb3;
    set lb2;

    aval  = lbstresn;
    avalc = lbstresc;
run;

/*----------------------------------------------------------------------------------------
  5. Baseline Value (BASE)
----------------------------------------------------------------------------------------*/

proc sql;
    create table base as
    select usubjid, paramcd, aval as base
    from lb3
    where ablfl = "Y";
quit;

proc sql;
    create table lb4 as
    select a.*, b.base
    from lb3 as a
    left join base as b
      on a.usubjid = b.usubjid
     and a.paramcd = b.paramcd;
quit;

/*----------------------------------------------------------------------------------------
  6. Change from Baseline (CHG) and Percent Change (PCHG)
----------------------------------------------------------------------------------------*/

data lb5;
    set lb4;

    if not missing(aval) and not missing(base) then chg = aval - base;
    if not missing(aval) and not missing(base) and base ne 0 then
        pchg = ((aval - base) / base) * 100;
run;

/*----------------------------------------------------------------------------------------
  7. Traceability
----------------------------------------------------------------------------------------*/

data lb6;
    set lb5;
    src = "LB";
run;

/*----------------------------------------------------------------------------------------
  8. Final ADLB Dataset
----------------------------------------------------------------------------------------*/

data adam.adlb;
    set lb6;

    keep studyid usubjid subjid siteid
         arm armcd saffl fasfl ittfl
         param paramcd
         aval avalc base chg pchg
         adt adtm ady
         avisit avisitn
         ablfl impute_ady
         lbstresn lbstresu lbstresc
         src;
run;

/*****************************************************************************************
 End of Program
******************************************************************************************/
