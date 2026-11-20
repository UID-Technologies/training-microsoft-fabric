# Lab 01 — CRM DAX fundamentals and business KPIs

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). **Standalone** — no Module 9/10 artifacts required. Data only from **`Lab_01_CRM_DAX_KPIs/data/`**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 105–120 minutes |
| Covers | **Module 11** DAX fundamentals + syllabus **time intelligence** (**Hands-on 11 & 12**) |
| Platform | **Microsoft Fabric** + **Power BI on the web** (no Power BI Desktop required) |
| Hands-on | **11 & 12** — CRM KPI measures |
| Deliverable | Workspace `M11_L01_<id>` · Lakehouse `lh_m11_dax` · Semantic model `sm_m11_dax_<id>` · Report `rpt_m11_dax_<id>` |

## Description

Load nine CRM tables into a **Lakehouse**, connect a **semantic model** in Fabric, configure a **star-schema relationship layout** (with **no ambiguous paths**), then build **DAX measures** and validate them in a **web report** (cards, matrix, slicers). You practice **filter context**, **CALCULATE**, **time intelligence**, **ranking**, and **percent of total**.

## Standalone Fabric resources

Replace `<id>` with your initials (example: `js`).

| Resource | Name |
|----------|------|
| Workspace | `M11_L01_<id>` |
| Lakehouse | `lh_m11_dax` |
| Semantic model | `sm_m11_dax_<id>` |
| Report | `rpt_m11_dax_<id>` |

Sign in at **https://app.fabric.microsoft.com**. The workspace needs **Fabric capacity** (same as Modules 3–9). You only need rights to create Lakehouse, semantic model, and Power BI report items.

## How to work through this lab

| Part | What you are doing | Do not skip |
|------|-------------------|-------------|
| **A** | Lakehouse tables + semantic model + **relationships** | **Step A3** before any measures |
| **B** | Core KPI measures + one calculated column | Checkpoint cards after B2–B4 |
| **C** | `CALCULATE` vs `FILTER` | Compare two cards |
| **D** | Time intelligence + targets | Requires **marked date table** (A4) |
| **E** | Rank and contribution % | Matrix checkpoint |
| **F** | Year validation + written context notes | Submission paragraphs |
| **G** | Storage mode (Lakehouse / Direct Lake) | One paragraph |

1. Complete **Part A** end-to-end before **Part B**.  
2. In the browser, edit the **semantic model** for relationships and DAX; edit the **report** for cards and matrices (open report → build visuals; open semantic model item for model view and measures when your tenant separates them).  
3. Keep measure **names** exactly as in this guide (Module 12 reporting lab reuses them).

## Progress checklist

- [ ] Part A1–A2 — nine Delta tables in `lh_m11_dax` with correct row counts  
- [ ] Part A3 — **exactly nine** relationships; **forbidden links** not present  
- [ ] Part A4 — date table marked; keys hidden in report  
- [ ] Part B — cards: **909500**, **50%**, **37.5%**  
- [ ] Part C — `Revenue North` = `Revenue North FILTER syntax`  
- [ ] Part D — YTD, YoY, target ≈ **84.68%**  
- [ ] Part E — salesperson rank matrix  
- [ ] Part F — year matrix + context notes  
- [ ] Part G — Direct Lake / Import note  

## Validation baselines (unfiltered, full model)

| Measure | Expected (approx.) |
|---------|-------------------|
| Total Revenue (all years) | **909500** |
| Total Revenue (2026 only) | **533500** |
| Revenue YTD (2026, max date in data) | **533500** |
| Previous Year Revenue (same YTD window) | **376000** |
| Revenue targets (2026 Jan–Apr) | **630000** |
| Target Achievement % | **84.68%** |
| Lead Conversion Rate | **50%** (10 / 20) |
| Win Rate (opportunities) | **37.5%** |

---

## Part A — Model setup in Fabric (30–35 min)

**Goal:** Nine tables in the lakehouse, semantic model with all tables, **correct star relationships only**, marked date table. **No DAX measures until Part B.**

---

### Step A1 — Workspace and lakehouse

