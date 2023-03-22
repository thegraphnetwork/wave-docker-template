#!/usr/bin/env bash

set -ex

if [ $# -eq 0 ]; then
  exit 0
fi

# prepare the conda environment
is_conda_in_path=$(echo $PATH|grep -m 1 --count /opt/conda/)

if [ $is_conda_in_path == 0 ]; then
  export PATH="/opt/conda/condabin:/opt/conda/bin:$PATH"
  echo "[II] included conda to the PATH"
fi

echo "[II] activate waveapp"
source activate waveapp

export H2O_WAVE_ADDRESS="http://127.0.0.1:9999"

(cd "${WAVE_PATH}" && ./waved -listen ":9999" &

sleep 3

echo "Running: ${@}"
$("${@}")