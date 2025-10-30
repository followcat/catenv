# CatEnv - Development Environment Setup

自动化安装和配置开发环境的工具集。

## 功能特性

- ✅ 安装最新版 Neovim
- ✅ 安装和配置 Pyenv (Python 版本管理)
- ✅ 安装和配置 Rye (现代化 Python 项目管理)
- ✅ 安装和配置 NVM (Node.js 版本管理)
- ✅ 安装和配置 Zsh + Oh-My-Zsh
- ✅ 安装 fzf (强大的历史命令浏览工具)
- ✅ 安装 zsh-autosuggestions (命令自动补全)
- ✅ 安装 zsh-syntax-highlighting (语法高亮)
- ✅ GitHub Copilot CLI 配置

## 快速开始

```bash
# 克隆项目
git clone <your-repo-url> catenv
cd catenv

# 执行安装
./install.sh
```

## 安装内容

### Neovim
- 从官方源安装最新稳定版
- 包含基础配置

### Pyenv
- Python 版本管理工具
- 自动配置环境变量

### Rye
- 现代化的 Python 项目和包管理工具
- 一站式解决方案：依赖管理、虚拟环境、打包发布
- 自动配置环境变量

### NVM
- Node.js 版本管理工具
- 自动安装最新 LTS 版本

### Zsh & Oh-My-Zsh
- 现代化的 Shell
- 丰富的插件生态系统
- 自定义主题和配置

### Tmux
- 终端复用器，支持多窗口和窗格
- 超大历史缓冲区（100万行）
- 会话持久化，可以断开重连
- 优化用于长时间运行的任务（如 Copilot CLI）
- 支持远程会话管理

### 系统工具
- **htop**: 交互式系统监控工具
- **screen**: 终端复用备选方案

### Shell 增强插件
- **fzf**: 模糊查找工具，Ctrl+R 浏览历史命令
- **bat**: 增强版 cat，支持语法高亮（用于 fzf 预览）
- **zsh-autosuggestions**: 基于历史的命令建议
- **zsh-syntax-highlighting**: 命令语法高亮

### GitHub Copilot CLI
- 配置说明和使用指南

## 使用说明

### ⚠️ 重要：安装后必须重新加载配置

安装完成后，**必须**执行以下操作之一：

**方案 1：重新加载配置（推荐）**
```bash
source ~/.zshrc
```

**方案 2：重启终端**
```bash
exec zsh
```

**方案 3：关闭并重新打开终端应用**

### 安装后需要做的

1. 验证工具是否可用：
```bash
nvm --version    # 检查 NVM
node --version   # 检查 Node.js
npm --version    # 检查 npm
pyenv --version  # 检查 Pyenv
rye --version    # 检查 Rye
nvim --version   # 检查 Neovim
```

2. 安装 Python 版本（可选）：
```bash
# 使用 Pyenv
pyenv install 3.12.0
pyenv global 3.12.0

# 或使用 Rye（推荐用于项目）
rye init myproject
cd myproject
rye sync
```

3. 安装 Node.js（已自动安装 LTS 版本）：
```bash
nvm install --lts
nvm use --lts
```

4. 安装 GitHub Copilot CLI：
```bash
npm install -g @github/copilot
copilot auth
```

### 快捷键

#### Zsh/fzf
- `Ctrl + R`: 使用 fzf 搜索历史命令
- `Ctrl + T`: 使用 fzf 搜索文件
- `Alt + C`: 使用 fzf 切换目录

#### Tmux（前缀键：Ctrl+a）
- `Ctrl+a |`: 垂直分割窗格
- `Ctrl+a -`: 水平分割窗格
- `Ctrl+a h/j/k/l`: 切换窗格（Vim 风格）
- `Ctrl+a c`: 创建新窗口
- `Ctrl+a d`: 分离会话
- `Ctrl+a S`: 保存历史到文件

## 系统要求

- Ubuntu/Debian 或 macOS
- curl
- git
- sudo 权限

## 自定义配置

所有配置文件位于 `config/` 目录：
- `config/.zshrc`: Zsh 配置
- `config/.tmux.conf`: Tmux 配置
- `config/init.vim`: Neovim 配置

## 故障排除

如果遇到问题，可以查看日志文件：
```bash
tail -f install.log
```

## 许可证

MIT License
