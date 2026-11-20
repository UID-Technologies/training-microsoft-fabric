# Hands-on labs (learners)

All practical exercises for this course live under **`Labs/`**. Each module folder contains **lab guides** (Markdown) and **sample data** you upload or import locally.

## Start here

1. Read **[Getting-Started.md](./Getting-Started.md)** — accounts, Fabric capacity, Power BI Desktop, and how labs are organized.  
2. Open your module folder (table below).  
3. Follow **one lab `.md` file from top to bottom**; use the module **Learner_Worksheet** or **Getting-Started** where provided.  
4. UI labels change over time — use **[Fabric and Power BI navigation reference](./_shared/Fabric-and-Power-BI-Navigation.md)** when a button name does not match.

## Modules with published labs

| Module | Folder | What you need |
|--------|--------|----------------|
| 1 — Introduction to Data Analytics & BI | [01 - Introduction…](./01%20-%20Introduction%20to%20Data%20Analytics%20%26%20Business%20Intelligence/) | Fabric + Lakehouse + SQL endpoint |
| 2 — Power BI Fundamentals | [02 - Power BI Fundamentals](./02%20-%20Power%20BI%20Fundamentals/) | Power BI Desktop (Windows) |
| 3 — Microsoft Fabric Fundamentals | [03 - Microsoft Fabric Fundamentals](./03%20-%20Microsoft%20Fabric%20Fundamentals/) | Fabric portal + capacity |
| 4 — OneLake & Fabric Lakehouse | [04 - OneLake & Fabric Lakehouse](./04%20-%20OneLake%20%26%20Fabric%20Lakehouse/) | Fabric Lakehouse, Notebook, SQL endpoint |
| 5 — Fabric Data Factory & Pipelines | [05 - Fabric Data Factory & Pipelines](./05%20-%20Fabric%20Data%20Factory%20%26%20Pipelines/) | Data pipeline, Copy data, monitoring |
| 6 — Power Query & Dataflows Gen2 | [06 - Power Query & Dataflows Gen2](./06%20-%20Power%20Query%20%26%20Dataflows%20Gen2/) | Dataflow Gen2, Silver tables |
| 7 — Fabric Notebooks & PySpark | [07 - Fabric Notebooks & PySpark Fundamentals](./07%20-%20Fabric%20Notebooks%20%26%20PySpark%20Fundamentals/) | Notebook, PySpark, Gold tables |
| 8 — Fabric Data Warehouse | [08 - Fabric Data Warehouse](./08%20-%20Fabric%20Data%20Warehouse/) | Warehouse T-SQL, views |
| 9 — Data Modeling & Star Schema | [09 - Data Modeling & Star Schema](./09%20-%20Data%20Modeling%20%26%20Star%20Schema/) | Star schema Dim/Fact tables |
| 10 — Power BI Semantic Models | [10 - Power BI Semantic Models](./10%20-%20Power%20BI%20Semantic%20Models/) | Power BI Desktop semantic model |
| 11 — DAX Fundamentals | [11 - DAX Fundamentals](./11%20-%20DAX%20Fundamentals/) | DAX + time intelligence (Hands-on 11–12) |
| 12 — Power BI Reporting | [12 - Power BI Reporting](./12%20-%20Power%20BI%20Reporting/) | Dashboards (Hands-on 13–15) |

Modules 13–27 in the [course README](../README.md) are syllabus-only until lab folders are added (Hands-on **13–15** in Module **12**).

## Standard folder pattern

```text
Labs/NN - Module title/
├── README.md                 ← Module home (lab list)
├── Getting-Started.md        ← Learner prerequisites (where present)
├── Learner_Worksheet.md      ← Optional answers (Module 1)
├── Lab_0N_ShortName/
│   ├── Lab 0N - Title.md     ← Complete instructions (read this)
│   └── data/                 ← Files for this lab only
└── Sample_Data/              ← Shared copies (Module 3); prefer lab data/ when listed in the guide
```

## Rules for every lab

- Use **only** the `data/` folder named in that lab unless the guide says otherwise.  
- Each Fabric lab uses its **own workspace** name with your initials.  
- **Modules 2 and 10:** new blank **`.pbix`** in Power BI Desktop unless the guide says otherwise.  
- **Modules 11–12:** Fabric workspace + **semantic model** + **report** in the browser (see each module Getting-Started).  
- Compare your results to **Expected** / **Validation** sections before you submit.  
- Complete **Cleanup** at the end of Fabric labs when instructed.

## Course outline

Full module topics: [../README.md](../README.md).
