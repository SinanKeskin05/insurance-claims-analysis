# PostgreSQL Insurance Risk Analysis

## 🎯 Project Overview
This project focuses on data analysis using PostgreSQL to evaluate insurance claims. The goal is to perform risk segmentation, identify high-claim cohorts, and provide actionable insights for better policy management.

## 🛠️ Tech Stack
* *Database:* PostgreSQL
* *Tool:* pgAdmin 4 / SQL Editor

## 🔍 Key Analyses Performed
* *Risk Segmentation:* Grouping customers and vehicles by risk levels using CASE WHEN statements.
* *Trend Analysis:* Analyzing yearly and monthly claim patterns.
* *Aggregated Metrics:* Using aggregate functions and window functions to evaluate the contribution of specific segments to the total claim pool.
* *Claim Rate Analysis:* Comparing claim rates across vehicle models and engine power segments.

## 💻 Key SQL Queries
```⁠
WITH engine_risk AS (
    SELECT
        v.engine_type,
        COUNT(p.policy_id) AS total_policies,
        COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) AS total_claims,
        ROUND(
            COUNT(CASE WHEN p.claim_status = '1' THEN 1 END) * 100.0 
            / COUNT(p.policy_id), 
            2
        ) AS claim_rate_percentage
    FROM policies p
    JOIN vehicles v 
        ON p.vehicle_id = v.vehicle_id
    GROUP BY v.engine_type
)
SELECT
    engine_type,
    total_policies,
    total_claims,
    claim_rate_percentage,
    RANK() OVER (
        ORDER BY claim_rate_percentage DESC
    ) AS risk_rank
FROM engine_risk
ORDER BY risk_rank;
```
## 💡 Insights
* *Volume vs. Risk Paradox:* Analysis of vehicle models and engine power reveals that high-volume segments (mainstream models) do not necessarily correlate with higher risk. Specific models such as *M2 and M5* exhibit higher claim rates (7.41% and 7.26%), making them notable segments for risk-adjusted pricing analysis.
* *Non-Linear Risk Distribution:* Engine power analysis indicates a non-linear relationship with claim rates, with risk peaking at specific power segments such as the *0.77 engine power tier*. This suggests that insurance risk may be sensitive to specific technical thresholds rather than following a simple linear trend.



