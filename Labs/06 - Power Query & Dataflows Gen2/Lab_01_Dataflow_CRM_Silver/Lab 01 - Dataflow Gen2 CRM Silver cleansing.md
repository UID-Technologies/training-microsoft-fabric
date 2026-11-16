# Lab 01 — Dataflow Gen2: cleanse CRM into Silver tables

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Source files from **`Lab_01_Dataflow_CRM_Silver/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 90–105 minutes |
| Hands-on | **Hands-on 6** — validated **Silver** CRM tables via **Dataflows Gen2** |
| Standalone | Workspace `M6_L01_<id>`, lakehouse `lh_m6_crm`, dataflow `df_m6_crm_silver` |
| Source data | `customers_source.csv`, `opportunities_source.csv`, `sales_source.csv` |

## Description

Use **Power Query** in **Dataflows Gen2** to fix CRM Bronze-style exports: duplicate customers, missing regions, invalid opportunity stages, bad dates, and inconsistent **salesperson** names. Publish cleansed tables to your Lakehouse as **Silver** (`silver_customers`, `silver_opportunities`, `silver_sales`).

## Learning objectives

- Build a **Dataflow Gen2** and set a **Lakehouse** destination  
- Apply types, **remove duplicates**, handle **nulls**, **filter**, and **conditional columns**  
- **Merge** sales to customers for region context; use **Group By** for validation  
- Create a **parameter** and compare **Dataflow vs pipeline vs notebook** for the same work  

## Prerequisites

- Fabric workspace on **capacity**  
- Familiarity with Power Query concepts (Module 2 helps; not required)  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M6_L01_<id>` |
| Lakehouse | `lh_m6_crm` |
| Dataflow Gen2 | `df_m6_crm_silver` |

---

## Progress checklist

- [ ] Lakehouse + files in `Files/bronze/`  
- [ ] Dataflow Gen2 with three queries  
- [ ] Parameter `p_min_revenue` used in sales query  
- [ ] Silver tables published to lakehouse  
- [ ] SQL validation totals match **Expected**  
- [ ] Short notes on Dataflow vs pipeline vs notebook  

---

## Part A — Lakehouse and Bronze files (15 min)

1. Create workspace `M6_L01_<id>` on Fabric capacity.  
2. **+ New item** → **Lakehouse** → `lh_m6_crm`.  
3. Create **Files** folder `bronze`.  
4. Upload all three CSVs from **`Lab_01_Dataflow_CRM_Silver/data/`** into `Files/bronze/`.

**Checkpoint:** Three files visible under `Files/bronze/`.

---

## Part B — Create Dataflow Gen2 (10 min)

1. **+ New item** → **Dataflow Gen2** (or **Dataflow (Gen2)**) → name `df_m6_crm_silver`.  
2. Choose **Get data** → **Text/CSV** or **OneLake / Lakehouse** (pick the option that reads `lh_m6_crm` / `Files/bronze/` in your tenant).  
3. Connect to `customers_source.csv` and open **Power Query** (Transform data).

**Note:** If only local upload is available, upload the same three files into the dataflow; still publish destination to `lh_m6_crm`. Record which source path you used.

---

## Part C — Query `Customers` → Silver (25 min)

Rename query **`Customers`**. Steps (order may vary slightly by UI):

1. Promote headers; set types: `CustomerID` (text), `Region` (text).  
2. **Remove duplicates** on `CustomerID` (keep first row).  
   - **Expected row count after step:** **14** (source has one duplicate `C005`).  
3. **Replace values** / conditional: blank `Region` → `Unspecified` (row `C012`).  
4. **Capitalize each word** or custom replace: `east` → `East` for `C013`.  
5. **Filter** null or blank `CustomerID` (none expected; keep as pattern).  
6. Rename query to **`silver_customers`** or map output table name **`silver_customers`** on publish.

---

## Part D — Query `Opportunities` → Silver (25 min)

1. New source: `opportunities_source.csv`.  
2. Add **conditional column** `Stage_Clean` (or replace `Stage`) using rules:

| If `Stage` contains / equals | Then |
|-----------------------------|------|
| `Won` or `Closed Won` | `Won` |
| `Lost` or `closed lost` | `Lost` |
| `Open`, `Negotiation`, `Pending`, `Proposal` | `Open` |
| Otherwise | `null` |

