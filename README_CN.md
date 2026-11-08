# Forge 自包含版（不访问 github.com）

基于 lllyasviel/stable-diffusion-webui-forge `dfdcbab685e57677014f05a3309b48cc87383167`。
所有原本启动/运行时要从 GitHub 拉的东西都已放进本仓库；pip 包走 PyPI 镜像（默认阿里云）；模型权重走 hf-mirror.com。

## 使用
```bash
git clone <本仓库地址> forge && cd forge
./install.sh            # 建 venv，装 torch(cu121)/xformers/本地 whl/requirements
./download_models.sh    # 默认下 SDXL base；可加: sdxl-vae sd15 upscalers
./webui-user.sh --listen --port 8080 --api --xformers --cuda-malloc
```
可选环境变量：`PIP_INDEX_URL`、`TORCH_INDEX_URL`（默认 https://mirrors.aliyun.com/pytorch-wheels/cu121/）、
`TORCH_SPEC`、`XFORMERS_SPEC`（设空不装）、`VENV_DIR`（`-` 表示用当前 Python）、`HF_ENDPOINT`。
换 CUDA 版本示例：`TORCH_INDEX_URL=https://mirrors.aliyun.com/pytorch-wheels/cu118/ TORCH_SPEC="torch==2.3.1+cu118 torchvision==0.18.1+cu118" ./install.sh`

## 仓库里放了什么（原来自 GitHub）
| 内容 | 原地址 | commit | 本地位置 |
|---|---|---|---|
| CLIP (pip) | github.com/openai/CLIP zip | d50d76daa670286dd6cacf3bcd80b5e4823fc8e1 | wheels/clip-1.0-py3-none-any.whl |
| open_clip (pip) | github.com/mlfoundations/open_clip zip | bb6e834e9c70d9c27d0dc3ecedeebeaeb1ffad6b | wheels/open_clip_torch-2.7.0-py3-none-any.whl |
| assets | AUTOMATIC1111/stable-diffusion-webui-assets | 6f7db241d2f8ba7457bac5ca9753331f0c266917 | repositories/stable-diffusion-webui-assets |
| huggingface_guess | lllyasviel/huggingface_guess | 84826248b49bb7ca754c73293299c4d4e23a548d | repositories/huggingface_guess |
| BLIP | salesforce/BLIP | 48211a1594f1321b00f14c9f7a5b4813144b2fb9 | repositories/BLIP |
| VAE-approx 预览模型 | AUTOMATIC1111 releases v1.0.0-pre | - | models/VAE-approx/ |
| TAESD 预览模型 | madebyollin/taesd (main) | - | models/VAE-taesd/ |

注意：requirements_versions.txt 固定 `open-clip-torch==2.20.0`（PyPI），安装后会覆盖本地 2.7.0 whl，这与官方行为一致；本地 whl 仅保证 launch 检查时不去 GitHub。

## 代码改动
- `modules/launch_utils.py`：`git_clone()` 遇到已存在且无 `.git` 的目录直接跳过（否则会 `git rev-parse` 到外层仓库导致去 fetch）；CLIP/OPENCLIP 默认指向 `wheels/`。
- `modules/ui_extensions.py`：扩展索引默认 URL 置空（"Available" 标签页不再访问 raw.githubusercontent.com）。

## 仍可能访问 GitHub 的点（仅在主动使用时）
- 放大/修脸模型首次使用时自动下载（ESRGAN、RealESRGAN、SwinIR、ScuNET、DAT、GFPGAN、CodeFormer、DeepDanbooru、facexlib）：请自行把权重放到 models/ 对应目录。
- Interrogate CLIP 的类别文本、autocrop 的 face_detection_yunet.onnx、ControlNet 预处理器权重（部分在 HF）。
- 扩展页手动“从 URL 安装”、`--update-check`、`--update-all-extensions`。
- Forge Spaces（forge_space_*）通过 huggingface_hub 下载，设置了 HF_ENDPOINT=hf-mirror.com。
