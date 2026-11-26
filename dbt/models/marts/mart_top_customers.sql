SELECT
    c.customer_id,
    c.customer_name,
    c.region,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_items,
    SUM(f.total_amount) AS total_spending
FROM {{ ref('fact_sales') }} f
JOIN {{ ref('dim_customer') }} c
    ON f.customer_id = c.customer_id
GROUP BY 1, 2, 3
ORDER BY total_spending DESC
LIMIT 10