{{ config(
    materialized='table'
) }}

WITH customer_recency AS (
    SELECT *
    FROM {{ ref('int_customer_purchase_behavior') }} -- Modèle intermediate pour fréquence et récurrence
),

customer_categorization AS (
    SELECT *
    FROM {{ ref('int_customer_segmentation_by_location') }} -- Modèle intermediate pour segmentation
),

customer_location_behavior AS (
    SELECT *
    FROM {{ ref('int_customer_purchase_by_location') }} -- Modèle intermediate pour comportement par localisation
)

SELECT
    cr.customer_id,
    cr.total_purchases,
    cr.avg_days_between_purchases,
    cc.city,
    cc.state,
    cl.total_orders,
    cl.total_revenue,
    cl.avg_order_value
FROM customer_recency cr
LEFT JOIN customer_categorization cc
    ON cr.customer_id = cc.customer_id
LEFT JOIN customer_location_behavior cl
    ON cr.customer_id = cl.customer_id
