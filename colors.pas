program lights;
uses crt;
var a,b:integer;
label 1;
begin
textbackground(white);
clrscr;
b:=0;
for a:=1 to 30000 do  b:=b+1;
randomize;
1:
a:=random(4)+1;
if a=1 then textbackground(blue);
if a=2 then textbackground(red);
if a=3 then textbackground(green);
if a=4 then textbackground(yellow);
write(' ');
goto 1;
end.
