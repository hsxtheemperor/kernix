#include "videodriver32.c" // Video Driver
#include <types.h>
#include <mod_flags.h>
uint8_t mod_flags = 0;
extern void vga_print(char); // prints one character

// Scandcode Definition [PRESS] [RELEASE -> PRESS & 0x80]
#define CTRL_KEY 0x1D
#define RIGHT_SHIFT_KEY 0x36
#define LEFT_SHIFT_KEY 0x2A
#define CAPS_LOCK_KEY 0x3A
#define ALT_KEY 0x38
#define NUM_LOCK_KEY 0x45
#define EXTEND_KEY 0xE0
#define DEL_KEY 0x53
#define INSERT_KEY 0x52

 // Key Map [Binary Signals -> ASCII Keys] for example: [0x1E -> 'a'] Map
const char scancode_map[128] = { // Base Scancode Map
    0,  27, '1','2','3','4','5','6','7','8','9','0','-','=','\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,  'a','s','d','f','g','h','j','k','l',';','\'','`',
    0, '\\','z','x','c','v','b','n','m',',','.','/', 0, '*', 0,
    ' ', // Spacebar
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // F1–F12 and unused
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

char translate_ascii(char base, uint8_t flags) {
    // Handle letters
    if (base >= 'a' && base <= 'z') {
        bool caps = flags & MOD_CAPS; // Checks for CAPS LOCK
        bool shift = flags & (MOD_LEFT_SHFT | MOD_RIGHT_SHFT); // Checks for Shift Key
        if (caps ^ shift) {
            base -= 32; // Convert to uppercase
        }
    }

    // Handle symbols with Shift
    if (flags & (MOD_LEFT_SHFT | MOD_RIGHT_SHFT)) {
        switch (base) {
            case '1': return '!';
            case '2': return '@';
            case '3': return '#';
            case '4': return '$';
            case '5': return '%';
            case '6': return '^';
            case '7': return '&';
            case '8': return '*';
            case '9': return '(';
            case '0': return ')';
            case '-': return '_';
            case '=': return '+';
            case '`': return '~';
            case '[': return '{';
            case ']': return '}';
            case '\\': return '|';
            case ';': return ':';
            case '\'': return '"';
            case ',': return '<';
            case '.': return '>';
            case '/': return '?';
            default: break;
        }
    }

    return base;
}

void translate_numpad(){}

void keyboard_handler(){
    uint8_t rawcode = inb(0x60);
    bool released = rawcode & 0x80;       // Is MSB = 1?
    uint8_t scancode = rawcode & 0x7F;    // Strip MSB to get actual code
    if (rawcode == 0xE0) {
    mod_flags |= MOD_EXTEND;
    return;
    }

    if (mod_flags & MOD_EXTEND) {
    switch (scancode) {
        case CTRL_KEY: // Right Ctrl
            if (released) mod_flags &= ~MOD_CTRL;
            else          mod_flags |= MOD_CTRL;
            break;

        case INSERT_KEY: // Insert
            // insert logic
            break;

        case DEL_KEY: // Del
            if (!released) vga_print(KEY_DEL);
            break;

        // more extended keys

        default:
            break;
    }

    mod_flags &= ~MOD_EXTEND;
    outb(0x20, 0x20);
    return;
}

    mod_flags &= ~MOD_EXTEND; // Clear the extend flag now

    switch (scancode) { // Alters Mod Byte 
        case CTRL_KEY: // Left Ctrl
            if (released) mod_flags &= ~MOD_CTRL;
            else           mod_flags |= MOD_CTRL;
            break;

        case LEFT_SHIFT_KEY: // Left Shift
            if (released) mod_flags &= ~MOD_LEFT_SHFT;
            else           mod_flags |= MOD_LEFT_SHFT;
            break;

        case RIGHT_SHIFT_KEY: // Right Shift
            if (released) mod_flags &= ~MOD_RIGHT_SHFT;
            else           mod_flags |= MOD_RIGHT_SHFT;
            break;

        case ALT_KEY: // Alt
            if (released) mod_flags &= ~MOD_ALT;
            else           mod_flags |= MOD_ALT;
            break;

        case CAPS_LOCK_KEY: // Caps Lock — toggle only on press
            if (!released) mod_flags ^= MOD_CAPS;
            break;

        case NUM_LOCK_KEY: // Num Lock
        if (!released) mod_flags ^= MOD_NUMS;
        // Num Key Logic
        translate_numpad();
        break;

        default:
            if (!released) {
                char base = scancode_map[scancode];     // Convert scancode to raw ASCII
                char final = translate_ascii(base, mod_flags); // Apply Caps and Shift
                if (final) vga_print(final);             // Show final output
            }
            break;
    }
    
    
    outb(0x20, 0x20); // End Of Interrupt (EOI) to Programmable Interrupt Controller (PIC)
}

