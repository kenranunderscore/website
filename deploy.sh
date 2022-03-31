#!/usr/bin/env bash

cd $(dirname "$0")
nix build
scp -r result/site/* sync:/var/www/kenran.info
ssh -t sync "sudo chown -R kenran /var/www/kenran.info && sudo chmod 777 -R /var/www/kenran.info/*"