3. Remove old `Stage`; rename `Stage_Clean` → `Stage`.  
4. **Filter out** rows where `Stage` is null.  
5. Set `ExpectedCloseDate` type to **Date**; **remove rows with date errors** (invalid `2026-13-45`, `not-a-date`).  
   - **Expected silver rows:** **13** (15 source minus 2 bad dates; stage rules keep 15 until date filter).  
6. Set `EstimatedValue` to decimal/currency.  
7. Name output **`silver_opportunities`**.

---

## Part E — Query `Sales` → Silver (30 min)

1. New source: `sales_source.csv`.  
2. Create **parameter** `p_min_revenue` (Decimal), default **0** (Dataflow **Manage parameters** / **New parameter**).  
3. Trim and normalize **Salesperson**: trim text; **Replace values** `unknown rep` and null/blank → `Unassigned`; apply **Capitalize each word** (or equivalent) so `amy chen` → `Amy Chen`.  
4. Parse **SaleDate**: use **Data type** Date with locale, or split column for mixed formats; **remove rows** that do not parse (`not-a-date`, `32/01/2026`).  
   - **Expected rows after date clean:** **13** (15 minus `S007`, `S012`).  
5. Set numeric types for `Quantity`, `Revenue`.  
6. **Filter** `Revenue` >= `p_min_revenue`.  
7. **Merge** queries: **Merge** `Sales` with **`silver_customers`** on `CustomerID`, expand `Region` for a `CustomerRegion` column (left outer).  
8. **Group By** validation query (optional new query): group by `Salesperson`, count rows — keep for submission screenshot.  
9. Name output **`silver_sales`**.

**Append (concept):** In notes, state that you would **Append** separate monthly sales files into one query before these steps when Bronze has multiple drops.

---

## Part F — Dataflow destination and publish (15 min)

1. In Dataflow Gen2 settings, set **destination** to lakehouse **`lh_m6_crm`**.  
2. Map entities to tables **`silver_customers`**, **`silver_opportunities`**, **`silver_sales`** (overwrite/update per UI).  
3. **Publish** / **Refresh** the dataflow.  
4. Open `lh_m6_crm` → **Tables** and confirm three Silver tables.  

---

## Part G — Validate Silver (10 min)

Open the Lakehouse **SQL analytics endpoint** and run:

```sql
SELECT COUNT(*) AS CustomerRows FROM dbo.silver_customers;
SELECT COUNT(*) AS OpportunityRows FROM dbo.silver_opportunities;
SELECT COUNT(*) AS SalesRows, SUM(CAST(Revenue AS decimal(18,2))) AS Revenue
FROM dbo.silver_sales;
```

**Expected**

| Table | Rows | Notes |
|-------|------|--------|
| `silver_customers` | **14** | Deduped `C005` |
| `silver_opportunities` | **13** | Stages Won/Lost/Open only; bad dates removed |
| `silver_sales` | **13** | Revenue **153000** |

```sql
SELECT DISTINCT Stage FROM dbo.silver_opportunities;
```

**Expected stages only:** `Won`, `Lost`, `Open`.

---

## Part H — Dataflow vs pipeline vs notebook (5 min)

In submission notes, three bullets:

| Tool | Best for this CRM scenario |
|------|-----------------------------|
| **Dataflow Gen2** | |
| **Pipeline** | |
| **Notebook** | |

---

## Submission

- Workspace, dataflow, and lakehouse names  
- SQL validation screenshot or copied counts  
- Parameter `p_min_revenue` definition  
- Part H comparison  

---

## Cleanup

Delete dataflow and lakehouse in `M6_L01_<id>` when signed off (unless instructor keeps Silver for Module 7).

---

## Help and troubleshooting

| Symptom | What to do |
|---------|------------|
| No Dataflow Gen2 | Confirm Fabric capacity; try **Dataflow** under **+ New item** |
| Publish fails | Map data types; remove error rows in Power Query preview |
| Row counts differ | Re-check duplicate removal and date filter steps |
| Merge adds duplicates | Use many-to-one merge; `CustomerID` unique in silver_customers |

---

## Verify your work (Lab 01)

| Check | Reference |
|-------|-----------|
| Hands-on 6 | Silver tables with cleansed customers, opportunities, sales |
| Customers | 14 rows, no blank Region |
| Opportunities | 13 rows; only Won/Lost/Open |
| Sales | 13 rows; revenue 153000; normalized salesperson |
| Parameter | `p_min_revenue` filters sales |