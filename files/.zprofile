# .bash_profile

# ------- ------- ------- ------- ------- ------- -------
# Source local definitions {{{
if [ -f ~/.zprofile.local ]; then
	. ~/.zprofile.local
fi
# }}}


# ------- ------- ------- ------- ------- ------- -------
# Get the aliases and functions {{{
if [ -f ~/.bashrc ]; then
	. ~/.zshrc
fi
# }}}


# ------- ------- ------- ------- ------- ------- -------
# SSH_AUTH_SOCK {{{
eval `/usr/bin/ssh-agent`
# agent="/tmp/ssh-agent-$USER"
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
        /tmp/*/agent.[0-9]*)
            ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
    echo -e $'\e[046mhold SSH_AUTH_SOCK\e[m'
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
    echo -e $'\e[042mupdate SSH_AUTH_SOCK\e[m'
else
    echo -e $'\e[041mno ssh-agent\e[m'
fi

# }}}

# remove Duplication Path {{{

_path=""
for _p in $(echo $PATH | tr ':' ' '); do
    case ":${_path}:" in
        *:"${_p}":* )
            ;;
        * )
            if [ "$_path" ]; then
                _path="$_path:$_p"
            else
                _path=$_p
            fi
            ;;
    esac
done
PATH=$_path

unset _p
unset _path

export PATH

# }}}
