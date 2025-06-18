# 🛡️ BruteGuard – An SSH Brute Force Detection Script

BruteGuard is a lightweight, cron-powered shell script that parses your system’s `/var/log/auth.log` to detect SSH brute force attacks. When it spots a suspicious IP address exceeding a defined threshold of failed login attempts, it sends an alert to both your **local Linux user mailbox** and a **temporary email address**.

## 📋 Features

- Detects repeated failed SSH login attempts in real time
- Parses `/var/log/auth.log` using Bash (no Python dependencies)
- Sends alerts using `mail` (to both local and external email)
- Configurable attempt threshold and email targets
- Runs automatically every 5 minutes using `cron`
- Simple, secure, and fully reproducible


## 🛠️ How to Install and Use

### 1. Clone or Download the Script

```bash
wget https://raw.githubusercontent.com/Sauban-Kidwai/bruteguard/main/bruteguard.sh
chmod +x bruteguard.sh
```

### 2. Configure Your Settings

Edit the top of the script:

```bash
LOCAL_USER="your-linux-username"
TEMP_EMAIL="your-temp-email@example.com"
THRESHOLD=5
```

### 3. Run Manually

```bash
sudo ./bruteguard.sh
```

You’ll receive alerts if any IP exceeded the failed login threshold.

### 4. Schedule It to Run Every 5 Minutes

```bash
crontab -e
```

Add the following line to the bottom of the file:

```bash
*/5 * * * * /absolute/path/to/bruteguard.sh
```

Check cron activity:
```bash
grep CRON /var/log/syslog
```
