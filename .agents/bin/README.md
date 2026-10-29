# Agent Workflow Scripts

Thin, repo-owned wrappers that agent skills call instead of this repo's
specific commands. Shaka's standard `setup`, `validate`, and `test` live in
[`../shaka/bin/`](../shaka/bin/); other tools stay here. A script that is **absent**
means that capability is n/a here.

| Script | Purpose | This repo runs |
| --- | --- | --- |
| `setup` | Install dependencies | `bin/setup` |
| `validate` | Pre-push gate | JavaScript and Tailwind CSS builds, production Shakapacker compilation, then `bin/rails test` |
| `test` | Run tests | `bin/rails test` |
| `lint` | Lint / format | n/a |
| `build` | Build / type-check | JavaScript and Tailwind builds, React on Rails pack generation, then production Shakapacker compilation |
| `docs` | Validate documentation | n/a |
| `ci-detect` | Detect CI impact | n/a |

Non-command policy lives in [`../agent-workflow.yml`](../agent-workflow.yml).
