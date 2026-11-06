# Getting started — all labs

## Accounts and tools

| Lab type | Sign-in / software |
|----------|-------------------|
| **Microsoft Fabric** (Modules 1, 3, later Fabric modules) | https://app.fabric.microsoft.com with work or school account; **Fabric capacity** (F SKU or assigned trial) on your workspace |
| **Power BI Desktop** (Module 2) | [Install Power BI Desktop](https://powerbi.microsoft.com/desktop/) on Windows; sign in optional until publish exercises |

**Fabric capacity:** Pro or Power BI alone often **cannot** create Lakehouse, Notebook, Pipeline, or Warehouse. If **+ New item → Lakehouse** is missing or creation fails, ask your instructor to assign Fabric capacity to the workspace (**Workspace settings → Workspace type**).

**Power BI Service / publish:** Optional in Module 2 Lab 03. Requires a workspace you can publish to and appropriate license.

## How to work through a lab

1. Clone or download this repository and locate the module under `Labs/`.  
2. Open the lab Markdown file (example: `Lab 01 - ….md`).  
3. Replace `<id>` or `<initials>` in workspace names with your identifier (example: `js`).  
4. Complete **Setup** or **Part A** before exercise steps.  
5. Run SQL or DAX **one statement or measure at a time** unless the guide says otherwise.  
6. Record answers in the module worksheet or your own document.  
7. Submit what the lab **Submission** / **Completion evidence** section lists.

## Finding files on disk

Paths are relative to the lab folder. Example (Module 1):

```text
Labs/01 - Introduction…/Lab_01_Discover_CRM/data/customers.csv
```

Example (Module 2):

```text
Labs/02 - Power BI Fundamentals/Lab_01_Connect_Clean_Transform/data/CRM_Sales_Raw.csv
```

Example (Module 3):

```text
Labs/03 - Microsoft Fabric Fundamentals/Lab_02_CRM_Lakehouse/data/customers.csv
```

## When the UI does not match the guide

Microsoft updates Fabric and Power BI Desktop frequently. Use the **[Fabric and Power BI navigation reference](./_shared/Fabric-and-Power-BI-Navigation.md)** to find the equivalent action. Do not enable experimental previews unless your instructor asks you to.

## Getting help

| Symptom | First step |
|---------|------------|
| Lakehouse / pipeline unavailable | Confirm Fabric capacity on workspace |
| SQL tables empty | Finish **Load to Tables**; wait 1–2 min; refresh SQL explorer |
| Power Query errors on dates | Follow lab troubleshooting; remove bad type step before casting |
| Publish disabled | Complete local PBIX; skip optional Service steps |
| Wrong row counts | Confirm you used this lab’s `data/` folder only |

Module-specific tips: each module **README.md** and lab **Troubleshooting** section.
