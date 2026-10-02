# AGENTS.md

## Agent Workflow Configuration

Portable shared skills resolve this repo's commands and policy through:
- **Commands** — run `.agents/bin/<name>` (`setup`, `validate`, `test`, ...); see `.agents/bin/README.md`. A missing script means that capability is n/a here.
- **Policy / config** — `.agents/agent-workflow.yml`.

## Repository delivery requirements

- AI reviewers are advisory unless they confirm a blocker. Before merging, require the full `gh pr checks` list to pass, all review threads to be resolved, and GitHub to report a clean, mergeable PR.
- Keep CI/workflow, build configuration, dependency or runtime bumps, broad refactors, and release changes maintainer-gated. Batch closeout may auto-merge only ready, low-risk PRs that satisfy the merge gate.
- Prefix follow-up work with `Follow-up:`.
- This example has no changelog, benchmark labels, or merge ledger requirement.
- Reproduce CI failures using the matching job in `.github/workflows/`. There is no separate hosted CI trigger or CI change detector.
