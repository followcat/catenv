" ============================================
" CatEnv Neovim Configuration
" ============================================

" 基础设置
set number                    " 显示行号
set relativenumber            " 显示相对行号
set cursorline                " 高亮当前行
set mouse=a                   " 启用鼠标支持
set clipboard=unnamedplus     " 使用系统剪贴板
set autoindent                " 自动缩进
set smartindent               " 智能缩进
set expandtab                 " 使用空格替代Tab
set tabstop=4                 " Tab宽度
set shiftwidth=4              " 缩进宽度
set softtabstop=4             " 软Tab宽度
set ignorecase                " 搜索时忽略大小写
set smartcase                 " 智能大小写搜索
set hlsearch                  " 高亮搜索结果
set incsearch                 " 增量搜索
set showmatch                 " 显示匹配的括号
set wrap                      " 自动换行
set linebreak                 " 在单词边界换行
set scrolloff=8               " 滚动时保持8行距离
set sidescrolloff=8           " 水平滚动时保持8列距离
set encoding=utf-8            " 编码设置
set fileencoding=utf-8        " 文件编码
set termguicolors             " 启用真彩色
set updatetime=300            " 更新时间
set timeoutlen=500            " 按键超时时间
set hidden                    " 允许隐藏未保存的缓冲区
set nobackup                  " 不创建备份文件
set nowritebackup             " 写入时不创建备份
set noswapfile                " 不创建交换文件
set undofile                  " 启用持久撤销
set undodir=~/.config/nvim/undo  " 撤销文件目录
set signcolumn=yes            " 始终显示标志列
set splitright                " 垂直分割时在右边打开
set splitbelow                " 水平分割时在下边打开

" 创建撤销目录
silent !mkdir -p ~/.config/nvim/undo

" ============================================
" 按键映射
" ============================================

" 设置 Leader 键
let mapleader = " "

" 保存和退出
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" 取消高亮
nnoremap <leader>h :nohlsearch<CR>

" 窗口导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 调整窗口大小
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" 标签页导航
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>

" 缓冲区导航
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" 移动行
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" 快速复制到行尾
nnoremap Y y$

" 保持视觉模式缩进
vnoremap < <gv
vnoremap > >gv

" ============================================
" 自动命令
" ============================================

augroup AutoCommands
    autocmd!
    " 保存时自动删除行尾空格
    autocmd BufWritePre * %s/\s\+$//e
    " 记住上次打开位置
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " 特定文件类型设置
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
    autocmd FileType javascript,typescript,json,yaml,html,css setlocal tabstop=2 shiftwidth=2 expandtab
    autocmd FileType go setlocal tabstop=4 shiftwidth=4 noexpandtab
augroup END

" ============================================
" 颜色主题
" ============================================

" 使用内置主题
try
    colorscheme slate
catch
    colorscheme default
endtry

" ============================================
" 状态栏
" ============================================

set laststatus=2              " 始终显示状态栏
set statusline=
set statusline+=\ %f          " 文件路径
set statusline+=\ %m          " 修改标志
set statusline+=\ %r          " 只读标志
set statusline+=%=            " 右对齐
set statusline+=\ %y          " 文件类型
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}  " 编码
set statusline+=\ [%{&fileformat}]  " 文件格式
set statusline+=\ %p%%        " 百分比
set statusline+=\ %l:%c       " 行号:列号

" ============================================
" 文件浏览器 (netrw)
" ============================================

let g:netrw_banner = 0        " 隐藏横幅
let g:netrw_liststyle = 3     " 树状视图
let g:netrw_browse_split = 4  " 在前一个窗口打开
let g:netrw_altv = 1
let g:netrw_winsize = 25

" 快捷键打开文件浏览器
nnoremap <leader>e :Explore<CR>
nnoremap <leader>v :Vexplore<CR>

" ============================================
" 注释
" ============================================

" 说明：
" 这是一个基础配置文件。如果需要更强大的功能，建议安装插件管理器：
" - vim-plug: https://github.com/junegunn/vim-plug
" - packer.nvim: https://github.com/wbthomason/packer.nvim
"
" 推荐插件：
" - nvim-tree.lua (文件浏览器)
" - telescope.nvim (模糊查找)
" - nvim-lspconfig (LSP 支持)
" - nvim-treesitter (语法高亮)
" - copilot.vim (GitHub Copilot)
" - lualine.nvim (状态栏)
