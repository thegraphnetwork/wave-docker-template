#!/usr/bin/env bash

set -e


ENV_NAME=waveapp

source /usr/share/miniconda3/bin/activate "$ENV_NAME" && \
wave run app/app.py
