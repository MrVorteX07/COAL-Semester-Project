org 100h

jmp start

;---main-screen variables---
score_label db 'Score: ',0
player_score dw 0
game_name db 'NFSx86',0

;---game-control-variables---
game_speed dw 6
random_seed db 0


;---cars-customization-variables---
; Color pallete: Each table: [body], [wheel], [back light], [front light], [chassis]
; m=white front lights, !,@=red back lights
; #=wheel, _= body, anyother = chassis

;npc size4x8
car_colors_npc db 09h, 00h, 0Ch, 0Fh, 0Eh   ; npc car colors
car_rown1 db '  m___m ',0
car_rown2 db ' #/___\#',0
car_rown3 db '  {___} ',0
car_rown4 db ' #!___!#',0

;player size7x10
car_colors_player db 40h, 00h, 4Ch, 4Fh, 40h, 6Eh   ; player car colors
car_rowp1 db '   m^^m   ',0
car_rowp2 db '##/____\##',0
car_rowp3 db '##\____/##',0
car_rowp4 db '  [____]  ',0
car_rowp5 db '##/____\##',0
car_rowp6 db '##\@%%@/##',0
car_rowp7 db '  ||  ||  ',0


;---NPC-animation-data/variables----
;npc-movement variables
lane_positions db 22, 35, 48
num_lanes db 3

;npc1
npc1_row db 0
npc1_col db 22
npc1_active db 0      ; 0 not active, 1 active

;npc2
npc2_row db 0
npc2_col db 35
npc2_active db 0

;npc3
npc3_row db 0
npc3_col db 48
npc3_active db 0

;---coin-data/variables----
coin_positions db 25, 40, 50
coin_value dw 10

coin1_row db 0
coin1_col db 25
coin1_active db 0
coin1_speed_counter dw 10  ;loop
coin1_speed dw 1

coin2_row db 0
coin2_col db 40
coin2_active db 0
coin2_speed_counter dw 0
coin2_speed dw 10

coin1_respawn_timer dw 0
coin2_respawn_timer dw 0
coin_respawn_delay dw 40     ;delay btw respawns


;---fuel-data/variables---
fuel_row db 0
fuel_col db 0
fuel_active db 0
fuel_speed_counter dw 0

fuel_base_speed dw 5
fuel_respawn_delay dw 50
fuel_respawn_timer dw 0

player_fuel dw 100
fuel_max dw 100
fuel_decay_counter dw 20
fuel_decay_rate dw 3
fuel_refill_amount dw 10
game_over_fuel_msg db 'GAME OVER - OUT OF FUEL!$'

;---road-animation-data/variables---
road_scroll_offset db 0 
road_scroll_counter dw 0

;---tree-animation-data/variables---
MAX_TREES_PER_SIDE equ 6

;left trees (0-18)
tree_left_rows db 0,0,0,0,0,0           ;row positions
tree_left_cols db 0,0,0,0,0,0           ;column positions
tree_left_active db 0,0,0,0,0,0         ;active flags
tree_left_speed_counters dw 0,0,0,0,0,0 ;speed counters

;right trees (61-78)
tree_right_rows db 0,0,0,0,0,0
tree_right_cols db 0,0,0,0,0,0
tree_right_active db 0,0,0,0,0,0
tree_right_speed_counters dw 0,0,0,0,0,0

tree_base_speed dw 2    ;base speed
tree_spawn_row db 5     ;spawn below fuel bar (row 5)

;---player-movement-data/variables---
KEY_LEFT equ 4Bh
KEY_RIGHT equ 4Dh
KEY_UP equ 48h
KEY_DOWN equ 50h
KEY_ESC equ 01h
KEY_Y equ 15h
KEY_N equ 31h

;player state
player_row db 15
player_col db 35
player_lane db 1                ; 0 = left(col:22), 1 = center(col:35), 2 = right(col:48)

old_kb_seg dw 0
old_kb_off dw 0


;--pause-screen/end-box-data----
game_paused db 0
game_started db 0
end_reason db 0                 ; 0 = none, 1 = fuel, 2 = crash, 3 = quit
pause_msg db 'GAME PAUSED', 0
quit_msg db 'Do you want to quit? (Y/N)', 0
goodbye_msg db 'Thanks for playing NFSx86!', 0
end_inst db 'Press any Key to Exit... ', 0
see_you db 'See you again, ', 0
race db 'Racer', 0

;---collisions-data/variables---
spark_char db '*',
num_sparks db 15
spark_center_row db 0
spark_center_col db 0
spark_color db 0Eh

;---screen-variables/data---
current_screen db 0
player_name db 20 dup(0)        ;max 20 chars
player_name_len db 0
player_rollno db 15 dup(0)      ;max 15
player_rollno_len db 0

;----printing-messages----
;---introduction-screen-messages---
intro_title db 'NFSx86 - NEED FOR SPEED x86', 0
intro_dev1 db 'Developed by:', 0
intro_dev2 db 'Name: [Ali Jawad]', 0
intro_dev3 db 'Roll No: [24L-0531]', 0
intro_dev4 db 'Name: [Aneeq Kamran]', 0
intro_dev5 db 'Roll No: [24L-0554]', 0
intro_loading db 'Loading', 0

;---player-input-screen---
name_prompt db 'Enter your name: ', 0
rollno_prompt db 'Enter your roll number: ', 0

;---instruction-screen---
inst_title db 'GAME INSTRUCTIONS', 0
welcome_msg db 'Welcome, ', 0
inst_1 db 'Arrow Keys - Move your car', 0
inst_2 db 'LEFT/RIGHT - Change lanes', 0
inst_3 db 'UP/DOWN - Move vertically', 0
inst_4 db 'Collect $ coins for points', 0
inst_5 db 'Collect + fuel to refill', 0
inst_6 db 'Avoid NPC cars!', 0
inst_7 db 'ESC - Pause game', 0
inst_8 db 'Press any key to continue...', 0

;---main-screen---
main_title db 'NFSx86', 0
start_msg db 'Press any key to start...', 0

;---end-screen---
end_title db 'GAME OVER', 0
end_fuel_msg db 'Cause: Out of Fuel', 0
end_crash_msg db 'Cause: Car Crash', 0
end_quit_msg db 'Cause: Player Quit', 0
end_name_label db 'Player: ', 0
end_roll_label db 'Roll No: ', 0
end_score_label db 'Final Score: ', 0
end_options db 'SPACE - Main Menu  |  ESC - Exit', 0

;---confirmation-screen---
confirm_msg db 'Do you want to exit?', 0
confirm_options db 'Y - Yes  |  N - No', 0

;---animated-screen-intro-data---
;display-car
intro_car_1  db '              ____----------- _____', 0
intro_car_2  db ' \~~~~~~~~~~/~_--~~~------~~~~~     \', 0
intro_car_3  db '  `---`\  _-~      |                   \', 0
intro_car_4  db '    _-~  <_         |                     \[]', 0
intro_car_5  db '  / ___     ~~--[""] |      ________-------_', 0
intro_car_6  db ' > /~` \    |-.   `\~~.~~~~~                _ ~ - _', 0
intro_car_7  db '  ~|  ||\%  |       |    ~  ._                ~ _   ~ ._', 0
intro_car_8  db '    `_//|_%  \      |          ~  .              ~-_   /\', 0
intro_car_9  db '           `--__     |    _-____  /\               ~-_ \/.', 0
intro_car_10 db '                ~--_ /  ,/ -~-_ \ \/          _______---~/', 0
intro_car_11 db '                    ~~-/._<   \ \`~~~~~~~~~~~~~     ##--~/', 0
intro_car_12 db '                          \    ) |`------##---~~~~-~  ) )', 0
intro_car_13 db '                           ~-_/_/                  ~~ ~~', 0

animated_title db 'N E E D   F O R   S P E E D   x 8 6', 0
loading_text db 'Loading', 0
press_any_text db 'Press any key...', 0
anititle_2 db 'x 8 6', 0

;---difficulty-settings
difficulty_level db 1           ; 0 = Easy, 1 = Medium, 2 = Hard
selected_option db 1

;---difficulty-screen---
diff_title db 'SELECT DIFFICULTY', 0
diff_easy db 'EASY', 0
diff_medium db 'MEDIUM', 0
diff_hard db 'HARD', 0
diff_desc_easy db 'Slow NPCs, More fuel', 0
diff_desc_medium db 'Normal speed, Balanced', 0
diff_desc_hard db 'Fast NPCs, Less fuel', 0
diff_instruction db 'Use UP/DOWN arrows, ENTER to select', 0


;---keyboard-isr-variables---
old_kb_vector dd 0
key_flag_left db 0
key_flag_right db 0
key_flag_up db 0
key_flag_down db 0
key_flag_pause db 0
key_flag_resume db 0
key_flag_quit db 0

;animated-intro subroutine
show_animated_intro:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
	;block all key-presses at this state
flush_kb_intro:
    mov ah, 01h
    int 16h
    jz intro_kb_clear
    mov ah, 00h
    int 16h
    jmp flush_kb_intro
    
intro_kb_clear:
    ;make screen-black
    mov ax, 0003h
    int 10h
    
    mov ax, 0b800h
    mov es, ax
    
    ;flash effect
    call flash_intro
    
    ;draw-animated title letter by letter
    mov di, 160 * 3 + 2 * 22
    mov si, animated_title
    
animate_title:
    lodsb
    cmp al, 0
    je title_done
    
    ;skip spaces
    cmp al, ' '
    je quick_space
    
    mov ah, 17h
    push si
    push di
    mov [es:di], ax
    pop di
    pop si
    
    ;short-delay
    call short_delay_intro
    
    add di, 2
    jmp animate_title
    
quick_space:
    add di, 2
    jmp animate_title
    
title_done:
	mov di, 160 * 3 + 2 * 22
    mov si, animated_title
	call print_blinking_text
	
	call draw_intro_car_animated
    
    call show_loading_bar_animated
    
    ;wait
	call long_delay
    
    ;fade-out
    call fade_out_screen

    ;flush
flush_kb_exit_intro:
    mov ah, 01h
    int 16h
    jz done_flush_intro
    mov ah, 00h
    int 16h
    jmp flush_kb_exit_intro
    
done_flush_intro:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;subroutine
flash_intro:
    push ax
    push cx
    push di
    
    ;flash lightblue
    xor di, di
    mov cx, 2000
    mov ax, 0EDBh
    rep stosw
    
    call very_short_delay_intro
    
    ;flash yellow
    xor di, di
    mov cx, 2000
    mov ax, 05DBh
    rep stosw
    
    call very_short_delay_intro
    
    ;flash cyan
    xor di, di
    mov cx, 2000
    mov ax, 01DBh
    rep stosw
    
    pop di
    pop cx
    pop ax
    ret

;drawing-subroutine
draw_intro_car_animated:
    push ax
    push di
    push si
    
    ;row-wise
    mov di, 160 * 6 + 2 * 12
    mov si, intro_car_1
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 7 + 2 * 12
    mov si, intro_car_2
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 8 + 2 * 12
    mov si, intro_car_3
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 9 + 2 * 12
    mov si, intro_car_4
    call print_car_line_animated
    call very_short_delay_intro

    mov di, 160 * 10 + 2 * 12
    mov si, intro_car_5
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 11 + 2 * 12
    mov si, intro_car_6
    call print_car_line_animated
    call very_short_delay_intro

    mov di, 160 * 12 + 2 * 12
    mov si, intro_car_7
    call print_car_line_animated
    call very_short_delay_intro

    mov di, 160 * 13 + 2 * 12
    mov si, intro_car_8
    call print_car_line_animated
    call very_short_delay_intro

    mov di, 160 * 14 + 2 * 12
    mov si, intro_car_9
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 15 + 2 * 12
    mov si, intro_car_10
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 16 + 2 * 12
    mov si, intro_car_11
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 17 + 2 * 12
    mov si, intro_car_12
    call print_car_line_animated
    call very_short_delay_intro
    
    mov di, 160 * 18 + 2 * 12
    mov si, intro_car_13
    call print_car_line_animated
    
    pop si
    pop di
    pop ax
    ret

;subroutine
print_car_line_animated:
    push ax
    
