# Lab 01 — CRM reporting dashboards (Executives, Pipeline, Customer 360)

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). **Standalone** — no Module 11 file required. Data only from **`Lab_01_CRM_Reporting_Dashboards/data/`**.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 120–150 minutes |
| Covers | **Modules 13–15** reporting topics; **Hands-on 13–15** in one report |
| Platform | **Microsoft Fabric** + **Power BI on the web** (no Power BI Desktop required) |
| Deliverable | Workspace `M12_L01_<id>` · Lakehouse `lh_m12_rpt` · Semantic model `sm_m12_rpt_<id>` · Report `rpt_m12_rpt_<id>` |
| Pages | **Executive**, **Pipeline**, **Customer 360**, **Customer Detail**, **Region Tooltip** |

## Description

Build three linked **web report** experiences: **Executive Sales** (KPIs and trends), **Pipeline analytics** (funnel and conversion), and **Customer 360** (profile and drill-through). Apply design principles, slicers, conditional formatting, **edit interactions**, bookmarks, buttons, **report tooltips**, and a basic **mobile** layout — all in the Fabric/Power BI report editor.

## Standalone Fabric resources

Replace `<id>` with your initials (example: `js`).

| Resource | Name |
|----------|------|
| Workspace | `M12_L01_<id>` |
| Lakehouse | `lh_m12_rpt` |
| Semantic model | `sm_m12_rpt_<id>` |
| Report | `rpt_m12_rpt_<id>` |

Sign in at **https://app.fabric.microsoft.com**. If you already built [Module 11](../../11%20-%20DAX%20Fundamentals/Lab_01_CRM_DAX_KPIs/Lab%2001%20-%20CRM%20DAX%20fundamentals%20and%20business%20KPIs.md) measures in another workspace, you may still follow **this** lab in a **new** workspace so submission is self-contained — recreate measures in **Part A6** below.

## How to work through this lab

| Part | Focus | Order note |
|------|--------|------------|
| **A** | Lakehouse → semantic model → **11 relationships** → measures | Complete **A3** before pages |
| **B** | Executive + **Customer Detail** + **Region Tooltip** | Build tooltip/drill pages during B |
| **C** | Pipeline + bookmarks + buttons | |
| **D** | Customer 360 + segmentation | |
| **E** | Navigation, Reset bookmark, mobile layout | |

1. Finish **Part A** checkpoint (**Total Revenue = 909500**) before **Part B**.  
2. Create pages in the **report** item; edit **relationships and DAX** in the **semantic model** item.  
3. Measure names match Module 11 where listed so instructors can use one rubric.

## Progress checklist

- [ ] Part A — ten Delta tables, **eleven** relationships, date table marked  
- [ ] Part A — measures + **Total Revenue = 909500**  
- [ ] Part B — Executive + drill-through + tooltip + interactions  
- [ ] Part C — Pipeline + bookmarks + buttons + target visual  
- [ ] Part D — Customer 360 + trends + activities  
- [ ] Part E — nav buttons, **Reset All**, mobile layout  
- [ ] Design checklist completed for submission  

---

## Part A — Model and measures (35–40 min)

**Goal:** Ten tables in the lakehouse, semantic model, **exactly eleven** star relationships (no ambiguity), minimum DAX, one validation report page before dashboard work.

---

### Step A1 — Workspace and lakehouse

1. **https://app.fabric.microsoft.com** → workspace **`M12_L01_<id>`** (create if needed; Fabric capacity required).  
2. **+ New item** → **Lakehouse** → **`lh_m12_rpt`** → **Create**.

---

### Step A2 — Upload CSVs and load Delta tables

#### A2.1 — Upload

1. In **`lh_m12_rpt`**, under **Files**, create folder **`crm`**.  
2. Upload **ten** CSVs from **`Lab_01_CRM_Reporting_Dashboards/data/`**:  
   `DimRegion`, `DimCustomer`, `DimProduct`, `DimSalesperson`, `DimDate`, `FactSales`, `FactOpportunity`, `FactLead`, `FactTarget`, `FactActivity`.

#### A2.2 — Load to Tables (nine passes + FactActivity)

