# Lab 01 — Parameterized pipeline: Bronze ingest and monitoring

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Upload from **`Lab_01_Bronze_Pipeline_Ingest/data/`** only.

## At a glance

| Item | Detail |
|------|--------|
| Time | About 105–120 minutes |
| Hands-on | **Hands-on 5** — full Module 5 topic set in one pipeline lab |
| Standalone | Workspace `M5_L01_<id>`, lakehouse `lh_m5_crm`, pipeline `pl_m5_bronze_ingest` |
| Sample data | [`data/`](./data/) — six CRM CSVs + `sales_incremental.csv` |

## Description

From one **Data Factory** pipeline you will: land CRM files on OneLake, use **Copy data** with **connections** and **destinations**, add **parameters**, **variables**, and **expressions**, run **monitoring** and **retries**, handle a failed run, introduce **incremental** load, and note **scheduling** for production. All CRM datasets ingest into **`Files/bronze/`** (Bronze layer).

## Learning objectives

- Explain **pipeline vs activity** and Copy data **source/destination** on a Lakehouse  
- Configure **retry** policy and read **run history** and **Monitoring hub**  
- Recover from a **failed** activity run  
- Build **parameterized** paths with `@concat()`, `@if()`, and `pipeline().parameters`  
- Execute full Bronze ingest for six entities; outline **incremental** and **schedule** patterns  

## Prerequisites

- Fabric workspace on **capacity**  
- Basic Lakehouse navigation (Module 3 or 4 helpful)  

## Fabric resources

Replace `<id>` with your initials.

| Resource | Name |
|----------|------|
| Workspace | `M5_L01_<id>` |
| Lakehouse | `lh_m5_crm` |
| Pipeline | `pl_m5_bronze_ingest` |

## Sample data

| File | Rows (approx.) |
|------|----------------|
| `customers.csv` | 18 |
| `products.csv` | 6 |
| `leads.csv` | 26 data rows in Bronze source |
| `opportunities.csv` | 28 |
| `sales.csv` | 45 — revenue **1946250** |
| `targets.csv` | 12 |
| `sales_incremental.csv` | 2 (incremental demo) |

---

## Progress checklist

- [ ] Lakehouse folders `source`, `bronze`, `source/incremental`  
- [ ] Six CRM files in `Files/source/`  
- [ ] First successful **Copy data** run (`customers`)  
- [ ] Parameters, variable, expressions on one Copy activity  
- [ ] Six Full bronze loads + one Incremental demo  
- [ ] Monitoring hub + failed-run exercise  
- [ ] Submission notes (concepts + scheduling)  

---

## Part A — Lakehouse layout (10 min)

1. Create workspace `M5_L01_<id>` on Fabric capacity.  
2. **+ New item** → **Lakehouse** → `lh_m5_crm`.  
3. Under **Files**, create `source`, `bronze`, and `source/incremental`.  
4. Upload the six main CSVs from this lab’s **`data/`** into **`Files/source/`**.  
5. Upload `sales_incremental.csv` to `Files/source/incremental/` (used in Part G).

---

## Part B — First Copy data activity (20 min)

**Goal:** Learn **connections**, **destinations**, and activity settings before parameters.

1. **+ New item** → **Data pipeline** → `pl_m5_bronze_ingest`.  
2. Add **Copy data** named `Copy_to_bronze`.  
3. **Source:** Lakehouse `lh_m5_crm`, file `Files/source/customers.csv`, delimited text with header.  
4. **Destination:** Same lakehouse, **Files** path `Files/bronze/customers.csv` (or table `bronze_customers` if file copy unavailable).  
5. **Settings → Retry:** count **1**, interval **30** seconds.  
6. **Run** the pipeline (no parameters yet).  

**Checkpoint:** `customers.csv` appears under `Files/bronze/`.

**If file-to-file copy is blocked:** land to Delta table and note the limitation in your submission.

---

## Part C — Parameters, variable, and expressions (25 min)

Refactor the same pipeline so one Copy activity serves **all** datasets.

### Parameters

| Name | Type | Default |
|------|------|---------|
| `p_dataset` | String | `customers` |
| `p_load_mode` | String | `Full` |

