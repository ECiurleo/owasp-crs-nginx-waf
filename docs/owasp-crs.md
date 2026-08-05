# OWASP CRS Notes

## Current Baseline in This Project

This project uses Debian stable packages:

- `libnginx-mod-http-modsecurity`
- `modsecurity-crs`

At runtime, this currently loads OWASP CRS `3.3.7` (as reported in ModSecurity audit logs in this environment).

## Alignment with Latest OWASP Changes

OWASP Core Rule Set continues to evolve (including CRS 4.x improvements). This repository is designed to follow the latest CRS version available in Debian stable for long-term maintainability and predictable patching.

To adopt newer upstream CRS releases earlier than Debian stable provides:

1. Pin a newer Debian/Ubuntu base that ships updated packages.
2. Or package CRS from upstream and override the default include path.
3. Re-run the smoke tests in `tests/security/run-owasp-crs-smoke.sh` after any upgrade.

## Verification Commands

```bash
docker compose exec waf grep -n '^SecRuleEngine' /etc/nginx/modsecurity.conf
docker compose logs --tail=100 waf
bash ./tests/security/run-owasp-crs-smoke.sh
```

Expected behavior:

- `SecRuleEngine On`
- Attack probes return `403` and are denied by `REQUEST-949-BLOCKING-EVALUATION`