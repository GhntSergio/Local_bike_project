{{ config(
    materialized='view'
) }}

WITH customer_data AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        c.state,
        c.zip_code,
        -- Exemple de segmentation démographique (ajouter un champ sexe ou autres si disponible)
        CASE
            WHEN c.state IN ('CA', 'TX', 'NY') THEN 'Major State' -- Exemples d'États principaux
            ELSE 'Other State'
        END AS state_category
        
    FROM {{ ref('stg_localbike_customers') }} c
)

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    state,
    zip_code,
    state_category
FROM customer_data
ORDER BY customer_id
