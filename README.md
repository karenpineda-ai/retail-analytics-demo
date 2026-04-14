# Retail Loyalty Program Analytics Demo 🛍️

Analytical framework for measuring and optimizing retail 
loyalty program performance — customer segmentation, 
retention tracking and business KPIs.

Built by [Karen Pineda](https://linkedin.com/in/karenpineda-businessanalyst)  
AI Automation Specialist & Business Analyst

---

## Business Context

A retail loyalty program generates valuable behavioral data:
- Purchase frequency and average ticket
- Customer lifetime value (CLV)
- Churn risk by segment
- Campaign effectiveness

This framework shows how to structure the analysis using SQL 
queries and Power BI dashboards to drive business decisions.

---

## SQL Queries

### 1. Customer Segmentation by Purchase Frequency
```sql
SELECT 
    customer_id,
    COUNT(order_id) as total_orders,
    SUM(amount) as total_spent,
    AVG(amount) as avg_ticket,
    DATEDIFF(MAX(order_date), MIN(order_date)) as days_active,
    CASE 
        WHEN COUNT(order_id) >= 10 THEN 'VIP'
        WHEN COUNT(order_id) >= 5 THEN 'Regular'
        ELSE 'Occasional'
    END as segment
FROM orders
WHERE order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY customer_id
ORDER BY total_spent DESC
```

### 2. Monthly Retention Rate
```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(DISTINCT customer_id) as active_customers,
    COUNT(DISTINCT CASE 
        WHEN customer_id IN (
            SELECT customer_id FROM orders 
            WHERE order_date BETWEEN 
                DATE_SUB(order_date, INTERVAL 1 MONTH) AND order_date
        ) THEN customer_id 
    END) as retained_customers
FROM orders
GROUP BY month
ORDER BY month
```

### 3. Revenue by Loyalty Tier
```sql
SELECT
    segment,
    COUNT(customer_id) as total_customers,
    AVG(total_spent) as avg_clv,
    AVG(total_orders) as avg_frequency,
    SUM(total_spent) as revenue_contribution,
    ROUND(SUM(total_spent) / SUM(SUM(total_spent)) OVER() * 100, 1) as revenue_pct
FROM customer_segments
GROUP BY segment
ORDER BY avg_clv DESC
```

### 4. Churn Risk Detection
```sql
SELECT
    customer_id,
    MAX(order_date) as last_purchase,
    DATEDIFF(NOW(), MAX(order_date)) as days_since_last_purchase,
    COUNT(order_id) as total_orders,
    CASE
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 90 THEN 'High Risk'
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 60 THEN 'Medium Risk'
        ELSE 'Active'
    END as churn_risk
FROM orders
GROUP BY customer_id
HAVING days_since_last_purchase > 30
ORDER BY days_since_last_purchase DESC
```

---

## KPIs Tracked

| KPI | Description | Target |
|-----|-------------|--------|
| Retention Rate | % customers who repurchase | > 40% |
| Average Ticket | Avg order value by segment | Growing MoM |
| CLV | Customer lifetime value | > 3x acquisition cost |
| Churn Rate | % customers lost per month | < 5% |
| NPS | Net Promoter Score | > 50 |
| Points Redemption Rate | % loyalty points redeemed | > 30% |

---

## Power BI Dashboard Structure

**Page 1 — Executive Summary**
- Total active loyalty members
- Revenue by loyalty tier
- Monthly retention trend
- Top 10 products by loyalty members

**Page 2 — Customer Segmentation**
- RFM matrix (Recency, Frequency, Monetary)
- Segment migration over time
- Churn risk heatmap by region

**Page 3 — Campaign Performance**
- Campaign ROI by segment
- Points issued vs redeemed
- Redemption rate by product category

---

## Tools Used

![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoftexcel&logoColor=white)
![Google Sheets](https://img.shields.io/badge/Google_Sheets-34A853?style=flat&logo=googlesheets&logoColor=white)
