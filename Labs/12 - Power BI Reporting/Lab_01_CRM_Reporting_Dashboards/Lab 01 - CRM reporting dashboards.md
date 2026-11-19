# Lab 01 — CRM reporting dashboards (Executives, Pipeline, Customer 360)

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Data in **`Lab_01_CRM_Reporting_Dashboards/data/`**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 120–150 minutes |
| Covers | **Modules 13–15** reporting topics; **Hands-on 13–15** in one report |
| Deliverable | `CRM_Reporting_L12.pbix` (3 pages + drill-through page) |
| Prerequisite | DAX from [Module 11 Lab 01](../../11%20-%20DAX%20Fundamentals/Lab_01_CRM_DAX_KPIs/Lab%2001%20-%20CRM%20DAX%20fundamentals%20and%20business%20KPIs.md) **or** build measures in **Part A2** below |

## Description

Build three linked report experiences: **Executive Sales** (KPIs and trends), **Pipeline analytics** (funnel and conversion), and **Customer 360** (profile and drill-through). Apply design principles, slicers, conditional formatting, interactions, bookmarks, buttons, tooltips, and a basic **mobile** layout.

## How to work through this lab

1. Finish **Part A** (model + measures) before building report pages.  
2. Create **support pages first**: `Customer Detail`, `Region Tooltip` (hidden), then **Executive → Pipeline → Customer 360**.  
3. After each part, use the **checkpoint** list for that page.  
4. Measure names must match Module 11 where possible so checkpoints align.

## Progress checklist

- [ ] Part A1 — ten tables imported, eleven relationships  
- [ ] Part A2 — minimum measures; **Total Revenue** = **909500**  
- [ ] Part B — Executive + drill-through + tooltip + interactions  
- [ ] Part C — Pipeline + bookmarks + buttons + target visual  
- [ ] Part D — Customer 360 + segmentation + trends  
- [ ] Part E — nav buttons, Reset bookmark, mobile layout  
- [ ] Design checklist completed for submission  

---

## Part A — Model and measures (25 min)

### Part A1 — Import and relationships (15 min)

#### Step A1 — Save file

**File → Save As** → **`CRM_Reporting_L12.pbix`**.

#### Step A2 — Import ten CSVs

From **`Lab_01_CRM_Reporting_Dashboards/data/`**:

`DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`, `FactLead`, `FactTarget`, `FactActivity`

Set types (keys whole number, revenue/decimals fixed decimal, `FullDate` date). **Close & Apply**.

#### Step A3 — Relationships (eleven total)

Same nine as Module 11 Lab Part A, **plus**:

| From (1) | To (*) | Column |
|----------|--------|--------|
| DimCustomer | FactActivity | CustomerKey |
| DimDate | FactActivity | ActivityDateKey |

Mark **`DimDate`** as date table on **`FullDate`**. Hide surrogate keys.

**Checkpoint:** `FactSales` **36** rows; `FactActivity` loads without errors.

---

### Part A2 — Minimum measures (10 min)

If you completed **Module 11**, copy measures into this file (or **reuse** that `.pbix` and add `FactActivity` + relationships above).

