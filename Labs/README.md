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

Modules 4–27 in the [course README](../README.md) are syllabus-only until lab folders are added.

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
- Each Power BI lab starts from a **new blank .pbix** unless the guide says otherwise.  
- Compare your results to **Expected** / **Validation** sections before you submit.  
- Complete **Cleanup** at the end of Fabric labs when instructed.

## Course outline

Full module topics: [../README.md](../README.md).
