# Customer Personality Analysis

End-to-end data analytics project on customer behavior and marketing response — cleaning, EDA, SQL analysis, and a business dashboard with actionable recommendations.

## Project Overview
This project analyzes the Customer Personality Analysis dataset — 2,240 customer records covering demographics, spending, purchase channels, and marketing campaign responses. It follows a full analytics workflow: data cleaning, exploratory analysis, SQL querying, and dashboarding.

## Problem Statement
Marketing campaigns don't perform equally across all customers — some segments respond well to offers, while others represent wasted spend. Without understanding which customer groups are most likely to engage, marketing budgets get allocated inefficiently. This project analyzes customer demographics, spending behavior, and past campaign responses to identify which segments to prioritize for future targeting.

## Objective
Analyze customer behavior and marketing campaign response data to identify which customer segments are most valuable and least engaged — through data cleaning, exploratory analysis, SQL querying, and a final dashboard with actionable business recommendations.


## Week 1 — Data Cleaning
Cleaned the raw dataset to make it analysis-ready — handling missing values, removing duplicates, fixing data types, and resolving inconsistent or invalid entries. Every cleaning decision is documented and justified rather than applied blindly.

## What was cleaned
| Issue | Action | Reasoning |
|---|---|---|
| 24 missing `Income` values | Filled with median | Income is right-skewed; median avoids distortion from high earners. Only ~1% of rows affected, so imputing preserves otherwise-complete records. |
| `Dt_Customer` stored as text | Converted to datetime | Enables date-based analysis (e.g. tenure, enrollment trends) in later stages. |
| 3 customers with impossible birth years (e.g. 1893, 1899) | Rows dropped | Implied age >100 is a clear data entry error, not a real customer. Removed rather than guessed at. |
| Junk categories in `Marital_Status` (`Absurd`, `YOLO`, `Alone`) | Mapped to `Single` | `Alone` is a duplicate label; `Absurd`/`YOLO` are invalid entries. Folding into `Single` preserves the records instead of discarding them. |
| `Z_CostContact`, `Z_Revenue` constant across all rows | Dropped | Zero variance means zero analytical value. |

## Results
| Metric | Before | After |
|---|---|---|
| Rows | 2,240 | 2,237 |
| Columns | 29 | 27 |
| Missing values | 24 | 0 |
| Duplicate rows | 0 | 0 |

## Tools Used
- **Python** (Pandas, NumPy) — data cleaning and manipulation
- **Jupyter Notebook** — analysis environment


## Week 2 — Exploratory Data Analysis

Explored the cleaned dataset to uncover patterns in customer spending and campaign response behavior. Computed descriptive statistics and built 6 visualizations, each tied to a specific business question.

### Key Findings
| Finding | Insight |
|---|---|
| Income distribution | Right-skewed — most customers earn 25,000–75,000, with a long tail of higher earners |
| Spend by education | Basic-education customers spend ~82 on average, roughly 8x lower than every other education group (500–670 range) |
| Spend by marital status | Widow customers show a higher median spend despite being the smallest group |
| Purchases by channel | Store purchases dominate over web and catalog |
| Campaign acceptance rates | The most recent campaign ('Response') hit ~15% acceptance — roughly double every earlier campaign |
| Income vs. spend | Positive correlation overall, but a segment of mid/high-income customers under-spend relative to income |

### Visualizations
1. Income distribution (histogram)
2. Average spend by education level (bar chart)
3. Spend distribution by marital status (boxplot)
4. Purchases by channel (bar chart)
5. Campaign acceptance rates (bar chart)
6. Income vs. total spend (scatter plot)

## Tools Used
- **Python** (Pandas, NumPy) — data cleaning and manipulation
- **Matplotlib, Seaborn** — data visualization
- **Jupyter Notebook** — analysis environment


## Week 3 — SQL Analysis (PostgreSQL)

Answered the same kinds of business questions from Week 2, this time in SQL using PostgreSQL. Since the
cleaned dataset is a single flat file, it was split into four related tables — `customers`, `spending`,
`purchases`, and `campaigns` — all linked by customer ID, so the queries below include real JOINs across
genuinely separate tables rather than working with one table alone.

### Database Structure
| Table | Rows | Description |
|---|---|---|
| `customers` | 2,237 | Demographics: education, marital status, income, age, complaints |
| `spending` | 13,422 | One row per customer per product category (melted from 6 spend columns) |
| `purchases` | 11,185 | One row per customer per purchase channel (melted from channel columns) |
| `campaigns` | 13,422 | One row per customer per campaign (melted from 6 campaign columns) |

