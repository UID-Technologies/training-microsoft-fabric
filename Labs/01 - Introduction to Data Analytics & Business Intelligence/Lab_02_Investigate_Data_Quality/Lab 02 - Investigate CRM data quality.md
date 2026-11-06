# Lab 02 — Investigate CRM data quality

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Use **`Lab_02_Investigate_Data_Quality/data/`** only. [Learner_Worksheet.md](../Learner_Worksheet.md) **Lab 02**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 45–60 minutes |
| Depends on Lab 01? | **No** — new workspace and new files |
| Sample data | [`Lab_02_Investigate_Data_Quality/data/`](./data/) |

## Description

Investigate intentionally flawed CRM extracts before reporting. You profile duplicates, missing values, inconsistent labels, orphan keys, and suspicious amounts—then show how poor quality inflates join totals. You record remediation actions **without** changing source data in Fabric.

## Use case

Regional revenue on a draft report looks wrong. Leadership asks whether the **data** or the **chart** is at fault. You deliver an evidence-based issue register and prove why join totals can still be wrong.

## Scenario

You validate customer and sales exports for a regional dashboard. The files look fine at first glance. Your job: list what is wrong, why it matters, who should fix it, and demonstrate the “join trap” with SQL.

## Learning objectives

- Profile row counts, distinct keys, and raw revenue  
- Use quality dimensions: uniqueness, completeness, consistency, referential integrity, validity  
- Compare LEFT vs INNER join sums  
- Build an issue register with owners and actions  

## Prerequisites

- Same Fabric access as Lab 01 (workspace + Lakehouse on Fabric capacity)  
- Lab 01 **not** required  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M1_L02_<id>` |
| Lakehouse | `lh_m1_l02` |

## Sample data

**[`Lab_02_Investigate_Data_Quality/data/`](./data/)**

| File | Table name after Setup D |
|------|--------------------------|
| `customers_dirty.csv` | `customers_dirty` |
| `sales_dirty.csv` | `sales_dirty` |
| `queries.sql` | Optional — queries are below |

---

## Progress checklist

- [ ] Setup A — Workspace `M1_L02_<id>` + Fabric capacity  
- [ ] Setup B — Lakehouse `lh_m1_l02`  
- [ ] Setup C — Both CSVs uploaded  
- [ ] Setup D — Both tables loaded  
- [ ] Setup E — SQL endpoint works  
- [ ] Steps 1–8 — Issue register complete  
- [ ] Submission ready  
- [ ] Cleanup — Lakehouse deleted  

---

## Fabric environment setup

### Setup A — Create workspace

1. Sign in at https://app.fabric.microsoft.com → **Workspaces** → **New workspace**.
2. Name: `M1_L02_<id>`. Description (optional): `Module 1 Lab 02 — data quality`.
3. **Workspace settings** → **Workspace type** → confirm **Fabric capacity**.
4. **Checkpoint:** Workspace opens with capacity assigned.

### Setup B — Create Lakehouse

1. **+ New item** → **Lakehouse** → name `lh_m1_l02` → **Create**.
2. **Checkpoint:** **Files** and **Tables** visible.

### Setup C — Upload files

1. **Get data** → **Upload files** (or **Files** → **…** → **Upload**).
2. From folder `Lab_02_Investigate_Data_Quality/data/`, upload:  
   `customers_dirty.csv`, `sales_dirty.csv`
3. **Checkpoint:** Both files listed under **Files**.

### Setup D — Load to tables

For each CSV: **Files** → **…** → **Load to Tables** → **New table**.

| File | Table name | Schema |
|------|------------|--------|
| `customers_dirty.csv` | `customers_dirty` | dbo |
| `sales_dirty.csv` | `sales_dirty` | dbo |

Use comma delimiter and first row as header.

**Checkpoint:** Two tables under **Tables**; preview each.

### Setup E — SQL endpoint

1. Open workspace `M1_L02_<id>` → select **SQL analytics endpoint** for `lh_m1_l02`.
2. Refresh until `customers_dirty` and `sales_dirty` appear.
3. Run test: `SELECT TOP (2) * FROM dbo.customers_dirty;`

**Checkpoint:** Results show rows (including duplicate C002).

---

## Step-by-step exercise

Fill [Learner_Worksheet.md](../Learner_Worksheet.md) **Lab 02** as you go.

### Step 1 — Profile raw records

Preview both tables in the Lakehouse, then run in SQL:

```sql
SELECT COUNT(*) AS CustomerRows,
       COUNT(DISTINCT CustomerID) AS DistinctCustomerIDs
FROM dbo.customers_dirty;

SELECT COUNT(*) AS SalesRows,
       SUM(CAST(Revenue AS decimal(18,2))) AS RawRevenue
