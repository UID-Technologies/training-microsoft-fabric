# Lab 01 — OneLake, Lakehouse fundamentals, and the SQL endpoint

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_01_OneLake_Lakehouse_Fundamentals/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 75–90 minutes |
| You will use | Fabric workspace, Lakehouse, OneLake **Files**, Delta **Tables**, SQL analytics endpoint |
| You will not use | Medallion layers (Lab 02), pipelines, notebooks (optional fallback only) |
| Sample data | [`Lab_01_OneLake_Lakehouse_Fundamentals/data/`](./data/) |

## Description

Build a dedicated CRM Lakehouse and connect the concepts behind **OneLake**, managed **Delta tables**, raw **Files**, and the **Lakehouse SQL endpoint**. Compare when to use a **Lakehouse** versus a **Fabric Warehouse**, and document **schema** choices that keep CRM data queryable.

## Use case

Platform architects ask every team to land CRM extracts in OneLake using a consistent pattern. Before you implement Bronze/Silver/Gold (Lab 02), you must explain how raw files become managed tables, where SQL runs, and how a Warehouse differs from a Lakehouse for the same CRM scenario.

## Learning objectives

By the end of this lab you can:

- Explain OneLake as shared storage and the Lakehouse as a workload item over it
- Place raw CSV exports in **Files** and create **Delta** tables for analytics
- Inspect table **schema** (names, types) and correct common load issues
- Query the Lakehouse **SQL analytics endpoint** with read-only T-SQL
- Contrast **Lakehouse vs Warehouse** for CRM reporting (conceptual + optional portal tour)

## Prerequisites

- Organization account and https://app.fabric.microsoft.com
- Workspace on **Fabric capacity** (F SKU or trial)
- Module folder on disk including this lab’s `data/` path
- Completion of Module 3 is helpful but **not required** — this lab is standalone

## Fabric resources for this lab

Replace `<id>` with your initials (example: `js` → workspace `M4_L01_js`).

| Resource | Name |
|----------|------|
| Workspace | `M4_L01_<id>` |
| Lakehouse | `lh_m4_l01` |

---

## Progress checklist

