#include "client.h"
#include "ui.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, const char *argv[]) {
    const char *host = "127.0.0.1";
    int port = 8080;

    if (argc > 1) {
        host = argv[1];
    }
    if (argc > 2) {
        port = atoi(argv[2]);
    }

    printf("Connecting CrazyConquest Client to %s:%d...\n", host, port);

    ui_init();
    int socket_fd = client_connect(host, port);
    (void)socket_fd;

    ui_render_map();

    ui_cleanup();
    return 0;
}
