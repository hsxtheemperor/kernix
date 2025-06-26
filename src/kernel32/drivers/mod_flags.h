// modifier_flags.h
#ifndef MODIFIER_FLAGS_H
#define MODIFIER_FLAGS_H

// Define individual bit flags (bit positions)
#define MOD_CTRL          (1 << 0)       // 0000 0001
#define MOD_LEFT_SHFT     (1 << 1)       // 0000 0010
#define MOD_RIGHT_SHFT    (1 << 2)       // 0000 0100
#define MOD_ALT           (1 << 3)       // 0000 1000
#define MOD_CAPS          (1 << 4)       // 0001 0000
#define MOD_NUMS          (1 << 5)       // 0010 0000
#define MOD_DEL           (1 << 6)       // 0100 0000
#define MOD_EXTEND        (1 << 7)       // 1000 0000

#endif
