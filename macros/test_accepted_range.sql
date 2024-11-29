{% macro test_accepted_range(model, column_name, min_value, max_value=None) %}
SELECT
    COUNT(*) AS failures
FROM {{ model }}
WHERE
    {{ column_name }} < {{ min_value }}
    {% if max_value is not none %}
    OR {{ column_name }} > {{ max_value }}
    {% endif %}
{% endmacro %}
