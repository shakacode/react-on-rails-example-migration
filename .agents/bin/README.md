# Agent Workflow Scripts

Standard entry points that portable agent-workflow skills call, so a skill can
run `.agents/bin/<name>` in any repo without knowing this repo's specific
commands. Each script is a thin, repo-owned wrapper. A script that is **absent**
means that capability is n/a here.

| Script | Purpose | This repo runs |
| --- | --- | --- |
| `setup` | Install dependencies | `bin/setup` |
| `validate` | Pre-push gate | `bin/rails test` |
| `test` | Run tests | `bin/rails test` |
| `lint` | Lint / format | n/a |
| `build` | Build / type-check | n/a |
| `docs` | Validate documentation | n/a |
| `ci-detect` | Detect CI impact | n/a |

Non-command policy lives in [`../agent-workflow.yml`](../agent-workflow.yml).
