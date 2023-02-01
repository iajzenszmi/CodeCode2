ian@ian-HP-Convertible-x360-11-ab1XX:~/CodeCode$ pforth sieve.fs
PForth V21
pForth loading dictionary from file /usr/lib/pforth/pforth.dic
     File format version is 8 
     Name space size = 120000 
     Code space size = 300000 
     Entry Point     = 0 
     Little  Endian Dictionary
Begin AUTO.INIT ------
Including: sieve.fs
Primes: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 End AUTO.TERM ------
ian@ian-HP-Convertible-x360-11-ab1XX:~/CodeCode$ yforth sieve.fs
yForth? v0.2  Copyright (C) 2012  Luca Padovani
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions; see LICENSE for details.
error(17): segmentation fault.
Segmentation fault (core dumped)
ian@ian-HP-Convertible-x360-11-ab1XX:~/CodeCode$ sudo apt install gforth
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages were automatically installed and are no longer required:
  dizzy dkms freeglut3 libalien-sdl-perl libclass-inspector-perl
  libconvert-color-perl libfile-sharedir-perl libflashrom1 libftdi1-2 libgle3
  libjpeg-turbo-progs libllvm13 libmodule-pluggable-perl libopengl-perl
  libopengl-xscreensaver-perl libsdl-perl libtie-simple-perl
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  gforth-common gforth-lib
The following NEW packages will be installed:
  gforth gforth-common gforth-lib
0 to upgrade, 3 to newly install, 0 to remove and 38 not to upgrade.
Need to get 617 kB of archives.
After this operation, 3,033 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://au.archive.ubuntu.com/ubuntu jammy/universe amd64 gforth-common all 0.7.3+dfsg-9build4.1 [329 kB]
Get:2 http://au.archive.ubuntu.com/ubuntu jammy/universe amd64 gforth-lib amd64 0.7.3+dfsg-9build4.1 [150 kB]
Get:3 http://au.archive.ubuntu.com/ubuntu jammy/universe amd64 gforth amd64 0.7.3+dfsg-9build4.1 [139 kB]
Fetched 617 kB in 0s (1,396 kB/s)
Selecting previously unselected package gforth-common.
(Reading database ... 371140 files and directories currently installed.)
Preparing to unpack .../gforth-common_0.7.3+dfsg-9build4.1_all.deb ...
Unpacking gforth-common (0.7.3+dfsg-9build4.1) ...
Selecting previously unselected package gforth-lib:amd64.
Preparing to unpack .../gforth-lib_0.7.3+dfsg-9build4.1_amd64.deb ...
Unpacking gforth-lib:amd64 (0.7.3+dfsg-9build4.1) ...
Selecting previously unselected package gforth.
Preparing to unpack .../gforth_0.7.3+dfsg-9build4.1_amd64.deb ...
Unpacking gforth (0.7.3+dfsg-9build4.1) ...
Setting up gforth-common (0.7.3+dfsg-9build4.1) ...
Setting up gforth-lib:amd64 (0.7.3+dfsg-9build4.1) ...
Setting up gforth (0.7.3+dfsg-9build4.1) ...
Install emacsen-common for emacs
emacsen-common: Handling install of emacsen flavor emacs
Install gforth for emacs
Processing triggers for man-db (2.10.2-1) ...
ian@ian-HP-Convertible-x360-11-ab1XX:~/CodeCode$ gforth sieve.fs
Primes: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 Gforth 0.7.3, Copyright (C) 1995-2008 Free Software Foundation, Inc.
Gforth comes with ABSOLUTELY NO WARRANTY; for details type `license'
Type `bye' to exit

:0: User interrupt
Backtrace:
$7FCF1F954F10 key-file 
$7FCF1F976D88 (key) 
$7FCF1F95E348 xkey 
$7FCF1F95E400 edit-line 
$7FCF1F95EB20 accept 
$7FCF1F95E4D8 perform 
bye 
ian@ian-HP-Convertible-x360-11-ab1XX:~/CodeCode$ cat sieve.fs
: prime? ( n -- ? ) here + c@ 0= ;
: composite! ( n -- ) here + 1 swap c! ;

: sieve ( n -- )
  here over erase
  2
  begin
    2dup dup * >
  while
    dup prime? if
      2dup dup * do
        i composite!
      dup +loop
    then
    1+
  repeat
  drop
  ." Primes: " 2 do i prime? if i . then loop ;

100 sieve
