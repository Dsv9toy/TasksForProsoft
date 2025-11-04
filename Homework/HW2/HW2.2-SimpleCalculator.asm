; HomeWork 2. second task. Простой калькулятор. 
;task: необходимо сложить два числа и вывести результат
;1 - скорее всего также будет использоваться стек
;2 - реализация действий через функции
;3 - Преобразование в строку и из числа и наоборот


;--------------------------------------------------
section .data
EnterMessage1 db 'Простой калькулятор суммы', 10
EnterMessage1Len equ $ - EnterMessage1
nextline db 10,0 

MsgForNum1 db 'Введи первое число: ', 10
MsgForNum1Len equ $ - MsgForNum1


MsgForNum2 db 'Введи второе число: ', 10
MsgForNum2Len equ $ - MsgForNum2


ResultMsg db 'Результат: ', 0
ResultMsgLen equ $ - ResultMsg

nextline1 db 10,0
;--------------------------------------------------
section .bss

FirstNumBuff resb 20
SecondNumBuff resb 20
ResultBuff resb 40

;-------------------------------------------------
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

; Вычисляем длину результата прямо здесь
    push rsi
    push rdx

 mov rsi, ResultBuff
    mov rdx, 0
.calcLen:
    cmp byte [rsi + rdx], 0  ; ищем конец строки
    je .printResult
    inc rdx
    jmp .calcLen
.printResult:
    call PrintEnterMsg     

    pop rdx
    pop rsi

    ;выводим перевод строки
    mov rsi, nextline
    mov rdx, 1
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
    push rsi
    push rdx

    mov rax, 0 ; перевод в режим чтения
    mov rdi, 0 ; с экрана консоли

    syscall

    ;заменяем символ новой строки на 0     
 cmp rax, 0
    je .done
    mov rdi, rsi
    add rdi, rax
    dec rdi                     ; переходим к последнему символу
    cmp byte [rdi], 10          ; проверяем если это \n
    jne .done
    mov byte [rdi], 0           ; заменяем \n на 0
.done:
    pop rdx
    pop rsi
    pop rdi
    pop rax
ret


;точка перед меткой создает локальную метку, которая видна только внутри функции. Не возникнет конфликтов если вдруг очень много меток и случайно объявили ту же самую
ToIntFromStringFunc:
    xor rax, rax        ; обнуляем результат 
    xor rcx, rcx        ; обнуляем счетчик, будем хранить текущий символ
    mov rbx, 10         ; т.к мы будем работать с десятичными числами, то множитель должен быть 10. 

.Looping:
    mov cl, [rsi]       ; берем текущий символ из строки
    cmp cl, 0           ; проверяем конец строки (нуль-терминатор)
    je .done            ; je - jump if equal. если равно то переход 
    cmp cl, '0'         ; проверяем валидность цифры
    jb .done            ; jb - jump if below. переход если меньше. т.е если символ < '0' - не цифра
    cmp cl, '9'
    ja .done            ; ja - jump if above. переход если больше. т.е если символ > '9' - не цифра
    
    sub cl, '0'         ; преобразуем символ в цифру: '5' -> 5
    imul rax, rbx       ; умножаем текущий результат на 10. imul - умножение 
                        ; (сдвигаем разряды влево)
    add rax, rcx        ; добавляем новую цифру к результату
    inc rsi             ; переходим к следующему символу в строке
    jmp .Looping   ; повторяем

.done:
ret


ToStringFromIntFunc:
    push rbx
    push rdx


    mov rax, rdi      
    mov rdi, rsi        ; буфер для результата
    add rdi, 39         ; начинаем с конца буфера (39-й байт из 40)
    mov byte [rdi], 0   ; ставим завершающий нуль в конец строки
    mov rbx, 10         

.Loopa:
    dec rdi             ; двигаемся назад по буферу (т.е справа налево)
    xor rdx, rdx        ; обнуляем rdx для деления
    div rbx             ; div -беззнаковое деление. делим rax на 10: rax=частное, rdx=остаток
    add dl, '0'         ; преобразуем цифру в символ
    mov [rdi], dl       ; сохраняем символ в буфер
    test rax, rax       ; проверяем, осталось ли что-то в частном
    jnz .Loopa   ; если да, продолжаем преобразование

    ;Копируем результат в начало буфера
    mov rax, rdi        ; rsi теперь указывает на начало числа в буфере

    pop rdx
    pop rbx
ret


ResultSumFunc:
    push rdi
    push rsi

    mov rax, r8
    add rax, r9

    ;преобразуем число обратно 
    mov rdi, rax        ; число для преобразования
    mov rsi, ResultBuff ; буфер для результата
    call ToStringFromIntFunc

;результат теперь в rax, копируем его в ResultBuff
    mov rsi, rax        ;копируем указатель на результат
    mov rdi, ResultBuff ;целевой буфер
.copyLoop:
    mov al, [rsi]       ;копируем байт
    mov [rdi], al       ;сохраняем в буфер
    test al, al         ;проверяем конец строки
    jz .copyDone       ;если 0 - закончили
    inc rsi             ;следующий источник данных
    inc rdi             ;следующий приемник
    jmp .copyLoop      ;продолжаем копирование
.copyDone:

    pop rsi
    pop rdi
ret

