-- Test 6: Vérifier que le pourcentage de marge bénéficiaire est valide (entre 0 et 100)
SELECT
    product_id,
    gross_margin_percentage
FROM {{ ref('mart_profitability') }}
WHERE gross_margin_percentage IS NULL OR gross_margin_percentage < 0 OR gross_margin_percentage > 100
