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
spark.sql(f"CREATE SCHEMA IF NOT EXISTS {env}_dab_practise")
spark.sql(f"USE SCHEMA {env}_dab_practise")

from pyspark.sql.functions import *

order_df = (
    spark.read.format("csv")
    .option('header','true')
    .option('inferSchema','true')
    .load('abfss://landing@strakeshdbdeveus001.dfs.core.windows.net/input/order/orders1_week20.txt')
    .withColumn('file_nm', lit('orders1_week20.txt'))
    .withColumn('ingest_dt', current_date())
)

order_df.write.mode('overwrite').option('mergeSchema', 'true').saveAsTable('order_bronze')