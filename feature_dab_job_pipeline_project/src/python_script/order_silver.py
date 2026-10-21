spark.sql("USE CATALOG training_dev")
spark.sql("USE SCHEMA dab_practise")

from pyspark.sql.functions import col
order_s_df = (
    spark.table("training_dev.dab_practise.order_bronze")
    .withColumnRenamed("orderid","order_id")
    .withColumnRenamed("customerid","customer_id")
    .withColumnRenamed("orderdate","order_date")
    .filter(col("order_id").isNotNull())
)


order_s_df.write.mode('overwrite').saveAsTable('training_dev.dab_practise.order_silver')