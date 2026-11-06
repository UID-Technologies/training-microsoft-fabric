# Lab 02 — Build a CRM Semantic Model and DAX Measures

> **Learner path:** [Module 2 Getting-Started.md](../../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). New blank `.pbix`; data in **`Lab_02_Semantic_Model_DAX/data/`**.

**Module:** 2 — Power BI Fundamentals  
**Duration:** 75–90 minutes  
**Level:** Beginner / Intermediate  
**Standalone deliverable:** `Lab02_CRM_Semantic_Model.pbix`  
**Objective:** Import clean CRM CSV files, create a star-schema-like model, define relationships, write DAX measures and validate results.

> **Power BI UI note (November 2026):** Instructions use the common Power BI Desktop ribbon and Power BI Service/Fabric web workspace labels. Microsoft may change button placement or names by tenant, update channel, or preview setting. If a label differs, use the corresponding action in Home, Transform Data, Model view, or the workspace item menu. Do not enable previews solely to complete this lab.

**Environment:** Windows PC with Power BI Desktop installed; Microsoft account/work account only for optional publishing. All local tasks work without paid licensing. A Power BI/Fabric workspace and appropriate permissions/licensing may be needed for cloud publishing/sharing.

**How to start:** Download/unzip this lab folder, open Power BI Desktop, create a **new blank PBIX**. Use **only files in this lab's `data/` folder**. Do not reuse prior labs.

## 1. Business scenario
A sales analytics team has clean customer, product, sales and opportunity exports. Build a reusable semantic model that supports accurate business reporting.

## 2. Supplied data
- `data/Customers.csv`: 24 customer records, unique CustomerID.
- `data/Products.csv`: 8 products, unique ProductID.
- `data/Sales.csv`: 120 sales transactions (SaleID, CustomerID, ProductID, SaleDate, Revenue).
- `data/Opportunities.csv`: 80 opportunities (OpportunityID, CustomerID, Stage, EstimatedValue, CloseDate).

## 3. Exercise A — Import four files (15 minutes)
1. Launch a **new blank Power BI Desktop report**.
2. **Home → Get data → Text/CSV** → choose `Customers.csv` → **Transform Data**.
3. Repeat with `Products.csv`, `Sales.csv`, `Opportunities.csv` via **Home → New Source → Text/CSV** in Power Query Editor.
4. Rename queries exactly `Customers`, `Products`, `Sales`, `Opportunities`.
5. Set identifier fields to **Text**, `SaleDate` and `CloseDate` to **Date**, `Revenue` and `EstimatedValue` to **Decimal Number**. All other descriptive columns are Text.
6. Verify header row and expected record counts; **Home → Close & Apply**.

## 4. Exercise B — Build relationships (20 minutes)
1. Select **Model view** on the left navigation.
2. Move `Customers` and `Products` to the top and `Sales`/`Opportunities` beneath them.
3. Create the relationships listed below. In the relationship dialog check cardinality **One to many**, cross-filter **Single**, and **Make this relationship active**.
4. Confirm each one-side key is unique and all fact foreign keys match dimension keys.
5. Verify the 1 and * symbols on each relationship line.

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


## 5. Exercise C — Add measures (20 minutes)
1. Create each measure above via **Modeling → New measure**.
2. Confirm each formula appears in the Data pane (calculator icon).
3. In **Measure tools**, set Win Rate format to **Percentage**, two decimals.
4. Set revenue measures to INR currency where supported; otherwise decimal with currency symbol formatting.
5. In **Report view**, insert a **Table** visual with `Customers[Region]`, `[Total Revenue]`, `[Buying Customers]`.
6. Insert a second **Table** visual with `Opportunities[Stage]` and `[Total Opportunities]`.
7. Add a **Card** for `[Win Rate]`.

## 6. Exercise D — Validate filter propagation (15 minutes)
1. Insert a **Slicer** using `Customers[Region]`.
2. Select North; confirm Revenue and Buying Customers change.
3. Confirm opportunity counts change when filtering Customers by region (because Customers filters Opportunities).
4. Clear the slicer; compare total metrics with the expected values below.
5. Add a ProductName slicer; confirm it filters sales metrics, but not opportunity metrics (there is no ProductID in Opportunities).
6. Explain why bidirectional filtering is not needed here.
7. Save as `Lab02_CRM_Semantic_Model.pbix`.

## 7. Expected results (no filters)
| Measure | Expected |
|---|---:|
| Sales transactions | 120 |
| Total Revenue | 1,056,250 |
| Customer master records | 24 |
| Buying Customers | 24 |
| Opportunities | 80 |
| Won Opportunities | 32 |
| Lost Opportunities | 16 |
| Closed Opportunities | 48 |
| Win Rate | 66.67% |

## 8. Troubleshooting
| Symptom | Fix |
|---|---|
| Relationship shows many-to-many | Confirm one-side key uniqueness and matching text data types |
| Revenue repeats for every region | Check Customers → Sales active relationship |
| Product slicer changes opportunity count unexpectedly | Inspect unintended relationship or visual interactions |
| DAX name not found | Confirm exact table/column names and that each measure was created separately |
| Win Rate shown as decimal | Select measure → format Percentage |

## 9. Completion checklist
- [ ] Four clean tables imported into a new PBIX.
- [ ] Three active one-to-many relationships.
- [ ] Nine DAX measures created.
- [ ] Region slicer filters both sales and opportunity metrics.
- [ ] Expected totals verified.
- [ ] PBIX saved and model diagram screenshot captured.

**Finish condition:** Submit PBIX plus screenshots of Model view and validation cards. This lab does not require Lab 01 or Lab 03.
