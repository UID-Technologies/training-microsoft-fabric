# Lab 02 — Create a CRM Lakehouse and Explore OneLake

> **Learner path:** Read top to bottom. First Fabric lab? [Module 3 Getting-Started.md](../Getting-Started.md) and [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md).

**Module:** 3 — Microsoft Fabric Fundamentals  
**Duration:** 75–90 minutes  
**Standalone:** Yes — new workspace `CRM-M3-L02-<initials>`  
**Deliverable:** Lakehouse with four CSV files under **Files/raw** and four Delta **Tables**.

## Progress checklist

- [ ] Workspace on Fabric capacity  
- [ ] Lakehouse `CRM_Lakehouse_L02` created  
- [ ] Four CSVs uploaded to `Files/raw/` from **`Lab_02_CRM_Lakehouse/data/`**  
- [ ] Four tables loaded (UI or Notebook fallback)  
- [ ] SQL validation: 60 sales, revenue 739000  
- [ ] Cleanup or instructor sign-off  

## Business scenario
The CRM team receives exports for customers, products, sales and opportunities. Store raw extracts in OneLake Files, convert them into managed Lakehouse tables and verify the data is queryable.

## Sample data (upload from your PC)

Folder on disk (same folder as this lab guide):

**`Lab_02_CRM_Lakehouse/data/`**

| File | Purpose |
|------|---------|
| `customers.csv` | 20 rows |
| `products.csv` | 8 rows |
| `sales.csv` | 60 rows — total **Revenue 739000** |
| `opportunities.csv` | 30 rows |

Do not edit file contents. All values are synthetic.

## Environment and navigation notes
- Use a Microsoft Fabric-enabled tenant with a workspace assigned to supported Fabric capacity or an active Fabric trial. A free Power BI license alone does not guarantee Lakehouse, Notebook, Pipeline or Warehouse creation.
- Sign in at https://app.fabric.microsoft.com. Depending on your tenant, use **Workspaces** in the left navigation, **New workspace**, and **+ New item** inside a workspace. See [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md).
- Workspace name for this lab: **`CRM-M3-L02-<initials>`** — do not reuse Lab 01 or Lab 03 workspaces. If workspace creation is disabled, ask the instructor for a dedicated workspace with Contributor or higher permissions.
- Do not select production capacity or upload real customer information. The included CSV files are synthetic.
- If a command or item is unavailable, capture a screenshot and document the permission/capacity limitation instead of pretending it succeeded.

## Part A — Create workspace and Lakehouse (15 min)
1. Sign in to Fabric, open **Workspaces** and select **New workspace**.
2. Name the workspace `CRM-M3-L02-<initials>`. Confirm it has supported Fabric capacity/trial.
3. Inside the workspace select **+ New item** → **Lakehouse** (search for Lakehouse if necessary).
4. Name it `CRM_Lakehouse_L02`, then select **Create**.
5. Open the Lakehouse explorer and identify the **Tables** and **Files** sections. Note that the SQL analytics endpoint is associated with the Lakehouse for SQL-based exploration.

**Expected:** A Lakehouse item opens with separate Tables and Files areas.

## Part B — Upload raw CRM files to OneLake Files (15 min)
1. Expand **Files** in the Lakehouse explorer.
2. Create a folder called `raw` using the folder/new-folder option.
3. Open `raw`. Select **Get data → Upload files** or **Files → … → Upload → Upload files**. Select all four CSV files from **`Lab_02_CRM_Lakehouse/data/`** on your computer.
4. Wait until uploads complete; refresh the explorer if necessary.
5. Confirm these paths are visible beneath Files: `raw/customers.csv`, `raw/products.csv`, `raw/sales.csv`, `raw/opportunities.csv`.
6. Select a file to inspect its preview and check header names. If preview is unavailable, use file properties or download to verify.

**Teaching point:** Files holds raw objects; Tables is for tabular Delta data. Merely uploading CSV files to Files does not automatically create SQL-queryable Lakehouse tables.

## Part C — Load CSV files as Delta tables (20–25 min)
1. In **Files/raw**, locate `customers.csv`.
2. Use its context menu and select **Load to tables** → **New table** if available (the wording may be **Load to Tables** or a similar action).
3. Set table name `customers`. Inspect mapping, delimiter, header handling and inferred types, then start the load.
4. Repeat for `products.csv` → `products`, `sales.csv` → `sales`, and `opportunities.csv` → `opportunities`.
5. If a direct file-to-table action is unavailable in your tenant, create a **Notebook** in the same workspace, attach `CRM_Lakehouse_L02` as the default Lakehouse and run the fallback PySpark cells below. Skip the context-menu approach if using the fallback.
6. Refresh **Tables** and confirm all four tables are present.

### Notebook fallback — cell 1: load CSV into Delta tables
```python
from pyspark.sql import functions as F

for name in ["customers", "products", "sales", "opportunities"]:
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(f"Files/raw/{name}.csv"))
    df.write.format("delta").mode("overwrite").saveAsTable(name)
    print(name, spark.table(name).count())
```
**Note:** The Notebook must be attached to the Lakehouse; `Files/...` relative paths resolve against the default Lakehouse. If the UI-based load inferred a wrong type, recreate the affected table after correcting the schema.

## Part D — Inspect Tables and query data (15 min)
1. Select the `sales` table under **Tables**. Inspect the schema and preview.
2. Open the Lakehouse **SQL analytics endpoint** (often available from the Lakehouse item or experience switcher).
3. Allow time for the new Delta tables to appear. Refresh metadata if necessary.
4. Open a new SQL query and run:
```sql
SELECT COUNT(*) AS SalesRows, SUM(Revenue) AS TotalRevenue
FROM dbo.sales;
```
5. Run:
```sql
SELECT COUNT(*) AS CustomerRows FROM dbo.customers;
SELECT COUNT(*) AS ProductRows FROM dbo.products;
SELECT COUNT(*) AS OpportunityRows FROM dbo.opportunities;
```
6. Confirm counts 60, 20, 8 and 30, and revenue 739000. If schema is not `dbo`, use the schema shown in the explorer.
7. Note that the Lakehouse SQL analytics endpoint is intended for querying; use Spark, loading operations or other supported mechanisms to write Delta tables rather than attempting SQL INSERT into the endpoint.

## Part E — Explore OneLake (10 min)
1. Return to the Lakehouse and compare **Files/raw** with **Tables**.
2. Explain why OneLake provides the shared storage foundation and the Lakehouse gives an organized interface over files and Delta tables.
3. Optionally inspect OneLake using the Fabric portal or OneLake file explorer if installed and allowed by IT. This is not required for successful completion.
4. Record the Lakehouse name, four table names and raw file paths.

## Validation checklist
- [ ] New workspace and Lakehouse created.
- [ ] Four CSV files visible under Files/raw.
- [ ] Four Delta tables visible under Tables.
- [ ] SQL query returns 60 sales rows and 739000 revenue.
- [ ] Other row counts match 20/8/30.
- [ ] Learner can explain Files vs Tables vs OneLake.

## Troubleshooting
- **Upload disabled:** check workspace role, capacity and Lakehouse permissions.
- **Load to tables not shown:** use the provided Notebook fallback.
- **SQL endpoint tables missing:** wait for metadata synchronization and refresh.
- **Revenue is text:** inspect inferred types; cast Revenue to numeric in a Notebook before writing the table.
- **Table creation fails:** verify notebook has the correct default Lakehouse and Spark capacity is available.

## Completion evidence
Submit screenshot of Files/raw, screenshot of Tables, and SQL query results. No other lab is required.
