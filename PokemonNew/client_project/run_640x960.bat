@echo off
set dir=%~dp0
%dir%trunk\simulator\win32\PGame.exe -workdir %dir% -resolution 640x960 -write-debug-log debug.txt -console enable 