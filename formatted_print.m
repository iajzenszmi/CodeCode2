Wed 28 Sep 2022 10:29:46 AEST
(10:29 ian@ian-Aspire-One-753 ~) > vim
(10:34 ian@ian-Aspire-One-753 ~) > octave realint.m
Warning: Ignoring XDG_SESSION_TYPE=wayland on Gnome. Use QT_QPA_PLATFORM=wayland to run on Wayland anyway.
real=12.896, integer=42, string=some messagereal=1.290e+01, integer=   42, string=some message(10:35 ian@ian-Aspire-One-753 ~) > cat realint.m
real = 12.89643;
integer = 42;
string = 'some message';
fprintf('real=%.3f, integer=%d, string=%s', real, integer, string);
fprintf('real=%9.3e, integer=%5d, string=%s', real, integer, string);
(10:36 ian@ian-Aspire-One-753 ~) >
