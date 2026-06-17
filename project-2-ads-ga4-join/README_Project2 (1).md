# Project 2 — Google Ads + GA4 JOIN Analysis
## Cost Per Lead by Landing Page

## Overview

This project answers the most important question in performance marketing:

> **Which landing pages give the lowest cost per lead — and which ones are wasting ad budget?**

By joining Google Ads spend data with GA4 behavioural data using SQL, I built a complete picture of paid campaign efficiency at the landing page level.

---

## The Problem

KOTS was running paid campaigns across multiple landing pages but had no visibility into:

- Which specific pages were generating leads from paid traffic
- How much each lead was actually costing per page
- Which pages were receiving budget but generating zero conversions

Without this analysis, budget decisions were based on campaign-level data — not page-level reality.

---

## Tools Used

| Tool | Purpose |
|---|---|
| Google Ads Report Editor | Ad spend, impressions, conversions by landing page |
| Google Analytics 4 | Views, engagement time, key events, CVR% |
| Python | Data cleaning and URL matching |
| SQLite | JOIN query logic |
| GitHub | Portfolio documentation |

---

## Data Sources

**Source 1 — Google Ads Landing Pages Report**
- Date range: May 1–31, 2026
- Columns: Landing page URL, Campaign, Impressions, Cost, Conversions, Cost per conversion

**Source 2 — GA4 Pages & Screens Report**
- Date range: May 1–31, 2026
- Columns: Page path URL, Views, Active users, Avg engagement time, Key events, CVR%

---

## Methodology

### The Core Challenge — URL Mismatch

Google Ads URLs contain tracking parameters:
```
https://www.kots.world/bangalore/whitefield/1-bhk{ignore}?utm_source=google&utm_medium=cpc...
```

GA4 shows only the clean path:
```
/bangalore/whitefield/1-bhk
```

**Solution:** Strip the domain and tracking parameters from Google Ads URLs to create a matching key.

---

### Step 1 — Clean Google Ads URLs

Remove `https://www.kots.world` and everything after `{ignore}`:

```python
url_clean = re.sub(r'\{ignore\}.*', '', url_raw)
url_path = re.sub(r'https://www\.kots\.world', '', url_clean).rstrip('/')
```

---

### Step 2 — Calculate CVR% from GA4

```sql
SELECT 
  page_path AS URL,
  views AS Views,
  key_events AS Key_Events,
  ROUND(CAST(key_events AS FLOAT) / CAST(views AS FLOAT) * 100, 2) AS CVR_Percent,
  avg_engagement_sec AS Engagement_Sec
FROM ga4_pages
WHERE views > 100;
```

---

### Step 3 — JOIN Both Tables on URL

```sql
SELECT 
  g.url AS URL,
  g.cost AS Ad_Spend_INR,
  p.views AS Views,
  p.engagement_sec AS Engagement_Sec,
  p.key_events AS Key_Events,
  p.cvr_percent AS CVR_Percent,
  ROUND(g.cost / p.key_events, 2) AS Cost_Per_Lead_INR,

  CASE 
    WHEN p.cvr_percent >= 15 AND p.engagement_sec >= 30 THEN 'Increase Budget'
    WHEN p.engagement_sec >= 40 AND p.cvr_percent < 5 THEN 'Fix CTA First'
    ELSE 'Reduce Budget'
  END AS Decision

FROM google_ads_data g
JOIN ga4_pages p ON g.url = p.url
WHERE g.cost > 0
ORDER BY g.cost DESC;
```

---

## Key Findings

### 1. Biggest Budget Leak — ₹38,288 Wasted

| Page | Spend | Views | Key Events | Cost Per Lead |
|---|---|---|---|---|
| /bangalore/whitefield/2-bhk | ₹38,288 | 14 | 0 | ❌ N/A |

**38,288 rupees spent. 14 views. Zero leads.**

This is the single biggest finding of the analysis. Either the page is broken, the URL tracking is wrong, or the audience targeting is completely misaligned.

**Immediate action: Pause this page and investigate.**

---

### 2. Best Performing Page — ₹0.72 Cost Per Lead

| Page | Spend | CVR | Cost Per Lead |
|---|---|---|---|
| /bangalore/whitefield/1bhk-for-rent-in-whitefield | ₹967 | 23.42% | **₹0.72** |

This page converts at 23% and costs less than 1 rupee per lead. It is massively underinvested compared to pages wasting thousands.

---

### 3. Full Decision Table

| URL | Spend | CVR | Cost Per Lead | Decision |
|---|---|---|---|---|
| /bangalore/whitefield/1bhk-for-rent-in-whitefield | ₹967 | 23.42% | ₹0.72 | ✅ Increase Budget |
| /bangalore/whitefield/2-bhk | ₹38,288 | 0% | N/A | ❌ Stop Immediately |
| /bangalore/whitefield/1-bhk | ₹2,970 | 0% | N/A | ❌ Stop Immediately |
| /bangalore/whitefield/kots-soir | ₹3,096 | 3.04% | ₹21.96 | 🔧 Fix CTA First |
| /bangalore/whitefield/kots-hamlet | ₹2,792 | 1.99% | ₹56.98 | 🔧 Fix CTA First |
| /bangalore/whitefield/3bhk-for-rent-in-whitefield | ₹1,126 | 10.17% | ₹31.27 | ❌ Reduce Budget |
| /bangalore/flats-for-rent-in-whitefield | ₹955 | 1.96% | ₹4.24 | ❌ Reduce Budget |
| /flats-for-rent-in-bangalore | ₹694 | 1.32% | ₹1.76 | 🔧 Fix CTA First |

---

## Business Recommendations

**1. Stop /whitefield/2-bhk campaign immediately**
₹38,288 with zero leads. Highest priority action. Investigate page health and URL tracking before reactivating.

**2. Double budget on /whitefield/1bhk-for-rent-in-whitefield**
₹0.72 cost per lead at 23% CVR. If budget shifted from the 2-bhk page alone, this page could generate 50,000+ leads with the same spend.

**3. Fix CTA on kots-soir and kots-hamlet pages**
Both have 55-68 seconds engagement — users are reading. But CVR is under 3%. A stronger WhatsApp button or lead form placement will unlock conversions without increasing spend.

**4. Never send paid traffic to generic city pages**
/flats-for-rent-in-whitefield and /flats-for-rent-in-bangalore have sub-2% CVR from paid traffic. These pages attract organic informational searchers, not paid buyers.

---

## What This Analysis Proves

This is not possible to see inside Google Ads or GA4 alone.

- Google Ads shows cost and conversions — but conversions are often miscounted
- GA4 shows behaviour — but does not show how much you spent
- **Joining both reveals the real cost per lead per page**

This is the foundation of data-driven budget allocation.

---

## Files in This Project

| File | Description |
|---|---|
| README.md | This case study |
| ads_ga4_join.sql | SQL JOIN query used |
| kots_ads_ga4_joined.csv | Final joined output with decisions |

---

## About

**Renuka Prasad S**
Digital Marketing Manager — KOTS Renting Pvt. Ltd., Bangalore
Specialisation: Performance Marketing, SEO, AEO, Growth Analytics

*This analysis was conducted on real Google Ads and GA4 data to identify cost per lead by landing page and optimise paid campaign budget allocation.*
