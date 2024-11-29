-- Test 5: Vérifier que les marges bénéficiaires sont calculées correctement
SELECT
    product_id,
    gross_profit,
    total_revenue,
    total_cost,
    (total_revenue - total_cost) AS calculated_gross_profit
FROM {{ ref('mart_profitability') }}
WHERE gross_profit != (total_revenue - total_cost)