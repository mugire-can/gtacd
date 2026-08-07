\# GTACD — GitHub Actions CI/CD Security Project



A secure CI/CD pipeline built with GitHub Actions and Ansible, focused on

DevSecOps practices: secret management, least-privilege access, and

auditable, automated deployments.



\## Project Overview



This project builds a two-part secure pipeline:



\- \*\*Part 1 — CI (GitHub Actions):\*\* automated checks on every push to `main`,

&#x20; with secure handling of secrets (API tokens, SSH keys) that are never

&#x20; exposed in logs.

\- \*\*Part 2 — CD (Ansible + GitHub Actions):\*\* automated deployment to a

&#x20; remote server using a dedicated, least-privilege deployment user and a

&#x20; dedicated SSH key (no personal credentials involved).



\## Repository Structure



```

.

├── app/

│   ├── index.html

│   └── check\_app.sh

├── ansible/

│   ├── deploy.yml

│   └── nginx\_vhost.conf.j2

├── scripts/

│   └── test\_deployment\_config.sh

├── .github/workflows/

│   ├── ci\_cd\_full.yml

│   └── secure-deployment-simulation.yml

└── .gitignore

```



\## Pipeline Jobs Summary



| Job | Description | Status |

|---|---|---|

| 1 | Minimal web app + verification script | ✅ |

| 2 | Basic CI workflow (checkout, test, log output) | ✅ |

| 3 | GitHub Secrets integration + failure simulation | ✅ |

| 4 | Deployment server hardening + config-validation simulation | ✅ |

| 5 | Ansible deployment playbook (Nginx + app deploy) | ✅ (validated locally) |

| 6 | Ansible integrated into GitHub Actions CD job | ✅ (workflow structure validated) |

| 7 | End-to-end pipeline trigger test | ✅ |



\## ⚠️ Known Limitation: `deploy` Job on GitHub-Hosted Runners



The `deploy` job in `ci\_cd\_full.yml` \*\*fails on GitHub-hosted runners\*\* with

Ansible exit code 4 (`UNREACHABLE`). This is expected: the target VM sits on

a private/local network (`192.168.233.136`) that is not reachable from

GitHub's cloud infrastructure.



This is a network-topology limitation, not a configuration error. The

deployment logic, secret handling, and SSH setup were fully validated:



\- \*\*Locally\*\*, via `ansible-playbook -i inventory.ini ansible/deploy.yml`

&#x20; and `scripts/test\_deployment\_config.sh` — both succeed end-to-end,

&#x20; including a real deploy of app updates (see the V2.0 test in Job 7).

\- \*\*On GitHub Actions\*\*, via `secure-deployment-simulation.yml`, which

&#x20; validates SSH key format/size/passphrase, secret presence, and simulates

&#x20; the deployment commands without requiring real network access — this

&#x20; workflow passes ✅.



In a real production setup with a publicly reachable (or VPN/self-hosted

runner-accessible) target server, the `deploy` job would succeed exactly as

designed.



\## Security Practices Implemented



\- \*\*Secrets management:\*\* all sensitive values (API tokens, SSH private key,

&#x20; server IP/user) are stored as GitHub Secrets, never hardcoded. GitHub

&#x20; automatically masks them in logs.

\- \*\*Dedicated SSH key:\*\* a passphrase-less, 4096-bit key generated

&#x20; specifically for this project (not a personal key), limiting blast radius

&#x20; if it were ever compromised.

\- \*\*Least privilege:\*\* a dedicated non-root `deployuser` with scoped sudo

&#x20; access is used for all deployment operations instead of `root`.

\- \*\*Traceability:\*\* every pipeline run is logged in GitHub Actions, giving a

&#x20; full audit trail of what was deployed, when, and by which commit.



\## Going Further — Advanced CI/CD Security



\- \*\*SAST/SCA:\*\* static application security testing and software composition

&#x20; analysis tools (e.g. Semgrep, Trivy, Dependabot) could be added as CI steps

&#x20; to catch vulnerable code patterns and dependencies before merge.

\- \*\*DAST:\*\* dynamic testing tools (e.g. OWASP ZAP) could run against the

&#x20; deployed app post-deployment to catch runtime vulnerabilities.

\- \*\*Audit \& logging:\*\* GitHub Actions and Ansible logs can be shipped to a

&#x20; SIEM for correlation and anomaly detection.

\- \*\*Environment protection:\*\* GitHub Environments with required reviewers

&#x20; could gate production deployments behind manual approval.

\- \*\*Rollback strategy:\*\* keeping the last N successful deploy artifacts and

&#x20; an Ansible rollback playbook would allow fast recovery from a bad deploy.



\## Setup Reference



See inline comments in `ansible/deploy.yml` and

`.github/workflows/\*.yml` for configuration details. Required GitHub

Secrets: `FAKE\_API\_TOKEN`, `ENV\_TYPE`, `SSH\_PRIVATE\_KEY`, `SERVER\_IP`,

`SERVER\_USER`.

