{{ config(
    materialized='view'
) }}

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_revenue -- Revenus après réduction
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_products') }} p
      ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
),

revenue_percentage_calculation AS (
    SELECT
        product_id,
        product_name,
        total_revenue,
        ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS revenue_percentage -- Contribution en pourcentage
    FROM product_revenue
)

SELECT
    product_id,
    product_name,
    ROUND(total_revenue,2) AS total_revenue,
    revenue_percentage
FROM revenue_percentage_calculation
ORDER BY revenue_percentage DESC -- Trier par contribution décroissante
