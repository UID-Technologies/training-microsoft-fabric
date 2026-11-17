# Lab 01 — CRM analytics in the Fabric Warehouse

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_01_Warehouse_CRM_Analytics/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–105 minutes |
| Hands-on | **Hands-on 8** — CRM warehouse queries and analytical views |
| Standalone | Workspace `M8_L01_<id>`, lakehouse `lh_m8_src`, warehouse `wh_m8_crm` |
| Sample data | [`data/`](./data/) — five CRM CSV files |

## Description

Create a **Fabric Warehouse**, **load** CRM tables from a Lakehouse source, run **T-SQL** for revenue, salesperson, win/loss, and trend analysis, then publish **views** for reuse. Compare **Warehouse vs Lakehouse**, note **security** basics, and optionally connect **Power BI**.

## Learning objectives

- Explain **Fabric Warehouse** architecture vs a **Lakehouse SQL endpoint**  
- **Load** relational tables into a warehouse from Lakehouse files/tables  
- Write filters, **joins**, **GROUP BY**, and aggregations in T-SQL  
- Create **analytical views** for CRM KPIs  
- Describe warehouse **permissions** and **Power BI** connectivity at a high level  

## Prerequisites

- Fabric workspace on **capacity**  
- Completion of Modules 4 or 7 helpful (Lakehouse load patterns)  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M8_L01_<id>` |
| Lakehouse (staging) | `lh_m8_src` |
| Warehouse | `wh_m8_crm` |

---

## Progress checklist

- [ ] Five staging tables in `lh_m8_src`  
- [ ] Warehouse `wh_m8_crm` with five `dbo` tables loaded  
- [ ] Hands-on 8 queries run  
- [ ] Five analytical **views** created  
- [ ] Warehouse vs Lakehouse + security notes  
- [ ] Optional Power BI connection noted  

---

## Part A — Staging Lakehouse (15 min)

1. Workspace `M8_L01_<id>` on Fabric capacity.  
2. **Lakehouse** `lh_m8_src`.  
3. Upload all five CSVs from **`data/`** to `Files/staging/`.  
4. Load to tables: `stg_customers`, `stg_products`, `stg_salespeople`, `stg_sales`, `stg_opportunities` (UI **Load to Tables** or Notebook):

```python
from pyspark.sql import functions as F

