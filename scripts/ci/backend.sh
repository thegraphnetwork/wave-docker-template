#!/usr/bin/env bash

set -e


ENV_NAME=waveapp

condabin_path=`which conda`


echo ${condabin_path}


source ${condabin_path%/*/*}/bin/activate "$ENV_NAME" && \
wave run app/app.py
