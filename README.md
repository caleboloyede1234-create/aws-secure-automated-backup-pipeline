# AWS Secure Automated Backup & Audit Pipeline

An automated, private cloud backup and event-driven auditing architecture built on AWS.

## Architecture Overview
- **Network Isolation (VPC):** Custom VPC (10.0.0.0/16) split into a public subnet (10.0.1.0/24) hosting a Bastion Host (10.0.1.72) and a private subnet (10.0.2.0/24) hosting the App Server (10.0.2.177).
- **Private S3 Connectivity & Cost Optimization:** Uses an S3 VPC Gateway Endpoint (pce-...) so the private App Server uploads backups directly to S3 over the AWS backbone without a NAT Gateway.
- **Least-Privilege Security (IAM):**
  - **EC2 Instance Profile:** Scoped strictly to s3:PutObject on rn:aws:s3:::caleb-backup-project-2026/backups/*.
  - **Lambda Execution Role:** Scoped strictly to dynamodb:PutItem on rn:aws:dynamodb:us-east-1:<ACCOUNT-ID>:table/backup-log plus CloudWatch logging.
  - **S3 Bucket Security:** Block all public access enabled.
- **Automated Backups & Event-Driven Logging:**
  - data-generator.service (systemd) continuously generates application log data on 10.0.2.177.
  - A root cron job (*/10 * * * * /usr/local/bin/backup.sh) compresses logs into .tar.gz archives and uploads them to s3://caleb-backup-project-2026/backups/.
  - S3 ObjectCreated:Put events trigger the Python AWS Lambda function (ackup-logger), which writes backup metadata (ackup_id, ucket, key, size, 	imestamp) into the DynamoDB ackup-log table.

## Deliverables & Verification (/screenshots)
- **Part 4 Security:** part4-ec2-s3-put-policy.png, part4-s3-block-public-access.png
- **Deliverable (h)  Automated Backups:** h1-data-generator-service.png, h2-crontab-and-backup-log.png, h3-backup-log.png, h4-s3-backup-objects.png
- **Deliverable (i)  DynamoDB Audit Table:** i-dynamodb-backup-log.png
- **Deliverable (j)  Lambda Trigger, IAM & Logs:** j1-lambda-s3-trigger.png, j2-lambda-iam-cloudwatch-policy.png, j3-lambda-iam-dynamodb-policy.png, j4-cloudwatch-lambda-logs.png
- **Deliverable (k)  VPC Endpoint Verification:** k-vpc-endpoint-verification.png (confirms outbound internet curl times out after NAT Gateway removal while S3 backup uploads succeed privately)
