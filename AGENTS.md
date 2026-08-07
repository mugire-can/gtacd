# AGENTS.md

## Purpose
- This repository demonstrates a secure CI/CD pipeline using GitHub Actions and Ansible.
- Keep changes small, auditable, and focused on deployment safety.

## Repository Areas
- `app/`: static app content and local app check script.
- `ansible/`: deployment playbook and Nginx template.
- `scripts/`: local deployment validation helper.
- `.github/workflows/`: CI/CD workflows and secure deployment simulation.

## Local Validation
- Run app check: `./app/check_app.sh`
- Optional remote validation (requires reachable target + SSH key): `./scripts/test_deployment_config.sh`
- Optional Ansible run (requires inventory and access): `ansible-playbook -i inventory.ini ansible/deploy.yml`

## Workflow Expectations
- `ci_cd_full.yml` is the main pipeline (`build-and-test` then `deploy`).
- `secure-deployment-simulation.yml` validates key format, secret presence, and deployment command simulation.
- The real `deploy` job may fail on GitHub-hosted runners when the target host is private/unreachable.

## Security Requirements
- Never commit secrets, keys, or server credentials.
- Keep all sensitive values in GitHub Secrets (`SSH_PRIVATE_KEY`, `SERVER_IP`, `SERVER_USER`, `FAKE_API_TOKEN`, `ENV_TYPE`).
- Preserve least-privilege deployment assumptions (`deployuser`, non-root automation).

## Change Guidelines
- Prefer minimal, targeted edits.
- Do not weaken existing secret checks or key validation logic in workflows.
- When changing deployment behavior, keep CI simulation and local validation paths consistent.
