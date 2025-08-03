# 🛠️ Honeypot Setup with Auditd on Kali Linux

This document outlines how to configure a high-interaction honeypot using bait files and the `auditd` daemon for file access monitoring. The goal is to detect attacker interactions in real-time.

---

## ⚙️ System Info

- **OS**: Kali Linux (Oracle VM)
- **Role**: Honeypot
- **Monitoring Tool**: auditd
- **SIEM**: Wazuh Agent installed and connected to Wazuh Server

---

## 📁 Bait Files Used

These files were created in the root and home directories to act as lures for attackers:

```bash
touch ~/.aws_key
touch ~/.flag.txt
touch /root/.vault_pass.txt
