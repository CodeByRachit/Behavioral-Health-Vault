# BHV: Behavioral Health Vault

The goal of this project is to provide a digitization approach to record the journey of recovery of people with serious mental illnesses and other social determinants. BHV (pronounced Beehive or Behave) aims to complement traditional Electronic Health Records (EHRs) by storing patient-provided images (photographs and scanned drawings) along with associated textual narratives, which may be provided by the patient or recorded by a social worker during an interview.

BHV is a high-performance, modular monolith designed for community clinics. It operates reliably even in resource-constrained environments (low RAM/CPU) and locations with intermittent network connectivity. 

## 🚀 Key Features

- **Chunked File Streaming:** Memory-efficient 64KB streaming ingestion allows clinics to upload large visual narratives and patient histories without out-of-memory (OOM) crashes, even on low-spec hardware.
- **Decoupled Encryption & Searchable Metadata:** Resolves the encryption vs. searchability trade-off. Visual payloads are encrypted at-rest using **AES-256** and stored securely. Non-sensitive clinical metadata (e.g., timestamps, file types, clinical tags) is extracted via Pydantic and indexed in MongoDB, allowing for rapid querying without decrypting sensitive records.
- **Application-Level Sync-State Tracking:** A resilient, state-aware upload queue manages intermittent internet connections. If a connection drops, local caching and the `pending_sync` state ensure uploads resume automatically without data loss.
- **Robust Security & Identity Management:**
  - **In-Memory Encryption:** Patient data is encrypted in memory using AES-256 before ever touching persistent storage.
  - **Multi-Factor Authentication (MFA):** Implements TOTP-based 2FA (via PyOTP), PBKDF2 password hashing, and an SMTP OTP system for account recovery and sensitive changes.
  - **Role-Based Access Control (RBAC):** Distinct roles for clinicians, system administrators, and patients.
  - **Security Hardening:** Global HTTP security headers (HSTS, X-Frame-Options), strict CSRF validation on all state-changing routes, and Write-Ahead Logging (WAL) for session recovery.
- **Minimalist Server-Side Rendering (SSR):** Uses Jinja2 directly with FastAPI to serve a dynamic and responsive web interface without the performance penalty of heavy JavaScript frameworks. Includes Vanilla JS for UX enhancements like dark/light mode toggles.
- **Automated GitHub OAuth Flow:** (Data Sovereignty) Syncs backups to a repository in a decentralized way without requiring complex manual token management.

## 🛠️ Technology Stack

- **Backend:** FastAPI (Python 3.10+), ASGI (Uvicorn), Asynchronous I/O
- **Database:** MongoDB (Motor async driver) for schema-less data modeling
- **Frontend:** Jinja2 Templating, Vanilla JavaScript, HTML/CSS
- **Cryptography:** Cryptography (Fernet AES-256), Pydantic (Metadata extraction), SHA-256 (Chunk fingerprinting)

## 📁 Source Code Architecture

```text
bhv-vault/
├── app/
│   ├── main.py           # FastAPI Application Entry Point (ASGI)
│   ├── auth.py           # TOTP 2FA, IAM, & Anti-ATO OTP Pipeline
│   ├── crypto.py         # AES-256 In-Memory Encryption & Decryption Engine
│   ├── database.py       # MongoDB (Motor) & Sync-State Tracking Logic
│   ├── schemas.py        # Pydantic Models for Searchable Metadata Validation
│   ├── templates/        # Server-Side Rendered Jinja2 UI
│   └── research.py       # [Stretch Goal] Culturally-Adaptive Fuzzy Logic
├── scripts/
│   └── setup.sh          # Pre-flight Environment Validator (RAM, Ports)
├── data/                 # Local Encrypted File Storage
├── tests/                # Security, Streaming Resilience, & Unit Tests
├── docker-compose.yml    # Multi-container Deployment Orchestration
└── requirements.txt      # Python Dependency Manifest
```

## 🔒 Security Architecture Highlights

1. **Security Interception (Middleware):** The FastAPI gateway ensures all incoming requests are authenticated and authorized (401 rejection for invalid sessions) before reaching the processing engine.
2. **Zero-Trust Retrieval Pipeline:** Clinicians can view encrypted vault files on the fly using `io.BytesIO` decryption, ensuring that unencrypted files are never saved to the local disk during viewing.
3. **Automated Validation:** Pre-flight validation checks (via Bash and Python) ensure minimum hardware requirements and required ports are available prior to initializing the vault.

## 🏃 Getting Started

*(Instructions for local setup, environment variables, and running the application will be added here).*
