# Lab 01 — CRM reporting dashboards (Executives, Pipeline, Customer 360)

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Data in **`Lab_01_CRM_Reporting_Dashboards/data/`**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 120–150 minutes |
| Covers | **Modules 13–15** reporting topics; **Hands-on 13–15** in one report |
| Deliverable | `CRM_Reporting_L12.pbix` (3 pages + drill-through page) |
| Prerequisite | DAX from [Module 11 Lab 01](../../11%20-%20DAX%20Fundamentals/Lab_01_CRM_DAX_KPIs/Lab%2001%20-%20CRM%20DAX%20fundamentals%20and%20business%20KPIs.md) (measure list in Part A below) |

## Description

Build three linked report experiences: **Executive Sales** (KPIs and trends), **Pipeline analytics** (funnel and conversion), and **Customer 360** (profile and drill-through). Apply design principles, slicers, conditional formatting, interactions, bookmarks, buttons, tooltips, and a basic **mobile** layout.

---

## Part A — Model and measures (25 min)

1. New file `CRM_Reporting_L12.pbix`.  
2. Import all CSVs from **`data/`** (including **FactActivity**).  
3. Recreate relationships from Module 11 lab plus:

| From | To | Column |
|------|-----|--------|
| DimCustomer | FactActivity | CustomerKey |
| DimDate | FactActivity | ActivityDateKey |

4. Mark **DimDate** as date table.  
5. Add these measures (minimum set — copy from Module 11 if you already built them):

| Measure | Purpose |
|---------|---------|
| `Total Revenue` | SUM FactSales[Revenue] |
| `Revenue YTD` | TOTALYTD on DimDate |
| `Pipeline Value` | Open opportunities |
| `Win Rate` | Won / all opportunities |
| `Average Deal Size` | Revenue / sale count |
| `Target Achievement %` | YTD vs FactTarget |
| `Lead Conversion Rate` | Converted / leads |
| `Won Opportunities` / `Lost Opportunities` | CALCULATE counts |
| `Opportunity Count` | COUNTROWS FactOpportunity |

6. Save model. **Validation:** `Total Revenue` with no slicer = **909500** (2025+2026 sales in this dataset).

---

## Part B — Page 1: Executive Sales Dashboard (Hands-on 13) (40 min)

**Page name:** `Executive`

### Layout and KPIs

1. Four **Card** visuals: `Total Revenue` (2026 context via Year slicer), `Pipeline Value`, `Win Rate`, `Target Achievement %`.  
2. **Line chart:** Axis `DimDate[FullDate]` (month hierarchy), Values `Total Revenue` — trend.  
3. **Clustered bar:** `DimRegion[RegionName]` via DimCustomer relationship → `Total Revenue`.  
4. **Matrix:** Rows `DimCustomer[CustomerName]`, Values `Total Revenue`, `Sale Count` — **conditional formatting** data bars on revenue.  
5. **Slicer:** `DimDate[Year]` (default **2026**).

### Design principles

- Align titles left; consistent accent color; limit to **one** primary trend chart above the fold.  
- Place slicers in a left panel; KPI cards in one row.

### Drill-through

1. Add page **`Customer Detail`** (hidden in view).  
2. On Executive matrix, enable **Drill through → Customer Detail** using `DimCustomer[CustomerName]`.  
3. On drill page: cards for customer name/region, chart revenue by product, table of sales.

### Tooltips

Create **Tooltip** page `Region Tooltip`: small matrix Region + Top 3 customers by revenue. Assign as **Page tooltip** on the region bar chart.

### Interactions

**Format → Edit interactions:** KPI cards **do not filter** bar chart (let slicers drive context).

---

## Part C — Page 2: Pipeline Dashboard (Hands-on 14) (35 min)

**Page name:** `Pipeline`

### Funnel and stage analysis

1. **Clustered bar chart (horizontal):** `FactOpportunity[Stage]`, Values `Opportunity Count`, `Pipeline Value`.  
2. **Donut:** Won / Lost / Open counts.  
3. **KPI:** `Lead Conversion Rate`.  
4. **Matrix:** `DimSalesperson[SalespersonName]` × measures Revenue (from sales), `Won Opportunities`.  
5. **Line:** Opportunities by `ExpectedCloseDate` month (count) — *aging / cycle* view.

### Conversion narrative

Add text box: lead → opportunity flow described; link `Lead Conversion Rate` to funnel story.

### Bookmarks

| Bookmark | Actions |
|----------|---------|
| `All Stages` | Clear stage filters |
| `Open Pipeline Only` | Filter `Stage = Open` |
| `Won Deals` | Filter `Stage = Won` |

### Buttons

Insert **Button** → **Bookmark** on canvas to switch between `All Stages` and `Open Pipeline Only`.

### Actual vs target

**Gauge** or card comparing `Revenue YTD` to `Revenue Target` (from Module 11 measures).

---

## Part D — Page 3: Customer 360 (Hands-on 15) (35 min)

**Page name:** `Customer 360`

1. **Slicer:** `DimCustomer[CustomerName]` (single select).  
2. **Multi-row card:** CustomerName, Region (via RELATED region), Industry.  
3. **KPI cards:** Customer-specific `Total Revenue`, count of sales, count of opportunities, count of activities.  

Measures example:

```dax
Customer Revenue =
CALCULATE ( [Total Revenue] )
```

```dax
Activity Count =
COUNTROWS ( FactActivity )
```

4. **Bar chart:** Revenue by `DimProduct[ProductName]` (filter by slicer).  
5. **Table:** Opportunity stage and EstimatedValue for selected customer.  
6. **Table:** FactActivity ActivityType and date.

### Segmentation

Add **Clustered bar** of customers by revenue; highlight **top 3** with conditional formatting rule.

### Drill-through design

From Customer 360 table of opportunities, use **drill-through** to `Customer Detail` page (if not already) or duplicate detail visuals on same page below fold.

### Customer trends

**Line chart:** selected customer revenue by month (`DimDate`).

---

## Part E — Navigation, mobile, publish (15 min)

1. **Buttons** on Executive page: **Page navigation** → Pipeline, Customer 360.  
2. **Bookmark** `Reset All` — clear all slicers.  
3. **View → Mobile layout** on `Executive` — stack KPI cards vertically; note in submission what you adjusted.  
4. Optional **Publish** to workspace `M12_L01_<id>`.

### Visual selection cheat sheet (submission)

| Question | Visual you chose |
|----------|------------------|
| KPI single number | Card |
| Category comparison | Bar |
| Trend over time | Line |
| Stage breakdown | Bar / Donut |
| Detail listing | Table / Matrix |

---

## Submission

- `.pbix` with pages: Executive, Pipeline, Customer 360, Customer Detail (+ tooltip page)  
- Screenshot of bookmarks/buttons  
- Mobile layout screenshot (Executive)  
- Completed design checklist below  

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