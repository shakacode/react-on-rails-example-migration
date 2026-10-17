# Control Plane Deployment Notes

This repository uses `cpflow` for opt-in pull-request review apps, automatic
staging deploys from `main`. Production promotion is not configured.
The generated GitHub Actions use `cpflow` v5.3.0 and pin the immutable release
commit `b1e5ff4a04adfccfd8b59996e8abdbb5defb3fd6`; see
[`.github/cpflow-help.md`](../.github/cpflow-help.md) for the complete commands,
settings, and upgrade procedure. After regenerating wrappers for a future
release, repin them with `bin/pin-cpflow-github-ref <release-commit-sha>`.

## Runtime Shape

The app uses SQLite and local Active Storage in production. The Control Plane
templates therefore mount persistent volumes at `/app/data` and `/app/storage`,
set `DATABASE_PATH=/app/data/production.sqlite3`, and leave the image's
`/app/db` migrations visible. The Rails entrypoint runs `bin/rails db:prepare`
before starting the server; no cron release runner mounts these volumes. The workload
uses one `stateful` replica because SQLite and Active Storage use ext4 volumes.
Each volume starts at the provider's 10 GiB minimum. CPU and memory are fixed;
Capacity AI is not enabled for this stateful workload.

## One-Time Bootstrap

The maintainer bootstraps each named app before CI deploys it. CI skips secret
setup and has no policy-administration permission. The explicit identity template
lets CI refresh an existing app without editing its secret-access policy.

Create the shared review-app secret before enabling review deployments. Review
apps execute pull-request code, so use a disposable value that grants no access
to staging, production, or third-party services:

```sh
cpln secret create-dictionary \
  --name react-on-rails-migration-example-review-secrets \
  --org "$CPLN_ORG_STAGING" \
  --entry "SECRET_KEY_BASE=$(bin/rails secret)"
```

Bootstrap persistent staging before its first deploy:

```sh
cpflow setup-app \
  -a react-on-rails-migration-example-staging \
  --org "$CPLN_ORG_STAGING" \
  --skip-post-creation-hook
```

Create `react-on-rails-migration-example-staging-secrets` with a distinct
`SECRET_KEY_BASE`. Bootstrap each review app with the same `setup-app` command
and its concrete review-app name before requesting its first CI deployment.

Outside CI, grant each app identity `reveal` on only its matching runtime
dictionary through a maintainer-owned policy. Keep the default
`<app-prefix>-secrets-policy` readable but without direct app-identity bindings;
cpflow cleanup can then inspect it without needing policy-edit permission.
CI needs `use` on the two dictionary references, not their plaintext values.
Limit its app, workload, volume, identity and image permissions to the bootstrapped
app names. Add a new review app to that allowlist before deploying it.

Seed the first image with `cpflow build-image -a APP --org ORG`, then
`cpflow deploy-image -a APP --org ORG` before enabling CI updates. The pinned
workflow refreshes existing templates while preserving their configured image;
an app with only the initial placeholder image cannot pass that refresh.

## GitHub Configuration

Store `CPLN_TOKEN_STAGING` as a repository secret. Set the repository variables
`CPLN_ORG_STAGING` to `shakacode-open-source-examples-staging` and
`STAGING_APP_NAME` to `react-on-rails-migration-example-staging`; both review
apps and automatic staging deploys use that staging organization. The review
app prefix is inferred from `.controlplane/controlplane.yml` unless
`REVIEW_APP_PREFIX` overrides it.
