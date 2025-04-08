import boto3
import pandas as pd
import csv



client = boto3.Session(region_name='il-central-1')
client = client.client('s3')


# print('Get type')
#  = client.head_object(Bucket='dwh-bucket-file-storage-gateway',Key='מבנה נתונים למילוי עבור דוח הידרולוגי.xlsx')
# print(Type['ContentType'])
print('Get list object')
list = client.list_objects(Bucket='dwh-bucket-file-storage-gateway')

for file_name in list['Contents']:
    Type = client.head_object(Bucket='dwh-bucket-file-storage-gateway',Key=file_name['Key'] )
    # print('file name: {} Type: {}'.format(file_name['Key'], Type['ContentType'] ))
    if Type['ContentType'] not in ['text/csv','application/x-directory; charset=UTF-8']:
        read_file = pd.read_excel(file_name['Key'])
        read_file.to_csv (f"{file_name['Key'].split('.')[0]}.csv",  
                  index = None, 
                  header=True)
        client.head_object(Bucket='dwh-bucket-file-storage-gateway',Key=f"{file_name['Key'].split('.')[0]}.csv")
        # df = pd.DataFrame(pd.read_csv(f"{file_name['Key'].split('.')[0]}.csv")) 


    

    # print(Type['ContentType'])
    # if Type['ContentType'] != 'csv':
    #     print(file_name)


# s3 = boto3.resource('s3')
# my_bucket = s3.Bucket('my_bucket')

# lst = []
# for s3obj in my_bucket.objects.filter(Prefix="converted/"):
    
#     # skip s3 objects not ending with csv
#     if (not s3obj.key.endswith('csv')): continue
        
#     print(s3obj.key)
#     bdy = s3obj.get()['Body'].read().decode('utf-8')
#     lst.append(bdy)
#     bdy = ''
    
# #print(lst)

# for file_str in lst:
#     for line in file_str.split('\n'):
#         print(line)



# import sys
# from awsglue.transforms import *
# from awsglue.utils import getResolvedOptions
# from pyspark.sql import SparkSession
# from awsglue.context import GlueContext
# from awsglue.job import Job

# args = getResolvedOptions(sys.argv, ['JOB_NAME', 'SOURCE_BUCKET', 'SOURCE_KEY', 'TARGET_BUCKET'])

# spark = SparkSession.builder.appName("S3ToParquet").getOrCreate()
# glueContext = GlueContext(spark.sparkContext)
# job = Job(glueContext)
# job.init(args['JOB_NAME'], args)

# source_path = f"s3://{args['SOURCE_BUCKET']}/{args['SOURCE_KEY']}"
# df = spark.read.format("csv").option("header", "true").load(source_path)

# # Convert to Parquet
# target_path = f"s3://{args['TARGET_BUCKET']}/converted/"
# df.write.mode("overwrite").parquet(target_path)

# job.commit()


# import sys
# from awsglue.transforms import *
# from awsglue.utils import getResolvedOptions
# from pyspark.context import SparkContext
# from awsglue.context import GlueContext
# from awsglue.job import Job
# from awsglue import DynamicFrame

# args = getResolvedOptions(sys.argv, ['JOB_NAME'])
# sc = SparkContext()
# glueContext = GlueContext(sc)
# spark = glueContext.spark_session
# job = Job(glueContext)
# job.init(args['JOB_NAME'], args)

# # Script generated for node AWS Glue Data Catalog
# AWSGlueDataCatalog_node1743063653799 = glueContext.create_dynamic_frame.from_catalog(database="s3-storage-gateway", table_name="______________________________________csv", transformation_ctx="AWSGlueDataCatalog_node1743063653799")

# # Script generated for node Amazon Redshift
# AmazonRedshift_node1743063702248 = glueContext.write_dynamic_frame.from_options(frame=AWSGlueDataCatalog_node1743063653799, connection_type="redshift", connection_options={"redshiftTmpDir": "s3://aws-glue-assets-820242910552-il-central-1/temporary/", "useConnectionProperties": "true", "dbtable": "public.new-excel", "connectionName": "dwh-redshift-cluster-connection", "preactions": "CREATE TABLE IF NOT EXISTS public.new-excel (col0 VARCHAR, col1 VARCHAR, col2 VARCHAR, col3 VARCHAR, col4 VARCHAR, col5 VARCHAR, col6 VARCHAR, col7 VARCHAR, col8 VARCHAR);"}, transformation_ctx="AmazonRedshift_node1743063702248")

# job.commit()