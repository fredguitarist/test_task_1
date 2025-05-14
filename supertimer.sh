#!/bin/bash

source ./config.env
interval=6  # 60 секунд

while true; do
  # Запоминаем время старта
  start=$(date +%s)

  echo "[$(date)] Старт итерации"

  # === Тело итерации ===
      if pgrep "$PROCESS_NAME" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME работает" >>log.txt

        STATUS=$(curl -LI "https://test.com/monitoring/test/api" -o /dev/null -w '%{http_code}' -s)

        if [[ "${STATUS}" != "200" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') - URL https://test.com/monitoring/test/api недоступен, код: $STATUS" >> log.txt
        fi
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME не работает" >>log.txt
    fi
  # sleep 7  # Пример работы
  # =====================

  # Запоминаем время окончания работы
  end=$(date +%s)
  elapsed=$((end - start))

  # Считаем, сколько нужно ждать до следующей итерации
  wait_time=$((interval - elapsed))

  if [ $wait_time -gt 0 ]; then
    echo "Завершено за $elapsed секунд. Ожидаем $wait_time секунд до следующей итерации."
    sleep $wait_time
  else
    echo "⚠️ Итерация заняла больше $interval секунд ($elapsed секунд). Следующая итерация сразу."
  fi
done




# source ./config.env

# while true; do
#     if pgrep "$PROCESS_NAME" > /dev/null; then
#         echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME работает" >>log.txt

#         STATUS=$(curl -LI "https://test.com/monitoring/test/api" -o /dev/null -w '%{http_code}' -s)

#         if [[ "${STATUS}" != "200" ]]; then
#             echo "$(date '+%Y-%m-%d %H:%M:%S') - URL https://test.com/monitoring/test/api недоступен, код: $STATUS" >> log.txt
#         fi
#     else
#         echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME не работает" >>log.txt
#     fi
#     sleep 6
# done

