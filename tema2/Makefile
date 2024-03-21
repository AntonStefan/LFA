# make clean && make && make run1 > tests/out1.md
# make clean && make && make run1

CC = g++
CFLAGS = -g
 
all: tema

tema:
	flex -o tema.cpp latex_to_md.l 
	$(CC) -o tema tema.cpp $(CFLAGS)

run0:
	@./tema < ./tests/0.tex

run1:
	@./tema < ./tests/1.tex

run2:
	@./tema < ./tests/2.tex

run3:
	@./tema < ./tests/3.tex

run4:
	@./tema < ./tests/4.tex

.PHONY : clean
clean :
	rm -f tema.cpp 
	rm -rf tema
	rm -f lex.yy.cpp
	
