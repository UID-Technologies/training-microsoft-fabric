# Lab 03 — Build and Publish an Interactive CRM Sales Dashboard

> **Learner path:** [Module 2 Getting-Started.md](../../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). New blank `.pbix`; data in **`Lab_03_CRM_Sales_Dashboard/data/`**.

**Module:** 2 — Power BI Fundamentals  
**Duration:** 120–150 minutes  
**Level:** Beginner / Intermediate  
**Standalone deliverable:** `Lab03_CRM_Sales_Dashboard.pbix`; optional Power BI Service report and pinned dashboard.  
**Objective:** Build a complete CRM sales report covering Revenue, Customers, Opportunities, Region, Product and monthly trend analysis; test slicers and publish.

> **Power BI UI note (November 2026):** Instructions use the common Power BI Desktop ribbon and Power BI Service/Fabric web workspace labels. Microsoft may change button placement or names by tenant, update channel, or preview setting. If a label differs, use the corresponding action in Home, Transform Data, Model view, or the workspace item menu. Do not enable previews solely to complete this lab.

**Environment:** Windows PC with Power BI Desktop installed; Microsoft account/work account only for optional publishing. All local tasks work without paid licensing. A Power BI/Fabric workspace and appropriate permissions/licensing may be needed for cloud publishing/sharing.

**How to start:** Download/unzip this lab folder, open Power BI Desktop, create a **new blank PBIX**. Use **only files in this lab's `data/` folder**. Do not reuse prior labs.

## 1. Business scenario
The Sales Director wants one report showing revenue, active customer base, sales pipeline, high-performing regions, product mix and monthly revenue trends. Build the report from scratch using this lab's data. **Power BI Desktop creates reports; Power BI Service can create a separate single-page dashboard by pinning visuals.**

## 2. Sample files
- `data/Customers.csv` — 24 customers.
- `data/Products.csv` — 8 products.
- `data/Sales.csv` — 120 transactions across January–December 2026.
- `data/Opportunities.csv` — 80 opportunity records.

## 3. Exercise A — Import and model (25 minutes)
1. Launch Power BI Desktop → **Blank report**.
2. **Home → Get data → Text/CSV** → choose `Customers.csv` → **Transform Data**.
3. In Power Query Editor, use **Home → New Source → Text/CSV** to import the remaining three files.
4. Rename queries `Customers`, `Products`, `Sales`, `Opportunities`.
5. Verify ID fields are Text, dates are Date, and money columns are Decimal Number.
6. **Home → Close & Apply**.
7. Select **Model view** and create three active single-direction one-to-many relationships using the table below.

## Data model design

Use these exact names for the imported queries: `Customers`, `Products`, `Sales`, `Opportunities`. The CSVs are already clean, so **do not repeat Lab 01 cleanup**.

**Relationships (Model view → Manage relationships → New, or drag keys):**

| Dimension (one side) | Fact (many side) | Cardinality | Cross-filter |
|---|---|---|---|
| Customers[CustomerID] | Sales[CustomerID] | One-to-many (1:*) | Single |
| Customers[CustomerID] | Opportunities[CustomerID] | One-to-many (1:*) | Single |
| Products[ProductID] | Sales[ProductID] | One-to-many (1:*) | Single |

Use active relationships. The `Customers` table is shared across two fact tables. Do not create a direct Sales ↔ Opportunities relationship; the two tables have different grains.

**DAX measures:** Select `Sales` → **Modeling → New measure** and enter one formula at a time. For opportunity measures, select `Opportunities` as the home table.

```dax
Total Revenue = SUM(Sales[Revenue])
```
```dax
Total Customers = DISTINCTCOUNT(Customers[CustomerID])
```
```dax
Buying Customers = DISTINCTCOUNT(Sales[CustomerID])
```
```dax
Total Sales = DISTINCTCOUNT(Sales[SaleID])
```
```dax
Total Opportunities = DISTINCTCOUNT(Opportunities[OpportunityID])
```
```dax
Won Opportunities = CALCULATE([Total Opportunities], Opportunities[Stage] = "Won")
```
```dax
Closed Opportunities = CALCULATE([Total Opportunities], Opportunities[Stage] IN {"Won", "Lost"})
```
```dax
Win Rate = DIVIDE([Won Opportunities], [Closed Opportunities], 0)
```
```dax
Average Sale Value = DIVIDE([Total Revenue], [Total Sales], 0)
```

Format `Total Revenue` and `Average Sale Value` as currency, `Win Rate` as Percentage. The synthetic currency is **INR**; values are fictional. `Total Customers` counts the full customer master, while `Buying Customers` counts customers represented in sales. These are intentionally different concepts.


