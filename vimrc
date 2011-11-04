"--------------------------------------------------------------------------- 
" 全局定义
"--------------------------------------------------------------------------- 
" For pathogen.vim: auto load all plugins in .vim/bundle
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"----------------------------------------------------
" 获取平台等函数
"----------------------------------------------------
function! MySys()
    if has("win32") || has("win64")
    :   return "windows"
    elseif has("mac")
        return "mac"
    else
        return "linux"
    endif
endfunction

" 获取当前目录
func! GetPWD()
    return substitute(getcwd(), "", "", "g")
endf

" 返回当前时期
func! GetDateStamp()
    return strftime('%Y-%m-%d')
endfunction

" 全选
func! SelectAll()
    let s:current = line('.')
    exe "norm gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endfunc



"--------------------------------------------------------------------------- 
" 常规设置
"--------------------------------------------------------------------------- 
set nocompatible			" 不兼容旧版本的vi的mode
set bs=2					" 允许backspace在insert mode下正常使用
set showcmd					" 显示命令
set history=500				" 保持500个命令纪录
set ruler					" 总是显示光标所在的位置，在右下
set autoread				" 当文件在外边被修改的时候，自动重新读取
set linespace=2				" 行高
set lines=45				" 设置多少行
"set mouse=a
set dy=lastline				"显示最多行，不用@@
" 下面两条设置并不在终端下执行，原因是终端下会报错
if has('gui_running')
	set autochdir			" 自动切换当前目录为当前文件所在的目录
	set autoread			" 当文件在外部被修改，自动更新该文件
endif


filetype on					" 开启文件类型侦测
filetype indent on			" 为特定文件类型载入相关缩进文件
filetype plugin on			" 为特定文件类型载入相关插件


" 当vimrc文件被修改时，自动读取
autocmd! bufwritepost .vimrc source ~/.vimrc	


syntax on					" 开启语法高亮
set hlsearch				" 高亮搜索词



"--------------------------------------------------------------------------- 
" 外观设置
"--------------------------------------------------------------------------- 
if has( "gui_running" )
"	set guifont=Osaka-Mono:h14;
	set background=dark
	set guifont=Monaco:h12
	set guifontwide=Monaco:h12
	"set transparency=5
	
	set t_Co=256			" 256色模式
	colors moria
else
	color vgod
endif

if has("gui_macvim")

	set columns=182
	set lines=40
    winpos 0 0

    let macvim_skip_cmd_opt_movement = 1
    let macvim_hig_shift_movement = 1

	set guioptions=mcr		" 只显示菜单
	set guioptions=			" 隐藏全部的gui选项
	"set guioptions+=r		" 显示gui右边滚动条
	"set transp=12
	"set transparency=10
    "关闭工具栏
    set guioptions-=T "egmrt
    "set guioptions+=b

	set guioptions+=e
	" 使用 MacVim 原生的全屏幕功能
	let s:lines=&lines
	let s:columns=&columns
	func! FullScreenEnter()
		set lines=999 columns=999
		set fu
	endf

	func! FullScreenLeave()
		let &lines=s:lines
		let &columns=s:columns
		set nofu
	endf

	func! FullScreenToggle()
		if &fullscreen
			call FullScreenLeave()
		else
			call FullScreenEnter()
		endif
	endf
endif



"set clipboard=unnamed		" yank to the system register (*) by default    让xx系统的command+c 和 vim的p共用剪贴板
set showmatch				" 高亮匹配的括号
set showmode				" 显示当前模式
set wildchar=<TAB>			" 用<TAB>键开始命令栏的提示
set wildmenu				" 开始狂野模式

set wildignore=*.o,*.class,*.pyc	" 当狂野模式显示提示时，不包括这些文件


set autoindent				" 开启自动对齐
set smartindent
set incsearch				" 开启增量搜索
set nobackup				" 不开启文件备份的功能
set copyindent				" 拷贝时，同时拷贝自动缩进产生的缩进
"set ignorecase				" 搜索时忽略大小写
set smartcase				" 如果搜索的patten全都是小写，那么大小写敏感 PS：为啥没用呢
set smarttab				" 根据内容在一行的开始插入tabs


"--------------------------------------------------------------------------- 
" AutoCmd 自动执行
"--------------------------------------------------------------------------- 
if has("autocmd")
	" 让vim记录文件关闭时的位置，下次打开时直接跳至上会关闭时的位置
	if has("autocmd")
		au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	endif
endif



"--------------------------------------------------------------------------- 
" 关掉声音和错误
"--------------------------------------------------------------------------- 
"set noerrorbells
"set novisualbell
"set t_vb=
"set tm=500


