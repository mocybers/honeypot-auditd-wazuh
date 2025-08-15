#!/bin/bash
# telegram_alert.sh - Send honeypot alerts to Telegram securely

# --- Check environment variables ---
if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "[ERROR] TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set." >&2
    exit 1
fi

# --- Read message from stdin or argument ---
if [ -p /dev/stdin ]; then
    MESSAGE=$(cat)
else
    MESSAGE="$1"
fi

if [ -z "$MESSAGE" ]; then
    echo "[ERROR] No message provided." >&2
    exit 1
fi

# --- Send Telegram message ---
RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="${MESSAGE}" \
    -d parse_mode="Markdown")

if [[ $RESPONSE == *'"ok":true'* ]]; then
    echo "[INFO] Telegram alert sent successfully."
else
    echo "[ERROR] Failed to send Telegram alert. Response: $RESPONSE" >&2
fi
