#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
Display* display;
Window window;
int main( int argc, char *argv[] ){
display = XOpenDisplay("");
if (display == NULL) exit (-1);
int screennum = DefaultScreen(display);
long background = WhitePixel(display, screennum);
long foreground = BlackPixel(display, screennum);
window = XCreateSimpleWindow(display, DefaultRootWindow(display),
10, 10, 800, 600, 2, foreground, background);
XSetStandardProperties(display, window, "Bank Account", "OW",None, argv, argc, None);
XMapRaised(display, window);
XFlush(display);
sleep(2000);
//XCloseDisplay(display);
}
