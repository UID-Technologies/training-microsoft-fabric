# Microsoft Fabric Training

End-to-end curriculum for building a **CRM Sales & Revenue Analytics Platform** on Microsoft Fabric and Power BI—from data analytics fundamentals through ingestion, modeling, reporting, security, AI, governance, and operations.

**Learners:** all hands-on guides and sample data are under **[Labs/](./Labs/README.md)** (start with [Getting-Started.md](./Labs/Getting-Started.md)).

**Instructors:** slide PDFs for Modules **1–7** are in **[Presentation/](./Presentation/)** — see [Presentations by module](#presentations-by-module).

### Published labs (Modules 1–12)

| Module | Lab folder | Labs |
|--------|------------|------|
| 1 — Intro to DA & BI | [Labs/01…](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/) | 3 |
| 2 — Power BI Fundamentals | [Labs/02…](./Labs/02%20-%20Power%20BI%20Fundamentals/) | 3 |
| 3 — Fabric Fundamentals | [Labs/03…](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/) | 3 |
| 4 — OneLake & Lakehouse | [Labs/04…](./Labs/04%20-%20OneLake%20%26%20Fabric%20Lakehouse/) | 2 |
| 5 — Data Factory & Pipelines | [Labs/05…](./Labs/05%20-%20Fabric%20Data%20Factory%20%26%20Pipelines/) | 1 |
| 6 — Dataflows Gen2 | [Labs/06…](./Labs/06%20-%20Power%20Query%20%26%20Dataflows%20Gen2/) | 1 |
| 7 — Notebooks & PySpark | [Labs/07…](./Labs/07%20-%20Fabric%20Notebooks%20%26%20PySpark%20Fundamentals/) | 1 |
| 8 — Fabric Warehouse | [Labs/08…](./Labs/08%20-%20Fabric%20Data%20Warehouse/) | 1 |
| 9 — Star schema | [Labs/09…](./Labs/09%20-%20Data%20Modeling%20%26%20Star%20Schema/) | 1 |
| 10 — Semantic models | [Labs/10…](./Labs/10%20-%20Power%20BI%20Semantic%20Models/) | 1 |
| 11 — DAX & KPIs | [Labs/11…](./Labs/11%20-%20DAX%20Fundamentals/) | 1 (Hands-on **11–12**) |
| 12 — Power BI Reporting | [Labs/12…](./Labs/12%20-%20Power%20BI%20Reporting/) | 1 (Hands-on **13–15**) |

Modules **13–27:** topics below; additional lab folders not yet published. **Hands-on 13–15** are in **Module 12** lab.

---

## Module 1 — Introduction to Data Analytics & Business Intelligence

**Topics**

- Data analytics and BI fundamentals
- Operational vs analytical systems
- Structured and semi-structured data
- Enterprise data sources
- ETL vs ELT
- Data warehouse, data lake and Lakehouse fundamentals
- Modern analytics platform overview
- CRM analytics use-case walkthrough

**Presentation** — [01 - Introduction to Data Analytics and Business Intelligence (PDF)](./Presentation/01%20-%20Introduction-to-Data-Analytics-and-Business-Intelligence.pdf)

**Hands-on labs** — [Labs/01 - Introduction…](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/) · [All labs index](./Labs/README.md)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Discover CRM business data](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab_01_Discover_CRM/Lab%2001%20-%20Discover%20CRM%20business%20data.md) | Dimensions, measures, grain, relationships, source types |
| [Lab 02 — Investigate CRM data quality](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab_02_Investigate_Data_Quality/Lab%2002%20-%20Investigate%20CRM%20data%20quality.md) | Profiling, issue register, join impact |
| [Lab 03 — Calculate CRM KPIs](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab_03_Calculate_CRM_KPIs/Lab%2003%20-%20Calculate%20CRM%20KPIs%20and%20recommend%20an%20action.md) | KPI scorecard, targets, interpretation |

---

## Module 2 — Power BI Fundamentals

**Topics**

