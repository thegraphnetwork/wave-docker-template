#!/usr/bin/env bash

STATUS_CODE=''

echo "[II] Checking response status code from App..."

while [ "${STATUS_CODE}" != '200' ];
do
    echo "[II] Waiting for Curl..."
    STATUS_CODE=`curl -i http://localhost:10101 2>/dev/null | head -n 1 | cut -d$' ' -f2`
    sleep 5;
done

echo "[II] The status code is ${STATUS_CODE} OK!"
