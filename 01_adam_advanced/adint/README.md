# ADINT — Intermediate ADaM Datasets

Intermediate ADaM datasets (ADINT) serve as the **bridge** between SDTM and final ADaM structures.  
They simplify complex derivations, centralize reusable logic, and enforce traceability across the analysis pipeline.

This folder contains all intermediate datasets used in Chapter 1 of the Clinical Data Standards Lab.

---
Reference to the Example : https://www.cdisc.org/system/files/members/standard/foundational/ADaM%20Oncology%20Examples%20v1.0_Provisional.pdf


## 🎯 Purpose of ADINT Datasets

ADINT datasets are designed to:

- Normalize SDTM structures before analysis  
- Apply visit windowing and timing rules  
- Pre‑compute baseline and analysis flags  
- Consolidate multi‑source variables (e.g., treatment dates, severity, exposure)  
- Reduce complexity in downstream ADSL and BDS programs  
- Improve transparency and reproducibility of derivations  

They are **not** part of the final submission package, but they are essential for clean, maintainable ADaM programming.

---

## 📁 Files in This Folder

### **1. `adint_lb.sas`**
Intermediate dataset for laboratory data.

Includes:
- Visit windowing  
- Baseline identification  
- Imputation flags  
- Harmonized units (if applicable)  
- Pre‑derived AVISIT/AVISITN  
- Pre‑derived ADT/ADTM/ADY  

---

### **2. `adint_vs.sas`**
Intermediate dataset for vital signs.

Includes:
- Normalization of VS records  
- Handling multiple measurements per visit  
- Baseline logic  
- Analysis visit alignment  
- Timing variables  

---

### **3. `adint_ex.sas`**
Intermediate dataset for exposure.

Includes:
- Treatment start/stop derivation  
- Cumulative dose  
- Duration of exposure  
- Dose interruptions and gaps  
- Traceability to EX and DS  

---

### **4. `adint_ae.sas`**
Intermediate dataset for adverse events.

Includes:
- Treatment‑emergent flag (TEAE)  
- Severity and seriousness harmonization  
- Onset/offset imputation logic  
- Relationship to treatment  
- Pre‑derived analysis dates  

---

## 🧩 How ADINT Fits Into the Workflow

````
RAW → SDTM → ADINT → ADSL → BDS → TTE → ARS/TFL
````

ADINT datasets ensure that:

- ADSL remains clean and focused  
- BDS datasets inherit consistent logic  
- TFLs are reproducible and traceable  
- Metadata rules are applied uniformly  

---

## 📝 Notes for Contributors

- ADINT datasets should **never** contain analysis‑specific variables (e.g., CHG, PCHG).  
- All derivations must be documented in the metadata folder (`metadata/derivations.json`).  
- Each ADINT program should include:
  - Source SDTM domains  
  - Derivation logic  
  - Traceability comments  
  - Output dataset structure  

---

## ✔ Status

This folder contains **placeholder programs** that will be completed during Chapter 1 exercises.

````
adint_lb.sas
adint_vs.sas
adint_ex.sas
adint_ae.sas
````

---

If you want, I can also generate:

- A fully annotated **SAS template** for each ADINT program  
- A **Python (pandas)** version of the ADINT pipeline  
- A **metadata‑driven ADINT framework** that reads rules from JSON  

Just tell me which direction you want to take next.
