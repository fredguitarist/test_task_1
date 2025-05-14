#!/bin/bash

source ./config.env  # В этом файле должна быть строка: PROCESS_NAME=nginx (или другой процесс)

iteration_duration=5

while true; do
  echo "Запускаю проверку..."

  timeout "$iteration_duration" bash -c '
    echo "Я в теле цикла"
    sleep 4  # Долгая операция, которая будет прервана через timeout
    echo "Проверяю процесс: $1"
    if pgrep "$1" > /dev/null; then
        echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 работает" >> log.txt
    else
        echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 не работает" >> log.txt
    fi
  ' _ "$PROCESS_NAME"

  echo "Итерация завершена."
done






# #!/bin/bash

# source ./config.env  # В этом файле должна быть переменная PROCESS_NAME

# # Длительность одной итерации в секундах
# iteration_duration=5

# while true; do
#   echo "Запускаю операцию с ограничением по времени..."

#   timeout "$iteration_duration" bash -c '
#     echo "Я в теле цикла"
#     sleep 1  # Долгая операция, которая будет прервана через timeout

#     echo "Выполняю curl..."
#     STATUS=$(curl -LI "https://test.com/monitoring/test/api" --max-time 4 -o /dev/null -w "%{http_code}" -s)

#     if pgrep "$0" > /dev/null; then
#         echo "$(date '+%Y-%m-%d %H:%M:%S') - $0 работает (HTTP $STATUS)" >> log.txt
#     else
#         echo "$(date '+%Y-%m-%d %H:%M:%S') - $0 не работает (HTTP $STATUS)" >> log.txt
#     fi
#   ' "$PROCESS_NAME"

#   echo "Итерация завершена. Жду $iteration_duration секунд до следующей итерации"
# done

