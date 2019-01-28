@echo off
SET CMDER_ROOT=%~dp0
SET CWD=%CD%
@if "%CMDER_ROOT:~-1%" == "\" SET CMDER_ROOT=%CMDER_ROOT:~0,-1%
CALL "%CMDER_ROOT%\vendor\init.bat"
CD /D %CWD%