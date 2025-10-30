# 故障排除指南

## 安装后 nvm/node/npm 命令找不到

### 问题
安装完成后执行 `nvm`、`node` 或 `npm` 命令时提示：
```
zsh: command not found: nvm
zsh: command not found: node
zsh: command not found: npm
```

### 原因
安装脚本修改了 `~/.zshrc`，但当前 shell 会话还没有重新加载配置。

### 解决方案

**方案 1：重新加载配置（推荐）**
```bash
source ~/.zshrc
```

**方案 2：重启终端**
- 完全关闭终端应用
- 重新打开终端

**方案 3：启动新的 zsh 会话**
```bash
exec zsh
```

### 验证安装

重新加载后，验证工具是否可用：

```bash
# 检查 NVM
nvm --version

# 检查 Node.js
node --version

# 检查 npm
npm --version

# 检查 Pyenv
pyenv --version

# 检查 Neovim
nvim --version
```

## Pyenv 命令找不到

### 解决方案
```bash
# 重新加载配置
source ~/.zshrc

# 或手动加载 Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

## Oh-My-Zsh 插件不工作

### zsh-autosuggestions 不显示建议

检查插件是否已安装：
```bash
ls ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

如果不存在，手动安装：
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

然后重新加载：
```bash
source ~/.zshrc
```

### zsh-syntax-highlighting 不工作

检查插件是否已安装：
```bash
ls ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

如果不存在，手动安装：
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

然后重新加载：
```bash
source ~/.zshrc
```

## fzf 快捷键不工作

### Ctrl+R 不能搜索历史

检查 fzf 是否已安装：
```bash
fzf --version
```

如果未安装：
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

然后重新加载：
```bash
source ~/.zshrc
```

## Neovim 安装失败

### 下载失败

如果网络问题导致下载失败，可以手动安装：

```bash
# 下载最新版本
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# 解压安装
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# 创建符号链接
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# 验证
nvim --version
```

### 配置文件未生效

复制配置文件：
```bash
mkdir -p ~/.config/nvim
cp ~/Projects/catenv/config/init.vim ~/.config/nvim/init.vim
```

## bat 命令找不到

如果 fzf 预览提示 `bat: command not found`：

### Ubuntu/Debian
```bash
# 获取最新版本
BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

# 下载安装
cd /tmp
curl -LO "https://github.com/sharkdp/bat/releases/latest/download/bat_${BAT_VERSION}_amd64.deb"
sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb"
```

### macOS
```bash
brew install bat
```

## 权限问题

### chsh 失败

如果设置默认 shell 时提示权限错误：

```bash
# 检查 zsh 是否在允许的 shell 列表中
cat /etc/shells | grep zsh

# 如果没有，添加 zsh
which zsh | sudo tee -a /etc/shells

# 重新设置
chsh -s $(which zsh)
```

## GitHub Copilot CLI 问题

### 安装 Copilot CLI

```bash
# 确保 npm 可用
nvm use default
npm --version

# 全局安装
npm install -g @githubnext/github-copilot-cli

# 认证
github-copilot-cli auth
```

### 别名不工作

确保在 `~/.zshrc` 中有以下配置：
```bash
if command -v github-copilot-cli &> /dev/null; then
    eval "$(github-copilot-cli alias -- "$0")"
fi
```

然后重新加载：
```bash
source ~/.zshrc
```

## Python 版本问题

### pyenv install 失败

如果安装 Python 时失败，可能缺少依赖：

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl

# 然后重试
pyenv install 3.12.0
```

## 完全重新安装

如果遇到无法解决的问题，可以完全重新安装：

```bash
# 备份现有配置
cp ~/.zshrc ~/.zshrc.backup

# 删除已安装的工具
rm -rf ~/.oh-my-zsh
rm -rf ~/.fzf
rm -rf ~/.pyenv
rm -rf ~/.nvm
sudo rm -rf /opt/nvim-linux-x86_64
sudo rm /usr/local/bin/nvim

# 重新运行安装脚本
cd ~/Projects/catenv
./install.sh
```

## 获取帮助

如果以上方案都无法解决问题：

1. 检查安装日志（如果有）
2. 查看详细的错误信息
3. 在项目 GitHub 仓库提交 Issue
4. 提供以下信息：
   - 操作系统版本：`cat /etc/os-release`
   - Shell 版本：`echo $SHELL`
   - 错误的完整输出
