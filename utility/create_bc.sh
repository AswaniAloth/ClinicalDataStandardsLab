#!/bin/bash

# Create base directory
mkdir -p 05_biomedical_concepts

# Top-level README
cat << 'EOF' > 05_biomedical_concepts/README.md
# Chapter 4 — Biomedical Concepts & Dataset Specializations
This chapter contains Biomedical Concept models, Dataset Specializations, terminology curation, and metadata lineage.
EOF

###############################################
# BC MODELS
###############################################
mkdir -p 05_biomedical_concepts/bc_models

cat << 'EOF' > 05_biomedical_concepts/bc_models/README.md
# Biomedical Concept Models
Contains JSON-based Biomedical Concepts (BCs) defining clinical concepts, properties, terminology bindings, and constraints.
EOF

# Example BC model
cat << 'EOF' > 05_biomedical_concepts/bc_models/hemoglobin_bc.json
{
  "conceptId": "BC.Hemoglobin",
  "name": "Hemoglobin",
  "properties": [
    {"name": "Value", "datatype": "float"},
    {"name": "Unit", "datatype": "string"},
    {"name": "Specimen", "datatype": "string"},
    {"name": "Method", "datatype": "string"}
  ],
  "terminology": {
    "LBTESTCD": "HGB",
    "LBTEST": "Hemoglobin"
  }
}
EOF

###############################################
# DATASET SPECIALIZATIONS
###############################################
mkdir -p 05_biomedical_concepts/dataset_specializations

cat << 'EOF' > 05_biomedical_concepts/dataset_specializations/README.md
# Dataset Specializations
Contains SDTM-ready Dataset Specializations derived from Biomedical Concepts.
EOF

# Example Dataset Specialization
cat << 'EOF' > 05_biomedical_concepts/dataset_specializations/hemoglobin_specialization.json
{
  "specializationId": "DS.Hemoglobin.LB",
  "bcReference": "BC.Hemoglobin",
  "domain": "LB",
  "variableBindings": {
    "LBTESTCD": "HGB",
    "LBTEST": "Hemoglobin",
    "LBORRES": "Value",
    "LBORRESU": "Unit",
    "LBSPEC": "Specimen",
    "LBMETHOD": "Method"
  }
}
EOF

###############################################
# CURATION
###############################################
mkdir -p 05_biomedical_concepts/curation

cat << 'EOF' > 05_biomedical_concepts/curation/README.md
# Curation
Contains terminology mappings, lineage documentation, and BC-to-SDTM/ADaM curation notes.
EOF

# Terminology mapping template
cat << 'EOF' > 05_biomedical_concepts/curation/terminology_mapping.csv
BC_Property,SDTM_Variable,Controlled_Terms
Value,LBORRES,
Unit,LBORRESU,mg/dL; g/dL; mmol/L
Specimen,LBSPEC,Blood; Serum; Plasma
Method,LBMETHOD,Automated; Manual
EOF

# Lineage template
cat << 'EOF' > 05_biomedical_concepts/curation/lineage.md
# BC → Dataset Specialization → SDTM → ADaM Lineage

## Biomedical Concept
- Hemoglobin (BC.Hemoglobin)

## Dataset Specialization
- DS.Hemoglobin.LB

## SDTM Variables
- LBTESTCD = HGB
- LBORRES = Value
- LBORRESU = Unit
- LBSPEC = Specimen
- LBMETHOD = Method

## ADaM Mapping
- PARAMCD = HGB
- AVAL = LBORRES
- AVALU = LBORRESU
EOF

###############################################
# AUTOMATION SCRIPTS (PLACEHOLDERS)
###############################################
mkdir -p 05_biomedical_concepts/scripts

cat << 'EOF' > 05_biomedical_concepts/scripts/README.md
# Automation Scripts
Contains helper scripts for generating BCs, Dataset Specializations, and metadata.
EOF

touch 05_biomedical_concepts/scripts/generate_bc_template.py
touch 05_biomedical_concepts/scripts/generate_specialization_template.py

###############################################
# COMPLETION MESSAGE
###############################################
echo "Biomedical Concepts folder structure created successfully!"
