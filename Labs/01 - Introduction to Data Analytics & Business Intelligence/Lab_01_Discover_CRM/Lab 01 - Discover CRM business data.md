# Lab 01 — Discover CRM business data

> **Learner path:** [Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md). Use **`Lab_01_Discover_CRM/data/`** only. Record answers in [Learner_Worksheet.md](../Learner_Worksheet.md).

## At a glance

| Item | Detail |
|------|--------|
| Time | About 45–60 minutes including first-time Fabric setup |
| You will use | Fabric workspace, Lakehouse, file upload, SQL analytics endpoint |
| You will not use | Power BI Desktop, pipelines, notebooks |
| Sample data | [`Lab_01_Discover_CRM/data/`](./data/) |

## Description

Explore fictional CRM and sales exports in Microsoft Fabric before building dashboards. You classify data by structure, document grain and relationships, separate dimensions from measures, and validate totals with read-only SQL on a Lakehouse.

## Use case

A sales manager receives static exports from CRM and order systems. Analytics must start with **what the files mean**, how they relate, and which business questions they can answer—not with charts.

## Scenario

You join the analytics team for a fictional B2B company. Leadership wants revenue and customer insight, but the first delivery is a folder of CSV, JSON, and text files. Your job is to produce a concise data dictionary: sources, formats, keys, grain, proposed relationships, and three questions the data can support.

## Learning objectives

By the end of this lab you can:

- Distinguish structured, semi-structured, and unstructured sources
- Define row grain for customer, product, and sales tables
- Propose one-to-many relationships using business keys
- Classify fields as dimensions, measures, or identifiers
- Run simple aggregations and joins on the Lakehouse SQL endpoint

## Prerequisites

- Organization account and access to https://app.fabric.microsoft.com
- Permission to create a workspace and Lakehouse on **Fabric capacity** (not Pro/PPU shared capacity alone)
- This module folder on your computer (including the `data/` path below)
- No prior SQL or Power BI required

## Fabric resources for this lab

Replace `<id>` with your initials (example: `js` → workspace `M1_L01_js`).

| Resource | Name |
|----------|------|
| Workspace | `M1_L01_<id>` |
| Lakehouse | `lh_m1_l01` |

## Sample data

Upload files from this folder (**do not edit** file contents):

[`Lab_01_Discover_CRM/data/`](./data/)

| File | Load to Delta table? | Table name |
|------|:--------------------:|------------|
| `customers.csv` | Yes | `customers` |
| `products.csv` | Yes | `products` |
| `sales.csv` | Yes | `sales` |
| `activities.json` | No — keep under **Files** only | — |
| `customer_note.txt` | No — keep under **Files** only | — |
| `queries.sql` | Optional — same queries are in Step 4 below | — |

---

## Progress checklist

Copy this list to your notes and check items off as you go.

- [ ] **Setup A** — Workspace `M1_L01_<id>` created; Fabric capacity confirmed  
- [ ] **Setup B** — Lakehouse `lh_m1_l01` created; **Files** and **Tables** visible  
- [ ] **Setup C** — Five files uploaded to **Files**  
- [ ] **Setup D** — Three CSVs loaded to tables `customers`, `products`, `sales`  
- [ ] **Setup E** — SQL endpoint open; can see the three tables  
- [ ] **Steps 1–5** — Exercise completed; worksheet filled  
- [ ] **Submission** — Ready to hand in  
- [ ] **Cleanup** — Lakehouse deleted  

---

## Fabric environment setup

Complete **Setup A through E** before the exercise. Do not start Step 1 until Setup E checkpoint passes.

### Setup A — Create a dedicated workspace

1. Sign in at https://app.fabric.microsoft.com.
2. In the left navigation, select **Workspaces**.
3. Select **New workspace** (or the **New workspace** card on **Home**).
4. **Workspace name:** `M1_L01_<id>` (your initials).
5. **Description (optional):** `Module 1 Lab 01 — synthetic CRM data`.
6. Select **Apply**.
7. Open **Workspace settings** (gear on the workspace toolbar, or **…** next to the workspace name).
8. Select **Workspace type** (or **License** / **License info** on older tenants).
9. Confirm the workspace uses **Fabric capacity** (F SKU or assigned trial). If none is listed, contact your instructor or IT—you cannot complete this lab on Pro/PPU shared capacity alone.
10. Return to the workspace home; you should see an empty item list or **New item**.

