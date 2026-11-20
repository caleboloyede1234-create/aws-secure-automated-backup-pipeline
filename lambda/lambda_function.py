import json
import urllib.parse
import boto3
from datetime import datetime, timezone

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('backup-log')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'])
        size = record['s3']['object'].get('size', 0)
        timestamp = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S.%f')[:-3] + 'Z'

        table.put_item(
            Item={
                'backup_id': key,
                'bucket': bucket,
                'key': key,
                'size': size,
                'timestamp': timestamp
            }
        )

    return {'statusCode': 200, 'body': json.dumps('Backup logged successfully')}
