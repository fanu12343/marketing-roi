CREATE OR REPLACE VIEW `marketing-roi-495611.marketing_dataset.vw_customer_segments` AS

WITH rfm_base AS (
  SELECT
    ID,
    DATE_DIFF(CURRENT_DATE(), DATE_TRUNC(Dt_Customer, DAY), DAY) AS recency_days,
    (NumWebPurchases + NumStorePurchases + NumCatalogPurchases) AS frequency,
    (MntWines + MntFruits + MntMeatProducts + 
     MntFishProducts + MntSweetProducts + MntGoldProds) AS monetary,
    Income,
    Education,
    Marital_Status
  FROM `marketing-roi-495611.marketing_dataset.m_roi`
),

rfm_scored AS (
  SELECT
    *,
    NTILE(4) OVER (ORDER BY recency_days ASC)  AS r_score,
    NTILE(4) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary DESC) AS m_score
  FROM rfm_base
)

SELECT
  *,
  (r_score + f_score + m_score) AS rfm_total,
  CASE
    WHEN (r_score + f_score + m_score) >= 10 THEN 'Champion'
    WHEN (r_score + f_score + m_score) >= 7  THEN 'Loyal'
    WHEN (r_score + f_score + m_score) >= 5  THEN 'At-Risk'
    ELSE 'Lost'
  END AS customer_segment
FROM rfm_scored;


SELECT customer_segment, COUNT(*) as total
FROM `marketing-roi-495611.marketing_dataset.vw_customer_segments`
GROUP BY customer_segment
ORDER BY total DESC;