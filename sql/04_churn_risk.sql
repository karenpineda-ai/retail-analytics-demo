-- ============================================
-- Churn Risk Detection & Prevention
-- Retail Loyalty Program Analytics
-- Author: Karen Pineda | karenpineda-ai
-- ============================================

-- Churn Risk Scoring by Customer
SELECT
    customer_id,
    MAX(order_date)                                     AS last_purchase,
    DATEDIFF(NOW(), MAX(order_date))                    AS days_since_last_purchase,
    COUNT(order_id)                                     AS total_orders,
    SUM(amount)                                         AS total_spent,
    AVG(amount)                                         AS avg_ticket,
    CASE
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 90  THEN 'High Risk'
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 60  THEN 'Medium Risk'
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 30  THEN 'Low Risk'
        ELSE                                             'Active'
    END                                                 AS churn_risk,
    CASE
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 90  THEN 1
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 60  THEN 2
        WHEN DATEDIFF(NOW(), MAX(order_date)) > 30  THEN 3
        ELSE                                             4
    END                                                 AS risk_score
FROM orders
GROUP BY customer_id
ORDER BY days_since_last_purchase DESC;


-- Churn Risk Summary by Segment
SELECT
    churn_risk,
    COUNT(DISTINCT customer_id)                         AS total_customers,
    ROUND(AVG(total_spent), 0)                          AS avg_clv,
    ROUND(AVG(days_since_last_purchase), 0)             AS avg_days_inactive,
    SUM(total_spent)                                    AS revenue_at_risk
FROM (
    SELECT
        customer_id,
        SUM(amount)                                     AS total_spent,
        DATEDIFF(NOW(), MAX(order_date))                AS days_since_last_purchase,
        CASE
            WHEN DATEDIFF(NOW(), MAX(order_date)) > 90  THEN 'High Risk'
            WHEN DATEDIFF(NOW(), MAX(order_date)) > 60  THEN 'Medium Risk'
            WHEN DATEDIFF(NOW(), MAX(order_date)) > 30  THEN 'Low Risk'
            ELSE                                             'Active'
        END AS churn_risk
    FROM orders
    GROUP BY customer_id
) risk_table
GROUP BY churn_risk
ORDER BY avg_days_inactive DESC;


-- High Value Customers at High Churn Risk (Priority for Recovery)
SELECT
    customer_id,
    MAX(order_date)                                     AS last_purchase,
    DATEDIFF(NOW(), MAX(order_date))                    AS days_inactive,
    COUNT(order_id)                                     AS total_orders,
    SUM(amount)                                         AS total_spent,
    'Send win-back campaign'                            AS recommended_action
FROM orders
GROUP BY customer_id
HAVING 
    DATEDIFF(NOW(), MAX(order_date)) > 60
    AND SUM(amount) >= 200000
    AND COUNT(order_id) >= 3
ORDER BY total_spent DESC
LIMIT 100;
