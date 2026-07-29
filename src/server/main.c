#include "game.h"
#include "server.h"
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int port = 8080;
    if (argc > 1) {
        port = atoi(argv[1]);
    }

    printf("Starting CrazyConquest Server on port %d...\n", port);

    int server_fd = server_init(port);
    game_init(20, 20);

    server_run(server_fd);

    game_cleanup();
    server_cleanup();

    return 0;
}
