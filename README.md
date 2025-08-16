# Honeypot + Auditd + Wazuh + Telegram Alerts

A high-interaction honeypot setup on Kali Linux that uses `auditd` to monitor bait files, sends **real-time Telegram alerts**, and integrates with **Wazuh SIEM** for centralized security monitoring.

---

## 📌 Features
- **Auditd Monitoring** – Tracks any access to sensitive bait files.
- **Real-time Telegram Alerts** – Instant notifications when a bait file is accessed.
- **Wazuh Integration** – Forward logs to Wazuh for centralized alerting and incident analysis.
- **Secure UFW Rules** – Blocks attacker access but allows system updates, HTTPS, and Wazuh agent communication.

---

## 📂 Project Structure
honeypot-auditd-wazuh/
├── scripts/
│ └── telegram_alert.sh # Sends alerts to Telegram
├── README.md # Project documentation


---

## 🛠️ Installation & Setup

### **1️⃣  Clone this Repository**

git clone https://github.com/mocybers/honeypot-auditd-wazuh.git
cd honeypot-auditd-wazuh

### **2️⃣  Create Telegram Bot & Get Chat ID**
1. Go to Telegram, search for @BotFather and create a new bot.

2. Save your Bot Token.

3. Send a message to your bot.

4. Use @userinfobot to get your Chat ID.


### **3️⃣  Create the Telegram Alert Script**
Create the folder and script:
mkdir -p scripts
nano scripts/telegram_alert.sh

Paste this inside:
#!/bin/bash
MESSAGE="$1"
TOKEN="$TELEGRAM_BOT_TOKEN"
CHAT_ID="$TELEGRAM_CHAT_ID"

if [ -z "$TOKEN" ] || [ -z "$CHAT_ID" ]; then
  echo "[ERROR] TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID not set."
  exit 1
fi

curl -s -X POST https://api.telegram.org/bot${TOKEN}/sendMessage \
  -d chat_id="${CHAT_ID}" \
  -d text="${MESSAGE}" \
  -d parse_mode="Markdown" \
  >/dev/null && echo "[INFO] Telegram alert sent successfully."

Make it executable:
chmod +x scripts/telegram_alert.sh

### **4️⃣  Set Environment Variables**
Add these to your ~/.bashrc (so they load on every login):
export TELEGRAM_BOT_TOKEN="YOUR_BOT_TOKEN"
export TELEGRAM_CHAT_ID="YOUR_CHAT_ID"

Reload:
source ~/.bashrc

### **5️⃣  Configure Auditd to Monitor the Bait File**
Create bait file:
touch ~/.flag.txt

Add an audit rule:```
sudo auditctl -w $HOME/.flag.txt -p r -k baitfile ```



### **6️⃣  Trigger Telegram Alerts via Audit Events**
Create a dispatcher plugin at /etc/audit/plugins.d/telegram.conf:
```
active = yes
direction = out
path = /usr/local/bin/audisp-telegram
type = always
format = string ```

Then create /usr/local/bin/audisp-telegram:
#!/bin/bash
grep --line-buffered "baitfile" | while read -r line; do
  ~/honeypot-auditd-wazuh/scripts/telegram_alert.sh "🚨 Bait file accessed on $(hostname) at $(date)"
done

Make it executable:
sudo chmod +x /usr/local/bin/audisp-telegram

Restart auditd
sudo systemctl restart auditd

### **7️⃣  Wazuh Integration**
⦁	Install the Wazuh agent on Kali Linux.

⦁	Ensure /var/log/audit/audit.log is forwarded to the Wazuh manager.

⦁	Create a custom Wazuh rule to trigger when baitfile events are detected.

📜 Example Alert in Telegram
🚨 Bait file accessed on kali at Fri 15 Aug 2025 17:15:24 WAT!

🔒 Security Notes
⦁	❌ Never hardcode your Telegram token or Chat ID in scripts committed to GitHub.

⦁	✅ Use environment variables (.bashrc) instead

⦁	🔄 If you accidentally commit a token, revoke it immediately via BotFather.

📄 License
This project is licensed under the MIT License.

Author: mocybers
GitHub Repo: https://github.com/mocybers/honeypot-auditd-wazuh

📌 Disclaimer
This lab is intended for educational and research purposes only.
Do not deploy in a production environment without proper segmentation and controls.