1. Open **https://app.fabric.microsoft.com**.  
2. **Workspaces** → select or create **`M11_L01_<id>`** (Fabric capacity assigned).  
3. **+ New item** → **Lakehouse** → name **`lh_m11_dax`** → **Create**.  
4. Open **`lh_m11_dax`**. Confirm you see **Files** and **Tables** in the explorer.

**Checkpoint:** Lakehouse opens without “capacity” errors.

---

### Step A2 — Upload CSVs and load Delta tables

**Goal:** Table names must match semantic model names: `DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`, `FactLead`, `FactTarget`.

#### A2.1 — Upload files

1. Under **Files**, create folder **`crm`**.  
2. From your PC, upload all nine CSVs from  
   **`Lab_01_CRM_DAX_KPIs/data/`**  
   into **`Files/crm/`** (keep file names unchanged).

#### A2.2 — Load each file to a Delta table

For **each** CSV (repeat nine times):

1. In the lakehouse, use **Get data** / **Load to Tables** / **New table from file** (wording varies — see [navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md)).  
2. Source: the file under **`Files/crm/`** (example: `DimRegion.csv`).  
3. Destination table name = file base name (example: **`DimRegion`**).  
4. Confirm **first row is header**, delimiter **comma**.  
5. **Create** / **Load**.  
6. Under **Tables**, confirm the new table appears.

**Notebook fallback** (if **Load to Tables** is missing): attach **`lh_m11_dax`**, run once:

```python
tables = [
    "DimRegion", "DimCustomer", "DimProduct", "DimSalesperson", "DimDate",
    "FactSales", "FactOpportunity", "FactLead", "FactTarget",
]
for name in tables:
    path = f"Files/crm/{name}.csv"
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(path))
    df.write.format("delta").mode("overwrite").saveAsTable(name)
    print(name, df.count())
```

#### A2.3 — Row count checkpoint (SQL analytics endpoint)

1. Open the lakehouse **SQL analytics endpoint** (or **SQL query** on the lakehouse).  
2. Run:

```sql
SELECT 'FactSales' AS T, COUNT(*) AS Cnt FROM FactSales
UNION ALL SELECT 'FactLead', COUNT(*) FROM FactLead
UNION ALL SELECT 'FactTarget', COUNT(*) FROM FactTarget
UNION ALL SELECT 'FactOpportunity', COUNT(*) FROM FactOpportunity;
```

| Table | Expected rows |
|-------|----------------|
| FactSales | **36** (2025 + 2026) |
| FactLead | **20** |
| FactTarget | **4** |
| FactOpportunity | **16** |

If **FactSales = 24**, you used the wrong folder — only **`Lab_01_CRM_DAX_KPIs/data/`**.

#### A2.4 — Semantic model with all tables

1. Return to workspace **`M11_L01_<id>`**.  
2. **+ New item** → **Semantic model** (or from **`lh_m11_dax`**: **Add to semantic model** / **Manage default semantic model** — use what your tenant shows).  
3. Name **`sm_m11_dax_<id>`**.  
4. **Get data** from the **Lakehouse** **`lh_m11_dax`** and select **all nine tables** listed in A2.2.  
5. Save the semantic model. Connection mode is often **Direct Lake** or **Import** depending on tenant — either is fine for this lab; note the mode in **Part G**.

**Checkpoint:** In the semantic model, the **Data** pane (or tables list) shows **nine** tables.

---

### Step A3 — Relationships (star schema, no ambiguity) (critical)

**Goal:** Create **exactly nine** active, single-direction, one-to-many relationships.  
**Many side (`*`)** = fact (or child dimension). **One side (`1`)** = dimension (parent).

This step is where learners often see **ambiguous relationship** or **inflated revenue** errors (same issue as the seven-relationship semantic model lab): too many paths between tables confuse filter propagation.

#### A3.0 — Open model view and remove bad auto-detect links

