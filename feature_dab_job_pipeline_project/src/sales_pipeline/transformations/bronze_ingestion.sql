CREATE OR REFRESH STREAMING TABLE customer_bronze 
AS
SELECT *, 
       _metadata.file_path AS _file_nm, 
       current_timestamp() AS _ingest_ts
FROM cloud_files(
        'abfss://landing@strakeshdbdeveus001.dfs.core.windows.net/input/customer/',
        'csv',
        map('cloudFiles.inferColumnTypes', 'true')
     );

CREATE OR REFRESH STREAMING TABLE order_bronze 
AS
SELECT *, 
       _metadata.file_path AS _file_nm, 
       current_timestamp() AS _ingest_ts
FROM cloud_files(
        'abfss://landing@strakeshdbdeveus001.dfs.core.windows.net/input/order/',
        'csv',
        map('cloudFiles.inferColumnTypes', 'true')
     );


CREATE OR REFRESH STREAMING TABLE payment_bronze 
AS
SELECT *, 
       _metadata.file_path AS _file_nm, 
       current_timestamp() AS _ingest_ts
FROM cloud_files(
        'abfss://landing@strakeshdbdeveus001.dfs.core.windows.net/input/payment/',
        'csv',
        map('cloudFiles.inferColumnTypes', 'true')
     );