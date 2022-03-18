# .bashrc

# ------- ------- ------- ------- ------- ------- -------
# Source global definitions {{{
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Source environment definitions {{{
if [ -d ~/.local/rc/ ]; then
    for file in `\find ~/.local/rc -maxdepth 1 | grep rc_`; do
        . $file
    done
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Source local definitions {{{
if [ -f ~/.bashrc.local ]; then
	. ~/.bashrc.local
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Additional Tool {{{
# bash_completion self
if [ -r "/usr/local/etc/profile.d/bash_completion.sh" ]; then
    . "/usr/local/etc/profile.d/bash_completion.sh"
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Command Variable {{{

# shopt設定
shopt -s no_empty_cmd_completion    # 空行に対してコマンド補完しない
shopt -s dotglob                    # *がドットファイルに対応
shopt -s nocaseglob                 # 「*」などのパス名展開で大文字小文字を区別しない
shopt -s cmdhist                    # 複数行のコマンドの全ての行を1つの履歴エントリに保存
shopt -s checkhash                  # ハッシュ表にあるコマンドを、実際に存在するかを確認
shopt -s checkwinsize               # 端末の画面サイズを自動認識

# }}}


# ------- ------- ------- ------- ------- ------- -------
# Environment Variable {{{

# history
## window Title
PROMPT_COMMAND='printf "\e]0;%s@%s:%s\007" "${USER}" "$host" "${PWD/#$HOME/~}"'
## 'history'コマンドで整形表示
export HISTIGNORE=ls:l:ll:lll:llll:resource:tmux
export HISTSIZE=20000
export HISTTIMEFORMAT='%Y-%m-%d %T '

# }}}


# ------- ------- ------- ------- ------- ------- -------
# Color Alias {{{

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


# ------- ------- ------- ------- ------- ------- -------
# Git Prompt Settings {{{

# Length
function length()
{
	echo -n ${#1}
	return
}

# git-prompt
GIT_PROMPT=''
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

# git-completion
GIT_COMPLETION=~/.local/submodule/git/contrib/completion/git-completion.bash
if [ -f $GIT_COMPLETION ]; then
	source $GIT_COMPLETION
fi

# Git Branch Name
if which git 2>/dev/null >/dev/null
then
    if [ -f $GIT_COMPLETION ]; then
        export PS1_GIT_BRANCH='\[\e[$[COLUMNS]D\]\['"$(init-prompt-git-branch-protocol)"'\]\[\e[$[COLUMNS-$(length "$(init-prompt-git-branch)")-$(length "$(init-prompt-git-repo)")]C\]$(init-prompt-git-repo)$(init-prompt-git-branch)\[\e[$[COLUMNS]D\]\['"$COL_OFF"'\]'
    fi
else
	export PS1_GIT_BRANCH=
fi

# }}}


# ------- ------- ------- ------- ------- ------- -------
# Prompt Settings {{{

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

# account
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

# Prompt success/faile
COMR="\`
if [ \$? = 0 ]; then
	echo '$BGreen'
else
	echo '$BRed'
fi
\`"


## ~[<user名>:@<host名>:<IP>:<kernelバージョン>:<path>]
## $
## COL_USER=
## COL_HOST=
## COL_IP=
## COL_KERN=
## COL_PATH=

if [ -n "`/bin/hostname | grep -e 'login'`" ];
then
    # step host
    # skyblue[34]
    COL_USER="$BYellow(step)$COL_OFF$BBlue"
    COL_HOST=$BBlue
    COL_IP=$BBlue
    COL_KERN=$BBlue
    COL_PATH=$BBlue
elif [ -n "`/bin/hostname | grep -e 'dev'`" ];
then
    if [ -n "`/bin/hostname | grep -e $username*`" ];
    then
        # my world
        # purple[35]
        COL_USER=$BPurple
        COL_HOST=$BPurple
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BPurple
    else
        if [ -n "`/bin/hostname | grep -e '\.dev'`" ];
        then
            # skyblue[34]
            COL_USER=$BBlue
            COL_HOST=$BBlue
            COL_IP=$BBlue
            COL_KERN=$BBlue
            COL_PATH=$BBlue
        else
            # miniY:green[32]
            COL_USER=$BGreen
            COL_HOST=$BGreen
            COL_IP=$BBlue
            COL_KERN=$BBlue
            COL_PATH=$BGreen
        fi
    fi
else
    if [ -n "`/bin/hostname | grep -e 'prod' -e '\.test'`" ];
    then
        # prod/corp/pluto:red[31]
        COL_USER=$BRed
        COL_HOST=$BRed
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BRed
    else
        # other:yellow[33]
        COL_USER=$BYellow
        COL_HOST=$BYellow
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BYellow
    fi
fi


if [ "x$PS1_GIT_BRANCH" = "x" ];
then
    PS1=$"${COMR}~${COL_OFF}[${COL_USER}\u${COL_OFF}:${COL_HOST}@${host}${COL_OFF}:${COL_IP}${ip}${COL_OFF}:${COL_KERN}${version}${COL_OFF}${COL_PATH}\w${COL_OFF}]\n\$ "
else
    PS1=$"${COMR}~${COL_OFF}[${COL_USER}\u${COL_OFF}:${COL_HOST}@${host}${COL_OFF}:${COL_IP}${ip}${COL_OFF}:${COL_KERN}${version}${COL_OFF}${COL_PATH}\w${COL_OFF}]${PS1_GIT_BRANCH}\n\$ "
fi

# }}}