"--------------------------------------------------------------------------- 
" TAB的设置
"--------------------------------------------------------------------------- 
"set expandtab				"replace <TAB> with spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab				" 不要用空格代替制表符 

"au FileType Makefile set noexpandtab



"--------------------------------------------------------------------------- 
" laststatus的设置
"--------------------------------------------------------------------------- 
set laststatus=2
set statusline=\ %{HasPaste()}%<%-12.25(%f%)%m%r%h\ %w\ 
"set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=格式:[%Y/%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ \ \ ASCII:[%03.3b]
"set statusline+=\ \ \ %<%20.100(路径:%{CurDir()}%)/%f\ 
set statusline+=\ \ \ %<%20.100(路径:%{CurDir()}%)/\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")	" 获取当前路径，将$HOME转化为~
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction



"--------------------------------------------------------------------------- 
" C/C++的设置
"--------------------------------------------------------------------------- 
"autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30


"--------------------------------------------------------------------------- 
"Restore cursor to file position in previous editing session
"--------------------------------------------------------------------------- 
"set viminfo='10,\"100,:20,%,n~/.viminfo
"au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif


"--------------------------------------------------------------------------- 
" Tip #382: Search for <cword> and replace with input() in all open buffers 
"--------------------------------------------------------------------------- 
fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 


"--------------------------------------------------------------------------- 
" 自定义快捷键
"--------------------------------------------------------------------------- 
let mapleader=","			" 设置leader为,
let g:mapleader=","			" 设置全局leader

map <leader>bc :botright cope<CR>	" 开启错误console 就是quickfix模式


"--------------------------------------------------------------------------- 
" 开启自动填充 Enable omni completion. (Ctrl-X Ctrl-O)
"--------------------------------------------------------------------------- 
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete



"--------------------------------------------------------------------------- 
" use syntax complete if nothing else available
"--------------------------------------------------------------------------- 
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
				\	if &omnifunc == "" |
				\		setlocal omnifunc=syntaxcomplete#Complete |
				\	endif
endif

" make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css



"--------------------------------------------------------------------------- 
" ENCODING SETTINGS
"---------------------------------------------------------------------------
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk,big5,ucs-bom,gb18030,gb2312,cp936

fun! ViewUTF8()
	set encoding=utf-8                                  
	set termencoding=big5
endfun

fun! UTF8()
	set encoding=utf-8                                  
	set termencoding=big5
	set fileencoding=utf-8
	set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
	set encoding=big5
	set fileencoding=big5
endfun


"--------------------------------------------------------------------------- 
" PLUGIN SETTINGS
"---------------------------------------------------------------------------
set shellslash
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

"--------------------------------------------------------
" NERDtree插件
"--------------------------------------------------------
" 打开vim时自动打开
nmap <silent> <leader>nt :NERDTree
nmap <silent> <leader>nm :NERDTreeMirror<cr>
nmap <silent> <leader>nc :NERDTreeClose<cr>

let NERDChristmasTree=1						" 让树更好看,我是没看出来
let NERDTreeCaseSensitiveSort=1				" 让文件排列更有序
let NERDTreeChDirMode=1						" 改变tree目录的同时改变工程的目录
let NERDTreeHijackNetrw=1					" 当输入 [:e filename]不再显示netrw,而是显示nerdtree
let NERDTreeWinPos="right"
let NERDTreeBookmarksFile='/Users/colin/.vim/NERDTreeBookmarks'
let NERDTreeHighlightCursorline=0 " 当前选项为高亮
let NERDTreeWinSize=28 " 设置宽度


"--------------------------------------------------------
" NeoComplCache插件
"--------------------------------------------------------
let g:acp_enableAtStartup = 0								" Disable AutoComplPop.
"let g:neocomplcache_enable_at_startup = 1					" Use neocomplcache.
"let g:NeoComplCache_DisableAutoComplete = 1
let g:neocomplcache_enable_smart_case = 1					" Use smartcase.
let g:neocomplcache_enable_camel_case_completion = 1		" Use camel case completion.
"let g:neocomplcache_enable_underbar_completion = 1			" Use underbar completion.
let g:neocomplcache_min_syntax_length = 3					" Set minimum syntax keyword length.
"let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

"--------------------------------------------------------
" superTab插件安装
"--------------------------------------------------------
" Use neocomplcache. 
let g:neocomplcache_enable_at_startup = 1 
" Use smartcase. 
let g:neocomplcache_enable_smart_case = 1 
let g:neocomplcache_disable_auto_complete = 1 
let g:SuperTabDefaultCompletionType = "context" 
let g:SuperTabRetainCompletionType=2 
"let g:SuperTabDefaultCompletionType="<C-X><C-O>"

