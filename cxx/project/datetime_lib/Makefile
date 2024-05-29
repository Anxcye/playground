CC=gcc
CFLAGS=-Iinclude

BUILD_DIR=build
LIB_DIR=/usr/local/lib
INCLUDE_DIR=/usr/local/include

# 链接库名
NAME=datetime
LIB_NAME=lib$(NAME)

# 目标文件
SRC_FILES=$(wildcard src/*.c)
OBJ_FILES=$(patsubst src/%.c,$(BUILD_DIR)/%.o,$(SRC_FILES))

all: static dynamic

# 编译静态链接库
static: $(OBJ_FILES)
	ar rcs $(BUILD_DIR)/$(LIB_NAME).a $^

# 编译动态链接库
dynamic: $(OBJ_FILES)
	$(CC) -shared -o $(BUILD_DIR)/$(LIB_NAME).so $^

# 编译测试程序
test: test/test_datetime.c
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/test_datetime $^ -L$(BUILD_DIR) -l$(NAME)
	LD_LIBRARY_PATH=$(BUILD_DIR) $(BUILD_DIR)/test_datetime


# 安装静态链接库和头文件到系统目录
install:
	cp $(BUILD_DIR)/$(LIB_NAME).so $(LIB_DIR)
	cp include/datetime.h $(INCLUDE_DIR)

# 测试调用已安装的库
installtest:
	ldconfig
	$(BUILD_DIR)/test_datetime

# 清理生成的文件
clean:
	rm -rf $(BUILD_DIR)

# 编译目标文件
$(BUILD_DIR)/%.o: src/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# 创建目标文件夹
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