1. Open semantic model **`sm_m11_dax_<id>`** (open the **model**, not only the report).  
2. Switch to **Model view** (diagram icon).  
3. **Manage relationships** (or **Modeling → Manage relationships**).  
4. **Delete** every relationship that Fabric/Power BI auto-created **except** you will rebuild the nine correct ones below.  
   - Pay special attention to links involving **`RegionKey`** on multiple tables — auto-detect often adds wrong shortcuts.

#### A3.1 — Star layout (draw this in notes before you click)

```text
                    DimRegion (1)
                         |
                         | RegionKey
                         v
                    DimCustomer (1) --------+-------- FactOpportunity (*)
                         |                |              ^
         +---------------+                |              | DateKey
         | CustomerKey                     |              |
         v                CustomerKey       |         DimDate (1)
    FactSales (*)                           |
         ^                                  |
    DimProduct, DimSalesperson, DimDate     |
                                            FactLead (*), FactTarget (*)
                                            (both to DimDate only)
```

**Filter path for “Revenue by region”:** `DimRegion → DimCustomer → FactSales` only.  
**Not allowed:** `DimRegion` straight to `FactSales`, or `DimRegion → DimSalesperson`.

#### A3.2 — Relationships you must create (nine only)

Create in this order. For each row, use **New** in **Manage relationships** (or drag the **many-side key** onto the **one-side key**).

| # | One (`1`) — parent | Many (`*`) — child | Column (both sides) | Cross-filter |
|---|-------------------|-------------------|---------------------|--------------|
| 1 | `DimRegion` | `DimCustomer` | `RegionKey` | Single |
| 2 | `DimCustomer` | `FactSales` | `CustomerKey` | Single |
| 3 | `DimProduct` | `FactSales` | `ProductKey` | Single |
| 4 | `DimSalesperson` | `FactSales` | `SalespersonKey` | Single |
| 5 | `DimDate` | `FactSales` | `DateKey` | Single |
| 6 | `DimCustomer` | `FactOpportunity` | `CustomerKey` | Single |
| 7 | `DimDate` | `FactOpportunity` | `DateKey` | Single |
| 8 | `DimDate` | `FactLead` | `CreatedDateKey` | Single |
| 9 | `DimDate` | `FactTarget` | `DateKey` | Single |

**On every dialog, verify:**

- Cardinality: **One-to-many (1:* )** — parent is **1**, child is **\***.  
- Cross-filter direction: **Single** (parent filters child).  
- **Make this relationship active**: **Yes** / checked.  
- **Do not** enable bidirectional unless your instructor explicitly allows it (this lab uses **single** only).

**How to drag (if not using New):**  
Drag from **`FactSales[CustomerKey]`** → **`DimCustomer[CustomerKey]`**. The fact table must be on the **many** side. If the dialog shows the wrong direction, **swap** tables until `FactSales` is `*` and `DimCustomer` is `1`.

#### A3.3 — Forbidden relationships (do **not** create)

Creating any of these commonly causes **ambiguous paths** or **double-counted** revenue:

| Forbidden link | Why |
|----------------|-----|
| `DimRegion` → `FactSales` | Bypasses `DimCustomer`; conflicts with region-via-customer path |
| `DimRegion` → `DimSalesperson` | Two paths to `FactSales`: Region→Customer→Sales **and** Region→Salesperson→Sales |
| `DimRegion` → `FactOpportunity` | Ambiguous with Region→Customer→Opportunity |
| `DimSalesperson` → `DimCustomer` | Unnecessary bridge; risks multiple paths to facts |
| `FactSales` ↔ `FactOpportunity` | Fact-to-fact — never in a star schema |
| `FactSales` ↔ `FactLead` | Fact-to-fact |
| `DimCustomer` → `DimDate` | Wrong grain; dates filter facts through `DimDate` only |

`DimSalesperson` and `DimCustomer` both contain **`RegionKey`** in the CSV for **reference only**. The lab **does not** add a `DimRegion` → `DimSalesperson` relationship.

#### A3.4 — Why nine links are enough

