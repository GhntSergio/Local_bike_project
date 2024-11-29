{{ config(
    materialized='view'
) }}

WITH sales_data AS (
    SELECT
        FORMAT_DATE('%Y-%m', CAST(o.order_date AS DATE)) AS sales_month, -- Combiner année et mois (YYYY-MM)
        ROUND(SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)),3) AS total_revenue, -- Revenus totaux après réduction
        SUM(oi.quantity) AS total_quantity -- Quantité totale vendue
    FROM {{ ref('stg_localbike_orders') }} o
    JOIN {{ ref('stg_localbike_order_item') }} oi
      ON o.order_id = oi.order_id
    WHERE o.order_status = 4 -- Commandes expédiées uniquement
    GROUP BY sales_month
),

seasonality_metrics AS (
    SELECT
        sales_month,
        total_revenue,
        total_quantity,
        ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS revenue_percentage, -- Pourcentage des revenus par mois
        ROUND((total_quantity / SUM(total_quantity) OVER ()) * 100, 2) AS quantity_percentage -- Pourcentage des quantités par mois
    FROM sales_data
)

SELECT
    sales_month,
    total_revenue,
    total_quantity,
    revenue_percentage,
    quantity_percentage
FROM seasonality_metrics
ORDER BY sales_month