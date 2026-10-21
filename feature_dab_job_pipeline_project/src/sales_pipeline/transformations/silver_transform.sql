-- stg : column rename, add expectations

CREATE STREAMING TABLE customer_silver_stg 
(CONSTRAINT null_cust EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW)
AS
SELECT customer_id,customer_name,email,city,created_date,_file_nm,current_timestamp() AS _ingest_ts, _ingest_ts as _src_ingest_ts
FROM stream(customer_bronze);

CREATE STREAMING TABLE order_silver_stg 
(
    CONSTRAINT null_cust EXPECT (customer_id IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT null_order EXPECT (order_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT orderid as order_id,customerid as customer_id,orderdate as order_date,order_amount,order_status,_file_nm,current_timestamp() AS _ingest_ts, _ingest_ts as _src_ingest_ts
FROM stream(order_bronze);


CREATE STREAMING TABLE payment_silver_stg 
(
    CONSTRAINT null_order EXPECT (order_id IS NOT NULL),
    CONSTRAINT valid_payment_status EXPECT (payment_status IN ('SUCCESS','FAILED','PENDING')) ON VIOLATION DROP ROW,
    CONSTRAINT null_payment EXPECT (payment_id IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT payment_id,order_id,payment_date,payment_mode,payment_status,_file_nm,current_timestamp() AS _ingest_ts, _ingest_ts as _src_ingest_ts
FROM stream(payment_bronze);


-- silver: dedup, scd/merge


CREATE STREAMING TABLE customer_silver;

CREATE FLOW customer_silver_flow AS AUTO CDC
INTO customer_silver
FROM stream(customer_silver_stg)
KEYS (customer_id)
SEQUENCE BY (_src_ingest_ts)
STORED AS SCD TYPE 2
;



CREATE STREAMING TABLE order_silver;

CREATE FLOW order_silver_flow AS AUTO CDC
INTO order_silver
FROM stream(order_silver_stg)
KEYS (order_id)
SEQUENCE BY (_src_ingest_ts)
;


CREATE STREAMING TABLE payment_silver;

CREATE FLOW payment_silver_flow AS AUTO CDC
INTO payment_silver
FROM stream(payment_silver_stg)
KEYS (payment_id)
SEQUENCE BY (_src_ingest_ts)
;