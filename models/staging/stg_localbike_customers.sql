{{ config(
    materialized='view'
) }}

WITH cleaned_customers AS (
    SELECT
        CAST(customer_id AS INTEGER) AS customer_id, -- Identifiant unique du client
        CAST(first_name AS STRING) AS first_name, -- Prénom du client
        CAST(last_name AS STRING) AS last_name, -- Nom du client
        CAST(phone AS STRING) AS phone, -- Numéro de téléphone du client
        CAST(email AS STRING) AS email, -- Adresse e-mail du client
        CAST(street AS STRING) AS street, -- Rue de l'adresse du client
        CAST(city AS STRING) AS city, -- Ville de résidence du client
        CAST(state AS STRING) AS state, -- État de résidence du client
        CAST(zip_code AS INTEGER) AS zip_code -- Code postal
    FROM {{ source('localbike_dataset', 'customers') }}
    -- WHERE customer_id IS NOT NULL -- Exclure les clients sans identifiant
)

SELECT * FROM cleaned_customers
