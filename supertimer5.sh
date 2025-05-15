source ./config.env  # Должна быть переменная PROCESS_NAME

iteration_duration=3

while true; do
    echo "Запускаю операцию с ограничением по времени..."
    echo "Скрипт запущен от пользователя: $(whoami)"

    start_time=$(date +%s.%N)

    timeout "$iteration_duration" bash -c '
        echo "Проверяю процесс: $1"
        if pgrep "$1" > /dev/null; then
            echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 работает" >> log.txt
        else
            echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 не работает" >> log.txt
        fi
        echo "Операция завершена"
        sleep 1
        echo "Операция2 завершена"
    ' _ "$PROCESS_NAME"

    end_time=$(date +%s.%N)

    elapsed=$(echo "$end_time - $start_time" | bc)
    sleep_time=$(echo "$iteration_duration - $elapsed" | bc)

    if (( $(echo "$sleep_time > 0" | bc -l) )); then
        echo "Итерация завершена за $elapsed секунд. Сплю $sleep_time секунд."
        sleep "$sleep_time"
    else
        echo "Итерация заняла $elapsed секунд — спать не будем."
    fi
done


