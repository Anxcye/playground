GCC = gcc
SRC = main2.c ./lib/error.c ./lib/pathalloc.c
INC = -I.
OUT = myfind

all:
	@$(GCC) $(SRC) $(INC)  -o $(OUT)

run2:all
	@./$(OUT) ./hw

run4:all
	@./$(OUT) ./hw -comp ./a.a

run42:all
	@./$(OUT) ./hw -name a.a

clean:
	rm -f $(OUT)