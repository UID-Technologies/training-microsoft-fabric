# Lab 02 — Design a medallion CRM Lakehouse

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_02_Medallion_CRM_Lakehouse/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–120 minutes |
| You will use | Lakehouse **Files** (bronze paths), Delta **Tables**, **Notebook** (PySpark), SQL analytics endpoint |
| Standalone | Yes — new workspace; does not require Lab 01 artifacts |
| Sample data | [`Lab_02_Medallion_CRM_Lakehouse/data/`](./data/) — six CRM entities |

## Description

Implement **Hands-on 4**: a **medallion** CRM Lakehouse on OneLake. Land **Customers, Leads, Opportunities, Products, Sales, and Targets** in **Bronze**, apply light quality rules in **Silver**, and publish **Gold** analytics tables for revenue, pipeline, and target tracking.

## Use case

Leadership wants one governed CRM lake design before pipelines and semantic models (Modules 5–10). You document how **Bronze** preserves sources, **Silver** enforces quality, and **Gold** exposes business-ready tables.

## Learning objectives

By the end of this lab you can:

- Map CRM entities into **Bronze / Silver / Gold** tables on a single Lakehouse
- Land raw files under **Files/bronze/** and register **Delta** bronze tables
- Apply transforms (dedupe, casing, required fields) in a **Notebook**
- Query **Gold** tables from the **SQL analytics endpoint**
- Explain how this design scales with pipelines and a future **Warehouse** item

## Prerequisites

- Fabric workspace on **capacity**
- Comfort running a provided Notebook cell-by-cell (minimal PySpark editing)
- Lab 01 concepts recommended; not required

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M4_L02_<id>` |
| Lakehouse | `lh_m4_crm` |
| Notebook | `nb_m4_medallion` (you create) |

## Sample data

Upload from **`Lab_02_Medallion_CRM_Lakehouse/data/`** (synthetic INR-style fictional values):

| File | Bronze table | Rows (approx.) |
|------|--------------|----------------|
| `customers.csv` | `bronze_customers` | 18 |
| `products.csv` | `bronze_products` | 6 |
| `leads.csv` | `bronze_leads` | **26** (includes duplicate `LeadID`) |
| `opportunities.csv` | `bronze_opportunities` | 28 |
| `sales.csv` | `bronze_sales` | 45 |
| `targets.csv` | `bronze_targets` | 12 |

---

## Progress checklist

- [ ] Workspace `M4_L02_<id>` + lakehouse `lh_m4_crm`  
- [ ] Six files under **Files/bronze/**  
- [ ] Six **bronze_** Delta tables  
- [ ] Notebook builds **silver_** and **gold_** tables  
- [ ] SQL validation passes  
- [ ] Medallion diagram in submission notes (Part E)  
- [ ] Cleanup (if instructed)  

---

## Part A — Workspace and Lakehouse (10 min)

1. Create workspace `M4_L02_<id>` on Fabric capacity.  
2. **+ New item** → **Lakehouse** → `lh_m4_crm`.  
3. Create **Files** folder `bronze`.  
4. Upload all six CSVs from this lab’s **`data/`** folder into `Files/bronze/`.

---

## Part B — Bronze layer (25 min)

**Goal:** Raw-aligned Delta tables plus files retained in OneLake.

### B1 — Load bronze tables (UI or Notebook)

**Option UI:** For each CSV, use **Load to Tables** and name tables:

- `bronze_customers`, `bronze_products`, `bronze_leads`, `bronze_opportunities`, `bronze_sales`, `bronze_targets`

**Option Notebook** — create `nb_m4_medallion`, attach `lh_m4_crm`, run:

```python
from pyspark.sql import functions as F

bronze_tables = [
    "customers", "products", "leads",
    "opportunities", "sales", "targets",
]
for name in bronze_tables:
    path = f"Files/bronze/{name}.csv"
    df = (spark.read.option("header", "true")
          .option("inferSchema", "true")
          .csv(path))
    if name == "sales":
        df = df.withColumn("Revenue", F.col("Revenue").cast("decimal(18,2")))
        df = df.withColumn("Quantity", F.col("Quantity").cast("int"))
    bronze_name = f"bronze_{name}"
    df.write.format("delta").mode("overwrite").saveAsTable(bronze_name)
    print(bronze_name, spark.table(bronze_name).count())
```

**Bronze validation counts:**

| Table | Expected count |
|-------|----------------|
| bronze_customers | 18 |
| bronze_products | 6 |
| bronze_leads | 26 |
| bronze_opportunities | 28 |
| bronze_sales | 45 |
| bronze_targets | 12 |

**SQL check:**

```sql
SELECT SUM(CAST(Revenue AS decimal(18,2))) AS BronzeRevenue FROM dbo.bronze_sales;
```

**Expected BronzeRevenue:** **1946250.00**

**Teaching point — Bronze:** Keep source fidelity; `leads.csv` intentionally has a duplicate `L012`, lowercase `north`, and a blank company on `L018`.

---

## Part C — Silver layer (30 min)

**Goal:** Consistent types, deduped leads, trimmed text — still entity-level tables.

Add a new Notebook cell (still attached to `lh_m4_crm`):

```python
from pyspark.sql import functions as F

def copy_silver(bronze, silver, extra=None):
    df = spark.table(bronze)
    if extra:
        df = extra(df)
    df.write.format("delta").mode("overwrite").saveAsTable(silver)
    print(silver, spark.table(silver).count())

copy_silver(
    "bronze_customers", "silver_customers",
    lambda d: d.withColumn("CustomerName", F.trim("CustomerName"))
              .withColumn("Region", F.initcap(F.trim("Region"))),
)

copy_silver(
    "bronze_products", "silver_products",
    lambda d: d.withColumn("ProductName", F.trim("ProductName")),
)

copy_silver(
    "bronze_leads", "silver_leads",
    lambda d: (d.dropDuplicates(["LeadID"])
                .withColumn("CompanyName", F.trim("CompanyName"))
                .withColumn("Region", F.initcap(F.trim("Region")))
                .filter(F.length(F.col("CompanyName")) > 0)),
)

for b, s in [
    ("bronze_opportunities", "silver_opportunities"),
    ("bronze_sales", "silver_sales"),
    ("bronze_targets", "silver_targets"),
]:
    copy_silver(b, s)
```

**Silver validation:**

| Table | Expected count |
|-------|----------------|
| silver_leads | **24** |
| silver_sales | 45 |

```sql
SELECT COUNT(*) AS SilverLeads FROM dbo.silver_leads;
SELECT SUM(CAST(Revenue AS decimal(18,2))) FROM dbo.silver_sales;
```

**Expected:** SilverLeads **24**; revenue sum **1946250.00**.

Silver layer tables are the primary artifact in this lab (no extra `Files/silver/` copy required unless your instructor asks).

---

## Part D — Gold layer (25 min)

**Goal:** Business-ready aggregates for CRM analytics.

```python
from pyspark.sql import functions as F

sales = spark.table("silver_sales").alias("s")
cust = spark.table("silver_customers").alias("c")
opps = spark.table("silver_opportunities").alias("o")
targets = spark.table("silver_targets").alias("t")

# Gold 1 — revenue by region and month
rev = (sales.join(cust, "CustomerID")
       .withColumn("SaleMonth", F.date_format("SaleDate", "yyyy-MM"))
       .groupBy("Region", "SaleMonth")
       .agg(F.sum("Revenue").alias("Revenue")))
rev.write.format("delta").mode("overwrite").saveAsTable("gold_revenue_by_region_month")

# Gold 2 — open pipeline by region
pipe = (opps.join(cust, "CustomerID")
         .filter(F.col("Stage") == "Open")
         .groupBy("Region")
         .agg(F.sum("EstimatedValue").alias("OpenPipelineValue"),
              F.count("OpportunityID").alias("OpenOpportunityCount")))
pipe.write.format("delta").mode("overwrite").saveAsTable("gold_pipeline_by_region")

# Gold 3 — target vs actual revenue (January 2026 example)
actual_jan = (sales.join(cust, "CustomerID")
              .filter(F.date_format("SaleDate", "yyyy-MM") == "2026-01")
              .groupBy("Region")
              .agg(F.sum("Revenue").alias("ActualRevenueJanuary")))
tgt_jan = targets.filter(F.col("TargetMonth") == "2026-01")
vs = (tgt_jan.join(actual_jan, "Region", "left")
      .withColumn("ActualRevenueJanuary", F.coalesce("ActualRevenueJanuary", F.lit(0))))
vs.write.format("delta").mode("overwrite").saveAsTable("gold_target_vs_actual_jan")
```

**Gold validation SQL:**

```sql
SELECT COUNT(*) AS GoldRevRows FROM dbo.gold_revenue_by_region_month;
SELECT Region, OpenPipelineValue FROM dbo.gold_pipeline_by_region ORDER BY Region;
SELECT COUNT(*) AS GoldTargetRows FROM dbo.gold_target_vs_actual_jan;
```

**Expected highlights:**

| Check | Expected |
|-------|----------|
| `gold_revenue_by_region_month` rows | **≥ 4** (multiple months/regions) |
| Sum of revenue in gold matches silver | **1946250** total if summed across all gold revenue rows matches silver total |
| `gold_pipeline_by_region` | **4** regions |
| `gold_target_vs_actual_jan` | **4** rows |

```sql
SELECT SUM(Revenue) AS GoldTotal FROM dbo.gold_revenue_by_region_month;
```

**Expected GoldTotal:** **1946250**

---

## Part E — Design the CRM Lakehouse (15 min)

In your submission notes, draw or describe:

1. **Bronze** — which six entities and why you keep raw files in `Files/bronze/`.  
2. **Silver** — rules applied to **Leads** only (dedupe, region casing, blank company).  
3. **Gold** — purpose of each gold table.  
4. **Lakehouse vs Warehouse** — one sentence on when you would add a Fabric **Warehouse** star schema downstream of this lake.

Reference entity list from the course README: **Customers, Leads, Opportunities, Products, Sales, Targets**.

---

## Submission

Submit to your instructor either:

- Screenshots of **Tables** showing bronze/silver/gold names, or  
- SQL results for bronze revenue, silver lead count **24**, and gold revenue total **1946250**.

---

## Cleanup

When signed off, delete lakehouse `lh_m4_crm` in workspace `M4_L02_<id>` (or keep until Module 5 if instructor extends the story).

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| bronze_leads ≠ 26 | Reload from lab `data/` only; do not edit CSV |
| silver_leads ≠ 24 | Re-run Silver cell; confirm filter on `CompanyName` and dedupe on `LeadID` |
| Gold total mismatch | Cast `Revenue` in bronze load; re-run Gold |
| Tables missing in SQL | Wait 1–2 min; refresh endpoint |

---

## Verify your work (Lab 02)

| Item | Reference |
|------|-----------|
| Bronze entities | 6 tables + files under `bronze/` |
| bronze_leads rows | 26 |
| silver_leads rows | 24 |
| Total sales revenue | 1946250 |
| Gold tables | `gold_revenue_by_region_month`, `gold_pipeline_by_region`, `gold_target_vs_actual_jan` |
| Medallion | Bronze = raw, Silver = cleaned entities, Gold = business aggregates |