{% snapshot stg_promos_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='promo_id',

      strategy='check',
      check_cols=['status']
    )
  }}

  SELECT * 
  FROM {{ source('tutorial', 'promos') }}

{% endsnapshot %}