loopl:
    lodsb
    cmp al, 0
    je doneAni
    
    ;color-based printing
    cmp al, '#'
    je wheel_color1
    cmp al, '~'
    je body_color1
    cmp al, '-'
    je body_color1
    cmp al, '_'
    je body_color1
    cmp al, '|'
    je body_color1
    cmp al, '/'
    je body_color1
    cmp al, '\'
    je body_color1
    cmp al, '['
    je window_color
    cmp al, ']'
    je window_color
    cmp al, '"'
    je window_color
    
	;def color
    mov ah, 1Bh
    jmp write
    
wheel_color1:
    mov ah, 18h
    jmp write
    
body_color1:
    mov ah, 1Eh
    jmp write
    
window_color:
    mov ah, 10h
    
write:
    stosw
    jmp loopl
    
doneAni:
    pop ax
    ret

;ani-loading bar subroutine
show_loading_bar_animated:
    push ax
    push cx
    push di
    push si
    
    ;show-loading text
    mov di, 160 * 18 + 2 * 36
    mov si, loading_text
    mov ah, 1Eh
    
print_loading:
    lodsb
    cmp al, 0
    je start_bar
    stosw
    jmp print_loading
    
start_bar:
    mov cx, 3
    
dot_loop:
    push cx
    mov ax, 1E2Eh
    stosw
    call very_short_delay_intro
    pop cx
    loop dot_loop
    
    ;draw empty bar first
    mov di, 160 * 20 + 2 * 28
    mov ax, 0E5Bh
    stosw
    
    mov cx, 24
    mov ax, 07B0h
    rep stosw
    
    mov ax, 0E5Dh
    stosw
    
    ;fill bar linearly
    mov cx, 24
    mov di, 160 * 20 + 2 * 29
    
fill_loop:
    push cx
    
	;fill with
    mov ax, 0ADBh
    stosw
    
    call very_short_delay_intro
    
    pop cx
    loop fill_loop
    
    pop si
    pop di
    pop cx
    pop ax
    ret

;subroutine
print_blinking_text:
    push ax
	mov cx, 30
    
loopl2:
    lodsb
	call very_short_delay_intro
    mov ah, 1Eh
	stosw
    loop loopl2
	
	mov cx, 5
	mov di, 160 * 3 + 2 * 52
    mov si, anititle_2
loopl21:
    lodsb
	call very_short_delay_intro
    mov ah, 14h
	stosw
    loop loopl21
    
    pop ax
    ret
	
;similar second for intro screen
print_blinking_text2:
    push ax
	mov cx, 27
    
looplt2:
    lodsb
	call very_short_delay_intro
    mov ah, 0Ch
	stosw
    loop looplt2

    pop ax
    ret

;fade-out subroutine
fade_out_screen:
    push ax
    push cx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    xor di, di
    mov cx, 2000
    
fade1:
;darken step by step in 3 steps low-high progressively
    mov ax, [es:di]
    and ah, 0F0h
    mov [es:di], ax
    add di, 2
    loop fade1
    
    call very_short_delay_intro
    
	;more
    xor di, di
    mov cx, 2000
    
fade2:
    mov ax, [es:di]
    and ah, 00h
    mov ah, 08h
    mov [es:di], ax
    add di, 2
    loop fade2
    
    call very_short_delay_intro
    
	;full black
    mov ax, 0003h
    int 10h
    
    pop es
    pop di
    pop cx
    pop ax
    ret

;delay subroutines
very_short_delay_intro:
    push cx
    mov cx, 1
outer1:
    push cx
    mov cx, 0FFFFh
inner1:
    nop
    loop inner1
    pop cx
    loop outer1
    pop cx
    ret

short_delay_intro:
    push cx
    mov cx, 5
loop3:
    call very_short_delay_intro
    loop loop3
    pop cx
    ret

;start-screen(initalizer) subroutine
show_start_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    ;initalize game
    call draw_game
    call spawn_initial_npcs
    call init_coin_timers
    call init_fuel_timer
    call init_trees
    
    ;display start_msg
    mov ax, 0b800h
    mov es, ax
    
    mov di, 160 * 12 + 2 * 30
    mov si, start_msg
    
print_start:
    lodsb
    cmp al, 0
    je wait_key
    mov ah, 0Eh
    stosw
    jmp print_start
    
wait_key:
    ;wait 
    mov ah, 00h
    int 16h 
    
    ;clear-redraw road
    mov di, 160 * 12 + 2 * 25
    mov cx, 30
    mov ax, 08DBh
    rep stosw
    
    ;set game as started
    mov byte [game_started], 1
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;dev-info screen subroutine
show_intro_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
	
;same as ani-screen
flush_kb_intro_screen:
    mov ah, 01h
    int 16h
    jz intro_screen_kb_clear
    mov ah, 00h
    int 16h
    jmp flush_kb_intro_screen
    
intro_screen_kb_clear:
    ;clear screen
    mov ax, 0003h
    int 10h
	
	call hideCursor
    
    mov ax, 0b800h
    mov es, ax
    
    ;title
    mov di, 160 * 5 + 2 * 26
    mov si, intro_title
	mov ax, 0Fh ;color
	push ax
    call print_centered_string
    
    ;draw-box
    call draw_title_box
    
    ;devs
    mov di, 160 * 10 + 2 * 30
    mov si, intro_dev1
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 12 + 2 * 28
    mov si, intro_dev2
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 13 + 2 * 28
    mov si, intro_dev3
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 15 + 2 * 28
    mov si, intro_dev4
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 16 + 2 * 28
    mov si, intro_dev5
	mov ax, 0Eh ;color
	push ax
    call print_string_color
	
	mov di, 160 * 5 + 2 * 26
    mov si, intro_title
	call print_blinking_text2
    
	mov cx, 60

loopdel:
	call very_short_delay_intro
	loop loopdel

flush_kb_exit_intro_screen:
    mov ah, 01h
    int 16h
    jz done_intro_screen
    mov ah, 00h
    int 16h
    jmp flush_kb_exit_intro_screen
    
done_intro_screen:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;print colored string subroutine
print_string_color:
    push bp
    mov bp, sp
    push ax
    push dx
    
    mov dx, [bp+4]
    
print_loop:
    lodsb
    cmp al, 0
    je done_print
	cmp al, '+'
	je set_colr
	cmp al, '$'
	je set_colr2
    mov ah, dl
    stosw
    jmp print_loop

set_colr:
	mov ah, 0Ch
	stosw
	jmp print_loop

set_colr2:
	mov ah, 0Eh
	stosw
	jmp print_loop

done_print:
    pop dx
    pop ax
    pop bp
    ret 2

;subroutine
print_centered_string:
    push bp
    mov bp, sp
    push ax
    push dx
    
    mov dx, [bp+4]
   
loop5:
    lodsb
    cmp al, 0
    je done5
    mov ah, dl
    stosw
    jmp loop5
	
done5:
    pop dx
    pop ax
    pop bp
    ret 2

;subroutine
draw_title_box:
    push ax
    push cx
    push di
    
    mov di, 160 * 4 + 2 * 20
    mov cx, 40
    mov ax, 0FC4h
    rep stosw
    
    mov di, 160 * 6 + 2 * 20
    mov cx, 40
    mov ax, 0FC4h
    rep stosw

    mov di, 160 * 4 + 2 * 20
    mov ax, 0FDAh
    stosw
    
    mov di, 160 * 4 + 2 * 59
    mov ax, 0FBFh
    stosw
    
    mov di, 160 * 6 + 2 * 20
    mov ax, 0FC0h
    stosw
    
    mov di, 160 * 6 + 2 * 59
    mov ax, 0FD9h
    stosw
    
    pop di
    pop cx
    pop ax
    ret

;delay subroutines
short_delay:
    push cx
    mov cx, 5
outer3:
    push cx
    mov cx, 0FFFFh
inner3:
    nop
    loop inner3
    pop cx
    loop outer3
    pop cx
    ret

long_delay:
    push cx
    mov cx, 20
loop6:
    call short_delay
    loop loop6
    pop cx
    ret
	
;name-input subroutine
show_name_input_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
esc_pressed0:
    ; mov ax, 0003h
    ; int 10h
	
	mov ax, 0b800h
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ah, 07h
    mov al, 0DBh
    rep stosw
	
	call hideCursor
    
    mov ax, 0b800h
    mov es, ax
    
    mov di, 160 * 10 + 2 * 25
    mov si, name_prompt
	mov ax, 7Eh ;color
	push ax
    call print_string_color
    
    call get_player_name
    
    cmp al, 1Bh
    je show_confirm
    
    mov di, 160 * 12 + 2 * 25
    mov si, rollno_prompt
	mov ax, 7Eh ;color
	push ax
    call print_string_color
    
    call get_player_rollno
    
    cmp al, 1Bh
    je show_confirm
    
    jmp done6
    
show_confirm:
    call show_confirmation_screen
    cmp al, 'y'
    je exit_game
    cmp al, 'Y'
    je exit_game
    
	;if N
    jmp esc_pressed0
    
exit_game:
    call cleanup_and_exit
    
done6:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;subroutine
get_player_name:
    push bx
    push cx
    push di
    
    xor bx, bx
    mov di, 160 * 10 + 2 * 43
    
input_loop:
	;read
    mov ah, 00h
    int 16h
    
    ;esc check
    cmp al, 1Bh
    je done7
    
    ;enter check
    cmp al, 0Dh
    je done7
    
    ;backspace check
    cmp al, 08h
    je backspace
    
    ;printable check
    cmp al, 20h
    jb input_loop
    cmp al, 7Eh
    ja input_loop
    
    ;check max len
    cmp bl, 19
    jae input_loop
    
    ;store
    mov [player_name + bx], al
    inc bl
    
    ;display
    push ax
    mov ah, 7Eh
    stosw
    pop ax
    
    jmp input_loop
    
backspace:
    cmp bl, 0
    je input_loop
    
    dec bl
    mov byte [player_name + bx], 0
    sub di, 2
    
    push ax
    mov ax, 7E20h
    mov [es:di], ax
    pop ax
    
    jmp input_loop
    
done7:
    mov [player_name_len], bl
    
    pop di
    pop cx
    pop bx
    ret

;subroutine (smillar to name)
get_player_rollno:
    push bx
    push cx
    push di
    
    xor bx, bx
    mov di, 160 * 12 + 2 * 48
    
input_loop1:
    mov ah, 00h
    int 16h
    
    cmp al, 1Bh
    je done8
    
    cmp al, 0Dh
    je done8
    
    cmp al, 08h
    je backspace1
    
    cmp al, 20h
    jb input_loop1
    cmp al, 7Eh
    ja input_loop1
    
    cmp bl, 14
    jae input_loop1
    
    mov [player_rollno + bx], al
    inc bl
    
    push ax
    mov ah, 7Eh
    stosw
    pop ax
    
    jmp input_loop1
    
backspace1:
    cmp bl, 0
    je input_loop1
    
    dec bl
    mov byte [player_rollno + bx], 0
    sub di, 2
    
    push ax
    mov ax, 7E20h
    mov [es:di], ax
    pop ax
    
    jmp input_loop1
    
done8:
    mov [player_rollno_len], bl
    
    pop di
    pop cx
    pop bx
    ret
	
;instruction-screen subroutine
show_instruction_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
esc_pressed:
	;set bg
	mov ax, 0600h
	mov bh, 50h
	mov cx, 0000h
	mov dx, 184Fh
	int 10h
    
    mov ax, 0b800h
    mov es, ax
    
	;printing
    mov di, 160 * 3 + 2 * 28
    mov si, inst_title
	mov ax, 5Fh ;color
	push ax
    call print_centered_string
    
    mov di, 160 * 5 + 2 * 25
    mov si, welcome_msg
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov si, player_name
	mov ax, 53h ;color
	push ax
    call print_string_color
    
    mov ax, 5E21h
    stosw
    
    mov di, 160 * 8 + 2 * 22
    mov si, inst_1
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 10 + 2 * 22
    mov si, inst_2
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 11 + 2 * 22
    mov si, inst_3
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 13 + 2 * 22
    mov si, inst_4
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 14 + 2 * 22
    mov si, inst_5
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 15 + 2 * 22
    mov si, inst_6
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 17 + 2 * 22
    mov si, inst_7
	mov ax, 5Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 20 + 2 * 25
    mov si, inst_8
	mov ax, 5Bh ;color
	push ax
    call print_string_color
    
    ;Wait
