#!/usr/bin/env bash

cd $(dirname "$0")
cp ~/dotfiles/modules/programs/emacs/emacs.d/config.org emacs-config/
emacs -q --script publish.el
scp -r html/* sync:/var/www/kenran.info
