# Tmux 使用指南

## 简介

Tmux 是一个强大的终端复用器，允许你：
- 在一个终端窗口中管理多个会话
- 分离和重新连接会话（保持任务运行）
- 分割窗口为多个窗格
- 在不同机器上访问同一会话

## 为什么使用 Tmux 运行 Copilot CLI？

1. **会话持久化**：即使断开连接，任务继续运行
2. **多地访问**：可以在家里开始任务，在公司继续
3. **超大历史**：100万行缓冲区，不会丢失输出
4. **多窗格**：同时监控多个任务
5. **容易恢复**：意外断开连接后可以立即恢复

## 基本概念

### 层级结构
```
Server (tmux 守护进程)
├── Session 1 (会话)
│   ├── Window 1 (窗口)
│   │   ├── Pane 1 (窗格)
│   │   └── Pane 2
│   └── Window 2
│       └── Pane 1
└── Session 2
    └── Window 1
        └── Pane 1
```

### 前缀键
- CatEnv 配置使用 `Ctrl+a` 作为前缀键（类似 screen）
- 所有 tmux 命令都以前缀键开始

## 快速开始

### 创建和管理会话

```bash
# 创建新会话
tmux new -s copilot

# 创建带名称的会话并运行命令
tmux new -s work -c ~/projects

# 列出所有会话
tmux ls

# 连接到会话
tmux attach -t copilot
# 或简写
tmux a -t copilot

# 分离会话（任务继续运行）
# 在 tmux 中按：Ctrl+a d

# 杀死会话
tmux kill-session -t copilot

# 杀死所有会话
tmux kill-server
```

### 典型工作流程 - 运行 Copilot CLI

```bash
# 1. 创建专用会话
tmux new -s copilot-work

# 2. 在 tmux 中运行 Copilot CLI
github-copilot-cli

# 3. 分离会话（Ctrl+a d）
# 现在可以关闭终端，任务继续运行

# 4. 稍后重新连接
tmux attach -t copilot-work

# 5. 查看历史输出（上下滚动）
# 按 Ctrl+a [ 进入复制模式，使用方向键或 PgUp/PgDn 滚动
# 按 q 退出复制模式
```

## 窗口管理

### 窗口操作

```bash
# 在 tmux 会话中：

# 创建新窗口
Ctrl+a c

# 切换到下一个窗口
Ctrl+a n

# 切换到上一个窗口
Ctrl+a p

# 切换到指定窗口（0-9）
Ctrl+a 0-9

# 列出所有窗口
Ctrl+a w

# 重命名当前窗口
Ctrl+a ,

# 关闭当前窗口
Ctrl+a &
# 或直接
exit
```

### 实际应用

```bash
# 窗口 0: 运行 Copilot CLI
Ctrl+a c
github-copilot-cli

# 窗口 1: 监控系统
Ctrl+a c
htop

# 窗口 2: 查看日志
Ctrl+a c
tail -f app.log

# 在窗口间快速切换
Ctrl+a 0  # Copilot
Ctrl+a 1  # htop
Ctrl+a 2  # logs
```

## 窗格管理

### 窗格操作

```bash
# 垂直分割（左右）
Ctrl+a |

# 水平分割（上下）
Ctrl+a -

# 切换窗格（Vim 风格）
Ctrl+a h  # 左
Ctrl+a j  # 下
Ctrl+a k  # 上
Ctrl+a l  # 右

# 调整窗格大小
Ctrl+a H  # 向左扩展
Ctrl+a J  # 向下扩展
Ctrl+a K  # 向上扩展
Ctrl+a L  # 向右扩展

# 显示窗格编号
Ctrl+a q

# 关闭当前窗格
Ctrl+a x
# 或直接
exit

# 最大化/恢复当前窗格
Ctrl+a z
```

### 实际布局示例

```bash
# 创建监控仪表板
tmux new -s dashboard

# 1. 水平分割
Ctrl+a -

# 2. 上窗格运行 Copilot
github-copilot-cli

# 3. 切换到下窗格
Ctrl+a j

# 4. 垂直分割下窗格
Ctrl+a |

# 5. 左下窗格运行 htop
htop

# 6. 右下窗格显示日志
Ctrl+a l
tail -f ~/.copilot.log

# 最终布局：
# ┌─────────────────────┐
# │   Copilot CLI       │
# ├──────────┬──────────┤
# │  htop    │   logs   │
# └──────────┴──────────┘
```

## 复制模式和历史记录

### 进入复制模式

```bash
# 进入复制模式（可以滚动和复制）
Ctrl+a [

# 或
Ctrl+a Escape
```

### 在复制模式中（Vi 风格）

```bash
# 移动
h, j, k, l    # 左、下、上、右
Ctrl+u        # 上翻半页
Ctrl+d        # 下翻半页
Ctrl+b        # 上翻一页
Ctrl+f        # 下翻一页
g             # 跳到历史开始
G             # 跳到历史结束

# 搜索
/             # 向前搜索
?             # 向后搜索
n             # 下一个匹配
N             # 上一个匹配

# 选择和复制
v             # 开始选择
V             # 行选择
Ctrl+v        # 矩形选择
y             # 复制选中内容
Enter         # 复制并退出

# 退出复制模式
q             # 退出
Escape        # 退出
```

