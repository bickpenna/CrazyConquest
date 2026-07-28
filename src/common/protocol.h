#ifndef PROTOCOL_H
#define PROTOCOL_H

#include <stdint.h>

/* Application-level protocol message types */
typedef enum {
    MSG_REGISTER_REQ = 1,
    MSG_REGISTER_RES,
    MSG_MOVE_REQ,
    MSG_LOCAL_MAP_UPDATE,
    MSG_GLOBAL_MAP_UPDATE,
    MSG_USER_LIST_REQ,
    MSG_USER_LIST_RES,
    MSG_DISCONNECT
} MessageType;

/* Protocol Header */
typedef struct {
    uint8_t type;
    uint32_t payload_len;
} MessageHeader;

#endif /* PROTOCOL_H */
