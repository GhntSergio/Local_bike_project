{{ config(
    materialized='view'
) }}

WITH cleaned_order_items AS (
    SELECT
        CAST(order_id AS INTEGER) AS order_id, -- Identifiant unique de la commande
        CAST(item_id AS INTEGER) AS item_id, -- Identifiant unique de l'article dans la commande
        CAST(product_id AS INTEGER) AS product_id, -- Identifiant du produit commandé
        CAST(quantity AS INTEGER) AS quantity, -- Quantité commandée pour ce produit
        CAST(list_price AS FLOAT64) AS list_price, -- Prix unitaire du produit
        CAST(discount AS FLOAT64) AS discount -- Réduction appliquée sur l'article
    FROM {{ source('localbike_dataset', 'order_item') }}
    WHERE order_id IS NOT NULL -- Exclure les lignes sans identifiant de commande
)

SELECT * FROM cleaned_order_items