**Checkpoint:** You can open workspace `M1_L01_<id>` and capacity is assigned.

### Setup B — Create a Lakehouse

1. Inside the workspace, select **+ New item** or **New item**.
2. In the search box, type **Lakehouse** and select the **Lakehouse** item type.
3. **Name:** `lh_m1_l01`.
4. Select **Create** (keep default schema options if shown).
5. When the Lakehouse opens, confirm the left pane shows **Files** and **Tables**.

**Checkpoint:** Explorer shows **Files** and **Tables** for `lh_m1_l01`.

### Setup C — Upload sample files

1. On the Lakehouse menu, select **Get data** → **Upload files**.

   **If you do not see that:** open **Files** → **…** (More) → **Upload** → **Upload files**.
2. In the file picker, go to this folder on your PC:

   `…/01 - Introduction to Data Analytics & Business Intelligence/Lab_01_Discover_CRM/data/`
3. Select these five files (Ctrl+click to multi-select if supported):

   `customers.csv`, `products.csv`, `sales.csv`, `activities.json`, `customer_note.txt`
4. Select **Upload** and wait until each file shows success.
5. Open **Files** and confirm all five file names appear.

**Checkpoint:** Five files under **Files**; no tables required yet.

### Setup D — Load CSVs into tables

Repeat for **each CSV only** (not JSON or TXT):

1. Under **Files**, hover the CSV → select **…** → **Load to Tables** → **New table**.
2. **Table name:** use the name from the sample data table (`customers`, `products`, or `sales`).
3. If prompted for **Schema**, choose **dbo**.
4. Confirm **Delimiter** = comma and **First row as header** = yes. Preview should show separate columns—not one combined column.
5. Select **Load** and wait for success.
6. Expand **Tables** → **dbo** (if shown) → select the table and preview rows.

**Checkpoint:** Three tables exist; JSON and TXT remain files only.

### Setup E — Open the SQL analytics endpoint and run a test query

1. Select **Workspaces** in the left navigation and open workspace `M1_L01_<id>`.
2. In the item list, find **SQL analytics endpoint** for lakehouse `lh_m1_l01` (name may include “SQL analytics endpoint” or the lakehouse name). Select it to open the SQL editor.
   - **Alternative:** From inside the Lakehouse, use the link or menu entry to open the **SQL analytics endpoint** if your tenant shows it there.
3. In the object explorer, expand **Tables** until you see `customers`, `products`, and `sales`. If empty, wait 1–2 minutes and select **Refresh**.
4. Select **New SQL query** in the ribbon.
5. Paste and run:

```sql
SELECT TOP (3) * FROM dbo.customers;
```

6. Confirm you see customer rows in the **Results** pane.

**Checkpoint:** Test query returns data. If it fails, see **Help and troubleshooting** before continuing.

Read-only queries only in this lab—do not `UPDATE` or `DELETE` data.

---

## Step-by-step exercise

Use [Learner_Worksheet.md](../Learner_Worksheet.md) **Lab 01** section as you work.

### Step 1 — Identify sources and formats

1. In the Lakehouse **Files** area, open `customers.csv`. Notice fixed columns and one row per customer.
2. Open `sales.csv`. Find columns `SalesLineID`, `SaleDate`, `CustomerID`, `ProductID`, `Quantity`, `Revenue`.
3. Open `activities.json` (preview in Fabric or open the file in Notepad). Compare the two JSON records—fields inside `Details` differ between rows.
4. Open `customer_note.txt`. Notice business meaning is in plain sentences, not columns.
5. In your worksheet, classify: CSV tables = **structured**; JSON = **semi-structured**; note = **unstructured**.

**You should understand:** These are static file exports, not a live CRM connection.

### Step 2 — Grain, keys, and relationships

1. In **Tables**, preview `customers`. Count rows (expect **4**). Primary business key: `CustomerID`.
2. Preview `products` (**2** rows). Key: `ProductID`.
3. Preview `sales` (**6** rows). Each row is one **sales line** (grain = sales line). There is no `OrderID`, so you cannot count orders.
4. Find sales line `S001`: note `CustomerID` = `C001` and `ProductID` = `P01`. Look up names in customer and product tables.
5. Find `S004` for the same customer `C001` with a different product—multiple lines per customer is normal.
6. In your worksheet, write:
   - `customers.CustomerID` (one) → `sales.CustomerID` (many)  
   - `products.ProductID` (one) → `sales.ProductID` (many)
