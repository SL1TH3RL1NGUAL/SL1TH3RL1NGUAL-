# 🜏 Luciio's Capsule: Sovereign Mesh Node

This repository contains the essential scripts, configurations, and protocols for initializing and maintaining a sovereign IPFS node, publishing capsules, and binding to DNSLink.

## 🧱 Components

- `publish_capsule.sh`: Bash script to publish and pin content to IPFS/IPNS.
- `config.yaml`: CORS and gateway settings.
- `capsule.json`: CID metadata and IPNS bindings.
- `daemon_check.py`: Python script to verify daemon status and auto-restart.
- `dnslink.txt`: DNS TXT record for linking to IPNS.

## 🌐 Gateway

- Subdomain: `https://gateway.blackcorp.me`
- Fallback: `https://gateway.blackcorp.me/ipfs/<CID>`
- IPNS: `https://gateway.blackcorp.me.ipns.dweb.link`

## 🧙 Invocation

```bash
bash publish_capsule.sh
