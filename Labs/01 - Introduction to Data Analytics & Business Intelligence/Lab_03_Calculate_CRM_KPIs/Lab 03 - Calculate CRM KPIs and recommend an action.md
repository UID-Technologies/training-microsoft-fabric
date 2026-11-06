# Lab 03 — Calculate CRM KPIs and recommend an action

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Use **`Lab_03_Calculate_CRM_KPIs/data/`** only. [Learner_Worksheet.md](../Learner_Worksheet.md) **Lab 03**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 50–65 minutes |
| Depends on Labs 01–02? | **No** — own workspace and clean CSV set |
| Sample data | [`Lab_03_Calculate_CRM_KPIs/data/`](./data/) |

## Description

Build a January 2026 management scorecard from clean fictional CRM extracts. Define metrics first, run SQL in Fabric, interpret revenue, pipeline, win rate, and target achievement honestly.

## Use case

Leadership wants January performance: revenue vs target, regional and product mix, pipeline snapshot, and a short actionable brief.

## Scenario

You receive clean customer, product, sales, opportunity, and target files. Finance set a **company-wide** January revenue target. You produce verified KPIs and a three-sentence recommendation that separates facts from guesses.

## Learning objectives

- Define grain and period before calculating  
- Compute revenue, customers, regional/product splits  
- Calculate pipeline and snapshot win rate with safe division  
- Compare actuals to targets without double-counting  
- State what the dataset cannot prove  

## Prerequisites

- Fabric workspace + Lakehouse on Fabric capacity  
- All five CSVs from the Lab 03 data folder  

## Fabric resources

| Resource | Name |
|----------|------|
| Workspace | `M1_L03_<id>` |
| Lakehouse | `lh_m1_l03` |

## Sample data

| File | Table name |
|------|------------|
| `customers.csv` | `customers` |
| `products.csv` | `products` |
| `sales.csv` | `sales` |
| `opportunities.csv` | `opportunities` |
| `targets.csv` | `targets` |

Folder: [`Lab_03_Calculate_CRM_KPIs/data/`](./data/)

---

## Business definitions (read before SQL)

Agree these rules—they affect every number:

| Term | Definition for this lab |
|------|-------------------------|
| Sales grain | One row = one sales line; `Revenue` = line revenue (INR) |
| January sales | `SaleDate` from 2026-01-01 up to (not including) 2026-02-01 |
| Target | One org row for `2026-01`; target amount ₹80,000 |
| Open pipeline | Sum of `EstimatedValue` where stage is **Proposal** or **Negotiation** |
| Closed won/lost | Stages **Won** and **Lost** only |
| Win rate | Won count ÷ (Won + Lost)—snapshot on supplied file, not “closed in January” |
| Avg won deal | Average `EstimatedValue` where Stage = Won (not sales revenue) |

**Do not** join the target table to every sales row—aggregate actual and target separately (Step 6).

---

## Progress checklist

- [ ] Read business definitions above  
- [ ] Setup A–E complete  
- [ ] Step 1 row counts match 4,2,6,6,1  
- [ ] January revenue = ₹70,000 on worksheet  
- [ ] Scorecard + three-sentence recommendation done  
- [ ] Cleanup  

---

## Fabric environment setup

### Setup A — Create workspace

1. https://app.fabric.microsoft.com → **Workspaces** → **New workspace**.
2. Name: `M1_L03_<id>`.
3. **Workspace settings** → **Workspace type** → confirm Fabric capacity.
4. **Checkpoint:** Capacity assigned.

### Setup B — Create Lakehouse

1. **+ New item** → **Lakehouse** → `lh_m1_l03` → **Create**.
2. **Checkpoint:** **Files** and **Tables** visible.

### Setup C — Upload five CSVs

From the Lab 03 data folder, upload:  
`customers.csv`, `products.csv`, `sales.csv`, `opportunities.csv`, `targets.csv`

**Checkpoint:** Five files under **Files**.

### Setup D — Load each CSV to a table

| File | Table name |
|------|------------|
| customers.csv | customers |
| products.csv | products |
| sales.csv | sales |
| opportunities.csv | opportunities |
| targets.csv | targets |

**Load to Tables** → **New table**, schema **dbo**, comma, header row.

**Checkpoint:** Five tables; preview each (e.g. sales has 6 rows).

### Setup E — SQL analytics endpoint

1. Open **SQL analytics endpoint** for `lh_m1_l03`.
2. Refresh until all five tables appear.
3. Test: `SELECT COUNT(*) FROM dbo.sales;` → expect **6**.

---

## Step-by-step exercise

### Step 1 — Validate row counts

```sql
SELECT 'customers' AS Dataset, COUNT(*) AS RowsFound FROM dbo.customers
UNION ALL SELECT 'products', COUNT(*) FROM dbo.products
UNION ALL SELECT 'sales', COUNT(*) FROM dbo.sales
UNION ALL SELECT 'opportunities', COUNT(*) FROM dbo.opportunities
UNION ALL SELECT 'targets', COUNT(*) FROM dbo.targets;
```

**Expected:** 4, 2, 6, 6, 1. If not, delete tables and reload—avoid loading the same CSV twice.

### Step 2 — January revenue and purchasing customers

```sql
SELECT SUM(CAST(Revenue AS decimal(18,2))) AS JanuaryRevenue,
       COUNT(DISTINCT CustomerID) AS PurchasingCustomers,
       SUM(CAST(Quantity AS int)) AS Units
FROM dbo.sales
WHERE CAST(SaleDate AS date) >= '2026-01-01'
  AND CAST(SaleDate AS date) < '2026-02-01';
```

