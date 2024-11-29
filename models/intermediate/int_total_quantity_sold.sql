{{ config(
    materialized='view'
) }}

WITH product_quantity AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold -- Quantité totale vendue
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_products') }} p
      ON oi.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)

SELECT
    product_id,
    product_name,
    total_quantity_sold
FROM product_quantity
ORDER BY total_quantity_sold DESC -- Trier par quantité décroissante
