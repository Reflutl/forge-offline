#!/usr/bin/env bash
# 一次性安装依赖：全程不访问 github.com
#   PIP_INDEX_URL   PyPI 镜像（默认阿里云）
#   TORCH_INDEX_URL torch 源（默认阿里云 pytorch-wheels cu121 目录，用 -f 方式）
#   TORCH_SPEC      torch 版本（默认 torch==2.3.1+cu121 torchvision==0.18.1+cu121，对应 Forge 原设定）
#   XFORMERS_SPEC   默认 xformers==0.0.27（设为空则不装）
#   PYTHON          默认 python3；VENV_DIR 默认 ./venv（设 VENV_DIR=- 则不建 venv）
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$(pwd)"
PIP_INDEX_URL="${PIP_INDEX_URL:-https://mirrors.aliyun.com/pypi/simple}"
TORCH_INDEX_URL="${TORCH_INDEX_URL:-https://mirrors.aliyun.com/pytorch-wheels/cu121/}"
TORCH_SPEC="${TORCH_SPEC:-torch==2.3.1+cu121 torchvision==0.18.1+cu121}"
XFORMERS_SPEC="${XFORMERS_SPEC-xformers==0.0.27}"
PYTHON="${PYTHON:-python3}"
VENV_DIR="${VENV_DIR:-$ROOT/venv}"

if [ "$VENV_DIR" != "-" ]; then
  [ -d "$VENV_DIR" ] || "$PYTHON" -m venv "$VENV_DIR"
  PYTHON="$VENV_DIR/bin/python"
fi
PIP=("$PYTHON" -m pip --default-timeout=120)
export PIP_INDEX_URL

echo "==> pip 源: $PIP_INDEX_URL"
"${PIP[@]}" install -U pip wheel

echo "==> torch: $TORCH_SPEC  (from $TORCH_INDEX_URL)"
# shellcheck disable=SC2086
"${PIP[@]}" install $TORCH_SPEC -f "$TORCH_INDEX_URL"

if [ -n "$XFORMERS_SPEC" ]; then
  # shellcheck disable=SC2086
  "${PIP[@]}" install --no-deps $XFORMERS_SPEC || echo "!! xformers 安装失败，可去掉 --xformers 启动"
fi

echo "==> 本地 wheels（原 GitHub zip：clip / open_clip）"
"${PIP[@]}" install --no-deps "$ROOT"/wheels/*.whl
"${PIP[@]}" install ftfy regex

echo "==> requirements_versions.txt"
"${PIP[@]}" install -r requirements_versions.txt

echo "==> 内置扩展依赖（controlnet 预处理器，失败不致命）"
"${PIP[@]}" install fvcore mediapipe onnxruntime "opencv-python>=4.8.0" svglib || echo "!! 部分扩展依赖安装失败"

echo "==> 完成。下一步: ./download_models.sh  然后 ./webui-user.sh"
