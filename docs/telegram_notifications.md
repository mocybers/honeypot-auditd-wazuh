
Telegram Notifications for Honeypot Alerts

This section describes how to set up Telegram alerts for bait file access events detected by auditd.


# 1. Create a Telegram Bot

Open Telegram and search for @BotFather.

Type /start, then /newbot.

Follow the prompts to set a bot name and username.

BotFather will give you a BOT_TOKEN — save it.


# 2. Get Your Chat ID

i. Send a message to your bot.

ii. Visit:
https://api.telegram.org/bot<BOT_TOKEN>/getUpdates

ii. Look for:
"chat":{"id":<YOUR_CHAT_ID>}

# Create the Alert Script

Create /usr/local/bin/telegram_alert.sh:

#!/bin/bash
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"
MESSAGE="$1"

curl -s -X POST https://api.telegram.org/bot$BOT_TOKEN/sendMessage \
    -d chat_id=$CHAT_ID \
    -d text="$MESSAGE"

Make it executable:
sudo chmod +x /usr/local/bin/telegram_alert.sh


# 4. Add auditd Watch Rule

Edit sudo nano /etc/audit/rules.d/honeypot.rules:
-w /home/hacker/bait_files/ -p rwxa -k bait_access

Reload rules aftr saving:
sudo augenrules --load


# 5. Configure auditd Dispatcher for Telegram Alerts
Create Dispatcher Script

Create /usr/local/bin/auditd_telegram.sh:

#!/bin/bash
# Reads auditd events and sends Telegram alerts for bait file access
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

while read line; do
    if echo "$line" | grep -q "bait_access"; then
        /usr/local/bin/telegram_alert.sh "🚨 Bait file accessed on kali at $(date)"
    fi
done

Make it executable:
sudo chmod +x /usr/local/bin/auditd_telegram.sh


## Configure Dispatcher

Edit /etc/audisp/plugins.d/telegram_alert.conf:
active = yes
direction = out
path = /usr/local/bin/auditd_telegram.sh
type = always
format = string


Restart auditd
sudo systemctl restart auditd


From now on, whenever a bait file is accessed, auditd will trigger a Telegram alert in real time.
