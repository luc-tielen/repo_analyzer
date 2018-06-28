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
    cp ./target/x86_64-unknown-linux-musl/release/repo_analyzer /tmp/artifacts/repo_analyzer && \
    strip -S /tmp/artifacts/repo_analyzer

# 2. Build frontend
FROM kkarczmarczyk/node-yarn:8.0-slim AS FRONTEND_STAGE

RUN mkdir -p /tmp/workdir /tmp/artifacts
WORKDIR /tmp/workdir

COPY frontend .
RUN echo "ELM_APP_API_URL=http://127.0.0.1:8000" >> .env && \
    yarn install && \
    yarn run elm-package install -- -y && \
    yarn build && \
    cp /tmp/workdir/dist/app.js /tmp/artifacts/app.js && \
    cp /tmp/workdir/dist/index.html /tmp/artifacts/index.html

# 3. Copy over artifacts into a clean, minimal third stage
FROM library/alpine:3.7

RUN mkdir -p /app/backend /app/frontend/static /app/frontend/src /app/repo
WORKDIR /app/backend

COPY --from=BACKEND_STAGE /tmp/artifacts/repo_analyzer /app/backend
COPY --from=FRONTEND_STAGE /tmp/artifacts/app.js /app/frontend/src/
COPY --from=FRONTEND_STAGE /tmp/artifacts/index.html /app/frontend/src/

EXPOSE 8000
VOLUME /app/repo
ENV REPO_DIR=/app/repo
ENV ROCKET_ADDRESS=0.0.0.0

CMD "./repo_analyzer"

