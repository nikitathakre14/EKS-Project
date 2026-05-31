# EKS Production App — Unified Python + React UI

This repository is now a clean production-ready EKS setup with one unified application and a single README.

## Repository layout

- `app/`
  - `app.py` — FastAPI backend serving both `/user` and `/order` APIs plus the UI.
  - `requirements.txt` — Python dependencies for FastAPI and static file serving.
  - `Dockerfile` — container image build for the unified application.
  - `.dockerignore` — files excluded from the image build.
  - `ui/` — React-style frontend assets served from the app.

- `k8s/`
  - `production-namespace.yaml` — namespace for production workloads.
  - `app.yaml` — single deployment and service for the unified app.
  - `ingress.yaml` — ALB ingress routing `/`, `/user`, and `/order`.
  - `hpa.yaml` — autoscaling for the app deployment.
  - `pdb.yaml` — pod disruption budget for availability.

- `terraform/` — AWS infrastructure definition for EKS, networking, and security.

## Prerequisites

- AWS CLI configured with valid AWS credentials.
- Terraform installed.
- `kubectl` installed and configured for your EKS cluster.
- Docker installed for building container images.

## Local build

From the repository root:

```bash
cd app
docker build -t nikitathakre10/app-service:latest .
```

Then push to Docker Hub:

```bash
docker push nikitathakre10/app-service:latest
```

## Run locally

From the `app/` directory:

```bash
uvicorn app:app --host 0.0.0.0 --port 80
```

Then visit:

```bash
http://localhost:80
```

## Kubernetes deployment

1. Create the production namespace:

```bash
kubectl apply -f k8s/production-namespace.yaml
```

2. Deploy the application:

```bash
kubectl apply -f k8s/app.yaml
kubectl apply -f k8s/hpa.yaml
kubectl apply -f k8s/pdb.yaml
kubectl apply -f k8s/ingress.yaml
```

3. Access the UI via your ingress hostname:

```bash
https://app.example.com/
```

If DNS is not configured, port-forward the service locally:

```bash
kubectl port-forward svc/app-service 8080 -n production
```

Then open:

```bash
http://localhost:8080/
```

## API endpoints

- `GET /user`
- `GET /user/ping`
- `GET /user/users`
- `GET /user/users/{id}`
- `POST /user/users`
- `GET /order`
- `GET /order/ping`
- `GET /order/orders`
- `GET /order/orders/{id}`
- `POST /order/orders`

## Notes

- Update `k8s/ingress.yaml` with your real domain.
- The app image is `nikitathakre10/app-service:latest` in `k8s/app.yaml`.
- Keep only this README in the repository for documentation.
- Remove any local secret files from the repo before committing.
