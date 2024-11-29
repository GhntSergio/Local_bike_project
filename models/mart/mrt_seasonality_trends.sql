{{ config(
    materialized='table'
) }}

SELECT *
FROM {{ ref('int_sales_seasonality') }} -- Modèle intermediate pour saisonnalité et tendances
ORDER BY sales_month