wait_key1:
    mov ah, 00h
    int 16h
    
    ;esc check
    cmp ah, 01h
    je show_confirm1
    
    jmp done9
    
show_confirm1:
    call show_confirmation_screen
    cmp al, 'y'
    je exit_game1
    cmp al, 'Y'
    je exit_game1
    
    ;if n
    jmp esc_pressed
    
exit_game1:
    call cleanup_and_exit
    
done9:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
;difficulty-screen subroutine
show_difficulty_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
      
esc_pressed2:
redraw_diff_screen:
    ;bg color according to selection
    mov al, [selected_option]
    cmp al, 0
    je set_easy_bg
    cmp al, 1
    je set_medium_bg
    jmp set_hard_bg
    
set_easy_bg:
    mov bl, 02h ;color
    jmp fill_screen_diff
    
set_medium_bg:
    mov bl, 06h
    jmp fill_screen_diff
    
set_hard_bg:
    mov bl, 04h
    
fill_screen_diff:
;fill
    mov ax, 0b800h
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ah, bl
    mov al, 0DBh
    rep stosw
    
	;checks
	cmp bl, 02h
	je set_bl
	cmp bl, 06h
	je set_bl2
	
set_bl3:
	mov bl, 4Fh ;title attributes
	mov dl, 4Bh ;Instructions
	jmp cont
	
set_bl2:
	mov bl, 6Fh
	mov dl, 6Bh
	jmp cont

set_bl:
	mov bl, 2Fh
	mov dl, 2Bh
	
cont:
	;draw title and stuff
	mov di, 160 * 5 + 2 * 30
    mov si, diff_title
    mov ax, bx
    push ax
    call print_string_color
    
    call draw_difficulty_options
    
    mov di, 160 * 20 + 2 * 22
    mov si, diff_instruction
    mov ax, dx
    push ax
    call print_string_color
    
wait_diff_key:
	;check key presses
    mov ah, 00h
    int 16h
    
	;up
    cmp ah, 48h
    je move_up_diff
    
	;down
    cmp ah, 50h
    je move_down_diff
	
	;enter
    cmp al, 0Dh
    je select_difficulty
	
	;esc
    cmp ah, 01h
    je show_confirm_diff
    
    jmp wait_diff_key
    
move_up_diff:
    mov al, [selected_option]
    cmp al, 0
    je wait_diff_key
    dec byte [selected_option]
    jmp redraw_diff_screen
    
move_down_diff:
    mov al, [selected_option]
    cmp al, 2
    je wait_diff_key
    inc byte [selected_option]
    jmp redraw_diff_screen
    
select_difficulty:
    ;save
    mov al, [selected_option]
    mov [difficulty_level], al
    
    ;apply
    call apply_difficulty_settings
    
    jmp done_diff
    
show_confirm_diff:
    call show_confirmation_screen
    cmp al, 'y'
    je exit_game_diff
    cmp al, 'Y'
    je exit_game_diff
    
    jmp esc_pressed2
    
exit_game_diff:
    call cleanup_and_exit
    
done_diff:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;helper subroutine
draw_difficulty_options:
    push ax
    push bx
    push cx
    push di
    push si
    
	;check selection
    mov bl, [selected_option]
	mov cl, bl
    cmp cl, 0
    je bg_is_green
    cmp cl, 1
    je bg_is_yellow
    jmp bg_is_red
    
;change bg colors respectively
bg_is_green:
    mov ch, 2Fh
    jmp draw_options
    
bg_is_yellow:
    mov ch, 6Fh
    jmp draw_options
    
bg_is_red:
    mov ch, 4Fh
    
draw_options:
    ;for easy
    mov di, 160 * 9 + 2 * 37
    mov si, diff_easy
    cmp bl, 0
    je draw_easy_selected
    mov al, ch
    push ax
    call print_string_color
    jmp draw_easy_desc
    
;on selection highlight
draw_easy_selected:
    mov ax, 2Ah
    push ax
    call print_string_color

	mov di, 160 * 10 + 2 * 28
    mov si, diff_desc_easy
    mov ax, 2Eh
    push ax
    call print_string_color
	jmp done_easy
    
;on no selection
draw_easy_desc:
    mov di, 160 * 10 + 2 * 28
    mov si, diff_desc_easy
    mov al, ch
    push ax
    call print_string_color
    
done_easy:
    ;med same as easy
    mov di, 160 * 13 + 2 * 36
    mov si, diff_medium
    cmp bl, 1
    je draw_medium_selected
    mov al, ch
    push ax
    call print_string_color
    jmp draw_medium_desc
    
draw_medium_selected:
    mov ax, 63h
    push ax
    call print_string_color
	
	mov di, 160 * 14 + 2 * 28
    mov si, diff_desc_medium
    mov ax, 6Eh
    push ax
    call print_string_color
	jmp done_med
    
draw_medium_desc:
    mov di, 160 * 14 + 2 * 28
    mov si, diff_desc_medium
    mov al, ch
    push ax
    call print_string_color
	
done_med:
    ;hard
    mov di, 160 * 17 + 2 * 37
    mov si, diff_hard
    cmp bl, 2
    je draw_hard_selected
    mov al, ch
    push ax
    call print_string_color
    jmp draw_hard_desc
    
draw_hard_selected:
    mov ax, 4Ch
    push ax
    call print_string_color
	
	mov di, 160 * 18 + 2 * 28
    mov si, diff_desc_hard
    mov ax, 4Eh
    push ax
    call print_string_color
	jmp done_hard
    
draw_hard_desc:
    mov di, 160 * 18 + 2 * 28
    mov si, diff_desc_hard
    mov al, ch
    push ax
    call print_string_color
	
done_hard:
    pop si
    pop di
    pop cx
    pop bx
    pop ax
    ret

;applying subroutine
apply_difficulty_settings:
    push ax
    push bx
    
    mov al, [difficulty_level]
    
    cmp al, 0
    je set_easy
    cmp al, 1
    je set_medium
    jmp set_hard
    
set_easy:
    mov word [game_speed], 5 ;high = slow
    mov word [fuel_decay_rate], 3 ; high = slow
    mov word [coin_value], 5  ; points
    jmp done_apply
    
set_medium:
    mov word [game_speed], 3 
    mov word [fuel_decay_rate], 1
    mov word [coin_value], 10
    jmp done_apply
    
set_hard:
    mov word [game_speed], 2
    mov word [fuel_decay_rate], 1
    mov word [coin_value], 15
    
done_apply:
    pop bx
    pop ax
    ret
	
;confirmation-screen subroutine
show_confirmation_screen:
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
    mov ax, 0b800h
    mov es, ax
    
	;draw box 
    mov dh, 10
    
draw_box:
    mov dl, 25
    
draw_row:
    push dx
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    pop dx
    
    mov ax, 7020h
    stosw
    
    inc dl
    cmp dl, 55
    jbe draw_row
    
    inc dh
    cmp dh, 15
    jb draw_box
   
    mov di, 160 * 11 + 2 * 30
    mov si, confirm_msg
    call print_string_color_inv
    
    mov di, 160 * 13 + 2 * 32
    mov si, confirm_options
    call print_string_color_inv
    
wait_key3:
    mov ah, 00h
    int 16h
    
    cmp al, 'y'
    je done10
    cmp al, 'Y'
    je done10
    cmp al, 'n'
    je done10
    cmp al, 'N'
    je done10
    
    jmp wait_key3
    
done10:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    ret
	
;helper for inverted colors
print_string_color_inv:
    push ax
    
loop7:
    lodsb
    cmp al, 0
    je done11
    mov ah, 70h
    stosw
    jmp loop7
    
done11:
    pop ax
    ret
	
;game-reset subroutine(for restarting game)
reset_game_state:
    push ax
    
    ;reset player vars
	mov byte [player_name], 0
	mov byte [player_name_len], 0
	mov byte [player_rollno], 0
	mov byte [player_rollno_len], 0
    mov word [player_score], 0
    mov word [player_fuel], 100
    mov byte [player_row], 15
    mov byte [player_col], 35
    mov byte [player_lane], 2
    mov byte [game_paused], 0
    mov byte [game_started], 0
    
    ;npc
    mov byte [npc1_active], 0
    mov byte [npc2_active], 0
    mov byte [npc3_active], 0
    
    ;coins
    mov byte [coin1_active], 0
    mov byte [coin2_active], 0
    mov word [coin1_respawn_timer], 0
    mov word [coin2_respawn_timer], 0
    
    ;fuel
    mov byte [fuel_active], 0
    mov word [fuel_respawn_timer], 0
	mov word [fuel_decay_counter], 20
	mov word [fuel_decay_rate], 3
    mov word [fuel_refill_amount], 10
    
    ;trees
    mov cx, 6
    xor bx, bx
reset_trees_loop:
    mov byte [tree_left_active + bx], 0
    mov byte [tree_right_active + bx], 0
    inc bx
    loop reset_trees_loop
    
    ;road scroll
    mov byte [road_scroll_offset], 0
    mov word [road_scroll_counter], 0
    
    ;keyboard inputs
	mov word [old_kb_seg], 0
    mov word [old_kb_off], 0
    mov byte [key_flag_left], 0
    mov byte [key_flag_right], 0
    mov byte [key_flag_up], 0
    mov byte [key_flag_down], 0
    mov byte [key_flag_pause], 0
    mov byte [key_flag_resume], 0
    mov byte [key_flag_quit], 0
    
    pop ax
    ret
	
;end-screen subroutine
show_end_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
esc_pressed3:
    mov ax, 0003h
    int 10h
	
	call hideCursor
    
    mov ax, 0b800h
    mov es, ax
    
    mov di, 160 * 3 + 2 * 35
    mov si, end_title
	mov ax, 0Fh ;color
	push ax
    call print_centered_string
    
    mov di, 160 * 6 + 2 * 28
    mov al, [end_reason]
    cmp al, 1
    je show_fuel
    cmp al, 2
    je show_crash
    jmp show_quit
    
show_fuel:
    mov si, end_fuel_msg
    jmp print_reason
    
show_crash:
    mov si, end_crash_msg
    jmp print_reason
    
show_quit:
    mov si, end_quit_msg
    
print_reason:
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 10 + 2 * 28
    mov si, end_name_label
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov si, player_name
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 11 + 2 * 28
    mov si, end_roll_label
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov si, player_rollno
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov di, 160 * 12 + 2 * 28
    mov si, end_score_label
	mov ax, 0Eh ;color
	push ax
    call print_string_color
    
    mov ax, [player_score]
    call print_number_at_di
    
    mov di, 160 * 18 + 2 * 20
    mov si, end_options
	mov ax, 04h ;color
	push ax
    call print_string_color
    
wait_key4:
    mov ah, 00h
    int 16h
    
    cmp al, 20h
    je restart1
    
    cmp ah, 01h
    je show_confirm3
    
    jmp wait_key4
    
restart1:
    call reset_game_state
    
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax


    xor ax, ax 
    mov es, ax
    xor si, si
    xor di, di
    xor dx, dx
    xor	cx, cx
    xor bx, bx
	
    jmp restart
    
show_confirm3:
    call show_confirmation_screen
    cmp al, 'y'
    je exit_game3
    cmp al, 'Y'
    je exit_game3
    
    jmp esc_pressed3
    
exit_game3:
    call cleanup_and_exit
    
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;helper subroutine
print_number_at_di:
    push ax
    push bx
    push cx
    push dx
    
    cmp ax, 0
    jne not_zero1
    
    mov ax, 0E30h
    stosw
    jmp done12
    
not_zero1:
    mov bx, 10
    xor cx, cx
    
extract:
    cmp ax, 0
    je print
    
    xor dx, dx
    div bx
    push dx
    inc cx
    jmp extract
    
print:
    pop dx
    add dl, '0'
    mov dh, 0Eh
    mov ax, dx
    stosw
    loop print
    
