#include <stdbool.h>
#define NUMKEYS 16   // number of keys on keypad
#define BADCODE 0xFF // error code
#define NOKEY 0x00   // no key pressed
#define POLLCOUNT 1  // number of loops to create 1 ms poll time

#define keyA 0b

char porta, ddra, pucr;

void delayms(int ms);

// ; Description:
// ;  Loops for a period of 2ms, checking to see if
// ;  key is pressed. Calls readKey to read key if keypress
// ;  detected (and debounced) on Port A and get ASCII code for
// ;  key pressed.
char pollReadKey()
{
    char ch = NOKEY;

    porta = 0X0F; // set porta to nothing

    int count = POLLCOUNT; // loop for pollcount times
    while (count != 0)
    {
        if (porta != 0x0F) // change detected
        {
            delayms(1);         // see if anything changes after 1 ms
            if (porta != 0x0F)  // make sure it hasn't changed
                ch = readKey(); // return the key that is currently pressed
        }
        count--;
    }
    return ch;
}

// Initialize port A for keypad
void initKey()
{
    porta = 0x0F; // set porta to nothing
    ddra = 0xF0;  // set port A top 4 bits to output
}

// ; Description:
// ;  Main subroutine that reads a code from the
// ;  keyboard using the subroutine readKeybrd.  The
// ;  code is then translated with the subroutine
// ;  translate to get the corresponding ASCII code.
char readKey()
{
    delayms(10); // to debounce keypress
    switch (porta)
    {
    case 0b00011110: // 1
        return '1';
    case 0b00011101: // 2
        return '2';
    case 0b00011011: // 3
        return '3';
    case 0b00010111: // a
        return 'a';
    case 0b00101110: // 4
        return '4';
    case 0b00101101: // 5
        return '5';
    case 0b00101011: // 6
        return '6';
    case 0b00100111: // b
        return 'b';
    case 0b01001110: // 7
        return '7';
    case 0b01001101: // 8
        return '8';
    case 0b01001011: // 9
        return '9';
    case 0b01000111: // c
        return 'c';
    case 0b10001110: // *
        return '*';
    case 0b10001101: // 0
        return '0';
    case 0b10001011: // #
        return '#';
    case 0b10000111: // d
        return 'd';
    default:
        return NOKEY;
    }
}