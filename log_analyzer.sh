#!/bin/bash

# Check if log file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 NginxLog.log"
    echo "Example: $0 NginxLog.log"
    exit 1
fi

LOG_FILE="$1"

# Check if file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found!"
    exit 1
fi

echo "=== NGINX ACCESS LOG ANALYSIS ==="
echo

# Top 5 IP addresses with the most requests
echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
while read count ip; do
    echo "$ip - $count requests"
done
echo

# Top 5 most requested paths
echo "Top 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
while read count path; do
    echo "$path - $count requests"
done
echo

# Top 5 response status codes
echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
while read count code; do
    echo "$code - $count requests"
done
echo

# Top 5 user agents
echo "Top 5 user agents:"
# User agent is everything after the last double quote
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | \
while read count ua; do
    echo "$ua - $count requests"
done
echo