#!/bin/bash

set -e  # Exit immediately if any command fails

echo "🚀 [1] Starting HDFS Docker containers (with sudo)..."
cd ~/docker-hadoop/
sudo docker compose up -d

echo "⏳ [2] Waiting 10 seconds for HDFS to initialize..."
sleep 10

cd ~/Stock-Market-Trend/Data_Ingestion/

# Find the latest CSV file in the output folder
LATEST_FILE=$(ls -t output/*.csv | head -n 1)

if [ ! -f "$LATEST_FILE" ]; then
  echo "❌ No CSV file found in output/"
  exit 1
fi

FILENAME=$(basename "$LATEST_FILE")

echo "📤 [3] Copying $FILENAME into namenode Docker container..."
sudo docker cp "$LATEST_FILE" namenode:/tmp/"$FILENAME"

echo "📂 [4] Uploading $FILENAME into HDFS (/stock_data)..."
sudo docker exec namenode hdfs dfs -mkdir -p /stock_data/
sudo docker exec namenode hdfs dfs -put -f "/tmp/$FILENAME" /stock_data/

echo "✅ Upload complete! File is now in HDFS: /stock_data/$FILENAME"