- Power BI ecosystem: Desktop and Service
- Reports, dashboards and semantic models
- Connecting to Excel/CSV and common data sources
- Power Query introduction
- Fields, data types and relationships
- Core visuals, filters and slicers
- Basic report-development workflow
- Publishing concepts

**Presentation** — [02 - Power BI Fundamentals (PDF)](./Presentation/02%20-%20Power-BI-Fundamentals-From-Raw-Data-to-Business-Insights.pdf)

**Hands-on labs** — [Labs/02 - Power BI Fundamentals](./Labs/02%20-%20Power%20BI%20Fundamentals/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Connect, clean, transform](./Labs/02%20-%20Power%20BI%20Fundamentals/Lab_01_Connect_Clean_Transform/Lab%2001%20-%20Connect%20Clean%20and%20Transform%20CRM%20Data.md) | Power Query, CSV/Excel |
| [Lab 02 — Semantic model & DAX](./Labs/02%20-%20Power%20BI%20Fundamentals/Lab_02_Semantic_Model_DAX/Lab%2002%20-%20Build%20CRM%20Semantic%20Model%20and%20DAX%20Measures.md) | Relationships, measures |
| [Lab 03 — CRM sales dashboard](./Labs/02%20-%20Power%20BI%20Fundamentals/Lab_03_CRM_Sales_Dashboard/Lab%2003%20-%20Build%20and%20Publish%20CRM%20Sales%20Dashboard.md) | Report, slicers, optional publish |

---

## Module 3 — Microsoft Fabric Fundamentals

**Topics**

- Microsoft Fabric overview and unified analytics approach
- Fabric workloads
- OneLake
- Data Factory
- Data Engineering
- Data Warehouse
- Power BI in Fabric
- Workspaces, items and capacity concepts
- End-to-end Fabric architecture

**Presentation** — [03 - Microsoft Fabric: The Unified Analytics Platform (PDF)](./Presentation/03%20-%20Microsoft-Fabric-The-Unified-Analytics-Platform.pdf)

**Hands-on labs** — [Labs/03 - Microsoft Fabric Fundamentals](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Workspaces & capacity](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/Lab_01_Fabric_Workspace/Lab%2001%20-%20Explore%20Microsoft%20Fabric%20Workspaces%20Workloads%20and%20Capacity.md) | Fabric architecture |
| [Lab 02 — Lakehouse & OneLake](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/Lab_02_CRM_Lakehouse/Lab%2002%20-%20Create%20a%20CRM%20Lakehouse%20and%20Explore%20OneLake.md) | Files, Delta tables, SQL |
| [Lab 03 — End-to-end CRM](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/Lab_03_End_to_End_CRM/Lab%2003%20-%20Build%20an%20End-to-End%20CRM%20Analytics%20Solution.md) | Pipeline, notebook, Power BI |

---

## Module 4 — OneLake & Fabric Lakehouse

**Topics**

- OneLake architecture
- Lakehouse fundamentals
- Lakehouse vs Warehouse
- Tables and Files
- Delta Lake and Delta tables
- Lakehouse SQL endpoint
- Schema concepts
- Medallion architecture: Bronze, Silver and Gold
- Designing the CRM Lakehouse

**Presentation** — [04 - OneLake and Fabric Lakehouse (PDF)](./Presentation/04%20-%20OneLake-and-Fabric-Lakehouse.pdf)

**Hands-on labs** — [Labs/04 - OneLake & Fabric Lakehouse](./Labs/04%20-%20OneLake%20%26%20Fabric%20Lakehouse/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — OneLake, Lakehouse fundamentals & SQL endpoint](./Labs/04%20-%20OneLake%20%26%20Fabric%20Lakehouse/Lab_01_OneLake_Lakehouse_Fundamentals/Lab%2001%20-%20OneLake%20Lakehouse%20fundamentals%20and%20the%20SQL%20endpoint.md) | OneLake, Files, Delta, Lakehouse vs Warehouse |
| [Lab 02 — Medallion CRM Lakehouse](./Labs/04%20-%20OneLake%20%26%20Fabric%20Lakehouse/Lab_02_Medallion_CRM_Lakehouse/Lab%2002%20-%20Design%20a%20medallion%20CRM%20Lakehouse.md) | Bronze/Silver/Gold for all six CRM entities (Hands-on 4) |

