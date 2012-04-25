#!/bin/bash

if [[ "$(uname)" == "Darwin" ]]
then
    CONF_DIR=$(greadlink -f $(dirname $0))
else
    CONF_DIR=$(readlink -f $(dirname $0))
fi

ln -sf $CONF_DIR/bashrc $HOME/.bashrc
ln -sf $CONF_DIR/vimrc $HOME/.vimrc
ln -sf $CONF_DIR/gvimrc $HOME/.gvimrc
ln -sf $CONF_DIR/vim $HOME/.vim
ln -sf $CONF_DIR/gitconfig $HOME/.gitconfig
ln -sf $CONF_DIR/tmux.conf $HOME/.tmux.conf
