#!/usr/bin/env bash

# CatEnv 配置测试脚本

echo "=========================================="
echo "  CatEnv Configuration Test"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

test_passed=0
test_failed=0

# 测试函数
test_command() {
    local name=$1
    local cmd=$2
    
    echo -n "Testing $name... "
    if eval "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((test_passed++))
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((test_failed++))
    fi
}

# 测试配置文件
echo "Testing configuration files:"
test_command ".zshrc" "[ -f ~/.zshrc ]"
test_command ".tmux.conf" "[ -f ~/.tmux.conf ]"
test_command "nvim config" "[ -f ~/.config/nvim/init.vim ]"
echo ""

# 测试命令可用性
echo "Testing installed tools:"
test_command "zsh" "command -v zsh"
test_command "tmux" "command -v tmux"
test_command "htop" "command -v htop"
test_command "screen" "command -v screen"
test_command "nvim" "command -v nvim"
test_command "fzf" "command -v fzf"
test_command "bat" "command -v bat"
test_command "git" "command -v git"
echo ""

# 测试环境变量（在新的 zsh 会话中）
echo "Testing environment setup:"
test_command "NVM available" "zsh -c 'source ~/.zshrc && command -v nvm'"
test_command "Node.js available" "zsh -c 'source ~/.zshrc && command -v node'"
test_command "Pyenv available" "zsh -c 'source ~/.zshrc && command -v pyenv'"
test_command "Rye available" "zsh -c 'source ~/.zshrc && command -v rye'"
echo ""

# 测试 fzf 按键绑定
echo "Testing fzf integration:"
test_command "fzf in PATH" "zsh -c 'source ~/.zshrc && command -v fzf'"
test_command "fzf version" "~/.fzf/bin/fzf --version"
echo ""

# 测试 Oh-My-Zsh 插件
echo "Testing Oh-My-Zsh plugins:"
test_command "zsh-autosuggestions" "[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]"
test_command "zsh-syntax-highlighting" "[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]"
echo ""

# 总结
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$test_passed${NC}"
echo -e "Failed: ${RED}$test_failed${NC}"
echo ""

if [ $test_failed -eq 0 ]; then
    echo -e "${GREEN}All tests passed! ✓${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Run: source ~/.zshrc"
    echo "  2. Test fzf: Press Ctrl+R to search history"
    echo "  3. Test tmux: tmux new -s test"
    echo "  4. Install Node.js: nvm install --lts"
    echo "  5. Install Python: pyenv install 3.12.0"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    echo "Please check the output above for details."
    exit 1
fi
