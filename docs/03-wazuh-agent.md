# Wazuh Agent Setup on Kali Honeypot

This guide outlines how to install and configure the Wazuh agent on the Kali Linux honeypot to monitor system events and forward alerts to the Wazuh manager.

---

## 1. Install Wazuh Agent

```bash
curl -sO https://packages.wazuh.com/4.7/wazuh-agent_4.7.3-1_amd64.deb
sudo dpkg -i wazuh-agent_4.7.3-1_amd64.deb
