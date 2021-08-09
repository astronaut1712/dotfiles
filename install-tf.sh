#!/bin/bash
TF_VERSION=1.0.4
git clone -q https://github.com/hashicorp/terraform.git /tmp/terraform
cd /tmp/terraform
git checkout v$TF_VERSION
go mod vendor
go build -o tf .
sudo mv tf /usr/local/bin/terraform
sudo ln -s /usr/local/bin/terraform /usr/local/bin/tf

git clone -q https://github.com/juliosueiras/terraform-lsp.git /tmp/terraform-lsp
cd /tmp/terraform-lsp
go mod vendor
go build -o tf-lsp .
sudo mv tf-lsp /usr/local/bin/terraform-lsp
sudo ln -s /usr/local/bin/terraform-lsp /usr/local/bin/tf-lsp
rm -rf /tmp/terraform-lsp

mkdir -p ~/.vim
sudo ln -s $CWD/coc-settings.json ~/.vim/coc-settings.json

