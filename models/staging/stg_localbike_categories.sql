{{ config(
    materialized='view'
) }}

WITH cleaned_categories AS (
    SELECT
        CAST(category_id AS INTEGER) AS category_id, -- Identifiant unique de la catégorie
        CAST(category_name AS STRING) AS category_name, -- Nom de la catégorie
         {{ get_category_ratio(category_id) }} AS cost_ratio -- Ratio de coût basé sur la catégorie
    FROM {{ source('localbike_dataset', 'categories') }}
    WHERE category_id IS NOT NULL -- Exclure les lignes avec un identifiant null
)

SELECT * FROM cleaned_categories

