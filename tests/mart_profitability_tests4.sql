-- Test 4: Vérifier que la contribution au revenu total (en pourcentage) est valide
SELECT
    product_id,
    revenue_percentage
FROM {{ ref('mart_profitability') }}
WHERE revenue_percentage IS NULL OR revenue_percentage < 0 OR revenue_percentage > 100
