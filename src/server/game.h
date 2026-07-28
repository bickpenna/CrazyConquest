#ifndef SERVER_GAME_H
#define SERVER_GAME_H

#include "../common/game_types.h"

void game_init(int width, int height);
void game_update(void);
void game_cleanup(void);

#endif /* SERVER_GAME_H */
