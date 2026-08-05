# Architecture

## Overview

The stack contains two services:

- `app`: demo upstream application
- `waf`: NGINX reverse proxy with ModSecurity + OWASP CRS

Traffic flow:

1. Client connects to `waf` on port `80`
2. ModSecurity evaluates request with OWASP CRS rules
3. Allowed requests are proxied to `app`
4. Blocked requests return `403`

## Structure

- `app/`: demo Node.js application and image build files
- `waf/`: WAF container build and NGINX/ModSecurity configuration
- `tests/`: security validation scripts
- `deploy/`: deployment manifests
- `docs/`: architecture and operational documentation