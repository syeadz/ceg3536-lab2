#include <stdbool.h>
#define NUMKEYS 16   // number of keys on keypad
#define BADCODE 0xFF // error code
#define NOKEY 0x00   // no key pressed
#define POLLCOUNT 1  // number of loops to create 1 ms poll time

char porta, ddra, pucr;

void delayms(int ms);

// ; Description:
// ;  Loops for a period of 2ms, checking to see if
// ;  key is pressed. Calls readKey to read key if keypress 
// ;  detected (and debounced) on Port A and get ASCII code for
// ;  key pressed.
char pollReadKey() {

    porta = 0X0F;

    int count = POLLCOUNT;
    while(count != 0){
        delayms(1);
        if (porta != 0x0F)
        {
            return readKey();
        }
        count--;
    }

}

// initialize port A for keypad
void initKey()
{
    ddra = 0x00; // set port A to input
    pucr = 0x01; // disable pullups
}

// ; Description:
// ;  Main subroutine that reads a code from the
// ;  keyboard using the subroutine readKeybrd.  The
// ;  code is then translated with the subroutine
// ;  translate to get the corresponding ASCII code.
char readKey()
{
    if (porta == 0x11)
    {
        return 0x01; // 1
    }
    else if (porta == 0x12)
    {
        return 0x02; // 2
    }
    else if (porta == 0x14)
    {
        return 0x03; // 3
    }
    else if (porta == 0x18)
    {
        return 0x41; // A
    }
    else if (porta == 0x21)
    {
        return 0x04; // 4
    }
    else if (porta == 0x22)
    {
        return 0x05; // 5
    }
    else if (porta == 0x24)
    {
        return 0x06; // 6
    }
    else if (porta == 0x28)
    {
        return 0x42; // B
    }
    else if (porta == 0x41)
    {
        return 0x07; // 7
    }
    else if (porta == 0x42)
    {
        return 0x08; // 8
    }
    else if (porta == 0x44)
    {
        return 0x09; // 9
    }
    else if (porta == 0x48)
    {
        return 0x43; // C
    }
    else if (porta == 0x81)
    {
        return 0x2A; // *
    }
    else if (porta == 0x82)
    {
        return 0x00; // 0
    }
    else if (porta == 0x84)
    {
        return 0x23; // #
    }
    else if (porta == 0x88)
    {
        return 0x44; // D
    } else
    {
        return NOKEY;
    }
}