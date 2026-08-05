# Docker WAF Reference Stack

NGINX + ModSecurity + OWASP Core Rule Set in front of a demo application.

## Project Structure

```text
.
|- app/                          # Demo Node.js app
|- waf/                          # WAF image and NGINX/ModSecurity config
|- tests/
|  |- README.md
|  `- security/
|     `- run-owasp-crs-smoke.sh
|- deploy/
|  `- kubernetes/
|     `- waf-app.yaml
|- docs/
|  |- architecture.md
|  |- operations.md
|  `- owasp-crs.md
|- docker-compose.yml
`- LICENSE
```

## Quick Start

```bash
docker compose up -d --build
```

## Security Validation

```bash
bash ./tests/security/run-owasp-crs-smoke.sh
```

The smoke suite verifies that:

- benign traffic is allowed
- representative SQLi/XSS/LFI/RCE probes are blocked
- scanner signatures are blocked
- ModSecurity engine is `On` (blocking mode)

## OWASP CRS Versioning Strategy

This repository follows the OWASP CRS version shipped in Debian stable package sources for maintainability.

See details in [docs/owasp-crs.md](docs/owasp-crs.md).

## Kubernetes

Use [deploy/kubernetes/waf-app.yaml](deploy/kubernetes/waf-app.yaml) as the deployment baseline.

```bash
kubectl apply -f deploy/kubernetes/waf-app.yaml
```