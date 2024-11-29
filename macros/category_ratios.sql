{% macro get_category_ratio(category_id) %}
    {% if category_id == 1 %}
        0.6
    {% elif category_id == 2 %}
        0.65
    {% elif category_id == 3 %}
        0.7
    {% elif category_id == 4 %}
        0.75
    {% elif category_id == 5 %}
        0.8
    {% elif category_id == 6 %}
        0.7
    {% elif category_id == 7 %}
        0.75
    {% else %}
        0.7 -- Ratio par défaut
    {% endif %}
{% endmacro %}
