{{ config(
    materialized='view'
) }}

WITH cleaned_orders AS (
    SELECT
        CAST(order_id AS INTEGER) AS order_id, -- Identifiant unique de la commande
        CAST(customer_id AS INTEGER) AS customer_id, -- Identifiant unique du client
        CAST(order_status AS INTEGER) AS order_status, -- Statut de la commande
        -- Gestion des NULL pour les colonnes de type date
        SAFE_CAST(order_date AS DATE) AS order_date, -- Date de création de la commande
        SAFE_CAST(required_date AS DATE) AS required_date, -- Date requise pour la livraison
        SAFE_CAST(shipped_date AS DATE) AS shipped_date, -- Date d'expédition
        CAST(store_id AS INTEGER) AS store_id, -- Identifiant du magasin associé à la commande
        CAST(staff_id AS INTEGER) AS staff_id -- Identifiant de l'employé ayant traité la commande
    FROM {{ source('localbike_dataset', 'orders') }}
   -- WHERE order_id IS NOT NULL -- Exclure les lignes sans identifiant de commande
)

SELECT * FROM cleaned_orders
