# Chapter 1 — ADaM Advanced  
**Metadata‑Driven Analysis Dataset Engineering**

This chapter builds a complete, senior‑level ADaM workflow that mirrors real clinical trial programming.  
You will design intermediate datasets, construct ADSL, build BDS datasets, apply metadata rules, and validate outputs using CORE.

---

## 🎯 Learning Objectives

By the end of this chapter, you will be able to:

- Build **ADaM intermediate datasets (ADINT)** to simplify complex derivations  
- Construct a complete **ADSL** dataset with population flags and treatment logic  
- Develop **BDS datasets** (ADLB, ADVS, ADEG, ADAE) using metadata‑driven rules  
- Implement **criteria variables** (ANL01FL, BASETYPE, ABLFL, CHG, SHIFT)  
- Create **metadata specifications** in CSV/JSON formats  
- Apply **TFL‑driven ADaM design** based on mock shells  
- Validate ADaM using **CORE** and custom rule checks  
- Demonstrate traceability from **RAW → SDTM → ADaM → TFL**

---

# 1.1 ADaM Philosophy at Senior Level

ADaM is not just datasets — it is a **metadata system** that ensures:

- Reproducibility  
- Traceability  
- Regulatory transparency  
- TFL alignment  
- Deterministic derivations  

A senior programmer must think in terms of:

- **Data flow**  
- **Metadata rules**  
- **Automation**  
- **Validation**  
- **Traceability**

This chapter emphasizes that mindset.

---

# 1.2 ADaM Workflow Overview

