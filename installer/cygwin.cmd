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
:: @package      cygwin
:: @description  Build the list of packages to install with Cygwin and execute the installer
:: ----------------------------------------------------------------------------------------------------
:: Turn off output
@ECHO off

SETLOCAL EnableDelayedExpansion

:: Define parameters from arguments
SET architecture=%1
SET categories=base
SET installer=%3
SET local_package_dir=%4
SET package_list=%5
SET root=%2
SET mode=%6

SET site=ftp://mirrors.sonic.net/cygwin/
:: define the list separator
SET separator=,

IF /I %mode%=="install" (
  ECHO Installing Cygwin %architecture%
  ECHO Categories: %categories%
)

IF /I %mode%=="update" (
  ECHO Updating Cygwin %architecture%
  
  :: Update Cygwin setup.ini
  %root%\bin\bash.exe --login -c '/bin/apt-cyg update'

  :: Update Cygwin installer
  %root%\bin\bash.exe --login -c '/bin/apt-cyg update-setup'
) 

:: Get all the packages and make a well formated list
FOR /F "delims=" %%a IN ('type %package_list%') DO (
  SET currentline=%%a
  IF NOT DEFINED packages (
    SET packages=!currentline!
  ) ELSE (
    SET packages=!packages!%separator%!currentline!
  )
)

ECHO Packages: %packages%
ECHO Root Directory: %root%
ECHO Local Package Directory: %local_package_dir%

IF /I %mode%=="install" (
  :: Execute installer for install
  %installer% --arch %architecture% --categories %categories% --delete-orphans --download --local-install --local-package-dir %local_package_dir% --no-shortcuts --packages %packages% --quiet-mode --root %root% --site %site% --upgrade-also
)

IF /I %mode%=="update" (
  :: Execute installer for update
  %installer% --arch %architecture% --categories %categories% --delete-orphans --download --local-install --local-package-dir %local_package_dir% --no-shortcuts --packages %packages% --root %root% --upgrade-also
) 

ENDLOCAL
