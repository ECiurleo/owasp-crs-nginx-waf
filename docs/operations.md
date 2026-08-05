# Operations

## Local Run

```bash
docker compose up -d --build
```

## Validate OWASP CRS Blocking

```bash
bash ./tests/security/run-owasp-crs-smoke.sh
```

## Confirm Blocking Mode

```bash
docker compose exec waf grep -n '^SecRuleEngine' /etc/nginx/modsecurity.conf
```

Expected:

- `SecRuleEngine On`

## Logs

```bash
docker compose logs --tail=100 waf
```

Look for:

- `ModSecurity: Access denied with code 403`
- `REQUEST-949-BLOCKING-EVALUATION`