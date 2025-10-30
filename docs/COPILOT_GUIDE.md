# GitHub Copilot CLI 使用指南

## 安装

### 新版本 (推荐)

```bash
npm install -g @github/copilot
```

### 旧版本

```bash
npm install -g @githubnext/github-copilot-cli
```

## 认证

### 新版本
```bash
copilot auth
```

### 旧版本
```bash
github-copilot-cli auth
```

按照提示在浏览器中完成 GitHub 授权。

## 基本使用

### 新版本 (@github/copilot)

```bash
# 启动交互式聊天
copilot

# 直接提问
copilot "how to find large files in Linux"

# 从文件读取上下文
copilot --file script.py "explain this code"

# 生成 shell 命令
copilot "compress all .log files"
```

### 旧版本 (@githubnext/github-copilot-cli)

```bash
# Shell 命令建议
?? how to find large files

# Git 命令建议
git? undo last commit

# GitHub CLI 建议
gh? create a new issue
```

## 在 Tmux 中使用 Copilot

Copilot CLI 非常适合在 Tmux 中运行，特别是对于长时间的对话或生成任务。

### 创建专用会话

```bash
# 创建 Copilot 专用会话
tmux new -s copilot

# 在会话中启动 Copilot
copilot

# 分离会话 (Ctrl+a d)
# 任务继续在后台运行

# 稍后重新连接
tmux attach -t copilot
```

### 多项目布局

```bash
# 创建工作区会话
tmux new -s workspace

# 窗口 0: 主项目 Copilot
copilot

# 创建新窗口 (Ctrl+a c)
# 窗口 1: 监控
htop

# 创建新窗口
# 窗口 2: 日志查看
tail -f ~/.copilot.log

# 在窗口间切换
Ctrl+a 0  # Copilot
Ctrl+a 1  # 监控
Ctrl+a 2  # 日志
```

### 分割窗格布局

```bash
# 创建会话
tmux new -s dev

# 垂直分割 (Ctrl+a |)
# 左侧: Copilot
copilot

# 右侧: 代码编辑器
Ctrl+a l  # 切换到右侧
nvim myproject/

# 布局:
# ┌─────────────┬─────────────┐
# │  Copilot    │    Neovim   │
# └─────────────┴─────────────┘
```

## 保存对话历史

Copilot 的输出可能很长，使用 Tmux 的超大缓冲区和保存功能：

```bash
# 进入复制模式查看历史
Ctrl+a [

# 保存整个对话历史到文件
Ctrl+a S
# 输入文件名: ~/copilot-conversation-2024-10-30.txt

# 或使用命令保存
tmux capture-pane -S -1000000 -p > copilot-history.txt
```

## 常见使用场景

### 1. 代码审查和重构

```bash
copilot --file mycode.py "review this code and suggest improvements"
```

### 2. 调试帮助

```bash
copilot "why am I getting this error: segmentation fault"
```

### 3. 学习新技术

```bash
copilot "explain kubernetes pods and deployments with examples"
```

### 4. 生成脚本

```bash
copilot "create a bash script to backup mysql database"
```

### 5. 系统管理任务

```bash
copilot "how to check disk usage and clean up space"
```

### 6. Git 操作

```bash
copilot "how to rebase my feature branch onto main"
```

## 实战案例

### 案例 1: 长时间代码生成任务

```bash
# 1. 在 Tmux 中创建会话
tmux new -s codegen

# 2. 启动 Copilot
copilot

# 3. 提出复杂需求
"Generate a complete REST API with authentication, user management, 
and database integration using Node.js and PostgreSQL"

# 4. 分离会话去做其他事情
Ctrl+a d

# 5. 随时回来查看进度
tmux attach -t codegen

# 6. 保存完整输出
Ctrl+a S
# 保存到: ~/generated-api-code.txt
```

### 案例 2: 多项目并行开发

```bash
# 项目 1
tmux new -s project-api
copilot "help me build a user authentication API"
Ctrl+a d

# 项目 2
tmux new -s project-frontend
copilot "help me create a React dashboard"
Ctrl+a d

# 项目 3
tmux new -s project-devops
copilot "help me set up CI/CD pipeline"
Ctrl+a d

# 查看所有会话
tmux ls

# 在项目间切换
tmux attach -t project-api
tmux attach -t project-frontend
tmux attach -t project-devops
```

