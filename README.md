# Customer Personality Analysis

End-to-end data analytics project on customer behavior and marketing response — cleaning, EDA, SQL analysis, and a business dashboard with actionable recommendations.

## Project Overview
This project analyzes the Customer Personality Analysis dataset — 2,240 customer records covering demographics, spending, purchase channels, and marketing campaign responses. It follows a full analytics workflow: data cleaning, exploratory analysis, SQL querying, and dashboarding.

## Problem Statement
Marketing campaigns don't perform equally across all customers — some segments respond well to offers, while others represent wasted spend. Without understanding which customer groups are most likely to engage, marketing budgets get allocated inefficiently. This project analyzes customer demographics, spending behavior, and past campaign responses to identify which segments to prioritize for future targeting.

## Objective
Analyze customer behavior and marketing campaign response data to identify which customer segments are most valuable and least engaged — through data cleaning, exploratory analysis, SQL querying, and a final dashboard with actionable business recommendations.
2,240 customer records covering demographics, spending across 6 product categories, purchase channels, and marketing campaign responses.


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
