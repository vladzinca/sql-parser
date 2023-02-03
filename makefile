# Zinca Vlad-Alexandru, 333CC

CC = gcc

build: tema.l
	flex tema.l
	$(CC) -o tema lex.yy.c

run1: tema
	./tema test1.in
run2: tema
	./tema test2.in
run3: tema
	./tema test3.in
run4: tema
	./tema test4.in
.PHONY : clean
clean :
	rm -f lex.yy.c
	rm -f tema