**Expected:** JanuaryRevenue 70000; PurchasingCustomers 4; Units 10.

### Step 3 — Revenue by region

```sql
SELECT c.Region, SUM(CAST(s.Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.CustomerID = c.CustomerID
WHERE CAST(s.SaleDate AS date) >= '2026-01-01'
  AND CAST(s.SaleDate AS date) < '2026-02-01'
GROUP BY c.Region
ORDER BY Revenue DESC;
```

**Expected:** North 35000; South 20000; West 15000 (sum = 70000).

Record in worksheet; confirm regions add up to January total.

### Step 4 — Revenue by product

```sql
SELECT p.ProductName, SUM(CAST(s.Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales s
JOIN dbo.products p ON s.ProductID = p.ProductID
WHERE CAST(s.SaleDate AS date) >= '2026-01-01'
  AND CAST(s.SaleDate AS date) < '2026-02-01'
GROUP BY p.ProductName
ORDER BY Revenue DESC;
```

**Expected:** Learning License 40000; Training Package 30000.

### Step 5 — Pipeline and win rate

```sql
SELECT
  SUM(CASE WHEN Stage IN ('Proposal','Negotiation')
      THEN CAST(EstimatedValue AS decimal(18,2)) ELSE 0 END) AS OpenPipeline,
  SUM(CASE WHEN Stage = 'Won' THEN 1 ELSE 0 END) AS WonCount,
  SUM(CASE WHEN Stage = 'Lost' THEN 1 ELSE 0 END) AS LostCount,
  CAST(100.0 * SUM(CASE WHEN Stage = 'Won' THEN 1 ELSE 0 END)
    / NULLIF(SUM(CASE WHEN Stage IN ('Won','Lost') THEN 1 ELSE 0 END), 0)
    AS decimal(10,2)) AS WinRatePercent,
  AVG(CASE WHEN Stage = 'Won'
      THEN CAST(EstimatedValue AS decimal(18,2)) END) AS AverageWonDealValue
FROM dbo.opportunities;
```

**Expected:** OpenPipeline 55000; Won 2; Lost 2; WinRatePercent 50.00; AverageWonDealValue 15000.

**Worksheet note:** Pipeline is **potential** value—not January revenue.

### Step 6 — Target achievement

```sql
WITH Actual AS (
  SELECT SUM(CAST(Revenue AS decimal(18,2))) AS Revenue
  FROM dbo.sales
  WHERE CAST(SaleDate AS date) >= '2026-01-01'
    AND CAST(SaleDate AS date) < '2026-02-01'
), Target AS (
  SELECT SUM(CAST(RevenueTarget AS decimal(18,2))) AS RevenueTarget
  FROM dbo.targets WHERE [Month] = '2026-01'
)
SELECT a.Revenue, t.RevenueTarget,
       a.Revenue - t.RevenueTarget AS Variance,
       CAST(100.0 * a.Revenue / NULLIF(t.RevenueTarget, 0)
            AS decimal(10,2)) AS AchievementPercent
FROM Actual a CROSS JOIN Target t;
```

**Expected:** Revenue 70000; RevenueTarget 80000; Variance −10000; AchievementPercent 87.50.

### Step 7 — Complete scorecard

Transfer all metrics to [Learner_Worksheet.md](../Learner_Worksheet.md) **Lab 03** with a one-line interpretation each.

### Step 8 — Three-sentence recommendation

Write **exactly three sentences** in your own words:

1. **Fact** — cite numbers from your scorecard (revenue, target %, pipeline).  
2. **Insight** — what the pattern suggests (e.g. North half of revenue; below target).  
3. **Action** — a sensible next step (e.g. review open Proposal/Negotiation deals with owners).

**Do not:** claim why target was missed; promise pipeline will close the gap; calculate YoY without history.

**Example structure (adapt, do not copy verbatim):**  
“January recorded revenue was ₹70,000 against an ₹80,000 target, achieving 87.5%. North contributed ₹35,000, half of recorded revenue, while open pipeline stood at ₹55,000. Sales leadership should review the two open opportunities with account owners to confirm close plans and risks.”

### Step 9 — Architecture (short paragraph)

In your worksheet, describe the flow: **CSV upload → Files → Delta tables → SQL → scorecard**. Mention one improvement you would make next (e.g. standardize regions in a curated layer).

---

## Submission

Submit **Lab 03** worksheet (or equivalent) with:

- Full scorecard and reconciled regional/product totals  
- Three-sentence recommendation  
- Two clear limitations of the data  
- Architecture paragraph  

Pass criteria: January revenue ₹70,000; pipeline labeled as pipeline, not revenue.

---

## Cleanup

Delete lakehouse `lh_m1_l03` in workspace `M1_L03_<id>` after saving your work.

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Row counts too high | Tables loaded twice—delete lakehouse and restart setup |
| Achievement > 100% | Target joined incorrectly to sales lines—use Step 6 query exactly |
| Win rate NULL | No Won/Lost rows—check `opportunities` table loaded |
| Region totals ≠ 70000 | Wrong month filter or wrong customer join |

---

## Verify your work (Lab 03)

| Metric | Expected |
|--------|----------|
| January revenue | ₹70,000 |
| Target | ₹80,000 |
| Achievement | 87.5% |
| Open pipeline | ₹55,000 |
| Win rate | 50% |
| Avg won deal | ₹15,000 |
