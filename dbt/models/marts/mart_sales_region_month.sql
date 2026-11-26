SELECT
    c.region,
    STRFTIME(d.date_key, '%Y-%m') AS ym,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.quantity) AS total_quantity,
    SUM(f.total_amount) AS total_revenue
FROM {{ ref('fact_sales') }} f
JOIN {{ ref('dim_customer') }} c
    ON f.customer_id = c.customer_id
JOIN {{ ref('dim_date') }} d
    ON f.date_key = d.date_key
GROUP BY 1, 2
ORDER BY 2, 1