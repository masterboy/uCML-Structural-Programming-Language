Submitted By:-

16701053 - Md. Arif Reza
16701032 - Angel Sharma
16701076 - Rezaul Karim

It's straightforward to compile and run this program.
The entire grammer has been modified, rewritten to be recognized by BISON and FLEX.
Shift/Reduce conflicts don't need to be solved, the default reduce action is exactly what we intended.
$ make clean
$ make -f Makefile.prod

"Makefile" is for development build, "Makefile.prod" is for production build. Development build generates debug information and verbose files.


To run:-
$ ./uc z_variables.go

".go" extension is used since our language closely resembles the syntax of Go, hence we get Code Editor Text Hightlighting out of the box.

"mode debug" in code will set the interpreter to debug mode, printing the variables, states of our program along with the result. It's meant to used only for development.