For each file, **Load to Tables** / **New table from file** → table name = base name (example: `FactActivity`).

**Notebook fallback:**

```python
tables = [
    "DimRegion", "DimCustomer", "DimProduct", "DimSalesperson", "DimDate",
    "FactSales", "FactOpportunity", "FactLead", "FactTarget", "FactActivity",
]
for name in tables:
    path = f"Files/crm/{name}.csv"
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(path))
    df.write.format("delta").mode("overwrite").saveAsTable(name)
    print(name, df.count())
```

#### A2.3 — Row count checkpoint

```sql
SELECT 'FactSales' AS T, COUNT(*) AS Cnt FROM FactSales
UNION ALL SELECT 'FactActivity', COUNT(*) FROM FactActivity
UNION ALL SELECT 'FactOpportunity', COUNT(*) FROM FactOpportunity;
```

| Table | Expected rows |
|-------|----------------|
| FactSales | **36** |
| FactActivity | **20** |
| FactOpportunity | **16** |

#### A2.4 — Semantic model

1. Workspace **`M12_L01_<id>`** → **+ New item** → **Semantic model** → **`sm_m12_rpt_<id>`**.  
2. Connect to **`lh_m12_rpt`** and include **all ten** tables.  
3. Save.

---

### Step A3 — Relationships (eleven links, no ambiguity) (critical)

Same rules as [Module 11 Lab A3](../../11%20-%20DAX%20Fundamentals/Lab_01_CRM_DAX_KPIs/Lab%2001%20-%20CRM%20DAX%20fundamentals%20and%20business%20KPIs.md) — **plus two** links for activities. **Do not** add shortcuts that cause **inflated revenue**.

#### A3.0 — Model view cleanup

1. Open **`sm_m12_rpt_<id>`** → **Model view**.  
2. **Manage relationships** → delete **all** auto-detected links. Rebuild **only** the eleven below.

#### A3.1 — Allowed relationships (create in this order)

| # | One (`1`) | Many (`*`) | Column | Cross-filter |
|---|-----------|------------|--------|--------------|
| 1 | `DimRegion` | `DimCustomer` | `RegionKey` | Single |
| 2 | `DimCustomer` | `FactSales` | `CustomerKey` | Single |
| 3 | `DimProduct` | `FactSales` | `ProductKey` | Single |
| 4 | `DimSalesperson` | `FactSales` | `SalespersonKey` | Single |
| 5 | `DimDate` | `FactSales` | `DateKey` | Single |
| 6 | `DimCustomer` | `FactOpportunity` | `CustomerKey` | Single |
| 7 | `DimDate` | `FactOpportunity` | `DateKey` | Single |
| 8 | `DimDate` | `FactLead` | `CreatedDateKey` | Single |
| 9 | `DimDate` | `FactTarget` | `DateKey` | Single |
| 10 | `DimCustomer` | `FactActivity` | `CustomerKey` | Single |
| 11 | `DimDate` | `FactActivity` | `ActivityDateKey` | Single |

Every link: **active**, **single** cross-filter, **one-to-many** (parent = dimension, child = fact).

**Revenue by region** still flows: `DimRegion` → `DimCustomer` → `FactSales` only.

#### A3.2 — Forbidden relationships (do not create)

| Forbidden | Why |
|-----------|-----|
| `DimRegion` → `FactSales` | Ambiguous with Region→Customer→Sales |
| `DimRegion` → `DimSalesperson` | Two paths to `FactSales` |
| `DimRegion` → `FactOpportunity` / `FactActivity` | Use customer bridge |
| Any fact ↔ fact | Star schema rule |
| `FactActivity` → `FactSales` on `CustomerKey` only | Use `DimCustomer` as conformed dimension |

#### A3.3 — Checkpoint

1. **Manage relationships** count = **11**.  
2. Open **`rpt_m12_rpt_<id>`** (create from semantic model if needed).  
3. **Matrix**: Rows `DimRegion[RegionName]`, Values `Total Revenue` (temporary measure `SUM(FactSales[Revenue])` if measures not built yet).  
4. Grand total = **909500**. If higher → fix A3.2.

---

### Step A4 — Mark date table and hide keys

