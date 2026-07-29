#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdint.h>

#define MAX_USERNAME_LEN 32
#define MAX_GRID_SIZE 64
#define PROTOCOL_MAGIC 0x4351 /* 'CQ' - CrazyConquest */

/* Fixed-alignment for network packets to prevent struct padding mismatch */
#pragma pack(push, 1)

/* Application-level protocol message types */
typedef enum {
    MSG_REGISTER_REQ = 1,
    MSG_REGISTER_RES = 2,
    MSG_MOVE_REQ = 3,
    MSG_LOCAL_MAP_UPDATE = 4,
    MSG_GLOBAL_MAP_UPDATE = 5,
    MSG_USER_LIST_REQ = 6,
    MSG_USER_LIST_RES = 7,
    MSG_DISCONNECT = 8
} message_type_t;

/* Standard Protocol Header (6 bytes) */
typedef struct {
    uint16_t magic;       /* Magic bytes for validation (PROTOCOL_MAGIC) */
    uint8_t type;         /* message_type_t */
    uint8_t flags;        /* Reserved for future use / flags */
    uint16_t payload_len; /* Length of following payload in bytes */
} message_header_t;

/* Payload: Registration Request */
typedef struct {
    char username[MAX_USERNAME_LEN];
} msg_register_req_t;

/* Payload: Registration Response */
typedef struct {
    uint8_t success; /* 1 = Success, 0 = Failed */
    uint16_t player_id;
    uint16_t start_x;
    uint16_t start_y;
} msg_register_res_t;

/* Movement Directions */
typedef enum { DIR_UP = 0, DIR_RIGHT = 1, DIR_DOWN = 2, DIR_LEFT = 3 } move_direction_t;

/* Payload: Move Request */
typedef struct {
    uint16_t player_id;
    uint8_t direction; /* move_direction_t */
} msg_move_req_t;

#pragma pack(pop)

#endif /* PROTOCOL_H */
