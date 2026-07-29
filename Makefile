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

.PHONY: all build server server-sanitize client client-sanitize clients run run-sanitize sanitize clean format check-format check check-gcc check-clang check-cppcheck

# Default target: typing 'make' or 'make all' compiles the binaries (format -> compile)
all: build

default: all

# Build target: formats code first, then compiles only if files were modified
build: format $(SERVER_BIN) $(CLIENT_BIN)

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
# Postfix -sanitize allows autocomplete via TAB in terminal (e.g. make server<TAB>)
server-sanitize: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(SERVER_SRCS) -o $(SERVER_BIN)
	./scripts/run_local.sh server $(PORT) $(CLIENTS)

client-sanitize: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(CLIENT_SRCS) -o $(CLIENT_BIN)
	./scripts/run_local.sh clients $(PORT) $(CLIENTS)

clients-sanitize: client-sanitize

run-sanitize: format | $(BIN_DIR)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(SERVER_SRCS) -o $(SERVER_BIN)
	$(CC) $(CFLAGS) $(SAN_FLAGS) $(CLIENT_SRCS) -o $(CLIENT_BIN)
	./scripts/run_local.sh all $(PORT) $(CLIENTS)

sanitize: run-sanitize
sanitize-server: server-sanitize
sanitize-client: client-sanitize

format:
	@if command -v clang-format >/dev/null 2>&1; then \
		clang-format -i $$(find $(SRC_DIR) -name '*.c' -o -name '*.h'); \
	else \
		echo "⚠️ clang-format not installed locally. Skipping auto-format."; \
	fi

check-format:
	@command -v clang-format >/dev/null 2>&1 || { \
		echo "❌ clang-format is required. Install it before running this check."; \
		exit 1; \
	}
	@clang-format --dry-run --Werror $$(find $(SRC_DIR) -name '*.c' -o -name '*.h') || { \
		echo "❌ Formatting errors found! Run 'make format' locally."; \
		exit 1; \
	}

# Run the local equivalent of the GitHub Actions CI matrix.
check: check-format
	@$(MAKE) check-gcc
	@$(MAKE) check-clang
	@$(MAKE) check-cppcheck

check-gcc:
	@$(MAKE) clean
	@$(MAKE) CC=gcc

check-clang:
	@$(MAKE) clean
	@$(MAKE) CC=clang

check-cppcheck:
	@command -v cppcheck >/dev/null 2>&1 || { \
		echo "❌ cppcheck is required. Install it before running this check."; \
		exit 1; \
	}
	@cppcheck --enable=warning,style,performance,portability \
		--error-exitcode=1 \
		--inline-suppr \
		-I src/server -I src/client -I src/common \
		src/

clean:
	rm -f $(BIN_DIR)/server $(BIN_DIR)/client
