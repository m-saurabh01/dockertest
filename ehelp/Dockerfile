FROM node:22-bookworm-slim AS frontend-build

WORKDIR /app/frontend
COPY frontend/package.json ./
RUN npm install --no-audit --no-fund
COPY frontend/ ./
RUN mkdir -p /app/backend/ehelp/static && npm run build

FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    EHELP_DATA_DIR=/data

WORKDIR /app/backend
COPY backend/pyproject.toml ./pyproject.toml
COPY backend/ehelp/ ./ehelp/
RUN pip install --no-cache-dir . \
    && useradd --uid 10001 --create-home ehelp \
    && mkdir -p /data \
    && chown ehelp:ehelp /data
COPY --from=frontend-build /app/backend/ehelp/static/ ./ehelp/static/

USER ehelp
EXPOSE 8123
VOLUME ["/data"]

CMD ["uvicorn", "ehelp.app:create_app", "--factory", "--host", "0.0.0.0", "--port", "8123"]
