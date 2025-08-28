#!/bin/bash

# ====== CONFIGURATION ======
FIREBASE_URL="https://test-ca5a5-default-rtdb.asia-southeast1.firebasedatabase.app/systemReports.json"
OUTPUT_FILE="system_report.json"

# ====== COLLECT SYSTEM INFORMATION ======
HOSTNAME=$(hostname)
OS=$(uname -o)
KERNEL=$(uname -r)
ARCH=$(uname -m)
UPTIME=$(uptime -p)
CPU=$(lscpu | grep "Model name" | sed 's/Model name:\s*//')
CORES=$(nproc)
MEM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
MEM_USED=$(free -h | awk '/Mem:/ {print $3}')
DISK=$(df -h --total | grep total | awk '{print $2 " used:" $3 " avail:" $4}')
IP=$(hostname -I | awk '{print $1}')
USER=$(whoami)
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# ====== FORMAT AS JSON ======
cat <<EOF > $OUTPUT_FILE
{
  "hostname": "$HOSTNAME",
  "os": "$OS",
  "kernel": "$KERNEL",
  "architecture": "$ARCH",
  "uptime": "$UPTIME",
  "cpu": "$CPU",
  "cores": "$CORES",
  "memory": {
    "total": "$MEM_TOTAL",
    "used": "$MEM_USED"
  },
  "disk": "$DISK",
  "ip": "$IP",
  "user": "$USER",
  "timestamp": "$DATE"
}
EOF

# ====== SEND TO FIREBASE ======
curl -s -X POST -H "Content-Type: application/json" \
    -d @"$OUTPUT_FILE" \
    "$FIREBASE_URL"

echo "✅ System information collected and sent to Firebase."
echo "📂 Local copy saved in $OUTPUT_FILE"