done12:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;keyboard-isr
keyboard_isr:
    push ax
    push bx
    push ds
    
    ;set ds
    mov ax, cs
    mov ds, ax
    
	;read
    in al, 60h
    
    mov bl, [game_started]
    cmp bl, 0
    je chain_to_old
    
    mov bl, [game_paused]
    cmp bl, 1
    je handle_paused_keys
    
	;game running
    cmp al, KEY_LEFT
    je move_left_key
    
    cmp al, KEY_RIGHT
    je move_right_key
    
    cmp al, KEY_UP
    je move_up_key
    
    cmp al, KEY_DOWN
    je move_down_key
    
    cmp al, KEY_ESC
    je pause_game_key
    
    jmp chain_to_old
    
handle_paused_keys:
    cmp al, KEY_Y
    je quit_game_key
    
    cmp al, KEY_N
    je resume_game_key
    
    cmp al, KEY_ESC
    je resume_game_key
    
    jmp chain_to_old
    
pause_game_key:
    test al, 80h
    jnz chain_to_old
    
    mov byte [game_paused], 1
    mov byte [key_flag_pause], 1
    jmp chain_to_old
    
resume_game_key:
    test al, 80h
    jnz chain_to_old
    
    mov byte [game_paused], 0
    mov byte [key_flag_resume], 1
    jmp chain_to_old
    
quit_game_key:
    test al, 80h
    jnz chain_to_old
    
    mov byte [key_flag_quit], 1
    jmp chain_to_old
    
move_left_key:
    test al, 80h
    jnz chain_to_old
    mov byte [key_flag_left], 1
    jmp chain_to_old
    
move_right_key:
    test al, 80h
    jnz chain_to_old
    mov byte [key_flag_right], 1
    jmp chain_to_old
    
move_up_key:
    test al, 80h
    jnz chain_to_old
    mov byte [key_flag_up], 1
    jmp chain_to_old
    
move_down_key:
    test al, 80h
    jnz chain_to_old
    mov byte [key_flag_down], 1
    jmp chain_to_old

chain_to_old:
    pop ds
    pop bx
    pop ax
    
    ;chain to og
    jmp far [cs:old_kb_vector]

;keyboard-flag-setting subroutine
check_keyboard:
    push ax
    
    mov al, [key_flag_pause]
    cmp al, 1
    jne check_resume
    mov byte [key_flag_pause], 0
    call show_pause_screen
    
check_resume:
    mov al, [key_flag_resume]
    cmp al, 1
    jne check_quit
    mov byte [key_flag_resume], 0
    call hide_pause_screen
    
check_quit:
    mov al, [key_flag_quit]
    cmp al, 1
    jne check_left
    mov byte [key_flag_quit], 0
    mov byte [end_reason], 3
    call show_end_screen
    
check_left:
    mov al, [key_flag_left]
    cmp al, 1
    jne check_right
    mov byte [key_flag_left], 0
    call move_player_left
    
check_right:
    mov al, [key_flag_right]
    cmp al, 1
    jne check_up
    mov byte [key_flag_right], 0
    call move_player_right
    
check_up:
    mov al, [key_flag_up]
    cmp al, 1
    jne check_down
    mov byte [key_flag_up], 0
    call move_player_up
    
check_down:
    mov al, [key_flag_down]
    cmp al, 1
    jne done_check
    mov byte [key_flag_down], 0
    call move_player_down
    
done_check:
    pop ax
    ret

;install isr
install_keyboard:
    push ax
    push bx
    push dx
    push es
    
    mov ax, 3509h
    int 21h
    mov [old_kb_vector], bx
    mov [old_kb_vector+2], es
    
    push ds
    mov ax, cs
    mov ds, ax
    mov dx, keyboard_isr
    mov ax, 2509h
    int 21h
    pop ds
    
    pop es
    pop dx
    pop bx
    pop ax
    ret

;restore
restore_keyboard:
    push ax
    push dx
    push ds
    
    mov dx, [old_kb_vector]
    mov ax, [old_kb_vector+2]
    mov ds, ax
    mov ax, 2509h
    int 21h
    
    pop ds
    pop dx
    pop ax
    ret
	
;erase-player-car subroutine
erase_player_car:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    mov cx, 7
    mov dh, [player_row]
    mov dl, [player_col]
    
erase_row_loop:
    push cx
    push dx
    
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
    mov cx, 10
    mov ax, 08DBh
    rep stosw
    
    pop dx
    inc dh
    pop cx
    loop erase_row_loop
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
;check-all-npcs-collision helper
check_all_npcs_collision:
    push bx
    
    mov al, [npc1_active]
    cmp al, 1
    jne check_npc2_helper
    call check_collision_npc1
    cmp al, 1
    je found_collision
    
check_npc2_helper:
    mov al, [npc2_active]
    cmp al, 1
    jne check_npc3_helper
    call check_collision_npc2
    cmp al, 1
    je found_collision
    
check_npc3_helper:
    mov al, [npc3_active]
    cmp al, 1
    jne no_collision_helper
    call check_collision_npc3
    cmp al, 1
    je found_collision
    
no_collision_helper:
    mov al, 0
    jmp done_helper
    
found_collision:
    mov al, 1
    
done_helper:
    pop bx
    ret
	
;move-player-left subroutine
move_player_left:
    push ax
    push bx
    push dx
    
    mov al, [player_lane]
    cmp al, 0
    je done_left
    
    ;save position
    mov bl, [player_lane]
    mov bh, [player_col]
    
	;dec and check wether collision
    dec al
    mov cl, al
    
    cmp al, 0
    je calc_col_22
    cmp al, 1
    je calc_col_35
    jmp done_left
    
calc_col_22:
    mov ch, 22
    jmp test_new_pos
    
calc_col_35:
    mov ch, 35 
    
test_new_pos:
    mov [player_lane], cl
    mov [player_col], ch
    
    call check_all_npcs_collision
    cmp al, 1
    je collision_left
    
    ;no collision load back old position and erase
    mov [player_lane], bl
    mov [player_col], bh
    call erase_player_car
    
    ;and move
    mov [player_lane], cl
    mov [player_col], ch
    jmp done_left
    
collision_left:
    mov [player_lane], bl
    mov [player_col], bh
    
    call show_collision_sparks
    call game_over_collision
    
done_left:
    pop dx
    pop bx
    pop ax
    ret

;move-player-right subroutine
move_player_right:
;same logic as left
    push ax
    push bx
    push cx
    push dx
    
    mov al, [player_lane]
    cmp al, 2
    je done_right
    
    mov bl, [player_lane]
    mov bh, [player_col]
    
    
    inc al
    mov cl, al
    
    cmp al, 1
    je calc_col_35_r
    cmp al, 2
    je calc_col_48
    jmp done_right
    
calc_col_35_r:
    mov ch, 35
    jmp test_new_pos_r
    
calc_col_48:
    mov ch, 48
    
test_new_pos_r:
    mov [player_lane], cl
    mov [player_col], ch
    
    call check_all_npcs_collision
    cmp al, 1
    je collision_right
	
    mov [player_lane], bl
    mov [player_col], bh
    call erase_player_car
	
    mov [player_lane], cl
    mov [player_col], ch
    jmp done_right
    
collision_right:
    mov [player_lane], bl
    mov [player_col], bh
    
    call show_collision_sparks
    call game_over_collision
    
done_right:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
;move-player-up subroutine
move_player_up:
    push ax
    push dx
    
    mov al, [player_row]
    cmp al, 4
    jbe doneU
    
    call erase_player_car
    
    dec byte [player_row]
    
doneU:
    pop dx
    pop ax
    ret

;move-player-down subroutine
move_player_down:
    push ax
    push dx
    
    mov al, [player_row]
    cmp al, 18
    jae doneD1
    
    call erase_player_car
    
    inc byte [player_row]
    
doneD1:
    pop dx
    pop ax
    ret
	
;pause-screen subroutine
show_pause_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
    mov ax, 0b800h
    mov es, ax
    
	;row
    mov dh, 10
    
draw_box1:
;col
    mov dl, 22
    
draw_row1:
    push dx
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    pop dx
    
    mov ax, 7020h
    stosw
    
    inc dl
    cmp dl, 58
    jb draw_row1
    
    inc dh
    cmp dh, 15
    jb draw_box1
    
    mov di, 160 * 11 + 2 * 34
    mov si, pause_msg
    
print_pause:
    lodsb
    cmp al, 0
    je print_quit
    mov ah, 70h
    stosw
    jmp print_pause
    
print_quit:
    mov di, 160 * 13 + 2 * 26
    mov si, quit_msg
    
print_quit_msg:
    lodsb
    cmp al, 0
    je doneB
    mov ah, 70h
    stosw
    jmp print_quit_msg
    
doneB:
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;hide/erase-menu subroutine
hide_pause_screen:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    mov dh, 10
    
restore_box:
    mov dl, 22
    
restore_row:
    push dx
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    pop dx
    
    mov ax, 08DBh
    stosw
    
    inc dl
    cmp dl, 58
    jb restore_row
    
    inc dh
    cmp dh, 15
    jb restore_box
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;cleanup subroutine
cleanup_and_exit:

    call restore_keyboard
    call hideCursor

    mov ax, 0b800h
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ah, 07h
    mov al, 0DBh
    rep stosw

    mov di, 160*10 + 2*27
    mov si, goodbye_msg
	mov ax, 7Eh ;color
	push ax
    call print_string_color
	
	mov di, 160 * 12 + 2 * 29
    mov si, see_you
	mov ax, 7Ch ;color
	push ax
    call print_string_color
	
	cmp byte[player_name], 0
	je print_this
	mov si, player_name
	mov ax, 7Ch ;color
	push ax
    call print_string_color
	jmp nextp

print_this:
	mov si, race
	mov ax, 7Ch ;color
	push ax
    call print_string_color
    
nextp:
    mov ax, 7C21h
    stosw
	
    mov ax, 7C01h
    stosw
	
	mov di, 160 * 15 + 2 * 28
    mov si, end_inst
	mov ax, 7Bh ;color
	push ax
    call print_string_color
	
    mov ah, 00h
    int 16h
	
	mov ax, 0003h
    int 10h
	
    mov ax, 4C00h
    int 21h

	
;check-collision subroutine
check_npc_collisions:
    push ax
    push bx
    
    ;npc1
    mov al, [npc1_active]
    cmp al, 1
    jne check_npc2C
    
    call check_collision_npc1
    cmp al, 1
    je collision_detected
    
check_npc2C:
    mov al, [npc2_active]
    cmp al, 1
    jne check_npc3C
    
    call check_collision_npc2
    cmp al, 1
    je collision_detected
    
check_npc3C:
    mov al, [npc3_active]
    cmp al, 1
    jne doneCol
    
    call check_collision_npc3
    cmp al, 1
    je collision_detected
    
    jmp doneCol
    
collision_detected:
    call show_collision_sparks
    call game_over_collision
    
doneCol:
    pop bx
    pop ax
    ret

check_collision_npc1:
    push bx
    push cx
    push dx
    
	;player bounds
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
    mov cl, [player_col]
    mov ch, cl
    add ch, 9
    
    ;npc1 bounds
    mov dl, [npc1_row]
    mov dh, dl
    add dh, 3
    
    ;player bottom < npc top?
    cmp bh, dl                     
    jb no_collision
    
	;player top > npc bottom?
    cmp bl, dh                     
    ja no_collision
    
    ;rows, check npc left and right
    mov dl, [npc1_col]
    mov dh, dl
    add dh, 7
    
    ;column, overlap player left and right
	;player right < NPC left?
    cmp ch, dl
    jb no_collision
    
	;player left > NPC right?
    cmp cl, dh
    ja no_collision
    
    ;else collision
    mov al, 1
    jmp doneNC
    
no_collision:
    mov al, 0
    
doneNC:
    pop dx
    pop cx
    pop bx
    ret

;npc2
check_collision_npc2:
    push bx
    push cx
    push dx
    
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
    mov cl, [player_col]
    mov ch, cl
    add ch, 9
    
    mov dl, [npc2_row]
    mov dh, dl
    add dh, 3
    
    cmp bh, dl
    jb no_collision1
    cmp bl, dh
    ja no_collision1
    
    mov dl, [npc2_col]
    mov dh, dl
    add dh, 7
    
    cmp ch, dl
    jb no_collision1
    cmp cl, dh
    ja no_collision1
    
    mov al, 1
    jmp doneNC1
    
no_collision1:
    mov al, 0
    
doneNC1:
    pop dx
    pop cx
    pop bx
    ret