``` code
RAW → SDTM → ADaM Intermediate → ADSL → BDS/TTE → ARS/TFL
````

### Why Intermediate Datasets?

Real trials include:

- Multiple visits  
- Repeated measures  
- Derived endpoints  
- Multiple sources for the same variable  

Intermediate datasets allow you to:

- Normalize SDTM  
- Pre‑calculate reusable variables  
- Simplify downstream BDS logic  
- Improve transparency and reproducibility  

---

# 1.3 ADaM Intermediate Datasets (ADINT)

Intermediate datasets are the backbone of clean ADaM derivations.

### Example ADINT Datasets

- `ADINT_LB` — lab‑ready structure with baseline flags, visit windows  
- `ADINT_VS` — vital signs normalized across visits  
- `ADINT_EX` — exposure summaries  
- `ADINT_AE` — severity, seriousness, TEAE logic  

### Key Derivations to Demonstrate

- Visit windowing  
- Baseline identification  
- Treatment‑emergent logic  
- Imputation flags  
- Analysis visit (AVISIT, AVISITN)  
- Analysis dates (ADT, ADTM, ADY)  

### Suggested Folder Structure

````
01_adam_advanced/
│
├── adint/
│   ├── adint_lb.sas
│   ├── adint_vs.sas
│   ├── adint_ex.sas
│   └── adint_ae.sas

````

---

# 1.4 ADSL — Subject‑Level Analysis Dataset

ADSL is the foundation of all ADaM datasets.

### Core Components

- Treatment variables (TRTxxP, TRTxxA)  
- Demographics  
- Disposition flags  
- Study day calculations  
- Randomization and stratification factors  
- Population flags (SAFFL, EFFFL, ITTFL, PPFL)

### Advanced ADSL Topics

- Handling screen failures  
- Deriving treatment start/stop across multiple sources  
- Creating population flags using metadata rules  
- Linking ADSL to ARS metadata (future chapter)

---

# 1.5 BDS — Basic Data Structure (Advanced)

This is where senior‑level ADaM engineering becomes visible.

### Key Concepts

- PARAM/PARAMCD design  
- PARAM‑driven metadata  
- Analysis flags (ANL01FL, ANLzzFL)  
- Baseline and change‑from‑baseline logic  
- Visit alignment  
- Endpoint derivations  
- Handling multiple assessments per visit  
- Creating analysis‑ready variables for TFLs  

### Example BDS Datasets

- `ADLB` — labs  
- `ADVS` — vital signs  
- `ADEG` — ECG  
- `ADAE` — adverse events (BDS‑style for severity/occurrence analyses)

---

# 1.6 Criteria Variables (ANL01FL, BASETYPE, etc.)

These variables are essential for regulatory‑grade ADaM.

### Include Examples of:

- **ANL01FL** — primary analysis record  
- **ANL02FL** — sensitivity analysis  
- **BASETYPE** — baseline definition (screening, pre‑dose, last non‑missing)  
- **ABLFL** — baseline record flag  
- **CHG/PC/PD** — change and percent change  
- **WORSENFL** — worsening from baseline  
- **SHIFT** — shift tables (e.g., normal → high)

### Metadata‑Driven Approach

Store rules in:

```` Code 
metadata/bds_rules.csv
````

Example columns:

- PARAMCD  
- BASETYPE  
- BASE_WINDOW  
- ANALYSIS_RECORD_RULE  
- IMPUTATION_RULE  
- VISIT_ALIGNMENT_RULE  

---

# 1.7 Metadata‑Driven ADaM Specifications

This chapter introduces a reusable metadata system.

### Create Templates For:

- ADSL specifications  
- BDS specifications  
- TTE specifications  
- Controlled terminology  
- Derivation rules  
- Traceability mapping (SDTM → ADaM)

### Recommended Formats

- CSV  
- JSON  
- Excel (optional)

### Example Folder

````Code
metadata/
│
├── adsl_spec.csv
├── adlb_spec.csv
├── adae_spec.csv
├── derivations.json
└── codelists.csv
````

---

# 1.8 TFL‑Driven ADaM Design

A senior programmer must design ADaM **from the TFLs backward**.

### Demonstrate:

1. Reading mock shells  
2. Identifying required variables  
3. Back‑propagating requirements into ADaM  
4. Creating analysis‑specific flags  
5. Ensuring traceability to TFLs  

### Example Workflow

1. Start with mock table for labs  
2. Identify endpoints (e.g., ALT, AST, BILI)  
3. Define PARAM/PARAMCD  
4. Define baseline logic  
5. Define analysis flags  
6. Build ADLB  
7. Validate with CORE  
8. Generate TFL using ADLB  

---

# 1.9 Validation & Conformance

### Include:

- CORE rule execution  
- Custom rule writing  
- Cross‑dataset consistency checks  
- Traceability checks  
- Metadata vs dataset consistency checks  

---

# 1.10 Deliverables for Chapter 1

This chapter produces:

### ✔ ADSL dataset  
Complete, validated, metadata‑driven.

### ✔ Two or more BDS datasets  
Recommended: ADLB + ADVS.

### ✔ Intermediate datasets  
ADINT_LB, ADINT_VS, ADINT_AE.

### ✔ Metadata package  
Specs, derivation rules, codelists.

### ✔ Validation outputs  
CORE reports + custom checks.

### ✔ Documentation  
A README explaining the workflow.

---

# 1.11 Suggested Folder Structure

``` Code

01_adam_advanced/
│
├── README.md
│
├── adint/
│   ├── adint_lb.sas
│   ├── adint_vs.sas
│   ├── adint_ex.sas
│   ├── adint_ae.sas
│   └── README.md
│
├── adsl/
│   ├── adsl.sas
│   ├── adsl_metadata.csv
│   └── README.md
│
├── bds/
│   ├── adlb.sas
│   ├── advs.sas
│   ├── adeg.sas
│   ├── adae_bds.sas
│   ├── adlb_metadata.csv
│   ├── advs_metadata.csv
│   └── README.md
│
├── tte/
│   ├── adtte.sas
│   ├── adtte_metadata.csv
│   └── README.md
│
├── metadata/
│   ├── adsl_spec.csv
│   ├── adlb_spec.csv
│   ├── advs_spec.csv
│   ├── derivations.json
│   ├── codelists.csv
│   └── README.md
│
└── validation/
    ├── core_run_config.json
    ├── custom_rules.sas
    ├── validation_log.txt
    └── README.md

```

---

# ✔ End of Chapter 1  
This chapter establishes the foundation for advanced ADaM engineering and prepares you for SDTM, Dataset‑JSON, CORE, BCs, and ARS in later chapters.


