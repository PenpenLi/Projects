@echo off

set root_dir=%~dp0
set app_path=%root_dir%\pc_test\Pokemon

echo root_dir = %root_dir%
echo app_path = %app_path%
echo "%root_dir%"
"%root_dir%/UFPlayer.exe" "-workdir" %app_path% -size 640x960
exit 