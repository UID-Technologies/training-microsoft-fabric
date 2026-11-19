# Lab 01 — Build the reusable CRM semantic model

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). New blank `.pbix`; data in **`Lab_01_CRM_Semantic_Model/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–105 minutes |
| Hands-on | **Hands-on 10** — star-schema semantic model with validated relationships |
| Deliverable | `CRM_Semantic_Model_L10.pbix` |
| Platform | **Power BI Desktop** (optional Fabric semantic model publish) |
| Sample data | Seven CSV files (`Dim*` + `Fact*`) |

## Description

Build a **reusable CRM semantic model**: import dimension and fact tables, define **relationships** and **cardinality**, add **measures** vs a **calculated column**, create **hierarchies** and a marked **date table**, apply **business-friendly** names, and compare **Import**, **DirectQuery**, and **Direct Lake**.

## Learning objectives

- Assemble a **star schema** in Model view  
- Set **1:* relationships**, **single** cross-filter direction, and active relationships  
- Choose **measures** vs **calculated columns**  
- Build **hierarchies** and mark **DimDate** as the date table  
- Describe when to use **Import**, **DirectQuery**, or **Direct Lake** in Fabric  

## Prerequisites

- **Power BI Desktop** on Windows  
- Module 9 concepts helpful; lab is **standalone**  

## How to work through this lab

1. Work **Parts A → G in order**. Do not add report visuals for grading until **Part F** (scratch page only).  
2. Use **Model view** for relationships (Part B); use **Table tools** / **Column tools** for date table and hierarchies (Part C).  
3. After each part, run the **checkpoint** before moving on.  
4. Save the file often: **`CRM_Semantic_Model_L10.pbix`**. You will reuse this model in Module 11 if your course continues.

## Progress checklist

- [ ] Part A — seven tables imported and typed  
- [ ] Part B — seven relationships (single direction, active)  
- [ ] Part C — date table marked; Calendar + Product hierarchies  
- [ ] Part D — measures + one calculated column; revenue **533500**  
- [ ] Part E — display folder, sort-by, hide keys  
- [ ] Part F — validation matrix + scratch visuals  
- [ ] Part G — storage mode notes  

---

## Part A — Import tables (15 min)

**Goal:** Load all seven CSVs with correct names and data types. **No relationships yet.**

### Step A1 — Create and save the file

1. Open **Power BI Desktop**.  
2. **File → Save As** → name **`CRM_Semantic_Model_L10.pbix`** → save in your lab folder.

### Step A2 — Import the seven CSV files

1. **Home → Get data → Text/CSV** (or **Get data → More… → Text/CSV**).  
2. Browse to **`Lab_01_CRM_Semantic_Model/data/`**.  
3. Import **one file at a time**, or multi-select all seven if your Power BI version allows batch import:  
   `DimRegion.csv`, `DimCustomer.csv`, `DimProduct.csv`, `DimSalesperson.csv`, `DimDate.csv`, `FactSales.csv`, `FactOpportunity.csv`.  
4. For each file, confirm **Load** (or **Transform Data** if you need to fix types — see A3).

### Step A3 — Rename queries and set data types

In **Power Query Editor** (if you opened Transform Data), or **Data view** after load:

| Query / table | Columns to set |
|---------------|----------------|
| All `*Key` columns | **Whole number** |
| `FactSales[Revenue]`, `FactOpportunity[EstimatedValue]` | **Fixed decimal number** |
| `DimDate[FullDate]` | **Date** |

Rename each query to match the file base name exactly: `DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`.

5. **Close & Apply**.

### Step A4 — Row count checkpoint

In **Data view**, select each table and confirm **row counts** at the status bar (or add a quick **Table** visual):

| Table | Expected rows |
|-------|----------------|
| `FactSales` | **24** |
| `FactOpportunity` | **16** |
| `DimCustomer` | **12** |
| `DimDate` | **151** |

If counts differ, re-import from **`data/`** only (do not mix Module 11 files).

---

## Part B — Relationships and cardinality (25 min)

**Goal:** Connect dimensions to facts in **Model view**. Every link is **many-to-one** from fact → dimension, **single** cross-filter direction, **active**.

### Step B1 — Open Model view and arrange tables

1. Click **Model view** (left sidebar, third icon).  
2. Drag tables so **facts are in the center** and **dimensions around them** (star layout).

### Step B2 — Create each relationship (in this order)

For each row below: drag the **From (1)** key onto the **To (*)** key, or use **Home → Manage relationships → New**.

| # | From (1) | To (*) | Join columns | Cross-filter |
|---|----------|--------|--------------|--------------|
| 1 | `DimRegion` | `DimCustomer` | `RegionKey` | Single |
| 2 | `DimCustomer` | `FactSales` | `CustomerKey` | Single |
| 3 | `DimProduct` | `FactSales` | `ProductKey` | Single |
| 4 | `DimSalesperson` | `FactSales` | `SalespersonKey` | Single |
| 5 | `DimDate` | `FactSales` | `DateKey` | Single |
| 6 | `DimCustomer` | `FactOpportunity` | `CustomerKey` | Single |
| 7 | `DimDate` | `FactOpportunity` | `DateKey` | Single |

**On each relationship dialog:**

- Cardinality: **One to many (1:* )** — dimension side is **1**, fact side is **\***.  
- Cross-filter direction: **Single** (dimension filters fact).  
- **Make this relationship active** — checked.

### Step B3 — What not to connect

1. Do **not** create a relationship between `FactSales` and `FactOpportunity` (no fact-to-fact).  
2. Do **not** relate `DimRegion` to `DimSalesperson` (would create ambiguous filter paths to `FactSales` — see Part F note).

### Step B4 — Checkpoint

In **Manage relationships**, you should see **exactly seven** active relationships matching the table above.

---

## Part C — Date table and hierarchies (15 min)

### Step C1 — Mark the date table

1. In **Model view** or **Data view**, click table **`DimDate`**.  
2. **Table tools → Mark as date table → Mark as date table**.  
3. Date column: **`FullDate`**. Confirm **OK**.

### Step C2 — Hide surrogate keys (report view)

1. In **Model view**, select key columns on facts/dims (`DateKey`, `CustomerKey`, etc.).  
2. Right-click → **Hide in report view** (optional now; Part E repeats for remaining keys).

### Step C3 — Hierarchy: Calendar on `DimDate`

1. In **Model view**, right-click **`DimDate` → New hierarchy**. Name **`Calendar`**.  
2. Drag columns into the hierarchy in order: **`Year` → `Month` → `FullDate`** (use `MonthName` instead of `Month` if `Month` is not in your CSV — prefer numeric month for sorting in Part E).

### Step C4 — Hierarchy: Product on `DimProduct`

1. New hierarchy **`Product`**: **`Category` → `ProductName`**.

### Step C5 — Hierarchy: Geography on `DimRegion`

1. New hierarchy **`Geography`**: **`RegionName`** only.

**Checkpoint:** **Table tools** on `DimDate` shows **Marked as date table**. Two or three hierarchies visible in the fields list.

---

## Part D — Measures vs calculated columns (20 min)

**Goal:** Add **measures** (filter context) on facts and one **calculated column** (row context) for teaching contrast.

### Step D1 — Where to create measures

1. In **Report view** or **Data view**, select table **`FactSales`**.  
2. **Table tools → New measure** (or **Home → New measure**).  
3. Paste DAX, press **Enter**, name the measure exactly as shown.

Repeat for each measure below. Optionally create an empty **`_Measures`** table ( **Enter data** → single column → delete column → rename table `_Measures`) and create all measures there — either location is fine for this lab.

### Step D2 — Measures on `FactSales`

```dax
Total Revenue = SUM ( FactSales[Revenue] )
```

```dax
Sale Count = COUNTROWS ( FactSales )
```

```dax
Avg Deal Size = DIVIDE ( [Total Revenue], [Sale Count] )
```

### Step D3 — Calculated column on `FactSales` (contrast)

**Column tools → New column**:

```dax
Revenue per Unit = DIVIDE ( FactSales[Revenue], FactSales[Quantity] )
```

In your notes (one sentence each): why **Total Revenue** must be a **measure**; why **Revenue per Unit** is a **column** for row-level detail.

### Step D4 — Measures on `FactOpportunity`

```dax
Pipeline Value = SUM ( FactOpportunity[EstimatedValue] )
```

```dax
Won Opportunities =
CALCULATE (
    COUNTROWS ( FactOpportunity ),
    FactOpportunity[Stage] = "Won"
)
```

```dax
Win Rate =
DIVIDE (
    [Won Opportunities],
    COUNTROWS ( FactOpportunity )
)
```

### Step D5 — Validation checkpoint

1. **Report view** → insert **Card** → field **`Total Revenue`**.  
2. **Expected unfiltered:** **`533500`**.  
3. Optional: **Win Rate** ≈ **37.5%** (6 won / 16 opportunities).

Remove or keep the card for Part F.

---

## Part E — Business-friendly model design (10 min)

### Step E1 — Descriptions and folders

1. **`DimCustomer[CustomerName]`** — **Column tools → Description** (or Synonyms): “Account name”.  
2. Select all CRM measures → **Measure tools → Display folder** → **`CRM KPIs`**.

### Step E2 — Sort by column

1. Select **`DimDate[MonthName]`**.  
2. **Column tools → Sort by column → `Month`** (whole number).

### Step E3 — Hide remaining keys

Hide surrogate keys from report view where business names exist: `CustomerKey`, `ProductKey`, `SalespersonKey`, `RegionKey` on facts (if not already hidden).

**Checkpoint:** In the fields pane, measures appear under **`CRM KPIs`**; months sort in calendar order on a visual.

---

## Part F — Validate the model (15 min)

**Goal:** Prove filters flow along relationships; complete the validation matrix.

### Step F1 — Scratch report layout

Create a single report page (design not graded):

| Step | Visual | Fields |
|------|--------|--------|
| 1 | **Card** | `Total Revenue` |
| 2 | **Matrix** | Rows `DimRegion[RegionName]`, Values `Total Revenue` |
| 3 | **Matrix** | Rows `DimProduct[Category]`, Values `Total Revenue` |
| 4 | **Table** | `FactSales` columns + `DimCustomer[CustomerName]` |

### Step F2 — Expected numbers

- Region matrix rows sum to **`533500`** total.  
- **Four** regions appear.

### Step F3 — Relationship validation (submission)

Complete in your notes:

| Business question | Tables involved | Works? |
|-------------------|-----------------|--------|
| Revenue by region | DimRegion → DimCustomer → FactSales | |
| Revenue by salesperson | DimSalesperson → FactSales | |
| Pipeline by stage | FactOpportunity only | |
| Revenue by month | DimDate → FactSales | |

> **Modeling note:** Do **not** relate `DimRegion` to `DimSalesperson` — that would create two filter paths to `FactSales` (ambiguous). Use `DimSalesperson[RegionKey]` for reference only, or add `HomeRegion` as text without a second region dimension link.

---

## Part G — Import vs DirectQuery vs Direct Lake (10 min)

**Goal:** Written comparison only — **do not reconfigure** this `.pbix` unless your instructor asks.

### Step G1 — Fill in the table (in your notes)

| Mode | When to use for this CRM model | This lab |
|------|--------------------------------|----------|
| **Import** | Interactive dashboards, moderate size | **Default** — CSV import |
| **DirectQuery** | Very large facts, live warehouse | Optional: connect to `wh_m9_star` if you have Module 9 artifacts |
| **Direct Lake** | Lakehouse Delta + Fabric semantic model | Optional: document — no Delta source required here |

### Step G2 — One paragraph

Explain **Direct Lake** in your own words (semantic model on OneLake Delta without full Import copy).

### Optional — Fabric publish

If your tenant allows: **Publish** to workspace `M10_L01_<id>` and note **endorsement** / reusable semantic model concept.

---

## Submission

- `.pbix` file or screenshot of Model view  
- `[Total Revenue]` = **533500**  
- List of **7 relationships**  
- Measures vs calculated column explanation  
- Part G mode comparison  

---

## Cleanup

Keep `.pbix` for Module 11 DAX labs if your course continues; otherwise file per instructor.

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Revenue not 533500 | Confirm **`FactSales`** has **24** rows; remeasure on `FactSales[Revenue]` only |
| Cannot mark date table | Fix `DimDate[FullDate]` type to **Date**; no nulls in that column |
| Region matrix blank | Check relationship **DimRegion → DimCustomer → FactSales** chain is **active** and **single** |
| Ambiguous totals | Remove extra relationships between dimensions that touch the same fact |
| Wrong row counts | Re-import from **`Lab_01_CRM_Semantic_Model/data/`** only (not Module 11 multi-year sales) |

---

## Verify your work

| Check | Expected |
|-------|----------|
| Hands-on 10 | Reusable star-schema CRM semantic model |
| Total Revenue | 533500 |
| Win Rate (unfiltered) | 6/16 = 37.5% |
| Date table | Marked on `DimDate` |
| Hierarchies | Calendar + Product |