{{ config(
    materialized='view'
) }}

WITH cleaned_stocks AS (
    SELECT
        CAST(store_id AS INTEGER) AS store_id, -- Identifiant unique du magasin
        CAST(product_id AS INTEGER) AS product_id, -- Identifiant unique du produit
        CAST(quantity AS INTEGER) AS quantity -- Quantité disponible en stock
    FROM {{ source('localbike_dataset', 'stocks') }}
    WHERE store_id IS NOT NULL 
      AND product_id IS NOT NULL -- Exclure les lignes sans identifiant de magasin ou de produit
)

SELECT * FROM cleaned_stocks
