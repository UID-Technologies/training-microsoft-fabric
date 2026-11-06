# Lab 03 — Build an End-to-End CRM Analytics Solution in Microsoft Fabric

> **Learner path:** [Module 3 Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md)

**Module:** 3 — Microsoft Fabric Fundamentals  
**Duration:** 120–150 minutes  
**Standalone:** Yes — workspace `CRM-M3-L03-<initials>`  
**Deliverable:** Lakehouse, pipeline (or documented fallback), curated table, SQL results, Power BI report (or documented blocker).

## Progress checklist

- [ ] Workspace + Lakehouse `CRM_Lakehouse_L03`  
- [ ] CSVs in `Files/raw/` from **`Lab_03_End_to_End_CRM/data/`**  
- [ ] Ingestion: pipeline **or** Notebook fallback documented  
- [ ] Table `crm_sales_curated` — 60 rows, revenue 739000  
- [ ] SQL regional + monthly queries run  
- [ ] Report saved **or** permission limitation noted  

## Business scenario
A CRM sales manager needs revenue by region and month, customer counts and opportunity status. Build a compact Fabric pipeline that ingests CRM exports, engineers a curated dataset and makes it ready for BI. Explore a Warehouse as an optional SQL-first extension.

## Sample data

Upload from **`Lab_03_End_to_End_CRM/data/`** (four CSVs: customers, products, sales, opportunities).

Expected after load: 20 / 8 / 60 / 30 rows; sales revenue sum **739000**.

## Environment and navigation notes
- Fabric capacity required — see [Getting-Started.md](../Getting-Started.md).
- Sign in at https://app.fabric.microsoft.com; use **Workspaces** → **+ New item**. UI map: [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md).
- Workspace for this lab only: **`CRM-M3-L03-<initials>`**.
- Do not select production capacity or upload real customer information. The included CSV files are synthetic.
- If a command or item is unavailable, capture a screenshot and document the permission/capacity limitation instead of pretending it succeeded.

## Part A — Create workspace and Lakehouse (15 min)
1. Create workspace `CRM-M3-L03-<initials>` on supported Fabric capacity/trial.
2. Select **+ New item** → **Lakehouse**; name it `CRM_Lakehouse_L03`.
3. Under **Files**, create folder `raw` and upload the four supplied CSV files.
4. Confirm each upload is visible in `Files/raw`.

## Part B — Create a Data Factory pipeline (20 min)
1. From the workspace choose **+ New item** → **Data pipeline**.
2. Name it `PL_CRM_Ingestion_L03`.
3. In the pipeline canvas select **Add activity** and find **Copy data** (some UIs provide **Copy data assistant**).
4. Configure source as the Lakehouse `CRM_Lakehouse_L03`, choosing `Files/raw/customers.csv` or the corresponding OneLake file source available in the UI. Set CSV/header/delimiter settings if prompted.
5. Configure destination as the same Lakehouse **Tables** area and choose/create destination table `customers`. Use overwrite/replace for this repeatable training run if supported.
6. Review field mappings and run the pipeline. Open **Output** / monitoring and confirm the copy activity succeeded.
7. Repeat using separate Copy activities for `products.csv` → `products`, `sales.csv` → `sales`, `opportunities.csv` → `opportunities`. You may configure sequential dependencies to keep the exercise simple.
8. Run the complete pipeline and confirm four tables appear in the Lakehouse.

**UI alternative:** If a source connector cannot browse Lakehouse Files in your tenant, choose the supported OneLake/Lakehouse connector in Copy Data assistant, or use a Notebook to load the four raw CSVs as shown below. Record the pipeline connector limitation; the fallback still demonstrates ingestion, but does **not** count as a successful pipeline execution.

### Ingestion fallback Notebook cell
```python
for name in ["customers", "products", "sales", "opportunities"]:
    (spark.read.option("header", "true").option("inferSchema", "true")
     .csv(f"Files/raw/{name}.csv")
     .write.format("delta").mode("overwrite").saveAsTable(name))
```

## Part C — Engineer a curated CRM table using a Notebook (30 min)
1. Create a **Notebook** named `NB_CRM_Transform_L03`.
2. Attach `CRM_Lakehouse_L03` as its default Lakehouse and start a Spark session.
3. In the first cell, run:
```python
from pyspark.sql import functions as F
sales = spark.table("sales")
customers = spark.table("customers")
products = spark.table("products")
print("sales", sales.count(), "customers", customers.count(), "products", products.count())
```
4. In the second cell, run:
```python
curated = (sales.alias("s")
    .join(customers.alias("c"), F.col("s.CustomerID") == F.col("c.CustomerID"), "inner")
    .join(products.alias("p"), F.col("s.ProductID") == F.col("p.ProductID"), "inner")
    .select(F.col("s.SaleID"), F.col("s.CustomerID").alias("CustomerID"),
            F.col("c.CustomerName"), F.col("c.Region"), F.col("p.ProductName"),
            F.col("p.Category"), F.to_date(F.col("s.SaleDate")).alias("SaleDate"),
            F.col("s.Quantity").cast("int").alias("Quantity"),
            F.col("s.Revenue").cast("double").alias("Revenue")))
curated.write.format("delta").mode("overwrite").saveAsTable("crm_sales_curated")
print("curated rows:", curated.count())
```
5. Confirm the output is **60**. Select the curated table in the Lakehouse Tables explorer and inspect its schema.
6. Run this validation cell:
```python
spark.table("crm_sales_curated").agg(F.sum("Revenue").alias("TotalRevenue")).show()
```
**Expected:** 739000.0.

