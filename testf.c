int main () {
   extern char myfortsub(char[10]);
   char test [10] = "abcd";

   myfortsub (test);

   return 0;

}
