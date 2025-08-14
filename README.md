# 🛡️ Honeypot Auditd Wazuh Lab

This project demonstrates how to deploy a **high-interaction honeypot** on **Kali Linux** using `auditd` and **Wazuh**.  
It includes bait file monitoring, Wazuh log analysis, and attacker activity tracing — all integrated with **real-time Telegram alerts**.

---

## 📂 Lab Environment

**Virtualization Platform:** Oracle VirtualBox  
**VMs Used:**
- **Kali Linux** – Honeypot host + Wazuh Agent
- **Ubuntu** – (Planned) host for future log analysis
- **Metasploitable2** – Attacker simulation
- **Wazuh Server** – SIEM, alerting, and log storage

---

## 🔑 Key Components

- **auditd** – Linux auditing tool for file and system event monitoring  
- **Bait Files** – Decoy sensitive files (e.g., `.aws_key`, `.flag.txt`) to lure attackers  
- **Wazuh Agent & Manager** – Log collection, correlation, and alerting  
- **Real-Time Alerts** – Telegram/email notifications for bait file access  

---

## 🚀 Features

- Detects unauthorized file access instantly  
- Sends **real-time Telegram alerts** with timestamp and hostname  
- Forwards security logs to **Wazuh SIEM** for centralized analysis  
- Supports attacker IP tracking and investigation

---

## 🛠️ Recent Updates

**2025-08-13:**  
- Fixed Wazuh agent registration issue by importing the correct key from the manager  
- Verified dashboard connectivity  
- Confirmed agent is actively reporting to the manager

---

## 📜 Future Improvements

- Integrate **Kibana dashboards** for visual log analysis  
- Expand to monitor **network ports** and suspicious process execution  
- Automate honeypot deployment with an installation script

---

## 📁 Repository Structure


honeypot-auditd-wazuh/
│
├── docs/
│ ├── auditd_setup.md # Steps to install and configure auditd for bait file monitoring
│ ├── telegram_notifications.md # How to set up real-time Telegram alerts
│ ├── wazuh_custom_rule.md # Custom Wazuh rule for better alert visibility
│
├── scripts/
│ ├── telegram_alert.sh # Bash script for sending Telegram messages
│
├── README.md # Main project overview (this file)


---

## 📖 Documentation

- [Auditd Setup Guide](docs/auditd_setup.md)  
- [Telegram Notifications Setup](docs/telegram_notifications.md)  
- [Custom Wazuh Rule](docs/wazuh_custom_rule.md)  

---

## 🖼️ Example Alert

🚨 Bait file accessed on kali at Tue 05 Aug 2025 14:35:15 WAT!



---

## 📌 Disclaimer

This lab is intended for **educational and research purposes only**.  
Do **not** deploy in a production environment without proper segmentation and controls.

---

## 📚 References

- [auditd Manual](https://linux.die.net/man/8/auditd)  
- [Wazuh Documentation](https://documentation.wazuh.com/)  

