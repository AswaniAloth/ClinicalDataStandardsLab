/*****************************************************************************************
 Program:        adsl.sas
 Purpose:        Create Subject-Level Analysis Dataset (ADSL)
                 Based on SDTM DM + EX from PHUSE Test Data Factory (TDF_SDTM)
                 Aligned with your ADINT_* timing (TRTSDT/TRTEDT, ADY anchors)

 Inputs:         dm.xpt      (Demographics)
                 ex.xpt      (Exposure – for treatment dates)

 Output:         adsl.sas7bdat

 Key Derivations:
    - TRTSDT / TRTSDTM (first dose)
    - TRTEDT / TRTEDTM (last dose)
    - Study day anchors (for downstream ADY)
    - Population flags (simple SAFFL, FASFL, ITTFL)
******************************************************************************************/

/*----------------------------------------------------------------------------------------
  1. Load SDTM domains
----------------------------------------------------------------------------------------*/

libname sdtm_dm xport "path/TDF_SDTM/dm.xpt";
libname sdtm_ex xport "path/TDF_SDTM/ex.xpt";

data dm;
    set sdtm_dm.dm;
run;

data ex;
    set sdtm_ex.ex;
run;

/*----------------------------------------------------------------------------------------
  2. Derive treatment bounds from EX
----------------------------------------------------------------------------------------*/

data ex1;
    set ex;

    /* Start date/time */
    if not missing(exstdtc) then exstdt = input(substr(exstdtc,1,10), yymmdd10.);
    if length(exstdtc) >= 16 then exstdtm = input(exstdtc, e8601dt.);

    /* End date/time */
    if not missing(exendtc) then exendt = input(substr(exendtc,1,10), yymmdd10.);
    if length(exendtc) >= 16 then exendtm = input(exendtc, e8601dt.);

    format exstdt exendt yymmdd10. exstdtm exendtm e8601dt.;
run;

proc sql;
    create table trt_bounds as
    select usubjid,
           min(exstdt)                         as trtsdt  format=yymmdd10.,
           min(exstdtm)                        as trtsdtm format=e8601dt.,
           max(coalesce(exendt, exstdt))       as trtedt  format=yymmdd10.,
           max(coalesce(exendtm, exstdtm))     as trtedtm format=e8601dt.
    from ex1
    group by usubjid;
quit;

/*----------------------------------------------------------------------------------------
  3. Merge DM with treatment bounds
----------------------------------------------------------------------------------------*/

proc sql;
    create table adsl_pre as
    select a.*,
           b.trtsdt, b.trtsdtm, b.trtedt, b.trtedtm
    from dm as a
    left join trt_bounds as b
      on a.usubjid = b.usubjid;
quit;

/*----------------------------------------------------------------------------------------
  4. Population flags (simple, illustrative)
----------------------------------------------------------------------------------------*/

data adsl;
    set adsl_pre;

    length saffl fasfl ittfl $1;

    /* Example: everyone with non-missing TRTSDT is in all populations */
    if not missing(trtsdt) then do;
        saffl = "Y";
        fasfl = "Y";
        ittfl = "Y";
    end;
    else do;
        saffl = "N";
        fasfl = "N";
        ittfl = "N";
    end;

    /* Keep core ADSL variables (extend as needed) */
    keep studyid usubjid subjid siteid
         arm armcd
         sex age ageu race ethnic
         country
         trtsdt trtsdtm trtedt trtedtm
         saffl fasfl ittfl;
run;

proc datasets lib=work nolist;
    delete dm ex: trt_bounds adsl_pre;
quit;

/*****************************************************************************************
 End of Program
*****************************************************************************************/
