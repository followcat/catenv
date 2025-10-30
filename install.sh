#!/usr/bin/env bash

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    log_info "检测到操作系统: $OS"
}

# 安装系统依赖
install_dependencies() {
    log_info "安装系统依赖..."
    
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        sudo apt update
        sudo apt install -y \
            build-essential \
            curl \
            wget \
            git \
            zsh \
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
    elif [[ "$OS" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            log_info "安装 Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install openssl readline sqlite3 xz zlib
    fi
    
    log_success "系统依赖安装完成"
}

# 安装 Neovim
install_neovim() {
    log_info "安装 Neovim..."
    
    if command -v nvim &> /dev/null; then
        log_warning "Neovim 已安装，跳过"
        return
    fi
    
    if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
        # 从 GitHub 下载最新发布版
        log_info "从 GitHub 下载 Neovim 最新发布版..."
        
        # 获取最新版本号
        NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
        log_info "最新版本: $NVIM_VERSION"
        
        # 下载并安装
        cd /tmp
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
        rm nvim-linux64.tar.gz
        
    elif [[ "$OS" == "macos" ]]; then
        brew install neovim
    fi
    
    # 创建配置目录
    mkdir -p ~/.config/nvim
    
    # 复制配置文件（如果存在）
    if [ -f "config/init.vim" ]; then
        cp config/init.vim ~/.config/nvim/init.vim
        log_info "Neovim 配置文件已复制"
    fi
    
    log_success "Neovim 安装完成"
}

# 安装 Pyenv
install_pyenv() {
    log_info "安装 Pyenv..."
    
    if [ -d "$HOME/.pyenv" ]; then
        log_warning "Pyenv 已安装，跳过"
        return
    fi
    
    curl https://pyenv.run | bash
    
    log_success "Pyenv 安装完成"
}

# 安装 NVM
install_nvm() {
    log_info "安装 NVM..."
    
    if [ -d "$HOME/.nvm" ]; then
        log_warning "NVM 已安装，跳过"
        return
    fi
    
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # 加载 NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # 安装最新 LTS 版本的 Node.js
    if command -v nvm &> /dev/null; then
        log_info "安装 Node.js LTS..."
        nvm install --lts
        nvm use --lts
    fi
    
    log_success "NVM 安装完成"
}

# 安装 Oh-My-Zsh
install_oh_my_zsh() {
    log_info "安装 Oh-My-Zsh..."
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warning "Oh-My-Zsh 已安装，跳过"
    else
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        log_success "Oh-My-Zsh 安装完成"
    fi
}

# 安装 Zsh 插件
install_zsh_plugins() {
    log_info "安装 Zsh 插件..."
    
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
        log_success "zsh-autosuggestions 安装完成"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        log_success "zsh-syntax-highlighting 安装完成"
    fi
    
    # fzf
    if [ ! -d "$HOME/.fzf" ]; then
        log_info "安装 fzf..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
        log_success "fzf 安装完成"
    fi
    
    # bat (可选，用于 fzf 预览)
    if ! command -v bat &> /dev/null; then
        log_info "安装 bat (更好的 cat)..."
        if [[ "$OS" == "ubuntu" ]] || [[ "$OS" == "debian" ]]; then
            # 从 GitHub 下载最新版 bat
            BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')
            cd /tmp
            curl -LO "https://github.com/sharkdp/bat/releases/latest/download/bat_${BAT_VERSION}_amd64.deb"
            sudo dpkg -i "bat_${BAT_VERSION}_amd64.deb"
            rm "bat_${BAT_VERSION}_amd64.deb"
            log_success "bat 安装完成"
        elif [[ "$OS" == "macos" ]]; then
            brew install bat
            log_success "bat 安装完成"
        fi
    else
        log_info "bat 已安装"
    fi
}

# 配置 Zsh
configure_zsh() {
    log_info "配置 Zsh..."
    
    # 备份现有配置
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
        log_info "已备份现有 .zshrc"
    fi
    
    # 使用自定义配置
    if [ -f "config/.zshrc" ]; then
        cp config/.zshrc ~/.zshrc
        log_info "已应用自定义 .zshrc 配置"
    else
        # 创建基础配置
        cat > ~/.zshrc << 'EOF'
# Oh-My-Zsh 配置
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# 插件配置
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    kubectl
    python
    node
    npm
)

source $ZSH/oh-my-zsh.sh

# Pyenv 配置
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# NVM 配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fzf 配置
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 自定义别名
alias vim="nvim"
alias vi="nvim"
alias ls="ls --color=auto"
alias ll="ls -lah"
alias la="ls -A"
alias grep="grep --color=auto"

# GitHub Copilot CLI 别名（安装后可用）
if command -v github-copilot-cli &> /dev/null; then
    eval "$(github-copilot-cli alias -- "$0")"
fi

EOF
        log_info "已创建基础 .zshrc 配置"
    fi
    
    log_success "Zsh 配置完成"
}

# 设置 Zsh 为默认 Shell
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "设置 Zsh 为默认 Shell..."
        chsh -s $(which zsh)
        log_success "默认 Shell 已设置为 Zsh"
        log_warning "请重新登录或重启终端以使更改生效"
    else
        log_info "Zsh 已经是默认 Shell"
    fi
}

# 打印安装完成信息
print_completion_message() {
    echo ""
    log_success "============================================"
    log_success "  CatEnv 开发环境安装完成！"
    log_success "============================================"
    echo ""
    log_info "接下来的步骤："
    echo ""
    echo "  1. 重启终端或执行: source ~/.zshrc"
    echo ""
    echo "  2. 安装 Python (可选):"
    echo "     pyenv install 3.12.0"
    echo "     pyenv global 3.12.0"
    echo ""
    echo "  3. Node.js 已自动安装，验证:"
    echo "     node --version"
    echo "     npm --version"
    echo ""
    echo "  4. 安装 GitHub Copilot CLI:"
    echo "     npm install -g @githubnext/github-copilot-cli"
    echo "     github-copilot-cli auth"
    echo ""
    echo "  5. 快捷键提示:"
    echo "     Ctrl+R - 搜索历史命令 (fzf)"
    echo "     Ctrl+T - 搜索文件"
    echo "     Alt+C  - 切换目录"
    echo ""
    log_info "享受你的新开发环境！🚀"
    echo ""
}

# 主函数
main() {
    log_info "开始安装 CatEnv 开发环境..."
    echo ""
    
    detect_os
    
    if [[ "$OS" == "unknown" ]]; then
        log_error "不支持的操作系统"
        exit 1
    fi
    
    install_dependencies
    install_neovim
    install_pyenv
    install_nvm
    install_oh_my_zsh
    install_zsh_plugins
    configure_zsh
    set_default_shell
    
    print_completion_message
}

# 执行主函数
main "$@"
