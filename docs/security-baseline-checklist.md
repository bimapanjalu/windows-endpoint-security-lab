# Windows Endpoint Security Baseline Checklist

> Use this checklist only on a device you own or are authorized to assess. The appropriate setting depends on device purpose and organizational policy.

## Assessment metadata

- Date:
- Assessor:
- Windows edition/build:
- Device purpose:
- Scope and authorization:
- Reference policy/baseline:
- Exceptions approved by:

## Controls

| Control | Why it matters | Evidence to collect | Interpretation |
|---|---|---|---|
| Windows Firewall | Helps restrict inbound and outbound network traffic according to policy | Firewall profile states and applicable policy | A disabled profile requires investigation; do not enable/disable without understanding policy |
| Endpoint protection | Helps detect or prevent malicious activity | Defender state or approved third-party product status | Defender may not be the active product on a managed endpoint |
| UAC | Helps reduce silent elevation of administrative actions | UAC configuration and policy | Compare with an approved baseline; do not change casually |
| Remote Desktop | Remote access increases exposure if not properly controlled | RDP state, approved access path, firewall and authentication policy | Enabled RDP is not automatically a vulnerability, but must be justified and protected |
| Updates | Patches address known defects and vulnerabilities | Update history and update policy | Record pending/recent updates; respect managed maintenance windows |
| Least privilege | Limits the impact of compromised accounts | Approved review of local administrators and user roles | Remove privileges only through an approved change process |
| Backup / recovery | Supports recovery from deletion, failure, and ransomware | Backup policy and a verified restore test | A successful backup job is not proof of recoverability until restoration is tested |
| Screen lock | Reduces unattended-session exposure | Lock timeout policy | Compare with organizational policy and user workflow |
| Evidence handling | Prevents accidental exposure of internal information | Sanitized reports and approved storage | Never publish raw reports containing identifiers or secrets |

## Findings log

| ID | Control | Observation | Evidence | Status | Follow-up owner |
|---|---|---|---|---|---|
| SEC-001 | `[control]` | `[actual observation]` | `[sanitized evidence]` | `[pass / review / not available]` | `[owner or N/A]` |

## Change control

For any proposed change, document the reason, impact, approval, rollback plan, maintenance window, and post-change verification. This lab's script does not make changes.