### 保存历史到文件

```bash
# 在 tmux 中保存历史
Ctrl+a S
# 然后输入文件名，例如：~/copilot-history.txt

# 或使用命令
tmux capture-pane -S -1000000
tmux save-buffer ~/copilot-output.txt
```

## 高级功能

### 同步所有窗格

```bash
# 开启同步（所有窗格同时接收相同输入）
Ctrl+a S

# 关闭同步
Ctrl+a S  # 再次按下切换
```

### 会话管理

```bash
# 在 tmux 中切换会话
Ctrl+a s

# 重命名会话
Ctrl+a $

# 会话树视图
Ctrl+a w
```

### 查看所有按键绑定

```bash
# 列出所有快捷键
Ctrl+a ?
```

## 实战案例

### 案例 1: 长时间运行 Copilot CLI 任务

```bash
# 1. 创建会话
tmux new -s copilot-longrun

# 2. 运行长时间任务
github-copilot-cli
?? generate a complex project structure

# 3. 分离会话
Ctrl+a d

# 4. 几小时后重新连接
tmux a -t copilot-longrun

# 5. 查看所有历史输出
Ctrl+a [
# 滚动查看
g  # 跳到开始
```

### 案例 2: 多项目同时开发

```bash
# 项目 1
tmux new -s project1
cd ~/projects/project1
github-copilot-cli
Ctrl+a d

# 项目 2
tmux new -s project2
cd ~/projects/project2
github-copilot-cli
Ctrl+a d

# 项目 3
tmux new -s project3
cd ~/projects/project3
github-copilot-cli
Ctrl+a d

# 列出所有会话
tmux ls

# 切换项目
tmux a -t project1
tmux a -t project2
tmux a -t project3
```

### 案例 3: 远程服务器持久工作

```bash
# 在远程服务器上
ssh user@remote-server

# 创建或连接到会话
tmux new -s remote-work
# 或
tmux a -t remote-work

# 运行任务
github-copilot-cli

# 断开 SSH（tmux 会话继续运行）
# 直接关闭终端即可

# 从另一台机器重新连接
ssh user@remote-server
tmux a -t remote-work
# 所有工作都还在！
```

## 配置文件说明

CatEnv 的 Tmux 配置（`~/.tmux.conf`）包含：

### 核心特性
- ✅ 前缀键: `Ctrl+a`（更符合习惯）
- ✅ 历史缓冲: 100万行（足够长时间任务）
- ✅ 鼠标支持: 可以用鼠标切换窗格
- ✅ Vi 模式: 使用 Vi 快捷键复制
- ✅ 系统剪贴板: 自动集成
- ✅ 美化状态栏: 显示时间、日期、主机名

### 自定义快捷键
- `Ctrl+a r`: 重新加载配置
- `Ctrl+a |`: 垂直分割
- `Ctrl+a -`: 水平分割
- `Ctrl+a h/j/k/l`: Vim 风格导航
- `Ctrl+a S`: 保存历史到文件

## 故障排除

### Tmux 无法启动

```bash
# 检查是否安装
which tmux

# 重新安装
sudo apt install tmux  # Ubuntu/Debian
brew install tmux      # macOS
```

### 会话消失

```bash
# 检查 tmux 服务器是否运行
ps aux | grep tmux

# 列出所有会话
tmux ls
```

### 鼠标不工作

```bash
# 确保配置中有
set -g mouse on

# 重新加载配置
Ctrl+a r
```

### 复制到剪贴板不工作

```bash
# Ubuntu/Debian 安装 xclip
sudo apt install xclip

# macOS 自带 pbcopy
```

## 最佳实践

1. **命名规范**: 使用有意义的会话名
   ```bash
   tmux new -s copilot-feature-x
   tmux new -s monitoring
   tmux new -s dev-server
   ```

2. **定期保存历史**: 对于重要输出
   ```bash
   Ctrl+a S  # 保存到文件
   ```

3. **使用窗口**: 不同任务用不同窗口
   ```bash
   # 窗口 0: 主任务
   # 窗口 1: 监控
   # 窗口 2: 日志
   ```

4. **分离而非退出**: 保持会话运行
   ```bash
   Ctrl+a d  # 分离（推荐）
   exit      # 退出（会关闭会话）
   ```

5. **定期清理**: 删除不需要的会话
   ```bash
   tmux kill-session -t old-session
   ```

## 更多资源

- [Tmux 官方文档](https://github.com/tmux/tmux/wiki)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
- [A Quick and Easy Guide to tmux](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

## 小贴士

💡 **Pro Tip**: 在 SSH 断开时，tmux 会话会保持运行。这对于长时间任务非常有用！

💡 **Pro Tip**: 使用 `tmux attach` 时加上 `-d` 参数可以强制其他客户端断开：
```bash
tmux attach -dt copilot
```

💡 **Pro Tip**: 创建一个启动脚本自动设置你的工作环境：
```bash
#!/bin/bash
tmux new -s work -d
tmux send-keys -t work:0 'cd ~/projects && github-copilot-cli' C-m
tmux split-window -t work:0 -h
tmux send-keys -t work:0.1 'htop' C-m
tmux attach -t work
```