;npc3
check_collision_npc3:
    push bx
    push cx
    push dx
    
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
    mov cl, [player_col]
    mov ch, cl
    add ch, 9
    
    mov dl, [npc3_row]
    mov dh, dl
    add dh, 3
    
    cmp bh, dl
    jb no_collision2
    cmp bl, dh
    ja no_collision2
    
    mov dl, [npc3_col]
    mov dh, dl
    add dh, 7
    
    cmp ch, dl
    jb no_collision2
    cmp cl, dh
    ja no_collision2
    
    mov al, 1
    jmp doneNC2
    
no_collision2:
    mov al, 0
    
doneNC2:
    pop dx
    pop cx
    pop bx
    ret
	
show_collision_sparks:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    ;get collision points 
    mov al, [player_row]
    add al, 3
    mov [spark_center_row], al
    
    mov al, [player_col]
    add al, 5
    mov [spark_center_col], al
    
    mov cx, num_sparks
    
draw_spark_loop:
    push cx
    
    ;random offset for row drawing
    call get_random
    mov bl, 7
    xor ah, ah
    div bl
    sub ah, 3
    mov al, [spark_center_row]
    add al, ah
    mov dh, al ;row
    
    ;random offset for col drawing
    call get_random
    mov bl, 11
    xor ah, ah
    div bl
    sub ah, 5
    mov al, [spark_center_col]
    add al, ah
    mov dl, al ;col
    
    ;dont draw here, bounds
    cmp dh, 4
    jb skip_this_spark
    cmp dh, 24
    ja skip_this_spark
    cmp dl, 20
    jb skip_this_spark
    cmp dl, 60
    ja skip_this_spark
    
    ;position
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
	;get and write
    mov al, [spark_char]
    mov ah, [spark_color]
    
    mov [es:di], ax
    
skip_this_spark:
    pop cx
    dec cx
    cmp cx, 0
    jne draw_spark_loop
	
    call spark_delay
    
    pop es
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;spark-delay subroutine
spark_delay:
    push cx
    push bx
    
    mov bx, 20
spark_outer:
    mov cx, 0FFFFh
spark_inner:
    nop
    loop spark_inner
    dec bx
    jnz spark_outer
    
    pop bx
    pop cx
    ret
	
;coin-picking subroutines
check_coin1_pickup:
    push ax
    push bx
    
    mov al, [coin1_active]
    cmp al, 0
    je done_coin1
    
	;player and coin current position(row-check)
    mov al, [coin1_row]
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
	;coin row < player top?
    cmp al, bl                     
    jb done_coin1
	;or coin row > player bottom?
    cmp al, bh                     
    ja done_coin1
    
    ;player and coin current position(col-check, same logic as row)
    mov al, [coin1_col]
    mov bl, [player_col]
    mov bh, bl
    add bh, 9
    
    cmp al, bl
    jb done_coin1
    cmp al, bh
    ja done_coin1
    
    ;else collision
    mov byte [coin1_active], 0
    
    mov dh, [coin1_row]
    mov dl, [coin1_col]
    call erase_single_char
    
    mov ax, [player_score]
    add ax, [coin_value]
    
    cmp ax, 9999
    jbe not_max1
    mov ax, 9999
    
not_max1:
    mov [player_score], ax
    call print_score
    
    call get_random
    mov bl, 20
    xor ah, ah
    div bl
    mov al, ah
    mov ah, 0
    add ax, [coin_respawn_delay]
    mov [coin1_respawn_timer], ax
    
done_coin1:
    pop bx
    pop ax
    ret

;same as 1
check_coin2_pickup:
    push ax
    push bx
    
    mov al, [coin2_active]
    cmp al, 0
    je done_coin2
    
    mov al, [coin2_row]
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
    cmp al, bl
    jb done_coin2
    cmp al, bh
    ja done_coin2
    
    mov al, [coin2_col]
    mov bl, [player_col]
    mov bh, bl
    add bh, 9
    
    cmp al, bl
    jb done_coin2
    cmp al, bh
    ja done_coin2
    
    mov byte [coin2_active], 0
    
    mov dh, [coin2_row]
    mov dl, [coin2_col]
    call erase_single_char
    
    mov ax, [player_score]
    add ax, [coin_value]
    
    cmp ax, 9999
    jbe not_max2
    mov ax, 9999
    
not_max2:
    mov [player_score], ax
    call print_score
    
    call get_random
    mov bl, 20
    xor ah, ah
    div bl
    mov al, ah
    mov ah, 0
    add ax, [coin_respawn_delay]
    mov [coin2_respawn_timer], ax
    
done_coin2:
    pop bx
    pop ax
    ret

;fuel-pickup subroutine
check_fuel_pickup:
    push ax
    push bx
    
    mov al, [fuel_active]
    cmp al, 0
    je doneF
    
    mov al, [fuel_row]
    mov bl, [player_row]
    mov bh, bl
    add bh, 6
    
    cmp al, bl
    jb doneF
    cmp al, bh
    ja doneF
    
    mov al, [fuel_col]
    mov bl, [player_col]
    mov bh, bl
    add bh, 9
    
    cmp al, bl
    jb doneF
    cmp al, bh
    ja doneF
    
    mov byte [fuel_active], 0
    
    mov dh, [fuel_row]
    mov dl, [fuel_col]
    call erase_single_char
    
    mov ax, [player_fuel]
    add ax, [fuel_refill_amount]
    
    cmp ax, [fuel_max]
    jbe not_over_max
    mov ax, [fuel_max]
    
not_over_max:
    mov [player_fuel], ax
    call update_fuel
    
    mov ax, [fuel_respawn_delay]
    mov [fuel_respawn_timer], ax
    
doneF:
    pop bx
    pop ax
    ret
	
;gameover subroutines
game_over_fuel:
    mov byte [end_reason], 1
    call show_end_screen
    ret

game_over_collision:
    mov byte [end_reason], 2
    call show_end_screen
    ret
	
;randomRTC subroutine
get_random:
    push dx
    
    mov al, 00h          ;get seconds
    out 70h, al          ;port 70h
    jmp delayr           
    
delayr:
    in al, 71h           ;read from port 71h
	
    ;randomize
    xor al, byte [random_seed]
    add byte [random_seed], al
    inc byte [random_seed]
    
    pop dx
    ret

;helperRTC subroutine
init_random:
    push ax
	
    mov al, 00h
    out 70h, al
    jmp d1
d1:
    in al, 71h
    mov [random_seed], al
    
    mov al, 02h
    out 70h, al
    jmp d2
d2:
    in al, 71h
    add [random_seed], al
    
    pop ax
    ret

;get-random-lane subroutine
get_random_lane:
    push bx
    push si
    
    call get_random
    
    ;make it 0, 1, or 2 to point at the columns in lane_positions
    mov bl, [num_lanes]   
    xor ah, ah            
    div bl               
    
    mov si, lane_positions  ;point
    xor bh, bh
    mov bl, ah
    add si, bx 
    mov al, [si]
    
    pop si
    pop bx
    ret

;random-inital-spawn subroutine
spawn_initial_npcs:
    push ax
    push bx
    push cx
    
    ;pick 2 random different lanes
    call get_random_lane
    mov bl, al              ;bl first lane column
    
    ;second lane must be different
get_second_lane:
    call get_random_lane
    cmp al, bl
    je get_second_lane
    
    mov cl, al              ;cl second lane column
    
 ;spawn code
    ;which npc to activate based on column
    ;check first lane
    cmp bl, 22
    je first_is_npc1
    cmp bl, 35
    je first_is_npc2
    jmp first_is_npc3
    
first_is_npc1:
;random row with col 22 same for others
    mov byte [npc1_active], 1
    mov byte [npc1_col], 22
    call get_random
    mov bh, 10
    xor ah, ah
    div bh
    mov [npc1_row], ah
	
;draw
    push bx
    push cx
    xor ax, ax
    push ax
    mov al, [npc1_row]
    mov ah, 0
    push ax
    mov al, [npc1_col]
    mov ah, 0
    push ax
    call draw_car
    pop cx
    pop bx
    jmp check_second
    
first_is_npc2:
    mov byte [npc2_active], 1
    mov byte [npc2_col], 35
    call get_random
    mov bh, 10
    xor ah, ah
    div bh
    mov [npc2_row], ah
    
    push bx
    push cx
    xor ax, ax
    push ax
    mov al, [npc2_row]
    mov ah, 0
    push ax
    mov al, [npc2_col]
    mov ah, 0
    push ax
    call draw_car
    pop cx
    pop bx
    jmp check_second
    
first_is_npc3:
    mov byte [npc3_active], 1
    mov byte [npc3_col], 48
    call get_random
    mov bh, 10
    xor ah, ah
    div bh
    mov [npc3_row], ah
    
    push bx
    push cx
    xor ax, ax
    push ax
    mov al, [npc3_row]
    mov ah, 0
    push ax
    mov al, [npc3_col]
    mov ah, 0
    push ax
    call draw_car
    pop cx
    pop bx
    
check_second:
;second spawn at cl
    cmp cl, 22
    je second_is_npc1
    cmp cl, 35
    je second_is_npc2
    jmp second_is_npc3
    
second_is_npc1:
    mov byte [npc1_active], 1
    mov byte [npc1_col], 22
    call get_random
    mov bl, 10
    xor ah, ah
    div bl
    mov [npc1_row], ah
    
    xor ax, ax
    push ax
    mov al, [npc1_row]
    mov ah, 0
    push ax
    mov al, [npc1_col]
    mov ah, 0
    push ax
    call draw_car
    jmp doneS
    
second_is_npc2:
    mov byte [npc2_active], 1
    mov byte [npc2_col], 35
    call get_random
    mov bl, 10
    xor ah, ah
    div bl
    mov [npc2_row], ah
    
    xor ax, ax
    push ax
    mov al, [npc2_row]
    mov ah, 0
    push ax
    mov al, [npc2_col]
    mov ah, 0
    push ax
    call draw_car
    jmp doneS
    
second_is_npc3:
    mov byte [npc3_active], 1
    mov byte [npc3_col], 48
    call get_random
    mov bl, 10
    xor ah, ah
    div bl
    mov [npc3_row], ah
    
    xor ax, ax
    push ax
    mov al, [npc3_row]
    mov ah, 0
    push ax
    mov al, [npc3_col]
    mov ah, 0
    push ax
    call draw_car
    
doneS:
    pop cx
    pop bx
    pop ax
    ret

;hide-cursor subroutine
hideCursor:
    mov ah, 01h
    mov ch, 32
    mov cl, 0 
    int 10h
    ret
	
;clear-screen subroutine (draw grey road)
clear_screen:
	push bp
	mov bp, sp
	push ax
	push cx
	push di

	mov ax, 0b800h
	mov es, ax
	xor di, di
	mov ah, [bp+4]
	mov al, 0DBh
	mov cx, 2000
	rep stosw

	pop di
	pop cx
	pop ax
	pop bp
	ret 2
	
;delay subroutine
delay:
    push bx
    push cx
    
    mov bx, [game_speed]
    
outer_delay:
    mov cx, 0FFFFh
inner_delay:
    nop
    loop inner_delay
    
    dec bx
    jnz outer_delay
    
    pop cx
    pop bx
    ret

;dynamic-score-printing subroutine
print_score:
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov ax, 0B800h
    mov es, ax
    
    mov si, score_label
    mov di, 2 
    xor ax, ax

next_char:
    lodsb
    cmp al, 0
    je print_number
    mov ah, 2Eh
    mov [es:di], ax
    add di, 2
    jmp next_char

print_number:
    push di
    mov cx, 8 
    mov ax, 2A5Eh
clear_loop:
    mov [es:di], ax
    add di, 2
    loop clear_loop
    pop di
    
	;convert score to string
    mov ax, [player_score]
    
    ;if 0
    cmp ax, 0
    jne not_zero
    mov ax, 2E30h
    stosw
    jmp done
    
not_zero:
	;use stack to extract digits
    mov bx, 10
    xor cx, cx
    
extract_digits:
    cmp ax, 0
    je print_digits
    
    xor dx, dx
    div bx
    push dx
    inc cx
    jmp extract_digits
    
print_digits:
	;pop and print
    cmp cx, 0
    je done
    
    pop dx
    add dl, '0' ;convert ascii
    mov dh, 2Eh ;attribute
    mov ax, dx
    stosw
    dec cx
    jmp print_digits

done:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;print-game-name subroutine
print_game_name:
    push ax
	push di
	push si
	
    mov ax, 0B800h
    mov es, ax
	mov si, game_name
    mov di, 164
	xor ax, ax

next_char1:
    lodsb
    cmp al, 0
    je done1
    mov ah, 2bh
    mov [es:di], ax
    add di, 2
    jmp next_char1

done1:
    pop si
    pop di
    pop ax
    ret

;draw-car subroutine
draw_car:
	push bp
	mov bp, sp
    push ax
    push bx
    push dx
    push di
    push si
    
    mov ax, 0b800h
    mov es, ax
    
    mov dh, [bp+6]      ;starting row
    mov dl, [bp+4]      ;starting column
	
	xor bx, bx
	mov bx, [bp+8]       ;check npc/player
	cmp bx, 1
	je draw_player
    
draw_npc:
    mov si, car_rown1
    call draw_car_row
    
    inc dh
    mov si, car_rown2
    call draw_car_row
    
    inc dh
    mov si, car_rown3
    call draw_car_row
    
    inc dh
    mov si, car_rown4
    call draw_car_row
	jmp doneC

draw_player:
    mov si, car_rowp1
    call draw_car_row
    
    inc dh
    mov si, car_rowp2
    call draw_car_row
    
    inc dh
    mov si, car_rowp3
    call draw_car_row
    
    inc dh
    mov si, car_rowp4
    call draw_car_row
	
	inc dh
    mov si, car_rowp5
    call draw_car_row
	
	inc dh
    mov si, car_rowp6
    call draw_car_row
	
	inc dh
    mov si, car_rowp7
    call draw_car_row
	
doneC:
    pop si
    pop di
    pop dx
    pop bx
    pop ax
	pop bp
    ret 6


;draw-single-row-of-car subroutine
draw_car_row:
    push ax
    push bx
    push cx
    push dx
    push di
    push si

next_charC:
    lodsb
    cmp al, 0
    je done_car_row
    cmp al, ' '
    je skip_space

    push ax
	push bx
    xor ax, ax
    mov al, dh
    mov bh, 160
    mul bh
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
	pop bx
    pop ax

;color based on ascii
    cmp al, '_'       ; body
    je body_color
    cmp al, '#'       ; wheel
    je wheel_color
    cmp al, '@'       ; back light
    je back_light_color
	cmp al, '!'
	je back_light_color
    cmp al, 'm'       ; front light
    je front_light_color
	cmp al, '|'
	je nitrous_color
    jmp chassis_color

body_color:
    cmp bx, 1
    je body_player
    mov ah, [car_colors_npc]
    jmp apply_color
body_player:
    mov ah, [car_colors_player]
    jmp apply_color

wheel_color:
    cmp bx, 1
    je wheel_player
    mov ah, [car_colors_npc+1]
    jmp apply_color
wheel_player:
    mov ah, [car_colors_player+1]
    jmp apply_color

back_light_color:
    cmp bx, 1
    je bl_player
    mov ah, [car_colors_npc+2]
    jmp apply_color
bl_player:
    mov ah, [car_colors_player+2]
    jmp apply_color

front_light_color:
    cmp bx, 1
    je fl_player
    mov ah, [car_colors_npc+3]
    jmp apply_color
fl_player:
    mov ah, [car_colors_player+3]
    jmp apply_color

chassis_color:
    cmp bx, 1
    je chassis_color_player
    mov ah, [car_colors_npc+4]
    jmp apply_color
chassis_color_player:
    mov ah, [car_colors_player+4]
	jmp apply_color
	
nitrous_color:
    mov ah, [car_colors_player+5]

apply_color:
    stosw
    inc dl
    jmp next_charC

skip_space:
    inc dl
    jmp next_charC

done_car_row:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
;animation subroutine
move_all_npcs:
	push ax
	
    mov al, [npc1_active]
    cmp al, 1
    jne check_npc2
    call move_npc1
    
check_npc2:

    mov al, [npc2_active]
    cmp al, 1
    jne check_npc3
    call move_npc2
    
check_npc3:
    mov al, [npc3_active]
    cmp al, 1
    jne doneN
    call move_npc3
    
doneN:
	pop ax
    ret

;npc1-moving subroutine
move_npc1:
    push ax
    push dx
    
	;erase
    mov dh, [npc1_row]
    mov dl, [npc1_col]
    call erase_car
    
	;inc scroll down
    mov al, [npc1_row]
    inc al
    mov [npc1_row], al
    
	;reached end? 
    cmp al, 25
    jae finished
    
	;redraw at new position
    xor ax, ax
    push ax
    mov al, [npc1_row]
    mov ah, 0
    push ax
    mov al, [npc1_col]
    mov ah, 0
    push ax
    call draw_car
    jmp doneN1
    
finished:
    ;deactivate npc1
    mov byte [npc1_active], 0
    
    ;find last empty lane and spawn in that
    mov al, [npc2_active]
    cmp al, 0
    je spawn_lane2
    
    mov al, [npc3_active]
    cmp al, 0
    je spawn_lane3
    
    ;at max two cars so we end here but it shouldnt happen
    jmp doneN1
    
spawn_lane2:
;initalizing starting position and activation
    mov byte [npc2_row], 0
    mov byte [npc2_col], 35
    mov byte [npc2_active], 1
    
	;draw
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 35
    push ax
    call draw_car
    jmp doneN1
    
spawn_lane3:
;same as above
    mov byte [npc3_row], 0
    mov byte [npc3_col], 48
    mov byte [npc3_active], 1
    
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 48
    push ax
    call draw_car

doneN1:
    pop dx
    pop ax
    ret


;npc2-moving subroutine
move_npc2:
;same logic as move_npc1
    push ax
    push dx
    
    mov dh, [npc2_row]
    mov dl, [npc2_col]
    call erase_car
    
    mov al, [npc2_row]
    inc al
    mov [npc2_row], al
    
    cmp al, 25
    jae finished2
    
    xor ax, ax
    push ax
    mov al, [npc2_row]
    mov ah, 0
    push ax
    mov al, [npc2_col]
    mov ah, 0
    push ax
    call draw_car
    jmp doneN2
    
finished2:
    mov byte [npc2_active], 0
    
    mov al, [npc1_active]
    cmp al, 0
    je spawn_lane12
    
    mov al, [npc3_active]
    cmp al, 0
    je spawn_lane32
    
    jmp doneN2
    
spawn_lane12:
    mov byte [npc1_row], 0
    mov byte [npc1_col], 22
    mov byte [npc1_active], 1
    
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 22
    push ax
    call draw_car
    jmp doneN2
    
spawn_lane32:
    mov byte [npc3_row], 0
    mov byte [npc3_col], 48
    mov byte [npc3_active], 1
    
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 48
    push ax
    call draw_car

doneN2:
    pop dx
    pop ax
    ret

;npc3-moving subroutine
move_npc3:
;same as above
    push ax
    push dx
    
    mov dh, [npc3_row]
    mov dl, [npc3_col]
    call erase_car
    
    mov al, [npc3_row]
    inc al
    mov [npc3_row], al
    
    cmp al, 25
    jae finished3
    
    xor ax, ax
    push ax
    mov al, [npc3_row]
    mov ah, 0
    push ax
    mov al, [npc3_col]
    mov ah, 0
    push ax
    call draw_car
    jmp doneN3
    
finished3:
    mov byte [npc3_active], 0
    
    mov al, [npc1_active]
    cmp al, 0
    je spawn_lane13
    
    mov al, [npc2_active]
    cmp al, 0
    je spawn_lane23
    
    jmp doneN3
    
spawn_lane13:
    mov byte [npc1_row], 0
    mov byte [npc1_col], 22
    mov byte [npc1_active], 1
    
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 22
    push ax
    call draw_car
    jmp doneN3
    
spawn_lane23:
    mov byte [npc2_row], 0
    mov byte [npc2_col], 35
    mov byte [npc2_active], 1
    
    xor ax, ax
    push ax
    xor ax, ax
    push ax
    mov ax, 35
    push ax
    call draw_car

doneN3:
    pop dx
    pop ax
    ret
	
;car-erasing subroutine
erase_car:
;dh = row, dl = col
    push ax
    push bx
    push dx
    push di
    push es
    push si
    
    mov ax, 0b800h
    mov es, ax
    
    ;width
    mov cx, 4
    
erase_row:
    push cx
    push dx
    
    ;position
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
    ;draw-road
    mov cx, 8
    mov ax, 08DBh
    rep stosw
    
    pop dx
    inc dh
    pop cx
    loop erase_row
    
    pop si
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    ret
	
;draw-bushes subroutine
draw_bushes:
	push ax
	push bx
	push dx
	push di
	
	mov ax, 0b800h
    mov es, ax
    xor dx, dx
	mov dh, 0

drawA:
;position
	xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
	xor bx, bx
	mov bl, dl
	shl bl, 1
    add ax, bx
    mov di, ax

;draw
    mov ax, 2A5eh
    stosw 

;check
    inc dl
    cmp dl, 19 ; 20
    je resetA
	cmp dl, 80
	je resetA1
	jmp drawA

resetA:
	mov dl, 0
	inc dh
	cmp dh, 25
	je continueA
	
	xor ax, ax
	mov al, dh
	mov ah, 0
	xor bx, bx
	mov bl, 1
	div bl
	cmp ah, 0
	je skip_rowA
	jmp drawA
	
skip_rowA:
	inc dh
	cmp dh, 25
	je continueA
	jmp drawA
	
resetA1:
	mov dl, 61 ;60
	inc dh
	cmp dh, 25
	je exitA
	
	xor ax, ax
	mov al, dh
	mov ah, 0
	xor bx, bx
	mov bl, 1
	div bl
	cmp ah, 0
	je skip_rowA1
	cmp dh, 25
	je exitR
	jmp drawA
	
skip_rowA1:
	inc dh
	cmp dh, 25
	je exitA
	jmp drawA
	
continueA:
	mov dh, 0
	mov dl, 61 ;61
	jmp drawA

exitA:
	pop di
	pop dx
	pop bx
	pop ax
	ret 
	
;draw-grass subroutine
draw_grass:
	push ax
	push bx
	push dx
	push di
	
	mov ax, 0b800h
    mov es, ax
    xor dx, dx

draw:
	xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
	xor bx, bx
	mov bl, dl
	shl bl, 1
    add ax, bx
    mov di, ax

    mov ax, 62b2h
    stosw 

    inc dl
    cmp dl, 20
    je reset
	cmp dl, 80
	je reset1
	jmp draw

reset:
	mov dl, 0
	inc dh
	cmp dh, 25
	je continue
	jmp draw
	
reset1:
	mov dl, 60
	inc dh
	cmp dh, 25
	je exit
	jmp draw
	
continue:
	mov dh, 0
	mov dl, 60
	jmp draw

exit:
	pop di
	pop dx
	pop bx
	pop ax
	ret 

;draw-raod subroutine
draw_road:
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	push di
	
	mov ax, 0b800h
	mov es, ax
	xor di, di
	;initializing dx for drawing left side strip
	mov dh, 0
	mov dl, 19 ;20
	
;main drawing loop1(for long strips)
drawR:
	xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
	xor bx, bx
	mov bl, dl
	shl bl, 1
    add ax, bx
    mov di, ax
	
	xor ax, ax
	mov ah, [bp+4]
	mov al, '|'
    stosw 

    inc dl
    cmp dl, 21  ;for left strip 22
    je resetR
	cmp dl, 61  ;for right strip 60
	je resetR1
	jmp drawR
	
;main drawing loop2(for short strips)
drawR1:
	xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
	xor bx, bx
	mov bl, dl
	shl bl, 1
    add ax, bx
    mov di, ax
	
	xor ax, ax
	mov ah, [bp+4]
	mov al, 0b3h
    stosw 

    inc dl
	cmp dl, 34  ;for left small-strips
	je resetR2  
	cmp dl, 47  ;for right small-strips
	je resetR3
	jmp drawR1

;reset for left side strip
resetR:
	mov dl, 19   ;20
	inc dh
	cmp dh, 25
	je continueR
	jmp drawR