1. Semantic model → **`DimDate`** → **Mark as date table** → **`FullDate`**.  
2. **Hide in report view** surrogate keys on facts (`CustomerKey`, `DateKey`, `ActivityDateKey`, etc.).

---

### Step A5 — Create and save the report

1. From **`sm_m12_rpt_<id>`** → **Create report**.  
2. Save as **`rpt_m12_rpt_<id>`** in workspace **`M12_L01_<id>`**.

---

### Step A6 — Minimum measures (semantic model)

Create in the **semantic model** (or report **Data** pane → **New measure**). Names must match:

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

```dax
Customer Revenue = CALCULATE ( [Total Revenue] )
```

```dax
Activity Count = COUNTROWS ( FactActivity )
```

**Part A checkpoint:** **Card** → **`Total Revenue`** = **909500** (no slicers). **Save** semantic model and report.

---

## Part B — Page 1: Executive Sales (Hands-on 13) (40 min)

**Goal:** KPI dashboard with slicer-driven year context, region/customer breakdown, drill-through, tooltip page, and controlled cross-filtering.

**Page name:** **`Executive`**

### Step B0 — Add all report pages (recommended order)

In **`rpt_m12_rpt_<id>`**, create blank pages and rename:

1. `Executive` (build first)  
2. `Customer Detail`  
3. `Region Tooltip`  
4. `Pipeline` (placeholder — Part C)  
5. `Customer 360` (placeholder — Part D)  

Hiding tooltip/drill pages comes in B7–B8.

---

### Step B1 — Rename and canvas

1. Open page **`Executive`**.  
2. **View** → **Page view** → **Fit to page** (optional).

---

### Step B2 — Year slicer (filter context for the page)

1. **Insert** → **Slicer** → field **`DimDate[Year]`**.  
2. Select **2026** so KPIs match the executive year story.  
3. **Format** slicer → title **Year**.

**Teaching point:** Without this slicer, **Total Revenue** shows **909500** (all years); with **2026**, executive revenue is **533500**.

---

### Step B3 — KPI row (four cards)

**Insert** → **Card** (four times, one row):

| Card title (suggested) | Measure |
|------------------------|---------|
| Total Revenue | `Total Revenue` |
| Open Pipeline | `Pipeline Value` |
| Win Rate | `Win Rate` |
| Target vs YTD | `Target Achievement %` |

With **Year = 2026**, revenue card ≈ **533500**.

---

### Step B4 — Trend and region

1. **Line chart:** X-axis **`DimDate[FullDate]`** (drag **Year**, **Month** hierarchy if available), Y-axis **`Total Revenue`**.  
2. **Clustered bar chart:** Y-axis **`DimRegion[RegionName]`**, X-axis **`Total Revenue`**.  
   - Use **`DimRegion`** only — **do not** put `RegionKey` from facts on the axis.

---

### Step B5 — Customer matrix + conditional formatting

1. **Matrix:** Rows **`DimCustomer[CustomerName]`**, Values **`Total Revenue`**, **`Sale Count`**.  
2. Select matrix → **Format visual** → **Cell elements** → **Conditional formatting** → **Data bars** on **`Total Revenue`**.

---

### Step B6 — Layout

- Left column: **Year** slicer.  
- Top row: four **cards**.  
- Center: **line** then **region bar**.  
- Right or below: **customer matrix**.  
- One consistent accent color; left-aligned visual titles.

---

### Step B7 — Customer Detail (drill-through target)

On page **`Customer Detail`**:

1. **Format page** (paint roller on empty canvas) → **Page information**:  
   - **Allow use as drill through**: **On**.  
2. In the **Drill through** field well (bottom of **Visualizations**), add **`DimCustomer[CustomerName]`**.  
3. Add visuals:  
   - **Card**: `DimCustomer[CustomerName]`, `DimRegion[RegionName]` (from related region path).  
   - **Clustered bar**: `DimProduct[ProductName]`, `Total Revenue`.  
   - **Table**: `FactSales` columns (respect drill filter).  
4. Optional: **Page information** → **Page hidden** → **On** (page still works for drill-through).

**Test:** On **`Executive`** matrix, right-click a customer → **Drill through** → **Customer Detail**.

