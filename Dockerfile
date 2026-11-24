
# Stage 1:Python dependencies
FROM python:3.11-slim@sha256:07d4824036af339fa1b6ef769cc99d9c10a141769538b52b3b597c84f7a7b535 AS builder

WORKDIR /build

COPY requirements.lock .
RUN pip install --no-cache-dir --require-hashes --prefix=/install -r requirements.lock

# Stage 2: Minimal non-root runtime
FROM python:3.11-slim@sha256:07d4824036af339fa1b6ef769cc99d9c10a141769538b52b3b597c84f7a7b535 AS runtime

RUN groupadd --system appgroup && \
    useradd --system --gid appgroup --home-dir /app --shell /usr/sbin/nologin appuser

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
COPY --from=builder /install /usr/local
COPY app/app.py ./app.py

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
