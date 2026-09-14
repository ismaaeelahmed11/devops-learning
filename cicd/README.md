# CI/CD Module

Completed the CI/CD module using GitHub Actions. Built two pipelines: one for Continuous Integration (automated tests) and one for Continuous Deployment (building and pushing Docker images).

---

## Task 1 — CI Pipeline

### What I Built
A GitHub Actions workflow that runs Python tests on every push and pull request affecting `cicd/task-1/`.

### Files
| File | Purpose |
|------|---------|
| `cicd/task-1/app.py` | Simple Flask app with `/` and `/health` routes |
| `cicd/task-1/test_app.py` | Pytest tests for both routes |
| `cicd/task-1/requirements.txt` | Dependencies (flask, pytest) |
| `.github/workflows/ci-pipeline.yaml` | The CI workflow |

### How It Works
- Triggers on push and PR when files in `cicd/task-1/` change
- Spins up Ubuntu with Python 3.12
- Installs dependencies
- Runs pytest

### Screenshots
- Task 1 files
- CI pipeline passing (green check)
- Workflow YAML

---

## Task 2 — CD Pipeline

### What I Built
A GitHub Actions workflow that builds a Docker image from `cicd/task-2/` and pushes it to Docker Hub on every push to `main`.

### Files
| File | Purpose |
|------|---------|
| `cicd/task-2/Dockerfile` | Container definition for the Flask app |
| `cicd/task-2/app.py` | Same Flask app from Task 1 |
| `cicd/task-2/requirements.txt` | Dependencies |
| `.github/workflows/cd-pipeline.yaml` | The CD workflow |

### How It Works
- Triggers on push to `main` when files in `cicd/task-2/` change
- Logs into Docker Hub using GitHub Secrets (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`)
- Builds the Docker image
- Pushes to `ismaaeelahmed/cicd-task2:latest`

### Screenshots
- Task 2 files
- GitHub repository secrets
- CD pipeline passing (green check)
- Docker Hub image

---

## What I Learnt

- GitHub Actions only reads workflows from `.github/workflows/` at the repo root
- Workflows can be scoped to specific folders using `paths:` filter
- Secrets keep credentials out of YAML files
- Docker build and push can be fully automated with `docker/build-push-action`
- YAML indentation is unforgiving — one wrong space breaks everything

---

## Issues I Solved

### Issue 1: YAML indentation
`pull_request:` and `push:` must both be indented under `on:`. Had them at the wrong level — workflow failed to parse.

### Issue 2: Flask import typo
`from flask import flask` — capital F on `Flask`. Tests failed until fixed.

### Issue 3: Paths filter didn't trigger
Workflow only fires when files inside the watched folder change. Changed `app.py` to trigger it.

### Issue 4: Secret name mismatch
Secrets were named `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` on GitHub, but the workflow referenced `DOCKER_USERNAME`. Fixed the workflow to match.

---

## Why CI/CD Matters in DevOps

CI catches broken code before it merges. CD ships it automatically once it passes. Together they remove manual steps, reduce human error, and let teams deploy multiple times a day with confidence.