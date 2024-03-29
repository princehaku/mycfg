#color{{{
autoload colors
colors
 
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
#}}}
 
#命令提示符
#RPROMPT=$(echo "$RED%D %T$FINISH")
PROMPT=$(echo "$CYAN%n@$YELLOW%M:$GREEN%/$_YELLOW>$FINISH ")
 
#PROMPT=$(echo "$BLUE%M$GREEN%/
#$CYAN%n@$BLUE%M:$GREEN%/$_YELLOW>>>$FINISH ")
#标题栏、任务栏样式{{{
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term)
precmd () { print -Pn "\e]0;%n@%M//%/\a" }
preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" }
;;
esac
#}}}

#默认的一些路径
if [[ ! -d $HOME/.zsh ]] ; then mkdir -p $HOME/.zsh ;fi
if [[ ! -d $HOME/.trash ]] ; then mkdir -p $HOME/.trash ;fi

export TODAY=$(date +%Y-%m-%d)
#编辑器
export EDITOR=vim
#输入法
export XMODIFIERS="@im=ibus"
export QT_MODULE=ibus
export GTK_MODULE=ibus
#关于历史纪录的配置 {{{
#历史纪录条目数量
export HISTSIZE=10000
#注销后保存的历史纪录条目数量
export SAVEHIST=10000
#历史纪录文件
export HISTFILE=~/.zsh/history
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
 
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
 
#在命令前添加空格，不将此命令添加到纪录文件中
#setopt HIST_IGNORE_SPACE     
#}}}
 
#每个目录使用独立的历史纪录{{{
#cd() {
#builtin cd "$@"                             # do actual cd
#fc -W                                       # write current history  file
#local HISTDIR="$HOME/.zsh_history$PWD"      # use nested folders for history
#if  [ ! -d "$HISTDIR" ] ; then          # create folder if needed
#mkdir -p "$HISTDIR"
#fi
#export HISTFILE="$HISTDIR/zhistory"     # set new history file
#touch $HISTFILE
#local ohistsize=$HISTSIZE
#HISTSIZE=0                              # Discard previous dir's history
#HISTSIZE=$ohistsize                     # Prepare for new dir's history
#fc -R                                       #read from current histfile
#}
#mkdir -p $HOME/.zsh_history$PWD
#export HISTFILE="$HOME/.zsh_history$PWD/zhistory"
 
#function allhistory { cat $(find $HOME/.zsh_history -name zhistory) }
#function convhistory {
#sort $1 | uniq |
#sed 's/^:\([ 0-9]*\):[0-9]*;\(.*\)/\1::::::\2/' |
#awk -F"::::::" '{ $1=strftime("%Y-%m-%d %T",$1) "|"; print }' 
#}
#使用 histall 命令查看全部历史纪录
#function histall { convhistory =(allhistory) |
#sed '/^.\{20\} *cd/i\\' }
#使用 hist 查看当前目录历史纪录
#function hist { convhistory $HISTFILE }
 
#全部历史纪录 top50
# function top50 { allhistory | awk -F':[ 0-9]*:[0-9]*;' '{ $1="" ; print }' | sed 's/ /\n/g' | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 50 }
# 
#}}}
 
#杂项 {{{
#允许在交互模式中使用注释  例如：
#cmd #这是注释
setopt INTERACTIVE_COMMENTS
 
#启用自动 cd，输入目录名回车进入目录
#稍微有点混乱，不如 cd 补全实用
#setopt AUTO_CD
 
#扩展路径
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word
 
#禁用 core dumps
limit coredumpsize 0
 
#Emacs风格 键绑定
bindkey -e
#设置 一些常用键位
bindkey '\e[1~' beginning-of-line       # Home
bindkey '\e[2~' overwrite-mode          # Insert
bindkey "\e[3~" delete-char
bindkey '\e[4~' end-of-line             # End
 
#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}
 
#自动补全功能 {{{
setopt AUTO_LIST
setopt AUTO_MENU
#开启此选项，补全时会直接选中菜单项
#setopt MENU_COMPLETE
 
autoload -U compinit
compinit
 
#自动补全缓存
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/.zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd
 
#自动补全选项
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
 
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
 
#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

#彩色补全菜单
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
 
#修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正     
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
 
#kill 命令补全     
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
 
#补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'
 
# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}
 
##行编辑高亮模式 {{{
# Ctrl+@ 设置标记，标记和光标点之间为 region
zle_highlight=(region:bg=magenta #选中区域
special:bold      #特殊字符
isearch:underline)#搜索时使用的关键字
#}}}
 
##空行(光标在行首)补全 "cd " {{{
user-complete(){
case $BUFFER in
"" )                       # 空行填入 "cd "
BUFFER="cd "
zle end-of-line
zle expand-or-complete
;;
"cd --" )                  # "cd --" 替换为 "cd +"
BUFFER="cd +"
zle end-of-line
zle expand-or-complete
;;
"cd +-" )                  # "cd +-" 替换为 "cd -"
BUFFER="cd -"
zle end-of-line
zle expand-or-complete
;;
* )
zle expand-or-complete
;;
esac
}
zle -N user-complete
bindkey "\t" user-complete
#}}}
 
##在命令前插入 sudo {{{
#定义功能
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line                 #光标移动到行末
}
zle -N sudo-command-line
#定义快捷键为： ctrl+G
bindkey "^G" sudo-command-line
#}}}
 
 
 
##for Emacs {{{
#在 Emacs终端 中使用 Zsh 的一些设置 不推荐在 Emacs 中使用它
#if [[ "$TERM" == "dumb" ]]; then
#setopt No_zle
#PROMPT='%n@%M %/
#>>'
#alias ls='ls -F'
#fi    
#}}}
 
