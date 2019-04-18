#!/usr/bin/env sh                                                                                                       

# create virtualenv for python 3.6.5_1 on MacOS if you installed higher python with brew 
# `brew info python` to see

PY36="/usr/local/Cellar/python/3.6.5_1/bin/python3.6"

echo "Create Python 3.6 virtual environment .."
virtualenv --python=${PY36} $1 $2 $3 $4 $5 $6 $7 $8
