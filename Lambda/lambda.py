import boto3
import os
from PIL import Image

# S3 and SNS client
s3_client = boto3.client('s3')
sns_client = boto3.client('sns')

def lambda_handler(event, context):
    print("Hola mundo")
    return True