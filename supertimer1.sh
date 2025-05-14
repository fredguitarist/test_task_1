#!/bin/bash

source ./config.env
interval=6  # жёсткий лимит на длительность итерации (в секундах)

while true; do
  start=$(date +%s)
  echo "[$(date)] Старт итерации"

  # === Тело итерации ограничено временем выполнения ===
  timeout $interval bash -c '
    if pgrep "$PROCESS_NAME" > /dev/null; then
      echo "$(date "+%Y-%m-%d %H:%M:%S") - $PROCESS_NAME работает" >> log.txt

      STATUS=$(curl -LI "https://test.com/monitoring/test/api" --max-time 5 -o /dev/null -w "%{http_code}" -s)

      if [[ "$STATUS" != "200" ]]; then
        echo "$(date "+%Y-%m-%d %H:%M:%S") - URL https://test.com/monitoring/test/api недоступен, код: $STATUS" >> log.txt
      fi
    else
      echo "$(date "+%Y-%m-%d %H:%M:%S") - $PROCESS_NAME не работает" >> log.txt
    fi
  '

  # === Ждём до следующей итерации, если осталось время ===
  end=$(date +%s)
  elapsed=$((end - start))
  wait_time=$((interval - elapsed))

  if [ $wait_time -gt 0 ]; then
    echo "Завершено за $elapsed сек. Ожидаем $wait_time сек."
    sleep $wait_time
  else
    echo "⏱ Итерация заняла $elapsed сек (лимит $interval). Новая итерация сразу."
  fi
done
