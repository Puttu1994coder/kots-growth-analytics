-- ============================================================
-- Project 3 — GA4 Traffic Source / Channel Quality Analysis
-- Author: Renuka Prasad S
-- Purpose: Find which channels drive real conversions vs just clicks
-- Data: GA4 Traffic Acquisition Report (Session primary channel group)
-- Period: May 1 - May 31, 2026
-- Table: Traffic_acquisition_Session
-- Columns: c1=channel, c2=sessions, c3=engaged_sessions,
--          c4=engagement_rate, c5=avg_engagement_time,
--          c6=events_per_session, c7=event_count,
--          c8=key_events, c9=session_key_event_rate
-- ============================================================


-- ============================================================
-- SECTION 1: EXPLORE THE DATA
-- ============================================================

SELECT * FROM Traffic_acquisition_Session;


-- ============================================================
-- SECTION 2: RANK CHANNELS BY VOLUME (the misleading view)
-- ============================================================

SELECT
  c1 AS Channel,
  c2 AS Sessions,
  ROUND(CAST(c4 AS FLOAT) * 100, 1) AS Engagement_Rate_Percent
FROM Traffic_acquisition_Session
WHERE c1 NOT LIKE 'Session primary%'
ORDER BY CAST(c2 AS INTEGER) DESC;


-- ============================================================
-- SECTION 3: RANK CHANNELS BY REAL CONVERSION (CVR%)
-- ============================================================

SELECT
  c1 AS Channel,
  c2 AS Sessions,
  c8 AS Key_Events,
  ROUND(CAST(c9 AS FLOAT) * 100, 2) AS CVR_Percent,
  ROUND(CAST(c5 AS FLOAT), 1) AS Avg_Engagement_Sec
FROM Traffic_acquisition_Session
WHERE c1 NOT LIKE 'Session primary%'
ORDER BY CVR_Percent DESC;


-- ============================================================
-- SECTION 4: VOLUME vs QUALITY GAP
-- Large negative Rank_Gap = high volume rank but poor CVR rank
--   -> "Looks good in clicks, converts badly"
-- Large positive Rank_Gap = low volume rank but strong CVR rank
--   -> "Small but mighty"
-- ============================================================

SELECT
  c1 AS Channel,
  c2 AS Sessions,
  RANK() OVER (ORDER BY CAST(c2 AS INTEGER) DESC) AS Volume_Rank,
  ROUND(CAST(c9 AS FLOAT) * 100, 2) AS CVR_Percent,
  RANK() OVER (ORDER BY CAST(c9 AS FLOAT) DESC) AS CVR_Rank,
  (RANK() OVER (ORDER BY CAST(c2 AS INTEGER) DESC) - RANK() OVER (ORDER BY CAST(c9 AS FLOAT) DESC)) AS Rank_Gap
FROM Traffic_acquisition_Session
WHERE c1 NOT LIKE 'Session primary%'
ORDER BY Rank_Gap ASC;


-- ============================================================
-- SECTION 5: ENGAGEMENT QUALITY CHECK / DIAGNOSIS
-- ============================================================

SELECT
  c1 AS Channel,
  c2 AS Sessions,
  ROUND(CAST(c5 AS FLOAT), 1) AS Avg_Engagement_Sec,
  ROUND(CAST(c9 AS FLOAT) * 100, 2) AS CVR_Percent,
  CASE
    WHEN CAST(c5 AS FLOAT) < 10 AND CAST(c9 AS FLOAT) < 0.01
      THEN 'LOW QUALITY TRAFFIC - INVESTIGATE/REDUCE'
    WHEN CAST(c5 AS FLOAT) >= 30 AND CAST(c9 AS FLOAT) < 0.05
      THEN 'INTERESTED BUT NOT CONVERTING - FIX CTA/LANDING PAGE'
    WHEN CAST(c9 AS FLOAT) >= 0.10
      THEN 'HIGH QUALITY - INCREASE INVESTMENT'
    ELSE 'MONITOR'
  END AS Diagnosis
FROM Traffic_acquisition_Session
WHERE c1 NOT LIKE 'Session primary%'
AND CAST(c2 AS INTEGER) > 500
ORDER BY CVR_Percent DESC;


-- ============================================================
-- SECTION 6: PAID CHANNELS HEAD-TO-HEAD
-- ============================================================

SELECT
  c1 AS Paid_Channel,
  c2 AS Sessions,
  c8 AS Key_Events,
  ROUND(CAST(c9 AS FLOAT) * 100, 2) AS CVR_Percent,
  ROUND(CAST(c5 AS FLOAT), 1) AS Avg_Engagement_Sec
FROM Traffic_acquisition_Session
WHERE c1 LIKE 'Paid%'
ORDER BY CVR_Percent DESC;


-- ============================================================
-- SECTION 7: FINAL DECISION TABLE
-- ============================================================

SELECT
  c1 AS Channel,
  c2 AS Sessions,
  ROUND(CAST(c9 AS FLOAT) * 100, 2) AS CVR_Percent,
  ROUND(CAST(c5 AS FLOAT), 1) AS Avg_Engagement_Sec,
  CASE
    WHEN CAST(c9 AS FLOAT) >= 0.10 THEN 'INCREASE BUDGET / DOUBLE DOWN'
    WHEN CAST(c9 AS FLOAT) < 0.01 AND CAST(c2 AS INTEGER) > 50000 THEN 'STOP / DRASTICALLY REDUCE'
    WHEN CAST(c5 AS FLOAT) >= 30 AND CAST(c9 AS FLOAT) < 0.05 THEN 'FIX LANDING PAGE / CTA'
    ELSE 'MONITOR'
  END AS Decision
FROM Traffic_acquisition_Session
WHERE c1 NOT LIKE 'Session primary%'
AND CAST(c2 AS INTEGER) > 500
ORDER BY CAST(c2 AS INTEGER) DESC;
