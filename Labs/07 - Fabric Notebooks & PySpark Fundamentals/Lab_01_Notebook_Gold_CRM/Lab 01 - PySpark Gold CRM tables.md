# Lab 01 — PySpark notebook: Gold CRM tables

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_01_Notebook_Gold_CRM/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–105 minutes |
| Hands-on | **Hands-on 7** — Gold tables from sales, opportunities, customers |
| Standalone | Workspace `M7_L01_<id>`, lakehouse `lh_m7_crm`, notebook `nb_m7_gold` |
| Sample data | [`data/`](./data/) — `customers.csv`, `opportunities.csv`, `sales.csv` |

## Description

Use a **Fabric notebook** and **PySpark** to read Lakehouse CRM data, transform **sales** and **opportunities**, **join** customers, **aggregate** revenue by region, and write **Delta** Gold tables. Run **Spark SQL** against Gold output and compare **notebook vs dataflow vs SQL**.

## Learning objectives

- Attach a notebook to a Lakehouse and work with **DataFrames**  
- **Read** CSV/ Delta tables; **select**, **filter**, **transform** columns  
- **Join** and **groupBy** aggregations  
- **Write** Delta Gold tables with `saveAsTable`  
- Query Gold tables with **Spark SQL** (`%%sql` or `spark.sql`)  

## Prerequisites

- Fabric workspace on **capacity**  
- No prior PySpark required — run provided cells, then adjust one filter yourself  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M7_L01_<id>` |
| Lakehouse | `lh_m7_crm` |
| Notebook | `nb_m7_gold` |

---

## Progress checklist

- [ ] Bronze tables loaded in lakehouse  
- [ ] Notebook attached to `lh_m7_crm`  
- [ ] Sales/opportunities transforms complete  
- [ ] `gold_revenue_by_region` and `gold_customer_opportunity` written  
- [ ] Spark SQL validation passes  
- [ ] Tooling comparison notes (Part H)  

---

## Part A — Lakehouse and Bronze tables (15 min)

1. Workspace `M7_L01_<id>` on Fabric capacity.  
2. **+ New item** → **Lakehouse** → `lh_m7_crm`.  
3. Create **Files** folder `bronze`.  
4. Upload `customers.csv`, `opportunities.csv`, `sales.csv` from this lab’s **`data/`** into `Files/bronze/`.  
5. Load each CSV to Delta tables (UI **Load to Tables** or Notebook):

```python
from pyspark.sql import functions as F

