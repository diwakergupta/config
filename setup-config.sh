#!/bin/bash

CONF_DIR=$(readlink -f $(dirname $0))

ln -sf $CONF_DIR/bashrc $HOME/.bashrc
ln -sf $CONF_DIR/vimrc $HOME/.vimrc
ln -sf $CONF_DIR/gvimrc $HOME/.gvimrc
ln -sf $CONF_DIR/vim $HOME/.vim
ln -sf $CONF_DIR/gitconfig $HOME/.gitconfig
ln -sf $CONF_DIR/tmux.conf $HOME/.tmux.conf
ln -sf $CONF_DIR/eclimrc $HOME/.eclimrc
