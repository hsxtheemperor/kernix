#include <types.h>
#include <nav_keys.h>
#define VGA_WIDTH 80 // VGA Monitor Width
#define VGA_HEIGHT 25 // VGA Monitor Height
#define VGA_ADDRESS 0xB8000 // VGA Memory Address
#define COLOR_WHITE_ON_BLACK 0x0F // Black BG -> 0x0, White FG -> 0xF => [0x0F] or [0x{FG}{BG}]
#define KEY_DEL 0x7F // Delete Key ASCII

uint16_t*const video_memory = (unsigned short*) VGA_ADDRESS; // Stores ASCII Characters to VGA Memory

unsigned cursor_row = 0; // Row Initial
unsigned cursor_col = 0; // Coloumn Initial

// Combine character and color into one 16-bit VGA entry
uint16_t vga_entry(char ch, char color){ // Stores ASCII Characters to be added to the Video Memory Counter
    return((uint16_t)color << 8) | (uint8_t)ch ; // 2 bytes -> [1 byte for character | 1 byte for color]
}

void vga_clear(){
    for(int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++){
        video_memory[i] = vga_entry(' ', COLOR_WHITE_ON_BLACK); // Enters Empty Characters
    }
    cursor_row = 0;
    cursor_col = 0;
}

void vga_print(char ch){
    if(ch == '\n'){ // New Line
        cursor_row++;
        cursor_col = 0;
    }else if(ch == '\b'){ // Backspace
        if (cursor_col > 0){ // prevent underflow
        video_memory[cursor_row * VGA_WIDTH + cursor_col] = vga_entry(' ', COLOR_WHITE_ON_BLACK);
        cursor_col--;
        }
    }else if(ch == '\t'){ // Tab
        for(int i = 0; i < 4; i++){
            video_memory[cursor_row * VGA_WIDTH + cursor_col] = vga_entry(' ', COLOR_WHITE_ON_BLACK);
            cursor_col++;
        }
    }else if(ch == KEY_DEL){ // Delete
        cursor_col++;
        video_memory[cursor_row * VGA_WIDTH + cursor_col] = vga_entry(' ', COLOR_WHITE_ON_BLACK);
        cursor_col--;
    }else{
        video_memory[cursor_row * VGA_WIDTH + cursor_col] = vga_entry(ch, COLOR_WHITE_ON_BLACK); // Enters ASCII Character
        cursor_col++;

        if(cursor_col >= VGA_WIDTH){ // Auto Shifts to New Line
            cursor_col = 0;
            cursor_row++;
        }
    }

    if(cursor_row >= VGA_HEIGHT){
    vga_clear(); // Basic wrap-around (or you can implement scrolling later)
    }
}

void vga_nav(uint8_t dirn){
    switch(dirn){
        case NAV_UP:
            if(cursor_row > 0) cursor_row--;
            break;
        case NAV_DOWN:
            if(cursor_row < VGA_HEIGHT) cursor_row++;
            break;
        case NAV_LEFT:
            if(cursor_col < VGA_WIDTH) cursor_col++;
            break;
        case NAV_RIGHT:
            if(cursor_col > 0) cursor_col--;
            break;
        default:
            break;
    }
}