#!/usr/bin/env bash
# 直接从 ModelScope API 下载（绕过坏掉的 cdn-lfs.modelscope.cn）
#   MODEL_REPO  默认 ABCount/wai_n_sfw
#   MODEL_FILE  默认 waiIllustriousSDXL_v140.safetensors
#   REVISION    默认 master
set -euo pipefail
cd "$(dirname "$0")"
MODEL_REPO="${MODEL_REPO:-ABCount/wai_n_sfw}"
MODEL_FILE="${MODEL_FILE:-waiIllustriousSDXL_v140.safetensors}"
REVISION="${REVISION:-master}"
DEST="models/Stable-diffusion"
mkdir -p "$DEST"
OUT="$DEST/$MODEL_FILE"
URL="https://www.modelscope.cn/api/v1/models/${MODEL_REPO}/repo?Revision=${REVISION}&FilePath=${MODEL_FILE}"
if [ -f "$OUT" ] && [ "$(stat -c%s "$OUT" 2>/dev/null || echo 0)" -gt 1000000000 ]; then
  echo "已存在 $OUT，跳过"; exit 0
fi
echo "==> $URL"
curl -L --retry 20 --retry-all-errors --continue-at - -o "$OUT" "$URL"
echo "==> 完成: $(ls -lh "$OUT")"
