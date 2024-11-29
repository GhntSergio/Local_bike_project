{{ config(
    materialized='view'
) }}

WITH location_segmentation AS (
    SELECT
        c.customer_id,
        c.city,
        c.state,
        c.zip_code,
        COUNT(c.customer_id) AS total_customers -- Nombre total de clients dans chaque zone
    FROM {{ ref('stg_localbike_customers') }} c
    WHERE c.city IS NOT NULL -- Exclure les clients sans ville
      AND c.state IS NOT NULL -- Exclure les clients sans état
    GROUP BY c.customer_id, c.city, c.state, c.zip_code
)

SELECT
    customer_id,
    city,
    state,
    zip_code,
    total_customers
FROM location_segmentation
ORDER BY total_customers DESC -- Trier par concentration de clients
