#!/usr/bin/env bash
set -e

# JupyterLab: Terminal + file tree + editor.
# This image is used as an interactive debug shell first.
# Ollama Forge / API services should be started manually inside JupyterLab
# until the full container entrypoint is confirmed.
JUPYTER_TOKEN="${JUPYTER_TOKEN:-change_me_please}"
JUPYTER_PORT="${JUPYTER_PORT:-8080}"

mkdir -p /workspace
cd /workspace

echo "[AI Forge] Starting JupyterLab on 0.0.0.0:${JUPYTER_PORT}"
echo "[AI Forge] Token: ${JUPYTER_TOKEN}"

exec jupyter lab \
  --ip=0.0.0.0 \
  --port="${JUPYTER_PORT}" \
  --no-browser \
  --ServerApp.token="${JUPYTER_TOKEN}" \
  --ServerApp.root_dir="/workspace" \
  --ServerApp.allow_origin="*"