;reset for right side strip	
resetR1:
	mov dl, 59 ;58
	inc dh
	cmp dh, 25
	je continueR1 ;move to drawing samll-strips
	jmp drawR

;reset for left side samll-strips
resetR2:
	mov dl, 33
	inc dh
	cmp dh, 25
	je continueR2
	
	xor ax, ax
	mov al, dh
	mov ah, 0
	xor bx, bx
	mov bl, 4
	div bl
	cmp ah, 0
	je skip_row1
	jmp drawR1
	
skip_row1:
	inc dh
	cmp dh, 25
	je continueR2
	jmp drawR1
	
;reset for right side samll-strips
resetR3:
	mov dl, 46
    inc dh
    cmp dh, 25
    je exitR
	
	xor ax, ax
	mov al, dh
	mov ah, 0
	xor bx, bx
	mov bl, 4
	div bl
	cmp ah, 0
	je skip_row2
	cmp dh, 25
	je exitR
	jmp drawR1
	
skip_row2:
	inc dh
	cmp dh, 25
	je exitR
	jmp drawR1

;initializing dx for drawing right side strip	
continueR:
	; xor dx, dx
	mov dh, 0
	mov dl, 59 ; 58
	jmp drawR

;initializing dx for drawing left side small-strips
continueR1:
	; xor dx, dx
	mov dh, 1
	mov dl, 33
	jmp drawR1
	
;initializing dx for drawing right side small-strips
continueR2:
	; xor dx, dx
	mov dh, 1
	mov dl, 46
	jmp drawR1
	
exitR:
	pop di
	pop dx
	pop bx
	pop ax
	pop bp
	ret 2
	
;draw-char subroutine
draw_single_char:
    push ax
    push bx
    push dx
    push di
    push es
    
    mov bx, 0b800h
    mov es, bx
    
    push ax
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    pop ax
    
    stosw
    
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    ret

;erase-char subroutine
erase_single_char:
    push ax
    push bx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    push ax
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bx, bx
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    pop ax
    
    mov ax, 08DBh
    stosw
    
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    ret
	
;coin-moving-drive subroutine
;same logic as move_npcs subroutine
move_all_coins:
    push ax
    
	;check which one to move/spawn
    mov al, [coin1_active]
    cmp al, 1
    jne check_coin2
    call move_coin1
    
check_coin2:
    mov al, [coin2_active]
    cmp al, 1
    jne check_timers
    call move_coin2
    
check_timers:
    ;wait for timer to run down
    call check_coin_respawns
    
doneCO:
    pop ax
    ret

;coin-1-moving subroutine
move_coin1:
    push ax
    push dx
    
	;is it time to move? moves only at every nth iteration of game-loop
    mov ax, [coin1_speed_counter]
    inc ax
    mov [coin1_speed_counter], ax
    cmp ax, [coin1_speed] ;coin_speed = the iteration number and speed
    jb doneCO1 ;exit if timer hasnt run down
    
    ;reset the counter
    mov word [coin1_speed_counter], 0
    
    ;erase-old
    mov dh, [coin1_row]
    mov dl, [coin1_col]
    call erase_single_char
    
    ;inc move down
    mov al, [coin1_row]
    inc al
    mov [coin1_row], al
    
    ;reached end?
    cmp al, 25
    jae finishedC
    
    ;redraw at new
    mov dh, [coin1_row]
    mov dl, [coin1_col]
    mov al, '$'
    mov ah, 0Eh
    call draw_single_char
    jmp doneCO1
    
finishedC:
    ;deactivate
    mov byte [coin1_active], 0
    
    ;give random delay value to coin1 next spawn timer (40-59)
    call get_random
    mov bl, 20
    xor ah, ah
    div bl
    mov al, ah
    mov ah, 0
    add ax, [coin_respawn_delay]
    mov [coin1_respawn_timer], ax
    
doneCO1:
    pop dx
    pop ax
    ret

;coin-2-moving subroutine
move_coin2:
;same logic as above
    push ax
    push dx
    
    mov ax, [coin2_speed_counter]
    inc ax
    mov [coin2_speed_counter], ax
    cmp ax, [coin2_speed]
    jb doneCO2
    
    mov word [coin2_speed_counter], 0
    
    mov dh, [coin2_row]
    mov dl, [coin2_col]
    call erase_single_char
    
    mov al, [coin2_row]
    inc al
    mov [coin2_row], al
    
    cmp al, 25
    jae finishedC2
    
    mov dh, [coin2_row]
    mov dl, [coin2_col]
    mov al, '$'
    mov ah, 0Eh
    call draw_single_char
    jmp doneCO2
    
finishedC2:
    mov byte [coin2_active], 0
    
    call get_random
    mov bl, 20
    xor ah, ah
    div bl
    mov al, ah
    mov ah, 0
    add ax, [coin_respawn_delay]
    mov [coin2_respawn_timer], ax
    
doneCO2:
    pop dx
    pop ax
    ret

;coin-checking-and-spawning subroutine
check_coin_respawns:
    push ax
    push bx
    
    ;check is it time to spawn coin1?
    mov ax, [coin1_respawn_timer]
    cmp ax, 0
    je check_coin2_timer
    
    dec ax
    mov [coin1_respawn_timer], ax
    cmp ax, 0
    jne check_coin2_timer
    
    ;if coin1 already active, dont spawn
    mov al, [coin1_active]
    cmp al, 1
    je check_coin2_timer
    
    ; else, check if coin2 was active if not then spawn randomly in any lane from coin_positions
    mov al, [coin2_active]
    cmp al, 0
    je spawn1_random
    
    ;else coin2 is active, spawn in lane other than coin2
    mov al, [coin2_col]
    cmp al, 25
    je spawn1_40_or_50
    cmp al, 40
    je spawn1_25_or_50
    
	;if at 50(choose randomly)
    call get_random
    and al, 01h
    cmp al, 0
    je spawn1_at_25
    jmp spawn1_at_40
    
spawn1_40_or_50:
    call get_random
    and al, 01h
    cmp al, 0
    je spawn1_at_40
    jmp spawn1_at_50
    
spawn1_25_or_50:
    call get_random
    and al, 01h
    cmp al, 0
    je spawn1_at_25
    jmp spawn1_at_50
    
spawn1_random:
    call get_random_coin_position
    mov [coin1_col], al
    jmp do_spawn1
    
spawn1_at_25:
    mov byte [coin1_col], 25
    jmp do_spawn1
    
spawn1_at_40:
    mov byte [coin1_col], 40
    jmp do_spawn1
    
spawn1_at_50:
    mov byte [coin1_col], 50
    
do_spawn1:
    mov byte [coin1_row], 0
    mov byte [coin1_active], 1
    mov word [coin1_speed_counter], 0
    
    ;random speed
    call get_random
    mov bl, 5
    xor ah, ah
    div bl
    add ah, 4       ;can be adjusted here
    mov al, ah
    mov ah, 0
    mov [coin1_speed], ax
	
    mov dh, 0
    mov dl, [coin1_col]
    mov al, '$'
    mov ah, 0Eh
    call draw_single_char
    
check_coin2_timer:
;same logic as coin1
    mov ax, [coin2_respawn_timer]
    cmp ax, 0
    je doneCS
    
    dec ax
    mov [coin2_respawn_timer], ax
    cmp ax, 0
    jne doneCS
	
    mov al, [coin2_active]
    cmp al, 1
    je doneCS
    
    mov al, [coin1_active]
    cmp al, 0
    je spawn2_random

    mov al, [coin1_col]
    cmp al, 25
    je spawn2_40_or_50
    cmp al, 40
    je spawn2_25_or_50
    
    call get_random
    and al, 01h
    cmp al, 0
    je spawn2_at_25
    jmp spawn2_at_40
    
spawn2_40_or_50:
    call get_random
    and al, 01h
    cmp al, 0
    je spawn2_at_40
    jmp spawn2_at_50
    
spawn2_25_or_50:
    call get_random
    and al, 01h
    cmp al, 0
    je spawn2_at_25
    jmp spawn2_at_50
    
spawn2_random:
    call get_random_coin_position
    mov [coin2_col], al
    jmp do_spawn2
    
spawn2_at_25:
    mov byte [coin2_col], 25
    jmp do_spawn2
    
spawn2_at_40:
    mov byte [coin2_col], 40
    jmp do_spawn2
    
spawn2_at_50:
    mov byte [coin2_col], 50
    
do_spawn2:
    mov byte [coin2_row], 0
    mov byte [coin2_active], 1
    mov word [coin2_speed_counter], 0
    
    call get_random
    mov bl, 5
    xor ah, ah
    div bl
    add ah, 5  ;diff speed than coin1
    mov al, ah
    mov ah, 0
    mov [coin2_speed], ax
    
    mov dh, 0
    mov dl, [coin2_col]
    mov al, '$'
    mov ah, 0Eh
    call draw_single_char
    
doneCS:
    pop bx
    pop ax
    ret

;helper-check-and-sapwn-coin subroutine
;returns al which points to any random index in coin_positions
get_random_coin_position:
    push bx
    push si
    
    call get_random
    mov bl, [num_lanes] ;3
    xor ah, ah
    div bl
    
    mov si, coin_positions
    xor bh, bh
    mov bl, ah
    add si, bx
    mov al, [si]
    
    pop si
    pop bx
    ret

;set-coin-timer subroutine
init_coin_timers:
    push ax
    
    mov ax, [coin_respawn_delay]
    mov [coin1_respawn_timer], ax
    
    ;diff for coin 2
    add ax, 20
    mov [coin2_respawn_timer], ax
    
    pop ax
    ret

;move-fuel subroutine
move_fuel:
;same logic as of coins
    push ax
    push dx
	
    mov al, [fuel_active]
    cmp al, 1
    jne check_timer
    
    mov ax, [fuel_speed_counter]
    inc ax
    mov [fuel_speed_counter], ax
    cmp ax, [fuel_base_speed]
    jb check_timer
    
    mov word [fuel_speed_counter], 0
    
    mov dh, [fuel_row]
    mov dl, [fuel_col]
    call erase_single_char

    mov al, [fuel_row]
    inc al
    mov [fuel_row], al

    cmp al, 25
    jae finishedF
    
    mov dh, [fuel_row]
    mov dl, [fuel_col]
    mov al, '+'
    mov ah, 0Ch
    call draw_single_char
    jmp check_timer
    
finishedF:
    mov byte [fuel_active], 0
    mov ax, [fuel_respawn_delay]
    mov [fuel_respawn_timer], ax
    
check_timer:
    call check_fuel_respawn
    
doneFl:
    pop dx
    pop ax
    ret

;check-and-spawn-fuel subroutine
check_fuel_respawn:
;same but minimized logic of coins
    push ax
    
    mov ax, [fuel_respawn_timer]
    cmp ax, 0
    je doneFR
    
    dec ax
    mov [fuel_respawn_timer], ax
    cmp ax, 0
    jne doneFR

    mov al, [fuel_active]
    cmp al, 1
    je doneFR 
    
    call get_random_coin_position
    mov [fuel_col], al
    
    mov byte [fuel_row], 0
    mov byte [fuel_active], 1
    mov word [fuel_speed_counter], 0
    
    mov dh, 0
    mov dl, [fuel_col]
    mov al, '+'
    mov ah, 0Ch
    call draw_single_char
    
doneFR:
    pop ax
    ret

;set-fuel-timer subroutine
init_fuel_timer:
    push ax
    
    mov ax, [fuel_respawn_delay]
    mov [fuel_respawn_timer], ax
    
    pop ax
    ret

