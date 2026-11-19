# Lab 01 — Build CRM star schema tables

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_01_CRM_Star_Schema/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–105 minutes |
| Hands-on | **Hands-on 9** — `Dim*` and `Fact*` tables for CRM analytics |
| Standalone | Workspace `M9_L01_<id>`, lakehouse `lh_m9_stg`, warehouse `wh_m9_star` |
| Sample data | [`data/`](./data/) — same five CRM staging files as Module 8 |

## Description

Model a **star schema** in a **Fabric Warehouse**: conformed dimensions (including **DimDate**), fact tables for **sales** and **opportunities**, surrogate **keys**, and notes on **star vs snowflake**, **cardinality**, and **Power BI** modeling habits.

## Learning objectives

- Distinguish **fact** and **dimension** tables and business vs surrogate keys  
- Build a **star** layout (denormalized dimensions) vs when **snowflake** helps  
- Create **DimDate** and conformed **DimRegion**  
- Populate **FactSales** and **FactOpportunity** with dimension keys  
- Describe **filter direction** and performance-oriented modeling for Power BI  

## Prerequisites

- Fabric capacity with **Warehouse**  
- Module 8 patterns helpful; not required  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M9_L01_<id>` |
| Lakehouse (staging) | `lh_m9_stg` |
| Warehouse (star schema) | `wh_m9_star` |

---

## Progress checklist

- [ ] Part A2 — five `stg_*` tables in warehouse  
- [ ] Part B — grain documented + star sketch + build order understood  
- [ ] Seven star tables created in `wh_m9_star`  
- [ ] Fact rows match staging counts  
- [ ] Star diagram in submission notes  
- [ ] Star vs snowflake + cardinality notes  

---

## Part A — Stage source data (15 min)

1. Workspace `M9_L01_<id>` on Fabric capacity.  
2. Lakehouse `lh_m9_stg` — upload five CSVs from **`data/`** to `Files/staging/`.  
3. Create staging tables `stg_customers`, `stg_products`, `stg_salespeople`, `stg_sales`, `stg_opportunities` (same Notebook loop as Module 8 Lab 01 Part A).

**Expected staging counts:** customers **12**, products **6**, salespeople **4**, sales **24**, opportunities **16**; sales revenue **533500**.

---

## Part A2 — Copy staging into the warehouse (10 min)

1. In workspace `M9_L01_<id>`, **+ New item** → **Warehouse** → name **`wh_m9_star`** → **Create**.  
2. Open **`wh_m9_star`** and switch to the **SQL analytics endpoint** (warehouse SQL editor — you can run `CREATE TABLE` and `INSERT` here).  
3. **+ New item** → **Data pipeline** → name **`pl_m9_stage_copy`**.  
4. Add **Copy data** activities (one per table, or run five times):

   | Activity name | Source | Destination |
   |---------------|--------|-------------|
   | Copy customers | Lakehouse `lh_m9_stg` table **`stg_customers`** | Warehouse table **`stg_customers`** (create new, overwrite) |
   | Copy products | `stg_products` | `stg_products` |
   | Copy salespeople | `stg_salespeople` | `stg_salespeople` |
   | Copy sales | `stg_sales` | `stg_sales` |
   | Copy opportunities | `stg_opportunities` | `stg_opportunities` |

   If your UI uses **Copy data assistant**, pick **Lakehouse** as source and **Warehouse** as destination; map table to table. Names must match exactly so Part C SQL can use `stg_sales`, etc.

5. **Run** the pipeline. Wait until all five activities succeed.  
6. In the **warehouse** SQL editor, run:

```sql
SELECT 'stg_customers' AS T, COUNT(*) AS Cnt FROM stg_customers
UNION ALL SELECT 'stg_sales', COUNT(*) FROM stg_sales;
```

**Expected:** `stg_customers` = **12**, `stg_sales` = **24**.

> **Important:** Parts **B–D** use only **`wh_m9_star`**. Do not run the star-schema scripts on the lakehouse SQL endpoint.

---

## Part B — Star schema design and setup (15 min)

**Goal:** Decide what you will build, in what order, before you run any `CREATE TABLE` for `Dim*` or `Fact*`. Part B is planning + verification — you do **not** create dimension or fact tables yet.

### Step B1 — Open the correct workspace item

1. Go to workspace `M9_L01_<id>`.  
2. Open **`wh_m9_star`** (the **Warehouse**, not the lakehouse).  
3. Open **New SQL query** / SQL editor for this warehouse.  
4. Run:

```sql
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'stg_%'
ORDER BY TABLE_NAME;
```

**Checkpoint:** You must see **five** tables: `stg_customers`, `stg_products`, `stg_salespeople`, `stg_sales`, `stg_opportunities`.  
If any are missing, return to **Part A2** and finish the copy pipeline.

### Step B2 — List the seven tables you will create (Hands-on 9)

Copy this list into your notes and check each box when done in Parts C and D:

| Order | Table | Type | Purpose |
|:-----:|-------|------|---------|
| 1 | `DimRegion` | Dimension | Conformed region (4 values) |
| 2 | `DimCustomer` | Dimension | Customers + `RegionKey` |
| 3 | `DimProduct` | Dimension | Products (category on row = **star**) |
| 4 | `DimSalesperson` | Dimension | Salespeople + `RegionKey` |
| 5 | `DimDate` | Dimension | Calendar 2026; `DateKey` = `yyyymmdd` |
| 6 | `FactSales` | Fact | One row per sale; links to dim keys |
| 7 | `FactOpportunity` | Fact | One row per opportunity |

**Do not** create `Dim*` or `Fact*` tables until **Part C** (dimensions) and **Part D** (facts).

### Step B3 — Define grain (one row in a fact means)

Write in your notes:

| Fact table | Grain (one row =) | Business key from staging |
|------------|-------------------|---------------------------|
| `FactSales` | One sale line | `SaleID` in `stg_sales` |
| `FactOpportunity` | One opportunity | `OpportunityID` in `stg_opportunities` |

Measures such as revenue sum over **`FactSales`**; opportunity counts over **`FactOpportunity`**.

### Step B4 — Sketch the star (required for submission)

On paper or a whiteboard, draw:

- **Center:** `FactSales` and `FactOpportunity`  
- **Around them:** `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`  
- **Also:** `DimRegion` connected to `DimCustomer` and `DimSalesperson` (not directly to facts in this lab)

Label each line **1 : many** from dimension → fact.

### Step B5 — Confirm build rules

Before Part C, you should be able to answer **yes** to:

- [ ] I am in the **warehouse** `wh_m9_star` SQL editor.  
- [ ] All **five** `stg_*` tables exist and row counts match Part A.  
- [ ] I will run dimension scripts in **Part C in order**: Region → Customer → Product → Salesperson → Date.  
- [ ] I will run fact scripts in **Part D only after** all dimensions exist.  
- [ ] I will not add `RegionName` onto `FactSales` (region comes via `DimCustomer` → `DimRegion`).

When all boxes are checked, continue to **Part C**.

---

## Part C — Dimension tables (35 min)

**Where:** **`wh_m9_star`** warehouse SQL editor only.  
**How:** Run **one script block at a time** in the order below. Wait for success before the next block. If a script fails because the table already exists, fix with your instructor (drop table only if allowed).

**Order:** `DimRegion` → `DimCustomer` → `DimProduct` → `DimSalesperson` → `DimDate` (do not skip or reorder).

### DimRegion (conformed)

```sql
CREATE TABLE dbo.DimRegion (
    RegionKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RegionName  NVARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO dbo.DimRegion (RegionName)
SELECT DISTINCT Region FROM dbo.stg_customers
UNION
SELECT DISTINCT HomeRegion FROM dbo.stg_salespeople;
```

**Expected:** **4** regions (North, South, East, West).

Verify:

```sql
SELECT COUNT(*) AS RegionRows FROM dbo.DimRegion;
```

### DimCustomer

```sql
CREATE TABLE dbo.DimCustomer (
    CustomerKey  INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CustomerID   NVARCHAR(10) NOT NULL,
    CustomerName NVARCHAR(100) NOT NULL,
    RegionKey    INT NOT NULL,
    Industry     NVARCHAR(50) NULL
);

INSERT INTO dbo.DimCustomer (CustomerID, CustomerName, RegionKey, Industry)
SELECT c.CustomerID, c.CustomerName, r.RegionKey, c.Industry
FROM stg_customers c
JOIN dbo.DimRegion r ON c.Region = r.RegionName;
```

**Expected:** **12** rows.

### DimProduct (star — category on row)

```sql
CREATE TABLE dbo.DimProduct (
    ProductKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductID    NVARCHAR(10) NOT NULL,
    ProductName  NVARCHAR(100) NOT NULL,
    Category     NVARCHAR(50) NOT NULL,
    UnitPrice    DECIMAL(18,2) NOT NULL
);

INSERT INTO dbo.DimProduct (ProductID, ProductName, Category, UnitPrice)
SELECT ProductID, ProductName, Category, UnitPrice FROM stg_products;
```

**Expected:** **6** rows.

### DimSalesperson

```sql
CREATE TABLE dbo.DimSalesperson (
    SalespersonKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SalespersonID    NVARCHAR(10) NOT NULL,
    SalespersonName  NVARCHAR(100) NOT NULL,
    RegionKey        INT NOT NULL
);

INSERT INTO dbo.DimSalesperson (SalespersonID, SalespersonName, RegionKey)
SELECT sp.SalespersonID, sp.SalespersonName, r.RegionKey
FROM stg_salespeople sp
JOIN dbo.DimRegion r ON sp.HomeRegion = r.RegionName;
```

**Expected:** **4** rows.

### DimDate (calendar 2026)

```sql
CREATE TABLE dbo.DimDate (
    DateKey          INT NOT NULL PRIMARY KEY,
    FullDate         DATE NOT NULL,
    CalendarYear     SMALLINT NOT NULL,
    CalendarMonth    TINYINT NOT NULL,
    MonthName        NVARCHAR(20) NOT NULL,
    CalendarQuarter  TINYINT NOT NULL
);

WITH d AS (
    SELECT CAST('2026-01-01' AS DATE) AS dt
    UNION ALL
    SELECT DATEADD(day, 1, dt) FROM d WHERE dt < '2026-12-31'
)
INSERT INTO dbo.DimDate (DateKey, FullDate, CalendarYear, CalendarMonth, MonthName, CalendarQuarter)
SELECT
    YEAR(dt) * 10000 + MONTH(dt) * 100 + DAY(dt),
    dt,
    YEAR(dt),
    MONTH(dt),
    DATENAME(month, dt),
    DATEPART(quarter, dt)
FROM d
OPTION (MAXRECURSION 366);
```

**Expected:** **365** rows (or **366** if you extend script for leap years in other datasets).

**Teaching point:** Use integer **DateKey** `yyyymmdd` for joins to facts; conformed date table shared by all facts.

**Part C checkpoint** — before Part D, all five counts:

```sql
SELECT 'DimRegion' AS DimTable, COUNT(*) AS Cnt FROM dbo.DimRegion
UNION ALL SELECT 'DimCustomer', COUNT(*) FROM dbo.DimCustomer
UNION ALL SELECT 'DimProduct', COUNT(*) FROM dbo.DimProduct
UNION ALL SELECT 'DimSalesperson', COUNT(*) FROM dbo.DimSalesperson
UNION ALL SELECT 'DimDate', COUNT(*) FROM dbo.DimDate;
```

**Expected:** **4**, **12**, **6**, **4**, **365**.

---

## Part D — Fact tables (30 min)

**Where:** Same warehouse SQL editor.  
**When:** Only after **Part C checkpoint** passes.  
**Order:** `FactSales` first, then `FactOpportunity`.

### FactSales

```sql
CREATE TABLE dbo.FactSales (
    SaleID           NVARCHAR(10) NOT NULL PRIMARY KEY,
    DateKey          INT NOT NULL,
    CustomerKey      INT NOT NULL,
    ProductKey       INT NOT NULL,
    SalespersonKey   INT NOT NULL,
    Quantity         INT NOT NULL,
    Revenue          DECIMAL(18,2) NOT NULL
);

INSERT INTO dbo.FactSales (SaleID, DateKey, CustomerKey, ProductKey, SalespersonKey, Quantity, Revenue)
SELECT
    s.SaleID,
    YEAR(CAST(s.SaleDate AS DATE)) * 10000 + MONTH(CAST(s.SaleDate AS DATE)) * 100 + DAY(CAST(s.SaleDate AS DATE)),
    dc.CustomerKey,
    dp.ProductKey,
    dsp.SalespersonKey,
    s.Quantity,
    s.Revenue
FROM stg_sales s
JOIN dbo.DimCustomer dc ON s.CustomerID = dc.CustomerID
JOIN dbo.DimProduct dp ON s.ProductID = dp.ProductID
JOIN dbo.DimSalesperson dsp ON s.SalespersonID = dsp.SalespersonID;
```

**Expected:** **24** rows; `SUM(Revenue)` = **533500**.

### FactOpportunity

```sql
CREATE TABLE dbo.FactOpportunity (
    OpportunityID    NVARCHAR(10) NOT NULL PRIMARY KEY,
    DateKey          INT NOT NULL,
    CustomerKey      INT NOT NULL,
    Stage            NVARCHAR(20) NOT NULL,
    EstimatedValue   DECIMAL(18,2) NOT NULL
);

INSERT INTO dbo.FactOpportunity (OpportunityID, DateKey, CustomerKey, Stage, EstimatedValue)
SELECT
    o.OpportunityID,
    YEAR(CAST(o.ExpectedCloseDate AS DATE)) * 10000 + MONTH(CAST(o.ExpectedCloseDate AS DATE)) * 100 + DAY(CAST(o.ExpectedCloseDate AS DATE)),
    dc.CustomerKey,
    o.Stage,
    o.EstimatedValue
FROM stg_opportunities o
JOIN dbo.DimCustomer dc ON o.CustomerID = dc.CustomerID;
```

**Expected:** **16** rows.

---

## Part E — Star vs snowflake (10 min)

In submission notes:

1. **Star** in this lab: `Category` lives on **DimProduct**; customer **Region** resolves via **DimCustomer** → **DimRegion**.  
2. **Snowflake** alternative: `DimCategory` separate table and **DimProduct** holds only `CategoryKey` (fewer columns on product, extra join).  
3. When snowflake can help warehouse storage; when star is faster for **Power BI** (fewer joins).

Draw a diagram: facts in the center, dimensions around them.

---

## Part F — Keys, cardinality, filter direction (10 min)

| Relationship | Cardinality | Filter direction (Power BI) |
|--------------|---------------|-----------------------------|
| DimCustomer → FactSales | 1 : many | Single (dim filters fact) |
| DimDate → FactSales | 1 : many | Single |
| DimProduct → FactSales | 1 : many | Single |

Confirm every fact row has valid dimension keys (no orphan keys).

```sql
SELECT COUNT(*) AS Orphans
FROM dbo.FactSales f
LEFT JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;
```

**Expected Orphans:** **0**.

---

## Part G — Modeling for Power BI and performance (10 min)

Notes (no full report required):

- Hide surrogate keys from report view; use business columns on dimensions.  
- Do not store redundant **Region** on FactSales when **DimCustomer** provides it (avoids ambiguity).  
- Keep facts **narrow**; put text attributes on dimensions.  
- Optional: **Get data** from `wh_m9_star` and verify relationships auto-detect as 1:* .

---

## Submission

- Star schema diagram (hand-drawn or tool)  
- Row counts for all seven tables  
- Fact revenue total **533500**  
- Star vs snowflake paragraph  
- Orphan check = 0  

---

## Cleanup

Delete `wh_m9_star`, `lh_m9_stg`, and any load pipelines when signed off.

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| `stg_*` not in warehouse | Complete **Part A2**; verify with Step B1 query |
| Unsure what Part B is for | Planning only — no `Dim*`/`Fact*` until Part C/D in order |
| DateKey mismatch | Align `SaleDate`/`ExpectedCloseDate` cast with DimDate keys |
| Recursive CTE blocked | Build DimDate in Notebook and load, or use instructor date CSV |
| INSERT fails on RegionKey | Load **DimRegion** before customer/salesperson dims |

---

## Verify your work

| Object | Expected rows |
|--------|----------------|
| DimRegion | 4 |
| DimCustomer | 12 |
| DimProduct | 6 |
| DimSalesperson | 4 |
| DimDate | 365 |
| FactSales | 24 |
| FactOpportunity | 16 |
| Hands-on 9 | All seven table names present in `dbo` |