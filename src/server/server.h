#ifndef SERVER_H
#define SERVER_H

int server_init(int port);
void server_run(int server_fd);
void server_cleanup(void);

#endif /* SERVER_H */
