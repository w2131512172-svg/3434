#!/usr/bin/env bash
set -e

# JupyterLab: Terminal + 文件树 + 编辑器
# 生产环境建议你改成强一点的 token（或用 Cloudflare Access）
JUPYTER_TOKEN="${JUPYTER_TOKEN:-change_me_please}"

mkdir -p /workspace
cd /workspace

exec jupyter lab \
  --ip=0.0.0.0 --port=8888 \
  --no-browser \
  --ServerApp.token="${JUPYTER_TOKEN}" \
  --ServerApp.root_dir="/workspace" \
  --ServerApp.allow_origin="*"
