[org 0x0100]

jmp start

titleMsg:        db " WELCOME TO ATARI BREAKOUT! ", 0
pressEnterMsg:   db "Press ENTER to Start Game", 0
pressEscMsg:     db "Press ESC to Exit", 0
intro:           db "Sumbitted by Raazia Mehmood 24F-0614 and Sabeeka 24F-0654", 0
rules1: db "RULES:", 0
rules2: db "- Break all bricks to win.", 0
rules3: db "- You have 3 lives.", 0
controls1: db "CONTROLS:", 0
controls2: db "- Move Paddle: Left/Right Arrow Keys", 0
controls3: db "- Press ESC anytime to quit.", 0
desc1: db "Hit the ball with your paddle and clear all bricks!", 0

livesMsg:  db "Lives: ", 0
scoreMsg:  db "Score: ", 0
lives:  dw 3
score:  dw 0

brickColors: dw 0x5020, 0x2020, 0x4020, 0x3020
bricksRemaining: dw 40

paddleX: dw 34        ; starting column for paddle (centered)
ballRow: dw 23        ; starting row
ballCol: dw 40        ; starting column (center)
ballDx:  dw 1         ; direction in X (1 = right, -1 = left)
ballDy:  dw -1        ; direction in Y (-1 = up, 1 = down)

gameOverMsg: db " GAME OVER! ", 0
winMsg: db " YOU WIN! ", 0
finalScoreMsg: db "Final Score: ", 0
playAgainMsg: db "Press ENTER to Play Again or ESC to Exit", 0

clrscr: 
    push es
    push ax
    push cx
    push di
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    cld
    rep stosw
    pop di 
    pop cx
    pop ax
    pop es
    ret 

printNum:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax, [bp+4]          ;ax contain number
mov bx, 10              ;to divide by 10 each time to extract digit
mov cx, 0               ;to count number of digits
nextDigit:
mov dx, 0

div bx                  ;divide by 10 (quotient in ax, remainder in dl)
add dl, 0x30            ;convert to ascii
push dx                 ;save digit on stack
inc cx                  ;incremet count of digit
cmp ax, 0               ;loop till the qoutient is not zero
jnz nextDigit
mov ax, 0xB800          ;point to start of video memory
mov es, ax
    mov al, 80
    mul byte [bp+8]
    add ax, [bp+10]
    shl ax, 1
    mov di, ax
nextPos:
pop dx                      ;pop digit from stack
mov dh, [bp+6]              ;color byte
mov [es:di], dx
add di, 2
loop nextPos
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 8

printstr: 
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    
    push ds
    pop es
    mov di, [bp+4]
    mov cx, 0xffff
    xor al, al
    repne scasb
    mov ax, 0xffff
    sub ax, cx
    dec ax
    jz exit
    
    mov cx, ax
    mov ax, 0xb800
    mov es, ax
    mov al, 80
    mul byte [bp+8]
    add ax, [bp+10]
    shl ax, 1
    mov di, ax
    mov si, [bp+4]
    mov ah, [bp+6]
    cld
    
nextchar: 
    lodsb
    stosw
    loop nextchar
    
exit: 
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 8 

winGameScreen:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    mov cx, 2000    ;set background
    mov di, 0
    mov ax, 0xB800
    mov es, ax
    mov ah, 0x67
    mov al, 0x20    
    cld
    rep stosw

    push word 35
    push word 8
    push word 0x76
    push word winMsg
    call printstr

    push word 33
    push word 12
    push word 0x6F
    push word finalScoreMsg
    call printstr
    push word 47
    push word 12
    push word 0x6F
    push word [score]
    call printNum

    push word 20
    push word 14
    push word 0x6F
    push word playAgainMsg
    call printstr

    pop es
    pop di
    pop cx
    pop ax
    pop bp 
    ret

loseGameScreen:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    mov cx, 2000
    mov di, 0
    mov ax, 0xB800
    mov es, ax
    mov ah, 0x67
    mov al, 0x20    
    cld
    rep stosw

    push word 34
    push word 8
    push word 0x76
    push word gameOverMsg
    call printstr

    push word 33
    push word 12
    push word 0x6F
    push word finalScoreMsg
    call printstr
    push word 47
    push word 12
    push word 0x6F
    push word [score]
    call printNum

    push word 20
    push word 14
    push word 0x6F
    push word playAgainMsg
    call printstr

    pop es
    pop di
    pop cx
    pop ax
    pop bp 
    ret

