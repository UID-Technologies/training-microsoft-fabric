# Module 1 — Instructor guide

Trainer notes for **Introduction to Data Analytics & Business Intelligence**. Learners should use the individual **Lab 0N - …** markdown files; those documents are the single source of truth for setup and tasks.

## Lab plan

| Lab | Learner document | Sample data folder |
|-----|------------------|-------------------|
| 01 | [Lab 01 - Discover CRM business data](./Lab%2001%20-%20Discover%20CRM%20business%20data.md) | [data/Lab 01 - Discover CRM business data](./data/Lab%2001%20-%20Discover%20CRM%20business%20data/) |
| 02 | [Lab 02 - Investigate CRM data quality](./Lab%2002%20-%20Investigate%20CRM%20data%20quality.md) | [data/Lab 02 - Investigate CRM data quality](./data/Lab%2002%20-%20Investigate%20CRM%20data%20quality/) |
| 03 | [Lab 03 - Calculate CRM KPIs and recommend an action](./Lab%2003%20-%20Calculate%20CRM%20KPIs%20and%20recommend%20an%20action.md) | [data/Lab 03 - Calculate CRM KPIs and recommend an action](./data/Lab%2003%20-%20Calculate%20CRM%20KPIs%20and%20recommend%20an%20action/) |

Each lab uses its own workspace and lakehouse. SQL is copy-and-run; programming skill is not required.

## Before the session — checklist

1. Ensure learners have cloned or extracted this module folder so **`data/Lab 0N - …`** paths exist locally.
2. Confirm sign-in at https://app.fabric.microsoft.com with an organization account in the training tenant.
3. Arrange an active **Fabric capacity** (F SKU or approved trial) and workspace creation rights. Pro/PPU shared capacity alone does not run Lakehouse items.
4. Smoke-test: create a temporary lakehouse, upload a CSV, load a table, open the SQL endpoint, run `SELECT TOP (5)`, delete the item.
5. Assign each learner a short suffix (for example `vg01`) for workspace names; they replace `<id>` in lab instructions.
6. Keep source CSV files unchanged so expected answers stay reproducible.
7. Optional: distribute [Learner_Worksheet.md](./Learner_Worksheet.md) for written submissions.

## Navigation reminder

Use **Workspaces** in the left navigation → **New workspace**. Inside a workspace: **New item** → **Lakehouse**. Upload via **Get data → Upload files** or **Files → … → Upload**.

UI labels were checked against Microsoft documentation (November 2026). Tenant policies may hide controls; adjust verbally if needed.

## Facilitation tips

- **Lab 01:** Emphasize that six sales lines ≠ six orders; JSON is semi-structured.
- **Lab 02:** Do not let learners “fix” data in SQL; the point is an issue register and join-trap demo.
- **Lab 03:** Win rate is a **snapshot** definition, not a January close cohort; pipeline is not revenue.

Pick two labs if time is limited; Lab 01 + Lab 03 is a common pair.
