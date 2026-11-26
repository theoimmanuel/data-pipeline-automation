WITH monthly AS (
    SELECT
        STRFTIME(d.date_key, '%Y-%m') AS ym,
        SUM(f.total_amount) AS monthly_revenue
    FROM {{ ref('fact_sales') }} f
    JOIN {{ ref('dim_date') }} d
        ON f.date_key = d.date_key
    GROUP BY 1
)

SELECT
    ym,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY ym) AS prev_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY ym))
        * 100.0
        / NULLIF(LAG(monthly_revenue) OVER (ORDER BY ym), 0),
        2
    ) AS mom_growth_pct
FROM monthly
ORDER BY ym