---

### Step B8 — Region Tooltip page

On page **`Region Tooltip`**:

1. **Format page** → **Page information** → **Tooltip**: **On**.  
2. Resize page ( **Canvas settings** ) to a small tooltip size (example: 320×240).  
3. **Matrix**: Rows **`DimRegion[RegionName]`**, **`DimCustomer[CustomerName]`**, Values **`Total Revenue`**.  
4. **Page hidden**: **On** (recommended).

On **`Executive`** **region bar chart**:

1. Select the visual → **Format** → **General** → **Tooltips**.  
2. **Type**: **Report page** → page **`Region Tooltip`**.

**Test:** Hover a bar — tooltip page appears.

---

### Step B9 — Edit interactions (KPI cards do not filter charts)

1. On **`Executive`**, click a **KPI card** to select it.  
2. **Format** → **Edit interactions** (icon appears on other visuals).  
3. On **line**, **bar**, and **matrix**, set filter icon to **None** (no filter) for the card.  
4. **Slicer** should still filter all visuals — leave slicer → visual as filter.  
5. Click **Edit interactions** again to exit.

### Part B checkpoint

- [ ] Year **2026** → revenue **533500** on card  
- [ ] Region bar total ties to matrix logic; no inflated totals  
- [ ] Drill-through to **Customer Detail** works  
- [ ] Region bar uses **Report page** tooltip  
- [ ] KPI cards do not cross-filter charts  

---

## Part C — Page 2: Pipeline (Hands-on 14) (35 min)

**Page name:** **`Pipeline`**

### Step C1 — Stage visuals

1. **Clustered bar chart** (horizontal): Axis **`FactOpportunity[Stage]`**, Values **`Opportunity Count`**, **`Pipeline Value`**.  
2. **Donut chart**: Legend **`FactOpportunity[Stage]`**, Values **`Opportunity Count`**.  
3. **Card**: **`Lead Conversion Rate`**.

### Step C2 — Salesperson matrix

**Matrix:** Rows **`DimSalesperson[SalespersonName]`**, Values **`Total Revenue`**, **`Won Opportunities`**.

### Step C3 — Opportunities over time

**Line chart:** Axis **`DimDate[FullDate]`** (month), Values **`Opportunity Count`** (filters via **`DimDate` → `FactOpportunity`**).

### Step C4 — Narrative

**Insert** → **Text box** — one short paragraph: leads convert to opportunities; reference **`Lead Conversion Rate`**.

### Step C5 — Bookmarks (web)

1. **View** → **Bookmarks pane** (enable if hidden).  
2. Clear stage filters → **Add bookmark** → name **`All Stages`** → check **Data** → save.  
3. Filter opportunities to **Open** (slicer on **`Stage`** or visual filter) → **Add bookmark** → **`Open Pipeline Only`**.  
4. Filter **Won** → **`Won Deals`**.  
5. After changing filters, use **⋯ → Update** on each bookmark.

### Step C6 — Bookmark buttons

1. **Insert** → **Button** → style **Blank** or **Bookmark navigator**.  
2. **Format button** → **Action** → **Type: Bookmark** → select **`All Stages`** / **`Open Pipeline Only`**.  
3. Label buttons clearly on canvas.

### Step C7 — Actual vs target

**Gauge** visual (if available in tenant) or two **cards**: **`Revenue YTD`** and **`Revenue Target`**, or single **`Target Achievement %`** card.

### Part C checkpoint

- [ ] Donut shows Won / Lost / Open  
- [ ] Bookmarks change stage context  
- [ ] Buttons fire bookmarks  
- [ ] Target / YTD visual present  

---

## Part D — Page 3: Customer 360 (Hands-on 15) (35 min)

**Page name:** **`Customer 360`**

### Step D1 — Customer slicer and profile

1. **Slicer:** **`DimCustomer[CustomerName]`** — **single select** (format → selection → single select).  
2. **Multi-row card**: **`CustomerName`**, **`DimRegion[RegionName]`**, **`Industry`**.

### Step D2 — KPI cards for selected customer