---

## Module 5 — Fabric Data Factory & Pipelines

**Topics**

- Fabric Data Factory overview
- Data pipelines and activities
- Copy Data activity
- Connections and destinations
- Parameters and variables
- Pipeline expressions
- Scheduling concepts
- Monitoring runs
- Error handling and retries
- Incremental loading introduction

**Presentation** — [05 - Fabric Data Factory and Pipelines (PDF)](./Presentation/05%20-%20Fabric-Data-Factory-and-Pipelines.pdf)

**Hands-on lab** — [Labs/05 - Fabric Data Factory & Pipelines](./Labs/05%20-%20Fabric%20Data%20Factory%20%26%20Pipelines/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Parameterized pipeline Bronze ingest and monitoring (Hands-on 5)](./Labs/05%20-%20Fabric%20Data%20Factory%20%26%20Pipelines/Lab_01_Bronze_Pipeline_Ingest/Lab%2001%20-%20Parameterized%20pipeline%20Bronze%20ingest%20and%20monitoring.md) | Copy data, parameters, expressions, monitoring, retries, incremental & scheduling concepts |

---

## Module 6 — Power Query & Dataflows Gen2

**Topics**

- Power Query and Dataflows Gen2
- Data types and column transformations
- Duplicate and null handling
- Filtering and conditional columns
- Merge and append
- Group By
- Parameters
- Dataflow destinations
- Dataflow vs Pipeline vs Notebook

**Presentation** — [06 - Power Query and Dataflows Gen2 (PDF)](./Presentation/06%20-%20Power-Query-and-Dataflows-Gen2.pdf)

**Hands-on lab** — [Labs/06 - Power Query & Dataflows Gen2](./Labs/06%20-%20Power%20Query%20%26%20Dataflows%20Gen2/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Dataflow Gen2 CRM Silver cleansing (Hands-on 6)](./Labs/06%20-%20Power%20Query%20%26%20Dataflows%20Gen2/Lab_01_Dataflow_CRM_Silver/Lab%2001%20-%20Dataflow%20Gen2%20CRM%20Silver%20cleansing.md) | Power Query transforms, parameters, Lakehouse Silver destination, vs pipeline/notebook |

---

## Module 7 — Fabric Notebooks & PySpark Fundamentals

**Topics**

- Spark and Fabric notebooks introduction
- Spark DataFrames
- Reading Lakehouse data
- Select/filter/transform operations
- Joins and aggregations
- Writing Delta tables
- Spark SQL introduction
- When to use Notebook vs Dataflow vs SQL

**Presentation** — [07 - Fabric Notebooks and PySpark Fundamentals (PDF)](./Presentation/07%20-%20Fabric-Notebooks-and-PySpark-Fundamentals.pdf)

**Hands-on lab** — [Labs/07 - Fabric Notebooks & PySpark Fundamentals](./Labs/07%20-%20Fabric%20Notebooks%20%26%20PySpark%20Fundamentals/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — PySpark Gold CRM tables (Hands-on 7)](./Labs/07%20-%20Fabric%20Notebooks%20%26%20PySpark%20Fundamentals/Lab_01_Notebook_Gold_CRM/Lab%2001%20-%20PySpark%20Gold%20CRM%20tables.md) | DataFrames, transforms, joins, Delta Gold, Spark SQL, vs Dataflow/SQL |

---

## Module 8 — Fabric Data Warehouse

**Topics**

- Fabric Warehouse architecture
- Warehouse vs Lakehouse
- Tables and views
- T-SQL fundamentals in Fabric
- Filtering, joins, GROUP BY and aggregations
- Creating analytical views
- Loading warehouse data
- Warehouse security introduction
- Power BI integration

