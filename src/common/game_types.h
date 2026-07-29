#ifndef GAME_TYPES_H
#define GAME_TYPES_H

#include <stdint.h>

#define MAX_NICKNAME_LEN 32
#define MAX_PLAYERS 64

typedef enum { CELL_EMPTY = 0, CELL_WALL = 1 } CellType;

typedef struct {
    int x;
    int y;
} Position;

typedef struct {
    CellType type;
    int owner_id; // -1 if unclaimed
} Cell;

typedef struct {
    int id;
    char nickname[MAX_NICKNAME_LEN];
    Position pos;
    int score;
    int is_connected;
} Player;

#endif /* GAME_TYPES_H */
