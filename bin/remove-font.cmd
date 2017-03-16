::----------------------------------------------------------------------------------------------------
:: shark
:: The shell environment of your dreams
::
:: Shark is a package installer that will allow you to create a fully customized shell environment
:: through a single simple installer. It takes the hard work out of downloading and configuring all
:: the components you need. Shark simplifies the installation by asking simple questions and taking
:: care of downloading and installing everything FOR you from trusted sources (official repositories).
:: It has a modular architecture that allows anyone to add and improve the installer easilly.
::
:: @author       Kenrick JORUS
:: @copyright    2016 Kenrick JORUS
:: @license      MIT License
:: @link         http://kenijo.github.io/shark/
::
:: @package      remove-font
:: @description  This script is used to uninstall a Windows font.
:: @usage        remove-font.cmd -file "MyFont.ttf"
::               remove-font.cmd -path "C:\Custom Fonts\MyFont.ttf"
::               remove-font.cmd -path "C:\Custom Fonts"
:: ----------------------------------------------------------------------------------------------------
@echo off
setlocal enableextensions

if /i ["%1"]   == ["/f"]       goto:file
if /i ["%1"]   == ["/file"]    goto:file
if /i ["%1"]   == ["-f"]       goto:file
if /i ["%1"]   == ["-file"]    goto:file
if /i ["%1"]   == ["--f"]      goto:file
if /i ["%1"]   == ["--file"]   goto:file
if /i ["%1"]   == ["/p"]       goto:path
if /i ["%1"]   == ["/path"]    goto:path
if /i ["%1"]   == ["-p"]       goto:path
if /i ["%1"]   == ["-path"]    goto:path
if /i ["%1"]   == ["--p"]      goto:path
if /i ["%1"]   == ["--path"]   goto:path
if /i ["%~2"]  == [""]         goto:help
if /i ["%*"]   == [""]         goto:help

:help
echo.remove-font.cmd
echo.  This script is used to uninstall a Windows font.
echo.
echo.Usage:
echo.  remove-font.cmd -file "<Font file>" ^| -path "<Font file path or folder path>"
echo.
echo.Parameters:
echo.  -help
echo.   Displays usage information.
echo.  -file
echo.   A font file to remove from \Windows\Fonts.
echo.   Valid file types are .fon, .fnt, .ttf, .ttc, .otf,
echo.   .mmm, .pbf, and .pfm
echo.  -path
echo.   May be either the path to a font file or the path to a
echo.   reference folder containing font files to remove from
echo.   \Windows\Fonts.  Valid file types are .fon, .fnt, .ttf,
echo.   .ttc, .otf, .mmm, .pbf, and .pfm
echo.
echo.Examples:
echo.  remove-font.cmd
echo.  remove-font.cmd -file "MyFont.ttf"
echo.  remove-font.cmd -path "C:\Custom Fonts\MyFont.ttf"
echo.  remove-font.cmd -path "C:\Custom Fonts"
goto:eof

:path
Powershell -ExecutionPolicy Bypass -InputFormat None -Command "Invoke-Expression '.\Remove-Font.ps1 -Path ''%~2'''"
goto:eof

endlocal
