#!/usr/bin/env bash

set -e


ENV_NAME=waveapp

source /home/esloch/mambaforge/bin/activate "$ENV_NAME" && \
wave run app/app.py
