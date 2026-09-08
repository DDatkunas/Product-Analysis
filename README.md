# E-Commerce Purchase Speed & Conversion Journey Analysis
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)
![Google BigQuery](https://img.shields.io/badge/Google_BigQuery-669DF6?style=for-the-badge&logo=googlebigquery&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Jupyter Notebook](https://img.shields.io/badge/Jupyter_Notebook-F37626?style=for-the-badge&logo=jupyter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3a77ad?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Scipy](https://img.shields.io/badge/Scipy-005A9C?style=for-the-badge&logo=scipy&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)


### About the Project
This project evaluates same-day user journeys across a three-month dataset (~4,600 daily purchases across 100 countries) to measure conversion speed trends, evaluate user behavior across acquisition channels and devices, and assess how conversion duration correlates with total revenue.

---
### The core business objective
- Identifying friction points in the checkout process, evaluate channel traffic efficiency, and uncover strategies to maximize Average Order Value (AOV).

---

### Repository Files
- [Dashboard](dashboard/)
- [Query](product_analysis.sql)
- [Hypothesis Testing](product_hypothesis_tests.ipynb)

---

## Key Findings & Results

### Financial & Operational KPIs
* **Total Revenue:** $299,000
* **Average Order Value (AOV):** $65
* **Median Time to Purchase:** 19 minutes
* **Average Time to Purchase:** 74 minutes

### Journey Duration & Revenue Correlation
* **Higher Consideration Equals Higher Revenue:** Slower conversion journeys drove significantly larger cart sizes. Purchases in the **Slow Tier** averaged **$80 AOV**, double the **Very Fast Tier** average of **$40 AOV**.
* **Pre-Holiday Friction:** In the period leading up to the Christmas season, users took an average of 3 minutes longer to complete a purchase.

### Behavioral & Segmentation Patterns
* **Customer Retention:** Returning users converted significantly faster (13 min median) than first-time buyers (19.5 min median). 40% of repeat purchases occurred in the Fast/Very Fast duration tiers.
* **Day-of-Week Trends:** Sundays saw the fastest median purchase times (16 min), while Wednesdays recorded the longest (22 min).
* [Hypothesis Testing](product_hypothesis_tests.ipynb) showed statistical significance in both of these patterns.

---

### Recommendations

1. **Optimize High-Consideration Paths for Larger Carts:** Since longer decision-making journeys correlate with higher AOV, implement UX features that support comparison behavior to boost revenue.
2. **Enhance Personalization for Returning Buyers:** Repeat customers convert rapidly. Implementing personalized product recommendations, saved payment methods, and one-click reorder paths will capitalize on this existing speed advantage.
3. **Reduce Pre-Holiday Checkout Friction:** Introduce seasonal gift discovery tools, curated holiday collections, and prominent shipping dead-line notices prior to December to prevent decision fatigue.

---

### Limitations of the Analysis

* **Same-Day Boundary Constraint:** Purchases completing on a different calendar day from the user's initial login were filtered out of this dataset, which may undercount longer multi-day consideration journeys.
* **Timezone Standardization:** Event timestamps reflect UTC without user-level timezone data. Cross-midnight activity across global regions may lead to underreporting total daily purchase volume.
