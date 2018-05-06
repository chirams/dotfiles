# .bashrc


# Source global definitions {{{
# ----------------------------------------------------------------------------------------------------

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# }}}


# Source environment definitions {{{
# ----------------------------------------------------------------------------------------------------

if [ -d ~/.local/bash/ ]; then
    for file in `\find ~/.local/bash/ -maxdepth 1 -type f`; do
        . $file
    done
fi

# }}}


# Source local definitions {{{
# ----------------------------------------------------------------------------------------------------

if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi

# }}}


# Additional Tool {{{
# ----------------------------------------------------------------------------------------------------

# bash_completion
BASH_COMPLETION=~/.local/share/bash-completion/bash_completion
if [ -f $BASH_COMPLETION ]; then
	source $BASH_COMPLETION
fi

# git-prompt
GIT_PROMPT=~/.local/submodule/git/contrib/completion/git-prompt.sh
if [ -f $GIT_PROMPT ]; then
	source $GIT_PROMPT
	# 変更の有無
	GIT_PS1_SHOWDIRTYSTATE=true
	# stashの有無
	GIT_PS1_SHOWSTASHSTATE=true
	# 未addファイルの有無
	GIT_PS1_SHOWUNTRACKEDFILES=true
	# upstreamとの同期状況
	GIT_PS1_SHOWUPSTREAM="auto"
	# color使用
	GIT_PS1_SHOWCOLORHINTS=true
fi


# git-completion
GIT_COMPLETION=~/.local/submodule/git/contrib/completion/git-completion.bash
if [ -f $GIT_COMPLETION ]; then
	source $GIT_COMPLETION
fi

# }}}

# App setting {{{
# ----------------------------------------------------------------------------------------------------

# Mac : homebrew
export HOMEBREW_GITHUB_API_TOKEN=""

# }}}


# Color Alias {{{
# ----------------------------------------------------------------------------------------------------

# Common
COL_OFF='\e[00m'        # Text Color Reset

# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Underline
UBlack='\e[4;30m'       # Black
URed='\e[4;31m'         # Red
UGreen='\e[4;32m'       # Green
UYellow='\e[4;33m'      # Yellow
UBlue='\e[4;34m'        # Blue
UPurple='\e[4;35m'      # Purple
UCyan='\e[4;36m'        # Cyan
UWhite='\e[4;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

# High Intensity
IBlack='\e[0;90m'       # Black
IRed='\e[0;91m'         # Red
IGreen='\e[0;92m'       # Green
IYellow='\e[0;93m'      # Yellow
IBlue='\e[0;94m'        # Blue
IPurple='\e[0;95m'      # Purple
ICyan='\e[0;96m'        # Cyan
IWhite='\e[0;97m'       # White

# Bold High Intensity
BIBlack='\e[1;90m'      # Black
BIRed='\e[1;91m'        # Red
BIGreen='\e[1;92m'      # Green
BIYellow='\e[1;93m'     # Yellow
BIBlue='\e[1;94m'       # Blue
BIPurple='\e[1;95m'     # Purple
BICyan='\e[1;96m'       # Cyan
BIWhite='\e[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\e[0;100m'   # Black
On_IRed='\e[0;101m'     # Red
On_IGreen='\e[0;102m'   # Green
On_IYellow='\e[0;103m'  # Yellow
On_IBlue='\e[0;104m'    # Blue
On_IPurple='\e[0;105m'  # Purple
On_ICyan='\e[0;106m'    # Cyan
On_IWhite='\e[0;107m'   # White

# }}}


# Prompt Function {{{
# ----------------------------------------------------------------------------------------------------

# Length
function length()
{
	echo -n ${#1}
	return
}

# Git Branch Name
function init-prompt-git-branch()
{
    git symbolic-ref HEAD 2>/dev/null >/dev/null &&
    if [ -f $GIT_PROMPT ]; then
	    echo $(__git_ps1 "%s]")
    else
	    echo "$(git symbolic-ref HEAD 2>/dev/null | sed 's/^refs\/heads\///')]"
    fi
    return
}

# Git Repository Name
function init-prompt-git-repo()
{
    git remote -v 2>/dev/null >/dev/null &&
    echo "[$(git remote  -v  |grep fetch |grep origin | awk '$0  {print $2}' |cut -d : -f 2): "
    return
}

# Git Remote Active Check
function init-prompt-git-branch-protocol()
{
	git symbolic-ref HEAD 2>/dev/null >/dev/null &&
        if [ -n "`git remote -v | grep -e 'https:\/\/'`" ];
        then
            echo $BRed
            return
        else
            echo $BGreen
            return
        fi
        echo $BIYellow
    return
}

# Host Infomation
host=`hostname`
case "${OSTYPE}" in
    darwin*)
        ip=`ifconfig |grep "inet\s" | grep -v '127.0.0.1' | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$//g'`
        ;;
    linux*)
        ip=`hostname -i|cut -f 1 -d ' '`
        ;;
