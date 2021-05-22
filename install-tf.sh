#!/bin/bash
TF_VERSION=0.15.4
git clone https://github.com/hashicorp/terraform.git /tmp/terraform
cd /tmp/terraform
git checkout v$TF_VERSION
go mod vendor
go build -o tf .
mv tf /usr/local/bin/terraform
ln -s /usr/local/bin/terraform /usr/local/bin/tf

git clone https://github.com/juliosueiras/terraform-lsp.git /tmp/terraform-lsp
cd /tmp/terraform-lsp
go mod vendor
go build -o tf-lsp .
mv tf-lsp /usr/local/bin/terraform-lsp
ln -s /usr/local/bin/terraform-lsp /usr/local/bin/tf-lsp
rm -rf /tmp/terraform-lsp

mkdir -p ~/.vim
ls -s $PWD/coc-settings.json ~/.vim/coc-settings.json