**Hands-on lab** — [Labs/08 - Fabric Data Warehouse](./Labs/08%20-%20Fabric%20Data%20Warehouse/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — CRM analytics in the Fabric Warehouse (Hands-on 8)](./Labs/08%20-%20Fabric%20Data%20Warehouse/Lab_01_Warehouse_CRM_Analytics/Lab%2001%20-%20CRM%20analytics%20in%20the%20Fabric%20Warehouse.md) | Load warehouse tables, T-SQL, views, security intro, optional Power BI |

---

## Module 9 — Data Modeling & Star Schema

**Topics**

- Analytical data-modeling fundamentals
- Fact and dimension tables
- Star vs snowflake schema
- Keys and relationships
- Cardinality and filter direction
- Date dimension
- Modeling for Power BI
- Performance-oriented modeling practices

**Hands-on lab** — [Labs/09 - Data Modeling & Star Schema](./Labs/09%20-%20Data%20Modeling%20%26%20Star%20Schema/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Build CRM star schema tables (Hands-on 9)](./Labs/09%20-%20Data%20Modeling%20%26%20Star%20Schema/Lab_01_CRM_Star_Schema/Lab%2001%20-%20Build%20CRM%20star%20schema%20tables.md) | Dimensions, facts, DimDate, star vs snowflake, Power BI modeling notes |

---

## Module 10 — Power BI Semantic Models

**Topics**

- Semantic model fundamentals
- Relationships and cardinality
- Measures vs calculated columns
- Hierarchies and date tables
- Business-friendly model design
- Direct Lake introduction
- Import vs DirectQuery vs Direct Lake

**Hands-on lab** — [Labs/10 - Power BI Semantic Models](./Labs/10%20-%20Power%20BI%20Semantic%20Models/)

| Lab | Focus |
|-----|--------|
| [Lab 01 — Build the reusable CRM semantic model (Hands-on 10)](./Labs/10%20-%20Power%20BI%20Semantic%20Models/Lab_01_CRM_Semantic_Model/Lab%2001%20-%20Build%20the%20reusable%20CRM%20semantic%20model.md) | Star schema, relationships, measures, hierarchies, date table, Import/DQ/Direct Lake |

---

## Module 11 — DAX Fundamentals

**Topics**

- DAX syntax
- Measures vs calculated columns
- SUM, COUNT, COUNTROWS, DISTINCTCOUNT, AVERAGE
- DIVIDE, IF, SWITCH, RELATED
- CALCULATE and FILTER
- Row context and filter context
- Context transition introduction
- Intermediate DAX and time intelligence (Hands-on 12): CALCULATE scenarios, MTD/QTD/YTD, previous period, YoY, ranking, variables, percent of total, actual vs target

**Hands-on lab** — [Labs/11 - DAX Fundamentals](./Labs/11%20-%20DAX%20Fundamentals/) (**Hands-on 11 and 12** in one lab)

| Lab | Focus |
|-----|--------|
| [Lab 01 — CRM DAX fundamentals and business KPIs](./Labs/11%20-%20DAX%20Fundamentals/Lab_01_CRM_DAX_KPIs/Lab%2001%20-%20CRM%20DAX%20fundamentals%20and%20business%20KPIs.md) | Core DAX, CALCULATE, time intelligence, rank & contribution |

---

## Module 12 — Power BI Reporting

**Topics (Modules 13–15 combined)**

- Visualization design principles; selecting the right visual; KPI cards, charts, matrix, slicers  
- Conditional formatting; drill-down and drill-through; report tooltips  
- Bookmarks, buttons, navigation; visual interactions; report-page design; mobile layout  
- Sales funnel, pipeline by stage, win/loss, lead conversion, salesperson/region/product views  
- Customer 360, segmentation, revenue history, drill-through to detail  

**Hands-on lab** — [Labs/12 - Power BI Reporting](./Labs/12%20-%20Power%20BI%20Reporting/) (**Hands-on 13–15**)

| Lab | Focus |
|-----|--------|
| [Lab 01 — CRM reporting dashboards](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) | Executive dashboard, pipeline dashboard, Customer 360 |

---

## Module 13 — Power BI Visualization & Report Design

