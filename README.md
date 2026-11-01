<div align="center">

# Windows Endpoint Security Lab

**A defensive, read-only review of selected Windows endpoint security settings.**

`Endpoint Security` `PowerShell` `Baseline Review` `Risk Register`

</div>

---

## Overview

This lab documents a basic endpoint security review for a Windows device you own or are authorized to assess. It combines a checklist, a simple risk register, and a PowerShell script that reads selected configuration states.

This is **not** a complete security audit, penetration test, compliance attestation, or guarantee that a device is secure. A baseline result is only a starting point for review.

## Objectives

- Understand why endpoint settings matter.
- Inspect selected security controls without modifying them.
- Record evidence and distinguish pass, review, and unavailable states.
- Prioritize risks based on impact and likelihood.
- Recommend changes only after considering business needs and approval.

## Scope

The script checks selected indicators where the Windows environment exposes them:
- Windows Firewall profile state.
- Microsoft Defender service / real-time protection state, when available.
- User Account Control (UAC) registry setting.
- Remote Desktop enablement registry setting.

Some settings may be unavailable because of Windows edition, device policy, permissions, security software, or environment differences. `REVIEW` or `NOT AVAILABLE` is not proof of a vulnerability; investigate before drawing conclusions.

## Run the audit script

Open PowerShell in the project folder:

```powershell
.\scripts\Get-SecurityBaseline.ps1
```

By default, it writes `security-baseline.local.csv` in the current directory. The output file is ignored by Git. Use a custom path if needed:

```powershell
.\scripts\Get-SecurityBaseline.ps1 -OutputPath ".\reports\security-baseline.local.csv"
```

The script only reads configuration. It does not enable or disable controls, modify the registry, or change accounts.

## Review workflow

1. Define the device and assessment scope.
2. Record Windows edition/build, date, and whether the device is personally owned or authorized.
3. Run the script and inspect the result.
4. Compare findings with the organization's policy or an appropriate vendor baseline.
5. Record risks and recommendations in `docs/risk-register.csv`.
6. Get approval before making changes.
7. After an approved change, rerun the relevant check and document the actual result.

## Baseline checklist

See [`docs/security-baseline-checklist.md`](docs/security-baseline-checklist.md). The checklist explains intent, evidence, and interpretation for each control.

## Risk register

See [`docs/risk-register.csv`](docs/risk-register.csv). Initial entries are example risks to assess, not findings about a real computer. Update likelihood and impact based on the actual environment.

## Safe-use rules

- Run only on a device you own or are authorized to assess.
- Do not disable antivirus, firewall, UAC, or other protections to make a test easier.
- Do not publish raw reports containing hostnames, domains, usernames, or internal configuration.
- Do not include secrets or internal security architecture in a public repository.
- If a check suggests compromise, preserve evidence and follow an approved incident-response process instead of making ad hoc changes.

## Results

No device has been audited by this document. After running the script, add a dated report summary with the environment, actual output, interpretation, and limitations. Do not claim that the endpoint is “secure” solely because the listed checks pass.

## Structure

```text
.
├── README.md
├── scripts/
│   └── Get-SecurityBaseline.ps1
└── docs/
    ├── security-baseline-checklist.md
    └── risk-register.csv
```