FROM dbo.sales_dirty;
```

**Expected:** CustomerRows 6, DistinctCustomerIDs 5; SalesRows 5; RawRevenue 40000.

Record values in your worksheet. This raw total is **not** yet an approved KPI.

### Step 2 — Duplicate customer keys

```sql
SELECT CustomerID, COUNT(*) AS Occurrences
FROM dbo.customers_dirty
GROUP BY CustomerID
HAVING COUNT(*) > 1;
```

**Expected:** `C002` with Occurrences 2.

**Your action (write in register):** Investigate export/dedup rules; do not delete rows in Fabric.

### Step 3 — Missing region

```sql
SELECT CustomerID, CustomerName, Region
FROM dbo.customers_dirty
WHERE Region IS NULL OR LTRIM(RTRIM(Region)) = '';
```

**Expected:** `C003` with blank region.

**Action:** Request source fix or approved “Unknown” region—not a guess.

### Step 4 — Inconsistent region labels

```sql
SELECT CustomerID, Region,
       UPPER(LTRIM(RTRIM(Region))) AS SuggestedRegionKey
FROM dbo.customers_dirty
ORDER BY CustomerID;
```

Compare values: `North`, `NORTH`, ` North ` (with spaces). **Action:** Trim and map to a standard region list in a future prepared layer; keep originals for audit.

### Step 5 — Orphan customer on sales

```sql
SELECT s.SalesLineID, s.CustomerID, s.Revenue
FROM dbo.sales_dirty s
WHERE NOT EXISTS (
  SELECT 1 FROM dbo.customers_dirty c
  WHERE c.CustomerID = s.CustomerID
);
```

**Expected:** `S003`, `C999`, revenue 5000.

**Action:** Escalate—do not invent customer `C999` or drop the sale without approval.

### Step 6 — Negative revenue

```sql
SELECT * FROM dbo.sales_dirty
WHERE CAST(Revenue AS decimal(18,2)) < 0;
```

**Expected:** `S004`, revenue −2000.

**Action:** Finance review (refund vs error)—dataset has no transaction type.

### Step 7 — Join trap (critical)

Run both queries and record **your** totals in the worksheet.

```sql
SELECT SUM(CAST(s.Revenue AS decimal(18,2))) AS LeftJoinRevenue
FROM dbo.sales_dirty s
LEFT JOIN dbo.customers_dirty c ON s.CustomerID = c.CustomerID;
```

**Expected LeftJoinRevenue:** 55000 (duplicate C002 doubles ₹15,000; orphan C999 still included).

```sql
SELECT SUM(CAST(s.Revenue AS decimal(18,2))) AS InnerJoinRevenue
FROM dbo.sales_dirty s
JOIN dbo.customers_dirty c ON s.CustomerID = c.CustomerID;
```

**Expected InnerJoinRevenue:** 50000 (still wrong—duplicate still inflates; C999 excluded).

**Write in worksheet:** Changing LEFT vs INNER join does **not** fix bad source data. Do not use `SUM(DISTINCT Revenue)` as a hack.

### Step 8 — Issue register

Add **at least five** rows to your worksheet table. Include:

| Finding | Quality dimension | Example owner |
|---------|-------------------|---------------|
| Duplicate C002 | Uniqueness | CRM / export owner |
| Missing region C003 | Completeness | Master data owner |
| Region spelling/spacing | Consistency | Data steward |
| C999 on S003 | Referential integrity | CRM + sales |
| Negative S004 | Validity (needs context) | Finance |

For each row add: evidence, business impact, proposed action.

---

## Submission

Submit completed **Lab 02** worksheet (or equivalent document) with:

- Issue register (≥5 findings)  
- Raw, LEFT, and INNER revenue totals  
- Short explanation why the three totals differ  
- At least one decision needing **business** approval  

There is no single “correct” cleaned revenue until orphans and credits are decided.

---

## Cleanup

1. Save/submit answers.  
2. Delete lakehouse `lh_m1_l02` in workspace `M1_L02_<id>`.  

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Duplicate C002 not found | Reload `customers_dirty.csv` from Lab 02 data folder only |
| Join totals match raw 40000 | Check you joined to `customers_dirty`, not clean Lab 01 tables |
| Empty orphan query | Confirm `sales_dirty` loaded; check for C999 row in preview |
| SQL errors | Replace `dbo` if your tenant shows a different schema name |

---

## Verify your work (Lab 02)

| Check | Expected |
|-------|----------|
| Distinct customer IDs | 5 (from 6 rows) |
| Raw revenue | ₹40,000 |
| LEFT join revenue | ₹55,000 |
| INNER join revenue | ₹50,000 |
| Orphan sale | S003 / C999 |
