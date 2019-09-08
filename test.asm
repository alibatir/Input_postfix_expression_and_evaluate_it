code segment
start:
mov ah,01h
int 21h ; character is read
jmp check ; jumps to character control

num:
sub al,030h ; converts ASCII value to binary in the register
jmp mult16 ; jumps to digits-to-number converter
letter:
sub al,037h ; converts ASCII value to binary in the register
jmp mult16 ; jumps to digits-to-number converter
mult16:
mov ah,0 ; ah is set to 0 to use in next calculations.
mov bx,ax ; ax (previous number) is stored in bx register
pop ax ; upper digit is popped to ax
push 16d
pop cx
mul cx ; upper digit is multiplied with 16h
add ax,bx ; new number is generated and pushed
push ax
jmp start ; jumps back to reading input
blank:
push 0 ; pushes 0 in order to prevent conflict with numbers in mult16
jmp start ; turns back to reading input

ifnum:
cmp al,030h ; checks if input is bigger than or equal to '0' ASCII (hence checks ifnum)
jae num ; jumps to num if ASCII is between '0-9'
jmp notnum ; jumps to notnum hence continues character check

ifletter:
cmp al,041h ; checks if input is bigger than or equal to 'A' ASCII (hence checks ifletter)
jae letter ; jumps to letter if ASCII is between 'A-F'
jmp notletter ; jumps to notletter if ASCII is between 'A-F'

check:
cmp al,020h ; ' '
jz blank ; checks if input is Space character and jumps to blank
cmp al,039h ; 0-9
jbe ifnum ;checks if input ASCII is smaller than '9' ASCII and jumps to ifnum
notnum:
cmp al,046h ; A-F
jbe ifletter ; checks if input ASCII is smaller than 'F' ASCII and jumps to ifletter
notletter:
cmp al,0Dh ; enter
jle finishread ; checks if input is 'carriage return' and jumps to result calculation
pop cx ; pops the last item in the stack to bring the last number to top of the stack
cmp al,02Bh ; +
je addition ; checks if input is '+' and jumps to addition
cmp al,02Ah ; *
je multiplication ; checks if input is '*' and jumps to multiplication
cmp al,02Fh ; /
je integerdivision ; checks if input is '*' and jumps to multiplication
cmp al,05Eh ; ^
je bitxor ; checks if input is '*' and jumps to multiplication
cmp al,07Ch ; |
je bitor ; checks if input is '*' and jumps to multiplication
cmp al,026h ; &
je bitand ; checks if input is '*' and jumps to multiplication

addition:
pop cx
pop ax
add ax,cx
push ax ; pops last two items of the stack, adds and pushes the result to stack.
jmp start ; jumps to reading inputs
multiplication:
pop cx
pop ax
mul cx
push ax ; pops last two items of the stack, multiplies and pushes the result to stack.
jmp start ; jumps to reading inputs
integerdivision:
mov dx,0
pop cx
pop ax
div cx ; pops last two items of the stack, divides and pushes the result to stack.
push ax ; jumps to reading inputs
jmp start
bitxor:
pop cx
pop ax
xor ax,cx
push ax ; pops last two items of the stack, applies bitwise xor and pushes the result to stack.
jmp start ; jumps to reading inputs
bitand:
pop cx
pop ax
and ax,cx
push ax ; pops last two items of the stack, applies bitwise and and pushes the result to stack.
jmp start ; jumps to reading inputs
bitor:
pop cx
pop ax
or ax,cx
push ax ; pops last two items of the stack, applies bitwise or and pushes the result to stack.
jmp start ; jumps to reading inputs

finishread:
pop ax ; pops last result (binary)
mov cx,010h ; moves decimal 16 to cx in order to divide in backtoHex
push 011h ; puts a control value to stack
backtoHex:
mov dx,0
div cx ; divides ax by cx (16) to get digit value to dx
push dx ; pushes the quotient to stack
cmp ax,0
jne backtoHex ; checks if ax is 0 and continues dividing unless it is.

printHex:
pop ax ; pops higher order digit from stack
cmp ax,011h ; compares if the last item of the stack is the control value defined in 'finishread'.
je finish ; jumps to end if control value is reached which means the result is printed successfully.
cmp ax, 09h
jle print
add al,07h ; adds extra 07h to compensate for the ASCII difference between '9' and 'A'
print:
add al,030h ; adds 30h to convert to ASCII
mov dl,al ; moves the digit to dl in order to write it on the screen
mov ah,02h
int 21h ; prints the digit
jmp printHex ; jumps for the next digit
finish:
int 20h ; finishes the program
code ends          