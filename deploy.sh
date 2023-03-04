#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
cp ~/dotfiles/home-manager-modules/emacs/emacs.d/config.org emacs-config/
emacs --script publish.el
scp -r html/* sync:/var/www/kenran.info
