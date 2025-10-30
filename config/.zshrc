# ============================================
# CatEnv Zsh Configuration
# ============================================

# Oh-My-Zsh 配置
export ZSH="$HOME/.oh-my-zsh"

# 主题设置（可选择: robbyrussell, agnoster, powerlevel10k等）
ZSH_THEME="robbyrussell"

# 插件配置
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    docker-compose
    kubectl
    python
    pip
    node
    npm
    yarn
    sudo
    history
    copyfile
    copypath
    dirhistory
    jsontools
)

# 加载 Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ============================================
# 环境变量配置
# ============================================

# Pyenv 配置
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# Rye 配置
if [ -f "$HOME/.rye/env" ]; then
    source "$HOME/.rye/env"
fi

# NVM 配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# fzf 配置
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf 高级配置
if command -v bat &> /dev/null; then
    # 如果安装了 bat，使用 bat 预览
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --preview 'bat --color=always --style=numbers --line-range=:500 {}'
        --preview-window=right:60%
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-a:select-all'
    "
else
    # 否则使用 cat 预览
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --preview 'cat {}'
        --preview-window=right:60%
        --bind 'ctrl-/:toggle-preview'
        --bind 'ctrl-a:select-all'
    "
fi

# 使用 fd 替代 find（如果已安装）
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# 编辑器配置
export EDITOR='nvim'
export VISUAL='nvim'

# ============================================
# 别名配置
# ============================================

# Neovim 别名
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# ls 别名（使用 exa 如果已安装，否则使用 ls）
if command -v exa &> /dev/null; then
    alias ls="exa --icons"
    alias ll="exa -lah --icons"
    alias la="exa -a --icons"
    alias lt="exa --tree --level=2 --icons"
else
    alias ls="ls --color=auto"
    alias ll="ls -lah"
    alias la="ls -A"
fi

# 目录导航
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git 别名
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --all"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"

# 其他实用别名
alias grep="grep --color=auto"
alias df="df -h"
alias du="du -h"
alias free="free -h"
alias mkdir="mkdir -p"
alias h="history"
alias c="clear"
alias reload="source ~/.zshrc"

# Python 相关
alias py="python"
alias py3="python3"
alias venv="python -m venv"
alias activate="source venv/bin/activate"

# Docker 相关
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"

# ============================================
# 函数定义
# ============================================

# 创建并进入目录
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 快速查找文件
ff() {
    find . -type f -iname "*$1*"
}

# 快速查找目录
fd() {
    find . -type d -iname "*$1*"
}

# 提取各种压缩文件
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' 无法被提取" ;;
        esac
    else
        echo "'$1' 不是一个有效的文件"
    fi
}

# 创建备份文件
backup() {
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# GitHub Copilot CLI 别名
if command -v github-copilot-cli &> /dev/null; then
    eval "$(github-copilot-cli alias -- "$0")"
fi

# ============================================
# 历史命令配置
# ============================================

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# 历史命令配置选项
setopt HIST_IGNORE_ALL_DUPS  # 删除重复的历史记录
setopt HIST_FIND_NO_DUPS     # 搜索时不显示重复
setopt HIST_SAVE_NO_DUPS     # 保存时不保存重复
setopt HIST_REDUCE_BLANKS    # 删除多余空格
setopt SHARE_HISTORY         # 多个终端共享历史
setopt APPEND_HISTORY        # 追加而不是覆盖历史文件
setopt INC_APPEND_HISTORY    # 立即追加到历史文件

# ============================================
# 欢迎信息
# ============================================

# 显示系统信息（可选）
if command -v neofetch &> /dev/null; then
    neofetch
fi

# 提示信息
echo "🐱 Welcome to CatEnv! Type 'help' for available commands."
