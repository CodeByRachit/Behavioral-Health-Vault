# BHV: 🧠 Behavioral Health Vault

[![CI](https://github.com/CodeByRachit/Behavioral-Health-Vault/actions/workflows/ci.yml/badge.svg)](https://github.com/CodeByRachit/Behavioral-Health-Vault/actions/workflows/ci.yml)
[![CodeQL](https://github.com/CodeByRachit/Behavioral-Health-Vault/actions/workflows/codeql.yml/badge.svg)](https://github.com/CodeByRachit/Behavioral-Health-Vault/actions/workflows/codeql.yml)
[![License: BSD 3-Clause](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=flat&logo=fastapi)](https://fastapi.tiangolo.com/)
[![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=flat&logo=mongodb&logoColor=white)](https://www.mongodb.com/)

> Secure, memory-efficient, chunked file storage and access control system for highly sensitive clinical narratives and behavioral health data.

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


<img width="809" height="258" alt="image" src="https://github.com/user-attachments/assets/4a10a4fe-e261-4496-8fda-21da2f620d26" />

## 🏃 Getting Started

### Prerequisites
- Python 3.10+
- MongoDB instance (local or remote)

### Local Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/CodeByRachit/Behavioral-Health-Vault.git
   cd Behavioral-Health-Vault
   ```

2. **Set up a virtual environment:**
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows, use `.venv\Scripts\activate`
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Environment Variables:**
   Create a `.env` file in the root directory and configure your MongoDB connection and secrets:
   ```env
   MONGODB_URL=mongodb://localhost:27017
   SECRET_KEY=your_secret_key_here
   ```

5. **Run the Application:**
   ```bash
   uvicorn app:app --reload
   ```
   The API gateway will be available at `http://localhost:8000`.

## 📊 Performance & Benchmarks (Clinical Impact)

To ensure BHV can operate smoothly on limited hardware (such as 10-year-old desktops or Raspberry Pis) in underfunded clinics, the system has undergone stress testing for the 64KB chunked ingestion pipeline:

- **OOM Crash Prevention (10MB RAM):** The asynchronous chunked streaming keeps memory usage incredibly low. While a regular FastAPI server would attempt to load a 500MB payload directly into memory (crashing legacy hardware), BHV maintains a stable memory footprint of only ~10MB.
- **Zero-Blocking UI (139 MB/s Ingestion):** The modular backend can ingest data at high speeds. It can store a 15MB high-resolution scan of a patient's artwork in approximately 0.1 seconds, guaranteeing the interface stays fully responsive for clinicians.
- **Medical Data Fidelity (SHA-256 Integrity):** Precision is crucial in healthcare. Benchmark tests confirm that the AES-256 in-memory encryption and decryption processes do not alter a single byte of data. Hash verifications perfectly match the original plaintext with the decrypted outputs.
<img width="1012" height="505" alt="image" src="https://github.com/user-attachments/assets/d13d7ec5-2407-4803-aa41-9c21040c16c4" />

<img width="1043" height="312" alt="image" src="https://github.com/user-attachments/assets/bbf94880-11d9-437f-bf8f-bb229dabdb0b" />
<img width="1008" height="557" alt="image" src="https://github.com/user-attachments/assets/eef5a1e8-a82d-4d02-8fad-54f820e88849" />