## 4. Exercise B — Build KPI cards (20 minutes)
1. In **Report view**, rename Page 1 to `Sales Overview` (double-click page tab or right-click → Rename).
2. In the Visualizations pane select **Card** (the exact icon/layout may vary in current Desktop versions).
3. Drag `[Total Revenue]` to the card value/data field. Set title `Total Revenue`.
4. Add separate cards for `[Buying Customers]`, `[Total Opportunities]`, `[Won Opportunities]`, `[Win Rate]`.
5. Format Win Rate as a percentage. For revenue use INR currency or label it explicitly as INR.
6. Align cards across the top using the Format ribbon → Align/Distribute where available.

**Expected unfiltered values:** Revenue 1,056,250; Buying Customers 24; Opportunities 80; Won 32; Win Rate 66.67%.

## 5. Exercise C — Revenue by Region (15 minutes)
1. Click a blank area on the canvas.
2. Choose **Clustered bar chart**.
3. Drag `Customers[Region]` to **Y-axis** (category) and `[Total Revenue]` to **X-axis** (value); field wells can differ by orientation.
4. Sort descending by Total Revenue using the visual **More options (...) → Sort axis**.
5. Title the visual `Revenue by Region`; turn on **Data labels** in Format visual.
6. Select a bar and verify that related KPI cards respond, depending on configured visual interactions.

## 6. Exercise D — Revenue by Product (15 minutes)
1. Add a **Clustered column chart**.
2. Place `Products[ProductName]` on X-axis and `[Total Revenue]` on Y-axis.
3. Sort by revenue descending; enable data labels.
4. Title it `Revenue by Product`.
5. Optionally use `Products[Category]` as a legend or build a second category chart.

## 7. Exercise E — Monthly Revenue Trend (20 minutes)
1. Add a **Line chart**.
2. Place `Sales[SaleDate]` on X-axis and `[Total Revenue]` on Y-axis.
3. If Power BI automatically creates a Date Hierarchy, use **Year → Month** with drill-down, or switch to a Month field as described next.
4. For an explicit sortable month label, select `Sales` → **Modeling → New column** and create:

```dax
Month Start = DATE(YEAR(Sales[SaleDate]), MONTH(Sales[SaleDate]), 1)
```

5. Set `Month Start` to Date. Use it on the X-axis, set X-axis to **Continuous** if available, and choose a month/year date display format.
6. Confirm all 12 months Jan–Dec 2026 are shown chronologically; do not sort month names alphabetically.
7. Title it `Monthly Revenue Trend`.

## 8. Exercise F — Opportunity Pipeline (15 minutes)
1. Add a **Donut chart**.
2. Place `Opportunities[Stage]` in Legend and `[Total Opportunities]` in Values.
3. Turn on category and percentage labels if supported.
4. Title it `Opportunity Pipeline by Stage`.
5. Add a **Table** visual with `Customers[CustomerName]`, `[Total Revenue]`, `[Total Sales]` to show top customers.
6. Sort customer table by revenue descending; optionally apply a Top N filter.

## 9. Exercise G — Slicers and interactions (15 minutes)
1. Insert a **Slicer** with `Customers[Region]`.
2. Insert another **Slicer** with `Products[Category]`.
3. Add a Date slicer using `Sales[SaleDate]` and choose **Between** if available.
4. Select **North** and confirm the revenue and customer metrics update.
5. Select a product category and confirm product-linked sales visuals update. Opportunity counts should not change from Product alone because there is no product relationship to Opportunities.
6. Test a date selection. **Important:** A slicer based on `Sales[SaleDate]` filters Sales, not automatically Opportunities; to apply one common calendar to both fact tables, build a separate Date dimension and relationships (extension exercise below).
7. Use **Format ribbon → Edit interactions** to control whether each slicer filters a visual, where needed.
8. Clear all slicers and check baseline totals.

## 10. Exercise H — Add a detail page (10 minutes)
1. Click the **+** page tab to add a new report page.
2. Rename it `Customer Detail`.
3. Add a **Table** visual with `Customers[CustomerName]`, `Customers[Region]`, `[Total Revenue]`, `[Total Sales]`.
4. Add a bar chart for `Products[Category]` and `[Total Revenue]`.
5. Add a Region slicer; test it.
6. Return to Sales Overview and save as `Lab03_CRM_Sales_Dashboard.pbix`.

## 11. Exercise I — Publish and create an actual dashboard (optional; 20–30 minutes)
**Prerequisite:** Sign in to Power BI Desktop and ensure your tenant has a workspace where you can publish. Licensing/capacity/permissions vary. If publishing is unavailable, skip this cloud-only portion and submit the local PBIX.

