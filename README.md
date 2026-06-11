 KOTS Growth Analytics — GA4 Page Performance Analysis

 Overview

This project analyses real website data from **KOTS Renting Pvt. Ltd.**, a managed rental apartment company in Bangalore, to answer one business question:

Which landing pages deserve more ad budget — and which ones are wasting spend?**

Using GA4 data and SQL, I built a data-driven budget allocation framework based on user engagement and conversion behaviour.

 Business Context

KOTS runs paid campaigns across Google Ads, Meta Ads, and Reddit Ads targeting renters in Bangalore. With multiple landing pages across different localities and property types, the challenge was:

- Not all pages convert equally
- Increasing budget on low-performing pages wastes CAC
- Without data, budget decisions were based on assumptions

 Tools Used

| Tool | Purpose |

| Google Analytics 4 | Raw behavioural data source |
| SQLite (sqliteonline.com) | SQL analysis |
| Microsoft Excel | Data export and decision mapping |
| GitHub | Portfolio documentation |

 Dataset

**Source:** GA4 Pages & Screens Report  
**Metrics used:**
- Page views
- Active users
- Average engagement time (seconds)
- Event count
- Key events (WhatsApp clicks, lead submissions, calls)
- CVR% (Key Events / Views × 100)

 Methodology

 Step 1 — Export GA4 Data
Exported Pages & Screens report as CSV from GA4 and imported into SQLite.

 Step 2 — Explore the Data
```sql
SELECT * FROM Pages_and_screens_Page_title_and_screen_class LIMIT 10;
```

Step 3 — Top Pages by Traffic
```sql
SELECT c1 AS Page_Name, c2 AS Views, c3 AS Active_Users
FROM Pages_and_screens_Page_title_and_screen_class
WHERE c1 NOT LIKE 'Page title%'
ORDER BY c2 DESC
LIMIT 10;
```

Step 4 — Calculate Conversion Rate (CVR%)
```sql
SELECT 
  c1 AS Page_Name,
  c2 AS Views,
  c7 AS Key_Events,
  ROUND(CAST(c7 AS FLOAT) / CAST(c2 AS FLOAT) * 100, 2) AS CVR_Percent
FROM Pages_and_screens_Page_title_and_screen_class
WHERE c1 NOT LIKE 'Page title%'
AND CAST(c2 AS INTEGER) > 500
ORDER BY CVR_Percent DESC
LIMIT 10;
```

 Step 5 — Full Performance Analysis
```sql
SELECT 
  c1 AS Page_Name,
  c2 AS Views,
  c3 AS Active_Users,
  ROUND(CAST(c5 AS FLOAT), 1) AS Avg_Engagement_Sec,
  c7 AS Key_Events,
  ROUND(CAST(c7 AS FLOAT) / CAST(c2 AS FLOAT) * 100, 2) AS CVR_Percent
FROM Pages_and_screens_Page_title_and_screen_class
WHERE c1 NOT LIKE 'Page title%'
AND CAST(c2 AS INTEGER) > 5000
ORDER BY c7 DESC, CVR_Percent DESC
LIMIT 15;
```

Key Findings

 Decision Framework

| CVR% | Engagement | Decision |
|---|---|---|
| Above 15% | Above 30 sec | ✅ Increase Budget |
| Above 30 sec | Below 5% CVR | 🔧 Fix CTA First |
| Below 5% | Below 15 sec | ❌ Reduce Budget |

Results

| Page | Views | Engagement | CVR% | Decision |

| Furnished Studio Flat - Mahadevpura | 95,681 | 61 sec | 28.8% | ✅ Increase Budget |
| Furnished 1 BHK - Hennur | 9,468 | 35 sec | 26.5% | ✅ Increase Budget |
| Furnished 1 BHK - Whitefield | 5,764 | 38 sec | 23.4% | ✅ Increase Budget |
| Furnished 2 BHK - Whitefield | 8,265 | 37 sec | 20.5% | ✅ Increase Budget |
| Furnished 1 BHK - Sarjapur | 28,392 | 47 sec | 20.3% | ✅ Increase Budget |
| Upgrade to Premium Living | 42,637 | 57 sec | 19.8% | ✅ Increase Budget |
| Furnished 1 BHK - Mahadevpura | 7,032 | 28 sec | 19.6% | ✅ Increase Budget |
| Kots Serein - Bellandur | 6,256 | 77 sec | 1.53% | 🔧 Fix CTA First |
| Studio & 1 BHK - Whitefield Bien | 5,109 | 60 sec | 1.37% | 🔧 Fix CTA First |
| Flats/Apartments - Bangalore | 29,877 | 48 sec | 1.32% | 🔧 Fix CTA First |
| Discover Flats - Whitefield | 70,345 | 10 sec | 1.05% | ❌ Reduce Budget |
| Kots Aube - Hennur | 57,321 | 9 sec | 0.49% | ❌ Reduce Budget |
| Studio 1BHK 2BHK - Whitefield Neuf | 32,387 | 9 sec | 0.38% | ❌ Reduce Budget |
| Studio - Koramangala | 24,116 | 17 sec | 0.68% | ❌ Reduce Budget |

 Insight
1. "No Hidden Charges" pages consistently outperform**  
Every high-CVR page has "No Hidden Charges" in the title. This is the strongest value proposition for KOTS renters and should be used in all ad headlines.

2. High traffic ≠ high conversion**  
"Discover Flats in Whitefield" gets 70,000+ views but only 10 seconds engagement and 1% CVR. Traffic without intent is wasted budget.

3. Hidden gems need attention**  
Kots Serein Bellandur has 77 seconds average engagement — the highest of all pages — but only 1.53% CVR. Users are reading but not acting. A stronger WhatsApp CTA or lead form placement could unlock significant leads without any extra ad spend.

4. Locality matters more than property type**  
Mahadevpura and Bellandur pages consistently outperform Whitefield generic pages. Budget should be concentrated on these localities.

---

 Business Recommendations

1. **Double ad spend** on Mahadevpura Studio and Bellandur Studio pages — highest traffic + highest CVR
2. **Add "No Hidden Charges" to all ad headlines** — proven messaging from page performance data
3. **Fix CTA on Kots Serein Bellandur** — 77 sec engagement with almost zero conversions is a UX problem, not a traffic problem
4. **Pause or reduce budget** on Whitefield generic pages and Koramangala — wrong audience reaching these pages
5. **Replicate Mahadevpura Studio page structure** for other localities — it is the benchmark

---

 Summary

| Category | Pages | Action |
|---|---|---|
| ✅ Increase Budget | 7 pages | Shift more ad spend here |
| 🔧 Fix CTA First | 3 pages | Improve page before spending more |
| ❌ Reduce Budget | 4 pages | Reallocate budget away |

---

 About

Renuka Prasad S
Digital Marketing Manager — KOTS Renting Pvt. Ltd., Bangalore  
Specialisation: Performance Marketing, SEO, AEO, Growth Analytics

*This analysis was conducted on real GA4 data using SQL to support data-driven marketing decisions.*# kots-growth-analytics
GA4 page performance analysis using SQL to identify budget allocation opportunities
