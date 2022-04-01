#!/usr/bin/env bash

cd $(dirname "$0")
emacs -q --script publish.el
scp -r html/* sync:/var/www/kenran.info
