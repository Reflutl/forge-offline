#!/usr/bin/env bash
# 从 ModelScope 下载模型（国内直连，不访问 GitHub / HF）
#   MODEL_REPO  默认 ABCount/wai_n_sfw
#   MODEL_FILE  默认 waiIllustriousSDXL_v140.safetensors
set -euo pipefail
cd "$(dirname "$0")"
PY="${PYTHON:-python3}"
MODEL_REPO="${MODEL_REPO:-ABCount/wai_n_sfw}"
MODEL_FILE="${MODEL_FILE:-waiIllustriousSDXL_v140.safetensors}"
DEST="models/Stable-diffusion"
mkdir -p "$DEST"
command -v modelscope >/dev/null 2>&1 || "$PY" -m pip install modelscope -i "${PIP_INDEX_URL:-https://mirrors.aliyun.com/pypi/simple}"
if [ -f "$DEST/$MODEL_FILE" ]; then echo "已存在 $DEST/$MODEL_FILE，跳过"; exit 0; fi
modelscope download --model "$MODEL_REPO" "$MODEL_FILE" --local_dir "$DEST"
echo "==> 完成: $DEST/$MODEL_FILE"
