#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    TAG='latest'
else
    TAG=$1
fi

export PYENV_ROOT="./tmp/pyenv"

if [[ -e "./tmp" ]]; then
    echo "'tmp' exists"
    [[ -e "./tmp/pyenv" ]] && rm -rf "./tmp/pyenv"  # remove existing pyenv
else 
    echo "'tmp' missing. creating..."
    mkdir "tmp"
fi

export PYENV_ROOT="./tmp/pyenv"
echo "Getting pyenv"
curl https://pyenv.run | bash

echo "Duplicate to test base"
cp -r ./tmp/pyenv ./tmp/pyenv-test

echo "Installing pyenv-multiuser to test install"
#git clone https://github.com/macdub/pyenv-multiuser ./tmp/pyenv-test/plugins/pyenv-multiuser
mkdir -p ./tmp/pyenv-test/plugins/pyenv-multiuser
cp -r {backup,bin,test}/ ./tmp/pyenv-test/plugins/pyenv-multiuser

exit 0

echo "Peforming Docker build"
docker build -t "pyenv-multiuser-test:$TAG" .

echo "Cleaning up"
rm -rf ./tmp
