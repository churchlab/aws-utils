#!/bin/bash

# no need for sudo because running from packer

# ******************************************************************************
apt-get update

apt-get install -y python3-pip
apt-get install -y build-essential libssl-dev libffi-dev python3-dev

# ******************************************************************************
# install AWS CLI globally
pip3 install --upgrade pip
pip3 install -y awscli

# ******************************************************************************
# Install virtual environment stuff, make a vitualenvwrapper home vw_venvs
pip3 install virtualenv
# apt-get install -y python3-venv
pip3 install virtualenvwrapper
mkdir vw_venvs
echo "export WORKON_HOME=~/vw_venvs" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh\n" >> ~/.bashrc
source ~/.bashrc

# ******************************************************************************
apt-get install -y python3-apt
apt-get clean

