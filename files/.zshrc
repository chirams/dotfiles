# .zshrc

# ------- ------- ------- ------- ------- ------- -------
# Source global definitions {{{
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Source environment definitions {{{
if [ -d ~/.local/rc/ ]; then
    for file in `\find ~/.local/rc/ -maxdepth 1`; do
        . $file
    done
fi
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Source local definitions {{{
if [ -f ~/.zshrc.local ]; then
	. ~/.zshrc.local
fi
# }}}


# ------- ------- ------- ------- ------- ------- -------
# Additional Tool {{{
fpath=(~/.zsh $fpath)

# git-completion
GIT_COMPLETION=~/.local/submodule/git/contrib/completion/git-completion.zsh
if [ -f $GIT_COMPLETION ]; then
    fpath=(~/.zsh $GIT_COMPLETION)
fi
# }}}

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
# }}}

# ------- ------- ------- ------- ------- ------- -------
# Environment Variable {{{
fpath=(/usr/local/share/zsh/functions ${fpath})

# use color
autoload -Uz colors

# use completion
case "${OSTYPE}" in
    darwin*)
        if type brew &>/dev/null; then
            FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
            autoload -Uz compinit
            compinit
        fi
        ;;
esac

# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
export ZLSCOLORS="${LS_COLORS}"
zmodload  zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

# }}}

# ------- ------- ------- ------- ------- ------- -------
# Color Alias {{{

# Common
COL_OFF='%f%b'        # Text Color Reset

# Regular Colors
Black='%F{black}'       # Black
Red='%F{red}'           # Red
Green='%F{green}'       # Green
Yellow='%F{yellow}'     # Yellow
Blue='%F{blue}'         # Blue
Purple='%F{purple}'     # Purple
Cyan='%F{cyan}'         # Cyan
White='%F{white}'       # White

# Bold
BBlack='%B%F{black}'       # Black
BRed='%B%F{red}'           # Red
BGreen='%B%F{green}'       # Green
BYellow='%B%F{yellow}'     # Yellow
BBlue='%B%F{blue}'         # Blue
BPurple='%B%F{purple}'     # Purple
BCyan='%B%F{cyan}'         # Cyan
BWhite='%B%F{white}'       # White

# }}}

# ------- ------- ------- ------- ------- ------- -------
# Prompt Settings {{{

# Host Infomation
host=`hostname`
case "${OSTYPE}" in
    darwin*)
        ip=`ifconfig |grep "inet\s" | grep -v '127.0.0.1' | cut -d' ' -f2 | tr '\n' ',' | sed 's/,$//g'`
        ;;
    linux-gnu)
        ip=`ifconfig |grep "inet\s" | grep -v '127.0.0.1' | cut -d' ' -f10 | tr '\n' ',' | sed 's/,$//g'`
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
COMR="%(?.%B%F{green}.%B%F{red})"

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
elif [ -n "`/bin/hostname | grep -e 'dev' -e '.localdomain' -e .'local'`" ];
then
    if [ -n "`/bin/hostname | grep -e '$username*'`" ];
    then
        # my world
        # purple[35]
        COL_USER=$BPurple
        COL_HOST=$BPurple
        COL_IP=$BBlue
        COL_KERN=$BBlue
        COL_PATH=$BPurple
    else
        if [ -n "`/bin/hostname | grep -e '\.dev' -e '^dev'`" ];
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
PROMPT="${COMR}~${COL_OFF}[${COL_USER}%n${COL_OFF}:${COL_HOST}@${host}${COL_OFF}:${COL_IP}${ip}${COL_OFF}:${COL_KERN}${version}${COL_OFF}${COL_PATH}%~${COL_OFF}]
%# "

# RPROMPT for git

# if [ -f $GIT_PROMPT ]; then
#     setopt prompt_subst
#     if which git 2>/dev/null >/dev/null
#     then
#         RPROMPT='$(init-prompt-git)'
#     fi
# fi

setopt prompt_subst

# autoload -Uz vcs_info
# zstyle ':vcs_info:*' max-exports 3
# zstyle ':vcs_info:*' enable git svn
# zstyle ':vcs_info:*' formats '[%F{green}%r: %b%c%u%f]'
# zstyle ':vcs_info:*' actionformats '[%F{green}%r: %b %c%u%f%m]''<!%a>'
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
#
# precmd () { vcs_info }
# RPROMPT='${vcs_info_msg_0_}'

# }}}
