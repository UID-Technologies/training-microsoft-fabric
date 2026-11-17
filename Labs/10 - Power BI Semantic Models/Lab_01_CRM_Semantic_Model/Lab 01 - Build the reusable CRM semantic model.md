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

## Progress checklist

- [ ] Seven tables imported  
- [ ] Seven relationships configured  
- [ ] Date table marked; hierarchies created  
- [ ] Measures validated (**533500** revenue)  
- [ ] Relationship validation matrix complete  
- [ ] Storage mode comparison notes  

---

## Part A — Import tables (15 min)

1. New blank report → **File → Save As** `CRM_Semantic_Model_L10.pbix`.  
2. Import all seven CSVs from **`data/`** via **Text/CSV**.  
3. Rename queries to match file base names: `DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`.  
4. Set types: keys **Whole number**, `Revenue`/`EstimatedValue` **Decimal**, `DimDate[FullDate]` **Date**.  
5. **Close & Apply**.  

**Row check:** `FactSales` **24**, `DimCustomer` **12**, `DimDate` **151**.

---

## Part B — Relationships and cardinality (25 min)

Open **Model view**. Arrange dimensions around facts.

Create **active**, **single** cross-filter, **one-to-many** relationships:

| From (1) | To (*) | Join columns |
|----------|--------|----------------|
| DimRegion | DimCustomer | RegionKey |
| DimCustomer | FactSales | CustomerKey |
| DimProduct | FactSales | ProductKey |
| DimSalesperson | FactSales | SalespersonKey |
| DimDate | FactSales | DateKey |
| DimCustomer | FactOpportunity | CustomerKey |
| DimDate | FactOpportunity | DateKey |

**Validate business relationships:**

1. `DimRegion[RegionName]` filters sales revenue (use matrix later).  
2. No relationship between the two fact tables (**no fact-to-fact**).  
3. Confirm **1** and ***** on each link.

---

## Part C — Date table and hierarchies (15 min)

1. Select `DimDate` → **Table tools → Mark as date table** → **FullDate** as date column.  
2. Hide `DateKey` from report view (optional: **Model view → hide** key fields).  
3. On `DimDate`, create hierarchy **Calendar**: **Year → Month → FullDate**.  
4. On `DimProduct`, hierarchy **Product**: **Category → ProductName**.  
5. On `DimRegion`, hierarchy **Geography**: **RegionName** only (extend with customer name in reports if needed).

---

## Part D — Measures vs calculated columns (20 min)

### Measures (add on `FactSales`)

```dax
Total Revenue = SUM ( FactSales[Revenue] )
```

```dax
Sale Count = COUNTROWS ( FactSales )
```

```dax
Avg Deal Size = DIVIDE ( [Total Revenue], [Sale Count] )
```

### Calculated column (teaching contrast)

On `FactSales`:

```dax
Revenue per Unit = DIVIDE ( FactSales[Revenue], FactSales[Quantity] )
```

In notes: why **Total Revenue** must be a **measure** (aggregates correctly) and why **Revenue per Unit** is often a column only for row-level detail.

### Opportunity measures (on `FactOpportunity`)

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

**Validation card:** `[Total Revenue]` = **533500**.

---

## Part E — Business-friendly model design (10 min)

1. **DimCustomer[CustomerName]** — set **Synonyms** or description: “Account name”.  
2. Organize fields: **Display folder** on measures → folder `CRM KPIs`.  
3. Sort `DimDate[MonthName]` by `DimDate[Month]` column.  
4. Hide surrogate keys from report view (`CustomerKey`, `ProductKey`, etc.) where business names exist.

---

## Part F — Validate the model (15 min)

Create a one-page scratch layout (not graded for design):

| Visual | Fields |
|--------|--------|
| Card | Total Revenue |
| Matrix | Rows `DimRegion[RegionName]`, Values Total Revenue |
| Matrix | Rows `DimProduct[Category]`, Values Total Revenue |
| Table | FactSales columns + `DimCustomer[CustomerName]` |

**Expected:** Region matrix sums to **533500**; four regions appear.

> **Modeling note:** Do **not** relate `DimRegion` to `DimSalesperson` — that would create two filter paths to `FactSales` (ambiguous). Use `DimSalesperson[RegionKey]` for reference only, or add `HomeRegion` as text without a second region dimension link.

Complete the **relationship validation** table in submission notes:

| Business question | Tables involved | Works? |
|-------------------|-----------------|--------|
| Revenue by region | DimRegion → DimCustomer → FactSales | |
| Revenue by salesperson | DimSalesperson → FactSales | |
| Pipeline by stage | FactOpportunity only | |
| Revenue by month | DimDate → FactSales | |

---

## Part G — Import vs DirectQuery vs Direct Lake (10 min)

| Mode | When to use for this CRM model | This lab |
|------|--------------------------------|----------|
| **Import** | Interactive dashboards, moderate size | **Default** — CSV import |
| **DirectQuery** | Very large facts, live warehouse | Optional: connect to `wh_m9_star` if you have Module 9 artifacts |
| **Direct Lake** | Lakehouse Delta + Fabric semantic model | Optional: document — no Delta source required here |

In notes: one paragraph on **Direct Lake** (semantic model on OneLake Delta without Import copy).

### Optional Fabric publish

If your tenant allows: **Publish** to workspace `M10_L01_<id>` and set semantic model as **reusable** (endorsement concept only).

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

## Verify your work

| Check | Expected |
|-------|----------|
| Hands-on 10 | Reusable star-schema CRM semantic model |
| Total Revenue | 533500 |
| Win Rate (unfiltered) | 6/16 = 37.5% |
| Date table | Marked on `DimDate` |
| Hierarchies | Calendar + Product |