Valid `p_dataset` values: `customers`, `products`, `leads`, `opportunities`, `sales`, `targets`.

### Variable

1. Add pipeline variable `v_run_note` (String).  
2. Insert **Set variable** `Set_run_note` **before** Copy:

```text
@concat('Bronze ingest ', pipeline().parameters.p_dataset, ' at ', utcnow())
```

### Copy paths (expressions)

Update `Copy_to_bronze` source/destination paths:

**Source:**

```text
@if(equals(pipeline().parameters.p_load_mode, 'Incremental'),
    concat('Files/source/incremental/', pipeline().parameters.p_dataset, '_incremental.csv'),
    concat('Files/source/', pipeline().parameters.p_dataset, '.csv'))
```

**Destination:**

```text
@concat('Files/bronze/', pipeline().parameters.p_dataset, '.csv')
```

Increase **Retry** to **2** / **60** seconds.

**Validate** the pipeline, run once with defaults (`customers`, `Full`) to confirm behavior matches Part B.

---

## Part D — Bronze ingest for all CRM entities (20 min)

Run the pipeline six times with **`p_load_mode` = `Full`**:

| Run | `p_dataset` |
|-----|-------------|
| 1 | customers |
| 2 | products |
| 3 | leads |
| 4 | opportunities |
| 5 | sales |
| 6 | targets |

Confirm **six files** in `Files/bronze/`. Optional: load `sales.csv` to a table and verify revenue **1946250**.

In notes: why **one parameterized pipeline** is preferable to six separate pipelines.

---

## Part E — Monitor runs (15 min)

1. Open pipeline **Run history** — list all runs with parameters used.  
2. For one run, record per-activity **status**, **duration**, and **rows/files copied**.  
3. Open **Monitoring hub**; filter by workspace `M5_L01_<id>`.  
4. Match a run from step 1 to Monitoring hub (same status/time).

**Teaching point:** Editor = detail for one pipeline; Monitoring hub = operations view across items.

---

## Part F — Error handling and retries (15 min)

1. Temporarily set destination path to an invalid location **or** point source to a missing file (instructor-approved safe test).  
2. Run and observe **Failed**; capture the **error** message.  
3. Fix the activity; **Run** again manually.  
4. In notes: difference between **automatic activity retry** (Settings) and **manual re-run**.

---

## Part G — Incremental loading introduction (10 min)

1. Run with `p_dataset` = `sales`, `p_load_mode` = `Incremental`.  
2. Source should resolve to `Files/source/incremental/sales_incremental.csv`.  
3. Document where the file landed in `Files/bronze/` and whether it overwrote `sales.csv`.  

Answer briefly:

- What **watermark** or control table would you use for real CRM incremental loads?  
- Why incremental loads still need **monitoring** and idempotent **retries**?  

---

## Part H — Scheduling and Data Factory concepts (10 min)

**Scheduling (concept only):** Describe a **daily schedule** that passes `Incremental` on weekdays and `Full` on Sunday — do not publish unless instructor approves.

One sentence each in submission notes:

| Topic | Your answer |
|-------|-------------|
| Pipeline vs activity | |
| Role of connection/linked service in Copy data | |
| Why Bronze uses `Files/bronze/` | |
| When to use **pipeline** vs **notebook** vs **dataflow** for cleansing (hint: Module 6) | |

---

## Submission

- Resource names (`M5_L01_*`, pipeline, lakehouse)  
- Proof of **six** bronze files  
- Expression snippets (`v_run_note`, source/destination paths)  
- Monitoring hub + failure/recovery notes  
- Incremental run + Part H concepts  

---

## Cleanup

Delete `lh_m5_crm` and `pl_m5_bronze_ingest` when signed off.

---

## Verify your work

| Check | Expected |
|-------|----------|
| Copy data + connections | Customers copy successful (Part B) |
| Parameters / expressions | Six datasets to bronze (Part D) |
| Monitoring + retries | Part E–F completed |
| Incremental | Part G attempted |
| Hands-on 5 | Parameterized Bronze ingest + monitoring |
| Sales revenue (optional SQL) | **1946250** |