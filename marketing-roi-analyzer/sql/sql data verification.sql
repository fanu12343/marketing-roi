SELECT * FROM `marketing-roi-495611.marketing_dataset.m_roi` limit 5;
select count(*) from `marketing-roi-495611.marketing_dataset.m_roi`;
SELECT
  COUNTIF(Income IS NULL) AS income_nulls,
  COUNTIF(Year_Birth IS NULL) AS year_birth_nulls,
  COUNTIF(ID IS NULL) AS id_nulls
FROM  `marketing-roi-495611.marketing_dataset.m_roi`;
SELECT DISTINCT Education,count(Education) as Count 
FROM  `marketing-roi-495611.marketing_dataset.m_roi`
group by Education
ORDER BY Education;
select distinct Marital_Status,count(Marital_Status) as count
FROM  `marketing-roi-495611.marketing_dataset.m_roi`
group by Marital_Status
order by Marital_Status;
