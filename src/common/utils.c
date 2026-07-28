#include "utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

void log_message(const char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fprintf(stderr, "\n");
}

void handle_error(const char *msg) {
    perror(msg);
    exit(EXIT_FAILURE);
}
