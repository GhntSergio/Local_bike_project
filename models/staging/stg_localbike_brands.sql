{{ config(
    materialized='view'
) }}

WITH cleaned_brands AS (
    SELECT
        CAST(brand_id AS INTEGER) AS brand_id, -- Identifiant unique de la marque
        CAST(brand_name AS STRING) AS brand_name -- Nom de la marque
    FROM {{ source('localbike_dataset', 'brands') }}
    WHERE brand_id IS NOT NULL -- Exclure les lignes avec un identifiant null
)

SELECT * FROM cleaned_brands