welcomeScreen:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    ; Clear screen with orange background
    mov cx, 2000
    mov di, 0
    mov ax, 0xB800
    mov es, ax
    mov ah, 0x67
    mov al, 0x20
    cld
    rep stosw

    ;title
    push word 25
    push word 3
    push word 0x76
    push word titleMsg
    call printstr

    ;game description
    push word 10
    push word 6
    push word 0x6E
    push word desc1
    call printstr

    ;rules
    push word 5
    push word 9
    push word 0x6F
    push word rules1
    call printstr

    push word 8
    push word 10
    push word 0x6E
    push word rules2
    call printstr

    push word 8
    push word 11
    push word 0x6E
    push word rules3
    call printstr

    ;controls
    push word 5
    push word 13
    push word 0x6F
    push word controls1
    call printstr

    push word 8
    push word 14
    push word 0x6E
    push word controls2
    call printstr

    push word 8
    push word 15
    push word 0x6E
    push word controls3
    call printstr

    ;enter/esc
    push word 27
    push word 18
    push word 0x6F
    push word pressEnterMsg
    call printstr

    push word 30
    push word 20
    push word 0x6F
    push word pressEscMsg
    call printstr

    push word 16
    push word 22
    push word 0x6E
    push word intro
    call printstr

    pop es
    pop di
    pop cx
    pop ax
    pop bp
    ret

printTop:
    push ax
    push cx
    push di
    push es

    ;row 0: priint lives and score
    push word 10       ; x 
    push word 0        ; y 
    push word 0x0F     ; white (color attribute)
    push word livesMsg
    call printstr

    push word 18       ; x
    push word 0        ; y
    push word 0x0F     ; color
    push word [lives]  ; value
    call printNum

    push word 50
    push word 0
    push word 0x0F
    push word scoreMsg
    call printstr

    push word 58       ; x
    push word 0        ; y
    push word 0x0F     ; color
    push word [score]  ; value
    call printNum

    ;row 1: print a line
    mov ax, 0xB800
    mov es, ax
    mov di, 80*1*2         ; Row 1 offset
    mov cx, 80             ; 80 characters
    mov ah, 0x07           ; white
    mov al, '-'            ; ------------
    rep stosw

    pop es
    pop di
    pop cx
    pop ax
    ret


PrintBrick:
    push bp
    mov bp, sp
    push ax
    push cx
    push dx

    mov dx, 10

Print:
    mov ax, [bp+4]
    mov cx, 7
    rep stosw
    mov ax, 0x0720
    stosw 
    dec dx
    jnz Print
    
    pop dx
    pop cx
    pop ax
    pop bp
    ret 2

drawBricks:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov ax, 0xb800
    mov es, ax

    mov bx, 2   ;start bricks from 3rd row
    mov cx, 4
    mov si, 0
    
row_loop:
    mov ax, 80
    mul bx
    shl ax, 1
    mov di, ax

    mov ax, [brickColors+si]
    push ax
    call PrintBrick

    inc bx
    add si, 2
    loop row_loop

    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;PADDLE FUNCTIONS
clearPaddle:
    push ax
    push bx
    push cx
    push di
    push es

    mov ax, 0xB800
    mov es, ax

    ; Calculate position: (24 * 80 + paddleX) * 2
    mov ax, 24
    mov bl, 80
    mul bl
    add ax, [paddleX]
    shl ax, 1
    mov di, ax

    mov cx, 12
    mov ax, 0x0720  ;space character
    rep stosw

    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

drawPaddle:
    push ax
    push bx
    push cx
    push di
    push es

    mov ax, 0xB800
    mov es, ax

    mov ax, 24
    mov bl, 80
    mul bl
    add ax, [paddleX]
    shl ax, 1
    mov di, ax

    mov ah, 0x10      ; blue background for paddle
    mov al, 0x20      ; space

    mov cx, 12
    rep stosw

    pop es
    pop di
    pop cx
    pop bx
    pop ax
    ret

;BALL FUNCTIONS
drawBall:
    push ax
    push bx
    push di
    push es

    mov ax, 0xB800
    mov es, ax

    ; Calculate position
    mov ax, [ballRow]
    mov bl, 80
    mul bl
    add ax, [ballCol]
    shl ax, 1
    mov di, ax

    mov ah, 0x0F      ; white
    mov al, 'o'       ; ball character
    mov [es:di], ax

    pop es
    pop di
    pop bx
    pop ax
    ret

eraseBall:
    push ax
    push bx
    push di
    push es

    mov ax, 0xB800
    mov es, ax

    mov ax, [ballRow]
    mov bl, 80
    mul bl
    add ax, [ballCol]
    shl ax, 1
    mov di, ax

    mov ax, 0x0720  ;space character
    mov [es:di], ax

    pop es
    pop di
    pop bx
    pop ax
    ret

