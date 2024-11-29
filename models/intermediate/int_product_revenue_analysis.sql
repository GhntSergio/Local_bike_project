{{ config(
    materialized='view'
) }}

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.list_price, -- Prix unitaire (identique au prix de vente)
        SUM(oi.quantity) AS total_quantity_sold, -- Quantité totale vendue
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_revenue -- Revenus après réduction
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_products') }} p
      ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.list_price
),

revenue_metrics AS (
    SELECT
        product_id,
        product_name,
        list_price,
        total_quantity_sold,
        total_revenue,
        ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS revenue_percentage -- Contribution au revenu total
    FROM product_sales
)

SELECT
    product_id,
    product_name,
    list_price,
    total_quantity_sold,
    ROUND( total_revenue,2) AS total_revenue,
    revenue_percentage
FROM revenue_metrics
ORDER BY total_revenue DESC -- Trier par revenus décroissants
