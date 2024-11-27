{{ config(
    materialized='view'
) }}

WITH cleaned_staffs AS (
    SELECT
        CAST(staff_id AS INTEGER) AS staff_id, -- Identifiant unique du membre du personnel
        CAST(first_name AS STRING) AS first_name, -- Prénom du membre du personnel
        CAST(last_name AS STRING) AS last_name, -- Nom du membre du personnel
        CAST(email AS STRING) AS email, -- Adresse e-mail professionnelle
        CAST(phone AS STRING) AS phone, -- Numéro de téléphone professionnel
        CAST(active AS INTEGER) AS active, -- Statut actif (1 pour actif, 0 pour inactif)
        CAST(store_id AS INTEGER) AS store_id, -- Identifiant du magasin associé au membre du personnel
        CAST(manager_id AS INTEGER) AS manager_id -- Identifiant du manager direct (facultatif)
    FROM {{ source('localbike_dataset', 'staffs') }}
    WHERE staff_id IS NOT NULL -- Exclure les lignes sans identifiant du personnel
)

SELECT * FROM cleaned_staffs
