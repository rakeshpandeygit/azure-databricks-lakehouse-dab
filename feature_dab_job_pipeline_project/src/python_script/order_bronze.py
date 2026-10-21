spark.sql("USE CATALOG training_dev")
spark.sql("CREATE SCHEMA IF NOT EXISTS dab_practise")
spark.sql("USE SCHEMA dab_practise")

from pyspark.sql.functions import *

order_df = (
    spark.read.format("csv")
    .option('header','true')
    .option('inferSchema','true')
    .load('abfss://landing@strakeshdbdeveus001.dfs.core.windows.net/input/order/orders1_week20.txt')
    .withColumn('file_nm', lit('orders1_week20.txt'))
    .withColumn('ingest_dt', current_date())
)

order_df.write.mode('overwrite').option('mergeSchema', 'true').saveAsTable('training_dev.dab_practise.order_bronze')