### The 10 Queries
| # | Question Answered | Technique Used |
|---|---|---|
| 1 | Which education group generates the most total spend? | JOIN + GROUP BY |
| 2 | Within each marital status, which category drives the most spend? | JOIN + 2-column GROUP BY |
| 3 | Are latest-campaign responders wealthier than average? | JOIN + subquery |
| 4 | Does education level affect web purchase behavior? | JOIN + WHERE + GROUP BY |
| 5 | Which campaign performed best? | Aggregation |
| 6 | How many customers are "high spenders"? | Subquery |
| 7 | Do certain education groups complain more? | GROUP BY |
| 8 | Who are the top 5 highest-value customers? | JOIN + subquery + LIMIT |
| 9 | Do purchase channel preferences shift by age group? | JOIN + CASE + GROUP BY |
| 10 | What's the income profile of childless, above-average spenders? | Nested subquery |

### Verifying Pandas vs SQL (PostgreSQL)
| Metric | SQL Result | Pandas Result | Match |
|---|---|---|---|
| Total spend, Graduation | 698,626.00 | 698,626 | ✅ |
| Total spend, Basic | 4,417.00 | 4,417 | ✅ |
| Campaign6_Latest acceptance rate | 14.93% | 14.93% | ✅ |
| Childless high-spenders count | 478 | 478 | ✅ |
| Childless high-spenders avg income | 75,955.28 | 75,955.28 | ✅ |

### Key Findings
- **Income, not education itself, appears to drive the spend gap** — latest-campaign responders average
  60,183 income vs. 52,227 overall (Query 3), and higher-education customers also skew toward higher income.
- **The most recent campaign meaningfully outperformed every prior one** — 14.93% acceptance vs. 1.34%–7.47%
  for the previous five campaigns (Query 5).
- **A clear high-value segment exists**: 478 childless customers who spend above average carry an average
  income of 75,955.28 — well above the overall base of 52,227 (Query 10).

## Tools Used
- **Python** (Pandas, NumPy) — data cleaning and manipulation
- **Matplotlib, Seaborn** — data visualization
- **PostgreSQL** — relational database, SQL querying and validation
- **pgAdmin** — PostgreSQL database management and query execution
- **Jupyter Notebook** — analysis environment
- **Power BI Desktop** — dashboard and business intelligence reporting *(Week 4)*
- **Microsoft Word** — insights report
- **GitHub** — version control and project hosting

## Week 4 — Insights Dashboard & Report

**Dashboard & Report:** Customer Personality Analysis Dashboard a 2-page Power BI dashboard covering campaign performance, spending patterns, and customer demographics.

Turned the analysis from Weeks 1-3 into a 2-page Power BI dashboard and a written report with 3 specific, actionable recommendations — each following a finding → supporting chart → action structure.

### Dashboard Structure

**Page 1 — Dashboard Overview (Campaign & Spending Insights)**
| Visual | Details |
|---|---|
| KPI cards | Total Spend ($1,355,048), High-Value Customers (917), Average Age (45.1), Campaign Success Rate (14.93%) |
| Spending by Product Category | Bar chart — Wines and Meat dominate total spend |
| Income vs Total Spend | Scatter chart — positive correlation, one dot per customer |
| Average Spend by Age Group | Line chart — dips at 31-40, rises steadily through 61-70 |
| Slicers | Age Group, Income Bucket, Campaign Accepted |

**Page 2 — Customer Insights (Demographics)**
| Visual | Details |
|---|---|
| KPI cards | Total Customers (2,237), Avg Income ($52,227), Average Age (45.1), Response Rate (14.93%) |
| Marital Status | Donut chart — 39% Married, 26% Together, 22% Single, 10% Divorced, 3% Widow |
| Education Level | Bar chart — 50% Graduation, 22% PhD, 17% Master, 9% 2n Cycle, 2% Basic |
| Age Distribution | Bar chart — 29% aged 41-50, the largest single band |
| Slicers | Education, Marital Status, Children at Home |

### Key DAX Measures
\```dax
Total Spend = SUM(customers[Total_Spend_Check])
Total Customers = DISTINCTCOUNT(customers[ID])
Avg Income = AVERAGE(customers[Income])
Avg Age = AVERAGE(customers[Age])
High Value Customers = CALCULATE(DISTINCTCOUNT(customers[ID]), FILTER(customers, customers[Total_Spend_Check] > [Avg Spend per Customer]))
Campaign Rate = AVERAGE(customers[Response]) * 100
\```

### Report: 3 Recommendations
1. **Target childless, higher-income households** — 478 customers with no dependents and above-average spend
   carry an average income of $75,955, 45% above the overall base. Prioritize this segment for the next campaign.
2. **Re-engage Basic-education customers with value-tier offers, not premium ones** — this group spends ~8x
   less than every other education group and shows the lowest engagement across every channel; the gap is
   income-driven, not preference-driven.
3. **Study and replicate what made the latest campaign succeed** — it achieved 14.93% acceptance, nearly
   double the best-performing prior campaign, and skewed toward higher-income responders.

## Tools Used
- **Power BI Desktop** — dashboard building and DAX measures
- **Power Query** — data shaping and unpivoting for the dashboard
- **Microsoft Word** — insights report
