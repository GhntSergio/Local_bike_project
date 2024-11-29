{{ config(
    materialized='view'
) }}

WITH customer_orders AS (
    SELECT
        o.customer_id,
        c.city,
        c.state,
        c.zip_code,
        COUNT(o.order_id) AS total_orders, -- Nombre total de commandes
        SUM(oi.quantity) AS total_quantity, -- Quantité totale achetée
        SUM((oi.quantity * oi.list_price) - (oi.quantity * oi.list_price * oi.discount)) AS total_spent -- Montant total dépensé après réduction
    FROM {{ ref('stg_localbike_orders') }} o
    JOIN {{ ref('stg_localbike_order_item') }} oi
      ON o.order_id = oi.order_id
    JOIN {{ ref('stg_localbike_customers') }} c
      ON o.customer_id = c.customer_id
    WHERE o.order_status = 4 -- Commandes expédiées uniquement
    GROUP BY o.customer_id, c.city, c.state, c.zip_code
),

aggregated_data AS (
    SELECT
        customer_id,
        city,
        state,
        zip_code,
        COUNT(customer_id) AS total_customers, -- Nombre total de clients par localisation
        SUM(total_orders) AS total_orders, -- Total des commandes par localisation
        SUM(total_quantity) AS total_quantity, -- Quantité totale achetée par localisation
        SUM(total_spent) AS total_revenue, -- Montant total dépensé par localisation
        ROUND(AVG(total_spent / total_orders), 2) AS avg_order_value -- Valeur moyenne par commande
    FROM customer_orders
    GROUP BY customer_id, city, state, zip_code
)

SELECT
    customer_id,
    city,
    state,
    zip_code,
    total_customers,
    total_orders,
    total_quantity,
    ROUND(total_revenue,2) AS total_revenue,
    avg_order_value
FROM aggregated_data
ORDER BY total_revenue DESC -- Trier par revenu total pour prioriser les localisations
