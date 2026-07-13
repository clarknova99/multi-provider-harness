# Security Policy

## Supported versions
This project is a template/harness distributed from the `main` branch. Security fixes are applied to `main`; there are no separately maintained release branches.

| Version | Supported |
|---|---|
| `main` (latest) | ✅ |
| older commits / tags | ❌ |

## Reporting a vulnerability
Please **do not** report security vulnerabilities through public GitHub issues, discussions, or pull requests.

Instead, use GitHub's private vulnerability reporting:
1. Go to the repository's **Security** tab.
2. Click **Report a vulnerability**. (The maintainer must enable *Private vulnerability reporting* under **Settings → Code security & analysis**.)

Please include:
- A description of the vulnerability and its impact.
- Steps to reproduce (a proof-of-concept if possible).
- Any suggested remediation.

## What to expect
- Acknowledgement of your report within a few business days.
- An assessment and, if confirmed, a fix on `main`.
- Credit in the fix notes if you'd like it — just say so in your report.

## Project-specific note
Because this harness deliberately stores task state as **plain files committed to the repo** (`docs/state/`, `.agents/memory/`, etc.), please also flag any pattern that could cause a tool to write secrets, tokens, or other sensitive data into those committed files. That is a project-specific risk class worth reporting even if it isn't a traditional code vulnerability.
