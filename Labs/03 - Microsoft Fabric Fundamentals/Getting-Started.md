# Getting started — Module 3 (Microsoft Fabric labs)

## Prerequisites

| Requirement | Details |
|-------------|---------|
| URL | https://app.fabric.microsoft.com |
| Account | Work or school account in the training tenant |
| Capacity | Workspace must use **Fabric capacity** or assigned trial (**Workspace settings → Workspace type**) |
| Browser | Current Edge or Chrome |
| Data | CSV files in each lab’s **`data/`** folder (copied from module `Sample_Data/`) |

Read **[Labs/Getting-Started.md](../Getting-Started.md)** and **[Navigation reference](../_shared/Fabric-and-Power-BI-Navigation.md)**.

## Labs (each uses a new workspace)

| Lab | Guide | Upload from |
|-----|-------|-------------|
| 01 | [Lab 01 - Explore…](./Lab_01_Fabric_Workspace/Lab%2001%20-%20Explore%20Microsoft%20Fabric%20Workspaces%20Workloads%20and%20Capacity.md) | No file upload |
| 02 | [Lab 02 - Create a CRM Lakehouse…](./Lab_02_CRM_Lakehouse/Lab%2002%20-%20Create%20a%20CRM%20Lakehouse%20and%20Explore%20OneLake.md) | `Lab_02_CRM_Lakehouse/data/` |
| 03 | [Lab 03 - End-to-End CRM…](./Lab_03_End_to_End_CRM/Lab%2003%20-%20Build%20an%20End-to-End%20CRM%20Analytics%20Solution.md) | `Lab_03_End_to_End_CRM/data/` |

## Naming convention

Replace `<initials>` in workspace names (examples: `CRM-M3-L02-ab`).

Do **not** reuse a workspace from another lab unless your instructor explicitly allows it.

## Expected validation numbers (Labs 02 & 03 data)

| Dataset | Rows |
|---------|-----:|
| customers | 20 |
| products | 8 |
| sales | 60 |
| opportunities | 30 |
| **Sum of sales Revenue** | **739000** |

## If UI actions are missing

- **Load to Tables** not on menu → use the **Notebook fallback** in Lab 02 or Lab 03 guide.  
- **Copy data** pipeline cannot see Files → use ingestion **Notebook fallback** and document the limitation.  
- **Report / semantic model** blocked → complete SQL and Notebook evidence; note license in submission.