esac
username=`whoami`

# Kernel Version
case "${OSTYPE}" in
    darwin*)
        version=''
        ;;
    linux*)
        version=`cat /etc/redhat-release | sed -e 's/^.*release\s//g'| sed -e 's/\s.*$//g'`':'
        ;;
esac

# }}}


# Prompt Variable {{{
# ----------------------------------------------------------------------------------------------------

# Git Branch Name
if which git 2>/dev/null >/dev/null
then

    if [ -f $GIT_COMPLETION ]; then
        export PS1_GIT_BRANCH='\[\e[$[COLUMNS]D\]\['"$(init-prompt-git-branch-protocol)"'\]\[\e[$[COLUMNS-$(length "$(init-prompt-git-branch)")-$(length "$(init-prompt-git-repo)")]C\]$(init-prompt-git-repo)$(init-prompt-git-branch)\[\e[$[COLUMNS]D\]\['"$COL_OFF"'\]'
    else
        export PS1_GIT_BRANCH='\[\e[$[COLUMNS]D\]\['"$(init-prompt-git-branch-protocol)"'\]\[\e[$[COLUMNS-$(length "$(init-prompt-git-branch)")-$(length "$(init-prompt-git-repo)")]C\]$(init-prompt-git-repo)$(init-prompt-git-branch)\[\e[$[COLUMNS]D\]\['"$COL_OFF"'\]'
    fi
else
	export PS1_GIT_BRANCH=
fi

# Prompt success/faile
COMR="\`
if [ \$? = 0 ]; then
	echo '$BGreen'
else
	echo '$BRed'
