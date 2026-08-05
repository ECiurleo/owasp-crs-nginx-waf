# Test Suite

## Security Validation

Run OWASP CRS smoke tests:

```bash
bash ./tests/security/run-owasp-crs-smoke.sh
```

Prerequisites:

- bash
- curl
- docker compose

Useful options:

- `--skip-compose-up` to run against an already running stack
- `--base-url` to target a non-default endpoint