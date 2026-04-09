/*****************************************************************************************
 Program:        adint_ex.sas
 Purpose:        Create Intermediate ADaM Exposure Dataset (ADINT_EX)
                 Based on SDTM EX from PHUSE Test Data Factory (TDF_SDTM)

 Inputs:         ex.xpt      (Exposure)
                 dm.xpt      (Demographics)

 Output:         adint_ex.sas7bdat

 Key Derivations:
    - TRTSDT / TRTSDTM (first dose)
    - TRTEDT / TRTEDTM (last dose)
    - ADT / ADTM per EX record
    - ADY (study day relative to TRTSDT)
    - Cumulative dose (per subject, per treatment)
    - Simple exposure flags
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load SDTM domains
----------------------------------------------------------------------------------------*/

libname sdtm_ex xport "path/TDF_SDTM/ex.xpt";
libname sdtm_dm xport "path/TDF_SDTM/dm.xpt";

data ex_raw;
    set sdtm_ex.ex;
run;

data dm;
    set sdtm_dm.dm;
run;

/*----------------------------------------------------------------------------------------
  2. Convert EX dates/times → ADT / ADTM
----------------------------------------------------------------------------------------*/

data ex1;
    set ex_raw;

    /* Start date/time */
    if not missing(exstdtc) then adt = input(substr(exstdtc,1,10), yymmdd10.);
    if length(exstdtc) >= 16 then adtm = input(exstdtc, e8601dt.);

    /* End date/time */
    if not missing(exendtc) then aenddt = input(substr(exendtc,1,10), yymmdd10.);
    if length(exendtc) >= 16 then aendtm = input(exendtc, e8601dt.);

    format adt aenddt yymmdd10. adtm aendtm e8601dt.;
run;

/*----------------------------------------------------------------------------------------
  3. Derive TRTSDT / TRTSDTM and TRTEDT / TRTEDTM per subject
----------------------------------------------------------------------------------------*/

proc sql;
    create table trt_bounds as
    select usubjid,
           min(adt)    as trtsdt  format=yymmdd10.,
           min(adtm)   as trtsdtm format=e8601dt.,
           max(coalesce(aenddt, adt))  as trtedt  format=yymmdd10.,
           max(coalesce(aendtm, adtm)) as trtedtm format=e8601dt.
    from ex1
    group by usubjid;
quit;

/*----------------------------------------------------------------------------------------
  4. Merge with DM and TRT bounds
----------------------------------------------------------------------------------------*/

proc sql;
    create table ex2 as
    select a.*, 
           b.trtsdt, b.trtsdtm, b.trtedt, b.trtedtm,
           c.arm, c.sex, c.age
    from ex1 as a
    left join trt_bounds as b on a.usubjid = b.usubjid
    left join dm          as c on a.usubjid = c.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  5. Derive Study Day (ADY) for each exposure record
----------------------------------------------------------------------------------------*/

data ex3;
    set ex2;
    if not missing(adt) and not missing(trtsdt) then
        ady = adt - trtsdt + (adt >= trtsdt);
run;

/*----------------------------------------------------------------------------------------
  6. Cumulative Dose per Subject / Treatment
----------------------------------------------------------------------------------------*/

proc sort data=ex3; 
    by usubjid extrt adt adtm; 
run;

data ex4;
    set ex3;
    by usubjid extrt;

    length doseu_std $20;
    doseu_std = upcase(exdosu);

    /* Example: assume all doses are in same unit per treatment */
    if first.extrt then cumdose = 0;
    cumdose + exdose;

    retain cumdose;
run;

/*----------------------------------------------------------------------------------------
  7. Exposure Flags
----------------------------------------------------------------------------------------*/

data ex5;
    set ex4;

    /* On-treatment flag: within TRTSDT–TRTEDT */
    if not missing(adt) and not missing(trtsdt) and not missing(trtedt) then do;
        if trtsdt <= adt <= trtedt then ontrtfl = "Y";
        else ontrtfl = "N";
    end;

    /* First dose flag */
    if adt = trtsdt and adtm = trtsdtm then firstdosefl = "Y";
    else firstdosefl = "";

    /* Last dose flag */
    if coalesce(aenddt, adt) = trtedt and coalesce(aendtm, adtm) = trtedtm then lastdosefl = "Y";
    else lastdosefl = "";
run;

/*----------------------------------------------------------------------------------------
  8. Final ADINT_EX Dataset
----------------------------------------------------------------------------------------*/

data adint_ex;
    set ex5;

    keep usubjid exseq extrt exdose exdosu doseu_std
         adt adtm aenddt aendtm ady
         trtsdt trtsdtm trtedt trtedtm
         cumdose ontrtfl firstdosefl lastdosefl
         arm sex age;
run;

proc datasets lib=work nolist;
    delete ex:;
quit;

/*****************************************************************************************
 End of Program
*****************************************************************************************/
