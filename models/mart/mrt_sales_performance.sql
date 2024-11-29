{{ config(
    materialized='table'
) }}

WITH sales_by_store AS (
    SELECT
        store_id,
        store_name,
        total_revenue AS revenue_by_store
    FROM {{ ref('int_revenue_by_store') }} -- Modèle intermediate
),

top_products AS (
    SELECT
        category_name,
        product_name,
        total_quantity_sold,
        product_rank
    FROM {{ ref('int_top_products_by_category') }} -- Modèle intermediate
    WHERE product_rank <= 5
),

sales_by_channel AS (
    SELECT
        sales_channel,
        total_revenue AS revenue_by_channel,
        total_quantity AS quantity_by_channel
    FROM {{ ref('int_sales_by_channel') }} -- Modèle intermediate
)

SELECT
    -- Revenus par point de vente
    sb.store_id,
    sb.store_name,
    sb.revenue_by_store,

    -- Produits les plus vendus par catégorie
    tp.category_name,
    tp.product_name,
    tp.total_quantity_sold AS top_product_quantity
FROM sales_by_store sb
LEFT JOIN top_products tp
    ON TRUE -- Jointure logique pour croiser les résultats
ORDER BY sb.revenue_by_store DESC
