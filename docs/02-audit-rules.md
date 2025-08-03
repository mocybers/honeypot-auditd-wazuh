# Step 2: Configure auditd Rules for Bait Files

This guide shows how to set up auditd rules to monitor unauthorized access to sensitive bait files on Kali Linux.

## 🎯 Bait Files to Monitor

We are tracking the following sensitive-looking files:

- `/home/hacker/.aws_key`
- `/home/hacker/.flag.txt`

> You can modify these paths or add more depending on your honeypot strategy.

## 🔧 Create the audit rules

Use the following commands to define permanent auditd rules:

```bash
sudo nano /etc/audit/rules.d/honeypot.rules

-w /home/hacker/.aws_key -p rwxa -k honeypot
-w /home/hacker/.flag.txt -p rwxa -k honeypot
