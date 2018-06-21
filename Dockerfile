# 1. Build backend in release mode
FROM clux/muslrust:nightly-2018-06-09 AS BACKEND_STAGE

RUN apt-get update && \
    apt-get install -y cmake && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /tmp/workdir /tmp/artifacts
WORKDIR /tmp/workdir

COPY backend .
RUN cargo build --release && \
    cp ./target/x86_64-unknown-linux-musl/release/repo_analyzer /tmp/artifacts/repo_analyzer_backend && \
    strip -S /tmp/artifacts/repo_analyzer_backend

# 2. Build frontend in release mode
FROM kkarczmarczyk/node-yarn:8.0-slim AS FRONTEND_STAGE

RUN mkdir -p /tmp/workdir /tmp/artifacts
WORKDIR /tmp/workdir

COPY frontend .
RUN yarn install && \
    yarn run elm-make Main.elm -- --output=/tmp/artifacts/app.js

# 3. Copy over artifacts into a clean, minimal third stage
FROM library/alpine:3.7

RUN mkdir -p /app/backend /app/frontend/static/js /app/repo
WORKDIR /app/backend

COPY --from=BACKEND_STAGE /tmp/artifacts/repo_analyzer_backend /app/backend
COPY --from=FRONTEND_STAGE /tmp/artifacts/app.js /app/frontend/static/js
COPY frontend/static/ /app/frontend/static

EXPOSE 8000
VOLUME /app/repo
ENV REPO_DIR=/app/repo
ENV ROCKET_ADDRESS=0.0.0.0

CMD "./repo_analyzer_backend"

