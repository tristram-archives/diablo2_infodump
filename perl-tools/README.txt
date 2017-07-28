The files in bin/ you execute.
These executable files require the files in share/d2-tools
All of the files in bin/ that point to share/d2-tools will be broken and need to be fixed.
To get this working on Windows you need Cygwin.
Once cygwin is installed you can execute the bash shell scripts in bash/
However, in Cygwin `perl` (the programming language interpretor [aka. the programming language]) and `go` (the programming language compiler [ie. allows you to compile Go programs into executables]). Why does it require Go?
