# Getting started — Module 2 (Power BI Desktop labs)

## Before Lab 01

1. Install **Power BI Desktop** on Windows and launch it once.  
2. Download this repo and locate `Labs/02 - Power BI Fundamentals/`.  
3. Read **[Labs/Getting-Started.md](../Getting-Started.md)** for general rules.  
4. UI help: **[Fabric and Power BI navigation reference](../_shared/Fabric-and-Power-BI-Navigation.md)**.

## Lab order

Labs are **standalone**. You may take them in any order; each uses its own `data/` folder and a **new blank .pbix**.

| Lab | Guide | Data folder |
|-----|-------|-------------|
| 01 | [Lab 01 - Connect Clean and Transform CRM Data.md](./Lab_01_Connect_Clean_Transform/Lab%2001%20-%20Connect%20Clean%20and%20Transform%20CRM%20Data.md) | `Lab_01_Connect_Clean_Transform/data/` |
| 02 | [Lab 02 - Build CRM Semantic Model and DAX Measures.md](./Lab_02_Semantic_Model_DAX/Lab%2002%20-%20Build%20CRM%20Semantic%20Model%20and%20DAX%20Measures.md) | `Lab_02_Semantic_Model_DAX/data/` |
| 03 | [Lab 03 - Build and Publish CRM Sales Dashboard.md](./Lab_03_CRM_Sales_Dashboard/Lab%2003%20-%20Build%20and%20Publish%20CRM%20Sales%20Dashboard.md) | `Lab_03_CRM_Sales_Dashboard/data/` |

## Every lab — same opening steps

1. Open Power BI Desktop → **Blank report**.  
2. **File → Save As** early with the name in the lab (example: `Lab01_CRM_Cleaned.pbix`).  
3. Import files **only** from that lab’s `data/` folder via **Home → Get data**.  
4. Prefer **Transform Data** first when the lab asks you to clean in Power Query.  
5. Finish with the lab **Validation checklist** before submit.

## Optional cloud steps (Lab 03 only)

Publishing needs sign-in and a workspace. If **Publish** is disabled, complete the `.pbix` locally and submit screenshots — skip Exercise I.

## Synthetic data baseline (Labs 02 & 03 clean sets)

120 sales, revenue **1,056,250** (INR fictional), 24 customers, 80 opportunities (32 won, 16 lost, 32 open). Lab 01 uses intentionally dirty sales data — different row counts after cleanup.
