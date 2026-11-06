# Lab 01 — Explore Microsoft Fabric Workspaces, Workloads and Capacity

> **Learner path:** [Module 3 Getting-Started.md](../Getting-Started.md) · [Navigation reference](../../_shared/Fabric-and-Power-BI-Navigation.md)

**Module:** 3 — Microsoft Fabric Fundamentals  
**Duration:** 45–60 minutes  
**Standalone:** Yes — no file upload  
**Deliverable:** Workspace `CRM-M3-L01-<initials>`, architecture worksheet, screenshots (if requested).

## Progress checklist

- [ ] Signed in at app.fabric.microsoft.com (correct tenant)  
- [ ] Workspace created; capacity/license recorded  
- [ ] Six+ Fabric item types identified in **+ New item**  
- [ ] CRM architecture table completed  
- [ ] End-to-end flow drawn in notes  

## Business scenario
A CRM analytics team wants a governed environment to store data, orchestrate ingestion, engineer datasets, serve SQL analytics and publish Power BI reports. Before implementing anything, identify where each Fabric capability belongs and verify the environment is ready.

## Learning objectives
1. Identify the unified Fabric experience and OneLake's role.
2. Distinguish Data Factory, Data Engineering, Data Warehouse and Power BI workloads.
3. Create a workspace, inspect its settings, roles and capacity assignment.
4. Locate item creation options and map CRM requirements to Fabric items.

## Environment and navigation notes
- Use a Microsoft Fabric-enabled tenant with a workspace assigned to supported Fabric capacity or an active Fabric trial. A free Power BI license alone does not guarantee Lakehouse, Notebook, Pipeline or Warehouse creation.
- Sign in at https://app.fabric.microsoft.com. Depending on your tenant, use **Workspaces** in the left navigation, **New workspace**, and **+ New item** inside a workspace. The exact placement and wording may vary as Fabric UI evolves.
- Choose an individual lab workspace name, such as `CRM-M3-L01-<initials>`; do not reuse a workspace from another lab. If workspace creation is disabled, ask the instructor for a dedicated workspace with Contributor or higher permissions.
- Do not select production capacity or upload real customer information. The included CSV files are synthetic.
- If a command or item is unavailable, capture a screenshot and document the permission/capacity limitation instead of pretending it succeeded.

## Part A — Sign in and inspect the Fabric experience (10 min)
1. Open `https://app.fabric.microsoft.com` and sign in with the training account.
2. Confirm you are in the intended organization/tenant from the profile menu. Do not switch tenants without instructor guidance.
3. Locate **Workspaces**, the Fabric home/navigation area and **New item** creation experience. Some tenants expose workload-specific hubs or filters rather than a single persistent workload switcher.
4. Browse available creation options without creating them yet. Look for **Lakehouse**, **Notebook**, **Data pipeline**, **Warehouse**, **Semantic model** and **Report**.
5. Record each item you can see. If some are hidden, note that access and capacity may affect availability.

**Checkpoint:** Explain in one sentence why Fabric is more than Power BI: it brings ingestion, engineering, warehousing and BI together on a shared SaaS analytics platform.

## Part B — Create a dedicated workspace (15 min)
1. In the left navigation, select **Workspaces**.
2. Select **New workspace** (or **Home** → **New workspace** card).
3. **Name:** `CRM-M3-L01-<initials>`. **Description:** `Module 3 Lab 01 — Fabric exploration`.
4. Select **Apply** (or **Create**). If creation is blocked, use an instructor-provisioned workspace and record its exact name.
5. Open **Workspace settings** (gear on toolbar or **…** on workspace name).
6. Select **Workspace type** (may appear as **License info** / **License mode**). Record: Fabric F capacity, trial, or unsupported mode. **Do not change capacity** without permission.
7. Open **Manage access** (or **People**). List roles you see: **Admin**, **Member**, **Contributor**, **Viewer**. Do not invite real users during the exercise.
8. Optional for submission: screenshot of workspace home and of **Workspace type** (redact tenant IDs).

**Checkpoint:** You can open the workspace and state whether Fabric items (Lakehouse, etc.) are allowed on this capacity.

**Expected:** You can access a dedicated workspace and identify its licensing/capacity context. An unsupported capacity is a documented blocker for subsequent Fabric items, not a successful lab outcome.

## Part C — Explore Fabric item types (10 min)
1. In your workspace select **+ New item**.
2. Search or browse **Lakehouse**. Note that it stores files and Delta tables in OneLake.
3. Search **Data pipeline**. Note that it orchestrates movement and activities.
4. Search **Notebook**. Note that it runs Spark/Python/SQL workloads.
5. Search **Warehouse**. Note its SQL-first relational analytics experience.
6. Search **Report** and **Semantic model**. Note that Power BI is the consumption/semantic layer.
7. Cancel item creation; this lab is intentionally an environment exploration.

## Part D — CRM architecture worksheet (10 min)
Complete this mapping (compare with answer key below):

| CRM requirement | Fabric capability / item | Reason |
|---|---|---|
| Land raw CSV exports | __________ | __________ |
| Schedule ingestion | __________ | __________ |
| Clean and join large datasets in Python | __________ | __________ |
| Serve SQL analytics | __________ | __________ |
| Define business measures | __________ | __________ |
| Share interactive visual analytics | __________ | __________ |

**Answer key:** Lakehouse Files; Data Factory Data pipeline; Data Engineering Notebook; Warehouse (or Lakehouse SQL analytics endpoint for supported read-only analytics); Power BI semantic model; Power BI report.

## Part E — Draw the end-to-end architecture (5 min)
Create this flow in your notes: `CRM exports → Data Factory pipeline → OneLake/Lakehouse Files → Notebook/Delta tables → Warehouse or SQL analytics endpoint → Semantic model → Power BI report`. Mark Warehouse as optional for a small lakehouse-based design. OneLake is the underlying unified logical data lake, not a separate file upload service that must be created.

## Validation checklist
- [ ] Fabric portal opened and tenant confirmed.
- [ ] Workspace created or instructor-provisioned workspace documented.
- [ ] Capacity/license state identified accurately.
- [ ] Workspace roles located.
- [ ] At least five Fabric item types identified.
- [ ] CRM architecture worksheet completed.

## Troubleshooting
- **No New workspace button:** tenant policy or insufficient permission; request an instructor-provisioned workspace.
- **No Lakehouse/Notebook/Warehouse:** verify Fabric capacity/trial, permissions and tenant settings.
- **Power BI only UI:** navigate to Fabric home/item creation and check whether Fabric is enabled for the tenant.

## Completion evidence
Submit workspace name, capacity type, architecture worksheet and two screenshots. **Do not delete the workspace** until the instructor checks the result.
