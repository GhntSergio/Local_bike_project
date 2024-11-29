{{ config(
    materialized='view'
) }}

WITH purchase_data AS (
    SELECT
        o1.customer_id,
        COUNT(o1.order_id) AS total_purchases, -- Nombre total de commandes
        MIN(o1.order_date) AS first_purchase_date, -- Date de la première commande
        MAX(o1.order_date) AS last_purchase_date, -- Date de la dernière commande
        COUNT(DISTINCT DATE(o1.order_date)) AS distinct_purchase_days -- Jours uniques avec une commande
    FROM {{ ref('stg_localbike_orders') }} o1
    WHERE o1.order_status = 4 -- Considérer uniquement les commandes expédiées
    GROUP BY o1.customer_id
),

date_differences AS (
    SELECT
        o1.customer_id,
        DATE_DIFF(o1.order_date, o2.order_date, DAY) AS days_between_purchases -- Différence entre deux commandes successives
    FROM {{ ref('stg_localbike_orders') }} o1
    LEFT JOIN {{ ref('stg_localbike_orders') }} o2
      ON o1.customer_id = o2.customer_id
     AND o1.order_date > o2.order_date -- Associer chaque commande à la commande immédiatement précédente
    WHERE o1.order_status = 4 AND o2.order_status = 4 -- Commandes expédiées uniquement
),

avg_days_calc AS (
    SELECT
        d.customer_id,
        AVG(d.days_between_purchases) AS avg_days_between_purchases -- Moyenne des intervalles
    FROM date_differences d
    WHERE d.days_between_purchases IS NOT NULL -- Ignorer les valeurs NULL résultant de la première commande
    GROUP BY d.customer_id
)

SELECT
    p.customer_id,
    p.total_purchases,
    p.first_purchase_date,
    p.last_purchase_date,
    p.distinct_purchase_days,
    COALESCE(ROUND(a.avg_days_between_purchases, 2), 0) AS avg_days_between_purchases -- Remplacer NULL par 0 pour les clients avec une seule commande
FROM purchase_data p
LEFT JOIN avg_days_calc a
  ON p.customer_id = a.customer_id
ORDER BY p.total_purchases DESC