Four **cards**: **`Customer Revenue`**, **`Sale Count`**, **`Opportunity Count`**, **`Activity Count`** — all respect the slicer.

### Step D3 — Products and detail tables

1. **Clustered bar**: **`DimProduct[ProductName]`**, **`Customer Revenue`**.  
2. **Table**: `FactOpportunity` — **Stage**, **EstimatedValue**.  
3. **Table**: `FactActivity` — **ActivityType**, **`DimDate[FullDate]`** (or `ActivityDateKey` formatted).

### Step D4 — Segmentation

**Clustered bar** of **`DimCustomer[CustomerName]`** vs **`Customer Revenue`**; **conditional formatting** → highlight **top 3** customers by revenue.

### Step D5 — Drill-through link

From opportunity **table**, confirm **Drill through → Customer Detail** or duplicate detail section lower on the same page.

### Step D6 — Customer trend

**Line chart**: Month from **`DimDate[FullDate]`**, Values **`Customer Revenue`**.

### Part D checkpoint

- [ ] Slicer changes all customer-scoped visuals  
- [ ] **Activity Count** > 0 for customers with activities  
- [ ] Trend line shows one customer’s months  

---

## Part E — Navigation, mobile, share (15 min)

### Step E1 — Page navigation

On **`Executive`**: **Insert** → **Button** → **Action: Page navigation** → target **`Pipeline`** and **`Customer 360`** (two buttons or **Page navigator**).

### Step E2 — Reset All bookmark

1. Clear slicers (Year, Customer, Stage).  
2. **Add bookmark** → **`Reset All`** with **Data** selected.  
3. Optional button with **Action: Bookmark** → **`Reset All`**.

### Step E3 — Phone layout (web)

1. Open page **`Executive`**.  
2. **View** → **Mobile layout** (or **Phone layout**).  
3. Drag **Year** slicer and **four cards** into the phone canvas — **stack cards vertically**.  
4. Add key chart if space allows. **Save**.

### Step E4 — Share evidence

Report is already in workspace **`M12_L01_<id>`**. Copy **Share link** or submit workspace name for instructor access — no `.pbix` required.

### Visual selection cheat sheet (submission)

| Question | Visual you chose |
|----------|------------------|
| KPI single number | Card |
| Category comparison | Bar |
| Trend over time | Line |
| Stage breakdown | Bar / Donut |
| Detail listing | Table / Matrix |

### Design checklist (submission)

| Feature | Where implemented |
|---------|-------------------|
| Slicers | Year (Executive), Customer (360) |
| Conditional formatting | Executive matrix revenue bars |
| Drill-through | Customer Detail |
| Bookmarks + buttons | Pipeline |
| Report tooltip | Region bar on Executive |
| Edit interactions | Executive KPI vs charts |
| Mobile / phone layout | Executive |

---

## Submission

- Workspace **`M12_L01_<id>`** and item names (lakehouse, semantic model, report)  
- Screenshot: **Model view** with **11** relationships  
- Report URL or screenshots: **Executive**, **Pipeline**, **Customer 360**, drill-through, tooltip hover, bookmarks, **phone layout**  
- Completed **design checklist**  
- One sentence: how **Year** slicer changed **Total Revenue** (909500 vs 533500)  

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| Revenue **> 909500** | Remove forbidden relationships (Part A3.2); keep **11** links only |
| Region bar empty | Axis = **`DimRegion[RegionName]`**; path via **DimCustomer** |
| Executive revenue 909500 but should be 2026 view | Set **Year** slicer to **2026** → **533500** |
| Drill-through greyed out | **Customer Detail**: drill through **On**; field in drill-through well |
| Tooltip does not show | **Region Tooltip** page type **Tooltip**; bar chart tooltip **Report page** |
| Bookmarks no effect | **Update** bookmark after filter change; include **Data** |
| **Activity Count** always 0 | Relationships #10–#11; **`FactActivity`** 20 rows in lakehouse |
| YTD / Target blank | Mark **`DimDate`**; relationships #5 and #9 |
| Mobile layout missing | Use **View → Mobile layout** on **`Executive`**; save report |
| Cannot add measure in report | Open **`sm_m12_rpt_<id>`** and create measures there, refresh report |

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