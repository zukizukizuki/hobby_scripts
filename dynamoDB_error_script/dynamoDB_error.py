import boto3
from botocore.exceptions import ClientError

# DynamoDBクライアントの作成
dynamodb = boto3.client('dynamodb', region_name='us-east-1')

# 存在しないテーブルへのクエリ実行
try:
    response = dynamodb.get_item(
        TableName='non_existent_table',
        Key={'id': {'S': 'test'}}
    )
except ClientError as e:
    print(f"Error: {e.response['Error']['Message']}")
