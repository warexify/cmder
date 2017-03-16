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
:: @package      add-font
:: @description  This script is used to install Windows fonts
:: @usage        add-font.cmd -path "C:\Custom Fonts\MyFont.ttf"
::               add-font.cmd -path "C:\Custom Fonts"
:: ----------------------------------------------------------------------------------------------------
@echo off
setlocal enableextensions

if /i ["%1"]   == ["/p"]      goto:path
if /i ["%1"]   == ["/path"]   goto:path
if /i ["%1"]   == ["-p"]      goto:path
if /i ["%1"]   == ["-path"]   goto:path
if /i ["%1"]   == ["--p"]     goto:path
if /i ["%1"]   == ["--path"]  goto:path
if /i ["%~2"]  == [""]        goto:help
if /i ["%*"]   == [""]        goto:p

:help
echo.add-font.cmd
echo.  This script is used to install Windows fonts.
echo.
echo.Usage:
echo.  add-font.cmd -path "<Font file or folder path>"
echo.
echo.Parameters:
echo.  -path
echo.   May be either the path to a font file or the path to a folder
echo.   containing font files to install. Valid file types are .fon,
echo.   .fnt, .ttf, .ttc, .otf, .mmm, .pbf, and .pfm
echo.
echo.Examples:
echo.  add-font.cmd
echo.  add-font.cmd -path "C:\Custom Fonts\MyFont.ttf"
echo.  add-font.cmd -path "C:\Custom Fonts"
goto:eof

:path
Powershell -ExecutionPolicy Bypass -InputFormat None -Command "Invoke-Expression '.\Add-Font.ps1 -Path ''%~2'''"
goto:eof

endlocal
