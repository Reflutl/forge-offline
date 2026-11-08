#!/usr/bin/env bash
# 从 hf-mirror.com 下载模型权重（不进 git）。用法:
#   ./download_models.sh            # 默认下载 SDXL base 1.0
#   ./download_models.sh sdxl sdxl-vae sd15 upscalers
#   HF_ENDPOINT=https://hf-mirror.com  可改；HF_TOKEN 可选（受限模型）
set -euo pipefail
cd "$(dirname "$0")"
EP="${HF_ENDPOINT:-https://hf-mirror.com}"
dl(){ # repo file dest_dir
  mkdir -p "$3"; local out="$3/$(basename "$2")"
  [ -s "$out" ] && { echo "已存在: $out"; return; }
  echo "==> $1/$2 -> $out"
  curl -fL --retry 5 -C - ${HF_TOKEN:+-H "Authorization: Bearer $HF_TOKEN"} -o "$out.part" "$EP/$1/resolve/main/$2" && mv "$out.part" "$out"
}
[ $# -eq 0 ] && set -- sdxl
for t in "$@"; do case "$t" in
  sdxl)      dl stabilityai/stable-diffusion-xl-base-1.0 sd_xl_base_1.0.safetensors models/Stable-diffusion ;;
  sdxl-vae)  dl madebyollin/sdxl-vae-fp16-fix sdxl.vae.safetensors models/VAE ;;
  sd15)      dl stable-diffusion-v1-5/stable-diffusion-v1-5 v1-5-pruned-emaonly.safetensors models/Stable-diffusion ;;
  upscalers) dl ai-forever/Real-ESRGAN RealESRGAN_x4.pth models/RealESRGAN ;;
  *) echo "未知目标: $t"; exit 1 ;;
esac; done
echo "完成。tokenizer/config 已随仓库在 backend/huggingface/，无需下载。"
