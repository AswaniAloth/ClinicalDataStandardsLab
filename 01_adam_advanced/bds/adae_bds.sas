/*****************************************************************************************
 Program:        adae_bds.sas
 Purpose:        Create Final ADaM Adverse Events Dataset (ADAE)
                 Based on ADINT_AE + ADSL
                 Following ADaM IG and Oncology Examples patterns

 Inputs:         adint_ae.sas7bdat
                 adsl.sas7bdat

 Output:         adae.sas7bdat

 Key Derivations:
    - PARAM / PARAMCD (SOC/PT)
    - AVALC (AE term)
    - ADT / ADTM / ADY (from ADINT)
    - TRTEMFL (from ADINT)
    - AVISIT / AVISITN (from ADINT)
    - Seriousness / Severity
    - Traceability (SRC = "AE")
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load ADINT and ADSL
----------------------------------------------------------------------------------------*/

libname adam "path/adam";

data adint_ae;
    set adam.adint_ae;
run;

data adsl;
    set adam.adsl;
run;

/*----------------------------------------------------------------------------------------
  2. Merge ADINT_AE with ADSL
----------------------------------------------------------------------------------------*/

proc sql;
    create table ae1 as
    select a.*,
           b.studyid, b.subjid, b.siteid,
           b.arm, b.armcd,
           b.saffl, b.fasfl, b.ittfl
    from adint_ae as a
    left join adsl as b
      on a.usubjid = b.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. PARAM / PARAMCD
     AE is typically parameterized by Preferred Term (PT)
----------------------------------------------------------------------------------------*/

data ae2;
    set ae1;

    length param $200 paramcd $40;

    param   = strip(aedecod);
    paramcd = strip(aebodsys) || "_" || strip(aedecod);
run;

/*----------------------------------------------------------------------------------------
  4. AVAL / AVALC
     AE is usually character-only (no numeric AVAL)
----------------------------------------------------------------------------------------*/

data ae3;
    set ae2;

    aval  = .;                     /* AE has no numeric value */
    avalc = strip(aeterm);         /* Character representation */
run;

/*----------------------------------------------------------------------------------------
  5. Baseline (AE rarely uses baseline; keep ABLFL from ADINT if present)
----------------------------------------------------------------------------------------*/

data ae4;
    set ae3;
    /* ABLFL already derived in ADINT if needed */
run;

/*----------------------------------------------------------------------------------------
  6. Traceability
----------------------------------------------------------------------------------------*/

data ae5;
    set ae4;
    src = "AE";
run;

/*----------------------------------------------------------------------------------------
  7. Final ADAE Dataset
----------------------------------------------------------------------------------------*/

data adam.adae;
    set ae5;

    keep studyid usubjid subjid siteid
         arm armcd saffl fasfl ittfl
         aebodsys aedecod aeterm
         param paramcd
         aval avalc
         adt adtm ady
         aendt aendtm
         avisit avisitn
         trtemfl
         aeser seriousfl aesev
         src;
run;

/*****************************************************************************************
 End of Program
******************************************************************************************/
