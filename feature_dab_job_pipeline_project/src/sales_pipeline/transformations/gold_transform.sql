-- customer granular data - customer id per order per payment

CREATE MATERIALIZED VIEW customer_order_payment_gold AS
SELECT
  c.customer_id,  c.customer_name,
  o.order_id,  o.order_amount, o.order_date,o.order_status,
  p.payment_id,p.payment_date,p.payment_status,p.payment_mode,
  current_date() AS _ingest_dt
FROM 
    customer_silver c
    JOIN order_silver o   ON c.customer_id = o.customer_id
    JOIN payment_silver p ON o.order_id = p.order_id
;


CREATE MATERIALIZED VIEW customer_snapshot 
AS
SELECT 
current_date() AS _snapshot_date, customer_id,customer_name,count(distinct order_id) as total_orders, sum(order_amount) as total_order_amount
FROM customer_order_payment_gold
where order_status = 'COMPLETED' and payment_status = 'SUCCESS' and to_date(_ingest_dt) = current_date()
GROUP BY _snapshot_date,customer_id,customer_name
;