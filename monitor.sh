#!/bin/bash

source ./config.env

while true; do
    if pgrep "$PROCESS_NAME" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME работает" >>log.txt

        STATUS=$(curl -LI "https://test.com/monitoring/test/api" -o /dev/null -w '%{http_code}' -s)

        if [[ "${STATUS}" != "200" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - URL https://test.com/monitoring/test/api недоступен, код: $STATUS" >> log.txt
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME не работает" >>log.txt
    fi
    sleep 6
done

