#!/usr/bin/env bash
set -e

echo "🏁 Starting ${ENVIRONMENT} environment..."

# Wait for database if DB_HOST is defined
if [ -n "${DB_HOST}" ]; then
  echo "⏳ Waiting for database ${DB_HOST}:${DB_PORT:-3306}..."
  until nc -z "${DB_HOST}" "${DB_PORT:-3306}" >/dev/null 2>&1; do
    sleep 1
  done
  echo "✅ Database is up."
fi

# Run database migrations safely
echo "📦 Running migrations..."
bundle exec rake db:migrate RACK_ENV=${ENVIRONMENT} || true

# Start Puma
echo "🚀 Starting application..."
exec "$@"
