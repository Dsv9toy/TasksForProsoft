; HomeWork 2. second task. Простой калькулятор. 
;task: необходимо сложить два числа и вывести результат
;1 - скорее всего также будет использоваться стек
;2 - реализация действий через функции
;3 - Преобразование в строку и из числа и наоборот



section .data
EnterMessage1 db 'Простой калькулятор суммы', 10
EnterMessage1Len equ $ - EnterMessage1
nextLine db 10,0 

MsgForNum1 db 'Введи первое число: ', 10
MsgForNum1Len equ $ - MsgForNum1
nextLine db 10,0 

MsgForNum2 db 'Введи второе число: ', 10
MsgForNum2Len equ $ - MsgForNum2
nextLine db 10,0 

ResultMsg db 'Результат: ', 0
ResultMsgLen equ $ - ResultMsg

section .bss

FirstNumBuff resb 20
SecondNumBuff resb 20
ResultBuff resb 40

section .text
    global _start


_start:
    mov rsi, EnterMessage1 ; Кладем в rsi наше приветствие
    mov rdx, EnterMessage1Len ; размером строки
    call PrintEnterMsg

    ;---------------------------стадия записи первого числа--------------------------------------
    mov rsi, MsgForNum1 ; Подсказываем пользователю ввести первое число
    mov rdx, MsgForNum1Len
    call PrintEnterMsg

;читаем первое число
    mov rsi, FirstNumBuff
    mov rdx, 20 
    call ReadImputNumsFunc

;преобразуем первое число в строку
    mov rsi, FirstNumBuff
    call ToIntFromStringFunc
    mov r8, rax ; сохраним первое число в r8
    
    
    ;----------------------------------стадия записи второго числа--------------------------------------
    mov rsi, MsgForNum2 ; Подсказываем пользователю ввести второе число
    mov rdx, MsgForNum2Len
    call PrintEnterMsg

;читаем второе число
    mov rsi, SecondNumBuff
    mov rdx, 20 
    call ReadImputNumsFunc

;преобразуем второе число в строку
    mov rsi, SecondNumBuff
    call ToIntFromStringFunc
    mov r9, rax ; сохраним первое число в r9

;сложение
    call ResultSumFunc

;вывод рез-та
    mov rsi, ResultMsg
    mov rdx, ResultMsgLen
    call PrintEnterMsg

    mov rsi, ResultBuff
    mov rdx, 40
    call PrintEnterMsg



    ;Выход из программы
    mov rax, 60  ; exit
    xor rdi, rdi ; код возврата чтобы 0 был. успешный
    syscall 

;--------------------------ФУНКЦИИ-----------------------------------------ФУНКЦИИ---------------------------------ФУНКЦИИ-------------------------------
PrintEnterMsg:
    push rax ; Сохраняем состояние тк он исп-ся для системных вызовов
    push rdi ; Сохраняем состояние тк он исп-ся для определения назначения данных. 
    
    mov rax, 1 ; говорим - Переводись в состояние записи write
    mov rdi, 1 ; 1 - значит на экран(stdout)

    syscall  

    pop rdi
    pop rax ; вернули всё на место

ret

ReadImputNumsFunc:
    push rax ; 
    push rdi

    mov rax, 0 ; перевод в режим чтения
    mov rdi, 0 ; с экрана консоли
    ;заменяем символ новой строки на 0                         
    mov rdi, rsi
    add rdi, rax
    dec rdi
    mov byte [rdi], 0             

    pop rdi   ; раскрываем стек обратно
    pop rax   ; 
ret

ToIntFromStringFunc:
    ; Нужно реализовать преобразование строки в число
    ; Пока заглушка - возвращает 5
    mov rax, 5
ret

ToStringFromIntFunc:
   ; Нужно реализовать преобразование числа в строку  
    ; Пока заглушка
ret

ResultSumFunc:
    push rax

    mov rax, r8
    add rax, r9

    pop rax
ret

