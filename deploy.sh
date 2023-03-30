#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
mkdir -p emacs-config/my-packages
cp ~/dotfiles/home-manager-modules/emacs/emacs.d/config.org emacs-config/
cp ~/dotfiles/home-manager-modules/emacs/emacs.d/my-packages/*.org emacs-config/my-packages/
emacs --script publish.el
scp -r html/* sync:/var/www/kenran.info