1. In Desktop select **Home → Publish**.
2. Choose an existing authorized workspace (or My workspace if permitted). Confirm publishing.
3. Open Power BI Service at `https://app.powerbi.com` (or your organization's Fabric portal entry point).
4. Navigate to **Workspaces → [selected workspace]**. Verify that both the **report** and **semantic model** appear.
5. Open the published report and inspect the visuals.
6. In the report, hover over a supported visual and choose **Pin visual** (pin icon, or visual More options menu). Choose **New dashboard** and name it `CRM Sales Executive Dashboard`.
7. Pin at least the Total Revenue KPI, Revenue by Region and Monthly Revenue Trend visuals to the same dashboard. Pinning options can depend on the visual and service UI.
8. Return to the workspace and open the newly created **Dashboard** item. Arrange tiles on its single-page canvas.
9. Inspect semantic model settings for **Data source credentials** and **Refresh**. A local CSV path usually cannot be refreshed by the cloud service without an appropriate gateway or relocating the source to a supported cloud location. **Do not claim scheduled refresh works until credentials/connectivity have been tested.**
10. Discuss workspace roles (Viewer, Contributor, Member, Admin) and sharing/licensing requirements. Do not share with external users during training.

## 12. Optional extension — Common Date table (15–20 minutes)
To make one date slicer filter both Sales and Opportunities by their respective date fields:
1. Select **Modeling → New table** and enter:

```dax
DimDate = CALENDAR(DATE(2026,1,1), DATE(2026,12,31))
```

2. Create columns `Year = YEAR(DimDate[Date])` and `Month = FORMAT(DimDate[Date], "MMM")` and `MonthNumber = MONTH(DimDate[Date])` using **New column** separately.
3. Select `DimDate[Month]` → **Column tools → Sort by column → MonthNumber**.
4. In Model view create `DimDate[Date]` (one side) → `Sales[SaleDate]` (many side), single-direction active.
5. Create `DimDate[Date]` (one side) → `Opportunities[CloseDate]` (many side), single-direction active.
6. Replace the SaleDate slicer with `DimDate[Date]`. Confirm both sales and opportunity metrics now respond to the date selection.
7. Optional: **Table tools → Mark as date table** using `DimDate[Date]` if the current Desktop experience supports it.

## 13. Validation / acceptance criteria
| Check | Expected |
|---|---|
| Total Revenue | 1,056,250 |
| Total Sales | 120 |
| Customer master | 24 |
| Buying Customers | 24 |
| Opportunities | 80 |
| Won / Lost / Open | 32 / 16 / 32 |
| Win Rate | 66.67% |
| Region chart | Four regions |
| Product chart | Eight products |
| Monthly trend | Twelve months, Jan–Dec 2026 |
| Report pages | Sales Overview + Customer Detail |
| Published report | Optional, if workspace access is available |
| Service dashboard | Optional, three or more pinned tiles |

## 14. Troubleshooting
| Issue | Suggested fix |
|---|---|
| Card shows same value across all regions | Check Customers → Sales relationship and filter direction |
| Month chart sorts alphabetically | Use Month Start date or MonthNumber sort |
| Region slicer doesn't affect opportunities | Check Customers → Opportunities relationship |
| Product slicer doesn't affect opportunities | Expected; no product key exists in opportunity records |
| Publish button disabled | Sign in and verify tenant/workspace access |
| Dashboard pin action missing | Confirm you are in Power BI Service, not Desktop, and inspect supported visual options |
| Refresh fails after publish | Local files need accessible cloud source or appropriate gateway and credentials |
| Win Rate appears as 0.5 | Set measure format to Percentage |

## 15. Learner questions
1. Which region has the highest revenue and why?
2. Which product contributes most revenue?
3. What is the difference between Total Customers and Buying Customers?
4. Why is the Win Rate denominator Closed Opportunities rather than all opportunities?
5. Why does a Sales date slicer not automatically filter Opportunities?
6. What is the difference between the published report and the pinned dashboard?

## 16. Submission
- [ ] `Lab03_CRM_Sales_Dashboard.pbix` saved.
- [ ] Sales Overview screenshot showing KPIs, region, product, monthly trend, opportunities.
- [ ] Customer Detail page screenshot.
- [ ] Screenshot with Region slicer selected and filtered metrics.
- [ ] Optional Service report/dashboard screenshot.

**Finish condition:** The PBIX opens independently and all six required business analyses work without files from another lab.
