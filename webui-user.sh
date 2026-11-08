#!/usr/bin/env bash
# 启动包装：所有原 GitHub 依赖指向仓库内本地副本，默认 --skip-install，不访问 github.com
cd "$(dirname "$0")"
ROOT="$(pwd)"
[ -x "$ROOT/venv/bin/python" ] && export PATH="$ROOT/venv/bin:$PATH"
PY="${PYTHON:-python}"

export CLIP_PACKAGE="\"$ROOT/wheels/clip-1.0-py3-none-any.whl\""
export OPENCLIP_PACKAGE="\"$ROOT/wheels/open_clip_torch-2.7.0-py3-none-any.whl\""
# 下面几个仓库已以普通文件形式放在 repositories/，launch 看到目录存在（无 .git）直接跳过
export ASSETS_REPO="$ROOT/repositories/stable-diffusion-webui-assets"
export HUGGINGFACE_GUESS_REPO="$ROOT/repositories/huggingface_guess"
export BLIP_REPO="$ROOT/repositories/BLIP"
export WEBUI_EXTENSIONS_INDEX=""
export PIP_INDEX_URL="${PIP_INDEX_URL:-https://mirrors.aliyun.com/pypi/simple}"
export HF_ENDPOINT="${HF_ENDPOINT:-https://hf-mirror.com}"
export GRADIO_ANALYTICS_ENABLED=False
export TORCH_COMMAND="${TORCH_COMMAND:-pip install torch==2.3.1+cu121 torchvision==0.18.1+cu121 -f https://mirrors.aliyun.com/pytorch-wheels/cu121/}"

COMMANDLINE_ARGS="${COMMANDLINE_ARGS:---skip-install --skip-python-version-check}"
# shellcheck disable=SC2086
exec "$PY" launch.py $COMMANDLINE_ARGS "$@"
