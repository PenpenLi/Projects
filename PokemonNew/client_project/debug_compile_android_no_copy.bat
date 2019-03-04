@echo off
set dir=%~dp0
cocos compile -p android -m debug

rename simulator/android/PGame-debug.apk "%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%.apk"