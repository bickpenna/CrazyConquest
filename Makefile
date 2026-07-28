# Configuration for local testing
PORT ?= 8080
CLIENTS ?= 2

CC = gcc
CFLAGS = -Wall -Wextra -Isrc/server -Isrc/client -Isrc/common -Isrc -std=c99 -D_POSIX_C_SOURCE=200809L
SAN_FLAGS = -fsanitize=address,undefined -g

BIN_DIR = bin
SRC_DIR = src

COMMON_SRCS = $(wildcard $(SRC_DIR)/common/*.c)
SERVER_SRCS = $(wildcard $(SRC_DIR)/server/*.c) $(COMMON_SRCS)
CLIENT_SRCS = $(wildcard $(SRC_DIR)/client/*.c) $(COMMON_SRCS)

SERVER_BIN = $(BIN_DIR)/server
CLIENT_BIN = $(BIN_DIR)/client

.PHONY: default build all server client clean format check-format run sanitize sanitize-server sanitize-client

# Default target: typing 'make' does EVERYTHING (format -> compile -> launch server + clients)
default: build run

# Build target: formats code first, then compiles only if files were modified
build: format $(SERVER_BIN) $(CLIENT_BIN)

all: build

$(SERVER_BIN): $(SERVER_SRCS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(CLIENT_BIN): $(CLIENT_SRCS) | $(BIN_DIR)
	$(CC) $(CFLAGS) $^ -o $@

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Standard Launch targets
server: format $(SERVER_BIN)
	./scripts/run_local.sh server $(PORT) $(CLIENTS)

client: format $(CLIENT_BIN)
	./scripts/run_local.sh clients $(PORT) $(CLIENTS)

clients: client

run: build
	./scripts/run_local.sh all $(PORT) $(CLIENTS)

# Sanitizer Launch targets (AddressSanitizer & UndefinedBehaviorSanitizer)
sanitize: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(SERVER_SRCS) -o $(SERVER_BIN)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(CLIENT_SRCS) -o $(CLIENT_BIN)
	./scripts/run_local.sh all $(PORT) $(CLIENTS)

sanitize-server: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(SERVER_SRCS) -o $(SERVER_BIN)
	./scripts/run_local.sh server $(PORT) $(CLIENTS)

sanitize-client: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(CLIENT_SRCS) -o $(CLIENT_BIN)
	./scripts/run_local.sh clients $(PORT) $(CLIENTS)

format:
	@if command -v clang-format >/dev/null 2>&1; then \
		clang-format -i $$(find $(SRC_DIR) -name '*.c' -o -name '*.h'); \
	else \
		echo "⚠️ clang-format not installed locally. Skipping auto-format."; \
	fi

check-format:
	clang-format --dry-run --Werror $$(find $(SRC_DIR) -name '*.c' -o -name '*.h')

clean:
	rm -f $(BIN_DIR)/server $(BIN_DIR)/client
