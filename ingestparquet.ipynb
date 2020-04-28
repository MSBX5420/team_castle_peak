from pyspark.sql  import SparkSession
spark = SparkSession.builder.getOrCreate()
sc = spark.sparkContext

data = spark.read.format('csv').options(header='true', inferSchema='true').load('s3://aws-emr-resources-788046738101-us-east-1/notebooks/e-228XWP1M3H3CJH36K2HJ87DMN/news_cleaned.csv')

data.show()
data.printSchema()

result_path = 's3://aws-emr-resources-788046738101-us-east-1/notebooks/e-228XWP1M3H3CJH36K2HJ87DMN/news.parquet'

data.write.parquet(result_path)

parqDF = spark.read.parquet(result_path)

parqDF

parqDF.show()
parqDF.printSchema()
