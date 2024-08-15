import boto3
import datetime

def lambda_handler(event, context):
    rds = boto3.client('rds')
    sts = boto3.client('sts')
    
    # 変数設定
    date = datetime.datetime.now().strftime("%Y-%m-%d")
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    db_instance = "dev-db-01"  # RDSインスタンス名を指定
    snapshot_name = f"daily-snapshot-{timestamp}"
    s3_bucket = "dev-db-snapshot-bucket-daily"  # エクスポート先のS3バケット名を指定
    
    # リージョンとアカウントIDの取得
    region = boto3.session.Session().region_name
    account_id = sts.get_caller_identity()["Account"]
    
    # KMSキーARNの設定
    kms_key_arn = f"arn:aws:kms:{region}:{account_id}:key/33660ecf-1dd8-4d17-a4a0-11388169c699"
    
    # 既存のスナップショットを確認
    existing_snapshots = rds.describe_db_snapshots(
        DBInstanceIdentifier=db_instance,
        SnapshotType='manual'
    )['DBSnapshots']

    # 同じ日付のスナップショットが存在する場合、削除
    for snapshot in existing_snapshots:
        if snapshot['DBSnapshotIdentifier'].startswith(f"daily-snapshot-{date}"):
            rds.delete_db_snapshot(DBSnapshotIdentifier=snapshot['DBSnapshotIdentifier'])
            print(f"Deleted existing snapshot: {snapshot['DBSnapshotIdentifier']}")

    # スナップショット作成
    try:
        rds.create_db_snapshot(
            DBInstanceIdentifier=db_instance,
            DBSnapshotIdentifier=snapshot_name
        )
        print(f"Created new snapshot: {snapshot_name}")
    except rds.exceptions.DBSnapshotAlreadyExistsFault:
        print(f"Snapshot {snapshot_name} already exists. Skipping creation.")
    
    # スナップショット完了を待機
    waiter = rds.get_waiter('db_snapshot_completed')
    waiter.wait(DBSnapshotIdentifier=snapshot_name)
    
    # S3へのエクスポート
    try:
        snapshot_arn = f"arn:aws:rds:{region}:{account_id}:snapshot:{snapshot_name}"
        rds.start_export_task(
            ExportTaskIdentifier=f"export-{snapshot_name}",
            SourceArn=snapshot_arn,
            S3BucketName=s3_bucket,
            IamRoleArn=f"arn:aws:iam::{account_id}:role/rds-s3-export-role",
            KmsKeyId=kms_key_arn
        )
        print(f"Started export task for snapshot: {snapshot_name}")
    except Exception as e:
        print(f"Error starting export task: {str(e)}")

    return {
        'statusCode': 200,
        'body': f"Snapshot {snapshot_name} processed and export started"
    }