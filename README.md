# 📊 Marketing Campaign ROI Analyzer

> **An end-to-end data analytics project** covering data profiling, SQL analysis, Python EDA, statistical testing, attribution modeling, machine learning and interactive dashboard — built on real customer data from a 2-year marketing campaign dataset.

---
## Live Dashboard

View the interactive dashboard here:  
[Marketing ROI Dashboard](https://fanu12343.github.io/marketing-roi/marketing-roi-analyzer/powerbi/marketing_roi_dashboard.html)



## 🎯 Business Problem

A company ran **5 marketing campaigns** across **3 purchase channels** over 2 years (2012–2014). The business needed answers to these critical questions:

- Which campaign drives the most customer conversions?
- Which channel (Web, Store, Catalog) generates the best return?
- Which customers are most valuable — and which are at risk of leaving?
- Can we predict how much a customer will spend in the future?
- What factors actually drive customer spending behaviour?

This project answers all of these questions using real data, statistical proof and machine learning.

---

## 📁 Project Structure

```
marketing-roi-analyzer/
│
├── data/
│   ├── raw/
│   │   └── marketing_campaign.csv        ← Original dataset (never modified)
│   └── processed/
│       ├── cleaned_data.csv              ← Cleaned dataset from Phase 3
│       └── customer_segments.csv         ← ML-generated segments from Phase 6
│
├── sql/
│   ├── 01_create_tables.sql              ← Data verification queries
│   ├── 02_channel_analysis.sql           ← Channel ROI + Campaign ranking
│   ├── 03_cohort_analysis.sql            ← Monthly cohort analysis
│   └── views/
│       ├── vw_channel_roi.sql            ← BigQuery view: channel metrics
│       └── vw_customer_segments.sql      ← BigQuery view: RFM segments
│
├── notebooks/
│   ├── 01_eda.ipynb                      ← Data cleaning & exploration
│   ├── 02_statistical_analysis.ipynb     ← Hypothesis testing
│   ├── 03_ab_testing.ipynb               ← A/B test: Campaign 3 vs 5
│   ├── 04_attribution_modeling.ipynb     ← First/Last/Linear attribution
│   └── 05_clv_prediction.ipynb           ← K-Means + XGBoost + SHAP
│
├── reports/
│   ├── 01_data_profiling_audit.xlsx      ← Phase 1 profiling sheet
│   └── 02_channel_pivot_dashboard.xlsx   ← Phase 2 Excel pivot dashboard
│
├── powerbi/
│   └── marketing_roi_dashboard      ← 3-page interactive dashboard
│
└── README.md
```

---

## 📦 Dataset

| Property | Detail |
|---|---|
| Source | [Kaggle — Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis) |
| Raw rows | 2,240 customers |
| Cleaned rows | 2,236 customers (4 outliers removed) |
| Columns | 29 original + 4 engineered features |
| Time period | July 2012 — June 2014 |
| Campaigns | 5 (AcceptedCmp1 through AcceptedCmp5) |
| Channels | Web, Store, Catalog |
| Products | Wines, Fruits, Meat, Fish, Sweets, Gold |

---

## 🗺️ Project Phases

### ✅ Phase 1 — Data Profiling & Acquisition
- Downloaded dataset from Kaggle
- Built a 29-column data profiling audit in Excel
- Identified key data quality issues before any coding:
  - **Income**: 24 null values (1.07%)
  - **Year_Birth**: Minimum of 1893 — impossible age (130+ years)
  - **Income**: Maximum of 666,666 — clear data entry error
  - **Marital_Status**: Contains `Absurd`, `YOLO`, `Alone` — invalid categories

---

### ✅ Phase 2 — SQL Analysis on Google BigQuery
Uploaded data to BigQuery and wrote 6 production-quality SQL queries:

| Query File | What It Does |
|---|---|
| `01_create_tables.sql` | Verifies row counts and null values — confirmed 24 Income nulls matching Excel audit |
| `02_channel_analysis.sql` | CTE-based ROI analysis — Store leads with 2,225 customers |
| `02_channel_analysis.sql` | RANK() window function — Campaign 4 ranks #1 at 7.46% acceptance |
| `03_cohort_analysis.sql` | DATE_TRUNC monthly cohort — August 2012 highest acquisition month |
| `vw_channel_roi.sql` | BigQuery view — reusable channel metrics table for Power BI |
| `vw_customer_segments.sql` | BigQuery view — RFM scoring with NTILE(4) and CASE WHEN segmentation |

**Key SQL finding:** September 2012 cohort had only 99 customers but the highest average spend (£800+) — fewer but higher quality customers than later months.

---

### ✅ Phase 3 — Python EDA & Data Cleaning
**Notebook:** `01_eda.ipynb` (Google Colab)

**Cleaning steps performed:**

| Problem | Fix Applied | Rows Affected |
|---|---|---|
| 24 null Income values | `fillna(median)` — median more robust than mean for skewed data | 0 removed |
| Year_Birth < 1940 (age 80+) | Removed impossible ages | ~3 removed |
| Income = 666,666 (outlier) | Removed above £200,000 | 1 removed |
| Absurd, YOLO, Alone in Marital_Status | Replaced with `Other` | 0 removed |

**Feature engineering — 4 new columns created:**

| New Column | Formula | Business Use |
|---|---|---|
| `Age` | `current_year - Year_Birth` | More intuitive than birth year |
| `Customer_Tenure` | Days since `Dt_Customer` | Loyalty measurement |
| `Total_Spend` | Sum of all 6 Mnt columns | Single spend metric |
| `Total_Campaigns_Accepted` | Sum of AcceptedCmp1–5 | Campaign engagement score |

**Key EDA findings:**
- Average customer age: **57 years** — middle-aged demographic
- Average total spend: **£605 per customer**
- Income vs Total Spend correlation: **0.79** — strong positive relationship
- PhD holders spend the most across all education groups

---

### ✅ Phase 4 — Statistical Analysis & A/B Testing
**Notebooks:** `02_statistical_analysis.ipynb`, `03_ab_testing.ipynb`

Three hypothesis tests performed:

| Test | Question | Result | p-value |
|---|---|---|---|
| **Independent T-test** | Do Campaign 1 acceptors spend more? | ✅ Reject H₀ — Yes, 2.7× more (£1,482 vs £545) | 0.0000 |
| **One-way ANOVA** | Does education level affect purchases? | ✅ Reject H₀ — Education significantly affects buying | 0.0000 |
| **Chi-square** | Does marital status affect campaign acceptance? | ❌ Fail to reject H₀ — No relationship proven | 0.923 |

**A/B Test — Campaign 3 vs Campaign 5:**
- Campaign 3 conversion rate: **7.28%**
- Campaign 5 conversion rate: **7.28%**  
- p-value: **0.954** — No statistically significant difference
- **Business decision:** Choose based on cost, not performance — they are statistically identical

---

### ✅ Phase 5 — Attribution Modeling
**Notebook:** `04_attribution_modeling.ipynb`

Built three attribution models to understand the customer journey:

| Model | Winner | Credit % | Business Meaning |
|---|---|---|---|
| **First Touch** | Campaign 1 | ~40% | Creates awareness — starts most customer journeys |
| **Last Touch** | Campaign 5 | ~50% | Closes conversions — the final push to buy |
| **Linear** | Shared | Equal split | All campaigns contribute throughout the journey |

**Key insight:** Campaign 1 and Campaign 5 serve different but equally important roles. Campaign 1 introduces customers to the brand. Campaign 5 converts them. Cutting either one would damage the full marketing funnel.

**Campaign 2 consistently performed worst across all three models** — budget reallocation recommended.

---

### ✅ Phase 6 — CLV Prediction & Customer Segmentation
**Notebook:** `05_clv_prediction.ipynb`

**Part A — K-Means Clustering:**
- Built RFM (Recency, Frequency, Monetary) features
- Applied StandardScaler to normalise features
- Used Elbow Method to find optimal K = **4 clusters**
- Resulting customer segments:

| Segment | Count | Business Action |
|---|---|---|
| 🏆 Champions | 520 (23.3%) | Protect — highest spenders (avg £1,269) |
| 💚 Loyal | 597 (26.7%) | Reward — consistent buyers |
| ⚠️ At-Risk | 646 (28.9%) | Re-engage — immediate retention opportunity |
| ❌ Lost | 473 (21.2%) | Win-back — were high value (avg £1,078) |

**Part B — XGBoost CLV Prediction:**

| Metric | Value | Interpretation |
|---|---|---|
| R² Score | **0.891** | Model explains 89.1% of spending variance |
| RMSE | **£202.76** | Predictions off by £203 on average |
| Train/Test split | 80/20 | 1,788 training / 448 testing |

**CLV Tier Distribution:**

| Tier | Customers | Avg Predicted CLV |
|---|---|---|
| 💎 High CLV | 171 (7.65%) | £1,761 |
| 🔵 Mid CLV | 638 (28.5%) | £1,158 |
| ⚪ Low CLV | 1,427 (63.8%) | £218 |

**Part C — SHAP Explainability:**

Top 3 features driving CLV predictions:
1. **NumCatalogPurchases** — Catalog buyers are typically older, higher-income premium customers
2. **Frequency** — More purchases directly drives higher lifetime value
3. **Income** — Confirms Phase 3 finding: Income vs Spend correlation of 0.79

> SHAP independently confirmed the correlation analysis finding from Phase 3 using a completely different method — strengthening confidence in the recommendation.

---

### ✅ Phase 7 — Power BI Dashboard
**File:** `powerbi/marketing_roi_dashboard.pbix`

Built a 3-page interactive dashboard connected to BigQuery views and processed CSV files:

| Page | Content |
|---|---|
| **Executive Overview** | 4 KPI cards, spend trend line chart, segment donut chart, revenue by segment bars, interactive slicer |
| **Channel Performance** | Channel metrics table, revenue bars, conversion comparison, campaign ranking, attribution model visualization |
| **Customer Segments** | CLV tier donut, scatter plot (Recency vs Spend), income by education, SHAP feature importance, model performance metrics |

---

## 🔑 Key Business Findings

| # | Finding | Evidence | Recommended Action |
|---|---|---|---|
| 1 | Campaign 4 has highest acceptance rate (7.46%) | SQL RANK() query | Prioritise Campaign 4 spend |
| 2 | Campaign 2 performs 5× worse than Campaign 4 (1.34%) | SQL + Attribution | Reallocate Campaign 2 budget |
| 3 | Campaign 1 starts 40% of customer journeys | Attribution Modeling | Maintain Campaign 1 for awareness |
| 4 | Campaign 5 closes 50% of conversions | Attribution Modeling | Increase Campaign 5 investment |
| 5 | Income predicts spend with 0.79 correlation | Correlation + SHAP | Target high-income customers |
| 6 | PhD holders earn £56K avg — 2.76× more than Basic | ANOVA + EDA | Target educated segments with premium campaigns |
| 7 | Catalog has lowest CAC (£18,194 vs £24,475 for Store) | SQL channel analysis | Invest more in Catalog channel |
| 8 | 171 High CLV customers worth 8× more than Low CLV | XGBoost prediction | Build VIP loyalty programme |
| 9 | 646 At-Risk customers represent £75K retention opportunity | K-Means clustering | Launch immediate re-engagement campaign |
| 10 | Campaign 3 and Campaign 5 perform identically (p=0.954) | A/B Testing | Choose by cost — performance is identical |

---

## 🛠️ Tools & Technologies

| Category | Tool | Purpose |
|---|---|---|
| **Cloud Database** | Google BigQuery | SQL analysis, views, cohort analysis |
| **Data Profiling** | Microsoft Excel Online | Data audit, pivot dashboard, budget analysis |
| **Python** | Google Colab | EDA, cleaning, statistics, ML |
| **Data Manipulation** | Pandas, NumPy | Data processing and feature engineering |
| **Visualisation** | Matplotlib, Seaborn | EDA charts and statistical plots |
| **Statistics** | SciPy, Statsmodels | T-test, ANOVA, Chi-square, A/B testing |
| **Machine Learning** | Scikit-learn, XGBoost | K-Means clustering, CLV prediction |
| **Explainability** | SHAP | Feature importance and model interpretation |
| **Dashboard** | Power BI Desktop | Interactive 3-page business dashboard |
| **Version Control** | GitHub | Project repository and portfolio |

---

## 📊 Statistical Results Summary

```
T-test  (Campaign 1 vs Spend):  t=19.54,  p=0.0000  ✅ Significant
ANOVA   (Education vs Spend):   F=17.27,  p=0.0000  ✅ Significant
Chi-sq  (Marital vs Campaign):  χ²=1.45,  p=0.923   ❌ Not significant
A/B Test (Campaign 3 vs 5):     t=0.057,  p=0.954   🤝 No difference

ML Model Performance:
XGBoost R² Score:  0.891  (89.1% variance explained)
XGBoost RMSE:      £202.76 (average prediction error)
```

---

## 📝 Data Limitations

1. **No actual advertising spend data** — Budget tracker was omitted as the dataset contains customer purchase revenue, not company advertising costs. A real budget tracker would require actual ad spend data from marketing platforms.

2. **Z_Revenue is a constant proxy** — Not real transaction revenue per customer. ROI calculations are directionally correct but not absolute.

3. **No timestamp per campaign** — Attribution modeling assumes Campaign 1–5 are chronologically ordered. Real attribution would require individual campaign exposure timestamps.

4. **Single market dataset** — Results are specific to this company's customer base and may not generalise across industries.

---

## ✅ Business Questions — Answered

At the start of this project, the business asked 5 critical questions. Here are the data-backed answers:

---

**❓ Question 1 — Which campaign drives the most customer conversions?**

> **Campaign 4** is the top performing campaign with a **7.46% acceptance rate** and **167 conversions** — ranking #1 across all 5 campaigns. Campaign 2 is the worst performer at only 1.34% and should have its budget reallocated. Additionally, attribution modeling revealed that Campaign 1 starts 40% of all customer journeys (awareness) while Campaign 5 closes 50% of all conversions (sales driver) — both play critical but different roles in the funnel.

---

**❓ Question 2 — Which channel generates the best return?**

> All three channels generate similar revenue (Store: £1.35M, Web: £1.35M, Catalog: £1.32M). However **Catalog is the most cost-efficient channel** with the lowest Customer Acquisition Cost at **£18,194** compared to Store (£24,475) and Web (£24,101). Store reaches the most customers (2,225) making it the best volume channel. The right answer depends on the business goal — efficiency (Catalog) or reach (Store).

---

**❓ Question 3 — Which customers are most valuable and which are at risk?**

> K-Means clustering identified 4 distinct segments:
> - 🏆 **Champions (520 customers)** — avg spend £1,269 — most valuable, generate 49% of total revenue
> - 💚 **Loyal (597 customers)** — consistent buyers, lower individual spend
> - ⚠️ **At-Risk (646 customers)** — represent a **£75,000 retention opportunity** — immediate re-engagement needed
> - ❌ **Lost (473 customers)** — had high historical spend (avg £1,078) — worth a win-back campaign

---

**❓ Question 4 — Can we predict how much a customer will spend in the future?**

> **Yes — with 89.1% accuracy.** An XGBoost machine learning model was trained on customer demographics, purchase history and campaign behaviour. The model predicts Customer Lifetime Value with an R² of 0.891 and an average error of just £203. Customers were classified into three CLV tiers: High (£1,761 avg), Mid (£1,158 avg) and Low (£218 avg). The 171 High CLV customers are worth 8× more than Low CLV customers individually.

---

**❓ Question 5 — What factors actually drive customer spending behaviour?**

> Three independent methods all point to the same answer:
> 1. **Correlation analysis** — Income vs Total Spend = 0.79 (strong positive relationship)
> 2. **ANOVA test** — Education level significantly affects purchases (F=17.27, p=0.0000)
> 3. **SHAP explainability** — Top 3 predictors are Catalog purchases, Purchase frequency and Income
>
> **Conclusion:** High-income, educated customers who buy frequently through the catalog channel are the highest-value customer profile. Marketing efforts should be concentrated on acquiring and retaining this profile.

---

## 👤 Author

**Fahad VB**

- 📧 Email: fahadfanu7@gmail.com
- 💼 LinkedIn: https://www.linkedin.com/in/fahadvb/



- Dataset: [Kaggle — Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis) by Dr. Omar Romero-Hernandez
- Tools: Google BigQuery, Google Colab, Microsoft Power BI

---

*This project was built as a portfolio project demonstrating end-to-end data analytics skills across SQL, Python, Statistics and Business Intelligence.*
