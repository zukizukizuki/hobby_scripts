import boto3
from botocore.exceptions import ClientError

# Initialize a session using Amazon DynamoDB
session = boto3.Session()
dynamodb = session.resource('dynamodb')

# Function to create a DynamoDB table
def create_table(table_name, partition_key, sort_key=None):
    try:
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {'AttributeName': partition_key, 'KeyType': 'HASH'},
                {'AttributeName': sort_key, 'KeyType': 'RANGE'} if sort_key else None,
            ],
            AttributeDefinitions=[
                {'AttributeName': partition_key, 'AttributeType': 'S'},
                {'AttributeName': sort_key, 'AttributeType': 'S'} if sort_key else None,
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5,
            }
        )
        table.meta.client.get_waiter('table_exists').wait(TableName=table_name)
        return f"Table {table_name} created successfully."
    except ClientError as e:
        return f"Failed to create table: {e}"

# Function to insert data into a DynamoDB table
def insert_data(table_name, item):
    table = dynamodb.Table(table_name)
    try:
        table.put_item(Item=item)
        return "Data inserted successfully."
    except ClientError as e:
        return f"Failed to insert data: {e}"

# Function to retrieve data from a DynamoDB table
def get_data(table_name, key):
    table = dynamodb.Table(table_name)
    try:
        response = table.get_item(Key=key)
        return response['Item'] if 'Item' in response else "No data found."
    except ClientError as e:
        return f"Failed to get data: {e}"

# Sample usage
if __name__ == "__main__":
    table_name = 'Users'
    partition_key = 'UserID'
    sort_key = 'Timestamp'

    # Create DynamoDB table
    print(create_table(table_name, partition_key, sort_key))

    # Insert data into the table
    user_data = {
        'UserID': '12345',
        'Timestamp': '2024-08-19',
        'Name': 'John Doe',
        'Age': 30,
    }
    print(insert_data(table_name, user_data))

    # Retrieve data from the table
    key = {'UserID': '12345', 'Timestamp': '2024-08-19'}
    print(get_data(table_name, key))
