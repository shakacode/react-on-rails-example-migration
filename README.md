# React on Rails Migration Example

This repository is a migrated version of [ganchdev/react-rails-example](https://github.com/ganchdev/react-rails-example), converted from `react-rails` to [`react_on_rails`](https://github.com/shakacode/react_on_rails).

## Requirements
- Ruby 3.3+
- Node.js 20.19+ or 22.12+
- Yarn 1.x

## What This Demonstrates
- Migrating from `react-rails` to `react_on_rails`
- `shakapacker`-based client and server bundles
- React component registration and SSR setup
- Development process options via `bin/dev`

## Quick Start
1. `bundle install`
2. `yarn install`
3. `bin/rails db:prepare`
4. `bin/dev`
5. Visit `http://localhost:3000/hello_world`

## Notes
- This app is intentionally minimal and focused on migration outcomes.
- Generated React on Rails files are kept in-repo so users can inspect exact changes after migration.

## Temporary Verification

Run `bin/verify-container` to build the production image and check server-rendered
HTML on `/`, `/posts/0`, and `/hello_world`. Docker must be running. The command
uses a random signing key, an ephemeral SQLite database, and a random localhost
port. It removes its container and image tag on success, failure, or interruption.
No cloud app, persistent volume, registry upload, or permanent endpoint is created.

For interactive browser checks, use `bin/dev` and stop it afterward. This repository
has no deployment workflows, automatic deployments, or permanent staging app.