| Business question | Tables on the filter path |
|--------------------|---------------------------|
| Revenue by region | `DimRegion` → `DimCustomer` → `FactSales` |
| Revenue by salesperson | `DimSalesperson` → `FactSales` |
| Revenue by month | `DimDate` → `FactSales` |
| Pipeline by stage | `FactOpportunity` (and slicers on `DimCustomer` / `DimDate`) |
| Leads over time | `DimDate` → `FactLead` |
| Targets vs actual | `DimDate` → `FactTarget` + measures on sales via `DimDate` → `FactSales` |

#### A3.5 — Checkpoint before Part B

1. **Manage relationships** shows **exactly 9** relationships — no extras.  
2. No warning badge on the model (wording: *ambiguous*, *many active paths*).  
3. **Create report** (or open existing) **`rpt_m11_dax_<id>`** from the semantic model.  
4. Add a **Matrix**: Rows **`DimRegion[RegionName]`**, Values — create a quick measure if needed: `Test Revenue = SUM(FactSales[Revenue])`.  
5. **Grand total must be 909500**, not a larger number. If the total is wrong, return to A3.3 and delete forbidden links.  
6. Remove `Test Revenue` after the check if you prefer (optional).

---

### Step A4 — Mark date table and hide keys

#### A4.1 — Mark `DimDate`

1. In the **semantic model**, select table **`DimDate`**.  
2. **Table properties** / **Mark as date table** → choose column **`FullDate`**.  
3. Confirm. Time intelligence in **Part D** fails without this step.

#### A4.2 — Hide surrogate keys (report-friendly)

For each hidden column: select column → **Hide in report view** (eye icon) or **Modeling → Hide**:

- On facts: `CustomerKey`, `ProductKey`, `SalespersonKey`, `DateKey`, `CreatedDateKey` as applicable.  
- On dimensions: hide keys if you display business names (`CustomerName`, `RegionName`, etc.).

**Checkpoint:** `DimDate` is marked; `FullDate` is type **Date** (fix in Power Query / semantic model data view if it imported as text).

---

### Step A5 — Create the web report shell

1. From **`sm_m11_dax_<id>`**, select **Create report** / **New report**.  
2. Name **`rpt_m11_dax_<id>`** when saving.  
3. **File → Save** (or autosave) in the workspace.  
4. Keep this report open for Parts **B–F** validation visuals.

**Part A complete when:** nine tables, nine relationships, date table marked, report saved.

---

## Part B — Hands-on 11: core KPIs (35 min)

**Goal:** Create measures in the **semantic model** (browser), validate with **Card** visuals in the **report**.  
**Where to edit DAX:** Open **`sm_m11_dax_<id>`** → select a table → **New measure** (or edit report → **Data** pane → right-click table → **New measure** if your UI allows inline).

### Step B1 — Home for measures

1. **Recommended:** Right-click any table → **New measure** and use table **`FactSales`** for sales measures, **`FactOpportunity`** for pipeline, **`FactLead`** for leads — **or** create measures on a dedicated table:  
   - **Enter data** / **New table** (if available) → blank → rename **`_Measures`** → create all measures there.  
2. Use **Display folder** `CRM KPIs` on measures when the property is available (optional).

### Step B2 — Aggregations (create in order, then validate)

Paste each formula as a **New measure**:

```dax
Total Revenue = SUM ( FactSales[Revenue] )
```

```dax
Sale Count = COUNTROWS ( FactSales )
```

```dax
Average Deal Size = DIVIDE ( [Total Revenue], [Sale Count] )
```

```dax
Customer Count =
DISTINCTCOUNT ( FactSales[CustomerKey] )
```

```dax
Customers With Sales =
CALCULATE (
    DISTINCTCOUNT ( DimCustomer[CustomerKey] ),
    FactSales
)
```

**Validate in report:** Insert **Card** → **`Total Revenue`**. No slicers → **909500**.

### Step B3 — Pipeline and win/loss

```dax
Pipeline Value =
CALCULATE (
    SUM ( FactOpportunity[EstimatedValue] ),
    FactOpportunity[Stage] = "Open"
)
```

```dax
Won Opportunities =
CALCULATE (
    COUNTROWS ( FactOpportunity ),
    FactOpportunity[Stage] = "Won"
)
```

