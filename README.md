# Sinatra web-app

Sinatra web-app with MySQL Backend.

You should have an existing MySQL-Database to use this app.

## Installation

```console
git clone https://github.com/dxas90/sinatra-mysql-puma.git
cd sinatra-mysql-puma
bundle install
export RACK_ENV=development
rake db:create
rake db:schema:load
bundle exec puma config.ru -C puma.rb
```

## CI/CD Pipeline

This project includes a GitLab CI/CD pipeline with the following stages:

### Pipeline Stages

1. **initialize** - Displays pipeline information and verifies Ruby/Bundler versions
2. **build** - Installs dependencies and creates build artifacts
3. **test** - Runs database migrations and syntax checks
4. **containerize** - Builds and pushes Docker images (only on tags)
5. **deployment** - Deploys to staging environment (only on tags)
6. **promote** - Manual job to promote images to production (only on tags)
7. **notify** - Sends pipeline status notifications

### Pipeline Behavior

**On every commit to any branch:**
- `initialize` → `build` → `test` → `notify`

**On tags only:**
- `initialize` → `build` → `test` → `containerize` → `deployment` (staging) → `promote` (manual) → `notify`

### Creating a Release

To trigger a full pipeline with containerization and deployment:

```console
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

After the staging deployment completes, you can manually trigger the `promote_production` job to deploy to production.
