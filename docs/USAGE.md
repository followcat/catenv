# CatEnv 使用指南

## 快速开始

### 安装

```bash
git clone <your-repo-url> catenv
cd catenv
chmod +x install.sh
./install.sh
```

安装完成后，重启终端或执行：
```bash
source ~/.zshrc
```

## 工具使用说明

### 1. Neovim

#### 基础使用
```bash
nvim filename       # 打开文件
vim filename        # 也可以使用 vim（已设置别名）
v filename          # 快捷别名
```

#### 快捷键
- `Space + w` - 保存文件
- `Space + q` - 退出
- `Space + e` - 打开文件浏览器
- `Ctrl + h/j/k/l` - 窗口间导航
- `Tab / Shift+Tab` - 切换标签页

### 2. Pyenv (Python 版本管理)

#### 查看可安装的 Python 版本
```bash
pyenv install --list
```

#### 安装 Python
```bash
pyenv install 3.12.0        # 安装 Python 3.12.0
pyenv install 3.11.5        # 安装 Python 3.11.5
```

#### 设置 Python 版本
```bash
pyenv global 3.12.0         # 全局设置
pyenv local 3.11.5          # 当前目录设置
pyenv shell 3.10.0          # 当前 Shell 设置
```

#### 查看已安装版本
```bash
pyenv versions
```

#### 创建虚拟环境
```bash
pyenv virtualenv 3.12.0 myproject
pyenv activate myproject
pyenv deactivate
```

### 3. Rye (现代化 Python 项目管理)

#### 创建新项目
```bash
rye init myproject          # 创建新项目
cd myproject
```

#### 添加依赖
```bash
rye add requests            # 添加依赖
rye add pytest --dev        # 添加开发依赖
```

#### 同步依赖
```bash
rye sync                    # 安装所有依赖
```

#### 运行命令
```bash
rye run python script.py    # 在项目环境中运行
rye run pytest              # 运行测试
```

#### 管理 Python 版本
```bash
rye pin 3.12                # 设置项目 Python 版本
rye fetch 3.12              # 下载指定 Python 版本
```

#### 构建和发布
```bash
rye build                   # 构建包
rye publish                 # 发布到 PyPI
```

#### 常用命令
```bash
rye list                    # 列出依赖
rye remove package          # 移除依赖
rye lock                    # 锁定依赖版本
rye fmt                     # 格式化代码
rye lint                    # 代码检查
```

### 4. NVM (Node.js 版本管理)

#### 安装 Node.js
```bash
nvm install --lts           # 安装最新 LTS 版本
nvm install 18.17.0         # 安装指定版本
nvm install node            # 安装最新版本
```

#### 使用 Node.js 版本
```bash
nvm use --lts               # 使用 LTS 版本
nvm use 18.17.0             # 使用指定版本
nvm use default             # 使用默认版本
```

#### 设置默认版本
```bash
nvm alias default 18.17.0
```

#### 查看已安装版本
```bash
nvm ls
```

### 5. Zsh 和 Oh-My-Zsh

#### 常用插件

已启用的插件：
- `git` - Git 快捷命令和别名
- `zsh-autosuggestions` - 命令自动建议
- `zsh-syntax-highlighting` - 语法高亮
- `docker` - Docker 命令补全
- `python` - Python 相关功能
- `node` - Node.js 相关功能

#### 自定义配置

编辑 `~/.zshrc` 添加你的自定义配置：
```bash
vim ~/.zshrc
```

重新加载配置：
```bash
source ~/.zshrc
# 或使用别名
reload
```

### 6. fzf (模糊查找)

#### 快捷键
- `Ctrl + R` - 搜索历史命令
- `Ctrl + T` - 搜索文件
- `Alt + C` - 切换目录

#### 高级用法
```bash
# 在命令中使用
vim $(fzf)                  # 使用 fzf 选择文件打开

# 查找并预览文件
fzf --preview 'cat {}'

# 查找进程
ps aux | fzf

# 查找并删除文件
rm $(fzf -m)                # -m 允许多选
```

### 7. GitHub Copilot CLI

#### 安装
```bash
npm install -g @github/copilot
```

#### 认证
```bash
copilot auth
```

#### 使用

```bash
# 启动交互式聊天
copilot

# 直接提问
copilot "how to find large files"

# 使用别名
ask "explain this error message"
ghcp "create a bash script"
```

## 实用别名和函数

### 目录导航
```bash
..                  # cd ..
...                 # cd ../..
....                # cd ../../..
```

### Git 别名
```bash
gs                  # git status
ga                  # git add
gc                  # git commit
gp                  # git push
gl                  # git log (图形化)
gco                 # git checkout
```

### 自定义函数

#### 创建并进入目录
```bash
mkcd myproject      # mkdir -p myproject && cd myproject
```

#### 查找文件
```bash
ff "*.py"           # 查找所有 Python 文件
```

#### 解压文件
```bash
extract archive.tar.gz      # 自动识别并解压
```

#### 备份文件
```bash
backup important.txt        # 创建带时间戳的备份
```

## 故障排除

### Zsh 不是默认 Shell

手动设置：
```bash
chsh -s $(which zsh)
```

### 命令未找到

重新加载配置：
```bash
source ~/.zshrc
```

### Pyenv Python 版本问题

重新初始化：
```bash
eval "$(pyenv init -)"
```

### NVM 未加载

手动加载：
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### 插件不工作

检查插件是否已安装：
```bash
ls ~/.oh-my-zsh/custom/plugins/
```

重新安装插件：
```bash
cd ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting
```

## 进阶配置

### 更换 Zsh 主题

编辑 `~/.zshrc`：
```bash
ZSH_THEME="agnoster"        # 或其他主题
```

流行主题：
- `robbyrussell` (默认)
- `agnoster`
- `powerlevel10k`

### 添加更多插件

编辑 `~/.zshrc` 的 `plugins` 数组：
```bash
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    # 添加更多...
)
```

### 自定义 Neovim

编辑 `~/.config/nvim/init.vim` 或创建 `~/.config/nvim/init.lua`

推荐安装插件管理器如 vim-plug 或 packer.nvim

## 更多资源

- [Neovim 官方文档](https://neovim.io/doc/)
- [Oh-My-Zsh 插件列表](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [Pyenv GitHub](https://github.com/pyenv/pyenv)
- [NVM GitHub](https://github.com/nvm-sh/nvm)
- [fzf GitHub](https://github.com/junegunn/fzf)
