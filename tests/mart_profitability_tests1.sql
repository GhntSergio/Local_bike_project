-- Test 1: Vérifier que chaque produit a un identifiant unique
SELECT
    product_id,
    COUNT(*) AS occurrences
FROM {{ ref('mart_profitability') }}
GROUP BY product_id
HAVING COUNT(*) > 1