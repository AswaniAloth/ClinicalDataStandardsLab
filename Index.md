# 📘 CDISC

A structured, realistic roadmap to  ADaM Advanced, SDTM Advanced, Dataset‑JSON, CORE, Biomedical Concepts, and ARS.

---

## 🗓️ Chapter 1: ADaM Advanced Foundations
### **Topics**
- Intermediate datasets  
- Complex data flows  
- Traceability  
- BDS criteria variables  
- Commonly misused variables  
- Metadata creation  

### **Hands‑on Tasks**
- Select one study (public SDTM or own mock data)  
- Create:
  - `ADSL`
  - One time‑to‑event or efficacy dataset (e.g., `ADTTE`, `ADEFF`)
  - One BDS dataset with criteria variables  

### **Tools**
- SAS  
- ADaM IG  
- Define‑XML examples  

### **Outcome**
Ability to design ADaM datasets directly from TFL shells.

---

## 🗓️ Chapter 2: SDTM Advanced
### **Topics**
- Relative timing variables  
- EX, EC, biospecimen, lab‑like structures  
- Collected summary results  
- Manual vs automated conformance  
- Metadata Submission Guidelines  

### **Hands‑on Tasks**
- Map raw → SDTM for:
  - `EX`, `EC`, `LB`, `VS`
- Add timing variables (`EPOCH`, `TAETORD`, etc.)
- Validate manually + with any free validator  

### **Tools**
- SAS  
- SDTM IG  
- CORE rules (read only for now)  

### **Outcome**
Confidence in building complex SDTM domains and understanding conformance logic.

---

## 🗓️ Chapter 3: Dataset‑JSON v1.1
### **Topics**
- JSON structure  
- Dataset‑JSON specification  
- NDJSON  
- Conversion workflows  
- Error diagnosis  

### **Hands‑on Tasks**
- Convert 2–3 SAS datasets → Dataset‑JSON  
- Validate JSON  
- Compare SAS vs JSON metadata  

### **Tools**
- SAS OnDemand  
- Python (Google Colab)  
- JSON viewer  

### **Outcome**
Ability to work with the future transport format for regulatory submissions.

---

## 🗓️ Chapter 4: Biomedical Concepts (BCs) & Dataset Specializations
### **Topics**
- BC modeling  
- Dataset Specialization structure  
- Curation principles  
- 360i ecosystem  

### **Hands‑on Tasks**
- Pick 2 concepts (e.g., Blood Pressure, AE Severity)  
- Build BCs + Dataset Specializations  
- Compare with CDISC examples  

### **Tools**
- CDISC Library  
- Excel templates  

### **Outcome**
Understanding of semantic, metadata‑driven CDISC standards.

---

## 🗓️ Chapter 5: CORE (CDISC Open Rules Engine)
### **Topics**
- Rule Editor  
- Rule Engine  
- Writing conformance rules  
- Understanding rule logic  
- Validating SDTM/ADaM packages  

### **Hands‑on Tasks**
- Install CORE  
- Write 5–10 rules (simple → intermediate)  
- Validate your SDTM datasets  
- Compare CORE output vs manual checks  

### **Tools**
- CORE  
- SDTM datasets from Week 3–4  

### **Outcome**
Ability to write and execute conformance rules — a rare, high‑value skill.

---

## 🗓️ Chapter 6: ARS (Analysis Results Standard)
### **Topics**
- ARS v1.0 model  
- ARM support  
- FDA Standard Safety Tables  
- Metadata‑driven automation  
- TFL Designer concepts  

### **Hands‑on Tasks**
- Pick 3 TFLs (AE summary, lab shift, vital signs)  
- Create ARS metadata  
- Link ARS → ADaM datasets  
- Simulate ARM generation  

### **Tools**
- Excel  
- Python or SAS  
- ARS documentation  

### **Outcome**
Understanding of how analysis metadata will automate TFL generation.

---

## 🗓️ Chapter 7: Integration Project
### **Goal**
Combine everything into a mini‑submission package.

### **Hands‑on Tasks**
- Build SDTM for 3–4 domains  
- Build ADaM for 2–3 analysis datasets  
- Validate with CORE  
- Create Dataset‑JSON  
- Create ARS metadata  
- Build BCs for 2 concepts  

### **Outcome**
A complete end‑to‑end CDISC package

---

## 🗓️ Chapter 8: Portfolio + Career Preparation
### **Tasks**
- Document your project  
- Create a GitHub or private portfolio  
- Write a “CDISC Mastery” section for your CV  
- Prepare interview answers for:
  - ADaM design  
  - SDTM timing  
  - CORE rules  
  - ARS metadata  
  - Dataset‑JSON  

### **Outcome**
The whole project is a reference for senior/principal statistical programmers.

---

