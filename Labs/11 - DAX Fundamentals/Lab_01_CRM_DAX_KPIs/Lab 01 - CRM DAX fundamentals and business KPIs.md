# Lab 01 — CRM DAX fundamentals and business KPIs

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). New blank `.pbix`; **`Lab_01_CRM_DAX_KPIs/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 105–120 minutes |
| Covers | **Module 11** DAX fundamentals + **Module 12** time intelligence (single lab) |
| Hands-on | **11 & 12** — CRM KPI measures |
| Deliverable | `CRM_DAX_KPIs_L11.pbix` |
| Platform | Power BI Desktop |

## Description

Import the CRM star-schema tables, build **fundamental** and **time-intelligence** **measures**, and practice **filter context**, **CALCULATE**, **variables**, **ranking**, and **percent of total**. Validates pipeline, win/loss, lead conversion, YTD, YoY, targets, and contribution KPIs.

## How to work through this lab

1. Complete **Part A** fully (including **mark date table**) before **Part D** time intelligence.  
2. Create measures in **Part B** in order — run the **checkpoint cards** after each block.  
3. Use the same measure **names** as this document (Module 12 reporting lab references them).  
4. **Part C–G** add filter context, time intelligence, ranking, validation notes, and storage mode.

## Progress checklist

- [ ] Part A — nine tables, nine relationships, date table marked  
- [ ] Part B — core KPIs; cards: **909500**, **50%**, **37.5%**  
- [ ] Part C — `Revenue North` vs FILTER syntax match  
- [ ] Part D — YTD, PY, YoY %, target achievement ≈ **84.68%**  
- [ ] Part E — rank + product contribution %  
- [ ] Part F — year matrix + context notes  
- [ ] Part G — Import vs DirectQuery sentence  

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

## Part A — Model setup (20 min)

**Goal:** Same star layout as Module 10, plus **FactLead**, **FactTarget**, and date links. **No measures until Part B.**

### Step A1 — Save a new file

1. Power BI Desktop → **File → Save As** → **`CRM_DAX_KPIs_L11.pbix`**.

### Step A2 — Import nine CSVs

From **`Lab_01_CRM_DAX_KPIs/data/`** via **Get data → Text/CSV**:

`DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`, `FactLead`, `FactTarget`

Set key columns to **Whole number**, revenue/target fields to **decimal**, `DimDate[FullDate]` to **Date**. **Close & Apply**.

### Step A3 — Create relationships (order matters for less clutter)

**Model view** → create **active**, **single**, **one-to-many** (dimension **1**, fact **\***):

| # | From (1) | To (*) | Column |
|---|----------|--------|--------|
| 1 | DimRegion | DimCustomer | RegionKey |
| 2 | DimCustomer | FactSales | CustomerKey |
| 3 | DimProduct | FactSales | ProductKey |
| 4 | DimSalesperson | FactSales | SalespersonKey |
| 5 | DimDate | FactSales | DateKey |
| 6 | DimCustomer | FactOpportunity | CustomerKey |
| 7 | DimDate | FactOpportunity | DateKey |
| 8 | DimDate | FactLead | CreatedDateKey |
| 9 | DimDate | FactTarget | DateKey |

### Step A4 — Mark date table and hide keys

1. Select **`DimDate`** → **Table tools → Mark as date table** → **`FullDate`**.  
2. Hide surrogate keys from report view on facts (CustomerKey, DateKey, etc.).

### Step A5 — Row count checkpoint

| Table | Expected rows |
|-------|----------------|
| FactSales | **36** (2025 + 2026) |
| FactLead | **20** |
| FactTarget | **4** |
| FactOpportunity | **16** |

If `FactSales` is **24**, you imported Module 10 data by mistake — use **`Lab_01_CRM_DAX_KPIs/data/`** only.

---

## Part B — Hands-on 11: core KPIs (35 min)

**Goal:** Build aggregation, pipeline, and lead measures. Validate with cards before Part C.

### Step B1 — Create a home for measures (recommended)

1. **Home → Enter data** → load a blank row → **Transform** → delete the column → rename table **`_Measures`**.  
2. Select **`_Measures`** → use **New measure** for all measures below (keeps fact tables clean).

Alternatively, create measures on **`FactSales`** — names must still match this lab.

### Step B2 — Aggregations (create in order)

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

**Checkpoint:** Card **`Total Revenue`** = **909500** (no slicers).

### Step B3 — Pipeline and win/loss (`FactOpportunity`)

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

**Checkpoint:** **`Win Rate`** ≈ **37.5%**.

### Step B4 — Leads (`FactLead`)

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

**Checkpoint:** **`Lead Conversion Rate`** = **50%**.

### Step B5 — RELATED calculated column (row context)

On **`FactSales`** → **New column**:

```dax
Customer Name = RELATED ( DimCustomer[CustomerName] )
```

In notes: **row context** in the column; do not use `RELATED` in a measure without an iterator.

### Step B6 — Part B final checkpoint

Three cards on one page: **Total Revenue 909500**, **Lead Conversion Rate 50%**, **Win Rate 37.5%**.

---

## Part C — CALCULATE and FILTER (15 min)

**Goal:** Two equivalent ways to filter **North** region — document when FILTER is required.

### Step C1 — Create both measures

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

### Step C2 — Compare

1. Two **Card** visuals side by side — values must **match**.  
2. In notes: one example when **FILTER** is required (complex OR conditions, removing multiple filters, etc.).

---

## Part D — Hands-on 12: time intelligence (30 min)

**Prerequisite:** **`DimDate`** is **marked** (Part A). Time functions use **`DimDate[FullDate]`**.

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

**Checkpoint:** With no year slicer, **`Revenue YTD`** at max calendar date in data ≈ **533500** for 2026 window (confirm with your **`DimDate[Year]`** slicer set to **2026**).

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

**Checkpoint:** Card **`Previous Year Revenue`** ≈ **376000** with 2026 context; **`Revenue YoY %`** ≈ **41.9%** (confirm in your file).

### Step D3 — Actual vs target

```dax
Revenue Target =
SUM ( FactTarget[RevenueTarget] )
```

```dax
Target Achievement % =
DIVIDE ( [Revenue YTD], [Revenue Target] )
```

Target rows are month-end keys for **Jan–Apr 2026**; **`Target Achievement %`** ≈ **84.68%**.

### Step D4 — Verify years

Slicer **`DimDate[Year]`** = **2026** → **`Total Revenue`** = **533500**. Year **2025** alone → **376000**.

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

**Matrix:** Rows `DimSalesperson[SalespersonName]`, values `Salesperson Revenue`, `Salesperson Rank` — ranks 1–4 with no ties if data matches lab CSV.

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
- What **CALCULATE** does to filter context  
- **Context transition** in `Customers With Sales`

---

## Part G — Storage mode (5 min)

In notes: this lab uses **Import**; **DirectQuery** would send DAX to the warehouse live (see Module 10 Part G).

---

## Submission

- `.pbix` or measure list screenshot  
- All **Hands-on 11** and **12** measures named as in this lab  
- Validation table filled with your card values  

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Total Revenue is 533500 not 909500 | Wrong `FactSales` file — use Module 11 **`data/`** (36 rows) |
| YTD / TOTALYTD error | Mark **`DimDate`**; use **`FullDate`** in time functions |
| Target Achievement blank | Relationship **`DimDate` → `FactTarget`** on **DateKey**; four target rows |
| Revenue North wrong | **`DimRegion` → `DimCustomer` → `FactSales`** chain active |
| Lead conversion not 50% | `FactLead[IsConverted]` = 1 for 10 rows; 20 lead rows total |
| RELATED column errors | Relationship **DimCustomer → FactSales** on **CustomerKey** |

---

## Verify your work

| Hands-on | Measures |
|----------|----------|
| 11 | Total Revenue, Customer Count, Pipeline Value, Won/Lost, Win Rate, Avg Deal Size, Lead Conversion Rate |
| 12 | Revenue YTD, PY Revenue, YoY %, Target Achievement %, Salesperson Rank, Product Contribution % |