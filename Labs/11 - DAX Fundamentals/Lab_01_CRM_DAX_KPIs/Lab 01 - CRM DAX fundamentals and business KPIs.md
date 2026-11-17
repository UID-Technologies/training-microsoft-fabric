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

1. Save new file `CRM_DAX_KPIs_L11.pbix`.  
2. Import nine CSVs: all `Dim*` plus `FactSales`, `FactOpportunity`, `FactLead`, `FactTarget`.  
3. Relationships (**single**, **active**, **one-to-many**):

| From | To | Column |
|------|-----|--------|
| DimRegion | DimCustomer | RegionKey |
| DimCustomer | FactSales | CustomerKey |
| DimProduct | FactSales | ProductKey |
| DimSalesperson | FactSales | SalespersonKey |
| DimDate | FactSales | DateKey |
| DimCustomer | FactOpportunity | CustomerKey |
| DimDate | FactOpportunity | DateKey |
| DimDate | FactLead | CreatedDateKey |
| DimDate | FactTarget | DateKey |

4. Mark **DimDate** as date table on **FullDate**.  
5. Hide surrogate keys from report view.

**Fact counts:** Sales **36** (12 in 2025 + 24 in 2026), Leads **20**, Targets **4**.

---

## Part B — Hands-on 11: core KPIs (35 min)

Create measures on **`FactSales`** or a dedicated **`_Measures`** table (recommended).

### Aggregations

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

*Teaching:* `Customer Count` lives in **filter context** from facts; `Customers With Sales` uses **context transition** via `CALCULATE`.

### Pipeline and win/loss (`FactOpportunity`)

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

Use **SWITCH** for a status label measure (optional):

```dax
Win Rate Band =
SWITCH (
    TRUE (),
    [Win Rate] >= 0.4, "Strong",
    [Win Rate] >= 0.25, "Watch",
    "Improve"
)
```

### Leads (`FactLead`)

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

**Check cards:** Total Revenue **909500**, Lead Conversion Rate **50%**, Win Rate **37.5%**.

### RELATED (calculated column — row context)

On `FactSales`:

```dax
Customer Name = RELATED ( DimCustomer[CustomerName] )
```

Explain in notes: **row context** in the column; why not use RELATED in a measure without iterator.

---

## Part C — CALCULATE and FILTER (15 min)

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

Compare results — same number; document when **FILTER** is required (complex conditions).

---

## Part D — Hands-on 12: time intelligence (30 min)

Use **DimDate[FullDate]** (marked date table).

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

**Expected YoY % (with default filter):** about **41.9%** (533500 vs 376000 in parallel periods — confirm in your file with a card).

### Actual vs target

```dax
Revenue Target =
SUM ( FactTarget[RevenueTarget] )
```

```dax
Target Achievement % =
DIVIDE ( [Revenue YTD], [Revenue Target] )
```

Target rows are **month-end** keys for Jan–Apr 2026; achievement ≈ **84.68%**.

---

## Part E — Ranking and percent of total (15 min)

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

On `DimProduct` context or matrix with ProductName:

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

---

## Part F — Validate and document context (10 min)

Add a matrix: **Rows** `DimDate[Year]`, **Values** `Total Revenue` → **2025: 376000**, **2026: 533500**.

In submission notes, one paragraph each:

- **Row context** vs **filter context**  
- What **CALCULATE** does to filter context  
- **Context transition** in `Customers With Sales`

---

## Part G — Storage mode (5 min)

One sentence: this lab uses **Import**; **DirectQuery** would send these DAX queries to the warehouse live (Module 10).

---

## Submission

- `.pbix` or measure list screenshot  
- All **Hands-on 11** and **12** measures named as in this lab  
- Validation table filled with your card values  

---

## Verify your work

| Hands-on | Measures |
|----------|----------|
| 11 | Total Revenue, Customer Count, Pipeline Value, Won/Lost, Win Rate, Avg Deal Size, Lead Conversion Rate |
| 12 | Revenue YTD, PY Revenue, YoY %, Target Achievement %, Salesperson Rank, Product Contribution % |