# github-copilot-advance-features

This repository now contains a minimal scaffold for an `online-shopping` MVP.

Structure added:

- `backend/` — FastAPI backend skeleton, Dockerfile, requirements
- `frontend/` — Vite + React skeleton, Dockerfile
- `infra/terraform/` — Terraform scaffold (resource group example)
- `.github/workflows/build-and-deploy.yml` — CI pipeline to build images and run Terraform

Quick local run (backend):

```bash
python -m venv .venv
. .venv/bin/activate
pip install -r backend/requirements.txt
uvicorn backend.app.main:app --reload --port 8000
```

Open the frontend after building or serve statically; the frontend expects an API at `/api` by default.
