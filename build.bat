echo off

DEL *.xex /Q

REM ****************************** 
REM * compile and link code
REM ******************************

"C:\Program Files (x86)\Mads\mads.exe" -p -u -t:vbxe.lab -l:vbxe.lst main.asm -o:vbxe.xex 
if errorlevel 1 goto :error

vbxe.xex

goto :eof 
:error 
    echo "* * * an error occured -->aborting * * *"
:eof 
