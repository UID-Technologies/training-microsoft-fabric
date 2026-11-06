# Lab 01 — Connect, Clean and Transform CRM Data

> **Learner path:** [Module 2 Getting-Started.md](../../Getting-Started.md) · [Power BI navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Use **`Lab_01_Connect_Clean_Transform/data/`** only.

**Module:** 2 — Power BI Fundamentals  
**Duration:** 60–75 minutes  
**Level:** Beginner  
**Standalone deliverable:** `Lab01_CRM_Cleaned.pbix`  
**Objective:** Connect to CSV and Excel, profile raw CRM data, fix intentional quality problems, set data types and load clean data.

> **Power BI UI note (November 2026):** Instructions use the common Power BI Desktop ribbon and Power BI Service/Fabric web workspace labels. Microsoft may change button placement or names by tenant, update channel, or preview setting. If a label differs, use the corresponding action in Home, Transform Data, Model view, or the workspace item menu. Do not enable previews solely to complete this lab.

**Environment:** Windows PC with Power BI Desktop installed; Microsoft account/work account only for optional publishing. All local tasks work without paid licensing. A Power BI/Fabric workspace and appropriate permissions/licensing may be needed for cloud publishing/sharing.

**How to start:** Download/unzip this lab folder, open Power BI Desktop, create a **new blank PBIX**. Use **only files in this lab's `data/` folder**. Do not reuse prior labs.

## Progress checklist

- [ ] Blank PBIX saved as `Lab01_CRM_Cleaned.pbix`  
- [ ] `CRM_Sales_Raw.csv` connected; query renamed `Sales_Clean`  
- [ ] Cleanup steps applied; **117** rows, no date errors  
- [ ] `CRM_Import_Practice.xlsx` loaded as `Customers_Excel`  
- [ ] Validation table + card (117 distinct SaleID)  
- [ ] Reflection questions answered  

## 1. Business scenario
A CRM administrator exported sales transactions with inconsistent region capitalization, a duplicate SaleID, a missing revenue value, an invalid date and a negative test transaction. Prepare a reliable sales table without altering source files.

## 2. Provided sample data
- `data/CRM_Sales_Raw.csv` — 123 data rows (120 baseline transactions, one duplicate, one negative test record, and original data includes an invalid date and blank revenue).
- `data/CRM_Customers.csv` — 24 customers.
- `data/CRM_Import_Practice.xlsx` — equivalent sheets to practice the Excel connector.

**Columns:** SaleID (identifier), CustomerID, ProductID, SaleDate, Revenue, RegionRaw, Notes.

## 3. Exercise A — Connect to CSV (10 minutes)
1. Launch **Power BI Desktop** → **Blank report**.
2. Select **Home → Get data → Text/CSV** (or **Text/CSV** directly).
3. Browse to `data/CRM_Sales_Raw.csv`, select **Open**.
4. In the preview verify seven columns and headers; choose **Transform Data** (not Load).
5. In Power Query Editor, locate the query in the left Queries pane; rename it `Sales_Clean` using right-click → **Rename**.
6. In **View**, turn on **Column quality**, **Column distribution** and **Column profile**; if available set profiling to **entire data set** rather than first 1,000 rows.
7. Record which fields contain errors, nulls or suspicious values. The deliberately invalid date may appear as an error after a type conversion.

**Checkpoint:** Query `Sales_Clean` exists and displays raw CRM records.

## 4. Exercise B — Clean CRM data (25 minutes)
1. In **Applied Steps**, inspect the automatically generated **Changed Type** step. If it turns `SaleDate` into errors, remove that step so you can clean the text first.
2. Select `SaleID` → set **Data Type → Text**. Set `CustomerID` and `ProductID` to **Text** as well.
3. Select `RegionRaw` → **Transform → Format → Trim**, then **Clean**, then **Capitalize Each Word**. Confirm all regions read North/South/East/West.
4. Select `Revenue` → change type to **Decimal Number** (choose **Replace current** if prompted).
5. Open the `Revenue` filter → **Remove Empty** (or filter out `(null)`); confirm the missing-revenue record is excluded.
6. Filter `Revenue` to **greater than 0** to remove the negative test transaction. In this training scenario, negative amounts are test records; in production they may represent refunds and must be handled according to business policy.
7. Select `SaleDate` → **Data Type → Date**. If Power Query shows an error for `not-a-date`, select the `SaleDate` column and choose **Home → Remove Rows → Remove Errors**. In production, quarantine errors instead of silently dropping them.
8. Select `SaleID` → **Home → Remove Rows → Remove Duplicates**. Because a transaction identifier is expected to be unique, this removes the deliberate repeated record. If duplicates disagree, investigate rather than arbitrarily choosing a survivor.
9. Rename `RegionRaw` to `Region` and remove `Notes` (right-click column → **Remove**).
10. Reorder columns: `SaleID`, `CustomerID`, `ProductID`, `SaleDate`, `Revenue`, `Region`.
11. Check **Applied Steps** to see the ordered transformation history.

**Expected:** 117 valid, distinct, positive-revenue sales rows; four standardized region values; no errors in SaleDate; no null Revenue.

## 5. Exercise C — Connect to Excel (10 minutes)
1. While still in Power Query Editor, choose **Home → New Source → Excel workbook**.
2. Select `data/CRM_Import_Practice.xlsx`.
3. In Navigator choose `CRM_Customers` and click **OK/Transform Data**.
4. Rename query `Customers_Excel`.
5. If needed choose **Use First Row as Headers**.
6. Set `CustomerID`, `CustomerName`, `Region`, `Segment` to Text.
7. In the query list, right-click `Customers_Excel` → ensure **Enable Load** is checked.
8. **Home → Close & Apply**. Wait for data to load.

**Checkpoint:** Data pane lists `Sales_Clean` and `Customers_Excel`.

## 6. Exercise D — Inspect and save (10 minutes)
1. Switch to **Table view** (formerly Data view; left navigation icon). Inspect `Sales_Clean`.
2. Confirm `Revenue` is numeric and `SaleDate` is a Date.
3. Switch to **Report view** and insert a **Table** visual.
4. Add `SaleID`, `Region`, `Revenue`; verify readable values.
5. Insert a **Card** visual and use `SaleID` with **Count (Distinct)** aggregation; expected 117.
6. Select **File → Save As**, name the file `Lab01_CRM_Cleaned.pbix`.

## 7. Validation checklist
- [ ] CSV connected and query transformations visible.
- [ ] Excel workbook connected independently.
- [ ] 117 valid sales rows after cleanup.
- [ ] Four standardized regions and numeric revenue.
- [ ] Date column has no errors.
- [ ] PBIX saved locally.

## 8. Troubleshooting
| Problem | Cause | Resolution |
|---|---|---|
| Date conversion error | Invalid `not-a-date` value | Remove erroneous type step, then convert and remove error row |
| Blank revenue remains | Empty string became null or text | Change to decimal, filter null/blank |
| Wrong row count | Deduplication/filters in wrong order | Review Applied Steps; 120 baseline minus 3 invalid rows = 117 |
| Workbook sheet missing | Navigator selection | Expand workbook tree and select sheet, not an unintended range |
| Locale parsing issue | Regional settings | Change Type → Using Locale and select appropriate locale |

## 9. Reflection questions
1. Why should CustomerID be Text even if it looks numeric?
2. Why does the order of Applied Steps matter?
3. What would change if negative sales represented refunds rather than test data?
4. How is Power Query different from DAX?

**Finish condition:** Submit the PBIX and a screenshot of Applied Steps and the 117-row count. This lab has no dependency on Lab 02 or Lab 03.
