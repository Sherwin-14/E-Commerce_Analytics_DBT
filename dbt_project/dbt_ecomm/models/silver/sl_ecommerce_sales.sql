{{ config(materialized = 'table') }}

with cleaned as (

    SELECT 
         transaction_id,
         CAST(order_date as date) as order_date,
         customer_id,
         customer_name, 
         CASE 
            WHEN country in ('US', 'UK', 'IN', 'DE', 'FR', 'CA', 'AU') then country 
            ELSE 'Unknown'
         END as country,
         product_id,
         product_category,
         CASE 
             WHEN quantity > 0 THEN quantity 
             ELSE 1
         END as quantity,
         CASE 
             WHEN price > 0 THEN price 
             ELSE 0
         END as price,
         order_status

    FROM {{ ref('br_ecommerce_sales') }}
    WHERE customer_id IS NOT NULL and CAST(order_date as date) <= current_date

)

, deduplicated as (
  
  SELECT *,
       ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY order_date DESC) as rn 
  FROM cleaned

)

select *
from deduplicated
where rn = 1