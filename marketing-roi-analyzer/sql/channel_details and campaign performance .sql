WITH channel AS (
  SELECT 'Web' AS channel,
    COUNT(ID) AS total_customers,
    SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS total_spend,
    COUNTIF(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + 
            AcceptedCmp4 + AcceptedCmp5 > 0) AS total_conversions,
    SUM(Z_Revenue) AS total_revenue
  from `marketing-roi-495611.marketing_dataset.m_roi`
  WHERE NumWebPurchases > 0

  UNION ALL

  SELECT 'Catalog' AS channel,
 COUNT(ID) AS total_customers,
    SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS total_spend,
    COUNTIF(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + 
            AcceptedCmp4 + AcceptedCmp5 > 0) AS total_conversions,
    SUM(Z_Revenue) AS total_revenue
  from `marketing-roi-495611.marketing_dataset.m_roi`
   WHERE NumCatalogPurchases > 0

  UNION ALL

  SELECT 'Store' AS channel,
 COUNT(ID) AS total_customers,
    SUM(MntWines + MntFruits + MntMeatProducts + 
        MntFishProducts + MntSweetProducts + MntGoldProds) AS total_spend,
    COUNTIF(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + 
            AcceptedCmp4 + AcceptedCmp5 > 0) AS total_conversions,
    SUM(Z_Revenue) AS total_revenue
  from `marketing-roi-495611.marketing_dataset.m_roi`
      WHERE NumStorePurchases > 0
)

SELECT
  *,
  total_spend / NULLIF(total_conversions, 0) AS CAC,
  ROUND(((total_revenue - total_spend) / NULLIF(total_spend, 0)) * 100, 2) AS ROI
FROM channel
ORDER BY ROI DESC;