### 案例 3: 远程开发

```bash
# 在远程服务器上
ssh user@remote-server

# 创建或恢复 Copilot 会话
tmux attach -t copilot || tmux new -s copilot

# 启动 Copilot 并工作
copilot

# 断开 SSH（Copilot 继续运行）
# 直接关闭终端

# 从家里重新连接
ssh user@remote-server
tmux attach -t copilot
# 所有对话历史都在！
```

## 最佳实践

### 1. 使用描述性会话名

```bash
# 好的命名
tmux new -s copilot-api-design
tmux new -s copilot-bug-fix
tmux new -s copilot-learning-rust

# 避免
tmux new -s work
tmux new -s temp
```

### 2. 定期保存重要对话

```bash
# 创建自动保存脚本
cat > ~/save-copilot-session.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d-%H%M%S)
tmux capture-pane -t copilot -S -1000000 -p > ~/copilot-logs/session-$DATE.txt
echo "Saved to ~/copilot-logs/session-$DATE.txt"
EOF

chmod +x ~/save-copilot-session.sh
```

### 3. 结合其他工具

```bash
# 在一个窗口中使用 Copilot 生成代码
# 在另一个窗口中测试代码
tmux split-window -h
# 左侧: copilot
# 右侧: python test.py

# 或使用多窗口
# 窗口 0: copilot
# 窗口 1: nvim
# 窗口 2: terminal for testing
```

### 4. 清晰的提问

```bash
# 不好的提问
copilot "help"

# 好的提问
copilot "explain the difference between async/await and promises in JavaScript with code examples"
```

### 5. 提供上下文

```bash
# 包含项目信息
copilot --file package.json "add testing framework to this project"

# 包含错误信息
copilot "I'm getting 'ECONNREFUSED' error when trying to connect to MongoDB. My connection string is mongodb://localhost:27017/mydb"
```

## 配置选项

### 环境变量

```bash
# 添加到 ~/.zshrc
export GITHUB_COPILOT_CHAT_MODEL="gpt-4"  # 使用特定模型
export GITHUB_COPILOT_VERBOSE=1            # 启用详细输出
```

### 自定义别名

```bash
# 添加到 ~/.zshrc
alias ghcp="copilot"
alias ghchat="copilot"
alias ask="copilot"
```

## 故障排除

### 认证问题

```bash
# 重新认证
copilot auth

# 检查认证状态
copilot auth status
```

### 命令未找到

```bash
# 检查安装
npm list -g @github/copilot

# 重新安装
npm install -g @github/copilot

# 检查 PATH
echo $PATH | grep nvm
```

### 性能问题

```bash
# 清除缓存
rm -rf ~/.copilot/cache

# 更新到最新版本
npm update -g @github/copilot
```

## 提示和技巧

💡 **使用 Tmux 的复制模式快速搜索输出**
```bash
Ctrl+a [      # 进入复制模式
/keyword      # 搜索关键词
n             # 下一个匹配
N             # 上一个匹配
```

💡 **创建快速启动脚本**
```bash
cat > ~/start-copilot.sh << 'EOF'
#!/bin/bash
tmux has-session -t copilot 2>/dev/null
if [ $? != 0 ]; then
    tmux new-session -s copilot -d
    tmux send-keys -t copilot 'copilot' C-m
fi
tmux attach -t copilot
EOF
chmod +x ~/start-copilot.sh
```

💡 **使用历史命令快速重启**
```bash
# 按 Ctrl+R 搜索历史中的 copilot 命令
Ctrl+R
# 输入 'copilot' 查找并执行
```

## 更多资源

- [GitHub Copilot CLI 官方文档](https://docs.github.com/en/copilot/github-copilot-in-the-cli)
- [Tmux 使用指南](./TMUX_GUIDE.md)
- [GitHub Copilot 最佳实践](https://github.blog/2023-06-20-how-to-write-better-prompts-for-github-copilot/)
