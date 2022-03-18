#!/bin/bash

DOT_HOME=`pwd`/files
DOT_FILES=( .vimrc .bashrc .bash_profile .zshrc .zprofile .screenrc .gitconfig .gitignore .inputrc .colorrc .editrc .gitattributes_global .tmux.conf)
VIM_DIRS=( after/ftplugin dict syntax dein.rc tmp template )
LOCAL_DIRS=( bin rc submodule/git/contrib/completion )
MODE=0

if [ $# -eq 1 ]; then
    MODE=$1
fi

for file in ${DOT_FILES[@]}
do
    if [ -a $HOME/$file ]; then
	    echo "Find $HOME/$file"
        if [ $MODE -eq "0" ]; then
            echo "File exists: $file"
        elif [ $MODE -eq "1" ]; then
            rm -rf $HOME/$file
            echo "Delete: $file"
            ln -s $DOT_HOME/$file $HOME/$file
            echo "Symlink created: $file"
        fi
    else
	    echo "Not Find $HOME/$file"
        ln -s -i $DOT_HOME/$file $HOME/$file
        echo "Symlink created: $file"
    fi
done

if [ -a $HOME/.vim ]; then
    echo "Directory exists: $HOME/.vim"
else
    mkdir -p $HOME/.vim
    echo "Create $HOME/.vim"
fi

# echo 'contrib/completion/' > .git/modules/files/.local/submodule/git/info/sparse-checkout
# git config core.sparsecheckout true
# git submodule init
# git submodule update

for dir in ${VIM_DIRS[@]}
do
    FULL_DIR="$HOME/.vim/$dir"
    if [ -a $FULL_DIR ]; then
        echo "Directory exists: $FULL_DIR"
    else
        mkdir -p $FULL_DIR
        echo "Create Directory: $FULL_DIR"
    fi

    for ls_list in `ls $DOT_HOME/.vim/$dir`;
    do
        ls_file="$FULL_DIR/$ls_list"
        if [ -a $ls_file ]; then
            if [ $MODE -eq "0" ]; then
                echo "File exists: $ls_file"
            else
                rm -rf $ls_file
                echo "Delete: $ls_file"
                ln -s -i $DOT_HOME/.vim/$dir/$ls_list $ls_file
                echo "Symlink created: $ls_file"
            fi
        else
            ln -s -i $DOT_HOME/.vim/$dir/$ls_list $ls_file
            echo "Symlink created: $ls_file"
        fi
    done
done

if [ -a $HOME/.local ]; then
    echo "Directory exists: $HOME/.local"
else
    mkdir -p $HOME/.local
    echo "Create $HOME/.local"
fi

for dir in ${LOCAL_DIRS[@]}
do
    FULL_DIR="$HOME/.local/$dir"
    if [ -a $FULL_DIR ]; then
        echo "Directory exists: $FULL_DIR"
    else
        mkdir -p $FULL_DIR
        echo "Create Directory: $FULL_DIR"
    fi

    for ls_list in `ls $DOT_HOME/.local/$dir`;
    do
        ls_file="$FULL_DIR/$ls_list"
        if [ -a $ls_file ]; then
            if [ $MODE -eq "0" ]; then
                echo "File exists: $ls_file"
            else
                rm -rf $ls_file
                echo "Delete: $ls_file"
                ln -s -i $DOT_HOME/.local/$dir/$ls_list $ls_file
                echo "Symlink created: $ls_file"
            fi
        else
            ln -s -i $DOT_HOME/.local/$dir/$ls_list $ls_file
            echo "Symlink created: $ls_file"
        fi
    done
done

source ~/.bash_profile
