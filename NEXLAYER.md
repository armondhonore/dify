# Nexlayer — dify

<!-- nexlayer:meta version=1 analyzed=2026-06-21T17:54:46Z repo=https://github.com/armondhonore/dify branch=nexlayer -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
Dify is an LLM application development platform that provides a comprehensive toolset for building AI applications, including an orchestration engine, frontend web interface, and API contracts.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| Node.js | language | 22.22.1 | package.json, .nvmrc |
| pnpm | tool | 11.6.0 | package.json |
| Hono | framework | catalog | packages/dev-proxy/package.json |
| Vite | build | catalog | package.json |
| TypeScript | language | catalog | packages/contracts/package.json |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- web/ — Main web application frontend
- api/ — Backend API implementation
- packages/dev-proxy/ — Development proxy for API routing
- packages/contracts/ — API and enterprise contract definitions
- packages/dify-ui/ — Shared UI component library
- packages/iconify-collections/ — Custom icon sets
- cli/ — Command line interface tools
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- OpenAI/LLM APIs (Required for AI functionality)
- PostgreSQL (Persistent storage)
- Redis (Caching and Task Queue)
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js >= 22.22.1
- pnpm >= 11.6.0
- Python (for API contract generation scripts)

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
DATABASE_URL=postgresql://user:pass@localhost:5432/dify
REDIS_URL=redis://localhost:6379
```

### Steps

1. `pnpm install` — Install workspace dependencies
2. `pnpm run prepare` — Run vp config to initialize environment
3. `pnpm dev` — Start development server (vinext and proxy)

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `NODE_ENV` | `"production"` | plain |
| `app` | `PORT` | `"3000"` | plain |
| `app` | `HOSTNAME` | `"0.0.0.0"` | plain |
| `app` | `NEXT_PUBLIC_API_URL` | `"http://api.pod:8000"` | plain |
| `postgres` | `POSTGRES_USER` | `dify` | plain |
| `postgres` | `POSTGRES_PASSWORD` | _(set via Nexlayer dashboard)_ | secret |
| `postgres` | `POSTGRES_DB` | `dify` | plain |
| `postgres-data` | `size` | `10Gi` | plain |
| `postgres-data` | `mountPath` | `/var/lib/postgresql` | plain |

### Secrets Required

Set these in the Nexlayer dashboard before deploying:

- `POSTGRES_PASSWORD` (`postgres` pod)

### nexlayer.yaml

```yaml
application:
  name: dify
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/dify:9eeb511-fix1"
      path: /
      servicePorts:
        - 3000
      vars:
        NODE_ENV: "production"
        PORT: "3000"
        HOSTNAME: "0.0.0.0"
        NEXT_PUBLIC_API_URL: "http://api.pod:8000"
    - name: postgres
      image: mirror.gcr.io/library/postgres:16-alpine
      servicePorts:
        - 5432
      vars:
        POSTGRES_USER: dify
        POSTGRES_PASSWORD: password
        POSTGRES_DB: dify
      volumes:
        - name: postgres-data
          size: 10Gi
          mountPath: /var/lib/postgresql
    - name: redis
      image: mirror.gcr.io/library/redis:7-alpine
      servicePorts:
        - 6379
      vars: {}
```

<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| web | mirror.gcr.io/library/node:22-alpine | 3000 | web |
| api | mirror.gcr.io/library/node:22-alpine | 5001 | web |
| db | mirror.gcr.io/library/postgres:16-alpine | 5432 | database |
| redis | mirror.gcr.io/library/redis:7-alpine | 6379 | cache |
| worker | mirror.gcr.io/library/node:22-alpine | 5002 | worker |

### Deployment notes

- All inter-pod communication uses the <podName>.pod:<port> format (e.g., db.pod:5432).
- Node.js version 22 is strictly required per .nvmrc and package.json.
- The API and Worker pods must be separate to avoid resource contention during LLM processing tasks.

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-21T18:13:40Z  
**Live URL:** https://relaxed-weasel-dify.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: dify
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/dify:9eeb511-fix1"
      path: /
      servicePorts:
        - 3000
      vars:
        NODE_ENV: "production"
        PORT: "3000"
        HOSTNAME: "0.0.0.0"
        NEXT_PUBLIC_API_URL: "http://api.pod:8000"
    - name: postgres
      image: mirror.gcr.io/library/postgres:16-alpine
      servicePorts:
        - 5432
      vars:
        POSTGRES_USER: dify
        POSTGRES_PASSWORD: password
        POSTGRES_DB: dify
      volumes:
        - name: postgres-data
          size: 10Gi
          mountPath: /var/lib/postgresql
    - name: redis
      image: mirror.gcr.io/library/redis:7-alpine
      servicePorts:
        - 6379
      vars: {}
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-21T17:54:46Z | analyzed | initial repo analysis |
| 2026-06-21T18:13:40Z | success | deployed https://relaxed-weasel-dify.cloud.nexlayer.ai |
<!-- nexlayer:end -->
