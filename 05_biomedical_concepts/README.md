# TODO
- [] Select BCs relevant to LB, VS, EX
- 
- [] Map BCs to SDTM variables
This step connects semantic intent → SDTM structure.
One SDTM domain
One parameter concept (--TESTCD / --TEST, PARAMCD / PARAM)

Example: LB Mapping
BC: Hemoglobin Measurement

BC Element     SDTM Variable
Analyte        LBTESTCD = HGB
Test Name      LBTEST = Hemoglobin
Result         LBORRES / LBSTRESN
Unit           LBORRESU / LBSTRESU
Specimen       LBSPEC = BLOOD

- [] Generate BC‑driven mapping rules
- [] Integrate BCs into metadata dictionary

# Chapter 4 — Biomedical Concepts & Dataset Specializations
*A metadata‑driven foundation for modern CDISC standards*

Biomedical Concepts (BCs) and Dataset Specializations (DSpecs) represent the semantic layer of CDISC’s next‑generation metadata architecture.  
This chapter establishes the conceptual backbone for the entire Clinical Data Standards Lab by defining clinical meaning before it is transformed into SDTM, ADaM, Dataset‑JSON, CORE, or ARS structures.

---

## 🎯 Purpose of This Chapter

This chapter focuses on:

- Defining **Biomedical Concepts (BCs)** using JSON metadata  
- Creating **Dataset Specializations (DSpecs)** that translate BCs into SDTM‑ready structures  
- Establishing **terminology bindings** and controlled vocabularies  
- Documenting **metadata lineage** from BC → DSpec → SDTM → ADaM  
- Preparing metadata for downstream automation (CORE, Dataset‑JSON, ARS)

This is the first chapter that is **fully metadata‑driven**, not dataset‑driven.

---

## 🧬 What Are Biomedical Concepts?

A **Biomedical Concept (BC)** is a structured definition of a clinical idea — such as Hemoglobin, Systolic Blood Pressure, or Pregnancy Test.

Each BC defines:

- Concept name  
- Properties (value, unit, method, specimen, etc.)  
- Data types  
- Terminology bindings  
- Constraints  
- Expected structure  

BCs are **independent of SDTM or ADaM**.  
They represent the *pure clinical meaning* of a measurement or observation.

---

## 📦 What Are Dataset Specializations?

A **Dataset Specialization (DSpec)** is the SDTM‑ready version of a BC.

It defines:

- SDTM domain (e.g., LB, VS, EG)  
- Variable bindings (e.g., LBORRES = Value)  
- Controlled terminology  
- Constraints  
- Expected structure  

Dataset Specializations are the bridge between **clinical meaning** and **regulatory datasets**.

---

## 🗂 Folder Structure for This Chapter

```Code
05_biomedical_concepts/
│
├── bc_models/
│   ├── hemoglobin_bc.json
│   ├── systolic_bp_bc.json
│   └── README.md
│
├── dataset_specializations/
│   ├── hemoglobin_specialization.json
│   ├── systolic_bp_specialization.json
│   └── README.md
│
├── curation/
│   ├── terminology_mapping.csv
│   ├── lineage.md
│   └── README.md
│
└── scripts/
├── generate_bc_template.py
├── generate_specialization_template.py
└── README.md
```

This structure mirrors CDISC’s metadata architecture and supports automation.

---

## 🧪 Example Biomedical Concept (Hemoglobin)

```json
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
```

## 🧩 Example Dataset Specialization (Hemoglobin → LB)
```json
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
```
## 🔗 Metadata Lineage
- This chapter establishes the lineage:
```Script
Biomedical Concept
        ↓
Dataset Specialization
        ↓
SDTM Variable Metadata
        ↓
ADaM Parameter Metadata
        ↓
ARS Analysis Results

```
- Lineage is documented in:
- 05_biomedical_concepts/curation/lineage.md
## 📘 Learning Outcomes
- After completing this chapter, we will be able to:
  - Model clinical concepts using BCs
  - Translate BCs into SDTM‑ready Dataset Specializations
  - Bind terminology and controlled vocabularies
  - Generate metadata for SDTM and ADaM
  - Understand metadata lineage across CDISC standards
  - Prepare metadata for automation (CORE, JSON, ARS)

This chapter forms the semantic foundation for all downstream chapters.