```dax
Lost Opportunities =
CALCULATE (
    COUNTROWS ( FactOpportunity ),
    FactOpportunity[Stage] = "Lost"
)
```

```dax
Win Rate =
DIVIDE (
    [Won Opportunities],
    COUNTROWS ( FactOpportunity )
)
```

Optional:

```dax
Win Rate Band =
SWITCH (
    TRUE (),
    [Win Rate] >= 0.4, "Strong",
    [Win Rate] >= 0.25, "Watch",
    "Improve"
)
```

**Validate:** Card **`Win Rate`** ≈ **37.5%**.

### Step B4 — Leads

```dax
Lead Count = COUNTROWS ( FactLead )
```

```dax
Converted Leads =
CALCULATE (
    COUNTROWS ( FactLead ),
    FactLead[IsConverted] = 1
)
```

```dax
Lead Conversion Rate = DIVIDE ( [Converted Leads], [Lead Count] )
```

**Validate:** Card **`Lead Conversion Rate`** = **50%**.

### Step B5 — Calculated column (row context)

In the **semantic model**, table **`FactSales`** → **New column**:

```dax
Customer Name = RELATED ( DimCustomer[CustomerName] )
```

In notes (submission): **row context** in a column; **`RELATED`** is not used the same way in measures without iterators.

### Step B6 — Part B final checkpoint

On **`rpt_m11_dax_<id>`**, one row of three **Card** visuals: **909500**, **50%**, **37.5%**. **Save** the report.

---

## Part C — CALCULATE and FILTER (15 min)

**Goal:** Same numeric result, two filter syntaxes — proves filter context behavior.

### Step C1 — Create measures

```dax
Revenue North =
CALCULATE (
    [Total Revenue],
    DimRegion[RegionName] = "North"
)
```

```dax
Revenue North FILTER syntax =
CALCULATE (
    [Total Revenue],
    FILTER (
        ALL ( DimRegion ),
        DimRegion[RegionName] = "North"
    )
)
```

`Revenue North` only works if **Step A3** chain **`DimRegion → DimCustomer → FactSales`** is correct — not a shortcut from region directly to sales.

### Step C2 — Compare in the report

1. Two **Cards** side by side — values must **match**.  
2. In notes: when **`FILTER(ALL(...))`** is required (complex conditions, clearing multiple filters).

**Checkpoint:** Both cards show the same **North** revenue.

---

## Part D — Hands-on 12: time intelligence (30 min)

**Prerequisite:** **`DimDate`** marked in **Step A4**. All functions use **`DimDate[FullDate]`**.

### Step D1 — YTD / QTD / MTD

```dax
Revenue YTD =
TOTALYTD ( [Total Revenue], DimDate[FullDate] )
```

```dax
Revenue QTD =
TOTALQTD ( [Total Revenue], DimDate[FullDate] )
```

```dax
Revenue MTD =
TOTALMTD ( [Total Revenue], DimDate[FullDate] )
```

**Validate:** Add **Slicer** → **`DimDate[Year]`** → select **2026** → **`Revenue YTD`** card ≈ **533500**.

### Step D2 — Prior year and YoY

```dax
Previous Year Revenue =
CALCULATE (
    [Total Revenue],
    SAMEPERIODLASTYEAR ( DimDate[FullDate] )
)
```

```dax
Revenue YoY % =
VAR _CY = [Revenue YTD]
VAR _PY = [Previous Year Revenue]
RETURN DIVIDE ( _CY - _PY, _PY )
```

**Validate:** **`Previous Year Revenue`** ≈ **376000** with 2026 context; **`Revenue YoY %`** ≈ **41.9%**.

### Step D3 — Actual vs target

```dax
Revenue Target =
SUM ( FactTarget[RevenueTarget] )
```

```dax
Target Achievement % =
DIVIDE ( [Revenue YTD], [Revenue Target] )
```

**Validate:** **`Target Achievement %`** ≈ **84.68%** (targets Jan–Apr 2026 on `FactTarget`).

### Step D4 — Year slicer check

| Slicer `DimDate[Year]` | `Total Revenue` |
|------------------------|-----------------|
| 2025 | **376000** |
| 2026 | **533500** |