"--------------------------------------------------------
" 和谐相处
"--------------------------------------------------------
let g:NeoComplCache_DisableAutoComplete = 1
let g:SuperTabDefaultCompletionType = '<C-X><C-U>'

"--------------------------------------------------------
" MRU设置
"--------------------------------------------------------
nmap <silent> <leader>r :MRU<cr>

"--------------------------------------------------------
" commant-T设置
"--------------------------------------------------------
"let g:CommandTMaxHeight = 10
nmap <silent> <Leader>t :CommandT

" 为了取消commandT的快捷键
"nmap <silent> <D-t> :tabe<CR>
"nmap <silent> <Leader>tt :tabe<CR>


"--------------------------------------------------------
" c.vim设置
"--------------------------------------------------------
let c_comment_strings = 1
nmap <Leader>rc \rc
nmap <Leader>rr \rr


"--------------------------------------------------------
" xptemplate.vim设置
"--------------------------------------------------------
let g:xptemplate_key = '<Tab>'
let g:xptemplate_key_pum_only = '<S-Tab>'
let g:xptemplate_always_show_pum = 1
let g:xptemplate_highlight = "current"
let g:xptemplate_vars = 'SPop=&Sparg='
let g:xptemplate_snippet_folders = [$HOME . '/my_snippets', '/all_user_snippets' ]
" 兼容supertab
" avoid key conflict
let g:SuperTabMappingForward = '<Plug>supertabKey'

" if nothing matched in xpt, try supertab
let g:xptemplate_fallback = '<Plug>supertabKey'

" use <tab>/<S-tab> to navigate through pum. Optional
" let g:xptemplate_pum_tab_nav = 1

" xpt triggers only when you typed whole name of a snippet. Optional
let g:xptemplate_minimal_prefix = 'full'


"--------------------------------------------------------
" map 快捷键映射
"--------------------------------------------------------
nmap <Tab>		v>
nmap <S-Tab>	v<
vmap <Tab>		>gv
vmap <S-Tab>	<gv
nmap fe :e
nmap fw	:w<CR>
nmap fq	:q<CR>
nmap fx	:x<CR>
nmap faa :qa<CR>
nmap fl	<C-w>l
nmap fh	<C-w>h
nmap fj	<C-w>j
nmap fk	<C-w>k
"if MySys() == "mac"
	"map <D-y> <C-y>
	"map <D-e> <C-e>
	"map <D-f> <C-f>
	"map <D-b> <C-b>
	"map <D-u> <C-u>
	"map <D-d> <C-d>
	"map <D-w> <C-w>
	"map <D-r> <C-r>
	"map <D-o> <C-o>
	"map <D-i> <C-i>
	"map <D-g> <C-g>
	"map <D-a> <C-a>
	"map <D-]> <C-]>
	"cmap <D-d> <C-d>
	"imap <D-e> <C-e>
	"imap <D-y> <C-y>
"endif


"--------------------------------------------------------
"--------------------------------------------------------
"let my_terminal = conque_term#open('/bin/bash')

let g:ConqueTerm_StartMessages = 1					"如果系统配置有问题，则显示信息
"let my_subprocess = conque_term#subprocess('source /Users/colin/.bash_profile')
"nmap <silent> <Leader>ba :call conque_term#get_instance().writeln('ls/Users/colin')<CR>
"nnoremap <F4> :call conque_term#open('/bin/bash').writeln('source /Users/colin/.bash_profile && cd')<CR>
nnoremap <Leader>ba :call conque_term#open('/bin/bash').writeln('source /Users/colin/.bash_profile && cd ~/data/unix')<CR><CR>
"nmap <silent> <Leader>ba :conque_term#open('/bin/bash').writeln('ls /Users/colin/')<CR>
"nmap <silent> <Leader>ba :ConqueTerm bash<CR>
"nmap <silent> <Leader>bat :ConqueTermTab bash<CR>
nnoremap <Leader>v :vsplit ~/data/unix/unix.c<CR>

" 自动括号补全
":inoremap ( ()<ESC>i 
":inoremap ) <c-r>=ClosePair(')')<CR> 
":inoremap { {}<ESC>i 
":inoremap } <c-r>=ClosePair('}')<CR> 
":inoremap [ []<ESC>i 
":inoremap ] <c-r>=ClosePair(']')<CR> 
":inoremap < <><ESC>i 
":inoremap > <c-r>=ClosePair('>')<CR> 
":inoremap " ""<ESC>i 
":inoremap ' ''<ESC>i 
