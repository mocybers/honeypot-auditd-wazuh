# Honeypot Auditd Wazuh Lab

This project demonstrates how to set up a high-interaction honeypot on Kali Linux using auditd and Wazuh for real-time detection and alerting. It includes bait file monitoring, Wazuh log analysis, and attacker tracing.

## 📌 Lab Environment

- Oracle VM with:
  - Kali Linux (honeypot + Wazuh agent)
  - Ubuntu (future host for log analysis)
  - Metasploitable2 (attacker machine)
  - Wazuh Server

## 🧪 Key Components

- auditd (Linux auditing tool)
- Bait files (e.g., `.aws_key`, `.flag.txt`)
- Wazuh Agent & Manager
- Alerts and log forwarding