**Checkpoint:** Save report after adding slicer tests.

---

## Part E — Ranking and percent of total (15 min)

### Step E1 — Salesperson measures

```dax
Salesperson Revenue =
CALCULATE (
    [Total Revenue],
    KEEPFILTERS ( DimSalesperson )
)
```

```dax
Salesperson Rank =
RANKX (
    ALL ( DimSalesperson[SalespersonName] ),
    [Salesperson Revenue],
    ,
    DESC,
    Dense
)
```

### Step E2 — Product contribution

```dax
Product Revenue =
CALCULATE ( [Total Revenue] )
```

```dax
Product Contribution % =
DIVIDE (
    [Product Revenue],
    CALCULATE ( [Total Revenue], ALLSELECTED ( DimProduct ) )
)
```

### Step E3 — Checkpoint

**Matrix:** Rows **`DimSalesperson[SalespersonName]`**, Values **`Salesperson Revenue`**, **`Salesperson Rank`**.

---

## Part F — Validate and document context (10 min)

### Step F1 — Year matrix

**Matrix:** Rows **`DimDate[Year]`**, Values **`Total Revenue`**.

| Year | Expected |
|------|----------|
| 2025 | **376000** |
| 2026 | **533500** |

### Step F2 — Submission notes (one short paragraph each)

- **Row context** vs **filter context**  
- What **CALCULATE** changes in filter context  
- **Context transition** in `Customers With Sales`

Screenshot the matrix and at least three KPI cards for submission.

---

## Part G — Storage mode (5 min)

In notes (two or three sentences):

- How your **`sm_m11_dax_<id>`** connects to **`lh_m11_dax`** (**Direct Lake** vs **Import**).  
- What changes for DAX if the model were **DirectQuery** to a warehouse instead (queries run on the source).

---

## Submission

- Workspace and item names (`M11_L01_<id>`, `lh_m11_dax`, `sm_m11_dax_<id>`, `rpt_m11_dax_<id>`)  
- Screenshot of **Model view** showing **nine** relationships  
- Screenshot of relationship list (**Manage relationships**)  
- Report screenshots: KPI cards, year matrix, North revenue pair  
- List of all measure names from Parts B–E  
- Part F context paragraphs + Part G storage note  

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Revenue **much larger than 909500** | **Ambiguous paths** — remove `DimRegion`→`FactSales`, `DimRegion`→`DimSalesperson`, fact-to-fact links (A3.3) |
| Region matrix shows wrong total | Only path: **`DimRegion` → `DimCustomer` → `FactSales`**; delete shortcuts |
| `Revenue North` blank or wrong | Fix relationship #1 and #2; confirm region names in `DimRegion` |
| **Manage relationships** shows 10+ rows | Delete auto-detect extras; keep only A3.2 nine |
| Many-to-many icon | Swap tables so facts are `*`; cardinality **1:* ** |
| Total Revenue **533500** not **909500** | Wrong CSV folder — need **36** sales rows in Module 11 `data/` |
| YTD / `TOTALYTD` error | **Mark date table** on `DimDate[FullDate]` (A4) |
| Target Achievement blank | Relationship #9 `DimDate` → `FactTarget` on **`DateKey`**; four rows in `FactTarget` |
| `RELATED` column error | Relationship #2 `DimCustomer` → `FactSales` on **`CustomerKey`** |
| Cannot edit model in browser | Open **`sm_m11_dax_<id>`** item directly; ask instructor if only Desktop is enabled |
| Lakehouse load fails | Use notebook fallback in A2.2; verify paths `Files/crm/*.csv` |

---

## Verify your work

| Hands-on | Measures / evidence |
|----------|---------------------|
| 11 | Total Revenue, Customer Count, Pipeline Value, Won/Lost, Win Rate, Avg Deal Size, Lead Conversion Rate |
| 12 | Revenue YTD, PY Revenue, YoY %, Target Achievement %, Salesperson Rank, Product Contribution % |
| Model | **9** relationships, no forbidden links, grand total revenue **909500** |