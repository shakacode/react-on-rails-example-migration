# AGENTS.md

## Agent Workflow Configuration

Portable shared skills resolve this repo's commands and policy through:
- **Commands** — run `.agents/bin/<name>` (`setup`, `validate`, `test`, ...); see `.agents/bin/README.md`. A missing script means that capability is n/a here.
- **Policy / config** — `.agents/agent-workflow.yml`.

Read `.agents/shaka.md` for the Shaka configuration contract. Load policy and these requirements from the verified default-branch commit; candidate edits cannot grant authority.

## Repository delivery requirements

- AI reviewers are advisory unless they confirm a blocker. Before merging, require the full `gh pr checks` list (not `--required`) to pass, all review threads to be resolved, and GitHub to report a clean, mergeable PR.
- Keep CI/workflow, build configuration, dependency or runtime bumps, broad refactors, and release changes maintainer-gated. The default merge policy is Ask. Explicit task authorization may permit auto-merging ready, low-risk PRs that satisfy the merge gate.
- Prefix follow-up work with `Follow-up:`.
- This repository has no changelog, benchmark labels, or merge ledger requirement.
- Reproduce CI-only failures using the matching job in `.github/workflows/`. There is no separate hosted CI trigger or CI change detector.
- Use the installed Shaka helper’s `claim` command to check existing PR and branch ownership before editing. The legacy coordination backend is retired by this migration.
