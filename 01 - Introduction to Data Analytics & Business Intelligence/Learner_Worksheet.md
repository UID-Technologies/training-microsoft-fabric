# Module 1 — Learner worksheet

**How to use this file**

1. Open the lab you are taking (Lab 01, 02, or 03).
2. Fill in **only the section for that lab** below as you complete each step.
3. Compare numbers to the **Expected** values in the lab; fix setup before submitting if they differ.
4. Save a copy (or export to PDF) and submit per your instructor’s directions.

---

**Your details**

| Field | Your entry |
|-------|------------|
| Name | |
| Date | |
| Lab number (01 / 02 / 03) | |
| Fabric workspace name | |
| Lakehouse name | |

---

## Lab 01 — Discover CRM business data

### Data dictionary

| Dataset | Source/format (structured / semi-structured / unstructured) | Row grain | Key field | Example dimensions | Example measures |
|---------|--------------------------------------------------------------|-----------|-----------|--------------------|------------------|
| Customers | | | | | |
| Products | | | | | |
| Sales | | | | | |
| Activities (JSON file) | | | | | |
| Customer note (TXT file) | | | | | |

### Relationships (write cardinality)

1. Customers → Sales:  
2. Products → Sales:  

### SQL verification (from Step 4)

| Metric | Your result | Expected (check lab) |
|--------|-------------|----------------------|
| Sales line count | | 6 |
| Total units | | 10 |
| Total revenue | | 70000.00 |

### Business questions (write your own three)

| # | Business question | Fields / tables needed |
|---|-------------------|-------------------------|
| 1 | | |
| 2 | | |
| 3 | | |

**Why six sales lines are not six orders:**

**One operational task vs one analytical task:**

| Type | Example from this lab |
|------|------------------------|
| Operational | |
| Analytical | |

---

## Lab 02 — Investigate CRM data quality

### Issue register (minimum five rows)

| Dataset / record | Evidence (IDs, counts, values) | Quality dimension | Business impact | Proposed action | Owner |
|------------------|--------------------------------|-------------------|-----------------|-----------------|-------|
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |
| | | | | | |

### Join totals (Step 7)

| Metric | Your result | Expected (check lab) |
|--------|-------------|----------------------|
| Raw revenue (sales only) | | 40000 |
| LEFT JOIN revenue | | 55000 |
| INNER JOIN revenue | | 50000 |

**Why the three revenue numbers differ:**

**One decision that needs business approval (not IT alone):**

---

## Lab 03 — Calculate CRM KPIs and recommend an action

### KPI scorecard

| KPI / metric | Your definition (one line) | Your result | Short interpretation |
|--------------|----------------------------|-------------|----------------------|
| January revenue | | | |
| Purchasing customers | | | |
| January revenue target | | | |
| Target achievement % | | | |
| Variance (actual − target) | | | |
| Open pipeline | | | |
| Snapshot win rate | | | |
| Average won deal value | | | |

### Reconciliation

**Regional revenue rows sum to January total:** Yes / No — my total: ______

**Product revenue rows sum to January total:** Yes / No — my total: ______

### Recommendation (exactly three sentences: fact → insight → action)

1.  
2.  
3.  

### Limitations (two things the data cannot prove)

1.  
2.  

### Architecture (one short paragraph)

Files → Tables → SQL → scorecard — your words:

---

## Lab completion sign-off

| Step | Done |
|------|:----:|
| Setup A–E finished and checkpoints passed | [ ] |
| All exercise steps attempted | [ ] |
| Results match Expected (or I noted discrepancies) | [ ] |
| Answers saved / submitted | [ ] |
| My lab lakehouse deleted (cleanup) | [ ] |

**Instructor feedback:**
