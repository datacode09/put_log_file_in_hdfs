#!/bin/bash

# Configuration
hdfs_namenode="<HDFS-NAMENODE>"
hdfs_port="<PORT>"
hdfs_user="<HDFS-USER>"
hdfs_dir="/path/to/target/directory"

local_logfile="/path/to/local/logfile.log"

# Check if the local log file exists
if [ ! -f "$local_logfile" ]; then
    echo "Log file not found."
    exit 1
fi

# Generate timestamp
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Append timestamp to the log file name
hdfs_logfile_name="logfile_$timestamp.log"

# Check if the target directory exists in HDFS, create if not
hdfs dfs -test -e "$hdfs_dir"
if [ $? -ne 0 ]; then
    hdfs dfs -mkdir -p "$hdfs_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to create target directory in HDFS."
        exit 1
    fi
fi

# Upload the local log file to HDFS with timestamp-appended name
hdfs_logfile_path="$hdfs_dir/$hdfs_logfile_name"
hdfs dfs -put "$local_logfile" "$hdfs_logfile_path"

echo "Log file uploaded to HDFS successfully."
