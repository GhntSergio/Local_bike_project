{{ config(
    materialized='view'
) }}

WITH cleaned_stores AS (
    SELECT
        CAST(store_id AS INTEGER) AS store_id, -- Identifiant unique du magasin
        CAST(store_name AS STRING) AS store_name, -- Nom du magasin
        CAST(phone AS STRING) AS phone, -- Numéro de téléphone du magasin
        CAST(email AS STRING) AS email, -- Adresse e-mail du magasin
        CAST(street AS STRING) AS street, -- Rue où se situe le magasin
        CAST(city AS STRING) AS city, -- Ville où se situe le magasin
        CAST(state AS STRING) AS state, -- État où se situe le magasin
        CAST(zip_code AS INTEGER) AS zip_code -- Code postal du magasin
    FROM {{ source('localbike_dataset', 'stores') }}
    WHERE store_id IS NOT NULL -- Exclure les lignes sans identifiant du magasin
)

SELECT * FROM cleaned_stores
