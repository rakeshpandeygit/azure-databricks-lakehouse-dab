import argparse

# Job (spark_python_task) passes --environment as a CLI arg; interactive runs use the widget
parser = argparse.ArgumentParser()
parser.add_argument("--environment", default=None)
args, _ = parser.parse_known_args()

if args.environment:
    env = args.environment
else:
    dbutils.widgets.text("environment", "dev")
    env = dbutils.widgets.get("environment")
print(f"environment = {env}")


spark.sql("USE CATALOG training_dev")
spark.sql(f"USE SCHEMA {env}_dab_practise")

from pyspark.sql.functions import col
order_s_df = (
    spark.table(f"training_dev.{env}_dab_practise.order_bronze")
    .withColumnRenamed("orderid","order_id")
    .withColumnRenamed("customerid","customer_id")
    .withColumnRenamed("orderdate","order_date")
    .filter(col("order_id").isNotNull())
)


order_s_df.write.mode('overwrite').saveAsTable(f'training_dev.{env}_dab_practise.order_silver')