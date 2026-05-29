#!/usr/bin/env bash
set -euo pipefail

FORGE_API_HOST="${FORGE_API_HOST:-0.0.0.0}"
FORGE_API_PORT="${FORGE_API_PORT:-8001}"
OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5:0.5b}"
PULL_MODEL_ON_START="${PULL_MODEL_ON_START:-1}"

mkdir -p /workspace
cd /workspace

echo "[AI Forge] Starting Ollama server..."
ollama serve > /root/ollama.log 2>&1 &

for i in $(seq 1 60); do
  if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    echo "[AI Forge] Ollama is ready."
    break
  fi
  sleep 2
  if [ "$i" = "60" ]; then
    echo "[AI Forge] Ollama did not become ready. Last log:"
    tail -80 /root/ollama.log || true
    exit 1
  fi
done

if [ "$PULL_MODEL_ON_START" = "1" ]; then
  echo "[AI Forge] Pulling model: ${OLLAMA_MODEL}"
  ollama pull "${OLLAMA_MODEL}"
fi

echo "[AI Forge] Starting Ollama Forge API on ${FORGE_API_HOST}:${FORGE_API_PORT}"
exec python -m uvicorn ollama_forge_api:app --host "${FORGE_API_HOST}" --port "${FORGE_API_PORT}"
