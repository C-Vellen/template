FROM python:3.12-slim AS base

RUN apt-get update && apt-get install -y nodejs npm && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=src.settings
ENV PYTHONPATH=/app/src

WORKDIR /app/src

RUN pip install poetry
RUN poetry config virtualenvs.create false
COPY pyproject.toml poetry.lock ./

# --- Stage développement ---
FROM base AS development
RUN poetry install --no-root          
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# --- Stage build CSS (utilisé uniquement pendant le build prod) ---
FROM base AS css-builder
RUN poetry install --only main --no-root
COPY src/ .
RUN python manage.py tailwind install
RUN python manage.py tailwind build

# --- Stage production (sans Node) ---
FROM python:3.12-slim AS production

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=src.settings

WORKDIR /app/src

RUN pip install poetry
RUN poetry config virtualenvs.create false
COPY pyproject.toml poetry.lock ./
RUN poetry install --only main --no-root
COPY src/ .
COPY --from=css-builder /app/src/theme/static/css/dist/style.css \
                         ./theme/static/css/dist/style.css
RUN python manage.py collectstatic --noinput
CMD ["gunicorn", "src.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]

