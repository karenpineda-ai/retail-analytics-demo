-- ============================================
-- Revenue Analysis by Loyalty Tier
-- Retail Loyalty Program Analytics
-- Author: Karen Pineda | karenpineda-ai
-- ============================================

-- Revenue Contribution by Loyalty Tier
SELECT
    segment,
    COUNT(DISTINCT customer_id)                         AS total_customers,
    SUM(total_spent)                                    AS total_revenue,
    ROUND(AVG(total_spent), 0)                          AS avg_clv,
    ROUND(AVG(total_orders), 1)                         AS avg_orders,
    ROUND(AVG(avg_ticket), 0)                           AS avg_ticket,
    ROUND(SUM(total_spent) /
          SUM(SUM(total_spent)) OVER() * 100, 1)        AS revenue_pct,
    ROUND(COUNT(DISTINCT customer_id) /
          SUM(COUNT(DISTINCT customer_id)) OVER() * 100, 1) AS customer_pct
FROM (
    SELECT
        customer_id,
        COUNT(order_id)     AS total_orders,
        SUM(amount)         AS total_spent,
        AVG(amount)         AS avg_ticket,
        CASE
            WHEN COUNT(order_id) >= 10
                 AND SUM(amount) >= 500000 THEN 'VIP'
            WHEN COUNT(order_id) >= 5
                 AND SUM(amount) >= 200000 THEN 'Regular'
            WHEN COUNT(order_id) >= 2      THEN 'Occasional'
            ELSE                                'New'
        END AS segment
    FROM orders
    WHERE order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
    GROUP BY customer_id
) segments
GROUP BY segment
ORDER BY total_revenue DESC;


-- Monthly Revenue Trend by Tier
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m')              AS month,
    s.segment,
    COUNT(DISTINCT o.customer_id)                   AS active_customers,
    SUM(o.amount)                                   AS monthly_revenue,
    ROUND(AVG(o.amount), 0)                         AS avg_ticket
FROM orders o
JOIN (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) >= 10
                 AND SUM(amount) >= 500000 THEN 'VIP'
            WHEN COUNT(order_id) >= 5
                 AND SUM(amount) >= 200000 THEN 'Regular'
            WHEN COUNT(order_id) >= 2      THEN 'Occasional'
            ELSE                                'New'
        END AS segment
    FROM orders
    GROUP BY customer_id
) s ON o.customer_id = s.customer_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), s.segment
ORDER BY month, total_revenue DESC;


-- Top 10 Products by Loyalty Tier
SELECT
    s.segment,
    o.product_category,
    COUNT(o.order_id)                               AS total_orders,
    SUM(o.amount)                                   AS total_revenue,
    ROUND(AVG(o.amount), 0)                         AS avg_ticket
FROM orders o
JOIN (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) >= 10
                 AND SUM(amount) >= 500000 THEN 'VIP'
            WHEN COUNT(order_id) >= 5
                 AND SUM(amount) >= 200000 THEN 'Regular'
            WHEN COUNT(order_id) >= 2      THEN 'Occasional'
            ELSE                                'New'
        END AS segment
    FROM orders
    GROUP BY customer_id
) s ON o.customer_id = s.customer_id
GROUP BY s.segment, o.product_category
ORDER BY s.segment, total_revenue DESC;
