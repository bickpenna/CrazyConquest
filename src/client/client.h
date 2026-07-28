#ifndef CLIENT_H
#define CLIENT_H

#include <stddef.h>

int client_connect(const char *host, int port);
void client_disconnect(int socket_fd);
int client_send_command(int socket_fd, const void *data, size_t len);

#endif /* CLIENT_H */
