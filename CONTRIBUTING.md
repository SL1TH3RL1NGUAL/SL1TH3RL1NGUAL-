# CONTRIBUTING.md  
### Operational Discipline for SL1TH3RL1NGUAL‑project (S‑OPS‑01)

Thank you for contributing to **SL1TH3RL1NGUAL‑project**, the sovereign orchestration unit responsible for capsule processing, identity governance, topology mapping, and adaptive event routing within the Blackcorp/SL1TH3RL1NGUAL ecosystem.

This document defines the operational discipline, expectations, and boundaries for all contributors.

---

## 1. Operating Principles

- **Sovereignty**: Internal identifiers and capsule structures remain inside the trust boundary.
- **Auditability**: All changes must be traceable, documented, and reproducible.
- **Safety**: No contribution may expose private identifiers or violate codex governance.
- **Modularity**: Components must be replaceable, testable, and isolated.
- **Clarity**: Code and documentation must be explicit and readable.

---

## 2. Identity Discipline

### Private identifiers (never exposed externally):
- Avatar ID  
- Internal Circuit‑ID  
- Capsule ID  
- Topology bindings  

These must never appear in:
- Issues  
- Merge requests  
- Logs  
- Commit messages  

### Public identifiers (safe for external use):
- `SLN-{RAND8}-{DATE}`  
Used for support tickets, logs, and external references.

---

## 3. Contribution Workflow

### Step 1 — Branch naming
Use: