build:
	nasm -f elf64 -l main.lst main.asm
	ld -o main main.o
	./main
debug:
	nasm -g -f elf64 -l main.lst main.asm
	ld -o main main.o
	gdb main
