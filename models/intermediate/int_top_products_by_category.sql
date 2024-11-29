{{ config(
    materialized='view'
) }}

WITH product_sales AS (
    SELECT
        p.category_id,
        p.product_id,
        o.store_id,
        p.product_name,
        c.category_name,
        SUM(oi.quantity) AS total_quantity_sold -- Calcul des quantités totales vendues par produit
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_products') }} p
      ON oi.product_id = p.product_id
    JOIN {{ ref('stg_localbike_categories') }} c
      ON p.category_id = c.category_id
    JOIN {{ ref('stg_localbike_orders') }} o
      ON oi.order_id = o.order_id
    GROUP BY 1, 2, 3, 4, 5
),

ranked_products AS (
    SELECT
        category_id,
        store_id,
        category_name,
        product_id,
        product_name,
        total_quantity_sold,
        RANK() OVER (PARTITION BY category_id ORDER BY total_quantity_sold DESC) AS product_rank -- Classement par catégorie
    FROM product_sales
)

SELECT
    category_id,
    store_id,
    category_name,
    product_id,
    product_name,
    total_quantity_sold,
    product_rank
FROM ranked_products
WHERE product_rank <= 5 -- Garder les 5 produits les plus vendus par catégorie
ORDER BY category_id, product_rank