;COLLISION DETECTION
checkWallCollision:
    ; Left wall
    cmp word [ballCol], 0
    jle .bounceX
    
    ; Right wall
    cmp word [ballCol], 79
    jge .bounceX
    
    ;top wall
    cmp word [ballRow], 2
    jg .checkBottom    
    
    neg word [ballDy]   ;bounce y
    mov word [ballRow], 2
    jmp .done

.checkBottom:
    cmp word [ballRow], 25
    jge .loseLife
    
    jmp .done

.bounceX:
    neg word [ballDx]
    jmp .done

.bounceY:
    neg word [ballDy]
    jmp .done

.loseLife:
    dec word [lives]         ; lose 1 life
    call updateLives         ; update display
    call playLifeLostSound

    cmp word [lives], 0
    jle .done     ; if 0 then game over
    push ax
    ; reset ball to starting position
    mov ax, [paddleX]
    add ax, 5
    mov word [ballRow], 23
    mov word [ballCol], ax
    mov word [ballDy], -1     ; ball will go upward
    mov word [ballDx], 1
    pop ax
.done:
    ret

checkPaddleCollision:
    ; Check if ball is at paddle row (row 23, above paddle at 24)
    cmp word [ballRow], 23
    jne .noPaddle
    
    ; Check if ball is moving down
    cmp word [ballDy], 1
    jne .noPaddle
    
    ; Check if ballCol is within paddle range
    mov ax, [ballCol]
    mov bx, [paddleX]
    
    ; Is ball >= paddleX?
    cmp ax, bx
    jl .noPaddle
    
    ; Is ball <= paddleX + 12?
    add bx, 12
    cmp ax, bx
    jg .noPaddle
    
    ;hit the paddle, so Bounce up
    neg word [ballDy]
    call playPaddleSound

.noPaddle:
    ret

checkBrickCollision:
    ; Check if ball is in brick area (rows 2-5)
    cmp word [ballRow], 2
    jl .noBrick
    cmp word [ballRow], 5
    jg .noBrick
    
    push es
    push di
    push ax
    push bx
    push cx
    mov ax, 0xB800
    mov es, ax
    
    ; Calculate offset where ball is
    mov ax, [ballRow]
    mov bl, 80
    mul bl
    add ax, [ballCol]
    shl ax, 1
    mov di, ax
    
    ; Read attribute byte (color)
    mov ah, [es:di+1]
    
    ; if it's black (no brick)
    cmp ah, 0x00
    je .noBrickHit
    cmp ah, 0x07
    je .noBrickHit
    
    ; Check if it's a space character
    mov al, [es:di]
    cmp al, 0x20
    jne .noBrickHit
    
    ;IT'S A BRICK, FIND START OF BRICK
    
    ; Calculate which brick column we hit
    mov ax, [ballCol]
    xor dx, dx
    mov bx, 8           ; Each brick is 7 chars + 1 space = 8 total
    div bx              ; AX = brick number, DX = position within brick
    
    ; Calculate starting column of this brick
    mov bx, 8
    mul bx              ; AX = brick_number * 8
    mov bx, ax          ; BX = starting column of brick
    
    ; Calculate video memory offset for brick start
    mov ax, [ballRow]
    mov cl, 80
    mul cl
    add ax, bx          ; AX = (row * 80) + brick_start_col
    shl ax, 1           ; Convert to byte offset
    mov di, ax
    
    ;erase the entire brick (7 characters)
    mov cx, 7           ; Brick width
    mov ax, 0x0720      ; Black background, space

.eraseBrick:
    mov [es:di], ax
    add di, 2           ; Next character
    loop .eraseBrick
    
    ; Bounce ball
    neg word [ballDy]
    
    call playBrickSound
    
    ;add scores
    add word[score], 10
    call updateScore
    ;decrement number of bricks
    dec word[bricksRemaining]
    
.noBrickHit:
    pop cx
    pop bx
    pop ax
    pop di
    pop es

.noBrick:
    ret

updateBall:
    call eraseBall

    ; Update position
    mov ax, [ballRow]
    add ax, [ballDy]
    mov [ballRow], ax

    ; PREVENT going above row 2
    cmp ax, 2
    jge .okTop
    mov word [ballRow], 2

.okTop:
    mov ax, [ballCol]
    add ax, [ballDx]
    mov [ballCol], ax

    call checkWallCollision
    call checkPaddleCollision
    call checkBrickCollision

    ; Draw new position
    call drawBall
    ret

