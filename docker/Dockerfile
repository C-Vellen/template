# ---------- Base ----------
FROM python:3.12-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=src.settings
ENV PYTHONPATH=/app/src

WORKDIR /app

RUN pip install poetry
RUN poetry config virtualenvs.create false

COPY ../pyproject.toml ../poetry.lock ./
RUN poetry install --no-root

# ---------- Dev ----------
FROM base AS development

COPY ../ ./
CMD ["python", "src/manage.py", "runserver", "0.0.0.0:8000"]

# ---------- CSS Builder ----------
FROM node:20 AS css-builder

WORKDIR /app

# Copier tout static_src (config + package.json + styles.css)
COPY ../src/theme/static_src ./src/theme/static_src

WORKDIR /app/src/theme/static_src

RUN npm install

RUN npx tailwindcss \
    -i ./src/styles.css \
    -o ../static/css/dist/style.css \
    --minify

# ---------- Production ----------
FROM python:3.12-slim AS production

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=src.settings
ENV PYTHONPATH=/app/src

WORKDIR /app

RUN pip install poetry
RUN poetry config virtualenvs.create false

COPY ../pyproject.toml ../poetry.lock ./
RUN poetry install --only main --no-root

COPY ../ ./

COPY --from=css-builder /app/src/theme/static/css/dist/style.css \
                        ./src/theme/static/css/dist/style.css

COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh", "gunicorn", "src.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
