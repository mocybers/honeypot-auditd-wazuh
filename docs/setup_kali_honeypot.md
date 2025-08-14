# 🛠️ Setting Up the Kali Linux Honeypot with auditd

This guide explains how to deploy a **high-interaction honeypot** on **Kali Linux** using `auditd` to monitor bait files and detect unauthorized access.

---

## 1️⃣ Update System and Install Required packages 
sudo apt update && sudo apt upgrade -y
sudo apt update && sudo apt install auditd audispd-plugins 

# 2️⃣1️Create Bait Files
mkdir -p ~/honeypot-auditd-wazuh/bait_files
echo "Fake AWS Key: AKIAxxxxxxxxxxxxxxxx" > ~/honeypot-auditd-wazuh/bait_files/.aws_key
echo "This is the secret flag" > ~/honeypot-auditd-wazuh/bait_files/.flag.txt

# 3️⃣ Configure auditd Rules
sudo nano /etc/audit/rules.d/bait.rules
-w /home/hacker/honeypot-auditd-wazuh/bait_files/.aws_key -p rwxa -k bait_access
-w /home/hacker/honeypot-auditd-wazuh/bait_files/.flag.txt -p rwxa -k bait_access
Note: Replace /home/hacker with your actual username.

Save and exit, then reload audith:
sudo augenrules --load
sudo systemctl restart auditd

# 4️⃣ Configure Wazuh Agent
sudo nano /var/ossec/etc/ossec.conf
<syscheck>
    <directories realtime="yes">/home/hacker/honeypot-auditd-wazuh/bait_files</directories>
</syscheck>

Save and return back to terminal and restart wazuh agent
sudo systemctl restart wazuh-agent

# 5️⃣ Enable Real-Time Telegram Alerts
sudo nano /var/local/bin/bait_alert.sh
#!/bin/bash
MESSAGE="🚨 Bait file accessed on $(hostname) at $(date)"
TOKEN="YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
    -d chat_id="$CHAT_ID" \
    -d text="$MESSAGE"
save and exit

Make it executable:
sudo chmod +x /usr/local/bin/bait_alert.sh

# 6️⃣ Automate Alerts with auditd
Edit /etc/audit/auditd.conf or use audit rules to call the script when an event occurs.

# 7️⃣ Test the Honeypot
cat ~/honeypot-auditd-wazuh/bait_files/.aws_key

# 8️⃣ Verify in Wazuh Dashboard
Check the Security Events tab for alerts with the keyword bait_access.


📌 Disclaimer
This setup is for educational purposes only.
Do not run it in a production environment without isolation