## Part D — Query with the Lakehouse SQL analytics endpoint (15 min)
1. Open the Lakehouse SQL analytics endpoint and refresh until `crm_sales_curated` is visible.
2. Run:
```sql
SELECT Region, COUNT(*) AS Transactions, SUM(Revenue) AS Revenue
FROM dbo.crm_sales_curated
GROUP BY Region
ORDER BY Revenue DESC;
```
3. Run:
```sql
SELECT YEAR(SaleDate) AS SalesYear, MONTH(SaleDate) AS SalesMonth,
       SUM(Revenue) AS Revenue
FROM dbo.crm_sales_curated
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
ORDER BY SalesYear, SalesMonth;
```
4. Explain the difference between this read-oriented SQL endpoint and a separate Fabric Warehouse, which supports SQL-first data warehousing and write operations.

## Part E — Create a Power BI report (25–35 min)
1. From the workspace or Lakehouse, choose an available **New semantic model** / **Create semantic model** action for the curated Lakehouse table. Depending on tenant/version, the model creation flow may be separate from the Lakehouse item.
2. Name the model `SM_CRM_Sales_L03`; include `crm_sales_curated`. Choose a supported connection/storage mode, such as Direct Lake when available.
3. Open the semantic model and choose **Create report** / **New report**.
4. Add a **Card** visual with sum of `Revenue` (expected 739000).
5. Add a **Clustered bar chart** with `Region` as category and sum of `Revenue` as value.
6. Add a **Line chart** with `SaleDate` grouped by month on the axis and sum of `Revenue` as value. Ensure months sort chronologically.
7. Add a **Slicer** for `Category` and test that selecting a product category filters the charts.
8. Save the report as `RPT_CRM_Sales_L03` to your workspace.
9. Optionally add a separate opportunity-stage visual by including the `opportunities` table in the semantic model; do not join it directly to sales on CustomerID because that can multiply rows. Use a proper shared customer dimension or separate measures.

**Expected:** Revenue card 739000 before slicer filtering; bar chart by region; monthly trend; category slicer. If semantic model/report creation is blocked by license or permissions, submit SQL results and document the blocker.

## Part F — Explore Data Warehouse (optional, 15–20 min)
1. In the workspace select **+ New item** → **Warehouse** and name it `CRM_Warehouse_L03`.
2. Open its SQL editor and inspect schemas and table creation options.
3. Create a simple demonstration table (if permitted):
```sql
CREATE TABLE dbo.CRMRevenueTarget (
    Region VARCHAR(30),
    TargetAmount DECIMAL(18,2)
);
INSERT INTO dbo.CRMRevenueTarget (Region, TargetAmount)
VALUES ('North', 200000), ('South', 200000), ('East', 200000), ('West', 200000);
SELECT * FROM dbo.CRMRevenueTarget;
```
4. Compare Warehouse (SQL-first managed tables and DML) with Lakehouse (Files + Delta Tables + Spark and SQL analytics endpoint). Do not attempt the Warehouse INSERT in the Lakehouse SQL analytics endpoint.

## Architecture review (5 min)
Draw: `CSV files → OneLake Files → Data Factory Copy → Lakehouse Delta tables → Spark Notebook curated table → SQL analytics endpoint / semantic model → Power BI report`. Place **Warehouse** as an optional downstream SQL-serving component. Label the workspace as the collaboration/security boundary and Fabric capacity as the compute/licensing resource.

## Validation checklist
- [ ] Dedicated workspace and Lakehouse created.
- [ ] Four raw CSV files uploaded.
- [ ] Pipeline executed successfully **or** ingestion fallback explicitly documented.
- [ ] Four base Delta tables and one curated Delta table created.
- [ ] Curated row count 60; revenue 739000.
- [ ] SQL regional and monthly queries run.
- [ ] Power BI report saved or access limitation documented.
- [ ] Optional Warehouse exercise completed if time/permissions allow.

## Troubleshooting
- **Copy activity connector or mapping differs:** use the Copy data assistant and check the current source/destination connector capabilities; fall back to Notebook and document the difference.
- **Spark notebook cannot find tables:** attach the correct default Lakehouse, check exact table names, rerun ingestion.
- **Revenue is string:** cast to numeric during transformation and verify nulls introduced by failed conversion.
- **SQL endpoint table missing:** wait for Lakehouse metadata synchronization and refresh.
- **Direct Lake unavailable:** use a supported semantic model connection mode and note the reason.
- **Report totals wrong:** inspect joins for duplicate customer/product keys and ensure revenue is summed, not counted.

## Completion evidence
Submit workspace/Lakehouse names, pipeline run status, Notebook result, SQL query screenshot, and report screenshot or documented limitation. This lab is independent of Labs 01 and 02.
