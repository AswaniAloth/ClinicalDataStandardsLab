#!/bin/bash

# Create base directory
mkdir -p 01_adam_advanced

# Create top-level README
cat << 'EOF' > 01_adam_advanced/README.md
# Chapter 1 — ADaM Advanced
This chapter contains intermediate datasets, ADSL, BDS datasets, metadata, and validation outputs.
EOF

###############################################
# ADINT
###############################################
mkdir -p 01_adam_advanced/adint

cat << 'EOF' > 01_adam_advanced/adint/README.md
# ADINT — Intermediate ADaM Datasets
Contains intermediate datasets used to simplify downstream ADaM derivations.
EOF

touch 01_adam_advanced/adint/adint_lb.sas
touch 01_adam_advanced/adint/adint_vs.sas
touch 01_adam_advanced/adint/adint_ex.sas
touch 01_adam_advanced/adint/adint_ae.sas

###############################################
# ADSL
###############################################
mkdir -p 01_adam_advanced/adsl

cat << 'EOF' > 01_adam_advanced/adsl/README.md
# ADSL — Subject-Level Analysis Dataset
Contains ADSL derivation program and metadata.
EOF

touch 01_adam_advanced/adsl/adsl.sas

cat << 'EOF' > 01_adam_advanced/adsl/adsl_metadata.csv
Variable,Type,Length,Description,Derivation
USUBJID,Char,20,Unique Subject Identifier,From DM
TRT01P,Char,40,Planned Treatment,From TS/DM
TRT01A,Char,40,Actual Treatment,From EX
SAFFL,Char,1,Safety Population Flag,Metadata rule
EOF

###############################################
# BDS
###############################################
mkdir -p 01_adam_advanced/bds

cat << 'EOF' > 01_adam_advanced/bds/README.md
# BDS — Basic Data Structure Datasets
Contains ADLB, ADVS, ADEG, ADAE (BDS-style), and metadata.
EOF

touch 01_adam_advanced/bds/adlb.sas
touch 01_adam_advanced/bds/advs.sas
touch 01_adam_advanced/bds/adeg.sas
touch 01_adam_advanced/bds/adae_bds.sas

cat << 'EOF' > 01_adam_advanced/bds/adlb_metadata.csv
PARAMCD,PARAM,Unit,Derivation
ALT,Alanine Aminotransferase,U/L,From LB
AST,Aspartate Aminotransferase,U/L,From LB
BILI,Bilirubin,mg/dL,From LB
EOF

cat << 'EOF' > 01_adam_advanced/bds/advs_metadata.csv
PARAMCD,PARAM,Unit,Derivation
SYSBP,Systolic Blood Pressure,mmHg,From VS
DIABP,Diastolic Blood Pressure,mmHg,From VS
PULSE,Pulse Rate,bpm,From VS
EOF

###############################################
# TTE
###############################################
mkdir -p 01_adam_advanced/tte

cat << 'EOF' > 01_adam_advanced/tte/README.md
# ADTTE — Time-to-Event Dataset
Contains ADTTE derivation program and metadata.
EOF

touch 01_adam_advanced/tte/adtte.sas

cat << 'EOF' > 01_adam_advanced/tte/adtte_metadata.csv
Variable,Description
PARAMCD,Event Parameter Code
EVNTFL,Event Flag
CNSR,Censoring Indicator
AVAL,Time-to-event value
EOF

###############################################
# METADATA
###############################################
mkdir -p 01_adam_advanced/metadata

cat << 'EOF' > 01_adam_advanced/metadata/README.md
# Metadata for ADaM Datasets
Includes ADaM specifications, derivation rules, and controlled terminology.
EOF

cat << 'EOF' > 01_adam_advanced/metadata/adsl_spec.csv
Variable,Type,Description
USUBJID,Char,Unique Subject Identifier
TRT01A,Char,Actual Treatment
SAFFL,Char,Safety Population Flag
EOF

cat << 'EOF' > 01_adam_advanced/metadata/adlb_spec.csv
Variable,Type,Description
USUBJID,Char,Subject Identifier
PARAMCD,Char,Parameter Code
AVAL,Num,Analysis Value
EOF

cat << 'EOF' > 01_adam_advanced/metadata/advs_spec.csv
Variable,Type,Description
USUBJID,Char,Subject Identifier
PARAMCD,Char,Parameter Code
AVAL,Num,Analysis Value
EOF

cat << 'EOF' > 01_adam_advanced/metadata/derivations.json
{
  "baseline_rule": "Last non-missing value prior to first dose",
  "analysis_flag_rule": "Record used for primary analysis",
  "visit_alignment": "Map SDTM visits to analysis visits"
}
EOF

cat << 'EOF' > 01_adam_advanced/metadata/codelists.csv
Codelist,Value,Description
SEX,M,Male
SEX,F,Female
RACE,WHITE,White
EOF

###############################################
# VALIDATION
###############################################
mkdir -p 01_adam_advanced/validation

cat << 'EOF' > 01_adam_advanced/validation/README.md
# Validation Outputs
Contains CORE configuration, custom validation rules, and logs.
EOF

cat << 'EOF' > 01_adam_advanced/validation/core_run_config.json
{
  "engine": "CORE",
  "datasets": ["ADSL", "ADLB", "ADVS"],
  "ruleset": "adam"
}
EOF

touch 01_adam_advanced/validation/custom_rules.sas

cat << 'EOF' > 01_adam_advanced/validation/validation_log.txt
Validation log placeholder.
CORE and custom rule outputs will be stored here.
EOF

echo "All folders and files for Chapter 1 created successfully!"