for name in ["customers", "opportunities", "sales"]:
    path = f"Files/bronze/{name}.csv"
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(path))
    if name == "sales":
        df = (df.withColumn("Revenue", F.col("Revenue").cast("decimal(18,2)))
              .withColumn("Quantity", F.col("Quantity").cast("int"))
              .withColumn("SaleDate", F.to_date("SaleDate")))
    if name == "opportunities":
        df = (df.withColumn("EstimatedValue", F.col("EstimatedValue").cast("decimal(18,2)))
              .withColumn("ExpectedCloseDate", F.to_date("ExpectedCloseDate")))
    df.write.format("delta").mode("overwrite").saveAsTable(f"bronze_{name}")
    print(f"bronze_{name}", spark.table(f"bronze_{name}").count())
```

**Expected counts:** `bronze_customers` **18**, `bronze_opportunities` **28**, `bronze_sales` **45**.

---

## Part B — Notebook setup and read Lakehouse data (10 min)

1. **+ New item** → **Notebook** → `nb_m7_gold`.  
2. Attach lakehouse **`lh_m7_crm`** as default.  
3. Cell 1 — confirm Spark and tables:

```python
display(spark.sql("SHOW TABLES").filter("tableName LIKE 'bronze_%'"))
```

4. Cell 2 — load DataFrames:

```python
customers = spark.table("bronze_customers")
opportunities = spark.table("bronze_opportunities")
sales = spark.table("bronze_sales")
print(customers.count(), opportunities.count(), sales.count())
```

---

## Part C — Transform sales and opportunities (20 min)

**Sales** — select, filter, transform:

```python
from pyspark.sql import functions as F

sales_clean = (sales
    .filter(F.col("Revenue") > 0)
    .select("SaleID", "CustomerID", "ProductID", "SaleDate", "Quantity", "Revenue")
    .withColumn("SaleYear", F.year("SaleDate"))
    .withColumn("SaleMonth", F.date_format("SaleDate", "yyyy-MM")))
sales_clean.cache()
print("sales_clean", sales_clean.count())
```

**Opportunities** — normalize stage, filter open pipeline for one Gold table:

```python
stage_norm = F.when(F.lower(F.col("Stage")).contains("won"), "Won") \
    .when(F.lower(F.col("Stage")).contains("lost"), "Lost") \
    .otherwise(F.col("Stage"))

opps_clean = (opportunities
    .withColumn("Stage", stage_norm)
    .filter(F.col("Stage").isin("Won", "Lost", "Open"))
    .select("OpportunityID", "CustomerID", "Stage", "EstimatedValue", "ExpectedCloseDate"))
print("opps_clean", opps_clean.count())
```

**Exercise:** Add a filter on `sales_clean` for `SaleYear == 2026` and note row count in your submission (should remain **45** for this dataset).

---

## Part D — Joins and Gold: revenue by region (25 min)

```python
sales_by_customer = sales_clean.join(customers, "CustomerID", "inner")

gold_revenue_by_region = (sales_by_customer
    .groupBy("Region")
    .agg(
        F.countDistinct("SaleID").alias("SaleCount"),
        F.sum("Revenue").alias("Revenue"),
        F.sum("Quantity").alias("Units")
    )
    .orderBy(F.desc("Revenue")))

gold_revenue_by_region.write.format("delta").mode("overwrite").saveAsTable("gold_revenue_by_region")
display(gold_revenue_by_region)
```

**Expected:** **4** rows (North, South, East, West). **Sum of `Revenue` = 1946250.00**.

---

## Part E — Gold: customer and opportunity join (20 min)

```python
gold_customer_opportunity = (customers.alias("c")
    .join(opps_clean.alias("o"), "CustomerID", "left")
    .select(
        "c.CustomerID", "c.CustomerName", "c.Region", "c.Industry",
        "o.OpportunityID", "o.Stage", "o.EstimatedValue", "o.ExpectedCloseDate"
    ))

gold_customer_opportunity.write.format("delta").mode("overwrite").saveAsTable("gold_customer_opportunity")

open_pipeline = (gold_customer_opportunity
    .filter(F.col("Stage") == "Open")
    .groupBy("Region")
    .agg(F.sum("EstimatedValue").alias("OpenPipelineValue"),
         F.count("OpportunityID").alias("OpenDeals")))

open_pipeline.write.format("delta").mode("overwrite").saveAsTable("gold_open_pipeline_by_region")
display(open_pipeline)
```

**Expected:** `gold_customer_opportunity` has **at least 28** rows with opportunities; customers without opps appear with null opportunity fields.

---

## Part F — Spark SQL on Gold tables (15 min)

In a new cell, use Spark SQL (notebook **%%sql** cell or):

```python
spark.sql("""
SELECT Region, SaleCount, Revenue
FROM gold_revenue_by_region
ORDER BY Revenue DESC
""").show()
```

```python
total = spark.sql("SELECT SUM(Revenue) AS Total FROM gold_revenue_by_region").collect()[0]["Total"]
print("Gold total revenue:", total)
```

**Expected `Total`:** **1946250**.

Optional — query open pipeline:

```sql
SELECT Region, OpenPipelineValue FROM gold_open_pipeline_by_region ORDER BY Region;
```

---

## Part G — When to use Notebook vs Dataflow vs SQL (5 min)

One sentence each for this CRM platform:

| Tool | Best when |
|------|-----------|
| **Notebook (PySpark)** | |
| **Dataflow Gen2** | |
| **Lakehouse SQL endpoint** | |

---

## Submission

- Workspace, lakehouse, notebook names  
- Screenshot or `display()` output for `gold_revenue_by_region`  
- Confirmed total revenue **1946250**  
- Part G comparison  

---

## Cleanup

Delete `nb_m7_gold`, `lh_m7_crm` when signed off.

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| `bronze_*` not found | Run Part A load; refresh notebook Spark session |
| Revenue not numeric | Cast `Revenue` in Part A load cell |
| Gold total mismatch | Re-run from `sales_clean`; confirm lab `data/` only |
| `%%sql` fails | Use `spark.sql(...)` in PySpark cell |

---

## Verify your work

| Check | Expected |
|-------|----------|
| Bronze sales rows | 45 |
| Gold regions | 4 |
| Gold total revenue | 1946250 |
| Gold tables | `gold_revenue_by_region`, `gold_customer_opportunity`, `gold_open_pipeline_by_region` |
| Hands-on 7 | Transforms, joins, aggregates, Delta Gold write, Spark SQL |