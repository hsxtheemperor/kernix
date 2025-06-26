#ifndef VIDEODRIVER32_H
#define VIDEODRIVER32_H

#include <types.h>
#define VGA_WIDTH 80
#define VGA_HEIGHT 25
#define VGA_ADDRESS 0xB8000
#define COLOR_WHITE_ON_BLACK 0x0F
#define KEY_DEL 0x7F

extern uint16_t* const video_memory;
extern unsigned cursor_row;
extern unsigned cursor_col;

uint16_t vga_entry(char ch, char color);
void vga_clear();
void vga_print(char ch);
void vga_nav(uint8_t dirn);

#endif