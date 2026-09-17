# Security Policy

## Supported Versions

We take the security of the Behavioral Health Vault extremely seriously. 

| Version | Supported          |
| ------- | ------------------ |
| >= 1.1.x| :white_check_mark: |
| < 1.1.0 | :x:                |

## Reporting a Vulnerability

**DO NOT create a public GitHub issue for security vulnerabilities.**

If you discover a security vulnerability within this project, please report it privately. 

1. Go to the **Security** tab of this repository.
2. Click on **Advisories** in the left sidebar.
3. Click the **Report a vulnerability** button.

We will investigate the issue and respond within 48 hours. If the vulnerability is verified, we will work with you to patch it and release a security update. You will be credited for the discovery in the release notes.

## Security Practices
- All code must pass the **CodeQL** Static Application Security Testing (SAST) pipeline.
- All code must pass the comprehensive Pytest security test suite (including SQL Injection, XSS, and Cryptographic boundary testing).
- Encryption keys (e.g., `ENCRYPTION_KEY`, `BHV_SECRET_KEY`) must **never** be committed to the repository.
