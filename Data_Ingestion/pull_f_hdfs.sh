#!/bin/bash

set -e

echo "🔄 [1] Pulling latest file from HDFS to local..."

# Get list of files in HDFS /stock_data directory
HDFS_FILE=$(sudo docker exec namenode hdfs dfs -ls /stock_data/ | tail -n 1 | awk '{print $8}')

if [ -z "$HDFS_FILE" ]; then
  echo "❌ No files found in HDFS /stock_data/"
  exit 1
fi

FILENAME=$(basename "$HDFS_FILE")
NEW_FILENAME="${FILENAME%.csv}_ready.csv"

# Pull file from HDFS to container's /tmp
sudo docker exec namenode hdfs dfs -get "$HDFS_FILE" /tmp/"$NEW_FILENAME"

# Copy file from container to local
sudo docker cp namenode:/tmp/"$NEW_FILENAME" ./prepared_for_s3/"$NEW_FILENAME"

echo "✅ File copied to prepared_for_s3/$NEW_FILENAME"
