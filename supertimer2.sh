#!/bin/bash

source ./config.env  # Если там есть нужные переменные

# Длительность одной итерации в секундах
iteration_duration=5

while true; do
  echo "Запускаю операцию с ограничением по времени..."

  # Операция с таймаутом
  timeout "$iteration_duration" bash -c "
    echo "Я в теле цикла"
    sleep 1  # Долгая операция, которая будет прервана через $iteration_duration секунд
    echo "Этот текст не появится, если timeout сработает"
    STATUS=$(curl -LI "https://test.com/monitoring/test/api" --max-time 4 -o /dev/null -w "%{http_code}" -s)
    if pgrep "$PROCESS_NAME" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME работает" >>log.txt
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME не работает" >>log.txt
    fi
  

  echo "Итерация завершена. Жду $iteration_duration секунд до следующей итерации"
done



    # if pgrep "$PROCESS_NAME" > /dev/null; then
    #     echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME работает" >>log.txt

    #     STATUS=$(curl -LI "https://test.com/monitoring/test/api" -o /dev/null -w '%{http_code}' -s)

    #     if [[ "${STATUS}" != "200" ]]; then
    #         echo "$(date '+%Y-%m-%d %H:%M:%S') - URL https://test.com/monitoring/test/api недоступен, код: $STATUS" >> log.txt
    #     fi
    # else
    #     echo "$(date '+%Y-%m-%d %H:%M:%S') - $PROCESS_NAME не работает" >>log.txt
    # # fi


