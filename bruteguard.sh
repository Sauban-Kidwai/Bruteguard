#!/bin/bash

# === BruteGuard: SSH Brute Force Detection Script ===
# Detects failed SSH login attempts from /var/log/auth.log
# Sends alert to local user and a temporary email address

# === CONFIGURATION ===
LOG_FILE="/var/log/auth.log"
ALERT_LOG="/tmp/brute_alerts.log"
THRESHOLD=5                         # Number of failed attempts before alert triggers
LOCAL_USER="USER"                   # Change this if your Linux username is different
TEMP_EMAIL="REPLACE@REPLACE.COM"    # Replace with any temp email
TODAY=$(date '+%b %e')              # Matches today's date format in auth.log (e.g., "Jun 18")

# === STEP 1: Extract Failed SSH Logins for Today ===
grep "$TODAY" "$LOG_FILE" | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr > "$ALERT_LOG"

# === STEP 2: Parse Each Offending IP and Send Alert If Threshold Exceeded ===
while read -r line; do
    COUNT=$(echo "$line" | awk '{print $1}')
    IP=$(echo "$line" | awk '{print $2}')

    if [ "$COUNT" -ge "$THRESHOLD" ]; then
        SUBJECT="Brute Force Alert on $(hostname)"
        BODY="Detected $COUNT failed SSH login attempts from IP: $IP on $(date)"

        # Send alert to local user
        echo "$BODY" | mail -s "$SUBJECT" "$LOCAL_USER"

        # Send alert to temporary email
        echo "$BODY" | mail -s "$SUBJECT" "$TEMP_EMAIL"

        echo "[+] Alert sent for IP $IP with $COUNT attempts."
    fi
done < "$ALERT_LOG"