If starting fresh, create **`_Measures`** table and add these measures **in order** (names must match):

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
Revenue YTD = TOTALYTD ( [Total Revenue], DimDate[FullDate] )
```

```dax
Revenue Target = SUM ( FactTarget[RevenueTarget] )
```

```dax
Target Achievement % = DIVIDE ( [Revenue YTD], [Revenue Target] )
```

```dax
Pipeline Value =
CALCULATE (
    SUM ( FactOpportunity[EstimatedValue] ),
    FactOpportunity[Stage] = "Open"
)
```

```dax
Opportunity Count = COUNTROWS ( FactOpportunity )
```

```dax
Won Opportunities =
CALCULATE ( COUNTROWS ( FactOpportunity ), FactOpportunity[Stage] = "Won" )
```

```dax
Lost Opportunities =
CALCULATE ( COUNTROWS ( FactOpportunity ), FactOpportunity[Stage] = "Lost" )
```

```dax
Win Rate = DIVIDE ( [Won Opportunities], [Opportunity Count] )
```

```dax
Lead Count = COUNTROWS ( FactLead )
```

```dax
Converted Leads =
CALCULATE ( COUNTROWS ( FactLead ), FactLead[IsConverted] = 1 )
```

```dax
Lead Conversion Rate = DIVIDE ( [Converted Leads], [Lead Count] )
```

**Part A checkpoint:** Card **`Total Revenue`** (no slicers) = **909500**. Save the `.pbix`.

---

## Part B — Page 1: Executive Sales Dashboard (Hands-on 13) (40 min)

**Page name:** **`Executive`**

### Step B1 — Rename page and set canvas

1. Right-click report page tab → **Rename** → **`Executive`**.  
2. Optional: **View → Page view → Fit to page**.

### Step B2 — Slicer first (drives context)

1. Insert **Slicer** → field **`DimDate[Year]`**.  
2. In slicer, select **2026** (single-year dashboard default).

### Step B3 — KPI row (four cards)

Insert **Card** for each (same row):

| Card | Field |
|------|--------|
| 1 | `Total Revenue` (shows 2026 when Year slicer = 2026 → **533500**) |
| 2 | `Pipeline Value` |
| 3 | `Win Rate` |
| 4 | `Target Achievement %` |

Format titles clearly (e.g. “Total Revenue (2026)”).

### Step B4 — Trend and region

1. **Line chart:** X-axis **`DimDate[FullDate]`** (or **Calendar** hierarchy at month level), Y-axis **`Total Revenue`**.  
2. **Clustered bar chart:** Axis **`DimRegion[RegionName]`**, Values **`Total Revenue`**.  
   - Revenue filters through **DimCustomer** (do not add `DimRegion` directly to `FactSales`).

### Step B5 — Customer matrix + conditional formatting

1. **Matrix:** Rows **`DimCustomer[CustomerName]`**, Values **`Total Revenue`**, **`Sale Count`**.  
2. Select matrix → **Format → Cells → Conditional formatting → Data bars** on **`Total Revenue`**.

### Step B6 — Design layout

- Titles left-aligned; one accent color.  
- Slicers in a **left column**; KPIs in **one row** at top; primary trend chart “above the fold”.

### Step B7 — Customer Detail page (drill-through)

1. **Insert → New page** → rename **`Customer Detail`**.  
2. **Format page → Page information → Allow use as drillthrough** → **On**.  
3. **Drillthrough filter:** **`DimCustomer[CustomerName]`** (add field to drillthrough well on this page).  
4. On **`Customer Detail`**, add:  
   - Cards: customer name, region (use `DimCustomer` + `DimRegion[RegionName]`),  
   - Bar chart: **`Total Revenue` by `DimProduct[ProductName]`**,  
   - Table: `FactSales` columns for the customer.  
5. On **`Executive`** matrix, right-click a customer → **Drill through → Customer Detail** to test.

### Step B8 — Region tooltip page

1. New page → rename **`Region Tooltip`**.  
2. **Format page → Page information → Tooltip** → **On**. Resize canvas small (e.g. 320×240).  
3. **Matrix:** Rows **`DimRegion[RegionName]`**, **`DimCustomer[CustomerName]`**, Values **`Total Revenue`**.  
   - Optional: Top N filter on customers per region for “top 3” story.  
4. On **`Executive`** region **bar chart** → **Format → General → Tooltip → Type: Report page** → **`Region Tooltip`**.

### Step B9 — Edit interactions

1. On **`Executive`**, select a **KPI card**.  
2. **Format → Edit interactions** (or **Format → Edit interactions** on ribbon).  
3. Click each other visual and set **card does not filter** charts (slicer still filters).  
4. End edit mode.

### Part B checkpoint

- [ ] Year **2026** → Total Revenue **533500**  
- [ ] Drill-through to **Customer Detail** works  
- [ ] Region bar shows **tooltip page** on hover  
- [ ] KPI cards do not filter bar/line when interaction set  

---

## Part C — Page 2: Pipeline Dashboard (Hands-on 14) (35 min)

**Page name:** **`Pipeline`**

### Step C1 — Funnel and stage visuals

1. **Clustered bar chart (horizontal):** Axis **`FactOpportunity[Stage]`**, Values **`Opportunity Count`**, **`Pipeline Value`**.  
2. **Donut chart:** Legend **`FactOpportunity[Stage]`**, Values **`Opportunity Count`** (Won / Lost / Open).  
3. **Card:** **`Lead Conversion Rate`**.

### Step C2 — Salesperson matrix

**Matrix:** Rows **`DimSalesperson[SalespersonName]`**, Values **`Total Revenue`**, **`Won Opportunities`**.

### Step C3 — Opportunities over time

**Line chart:** Axis **`DimDate[FullDate]`** at **month** level (relationship **`DimDate` → `FactOpportunity`** on **DateKey**), Values **`Opportunity Count`**. This shows how opportunities distribute across months in the sample data.

### Step C4 — Narrative

**Insert → Text box** — short lead → opportunity story; reference **`Lead Conversion Rate`**.

### Step C5 — Bookmarks (record filter state)

1. Set visuals to **All stages** visible (clear any stage slicer filters).  
2. **View → Bookmarks pane → Add** → name **`All Stages`**.  
3. Add slicer or filter **`FactOpportunity[Stage]`** = **Open** → **Add bookmark** → **`Open Pipeline Only`**.  
4. Filter **Won** → **Add bookmark** → **`Won Deals`**.  
5. For each bookmark: **⋯ → Update** after changing filters; uncheck **Data** if you only want visual state per instructor preference (default: include **Data**).

### Step C6 — Bookmark buttons

1. **Insert → Buttons → Navigator → Bookmark** (or Button → Bookmark).  
2. Assign **`All Stages`** and **`Open Pipeline Only`** to two buttons on the canvas.

### Step C7 — Actual vs target

**Gauge** (or two cards): **`Revenue YTD`** vs **`Revenue Target`**; or use **`Target Achievement %`** card.

### Part C checkpoint

- [ ] Donut shows Won / Lost / Open  
- [ ] Bookmarks switch stage filters  
- [ ] Buttons trigger bookmarks  
- [ ] Target visual shows YTD vs target  

---

## Part D — Page 3: Customer 360 (Hands-on 15) (35 min)

**Page name:** **`Customer 360`**

### Step D1 — Customer slicer and profile

1. **Slicer:** **`DimCustomer[CustomerName]`** (single select).  
2. **Multi-row card:** **`CustomerName`**, **`DimRegion[RegionName]`**, **`Industry`** (from `DimCustomer` / related region).

### Step D2 — Customer KPI measures

Create if missing:

```dax
Customer Revenue =
CALCULATE ( [Total Revenue] )
```

```dax
Activity Count =
COUNTROWS ( FactActivity )
```

**Cards (filtered by slicer):** `Customer Revenue`, `Sale Count`, `Opportunity Count`, `Activity Count`.

### Step D3 — Product and detail tables

1. **Bar chart:** **`DimProduct[ProductName]`**, **`Customer Revenue`**.  
2. **Table:** `FactOpportunity` — **Stage**, **EstimatedValue**, customer keys filtered by slicer.  
3. **Table:** `FactActivity` — **ActivityType**, date column.

### Step D4 — Segmentation bar

**Clustered bar:** All customers by **`Customer Revenue`**; **conditional formatting** → highlight **top 3** (rules or Top N filter).

### Step D5 — Drill-through

From opportunity table, ensure **drill through** to **`Customer Detail`** works, or duplicate detail visuals below the fold on this page.

### Step D6 — Customer trend line

**Line chart:** **`DimDate[FullDate]`** (month), **`Customer Revenue`**, controlled by customer slicer.

### Part D checkpoint

- [ ] Changing slicer updates all customer visuals  
- [ ] Activity table shows rows for selected customer  
- [ ] Monthly trend reflects one customer  

---

## Part E — Navigation, mobile, publish (15 min)

### Step E1 — Page navigation buttons

On **`Executive`**: **Insert → Buttons → Navigator → Page navigator** or two **Page navigation** buttons → targets **`Pipeline`**, **`Customer 360`**.

### Step E2 — Reset bookmark

1. Clear all slicers (Year, Customer, Stage).  
2. **Add bookmark** → **`Reset All`** — include **Data** and **Current page** only if you want reset to stay on current page.

### Step E3 — Mobile layout

1. **`Executive`** page → **View → Mobile layout**.  
2. Stack **KPI cards vertically**; place **Year slicer** at top.  
3. Note in submission what you moved.

### Step E4 — Optional publish

**Publish** to workspace `M12_L01_<id>` if tenant allows.

### Visual selection cheat sheet (submission)

| Question | Visual you chose |
|----------|------------------|
| KPI single number | Card |
| Category comparison | Bar |
| Trend over time | Line |
| Stage breakdown | Bar / Donut |
| Detail listing | Table / Matrix |

### Design checklist (complete for submission)

| Feature | Where implemented |
|---------|-------------------|
| Slicers | Year (Executive), Customer (360) |
| Conditional formatting | Executive matrix revenue bars |
| Drill-through | Customer Detail |
| Bookmarks + buttons | Pipeline |
| Report tooltip | Region bar on Executive |
| Edit interactions | Executive KPI vs charts |
| Mobile layout | Executive |

---

## Submission

- `.pbix` with pages: **Executive**, **Pipeline**, **Customer 360**, **Customer Detail** (+ **Region Tooltip**)  
- Screenshot of bookmarks/buttons  
- Mobile layout screenshot (Executive)  
- Completed **design checklist** table  

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Revenue 533500 on Executive with no slicer | Expected only when filtered to 2026 — check **Year** slicer or add one |
| Region bar empty | Use **`DimRegion[RegionName]`** with relationship through **DimCustomer** |
| Drill-through disabled | Target page **Allow use as drillthrough**; field in drillthrough well |
| Tooltip page not showing | Tooltip page **On**; assign on **region chart** tooltip type **Report page** |
| Bookmark does not change filters | Re-record bookmark with **Data** included; **Update** after filter change |
| YTD / Target broken | Mark **`DimDate`**; measures from **Part A2** |
| Activity Count zero | Relationships **DimCustomer → FactActivity**, **DimDate → FactActivity** |

---

## Verify your work

| Hands-on | Delivered on page |
|----------|-------------------|
| 13 Executive | Revenue, pipeline, win rate, deal size, target, trends, region/customer |
| 14 Pipeline | Funnel/stage, conversion, win/loss, salesperson, target |
| 15 Customer 360 | Profile, revenue, orders, opportunities, activities, products, drill-through |

| Design feature | Required |
|----------------|----------|
| Slicers | Year + Customer |
| Conditional formatting | Matrix revenue |
| Drill-through | Customer Detail |
| Bookmarks + buttons | Pipeline page |
| Report tooltip | Region chart |
| Edit interactions | KPI vs charts |
| Mobile layout | Executive page |