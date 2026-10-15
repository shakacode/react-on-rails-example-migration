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
`/app/db` migrations visible to the release script. The release script runs
`bin/rails db:prepare` before a new image is made live. The Rails workload
remains `standard` with one warm replica while Capacity AI right-sizes its
allocation.

## One-Time Bootstrap

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

Add a distinct `SECRET_KEY_BASE` to the generated staging app
secret dictionary. For later template changes, run `cpflow apply-template` and
ensure the app identity can `reveal` the app secret policy.

## GitHub Configuration

Store `CPLN_TOKEN_STAGING` as a repository secret. Set the repository variables
`CPLN_ORG_STAGING` to `shakacode-open-source-examples-staging` and
`STAGING_APP_NAME` to `react-on-rails-migration-example-staging`; both review
apps and automatic staging deploys use that staging organization. The review
app prefix is inferred from `.controlplane/controlplane.yml` unless
`REVIEW_APP_PREFIX` overrides it.

