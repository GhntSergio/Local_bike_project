-- Test 3: Vérifier que les quantités totales vendues sont valides (non nulles et non négatives)
SELECT
    product_id,
    total_quantity_sold
FROM {{ ref('mart_profitability') }}
WHERE total_quantity_sold IS NULL OR total_quantity_sold < 0