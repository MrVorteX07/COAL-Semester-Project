org 100h

jmp start

score_label db 'Score: ',0      ; Just the label, no number
player_score dw 0               ; Actual score value (0-9999)
coin_value dw 10                ; Points per coin
game_name db 'NFSx86',0
; game_over_msg db 'GAME OVER!$'
game_speed dw 3
random_seed db 0

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

;---animation data----

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

;coin-data/ variables
coin_positions db 25, 40, 50

coin1_row db 0
coin1_col db 25
coin1_active db 0
coin1_speed_counter dw 0  ;loop
coin1_speed dw 5

coin2_row db 0
coin2_col db 40
coin2_active db 0
coin2_speed_counter dw 0
coin2_speed dw 2

coin1_respawn_timer dw 0
coin2_respawn_timer dw 0
coin_respawn_delay dw 40     ;delay btw respawns


;fuel-data/ variables
fuel_row db 0
fuel_col db 48
fuel_active db 0
fuel_speed_counter dw 0

fuel_base_speed dw 0
fuel_respawn_delay dw 5
fuel_respawn_timer dw 0

player_fuel dw 100
fuel_max dw 100
fuel_decay_counter dw 0
fuel_decay_rate dw 1
fuel_refill_amount dw 30
game_over_fuel_msg db 'GAME OVER - OUT OF FUEL!$'

;road animation variables
road_scroll_offset db 0 
road_scroll_counter dw 0

;tree-data/variables
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


;randomRTC subroutine
get_random:
    push dx
    
    mov al, 00h          ;get seconds
    out 70h, al          ;port 70h
    jmp delayr           
    
delayr:
    in al, 71h           ; read from port 71h
	
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
	
;countdown subroutine
countdown:
    push ax
    push bx
    push cx
    push dx
    push di
    push es
    
    mov ax, 0b800h
    mov es, ax
    
    ;red-3
    mov di, 160 * 12 + 2 * 39
    mov ax, 0433h
    stosw
    
    call countdown_delay
    
    ;orange-2
    mov di, 160 * 12 + 2 * 39
    mov ax, 0632h
    stosw
    
    call countdown_delay
    
    ;yellow-1
    mov di, 160 * 12 + 2 * 39
    mov ax, 0E31h
    stosw
    
    call countdown_delay
    
    ;green-go!
    mov di, 160 * 12 + 2 * 38
    mov ax, 0247h
    stosw
    mov ax, 024Fh
    stosw
    mov ax, 0221h
    stosw
    
    call countdown_delay
    
    ;clear the last text go!
    mov di, 160 * 12 + 2 * 38
    mov ax, 08DBh
    stosw
    stosw
    stosw
    
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;countdown-helper subroutine
countdown_delay:
    ;delay time
    push cx
    mov cx, 0Fh
    
outer:
    push cx
    mov cx, 0FFFFh
    
inner:
    nop
    loop inner
    
    pop cx
    loop outer
    
    pop cx
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
	
;coin1-pickup subroutine
check_coin1_pickup:
;identical logic as fuel pick-up
    push ax
    push bx
    
	;active check
    mov al, [coin1_active]
    cmp al, 0
    je done_coin1
    
	;respective to player statitc positions
    ;row check
    mov al, [coin1_row]
    cmp al, 15
    jb done_coin1
    cmp al, 22
    ja done_coin1
    
    ;column check
    mov al, [coin1_col]
    cmp al, 48
    jb done_coin1
    cmp al, 58
    ja done_coin1
    
    ;else collision
    mov byte [coin1_active], 0
    
    ;erase coin
    mov dh, [coin1_row]
    mov dl, [coin1_col]
    call erase_single_char
    
    ;add points
    mov ax, [player_score]
    add ax, [coin_value]
    
    ;cap at 9999
    cmp ax, 9999
    jbe not_max1
    mov ax, 9999
    
;update score
not_max1:
    mov [player_score], ax
    
    call print_score
    
    ;random respawn timer
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

;coin-2 pickup subroutine
check_coin2_pickup:
;same logic as coin1
    push ax
    push bx
    
    mov al, [coin2_active]
    cmp al, 0
    je done_coin2
    
    mov al, [coin2_row]
    cmp al, 15
    jb done_coin2
    cmp al, 22
    ja done_coin2
    
    mov al, [coin2_col]
    cmp al, 48
    jb done_coin2
    cmp al, 58
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

;fuel-refill subroutine
check_fuel_pickup:
    push ax
    push bx
    
    ;check if fuel active or not?
    mov al, [fuel_active]
    cmp al, 0
    je doneF
	
	;check collison with player
	;if fuel has reached below row 15
	;or above row 22?
    mov al, [fuel_row]
    cmp al, 15
    jb doneF
    cmp al, 22
    ja doneF
    
    ;same for column
    mov al, [fuel_col]
    cmp al, 48
    jb doneF
    cmp al, 58
    ja doneF
    
    ;else collison deactivate fuel
    mov byte [fuel_active], 0
    
    ;erase-fuel
    mov dh, [fuel_row]
    mov dl, [fuel_col]
    call erase_single_char
    
    ;inc player fuel
    mov ax, [player_fuel]
    add ax, [fuel_refill_amount]
    
    ;check max, cap it
    cmp ax, [fuel_max]
    jbe not_over_max
    mov ax, [fuel_max]
    
not_over_max:
    mov [player_fuel], ax
    
    ;redraw fuel-bar
    call draw_fuel_bar
    
    ;set next fuel spawn time
    mov ax, [fuel_respawn_delay]
    mov [fuel_respawn_timer], ax
    
doneF:
    pop bx
    pop ax
    ret

;game-over-on-fuel-empty subroutine
game_over_fuel:
;clear screen
    mov ax, 0003h
    int 10h
    
    ;print game over! using interupts
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 28
    int 10h
    
    mov ah, 09h
    mov dx, game_over_fuel_msg
    int 21h
    
    ;wait for keypress
    mov ah, 00h
    int 16h
    
    ;exit
    mov ah, 4Ch
    int 21h

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
	;pattern could be any here is 3 dash, 1 gap
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
	mov ax, 1           ;type player
	push ax
	mov ax, 15          ; row
    push ax
    mov ax, 48          ; col
    push ax
	call draw_car
    call print_score
	call print_game_name
	call draw_fuel_bar
	ret
	
start:
	call init_random 
	call draw_game
	call spawn_initial_npcs
	call init_coin_timers
	call init_fuel_timer
    call init_trees
	call countdown	
	
game_loop:
    call move_all_npcs
	mov ax, 1           ;type player
	push ax
	mov ax, 15          ; row
    push ax
    mov ax, 48          ; col
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
	call delay
    
    jmp game_loop
