-- ============================================
-- Monthly Retention Rate Analysis
-- Retail Loyalty Program Analytics
-- Author: Karen Pineda | karenpineda-ai
-- ============================================

-- Monthly Active Customers & Retention Rate
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m')              AS month,
    COUNT(DISTINCT o.customer_id)                   AS active_customers,
    COUNT(DISTINCT prev.customer_id)                AS retained_customers,
    ROUND(
        COUNT(DISTINCT prev.customer_id) * 100.0 /
        NULLIF(COUNT(DISTINCT o.customer_id), 0), 1
    )                                               AS retention_rate_pct
FROM orders o
LEFT JOIN orders prev
    ON o.customer_id = prev.customer_id
    AND DATE_FORMAT(prev.order_date, '%Y-%m') = 
        DATE_FORMAT(DATE_SUB(o.order_date, INTERVAL 1 MONTH), '%Y-%m')
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;


-- New vs Returning Customers per Month
SELECT
    DATE_FORMAT(order_date, '%Y-%m')                AS month,
    COUNT(DISTINCT customer_id)                     AS total_customers,
    COUNT(DISTINCT CASE 
        WHEN customer_since = DATE_FORMAT(order_date, '%Y-%m') 
        THEN customer_id END)                       AS new_customers,
    COUNT(DISTINCT CASE 
        WHEN customer_since < DATE_FORMAT(order_date, '%Y-%m') 
        THEN customer_id END)                       AS returning_customers,
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN customer_since < DATE_FORMAT(order_date, '%Y-%m') 
            THEN customer_id END) * 100.0 /
        NULLIF(COUNT(DISTINCT customer_id), 0), 1
    )                                               AS returning_pct
FROM orders o
JOIN (
    SELECT customer_id, DATE_FORMAT(MIN(order_date), '%Y-%m') AS customer_since
    FROM orders
    GROUP BY customer_id
) first_purchase USING (customer_id)
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- 90-Day Cohort Retention
SELECT
    DATE_FORMAT(first_purchase, '%Y-%m')            AS cohort_month,
    COUNT(DISTINCT customer_id)                     AS cohort_size,
    COUNT(DISTINCT CASE 
        WHEN last_purchase >= DATE_ADD(first_purchase, INTERVAL 30 DAY) 
        THEN customer_id END)                       AS retained_30d,
    COUNT(DISTINCT CASE 
        WHEN last_purchase >= DATE_ADD(first_purchase, INTERVAL 60 DAY) 
        THEN customer_id END)                       AS retained_60d,
    COUNT(DISTINCT CASE 
        WHEN last_purchase >= DATE_ADD(first_purchase, INTERVAL 90 DAY) 
        THEN customer_id END)                       AS retained_90d
FROM (
    SELECT 
        customer_id,
        MIN(order_date) AS first_purchase,
        MAX(order_date) AS last_purchase
    FROM orders
    GROUP BY customer_id
) cohorts
GROUP BY DATE_FORMAT(first_purchase, '%Y-%m')
ORDER BY cohort_month;
