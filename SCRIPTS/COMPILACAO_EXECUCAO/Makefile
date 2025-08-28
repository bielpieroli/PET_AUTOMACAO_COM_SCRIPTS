all:
	gcc programa.c -o programa -Wall -Werror -std=c99
run: all
	./programa
valgrind:
	valgrind ./programa
clean:
	rm -f programa