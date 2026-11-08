# forge-offline

基于 stable-diffusion-webui-forge（commit dfdcbab6），只改了一件事：**启动时不再访问 github.com**。

- `repositories/` 内置了 assets、huggingface_guess、BLIP（原本启动时 git clone）
- `wheels/` 内置了 clip、open_clip（原本启动时从 GitHub zip 安装）
- `modules/launch_utils.py`：仓库目录已存在就不 fetch；clip/open_clip 默认用本地 whl
- 其余与原版一致：torch 用你环境里已有的，缺的 pip 依赖仍由 launch 自动补装

## 用法（和原版一样）
```
git clone https://v4.gh-proxy.org/https://github.com/Reflutl/forge-offline.git
cd forge-offline
export PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple   # 可选
python launch.py --listen --port 8080 --api --xformers
```

## 可选：下载模型（ModelScope）
`./download_models.sh` 默认下载 waiIllustriousSDXL_v140 到 models/Stable-diffusion/，
可用 `MODEL_REPO=... MODEL_FILE=...` 换模型。
