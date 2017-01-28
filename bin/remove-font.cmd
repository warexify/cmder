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
:: @description  Script that uninstalls fonts recursively
:: @usage        remove-font -path "font_to_unintall.ttf"
::               remove-font -path "C:\folder\with\fonts\to\uninstall"
:: ----------------------------------------------------------------------------------------------------
@echo off
setlocal enableextensions

if /i ["%1"]   == ["/p"]       goto:path
if /i ["%1"]   == ["/path"]    goto:path
if /i ["%1"]   == ["-p"]       goto:path
if /i ["%1"]   == ["-path"]    goto:path
if /i ["%1"]   == ["--p"]      goto:path
if /i ["%1"]   == ["--path"]   goto:path
if /i ["%~2"]  == [""]         goto:help
if /i ["%*"]   == [""]         goto:help

:help
echo.The syntax of the command is incorrect.
echo.
echo.This script is used to uninstall Windows fonts.
echo. remove-font -path "<Font folder path>"
echo.             /p, -p, -path, --p, --path
echo.                 May be either the path to a font file or to a folder
echo.                 containing font files to install. Valid file types are
echo.                 .fon, .fnt, .ttf, .ttc, .otf, .mmm, .pbf, and .pfm
goto:eof

:path
Powershell -InputFormat None -ExecutionPolicy RemoteSigned -Command "ForEach ($font in (dir '%~2' -Include *.fon, *.fnt, *.ttf, *.ttc, *.otf, *.mmm, *.pbf, *.pfm -Recurse)) {  & '.\Uninstall-Font.ps1' -File $font.Name; }"
goto:eof

endlocal
