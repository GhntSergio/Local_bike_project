-- Test 2: Vérifier que les revenus totaux ne sont pas null ou négatifs
SELECT
    product_id,
    total_revenue
FROM {{ ref('mart_profitability') }}
WHERE total_revenue IS NULL OR total_revenue < 0