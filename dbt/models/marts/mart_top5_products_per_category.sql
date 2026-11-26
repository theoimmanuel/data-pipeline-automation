WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        SUM(f.quantity) AS total_quantity,
        SUM(f.total_amount) AS total_revenue
    FROM {{ ref('fact_sales') }} f
    JOIN {{ ref('dim_product') }} p
        ON f.product_id = p.product_id
    GROUP BY 1, 2, 3
)

SELECT
    category,
    product_id,
    product_name,
    total_quantity,
    total_revenue,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM product_sales
QUALIFY category_rank <= 5
ORDER BY category, category_rank