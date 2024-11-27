{{ config(
    materialized='view'
) }}

WITH cleaned_products AS (
    SELECT
        CAST(product_id AS INTEGER) AS product_id, -- Identifiant unique du produit
        CAST(product_name AS STRING) AS product_name, -- Nom du produit
        CAST(brand_id AS INTEGER) AS brand_id, -- Identifiant de la marque associée
        CAST(category_id AS INTEGER) AS category_id, -- Identifiant de la catégorie du produit
        CAST(model_year AS INTEGER) AS model_year, -- Année du modèle
        CAST(list_price AS FLOAT64) AS list_price -- Prix unitaire du produit
    FROM {{ source('localbike_dataset', 'products') }}
    WHERE product_id IS NOT NULL -- Exclure les lignes sans identifiant de produit
)

SELECT * FROM cleaned_products
