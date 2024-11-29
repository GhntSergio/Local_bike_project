{{ config(
    materialized='view'
) }}

WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        p.list_price,
        -- Calculer cost_price à l'aide d'une logique CASE
        CASE
            WHEN c.category_id = 1 THEN p.list_price * 0.6
            WHEN c.category_id = 2 THEN p.list_price * 0.65
            WHEN c.category_id = 3 THEN p.list_price * 0.7
            WHEN c.category_id = 4 THEN p.list_price * 0.75
            WHEN c.category_id = 5 THEN p.list_price * 0.8
            WHEN c.category_id = 6 THEN p.list_price * 0.7
            WHEN c.category_id = 7 THEN p.list_price * 0.75
            ELSE p.list_price * 0.7 -- Ratio par défaut
        END AS cost_price,
        SUM(oi.quantity) AS total_quantity_sold, -- Quantité totale vendue
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_revenue, -- Revenus après réduction
        SUM(
            oi.quantity * 
            CASE
                WHEN c.category_id = 1 THEN p.list_price * 0.6
                WHEN c.category_id = 2 THEN p.list_price * 0.65
                WHEN c.category_id = 3 THEN p.list_price * 0.7
                WHEN c.category_id = 4 THEN p.list_price * 0.75
                WHEN c.category_id = 5 THEN p.list_price * 0.8
                WHEN c.category_id = 6 THEN p.list_price * 0.7
                WHEN c.category_id = 7 THEN p.list_price * 0.75
                ELSE p.list_price * 0.7 -- Ratio par défaut
            END
        ) AS total_cost -- Coût total estimé
    FROM {{ ref('stg_localbike_order_item') }} oi
    JOIN {{ ref('stg_localbike_products') }} p
      ON oi.product_id = p.product_id
    JOIN {{ ref('stg_localbike_categories') }} c
      ON p.category_id = c.category_id -- Désambiguïser category_id ici
    GROUP BY p.product_id, p.product_name, p.list_price, c.category_id
),

profitability_metrics AS (
    SELECT
        product_id,
        product_name,
        total_quantity_sold,
        total_revenue,
        total_cost,
        ROUND((total_revenue - total_cost), 2) AS gross_profit, -- Marge bénéficiaire brute
        ROUND(((total_revenue - total_cost) / total_revenue) * 100, 2) AS gross_margin_percentage -- Pourcentage de marge brute
    FROM product_sales
)

SELECT
    product_id,
    product_name,
    total_quantity_sold,
    ROUND(total_revenue,2) AS total_revenue,
    ROUND(total_cost,2) AS total_cost,
    gross_profit,
    gross_margin_percentage
FROM profitability_metrics
ORDER BY gross_profit DESC -- Trier par marge brute décroissante

