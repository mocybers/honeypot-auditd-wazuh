# Telegram Notification for Honeypot alerts
This guide explains how to send real-time Telegram alerts when bait files in the honeypot are accessed.  
It covers two approaches:

1. **Direct auditd → Telegram** (no SIEM required)  
2. **Wazuh-triggered Telegram** (integrated into your SIEM for richer context)  


## 1. Create a Telegram Bot and Get Chat ID
1. Open Telegram and search for **@BotFather**.
2. Type `/start`, then `/newbot`.
3. Follow the prompts to set a bot name and username.
4. BotFather will give you a **BOT_TOKEN** — save it.
5. Send a message to your bot in Telegram.
6. In a browser, visit: https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
7. Look for `"chat":{"id":<YOUR_CHAT_ID>}` and save your **CHAT_ID**.



## 2. Common Alert Script

Create `/usr/local/bin/telegram_alert.sh`:
```bash
#!/bin/bash
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
MESSAGE="$1"

curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage \
 -d chat_id=$CHAT_ID \
 -d text="$MESSAGE"

Make it executable
sudo chmod +x /usr/local/bin/telegram_alert.sh

3. Method A — Direct auditd → Telegram
a) Add auditd watch rule

Edit /etc/audit/rules.d/honeypot.rules:

-w /home/hacker/bait_files/ -p rwxa -k bait_access

Reload rules:
sudo aufenrules --load

b) Create dispatcher script

Create /usr/local/bin/auditd_telegram.sh:
#!/bin/bash
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

while read line; do
    if echo "$line" | grep -q "bait_access"; then
        /usr/local/bin/telegram_alert.sh "🚨 Bait file accessed on kali at $(date)"
    fi
done

Make it executable:
chmod +x /usr/local/bin/auditd_telegram.sh

c) Configure audisp

Edit /etc/audisp/plugins.d/telegram_alert.conf:
active = yes
direction = out
path = /usr/local/bin/auditd_telegram.sh
type = always
format = string
.
d) Restart auditd
sudo systemctl restart auditd

4. Method B — Wazuh-triggered Telegram

This method sends alerts from Wazuh to Telegram when Wazuh detects bait file access (using auditd logs shipped to the manager).

a) Create Wazuh custom rule

On Wazuh Manager, create /var/ossec/etc/rules/local_rules.xml (or edit if it exists):

<group name="honeypot,">
  <rule id="100500" level="12">
    <if_group>audit</if_group>
    <match>bait_access</match>
    <description>Bait file accessed on Kali honeypot</description>
  </rule>
</group>

Reload Wazuh manager:
sudo systemctl restart wazuh-manager

b) Create Wazuh integration script

Create /var/ossec/integrations/telegram:

#!/bin/bash
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

read -r ALERT
MESSAGE=$(echo "$ALERT" | jq -r '.full_log // "No log data"')

curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage \
    -d chat_id=$CHAT_ID \
    -d text="🚨 Wazuh Alert: $MESSAGE"

Make it executable:
sudo chmod +x /var/ossec/integrations/telegram

c) Configure integration
Edit /var/ossec/etc/ossec.conf inside the <ossec_config> section:

<integration>
  <name>telegram</name>
  <hook_url></hook_url>
  <alert_format>json</alert_format>
</integration>

D) Restart Wazuh manager

Sudo systemtcl restart wazuh-manager
5. Testing

Trigger a bait file access:

cat /home/hacker/bait_files/.flag.txt

You should receive an alert via:

Method A: Immediately from auditd dispatcher

Method B: Through Wazuh integration (may take a few seconds)
6. Choosing a Method

Use Method A if you want instant alerts with minimal setup.

Use Method B if you want alerts enriched with Wazuh's context, correlation, and history.
✅ This dual setup ensures real-time attacker detection and forensic-ready alert logging in your honeypot.
