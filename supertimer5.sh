# #!/bin/bash

# source ./config.env

# # Длительность одной итерации в секундах
# iteration_duration=3

# # Начало цикла
# while true; do
#     # Запускаем операцию с таймаутом
#     echo "Запускаю операцию с ограничением по времени..."
    
#     # Здесь ваша операция (например, долгий процесс)
#     timeout $iteration_duration bash -c "
#         # Ваши операции, которые могут занять больше времени
#         #sleep 10  # Например, эта операция займет 10 секунд
#         echo "Проверяю процесс: $1"
#         if pgrep "$1" > /dev/null; then
#             echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 работает" >> log.txt
#         else
#             echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 не работает" >> log.txt
#         fi
#         echo 'Операция завершена'
#     "
    
#     # Ожидаем оставшееся время для завершения итерации
#     echo "Итерация завершена. Начинаем новую через $iteration_duration секунд."
#     sleep $iteration_duration
# done

#!/bin/bash

source ./config.env  # Должна быть переменная PROCESS_NAME

iteration_duration=3

while true; do
    echo "Запускаю операцию с ограничением по времени..."

    timeout "$iteration_duration" bash -c '
        echo "Проверяю процесс: $1"
        if pgrep "$1" > /dev/null; then
            echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 работает" >> log.txt
        else
            echo "$(date "+%Y-%m-%d %H:%M:%S") - $1 не работает" >> log.txt
        fi
        echo "Операция завершена"
    ' _ "$PROCESS_NAME"

    echo "Итерация завершена. Начинаю новую через $iteration_duration секунд."
    sleep "$iteration_duration"
done

