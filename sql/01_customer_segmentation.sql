-- ============================================
-- Customer Segmentation by RFM Model
-- Retail Loyalty Program Analytics
-- Author: Karen Pineda | karenpineda-ai
-- ============================================

-- RFM Segmentation (Recency, Frequency, Monetary)
SELECT 
    customer_id,
    COUNT(order_id)                                    AS total_orders,
    SUM(amount)                                        AS total_spent,
    AVG(amount)                                        AS avg_ticket,
    MAX(order_date)                                    AS last_purchase_date,
    DATEDIFF(NOW(), MAX(order_date))                   AS days_since_last_purchase,
    DATEDIFF(MAX(order_date), MIN(order_date))         AS days_active,
    CASE 
        WHEN COUNT(order_id) >= 10 
             AND SUM(amount) >= 500000  THEN 'VIP'
        WHEN COUNT(order_id) >= 5  
             AND SUM(amount) >= 200000  THEN 'Regular'
        WHEN COUNT(order_id) >= 2                      THEN 'Occasional'
        ELSE                                                'New'
    END AS segment
FROM orders
WHERE order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY customer_id
ORDER BY total_spent DESC;


-- Segment Summary
SELECT
    segment,
    COUNT(*)                                           AS total_customers,
    ROUND(AVG(total_spent), 0)                         AS avg_clv,
    ROUND(AVG(total_orders), 1)                        AS avg_orders,
    ROUND(AVG(avg_ticket), 0)                          AS avg_ticket,
    SUM(total_spent)                                   AS total_revenue,
    ROUND(SUM(total_spent) / 
          SUM(SUM(total_spent)) OVER() * 100, 1)       AS revenue_pct
FROM (
    SELECT 
        customer_id,
        COUNT(order_id)   AS total_orders,
        SUM(amount)       AS total_spent,
        AVG(amount)       AS avg_ticket,
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
ORDER BY avg_clv DESC;
