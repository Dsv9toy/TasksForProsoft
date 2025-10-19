; my fisrt programm on accembler. Home Work 1.
; task: Модифицировать программу вывода HelloWorld:
; 1 - Реализация проверки возвращаемого значения системного вызова write
; 2 - Реализация вывода лог strace и генерация листинга (-l listing.lst)
; 3 - Результат работы программы вывести не в терминал, а в отдельный файл. Туда же стрейс и листинг 

global _start                      ; делаем метку метку _start видимой извне
 
section .data                      ; секция данных
    message db  "Hello world!",10  ; строка для вывода на консоль
    length  equ $ - message
 
section .text                      ; объявление секции кода
_start:                            ; точка входа в программу
    mov rax, 1                     ; 1 - номер системного вызова функции write
    mov rdi, 1                     ; 1 - дескриптор файла стандартного вызова stdout
    mov rsi, message               ; адрес строки для вывод
    mov rdx, length                ; количество байтов
    syscall                        ; выполняем системный вызов write
 
    mov rax, 60                    ; 60 - номер системного вызова exit
    syscall                        ; выполняем системный вызов exit


