#!/bin/sh
set -e

echo "Waiting for database..."
until pg_isready -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME"; do
  sleep 1
done

echo "Database ready."

if [ "$DJANGO_ENV" = "production" ]; then
  echo "Applying migrations..."
  python manage.py migrate --noinput

  echo "Collecting static files..."
  python manage.py collectstatic --noinput
fi

echo "Starting application..."
exec "$@"

