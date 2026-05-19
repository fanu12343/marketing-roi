WITH customer_cohorts AS (
  SELECT
    ID,
DATE_TRUNC(Dt_Customer, MONTH) AS cohort_month,
    SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS total_spend
  FROM `marketing-roi-495611.marketing_dataset.m_roi`
  GROUP BY ID, cohort_month
)

SELECT
  cohort_month,
  COUNT(ID) AS total_customers,
  ROUND(AVG(total_spend), 2) AS avg_spend_per_customer,
  SUM(total_spend) AS cohort_total_spend
FROM customer_cohorts
GROUP BY cohort_month
ORDER BY cohort_month;