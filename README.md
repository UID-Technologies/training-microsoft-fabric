# Microsoft Fabric Training

End-to-end curriculum for building a **CRM Sales & Revenue Analytics Platform** on Microsoft Fabric and Power BI—from data analytics fundamentals through ingestion, modeling, reporting, security, AI, governance, and operations.

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

**Hands-on labs** ([Module 1 folder](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/))

| Lab | Focus |
|-----|--------|
| [Lab 01 — Discover CRM business data](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab%2001%20-%20Discover%20CRM%20business%20data.md) | Dimensions, measures, grain, relationships, source types |
| [Lab 02 — Investigate CRM data quality](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab%2002%20-%20Investigate%20CRM%20data%20quality.md) | Profiling, issue register, join impact |
| [Lab 03 — Calculate CRM KPIs and recommend an action](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/Lab%2003%20-%20Calculate%20CRM%20KPIs%20and%20recommend%20an%20action.md) | KPI scorecard, targets, interpretation |

Sample files for each lab live under `data/Lab 0N - …` inside the module folder.

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

**Hands-on 2** — Build the first CRM Sales Dashboard with Revenue, Customers, Opportunities, Region, Product and monthly trend analysis.

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

**Hands-on 3** — Create a Fabric workspace and CRM Lakehouse, upload sample data, and explore Tables, Files and OneLake.

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

**Hands-on 4** — Create the CRM Lakehouse structure and organize Customers, Leads, Opportunities, Products, Sales and Targets into a medallion-style design.

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

**Hands-on 5** — Build and execute a parameterized pipeline that ingests CRM datasets into the Bronze layer and review execution monitoring.

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

**Hands-on 6** — Clean duplicate customers, missing regions, invalid opportunity stages, dates and salesperson names; write validated Silver data.

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

**Hands-on 7** — Transform opportunities and sales, aggregate revenue by region, join customer/opportunity data and write curated Gold tables.

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

**Hands-on 8** — Query CRM data for revenue by region/product, salesperson performance, win/loss, customer revenue and monthly trends.

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

**Hands-on 9** — Build DimCustomer, DimProduct, DimSalesperson, DimRegion, DimDate, FactSales and FactOpportunity.

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

**Hands-on 10** — Build the reusable CRM semantic model and validate business relationships.

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

**Hands-on 11** — Create Total Revenue, Customer Count, Pipeline Value, Won/Lost Opportunities, Win Rate, Average Deal Size and Lead Conversion Rate.

---

## Module 12 — Intermediate DAX & Time Intelligence

**Topics**

- CALCULATE business scenarios
- Date functions
- MTD, QTD and YTD
- Previous-period analysis
- Year-over-year analysis
- Ranking and Top-N
- Variables
- Percentage of total
- Actual vs target

**Hands-on 12** — Build Revenue YTD, Previous Year Revenue, YoY Growth %, Target Achievement %, Salesperson Rank and Product Contribution %.

---

## Module 13 — Power BI Visualization & Report Design

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

**Hands-on 13** — Build the Executive Sales Dashboard with Revenue, Pipeline, Win Rate, Deal Size, Target Achievement, trends and regional/customer analysis.

---

## Module 14 — CRM Sales Pipeline Analytics

**Topics**

- Sales-funnel concepts
- Lead-to-opportunity conversion
- Pipeline by stage
- Win/loss analysis
- Opportunity aging
- Sales-cycle analysis
- Salesperson, region and product performance
- Actual vs target

**Hands-on 14** — Build the Sales Pipeline Dashboard and conversion funnel.

---

## Module 15 — Customer Analytics

**Topics**

- Customer 360 concepts
- Segmentation
- Customer revenue and purchase history
- High-value customers
- Customer contribution
- Activity and opportunity history
- Customer trends
- Drill-through design

**Hands-on 15** — Build a Customer 360 page with profile, revenue, orders, opportunities, activities and products.

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

## Repository structure

| Module folder | Status |
|---------------|--------|
| [01 - Introduction to Data Analytics & Business Intelligence](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/) | Available — 3 labs + `data/` sample folders |

Additional module folders will be added as content is published.
