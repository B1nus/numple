section .data
	number dq 0
	text0 db "READ: "
	len0 equ $ - text0
	text1 db "odd",10
	len1 equ $ - text1
	text2 db "even",10
	len2 equ $ - text2

section .bss
	read resb 16


section .text
	global _start

_start:
; -- READ --
	mov rax, 1
	mov rdi, 1
	mov rsi, text0
	mov rdx, len0
	syscall
	mov rax, 0
	mov rdi, 0
	mov rsi, read
	mov rdx, 16
	syscall
	call _conversion_loop
	push rbx
; -- JUMP.EQ.0 --
	cmp qword [rsp], 0
	je L1
; -- JUMP.GT.O --
; -- JUMP --
	jmp make_positive
; -- LABEL --
LOOP:
; -- PUSH --
	push 2
; -- SUB --
	pop rax
	pop rbx
	sub rbx, rax
	push rbx
; -- JUMP.EQ.0 --
	cmp qword [rsp], 0
	je L1
; -- JUMP.GT.0 --
	cmp qword [rsp], 0
	jg LOOP
; -- PRINT --
	mov rax, 1
	mov rdi, 1
	mov rsi, text1
	mov rdx, len1
	syscall
; -- HALT --
	mov rax, 60
	mov rdi, 0
	syscall

; -- LABEL --
L1:
; -- PRINT --
	mov rax, 1
	mov rdi, 1
	mov rsi, text2
	mov rdx, len2
	syscall
; -- HALT --
	mov rax, 60
	mov rdi, 0
	syscall

; -- LABEL --
make_positive:
; -- PUSH --
	push 2
; -- ADD --
	pop rax
	pop rbx
	add rbx, rax
	push rbx
; -- JUMP.GT.0 --
	cmp qword [rsp], 0
	jg LOOP
; -- JUMP --
	jmp make_positive
_conversion_loop:
	mov rbx, 0
	mov rdi, read

_conversion_loop_inner:
	movzx rcx, byte [rdi]
	cmp rcx, 10
	je _conversion_done
	sub rcx, '0'
	mov rax, rbx
	mov rdx, 10
	imul rdx
	mov rbx, rax
	add rbx, rcx
	inc rdi
	jmp _conversion_loop_inner

_conversion_done:
	ret