;fuel-bar subroutine
draw_fuel_bar:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov ax, 0B800h
    mov es, ax
    
    ;row3, col0
    mov di, 160 * 3
    
    ;yello-F:
    mov ax, 6E46h
    stosw
    mov ax, 6E3Ah
    stosw
    
	;yellow-[
    mov ax, 6E5Bh
    stosw
    
	;we have total 19-cols (4 used for F:[]) remaing 19-4 = 15 blocks for bar
	;based on player fuel draw only those blocks
	;dived by six bcz 100/15 ~ 6
    mov ax, [player_fuel]
    mov bl, 6
    xor dx, dx
    div bx                  
    
	;check the quotient if below cap then safe to draw, else hard cap
    mov cl, al
    cmp cl, 15
    jbe blocks_ok
    mov cl, 15
    
blocks_ok:
    mov ch, 0
    cmp cl, 0
    je draw_empty
    
    push cx
    
draw_filled:
    push cx
    
    ;change color based on level
    mov ax, [player_fuel]
    cmp ax, 30
    jb red_bar             ;below 30 = red
    cmp ax, 60
    jb yellow_bar          ;below 60 = yellow
    
    ;green bar (above 60)
    mov ax, 0ADBh           
    jmp draw_block
    
yellow_bar:
    mov ax, 0EDBh
    jmp draw_block
    
red_bar:
    mov ax, 0CDBh
    
draw_block:
    stosw
    pop cx
    loop draw_filled
    
    pop cx
    
draw_empty:
    mov al, 15
    sub al, cl
    mov cl, al
    cmp cl, 0
    je draw_bracket
    
draw_empty_loop:
    mov ax, 62b2h
    stosw
    loop draw_empty_loop
    
draw_bracket:
    mov ax, 6E5Dh
    stosw
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;update-fuel subroutine
update_fuel:
;identical logic to coins
    push ax
    
    ;inc counter
    mov ax, [fuel_decay_counter]
    inc ax
    mov [fuel_decay_counter], ax
    
    ;compare with decay rate
    cmp ax, [fuel_decay_rate]
    jb doneD
    
    ;reset 
    mov word [fuel_decay_counter], 0
    
    ;dec fuel
    mov ax, [player_fuel]
    cmp ax, 0
    je game_over           ;empty
    
    dec ax
    mov [player_fuel], ax
    
    ;redraw
    call draw_fuel_bar
    
    ;again empty check
    cmp ax, 0
    je game_over
    
    jmp doneD
    
game_over:
    call game_over_fuel
    
doneD:
    pop ax
    ret

;scroll-road-drive subroutine
scroll_road:
    push ax
    
    ;check timer/counter
    mov ax, [road_scroll_counter]
    inc ax
    mov [road_scroll_counter], ax
    
    ;scroll only when ax value equal any number(speed of scroll)
    cmp ax, 1
    jb doneSR
    
    ;when equals reset counter
    mov word [road_scroll_counter], 0
    
    ;add scrolling effect via offset by inc and wrap-around (0-3)
    mov al, [road_scroll_offset]
    inc al
    
    ;reset at 4
    cmp al, 4
    jb save_offset
    xor al, al
    
save_offset:
    mov [road_scroll_offset], al
    
    ;redraw lines with new gap positios
    call draw_dashed_lines
    
doneSR:
    pop ax
    ret

;strip-animation subroutine
draw_dashed_lines:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    ;get offset
    xor cx, cx
    mov cl, [road_scroll_offset]
    
    ;start at row1
    mov dh, 1
    
left_dash_loop:
    ;check if there should be gap
	;ah = (row + offset) % 4, is the gap position being calculated
	;pattern could be any- here is 3 dash, 1 gap
    mov al, dh
    sub al, cl 
    mov ah, 0
    push bx
    mov bl, 4
    div bl
    pop bx
    
    cmp ah, 3
    je erase_left_dash
    
draw_left_dash:
;draw at ax = (row*160)+(col*2)
    push dx
    xor ax, ax
    mov al, dh
    push bx
    mov bl, 160
    mul bl
    pop bx
    mov dl, 33
    push bx
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    pop bx
    mov di, ax
    pop dx
    
    mov ax, 0eb3h ;line
    stosw
    jmp next_left
    
erase_left_dash:
    push dx
    xor ax, ax
    mov al, dh
    push bx
    mov bl, 160
    mul bl
    pop bx
    mov dl, 33
    push bx
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    pop bx
    mov di, ax
    pop dx
    
    mov ax, 08DBh ;road
    stosw
    
next_left:
    inc dh
    cmp dh, 25
    jb left_dash_loop
    
    mov dh, 1
    
right_dash_loop:
;same logic as above
    mov al, dh
    sub al, cl
    mov ah, 0
    push bx
    mov bl, 4
    div bl
    pop bx
    
    cmp ah, 3               ;gap row
    je erase_right_dash
    
draw_right_dash:
    push dx
    xor ax, ax
    mov al, dh
    push bx
    mov bl, 160
    mul bl
    pop bx
    mov dl, 46
    push bx
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    pop bx
    mov di, ax
    pop dx
    
    mov ax, 0eb3h
    stosw
    jmp next_right
    
erase_right_dash:
    push dx
    xor ax, ax
    mov al, dh
    push bx
    mov bl, 160
    mul bl
    pop bx
    mov dl, 46
    push bx
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    pop bx
    mov di, ax
    pop dx
    
    mov ax, 08DBh
    stosw
    
next_right:
    inc dh
    cmp dh, 25
    jb right_dash_loop
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
;draw-tree subroutine
draw_tree:
    push ax
    push bx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    push dx
    
	;top row leaves
	;position
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
    mov ax, 0ADBh
    stosw
    
    pop dx
    
	;bot row -trunk
    inc dh
    
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
    mov ax, 267Ch
    stosw
    
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    ret

;erase-tree subroutine
erase_tree:
    push ax
    push bx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
	;erase top-row
    push dx
    
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
	
    mov ax, 62b2h ;match bg
    stosw
    
    pop dx
    
    ;erase bot-row
    inc dh
    
    xor ax, ax
    mov al, dh
    mov bl, 160
    mul bl
    
    xor bh, bh
    mov bl, dl
    shl bx, 1
    add ax, bx
    mov di, ax
    
    mov ax, 2A5Eh ;match bg
    stosw
    
    pop es
    pop di
    pop dx
    pop bx
    pop ax
    ret
	
;get-random-left-col subroutine
get_random_left_col:
    push bx
    
    call get_random
    mov bl, 19
    xor ah, ah
    div bl
    
	;return al
    mov al, ah
    
    pop bx
    ret

;random-right-col subroutine
get_random_right_col:
    push bx
    
    call get_random
    mov bl, 18
    xor ah, ah
    div bl
    
    mov al, ah
    add al, 61
    
    pop bx
    ret

;initialize-tree subroutine
init_trees:
    push ax
    push cx
    push si
    
    xor cx, cx
    xor si, si
    
init_left:
    cmp cx, MAX_TREES_PER_SIDE
    jae init_right_start
    
	;get random row
    call get_random
    mov bl, 12
    xor ah, ah
    div bl
    mov al, ah
    add al, 4
    mov [tree_left_rows + si], al
    
    ;get random col
    push cx
    push si
    call get_random_left_col
    pop si
    mov [tree_left_cols + si], al
    pop cx
    
    ;activate
    mov byte [tree_left_active + si], 1
    
    ;reset counter
    mov bx, si
    shl bx, 1
    mov word [tree_left_speed_counters + bx], 0
    
    ;draw
    mov dh, [tree_left_rows + si]
    mov dl, [tree_left_cols + si]
    call draw_tree
    
    inc si
    inc cx
    jmp init_left
    
;same logic for right
init_right_start:
    xor cx, cx
    xor si, si
    
init_right:
    cmp cx, MAX_TREES_PER_SIDE
    jae doneT
	
    call get_random
    mov bl, 12
    xor ah, ah
    div bl
    mov al, ah
    add al, 4
    mov [tree_right_rows + si], al
    
    push cx
    push si
    call get_random_right_col
    pop si
    mov [tree_right_cols + si], al
    pop cx
    
    mov byte [tree_right_active + si], 1
	
    mov bx, si
    shl bx, 1
    mov word [tree_right_speed_counters + bx], 0
    
    mov dh, [tree_right_rows + si]
	inc dh
	inc dh
    mov dl, [tree_right_cols + si]
    call draw_tree
    
    inc si
    inc cx
    jmp init_right
    
doneT:
    pop si
    pop cx
    pop ax
    ret	

;move-all-tree-drive subroutine
move_all_trees:
    push ax
    push bx
    push cx
    push si
    
    xor cx, cx
    mov si, 0 ;index
    
move_left_loop:
    cmp cx, MAX_TREES_PER_SIDE
    jae move_right_trees
    
    mov al, [tree_left_active + si]
    cmp al, 1
    jne next_leftM
    
    ;speed
    mov bx, si
    shl bx, 1
    mov ax, [tree_left_speed_counters + bx]
    inc ax
    mov [tree_left_speed_counters + bx], ax
    
    cmp ax, [tree_base_speed]
    jb next_leftM
    
    ;reset counter
    mov word [tree_left_speed_counters + bx], 0
    
    ;erase
    mov dh, [tree_left_rows + si]
    mov dl, [tree_left_cols + si]
    call erase_tree
    
    ;move down skip 2 rows draw
    mov al, [tree_left_rows + si]
	inc al
	inc al
    mov [tree_left_rows + si], al
    
    ;off screen?
    cmp al, 25
    jae deactivate_left
    
    ;redraw
    mov dh, [tree_left_rows + si]
    mov dl, [tree_left_cols + si]
    call draw_tree
    jmp next_leftM
    
deactivate_left:
    ;respawn at
    mov byte [tree_left_rows + si], 5  ;below hud
    
    ;random col
    push cx
    push si
    call get_random_left_col
    pop si
    mov [tree_left_cols + si], al
    pop cx
    
    ;stay active
    mov byte [tree_left_active + si], 1
    
    ;redraw at new
    mov dh, [tree_left_rows + si]
    mov dl, [tree_left_cols + si]
    call draw_tree
    
next_leftM:
    inc si
    inc cx
    jmp move_left_loop
    
;same logic for right trees
move_right_trees:
    xor cx, cx
    mov si, 0
    
move_right_loop:
    cmp cx, MAX_TREES_PER_SIDE
    jae doneTM
    
    mov al, [tree_right_active + si]
    cmp al, 1
    jne next_rightM
    
    mov bx, si
    shl bx, 1
    mov ax, [tree_right_speed_counters + bx]
    inc ax
    mov [tree_right_speed_counters + bx], ax
    
    cmp ax, [tree_base_speed]
    jb next_rightM
    
    mov word [tree_right_speed_counters + bx], 0
    
    mov dh, [tree_right_rows + si]
    mov dl, [tree_right_cols + si]
    call erase_tree
    
    mov al, [tree_right_rows + si]
    inc al
	inc al
    mov [tree_right_rows + si], al
    
    cmp al, 25
    jae deactivate_right

    mov dh, [tree_right_rows + si]
    mov dl, [tree_right_cols + si]
    call draw_tree
    jmp next_rightM
    
deactivate_right:
    mov byte [tree_right_rows + si], 1
    
    push cx
    push si
    call get_random_right_col
    pop si
    mov [tree_right_cols + si], al
    pop cx
    
    mov byte [tree_right_active + si], 1
    
    mov dh, [tree_right_rows + si]
    mov dl, [tree_right_cols + si]
    call draw_tree
    
next_rightM:
    inc si
    inc cx
    jmp move_right_loop
    
doneTM:
    pop si
    pop cx
    pop bx
    pop ax
    ret
	
draw_game:
	mov ax, 08h
	push ax
	call clear_screen
	call hideCursor
	call draw_grass
	mov ax, 0eh
	push ax
	call draw_road
	call draw_bushes
    call print_score
	call print_game_name
	call draw_fuel_bar
	mov ax, 1
    push ax
    xor ax, ax
    mov al, [player_row]
    push ax
    mov al, [player_col]
    push ax
    call draw_car
	ret
	
start:
	call hideCursor
    call init_random
	call install_keyboard  
    
    call show_animated_intro
	call show_intro_screen
restart:
    call show_name_input_screen
    call show_instruction_screen
	call show_difficulty_screen 
    call show_start_screen
    
game_loop:
    call check_keyboard
    
    mov al, [game_paused]
    cmp al, 1
    je skip_updates
    
    call move_all_npcs
    
    mov ax, 1
    push ax
    xor ax, ax
    mov al, [player_row]
    push ax
    mov al, [player_col]
    push ax
    call draw_car
    
    call move_all_coins
    call check_coin1_pickup
    call check_coin2_pickup
    
    call move_fuel
    call update_fuel
    call check_fuel_pickup
    
    call move_all_trees
    call scroll_road
    
    call check_npc_collisions
	
skip_updates:
	call delay
    jmp game_loop