fi
\`"

# }}}


# PS1 setting {{{
# ----------------------------------------------------------------------------------------------------

## ~[<user名>:@<host名>:<IP>:<kernelバージョン>:<path>]
## $
## COL_USER=
## COL_HOST=
## COL_IP=
## COL_KERN=
## COL_PATH=

if [ -n "`/bin/hostname | grep -e 'login'  -e 'step'`" ];
then
    # step host
    # skyblue[34]
    COL_USER="$BYellow(step)$COL_OFF$BBlue"
    COL_HOST=$BBlue
    COL_IP=$BBlue
    COL_KERN=$BBlue
    COL_PATH=$BBlue
elif [ -n "`/bin/hostname | grep -e 'dev' 'test'`" ];
then
    if [ -n "`/bin/hostname | grep -e $username*`" ];
    then
        # my world
        # green[32]
        COL_USER=$BGreen
        COL_HOST=$BGreen
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BGreen
    else
        # dev,test
        # skyblue[34]
        COL_USER=$BBlue
        COL_HOST=$BBlue
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BBlue
    fi
else
    if [ -n "`/bin/hostname | grep -e 'prod'`" ];
    then
        # prod
        # red[31]
        COL_USER=$BRed
        COL_HOST=$BRed
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BRed
    else
        # other
        # yellow[33]
        COL_USER=$BYellow
        COL_HOST=$BYellow
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BYellow
    fi
fi
PS1=$"${COMR}~${COL_OFF}[${COL_USER}\u${COL_OFF}:${COL_HOST}@${host}${COL_OFF}:${COL_IP}${ip}${COL_OFF}:${COL_KERN}${version}${COL_OFF}${COL_PATH}\w${COL_OFF}]${PS1_GIT_BRANCH}\n\$ "

# }}}


# Command Variable {{{
# ----------------------------------------------------------------------------------------------------

# grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;37;41'

# shopt設定
# shopt -s cdspell                    # cdに指定したディレクトリ名のスペルミス補正
# shopt -s cdable_vars                # cdの引数でディレクトリでないものは変数と判断
shopt -s no_empty_cmd_completion    # 空行に対してコマンド補完しない
shopt -s dotglob                    # *がドットファイルに対応
shopt -s nocaseglob                 # 「*」などのパス名展開で大文字小文字を区別しない
shopt -s cmdhist                    # 複数行のコマンドの全ての行を1つの履歴エントリに保存
shopt -s checkhash                  # ハッシュ表にあるコマンドを、実際に存在するかを確認
shopt -s checkwinsize               # 端末の画面サイズを自動認識

# }}}


# Environment Variable {{{
# ----------------------------------------------------------------------------------------------------

# Encode
# export LANG=ja_JP.UTF-8
# export LC_ALL=ja_JP.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# C-s
# stty stop undef
# disable Stop (Ctrl+S)
[ -t 0 ] && stty stop undef


# colors
COLORRC=~/.colorrc
if [ -f $COLORRC ]; then
    case "${OSTYPE}" in
        linux*)
            eval `dircolors ~/.colorrc`
            ;;
    esac
fi

# history
## window Title
PROMPT_COMMAND='printf "\e]0;%s@%s:%s\007" "${USER}" "$host" "${PWD/#$HOME/~}"'
## 'history'コマンドで整形表示
# export HISTCONTROL=ignoredups
export HISTIGNORE=ls:l:ll:lll:llll:resource:tmux
export HISTSIZE=20000
export HISTTIMEFORMAT='%Y-%m-%d %T '
## historyの同期
# function share_history {
#     history -a
#     history -c
#     history -r
# }
# PROMPT_COMMAND='share_history'
# shopt -u histappend

# }}}


# Alias setting {{{
# ----------------------------------------------------------------------------------------------------

# Default setting
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias less="less -R"

# shortcut [cd common]
alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias .....="cd ../../../../"
alias cdgit="cd ~/git/"

# shortcut [ls common]
case "${OSTYPE}" in
    darwin*)
        # alias ls='gls -CFG --color'
        alias ls='gls -bFG --color'
        alias rm='grm -i'
        ;;
    linux*)
        # alias ls='ls -CF --color=auto'
        alias ls='ls -bF --color=auto'
        ;;
esac
alias ll='ls -lh'
alias lll='ll -a'
alias llll='tree -fC'
alias l='ll'

# shortcut [ssh common]
alias ssh='TERM=xterm ssh'

# shortcut [Alias/Typo]
alias vi='vim'
alias g="git"
alias gti="git"
alias grpe="grep"

# shortcut [original]
alias resource="source ~/.bashrc"
alias resource_profile="source ~/.bash_profile"
alias suvi="sudo vim -u ~/.vimrc"
alias psg="ps -aux | grep bash"

# }}}

# Mac Common {{{
# ----------------------------------------------------------------------------------------------------

case "${OSTYPE}" in
    darwin*)
        # alias[mac]
        alias updatedb='sudo /usr/libexec/locate.updatedb'
        alias cddesk='cd ~/Desktop/'
        alias cddock='cd ~/Documents/'
        alias cdtool='cd ~/Documents/Tools/'
        alias cdwork='cd ~/Documents/Work/'
        alias cdmemo="cd ~/Documents/memo/"
        alias cdgit="cd ~/Documents/git/"
        alias mvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias mmvim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/mvim "$@"'
        alias vit="vim ~/Documents/memo/`date +%Y`/`date +%Y-%m`/`date +%Y-%m-%d.md` -c ':%s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge | 4'"
        alias mvit="mvim ~/Documents/memo/`date +%Y`/`date +%Y-%m`/`date +%Y-%m-%d.md` -c ':%s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge | 4'"
        ;;
esac

# }}}


# Additional Command {{{
# ----------------------------------------------------------------------------------------------------

# tmux ssh
ssh_tmux() {
	ssh_cmd="ssh $@"
	tmux new-window -n "$*" "$ssh_cmd"
}

# sshソケット更新
up_sock() {
	NEWVAL=`tmux show-environment | grep "^SSH_AUTH_SOCK" | cut -d"=" -f2`
	if [ -n "${NEWVAL}" ]; then
		SSH_AUTH_SOCK=${NEWVAL}
	fi
	echo 'sock_update : "'$SSH_AUTH_SOCK'"'
}

# Useful unarchiver!
function unpack () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xjfv $1     ;;
            *.tar.gz)   tar xzfv $1     ;;
            *.tar)      tar xfv $1      ;;
            *.tbz2)     tar xjfv $1     ;;
            *.tgz)      tar xzfv $1     ;;
            *.bz2)      bunzip2 -v $1   ;;
            *.gz)       gunzip -v $1    ;;
            *.zip)      unzip $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

rcheck() {
    if [ $# -eq 1 ] ; then
        echo -e "\n$Green$ rubocop $1 $COL_OFF\n"
        rubocop $1
        echo -e "\n$Green$ foodcritic -C --progress --context --epic-fail any --epic-fail ~FC001 $1 $COL_OFF\n"
        foodcritic -C --progress --context --epic-fail any --epic-fail ~FC001 $1
    else
        echo "Please set 1 file or dir"
    fi
}

# }}}
