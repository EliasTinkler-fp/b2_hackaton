{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- set ci_schema = env_var('DBT_CI_SCHEMA', '') -%}
    {%- if ci_schema | length > 0 -%}
        {{ ci_schema | trim }}
    {%- elif custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
