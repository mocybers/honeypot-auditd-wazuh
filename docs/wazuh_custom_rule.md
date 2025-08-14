# 🛡️ Wazuh Custom Rule for Honeypot Bait File Access

This guide explains how to create a **custom Wazuh rule** to enhance visibility when a bait file in the honeypot is accessed.  
It builds on the Auditd and Telegram notification setup from previous sections.

---

## 📂 1. Rule File Location

Wazuh custom rules are stored in:
/var/ossec/bin/etc/rules/local_rules.xml

---

## ✍️ 2. Custom Rule Content

Append the following rule block to `local_rules.xml` **before the closing `</rules>` tag**:

```xml
<group name="auditd,">
  <rule id="100200" level="12">
    <decoded_as>auditd</decoded_as>
    <field name="audit.file.name">/root/.flag.txt</field>
    <description>🚨 Honeypot Bait File Access Detected: /root/.flag.txt</description>
    <mitre>
      <id>T1005</id>
    </mitre>
  </rule>
</group>


🔍 Explanation

⦁	id="100200" → Unique ID for this custom rule (must not conflict with existing rules).

⦁	level="12" → Sets a high severity to ensure it triggers strong alerts.

⦁	<decoded_as>auditd</decoded_as> → Matches logs from Auditd.

⦁	<field name="audit.file.name"> → Targets our bait file specifically.

⦁	<mitre> → Links to MITRE ATT&CK technique T1005 – Data from Local System.


💾 3. Save and Restart Wazuh Manager

After editing, restart Wazuh manager for changes to apply:

sudo systemctl restart wazuh-manager


🧪 4. Testing the Custom Rule

To test:
sudo cat /root/.flag.txt

Check Wazuh logs for the alert:

sudo tail -f /var/ossec/logs/alerts/alerts.log

You should see something like:
** Alert 1691423712.1234: - auditd,
2025 Aug 13 15:45:12 kali->/var/log/audit/audit.log
Rule: 100200 (level 12) -> '🚨 Honeypot Bait File Access Detected: /root/.flag.txt'

📡 5. Optional – Link to Telegram Notifications

If you already configured Telegram alerts (see docs/telegram_notifications.md),
this Wazuh rule will automatically send messages when triggered, e.g.
🚨 Honeypot Bait File Access Detected: /root/.flag.txt
MITRE ATT&CK: T1005 – Data from Local System


✅ Done!
You now have a dedicated Wazuh rule to highlight bait file access events,
with high severity and full integration into your alerting pipeline