7. Add one sentence: matching IDs describe intent; Fabric does not enforce relationships until you model them in analytics tools.

**Self-check:** `S001` should read as Aster School, Learning License, quantity 2, line revenue ₹10,000.

### Step 3 — Classify fields

In your worksheet, classify each field group:

- From **customers** and **products:** names, region, category → typically **dimensions** (descriptors).
- **Quantity**, **Revenue** on sales → **measures** (numeric facts).
- **CustomerID**, **ProductID**, **SalesLineID** → **identifiers** / keys.

**Important:** `Revenue` is **line revenue** already. Do **not** multiply `Revenue × Quantity`.

See **Verify your work (Lab 01)** at the end of this page after you attempt classification.

### Step 4 — Validate with SQL

In the SQL analytics endpoint, run **one query at a time**.

**Query 1 — totals**

```sql
SELECT COUNT(*) AS SalesLines,
       SUM(CAST(Quantity AS int)) AS Units,
       SUM(CAST(Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales;
```

**Expected results:** `SalesLines` = 6, `Units` = 10, `Revenue` = 70000.00.

Copy these into your worksheet. If different, recheck Setup D (wrong file or double load).

**Query 2 — join for context**

```sql
SELECT s.SalesLineID, c.CustomerName, p.ProductName, s.Quantity, s.Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.CustomerID = c.CustomerID
JOIN dbo.products p ON s.ProductID = p.ProductID
ORDER BY s.SalesLineID;
```

**Expected:** **6 rows**—one per sales line, with customer and product names added.

### Step 5 — Business questions and operational vs analytical

Write **three** business questions your data could answer and list fields/tables needed. Examples to adapt (do not copy blindly):

| Question idea | Fields / logic |
|---------------|----------------|
| Revenue by region | Join `sales` to `customers`; sum `Revenue` by `Region` |
| Revenue by product | Join `sales` to `products`; sum by `ProductName` |
| How many customers bought? | Count distinct `CustomerID` in `sales` |

In your worksheet:

- Give one **operational** task example (e.g. enter a new sale in CRM).
- Give one **analytical** task example (e.g. compare revenue by region).

---

## Submission

Hand in (or save) your completed **Lab 01** section of [Learner_Worksheet.md](../Learner_Worksheet.md), including:

- Grain and keys for customers, products, sales  
- Two relationships with cardinality  
- Field classifications  
- Three business questions  
- SQL totals matching 6 / 10 / 70000.00  
- Explanation: **why six sales lines are not six orders**

---

## Cleanup

1. Save your worksheet locally or submit to your instructor.
2. In workspace `M1_L01_<id>`, find lakehouse `lh_m1_l01` → **…** → **Delete** → confirm.

   This removes uploaded files and tables for this lab only.
3. Do not delete shared class workspaces or other learners’ items.

---

## Help and troubleshooting

| Symptom | Likely cause | What to do |
|---------|--------------|------------|
| No **Lakehouse** in New item | Workspace not on Fabric capacity | Fix Setup A step 8–9 |
| **Load to Tables** missing | File not uploaded | Repeat Setup C |
| All columns merged into one | Wrong delimiter | Reload table; set comma delimiter |
| SQL: invalid object `dbo.sales` | Table not loaded or wrong schema | Complete Setup D; use schema from explorer |
| SQL: no results yet | Metadata delay | Wait and refresh explorer |
| Numbers do not match Expected | Wrong lab folder or duplicate load | Delete tables; reload from `Lab_01_Discover_CRM/data/` only |

---

## Verify your work (Lab 01)

Use this **after** you try Steps 1–5 yourself.

| Topic | Reference answer |
|-------|------------------|
| Formats | CSV = structured; JSON = semi-structured; TXT note = unstructured |
| Grain | Customers: one row per customer; Sales: one row per sales line |
| Relationships | Customer 1→many Sales; Product 1→many Sales |
| Dimensions (examples) | `CustomerName`, `Region`, `ProductName`, `Category`, `SaleDate` |
| Measures | `Quantity`, `Revenue` |
| SQL totals | 6 lines, 10 units, ₹70,000 revenue |