*Hands-on:* [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (*Executive* page).

**Topics**

- Visualization design principles
- Selecting the right visual
- KPI cards, charts, matrix and slicers
- Conditional formatting
- Drill-down and drill-through
- Report tooltips
- Bookmarks, buttons and navigation
- Visual interactions
- Report-page design
- Mobile layout introduction

**Hands-on 13** — Executive Sales Dashboard — in [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (Page *Executive*).

---

## Module 14 — CRM Sales Pipeline Analytics

*Hands-on:* [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (*Pipeline* page).

**Topics**

- Sales-funnel concepts
- Lead-to-opportunity conversion
- Pipeline by stage
- Win/loss analysis
- Opportunity aging
- Sales-cycle analysis
- Salesperson, region and product performance
- Actual vs target

**Hands-on 14** — Sales Pipeline Dashboard — in [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (Page *Pipeline*).

---

## Module 15 — Customer Analytics

*Hands-on:* [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (*Customer 360* page).

**Topics**

- Customer 360 concepts
- Segmentation
- Customer revenue and purchase history
- High-value customers
- Customer contribution
- Activity and opportunity history
- Customer trends
- Drill-through design

**Hands-on 15** — Customer 360 page — in [Module 12 Lab 01](./Labs/12%20-%20Power%20BI%20Reporting/Lab_01_CRM_Reporting_Dashboards/Lab%2001%20-%20CRM%20reporting%20dashboards.md) (Page *Customer 360*).

---

## Module 16 — Power BI Service & Collaboration

**Topics**

- Power BI Service
- Workspaces and roles
- Reports, semantic models and dashboards
- Apps and sharing
- Refresh concepts
- Gateway overview
- Usage metrics
- Lineage view
- Endorsement concepts

**Hands-on 16** — Publish the CRM Analytics solution and organize the workspace.

---

## Module 17 — Power BI & Fabric Security

**Topics**

- Security fundamentals
- Fabric workspace roles
- Power BI permissions
- Semantic model security
- Static RLS
- Dynamic RLS introduction
- USERPRINCIPALNAME()
- Security groups
- Sharing vs security
- Least privilege
- Fabric item permissions

**Hands-on 17** — Implement regional RLS for North Manager, South Manager and Executive roles.

---

## Module 18 — Deployment & Enterprise Architecture

**Topics**

- Development lifecycle
- Development, Test/UAT and Production workspaces
- Deployment pipeline concepts
- Release and workspace strategy
- Environment separation
- Refresh, security and monitoring strategies
- Documentation
- End-to-end Fabric architecture

**Architecture review** — Map the completed CRM solution to a practical Dev → UAT → Production operating model.

---

## Module 19 — Power BI & Fabric Performance

**Topics**

- Power BI performance fundamentals
- Model size and cardinality
- Star schema and performance
- Efficient DAX
- Performance Analyzer
- Refresh-performance considerations
- Direct Lake and model-mode considerations
- Identifying common report and model bottlenecks

**Hands-on 18** — Diagnose and improve an intentionally inefficient Power BI report.

---

## Module 20 — Fabric Monitoring & Operational Readiness

**Topics**

- Fabric Monitoring Hub
- Pipeline/Dataflow/Notebook monitoring
- Refresh monitoring
- Operational failure patterns
- Monitoring and troubleshooting workflow
- Usage and activity review
- Preparing the solution for production operations

**Hands-on 19** — Review CRM solution runs, identify failed/slow activities and define an operational monitoring checklist.

---

## Module 21 — Capstone Integration Checkpoint

**Topics**

- Validate ingestion and medallion flow
- Validate analytical model and KPIs
- Validate report navigation and business questions
- Validate RLS and publishing approach
- Identify remaining gaps before advanced AI/governance sessions

**Capstone checkpoint** — Integrate and validate the end-to-end CRM solution before adding AI, governance and optimization capabilities.

---

## Module 22 — Integrating Artificial Intelligence with Microsoft Fabric

**Topics**

- AI-enabled analytics in the Fabric ecosystem
- Where Copilot fits across Fabric and Power BI workflows
- Common Copilot use cases for analysts, data engineers and BI developers
- Using natural-language assistance for exploration, authoring and productivity
- AI-assisted report and analytical workflow concepts
- Responsible use: validation, data access, governance and human review
- Selecting suitable CRM use cases for AI assistance

**Demo / Hands-on 20** — Use AI-assisted capabilities against the CRM analytics scenario to explore data, accelerate analytical tasks and validate generated outputs.

---

## Module 23 — Fabric Data Agents

**Topics**

- Data Agent concept and business purpose
- Connecting a Data Agent to governed analytical data
- Natural-language interaction with enterprise data
- Grounding responses in organizational data and semantic context
- Designing business questions and instructions for the agent
- Access, security and governance considerations
- Data Agent use cases: sales management, customer insights, pipeline and revenue questions
- Testing answer quality and business relevance

**Hands-on 21** — Configure a CRM-focused Data Agent scenario and test questions such as pipeline status, regional performance, customer revenue and opportunity risk.

---

## Module 24 — Data Activator & Event-Driven Analytics

**Topics**

- Data Activator overview and event-driven analytics concepts
- From passive dashboards to proactive business actions
- Events, conditions, rules and actions
- Identifying business signals that require action
- CRM examples: opportunity aging, revenue threshold, target shortfall and high-value deal changes
- Notifications and downstream action patterns
- Design considerations for alert noise, thresholds and ownership
- Combining analytics, AI insight and proactive action

**Hands-on 22** — Define an event-driven CRM scenario that detects an at-risk/high-value opportunity condition and triggers a business action or notification.

---

## Module 25 — Microsoft Purview for Data Governance

**Topics**

- Why enterprise data governance matters
- Microsoft Purview overview in the Fabric governance context
- Data discovery and catalog concepts
- Data lineage and impact analysis
- Sensitivity labels and information protection concepts
- Trusted data and endorsement concepts
- Ownership, stewardship and governance responsibilities
- Governance considerations across Lakehouse, Warehouse, semantic models and reports
- Using governance to support trusted self-service analytics
- Practical CRM governance operating model

**Hands-on 23** — Trace the CRM analytics data flow from source through Fabric to Power BI, identify governed assets, ownership, lineage and sensitivity requirements.

---

## Module 26 — Microsoft Fabric Capacity Optimization

**Topics**

- Fabric capacity concepts and workload consumption
- Understanding capacity usage and workload behavior
- Monitoring capacity and identifying utilization patterns
- Interactive vs background workload considerations
- Recognizing peaks, contention and throttling symptoms
- Capacity Metrics app / monitoring concepts
- Optimizing data ingestion and transformation workloads
- Optimizing semantic models, DAX and refresh patterns
- Scheduling and workload distribution practices
- Right-sizing and scaling considerations
- Cost-performance trade-offs
- Operational capacity review checklist and optimization best practices
- Row-Level Security (RLS) and other security concepts in Lakehouse & Warehouse

**Hands-on 24** — Review a sample CRM Fabric workload profile, identify capacity pressure points and propose practical optimization actions.

---

## Module 27 — End-to-End Capstone Finalization & Presentation

**Topics**

- Business requirement validation
- Data ingestion
- Bronze/Silver/Gold implementation
- Data quality and transformation
- Warehouse/star-schema design
- Semantic model and DAX
- Power BI report development
- RLS
- AI-assisted analytics / Data Agent use case
- Event-driven action use case
- Governance and lineage approach
- Capacity and performance optimization approach
- Publishing, monitoring and deployment concepts
- Team demonstration

**Capstone** — Build and present the complete CRM Sales & Revenue Analytics Platform, including AI-enabled analytics, governance and capacity optimization considerations.

---

## Presentations by module

Instructor slide decks (PDF). Pair each deck with the matching module labs when delivered in class.

| Module | Presentation |
|--------|----------------|
| 1 — Introduction to Data Analytics & BI | [01 - Introduction to Data Analytics and Business Intelligence](./Presentation/01%20-%20Introduction-to-Data-Analytics-and-Business-Intelligence.pdf) |
| 2 — Power BI Fundamentals | [02 - Power BI Fundamentals](./Presentation/02%20-%20Power-BI-Fundamentals-From-Raw-Data-to-Business-Insights.pdf) |
| 3 — Microsoft Fabric Fundamentals | [03 - Microsoft Fabric: The Unified Analytics Platform](./Presentation/03%20-%20Microsoft-Fabric-The-Unified-Analytics-Platform.pdf) |
| 4 — OneLake & Fabric Lakehouse | [04 - OneLake and Fabric Lakehouse](./Presentation/04%20-%20OneLake-and-Fabric-Lakehouse.pdf) |
| 5 — Fabric Data Factory & Pipelines | [05 - Fabric Data Factory and Pipelines](./Presentation/05%20-%20Fabric-Data-Factory-and-Pipelines.pdf) |
| 6 — Power Query & Dataflows Gen2 | [06 - Power Query and Dataflows Gen2](./Presentation/06%20-%20Power-Query-and-Dataflows-Gen2.pdf) |
| 7 — Fabric Notebooks & PySpark Fundamentals | [07 - Fabric Notebooks and PySpark Fundamentals](./Presentation/07%20-%20Fabric-Notebooks-and-PySpark-Fundamentals.pdf) |

**Lab status:** Modules **1–12** have folders under [Labs/](./Labs/README.md). **Presentations** available for Modules **1–7** only.

---

## Repository structure

| Location | Status |
|----------|--------|
| [Labs/](./Labs/README.md) | **Primary** — all learner lab guides and data |
| [Labs/01 - Introduction…](./Labs/01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/) | 3 Fabric/SQL labs |
| [Labs/02 - Power BI Fundamentals](./Labs/02%20-%20Power%20BI%20Fundamentals/) | 3 Power BI Desktop labs |
| [Labs/03 - Microsoft Fabric Fundamentals](./Labs/03%20-%20Microsoft%20Fabric%20Fundamentals/) | 3 Fabric portal labs |
| [Labs/04 - OneLake & Fabric Lakehouse](./Labs/04%20-%20OneLake%20%26%20Fabric%20Lakehouse/) | 2 Lakehouse / medallion labs |
| [Labs/05 - Fabric Data Factory & Pipelines](./Labs/05%20-%20Fabric%20Data%20Factory%20%26%20Pipelines/) | 1 Data pipeline lab |
| [Labs/06 - Power Query & Dataflows Gen2](./Labs/06%20-%20Power%20Query%20%26%20Dataflows%20Gen2/) | 1 Dataflow Gen2 lab |
| [Labs/07 - Fabric Notebooks & PySpark Fundamentals](./Labs/07%20-%20Fabric%20Notebooks%20%26%20PySpark%20Fundamentals/) | 1 Notebook / PySpark lab |
| [Labs/08 - Fabric Data Warehouse](./Labs/08%20-%20Fabric%20Data%20Warehouse/) | 1 Fabric Warehouse lab |
| [Labs/09 - Data Modeling & Star Schema](./Labs/09%20-%20Data%20Modeling%20%26%20Star%20Schema/) | 1 star-schema warehouse lab |
| [Labs/10 - Power BI Semantic Models](./Labs/10%20-%20Power%20BI%20Semantic%20Models/) | 1 Power BI Desktop semantic model lab |
| [Labs/11 - DAX Fundamentals](./Labs/11%20-%20DAX%20Fundamentals/) | 1 DAX / time intelligence lab (Hands-on 11–12) |
| [Labs/12 - Power BI Reporting](./Labs/12%20-%20Power%20BI%20Reporting/) | 1 reporting lab (Hands-on 13–15) |
| [Presentation/](./Presentation/) | **PDF decks for Modules 1–7** ([index above](#presentations-by-module)) |

**Syllabus only (no lab folder yet):** Modules **16–27**. **Hands-on 13–15** → Module **12** lab. **Hands-on 11–12** → Module **11** lab.
