#!/usr/bin/env bash
# AnythingLLM standalone launcher for Linux/macOS (Docker required).
set -euo pipefail
cd "$(dirname "$0")"
command -v docker >/dev/null || { echo 'Install Docker first: https://docs.docker.com/get-docker/'; exit 1; }
docker info >/dev/null || { echo 'Docker is not running. Start Docker first.'; exit 1; }
mkdir -p data
if [[ ! -f data/.env ]]; then
  command -v openssl >/dev/null || { echo 'openssl is required to generate an initial secret.'; exit 1; }
  printf 'JWT_SECRET=%s\n' "$(openssl rand -hex 32)" > data/.env
  chmod 600 data/.env
fi
docker compose -f compose.yaml pull
docker compose -f compose.yaml up -d
echo 'AnythingLLM is starting at http://localhost:3001'
echo 'First launch: choose/download a local model during onboarding.'
