# Power BI Dashboard Structure
## Retail Loyalty Program Analytics

---

## Overview

This document describes the Power BI dashboard structure designed
to monitor and optimize retail loyalty program performance.
The dashboard has 3 pages, each targeting a different audience.

---

## Page 1 — Executive Summary
**Audience:** CEO, Commercial Director, Board

### KPI Cards (top row)
| KPI | Calculation | Target |
|-----|-------------|--------|
| Total Active Members | COUNT DISTINCT customer_id (last 90 days) | Growing MoM |
| Monthly Revenue | SUM amount (current month) | > prior month |
| Retention Rate | Returning customers / total customers | > 40% |
| Avg Ticket | AVG amount (current month) | Growing MoM |

### Visuals
- **Line chart** — Monthly revenue trend (last 12 months) by loyalty tier
- **Donut chart** — Revenue % by segment (VIP / Regular / Occasional / New)
- **Bar chart** — Top 10 product categories by revenue
- **Map** — Revenue by region (if location data available)

### Filters
- Date range selector
- Product category
- Loyalty tier

---

## Page 2 — Customer Segmentation
**Audience:** Marketing Manager, CRM Team

### KPI Cards (top row)
| KPI | Calculation |
|-----|-------------|
| VIP Customers | COUNT where segment = 'VIP' |
| Churn Risk (High) | COUNT where days_inactive > 90 |
| New Customers (MTD) | COUNT first purchase this month |
| Avg CLV | AVG total_spent per customer |

### Visuals
- **Scatter plot** — RFM Matrix (Frequency vs Monetary, size = Recency)
- **Funnel chart** — Customer migration between segments MoM
- **Heatmap** — Churn risk by segment and days inactive
- **Table** — Top 50 VIP customers with last purchase date and CLV

### Filters
- Segment selector
- Churn risk level
- Date range

---

## Page 3 — Campaign Performance
**Audience:** Marketing Analyst, Loyalty Program Manager

### KPI Cards (top row)
| KPI | Calculation |
|-----|-------------|
| Points Issued (MTD) | SUM loyalty_points_issued |
| Points Redeemed (MTD) | SUM loyalty_points_redeemed |
| Redemption Rate | Redeemed / Issued * 100 |
| Campaign ROI | Revenue attributed / Campaign cost |

### Visuals
- **Bar chart** — Points issued vs redeemed by month
- **Line chart** — Redemption rate trend (last 6 months)
- **Bar chart** — Campaign ROI by customer segment
- **Table** — Campaign performance by product category

### Filters
- Campaign selector
- Date range
- Segment

---

## Data Model

orders (fact table)
├── order_id (PK)
├── customer_id (FK → customers)
├── order_date
├── amount
├── product_category
└── status
customers (dimension)
├── customer_id (PK)
├── segment (calculated)
├── first_purchase_date
├── last_purchase_date
└── total_spent (calculated)
loyalty_points (dimension)
├── customer_id (FK)
├── points_issued
├── points_redeemed
└── transaction_date

---

## Refresh Schedule

| Dataset | Frequency | Source |
|---------|-----------|--------|
| Orders | Daily 6am | SQL Database |
| Customer Segments | Daily 7am | SQL Query |
| Loyalty Points | Daily 6am | CRM API |

---

## Built by

[Karen Pineda](https://linkedin.com/in/karenpineda-businessanalyst)
AI Automation Specialist & Business Analyst