for name in ["customers", "products", "salespeople", "sales", "opportunities"]:
    df = (spark.read.option("header", "true").option("inferSchema", "true")
          .csv(f"Files/staging/{name}.csv"))
    if name == "sales":
        df = (df.withColumn("Revenue", F.col("Revenue").cast("decimal(18,2)))
              .withColumn("SaleDate", F.to_date("SaleDate")))
    df.write.format("delta").mode("overwrite").saveAsTable(f"stg_{name}")
```

**Expected counts:** customers **12**, products **6**, salespeople **4**, sales **24**, opportunities **16**.

**Teaching point:** Lakehouse staging is a common **load path** before curated warehouse tables.

---

## Part B — Create the Fabric Warehouse (10 min)

1. **+ New item** → **Warehouse** → `wh_m8_crm`.  
2. Open the warehouse **SQL endpoint** (full **read/write** T-SQL).  
3. In notes, contrast with your Module 4 **Lakehouse SQL analytics endpoint** (read-oriented, Delta-focused).

| Capability | Lakehouse SQL endpoint | Fabric Warehouse |
|------------|------------------------|------------------|
| Typical writes | Spark/Dataflow/Pipeline | **T-SQL** DML/DDL |
| Storage model | Delta / OneLake files | Relational warehouse tables |
| Best for | Lake + Spark paths | Governed SQL analytics |

---

## Part C — Load warehouse tables (25 min)

Load staging into warehouse tables using **Copy data** (Lakehouse → Warehouse) **or** warehouse T-SQL if your tenant supports cross-item `CREATE TABLE AS SELECT`.

**Target warehouse tables (dbo):** `Customers`, `Products`, `Salespeople`, `Sales`, `Opportunities`

### Option 1 — Data pipeline (recommended)

1. Pipeline `pl_m8_load_wh` with **Copy data** per table: source Lakehouse table `stg_*` → destination Warehouse `dbo.*` (overwrite).  
2. Run pipeline; confirm five tables in warehouse explorer.

### Option 2 — Manual / SQL script

If Copy is unavailable, create tables in the warehouse SQL editor and use supported **INSERT** / import flows your instructor demonstrates (screenshot requirement still applies).

**Checkpoint:**

```sql
SELECT COUNT(*) AS SalesRows FROM dbo.Sales;
```

**Expected:** **24** rows; `SELECT SUM(Revenue) FROM dbo.Sales` → **533500.00**.

---

## Part D — Hands-on 8: T-SQL queries (35 min)

Run in **warehouse** SQL editor. Replace schema if tables are not under `dbo`.

### 1 — Revenue by region

```sql
SELECT c.Region,
       COUNT(DISTINCT s.SaleID) AS SaleCount,
       SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.Region
ORDER BY Revenue DESC;
```

**Expected:** **4** regions; sum of `Revenue` = **533500**.

### 2 — Revenue by product

```sql
SELECT p.ProductName, p.Category,
       SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName, p.Category
ORDER BY Revenue DESC;
```

**Expected:** **6** products.

### 3 — Salesperson performance

```sql
SELECT sp.SalespersonName, sp.HomeRegion,
       COUNT(DISTINCT s.SaleID) AS Deals,
       SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Salespeople sp ON s.SalespersonID = sp.SalespersonID
GROUP BY sp.SalespersonName, sp.HomeRegion
ORDER BY Revenue DESC;
```

**Expected:** **4** salespeople.

### 4 — Win / loss / open pipeline

```sql
SELECT Stage,
       COUNT(*) AS OpportunityCount,
       SUM(EstimatedValue) AS PipelineValue
FROM dbo.Opportunities
GROUP BY Stage
ORDER BY Stage;
```

**Expected:** Won **6**, Lost **5**, Open **5** (16 total).

### 5 — Customer revenue

```sql
SELECT c.CustomerID, c.CustomerName, c.Region,
       SUM(s.Revenue) AS CustomerRevenue
FROM dbo.Sales s
JOIN dbo.Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName, c.Region
ORDER BY CustomerRevenue DESC;
```

**Expected:** **12** customers with sales in this dataset.

### 6 — Monthly revenue trend

```sql
SELECT YEAR(s.SaleDate) AS SalesYear,
       MONTH(s.SaleDate) AS SalesMonth,
       SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
GROUP BY YEAR(s.SaleDate), MONTH(s.SaleDate)
ORDER BY SalesYear, SalesMonth;
```

**Expected:** Months **1–4** in 2026 with non-zero revenue.

---

## Part E — Analytical views (15 min)

Create views for self-service reuse:

```sql
CREATE OR ALTER VIEW dbo.vw_RevenueByRegion AS
SELECT c.Region, SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.Region;
GO

CREATE OR ALTER VIEW dbo.vw_RevenueByProduct AS
SELECT p.ProductName, SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductName;
GO

CREATE OR ALTER VIEW dbo.vw_SalespersonPerformance AS
SELECT sp.SalespersonName, SUM(s.Revenue) AS Revenue
FROM dbo.Sales s
JOIN dbo.Salespeople sp ON s.SalespersonID = sp.SalespersonID
GROUP BY sp.SalespersonName;
GO

CREATE OR ALTER VIEW dbo.vw_WinLossSummary AS
SELECT Stage, COUNT(*) AS Cnt, SUM(EstimatedValue) AS Value
FROM dbo.Opportunities
GROUP BY Stage;
GO

CREATE OR ALTER VIEW dbo.vw_MonthlyRevenueTrend AS
SELECT YEAR(SaleDate) AS Y, MONTH(SaleDate) AS M, SUM(Revenue) AS Revenue
FROM dbo.Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate);
GO
```

Verify: `SELECT * FROM dbo.vw_RevenueByRegion;`

---

## Part F — Security introduction (5 min)

In notes:

1. Who can **read** warehouse data in your workspace (Viewer vs Contributor)?  
2. Where **object-level** permissions or future **RLS** will apply (Module 17).  
3. **Do not** grant broader workspace access than training requires.

---

## Part G — Power BI integration (optional, 10 min)

1. From workspace or warehouse, start **New semantic model** / **Get data** using the **Warehouse** connector pointing to `wh_m8_crm`.  
2. Add `dbo.vw_RevenueByRegion` and `dbo.vw_MonthlyRevenueTrend` to a simple report page.  
3. If publish is disabled, submit a screenshot of the model preview only.

---

## Submission

- Warehouse and lakehouse names  
- Load method (pipeline or alternate)  
- Query result for total revenue **533500** and win/loss counts  
- List of five views created  
- Part F security notes; optional Part G screenshot  

---

## Cleanup

Delete `wh_m8_crm`, `lh_m8_src`, and load pipeline when signed off.

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Cannot create Warehouse | Confirm Fabric capacity includes Warehouse |
| Copy Lakehouse → Warehouse missing | Use instructor alternate load; document |
| `CREATE VIEW` fails | Run statements one at a time; check `GO` support |
| Revenue mismatch | Reload from this lab `data/` only |

---

## Verify your work

| Check | Expected |
|-------|----------|
| Sales rows | 24 |
| Total revenue | 533500 |
| Opportunities by stage | Won 6, Lost 5, Open 5 |
| Views | 5 `vw_*` objects |
| Hands-on 8 | All six query patterns + views |