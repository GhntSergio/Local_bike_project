{{ config(
    materialized='view'
) }}

WITH sales_data AS (
    SELECT
        o.store_id,
        oi.product_id,
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_revenue -- Calcul des revenus après réduction
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_orders') }} o
      ON oi.order_id = o.order_id
    WHERE o.order_status = 4 -- Commandes expédiées uniquement
    GROUP BY 1, 2
),

store_revenue AS (
    SELECT
        s.store_id,
        s.store_name,
        sd.total_revenue
    FROM sales_data sd
    JOIN {{ ref('stg_localbike_stores') }} s
      ON sd.store_id = s.store_id
)

SELECT
    store_id,
    store_name,
    ROUND(SUM(total_revenue), 2) AS total_revenue -- Agrégation des revenus par magasin
FROM store_revenue
GROUP BY store_id, store_name
ORDER BY total_revenue DESC
