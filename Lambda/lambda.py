import boto3
import io
from PIL import Image

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')
sns_topic_arn = 'resizer-updates-topic'

def lambda_handler(event, context):

    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']


    response = s3_client.get_object(Bucket=source_bucket, Key=source_key)
    image_content = response['Body'].read()


    image = Image.open(io.BytesIO(image_content))
    resized_image = image.resize((100, 100))
    resized_image_bytes = io.BytesIO()
    resized_image.save(resized_image_bytes, format=image.format)
    resized_image_bytes.seek(0)


    target_bucket = 'mvgpbucket2-specificname24'
    target_key = 'resized/' + source_key
    s3_client.put_object(Bucket=target_bucket, Key=target_key, Body=resized_image_bytes)
    print("Sucessfully rescalated and uploaded")

    sns_message = f"Successfully upload to S3: {source_key}"
    sns_client.publish(TopicArn=sns_topic_arn, Message=sns_message)

    return {
        'statusCode': 200,
        'body': 'Done'
    }