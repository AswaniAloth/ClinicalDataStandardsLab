#!/bin/bash

# ============================================================
# SDTM PIPELINE — Folder & File Structure Generator
# Mirrors the structure used in clinical-data-standards-lab/
# ============================================================

# Create base directory
mkdir -p 01_sdtm

# ------------------------------------------------------------
# Top-level README
# ------------------------------------------------------------
cat << 'EOF' > 01_sdtm/README.md
# Chapter 1 — SDTM Pipeline
This chapter contains SDTM mapping programs, SDTM domains, timing logic, and validation outputs.
EOF

# ------------------------------------------------------------
# MAPPING
# ------------------------------------------------------------
mkdir -p 01_sdtm/mapping

cat << 'EOF' > 01_sdtm/mapping/README.md
# SDTM Mapping Programs
Contains SDTM mapping scripts for each domain, including variable-level and value-level transformations.
EOF

# Example placeholder mapping programs
touch 01_sdtm/mapping/dm_mapping.sas
touch 01_sdtm/mapping/vs_mapping.sas
touch 01_sdtm/mapping/lb_mapping.sas
touch 01_sdtm/mapping/ex_mapping.sas

# ------------------------------------------------------------
# DOMAINS
# ------------------------------------------------------------
mkdir -p 01_sdtm/domains

cat << 'EOF' > 01_sdtm/domains/README.md
# SDTM Domains
Contains SDTM-compliant datasets (XPT or SAS7BDAT) and domain-level specifications.
EOF

# Example placeholder domain files
touch 01_sdtm/domains/dm.sas
touch 01_sdtm/domains/vs.sas
touch 01_sdtm/domains/lb.sas
touch 01_sdtm/domains/ex.sas

# ------------------------------------------------------------
# TIMING
# ------------------------------------------------------------
mkdir -p 01_sdtm/timing

cat << 'EOF' > 01_sdtm/timing/README.md
# SDTM Timing Logic
Contains timing algorithms, reference start dates, and visit windowing rules.
EOF

touch 01_sdtm/timing/timing_rules.sas
touch 01_sdtm/timing/visit_windowing.sas

# ------------------------------------------------------------
# VALIDATION
# ------------------------------------------------------------
mkdir -p 01_sdtm/validation

cat << 'EOF' > 01_sdtm/validation/README.md
# SDTM Validation Outputs
Contains CORE configuration, Pinnacle21-style checks, and validation logs.
EOF

cat << 'EOF' > 01_sdtm/validation/core_run_config.json
{
  "engine": "CORE",
  "datasets": ["DM", "VS", "LB", "EX"],
  "ruleset": "sdtm"
}
EOF

touch 01_sdtm/validation/custom_rules.sas

cat << 'EOF' > 01_sdtm/validation/validation_log.txt
Validation log placeholder.
CORE and custom rule outputs will be stored here.
EOF

echo "All folders and files for SDTM Pipeline created successfully!"
