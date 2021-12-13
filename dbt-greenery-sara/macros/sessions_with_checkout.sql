{% macro sessions_with_checkout() %}
WITH sessions_with_checkout AS (
    SELECT 
        session_id,
        MAX(CASE WHEN event_type='checkout' THEN 1 ELSE 0 END) has_checkout
    FROM {{ref('stg_events')}}
    GROUP BY session_id
)
{% endmacro %}