updateLives:
    push word 18       ; x
    push word 0        ; y
    push word 0x0F     ; color
    push word [lives]  ; value
    call printNum
    ret

updateScore:
    push word 58       ; x
    push word 0        ; y
    push word 0x0F     ; color
    push word [score]  ; value
    call printNum
    ret

delay:
    push cx
    push dx
    
    mov cx, 400      
.outer:
    mov dx, 400
.inner:
    dec dx
    jnz .inner
    dec cx
    jnz .outer
    
    pop dx
    pop cx
    ret

playBrickSound:
    push ax
    push bx
    push cx
    
    in al, 0x61
    or al, 0x03
    out 0x61, al
    
    mov al, 0xB6
    out 0x43, al
    mov ax, 2000
    out 0x42, al
    mov al, ah
    out 0x42, al
    
    mov cx, 3000
.wait1:
    loop .wait1
    
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    
    pop cx
    pop bx
    pop ax
    ret

playPaddleSound:
    push ax
    push bx
    push cx
    
    in al, 0x61
    or al, 0x03
    out 0x61, al
    
    mov al, 0xB6
    out 0x43, al
    mov ax, 4000
    out 0x42, al
    mov al, ah
    out 0x42, al
    
    mov cx, 2000
.wait2:
    loop .wait2
    
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    
    pop cx
    pop bx
    pop ax
    ret

playLifeLostSound:
    push ax
    push bx
    push cx
    
    in al, 0x61
    or al, 0x03
    out 0x61, al
    
    mov al, 0xB6
    out 0x43, al
    mov ax, 8000
    out 0x42, al
    mov al, ah
    out 0x42, al
    
    mov cx, 8000
.wait3:
    loop .wait3
    
    in al, 0x61
    and al, 0xFC
    out 0x61, al
    
    pop cx
    pop bx
    pop ax
    ret


resetGameState:
    mov word [lives], 3
    mov word [score], 0
    mov word [bricksRemaining], 40
    mov word [paddleX], 34
    mov word [ballRow], 23
    mov word [ballCol], 40
    mov word [ballDx], 1
    mov word [ballDy], -1
    ret

;main game
start:
    call welcomeScreen

.waitWelcome:
    mov ah, 0x00
    int 0x16
    
    cmp ah, 0x1C      ; ENTER?
    je startGame
    
    cmp ah, 0x01      ; ESC?
    je near gameExit
    
    jmp .waitWelcome

startGame:
    call clrscr
    call drawBricks
    call drawPaddle
    call drawBall
    call printTop

gameLoop:
    ;check key pressed
    mov ah, 0x01
    int 0x16
    jz .noKey
    
    mov ah, 0x00
    int 0x16
    
    cmp ah, 0x01      ; ESC key?
    je .gameEnd
    
    cmp ah, 0x4B      ; LEFT arrow?
    je .moveLeft
    
    cmp ah, 0x4D      ; RIGHT arrow?
    je .moveRight
    
    jmp .noKey

.moveLeft:
    cmp word [paddleX], 0
    jle .noKey
    
    call clearPaddle
    sub word [paddleX], 3
    cmp word [paddleX], 0
    jge .drawLeft
    mov word [paddleX], 0
    
.drawLeft:
    call drawPaddle
    jmp .noKey

.moveRight:
    cmp word [paddleX], 68
    jge .noKey
    
    call clearPaddle
    add word [paddleX], 3
    cmp word [paddleX], 68
    jle .drawRight
    mov word [paddleX], 68
    
.drawRight:
    call drawPaddle

.noKey:
    call updateBall ;keep ball moving continously
    call delay
    
    ;Check game conditions
    cmp word [lives], 0
    je .gameEnd
    
    cmp word [bricksRemaining], 0
    je .gameWin
    
    jmp gameLoop    ;Continue playing

.gameEnd:
    call loseGameScreen
    
.waitEnd:
    mov ah, 0x00
    int 0x16
    
    cmp ah, 0x1C      ; ENTER to restart?
    je .restart
    
    cmp ah, 0x01      ; ESC to exit?
    je gameExit
    
    jmp .waitEnd

.gameWin:
    call winGameScreen
    
.waitWin:
    mov ah, 0x00
    int 0x16
    
    cmp ah, 0x1C      ; ENTER to restart?
    je .restart
    
    cmp ah, 0x01      ; ESC to exit?
    je gameExit
    
    jmp .waitWin

.restart:
    call resetGameState
    jmp startGame     ; Restart game

gameExit:
    call clrscr
    mov ax, 0x4c00
    int 0x21
