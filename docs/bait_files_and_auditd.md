##🎯 Bait Files & Auditd Rules

This guide explains how to set up bait files and configure auditd rules to monitor unauthorized access.

# 1️⃣  Create Bait Files

These files act as decoys to lure attackers.
mkdir -p ~/bait_files
echo "TOP SECRET: AWS Access Key" > ~/bait_files/.aws_key
echo "FLAG{you_found_the_honeypot}" > ~/bait_files/.flag.txt

# 2️⃣  Set Permissions

Restrict access so that legitimate users avoid them, but attackers might still try to open them.
chmod 600 ~/bait_files/.aws_key ~/bait_files/.flag.txt

# 3️⃣  Add Auditd Rules

Edit the audit rules file:
sudo nano /etc/audit/rules.d/bait_files.rules

# Add the following lines:
-w /home/hacker/bait_files/.aws_key -p r -k baitfile_access
-w /home/hacker/bait_files/.flag.txt -p r -k baitfile_access

# 4️⃣  Reload Auditd Rules
sudo augenrules --load
sudo systemctl restart auditd

# 5️⃣  Test the Setup
Run:
cat ~/bait_files/.aws_key

Then check the logs:
sudo ausearch -k baitfile_access

# ✅ Expected Behavior

Every read access triggers an audit log.

Wazuh will pick up these logs for alerting.

Real-time Telegram notifications will be sent if configured.
