# DevSecOps Project

[![CI Pipeline](https://github.com/worktemp-coder/project1/actions/workflows/ci.yml/badge.svg)](https://github.com/worktemp-coder/project1/actions/workflows/ci.yml)

## What Was Built

A complete DevSecOps pipeline securing a Flask REST API from scratch.

## Project Structure

```
project1/
├── .github/
│   └── workflows/
│       └── ci.yml                # CI pipeline (test, bandit, trivy, checkov)
├── k8s/
│   ├── deployment.yaml
│   ├── namespace.yaml
│   ├── secret.yaml
│   ├── service.yaml
│   └── serviceaccount.yaml
├── src/
│   └── app.py                    # Secured Flask app
├── terraform/
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── .env                          # Local secrets (gitignored)
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── README.md
├── requirements.txt
└── threat-model.md
```

## Security Controls Implemented

### Code Security
- SQL injection fixed — parameterised queries
- Hardcoded secret removed — loaded from environment
- debug=True removed — reads from env variable
- Constant-time password comparison (hmac.compare_digest)

### Container Security
- Multi-stage Dockerfile — build tools not in production image
- Non-root user (appuser) — runs as UID 1000
- Read-only filesystem — no writes except /tmp
- ALL capabilities dropped

### CI/CD Pipeline

| Job | Tool | Purpose |
|-----|------|---------|
| test | Flask + curl | Health check passes |
| sast-bandit | Bandit | Python security issues |
| container-scan | Trivy | CVEs in image |
| iac-scan | Checkov | Terraform misconfigs |

### Kubernetes
- Restricted Pod Security Standard enforced on namespace
- Non-root user, read-only filesystem, no privilege escalation
- All Linux capabilities dropped
- Resource limits defined
- Liveness and readiness probes

### Infrastructure
- S3 bucket: public access blocked, KMS encryption, versioning
- Security group: no SSH from internet, HTTPS only

## Threat Model

See threat-model.md — 6 STRIDE threats identified, 4 mitigated, 2 open.

## Running Locally

```bash
docker compose up -d
curl http://localhost:5000/health
```

> Note: `docker compose up` requires a `.env` file (gitignored) to exist. Copy `.env.example` if provided, or create `.env` with your own `APP_SECRET` before starting.
