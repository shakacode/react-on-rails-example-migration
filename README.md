# React on Rails Migration Example

This repository is a migrated version of [ganchdev/react-rails-example](https://github.com/ganchdev/react-rails-example), converted from `react-rails` to [`react_on_rails`](https://github.com/shakacode/react_on_rails).

## Requirements
- Ruby 3.1+
- Node.js 18+
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

## Control Plane Flow

This repo now includes a shared `cpflow` setup for review apps, automatic
staging deploys from `main`, and production promotion. See
`.controlplane/readme.md` for the required Control Plane and GitHub setup.
