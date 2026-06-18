SELECT * FROM google_ads_clean LIMIT 3;
SELECT * FROM ga4_table LIMIT 3;
SELECT 
  g.c1 AS URL,
  g.c4 AS Ad_Spend_INR,
  p.c2 AS Views,
  ROUND(CAST(p.c5 AS FLOAT), 1) AS Engagement_Sec,
  p.c7 AS Key_Events,
  ROUND(CAST(p.c7 AS FLOAT) / CAST(p.c2 AS FLOAT) * 100, 2) AS CVR_Percent,
  ROUND(CAST(g.c4 AS FLOAT) / CAST(p.c7 AS FLOAT), 2) AS Cost_Per_Lead_INR,
  CASE 
    WHEN CAST(p.c7 AS FLOAT) / CAST(p.c2 AS FLOAT) * 100 >= 15 
         AND CAST(p.c5 AS FLOAT) >= 30 
         THEN 'Increase Budget'
    WHEN CAST(p.c5 AS FLOAT) >= 40 
         AND CAST(p.c7 AS FLOAT) / CAST(p.c2 AS FLOAT) * 100 < 5 
         THEN 'Fix CTA First'
    ELSE 'Reduce Budget'
  END AS Decision
FROM google_ads_clean g
JOIN ga4_table p ON g.c1 = RTRIM(p.c1, '/')
WHERE g.c1 != 'url'
AND p.c1 != 'Page path and screen class'
AND CAST(p.c7 AS INTEGER) > 0
AND CAST(g.c4 AS FLOAT) > 0
ORDER BY CAST(g.c4 AS FLOAT) DESC
LIMIT 20;
         
