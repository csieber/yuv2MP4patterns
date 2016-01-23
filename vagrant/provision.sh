#!/usr/bin/env bash

trap 'exit' ERR

apt-get update

apt-get -y install libav-tools

echo "Provision (root) completed."
