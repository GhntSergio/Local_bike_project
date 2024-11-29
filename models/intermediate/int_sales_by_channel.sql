{{ config(
    materialized='view'
) }}

WITH sales_data AS (
    SELECT
        CASE
            WHEN o.store_id IS NULL THEN 'Online' -- Commandes sans magasin associé
            ELSE 'Physical' -- Commandes associées à un magasin
        END AS sales_channel,
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_revenue, -- Revenus nets
        SUM(oi.quantity) AS total_quantity -- Quantité totale vendue
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_orders') }} o
      ON oi.order_id = o.order_id
    WHERE o.order_status = 4 -- Commandes expédiées uniquement
    GROUP BY 1
)

SELECT
    sales_channel,
    total_quantity,
    ROUND(total_revenue, 2) AS total_revenue -- Revenus arrondis pour plus de lisibilité
FROM sales_data
ORDER BY total_revenue DESC