- [ ] **Setup A** — Workspace on Fabric capacity  
- [ ] **Setup B** — Lakehouse `lh_m4_l01` created  
- [ ] **Setup C** — Three CSVs under **Files/landing/**  
- [ ] **Setup D** — Delta tables `customers`, `products`, `sales`  
- [ ] **Setup E** — SQL endpoint lists three tables  
- [ ] **Steps 1–4** — Concepts, queries, Lakehouse vs Warehouse notes  
- [ ] **Submission** — Notes or screenshots ready  
- [ ] **Cleanup** — Lakehouse deleted  

---

## Fabric environment setup

Complete **Setup A through E** before the exercise.

### Setup A — Workspace

1. Sign in at https://app.fabric.microsoft.com.
2. **Workspaces** → **New workspace**.
3. Name: `M4_L01_<id>`.
4. **Workspace settings** → **Workspace type**: confirm **Fabric capacity** (not Pro/PPU shared capacity alone).

### Setup B — Lakehouse

1. Open workspace `M4_L01_<id>`.
2. **+ New item** → **Lakehouse** → name `lh_m4_l01` → **Create**.
3. Note **Tables** and **Files** in the explorer — this is the Lakehouse “folder” over OneLake storage.

**Teaching point:** OneLake is the tenant-wide logical data lake; each Lakehouse item gets a managed area for **Files** and **Tables** (Delta).

### Setup C — Upload landing files

1. Under **Files**, create folder `landing`.
2. Upload from **`Lab_01_OneLake_Lakehouse_Fundamentals/data/`** on your PC:
   - `customers.csv`
   - `products.csv`
   - `sales.csv`
3. Confirm paths: `landing/customers.csv`, etc.

**Teaching point:** Files hold **objects** (CSV, JSON, Parquet). Uploading alone does not create SQL tables.

### Setup D — Load Delta tables

For each CSV in `Files/landing/`:

1. **Load to Tables** → **New table** (wording may vary).
2. Map to table names: `customers`, `products`, `sales`.
3. Verify header row and comma delimiter.

**Notebook fallback** (if **Load to Tables** is missing): create a **Notebook**, attach lakehouse `lh_m4_l01`, run once:

```python
for name in ["customers", "products", "sales"]:
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(f"Files/landing/{name}.csv"))
    df.write.format("delta").mode("overwrite").saveAsTable(name)
    print(name, df.count())
```

**Expected row counts:** customers **10**, products **5**, sales **15**.

**Teaching point:** **Tables** in the Lakehouse are **Delta Lake** tables — ACID, versioned, optimized for analytics and the SQL endpoint.

### Setup E — SQL analytics endpoint

1. Open the **SQL analytics endpoint** for `lh_m4_l01` (from the lakehouse item or experience switcher).
2. Refresh metadata until `customers`, `products`, `sales` appear (schema may be `dbo` or another name — use what the explorer shows).

---

## Step 1 — Tables, Files, and Delta (15 min)

In your own notes (or the lab’s **Submission** section), answer briefly:

1. What lives under **Files/landing/** versus under **Tables** for this lab?
2. Why are Lakehouse tables described as **Delta** tables?
3. Name one benefit of keeping raw CSV in **Files** even after you create **Tables**.

Inspect the **`sales`** table schema in the Lakehouse UI. Record column names and whether `Revenue` is numeric.

| Column | Your observed type |
|--------|-------------------|
| SaleID | |
| CustomerID | |
| ProductID | |
| SaleDate | |
| Quantity | |
| Revenue | |

If `Revenue` loaded as text, note it in troubleshooting — aggregates may need a cast in SQL:

```sql
SELECT SUM(CAST(Revenue AS decimal(18,2))) AS TotalRevenue FROM sales;
```

(Replace `sales` with `dbo.sales` if required.)

---

## Step 2 — Query the SQL analytics endpoint (20 min)

Run **one query at a time** in the SQL endpoint.

**Query 1 — sales totals**

```sql
SELECT COUNT(*) AS SalesRows,
       SUM(CAST(Revenue AS decimal(18,2))) AS TotalRevenue
FROM dbo.sales;
```

**Expected:** `SalesRows` = **15**, `TotalRevenue` = **210000.00**.

**Query 2 — grain check**

```sql
SELECT COUNT(*) AS CustomerRows FROM dbo.customers;
SELECT COUNT(*) AS ProductRows FROM dbo.products;
```

**Expected:** **10** customers, **5** products.

**Query 3 — join pattern (schema concepts)**

```sql
SELECT c.Region,
       COUNT(DISTINCT s.SaleID) AS SaleLines,
       SUM(CAST(s.Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.CustomerID = c.CustomerID
GROUP BY c.Region
ORDER BY c.Region;
```

**Expected:** **4 rows** (East, North, South, West). Sum of `Revenue` across regions = **210000**.

**Teaching point:** The SQL endpoint is **read-focused** for Lakehouse Delta tables. Create or change tables with **Load to Tables**, **Notebook**, or **Pipeline** — not arbitrary `INSERT` in the endpoint.

---

## Step 3 — Lakehouse vs Warehouse (20 min)

Read the comparison. Then complete **either** (A) or (B).

| Topic | Lakehouse (this lab) | Fabric Warehouse |
|-------|----------------------|------------------|
| Primary storage format | Delta on OneLake **Files/Tables** | Relational tables optimized for SQL warehouse |
| Typical ingress | Files, Spark, pipelines, shortcuts | Pipelines, COPY, T-SQL load patterns |
| SQL experience | **SQL analytics endpoint** on Lakehouse | **Warehouse** SQL endpoint (T-SQL) |
| Best for | Flexible file + table lake, Spark, medallion | Curated relational models, heavy T-SQL |

**(A) Portal exploration (recommended if allowed)**  
1. In workspace `M4_L01_<id>`, **+ New item** → **Warehouse** → create `wh_m4_l01_explore` (delete later if your instructor allows).
2. Open the Warehouse and note how **Tables** and SQL editor differ from the Lakehouse UI.
3. **Do not** load full CRM data unless you have spare time — this step is conceptual.
4. Delete the warehouse in cleanup if you created it.

**(B) If Warehouse creation is blocked**  
In your notes, list **two** CRM questions better answered from a **Lakehouse** and **one** scenario where a team might add a **Warehouse** (example: governed star schema for enterprise SQL reporting).

---

## Step 4 — OneLake and design preview (10 min)

1. In two or three sentences, explain **OneLake** vs this lab’s **Lakehouse item** (not the same thing).
2. Sketch or list a future **folder/table naming** plan for Module 4 Lab 02: `bronze/`, `silver/`, `gold/` under Files or tables prefixed `bronze_`, `silver_`, `gold_` — you will implement medallion in [Lab 02](../Lab_02_Medallion_CRM_Lakehouse/Lab%2002%20-%20Design%20a%20medallion%20CRM%20Lakehouse.md).

---

## Submission

Submit to your instructor (or save in your notes):

- Files vs Tables vs Delta explanation  
- SQL totals **15** / **210000**  
- Lakehouse vs Warehouse comparison (Step 3A or 3B)  
- OneLake vs Lakehouse item explanation (Step 4)  

---

## Cleanup

1. Save submission evidence (notes or screenshots).  
2. Delete lakehouse `lh_m4_l01` in workspace `M4_L01_<id>` unless instructor asks you to keep it for Lab 02 (Lab 02 uses a **new** workspace).  
3. Delete optional warehouse `wh_m4_l01_explore` if created.

---

## Help and troubleshooting

| Symptom | Likely cause | What to do |
|---------|--------------|------------|
| No Lakehouse in **New item** | No Fabric capacity | Fix workspace type |
| Load to Tables missing | Tenant UI | Use Notebook fallback |
| TotalRevenue wrong | Wrong data folder | Reload from Lab 01 `data/` only |
| `dbo.sales` invalid | Schema name | Use schema from SQL explorer |
| Warehouse unavailable | License/capacity | Complete Step 3B |

---

## Verify your work (Lab 01)

| Topic | Reference |
|-------|-----------|
| Row counts | 10 / 5 / 15 |
| Total revenue | 210000 |
| Regions in Query 3 | 4 rows, revenue sums to 210000 |
| Delta | Managed tables under **Tables**, backed by OneLake |