#{{{自定义补全
#补全 ping
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com
 
#补全 ssh scp sftp 等
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
#}}}
 
 
####{{{
function timeconv { date -d @$1 +"%Y-%m-%d %T" } 
# }}}
 
zmodload zsh/mathfunc
autoload -U zsh-mime-setup
zsh-mime-setup
setopt EXTENDED_GLOB
#autoload -U promptinit
#promptinit
#prompt redhat
 
setopt correctall
autoload compinstall
 
#漂亮又实用的命令高亮界面
setopt extended_glob
 TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
  
 recolor-cmd() {
     region_highlight=()
     colorize=true
     start_pos=0
     for arg in ${(z)BUFFER}; do
         ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
         ((end_pos=$start_pos+${#arg}))
         if $colorize; then
             colorize=false
             res=$(LC_ALL=C builtin type $arg 2>/dev/null)
             case $res in
                 *'reserved word'*)   style="fg=magenta,bold";;
                 *'alias for'*)       style="fg=cyan,bold";;
                 *'shell builtin'*)   style="fg=yellow,bold";;
                 *'shell function'*)  style='fg=green,bold';;
                 *"$arg is"*)        
                     [[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";;
                 *)                   style='none,bold';;
             esac
             region_highlight+=("$start_pos $end_pos $style")
         fi
         [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
         start_pos=$end_pos
     done
 }
check-cmd-self-insert() { zle .self-insert && recolor-cmd }
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }
  
zle -N self-insert check-cmd-self-insert
zle -N backward-delete-char check-cmd-backward-delete-char
# fp 加文件名直接显示文件绝对路径
function fp() {
	readlink -f $1
}

function synchosts() {
	sudo cp $HOME/C/Windows/System32/drivers/etc/hosts /etc/hosts
	sudo sed -ie "s/\r//g" /etc/hosts
}

# 和最新版本同步
function syncremotecfg() {
	if [[ ! -z $1 ]] ; then
		 rm -rf $HOME/.zsh/.sync$TODAY
	fi
	
	if [[ ! -f $HOME/.zsh/.sync$TODAY ]] ; then
		echo "Syncing"
		cd $HOME
		wget -q 'http://lab.3haku.net/cfg/cfg.zip'; unzip -o -q cfg.zip;/bin/rm cfg.zip -rf
		chmod 700 $HOME/.ssh -R
		touch $HOME/.zsh/.sync
		/bin/rm $HOME/.zsh/.sync* -rf
		touch $HOME/.zsh/.sync$TODAY
		if [[ ! -e $HOME/.vim ]] ; then
			mv .vimme $HOME/.vim
			mkdir $HOME/.vim/backup
		fi
		if [[ ! -e $HOME/.ssh ]] ; then
			mv .sshme $HOME/.ssh
		fi
		rm -rf .sshme
		rm -rf .vimme
	fi
}


### by 3haku.net
function saferm() {
	ops_array=($*)
	if [[ -z $1 ]] ;then
		echo 'Missing Args'
		return
	fi
	J=0
	offset=0
	# for zsh
	if [[ -z ${ops_array[0]} ]] ; then
		offset=1
	fi
	while [[ $J -lt $# ]] ; do
		p_posi=$(($J + $offset))
		dst_name=${ops_array[$p_posi]}
		J=$(($J+1))
		# 忽略-开头的参数
		if [[ `echo ${dst_name} | cut -c 1` == '-' ]] ; then
		    continue
		fi
		# 如果文件或链接不存在就跳过
		if [[ ! ( -a $dst_name || -h $dst_name) ]] ; then
		  echo $dst_name' Not Existed'
			continue
		fi
    	# garbage collect
    	now=$(date +%s)
    	for s in $(ls --indicator-style=none $HOME/.trash/) ;do
			dir_date=${s//_/-}
			dir_time=$(date +%s -d $dir_date)
        	dir_name=${s//-/_}
        	# if big than one month then delete
        	if [[ 0 -eq dir_time || $(($now - $dir_time)) -gt 2592000 ]] ;then
            	echo "Trash " $dir_name " has Gone "
           		/bin/rm $HOME/.trash/$dir_name -rf
        	fi
    	done
    
    	# add new folder
    	prefix=$(date +%Y_%m_%d)
    	hour=$(date +%H)
 	    mkdir -p $HOME/.trash/$prefix/$hour
		  echo "Trashing " $dst_name
		  dst_path=$HOME/.trash/$prefix/$hour/$dst_name
    	if [[ -a $dst_path || -h $dst_path ]] ; then
    	    /bin/rm -rf $dst_path
    	fi
    	mv $dst_name $HOME/.trash/$prefix/$hour
	done
}

#####  for bzw

#路径别名 {{{
#进入相应的路径时只要 cd ~xxx
hash -d A="/home/admin/"
hash -d W="~/htdocs/"
#}}}

 
#命令别名 {{{
alias ls='ls -F --color=auto'
alias ll='ls -al'
alias grep='grep --color=auto'
alias rm=saferm
alias reloadcfg='source .zshrc'
 
#[Esc][h] man 当前命令时，显示简短说明
alias run-help >&/dev/null && unalias run-help
autoload run-help
 
#历史命令 top10
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}}

export PATH=$PATH:~/software/maven/bin/:~/hosts/:~/scripts/

# source the users bashrc if it exists
if [ -f "${HOME}/.zsh_me" ] ; then
  source "${HOME}/.zsh_me"
fi


