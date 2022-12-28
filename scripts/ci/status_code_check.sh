#!/usr/bin/env bash

echo "[I] Checking response status code from App..."

while [ "`curl -i http://localhost:10101 2>/dev/null | head -n 1 | cut -d$' ' -f2`" != 200 ];
do
    echo "[II] Waiting for Curl..."
    sleep 5;
done

echo "[III] The WaveApp is 200 OK!."
