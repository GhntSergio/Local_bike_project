{{ config(
    materialized='table'
) }}

WITH profitability AS (
    SELECT
        product_id,
        product_name,
        gross_profit,
        gross_margin_percentage
    FROM {{ ref('int_product_profitability') }} -- Marges bénéficiaires par produit
),

revenue_analysis AS (
    SELECT
        product_id,
        total_revenue
    FROM {{ ref('int_product_revenue_analysis') }} -- Revenu total généré par produit
),

quantity_sold AS (
    SELECT
        product_id,
        total_quantity_sold
    FROM {{ ref('int_total_quantity_sold') }} -- Quantité totale vendue
),

revenue_percentage AS (
    SELECT
        product_id,
        revenue_percentage
    FROM {{ ref('int_product_revenue_percentage') }} -- Contribution au revenu total
)

SELECT
    p.product_id,
    p.product_name,
    r.total_revenue,
    q.total_quantity_sold,
    rp.revenue_percentage,
    p.gross_profit,
    p.gross_margin_percentage
FROM profitability p
LEFT JOIN revenue_analysis r
    ON p.product_id = r.product_id
LEFT JOIN quantity_sold q
    ON p.product_id = q.product_id
LEFT JOIN revenue_percentage rp
    ON p.product_id = rp.product_id
ORDER BY r.total_revenue DESC
