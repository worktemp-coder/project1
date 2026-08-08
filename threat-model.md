# Capstone Threat Model — STRIDE Analysis

## System: Capstone Flask API

### A01 — Spoofing
**Threat:** No authentication on /users/<id> endpoint
**Impact:** Any user can access any other user's data (IDOR)
**Mitigation:** Add @login_required decorator, verify user owns the resource
**Status:** Open

### A03 — Tampering (SQL Injection)
**Threat:** Original code used f-string in SQL query
**Impact:** Full database dump, authentication bypass
**Mitigation:** Parameterised queries implemented
**Status:** Mitigated

### A02 — Information Disclosure
**Threat:** debug=True exposes Werkzeug interactive debugger
**Impact:** Arbitrary code execution on server
**Mitigation:** debug reads from FLASK_DEBUG env variable (default false)
**Status:** Mitigated

### A05 — Security Misconfiguration
**Threat:** Hardcoded secret in source code
**Impact:** Anyone with repo access has the secret
**Mitigation:** Secret loaded from environment variable / Vault
**Status:** Mitigated

### A06 — Vulnerable Components
**Threat:** Outdated dependencies with known CVEs
**Impact:** Exploitable vulnerabilities in production
**Mitigation:** Trivy scans on every PR, grype gates on HIGH/CRITICAL
**Status:** Mitigated (pipeline gate)

### A07 — Authentication Failures
**Threat:** No rate limiting on /login endpoint
**Impact:** Brute force attack possible
**Mitigation:** Add Flask-Limiter — 5 attempts per minute per IP
**Status:** Open
