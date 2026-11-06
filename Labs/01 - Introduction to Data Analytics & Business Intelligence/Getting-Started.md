# Getting started — Module 1 labs (learners)

Use this page once, then follow **one lab file from top to bottom** for each exercise.

## What you need

| Requirement | Details |
|-------------|---------|
| Account | Work or school Microsoft account that can open [Microsoft Fabric](https://app.fabric.microsoft.com) |
| Capacity | Your workspace must use **Fabric capacity** (F SKU or an assigned trial). If Lakehouse creation fails, ask your instructor or IT to assign capacity—not Power BI Pro alone. |
| Files | This module folder on your PC, including each lab’s **`Lab_0N_…/data/`** folder |
| Tools | A web browser; optional: [Learner_Worksheet.md](./Learner_Worksheet.md) or any text editor for answers |
| Skills | No prior SQL or Power BI required—you will copy and run provided queries |

## Which lab should I open?

| If you are doing… | Open this file |
|-------------------|----------------|
| Lab 1 | [Lab_01_Discover_CRM/Lab 01 - Discover CRM business data.md](./Lab_01_Discover_CRM/Lab%2001%20-%20Discover%20CRM%20business%20data.md) |
| Lab 2 | [Lab_02_Investigate_Data_Quality/Lab 02 - Investigate CRM data quality.md](./Lab_02_Investigate_Data_Quality/Lab%2002%20-%20Investigate%20CRM%20data%20quality.md) |
| Lab 3 | [Lab_03_Calculate_CRM_KPIs/Lab 03 - Calculate CRM KPIs and recommend an action.md](./Lab_03_Calculate_CRM_KPIs/Lab%2003%20-%20Calculate%20CRM%20KPIs%20and%20recommend%20an%20action.md) |

Labs **do not** depend on each other. Each lab uses a **new** workspace and lakehouse.

## How to complete any lab (same flow every time)

1. **Read** Description, Use case, and Scenario so you know the business goal.
2. **Replace `<id>`** in workspace names with your initials (example: `M1_L01_js`).
3. **Complete Setup A → E** in order. Do not skip checkpoints.
4. **Upload** files only from **that lab’s `data/` folder**—do not change file contents.
5. **Work through each exercise step**; run SQL one query at a time; compare results to **Expected** values.
6. **Record answers** in [Learner_Worksheet.md](./Learner_Worksheet.md) or your own document.
7. **Submit** what the lab’s Submission section lists (to your instructor or LMS).
8. **Cleanup** — delete **your** lab lakehouse when finished so you do not leave test data in the tenant.

## Finding sample data on your computer

Example for Lab 1:

```text
…/01 - Introduction to Data Analytics & Business Intelligence/Lab_01_Discover_CRM/data/customers.csv
```

In File Explorer, browse to that lab’s **`data`** folder when Fabric asks you to choose files to upload.

## Quick troubleshooting

| Problem | What to try |
|---------|-------------|
| Cannot create Lakehouse | Open workspace **Settings** → **Workspace type** → confirm Fabric capacity is assigned. |
| **Upload files** menu missing | Use **Files** → **…** → **Upload** → **Upload files**. |
| SQL endpoint shows no tables | Wait 1–2 minutes; refresh the object explorer; confirm CSVs were **Load to Tables** (Setup D). |
| Query fails on `dbo.sales` | In the SQL explorer, note the schema name shown (might not be `dbo`) and replace `dbo` in queries. |
| Revenue numbers do not match Expected | Confirm you loaded files from the correct lab **`data/`** folder only. |
| Windows hid `.csv` as `.csv.txt` | In File Explorer enable **View → File name extensions**; rename before upload. |

More detail is in each lab under **Help and troubleshooting**.

**UI labels:** [Fabric and Power BI navigation reference](../_shared/Fabric-and-Power-BI-Navigation.md)

## Need the big picture?

See the [Module 1 README](./README.md) for folder layout and topic list. Instructors use [Instructor-Guide.md](./Instructor-Guide.md)—learners do not need it to complete labs.
