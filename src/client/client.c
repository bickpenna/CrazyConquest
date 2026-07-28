#include "client.h"
#include "../common/utils.h"
#include <stdio.h>

int client_connect(const char *host, int port) {
    (void)host;
    (void)port;
    /* Connection stub */
    return -1;
}

void client_disconnect(int socket_fd) {
    (void)socket_fd;
    /* Disconnect stub */
}

int client_send_command(int socket_fd, const void *data, size_t len) {
    (void)socket_fd;
    (void)data;
    (void)len;
    /* Send stub */
    return 0;
}
