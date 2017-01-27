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
:: @package      modules
:: @description  Adds the list of modules to the nsi script
:: ----------------------------------------------------------------------------------------------------
:: Turn off output
@ECHO off

SETLOCAL enabledelayedexpansion

:: Define parameters from arguments
SET nsi_file=%1
SET module_folder=%2

FOR %%F IN (%module_folder%\*.nsh) DO (
  SET basename=%%~nF
  SET name=!basename:~3!
  IF /I NOT '!name!'=='separator' (
    ECHO      ^^!insertmacro MUI_DESCRIPTION_TEXT ${section_!name!} $^(desc_!name!^) >> %nsi_file%
  )
)
ENDLOCAL