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

cd %dp0

:: Define parameters from arguments
SET architecture=%2
SET categories=base
SET installer=%1
SET local_package_dir=%4
SET packages=%5
SET root=%3
::SET site=http://mirrors.kernel.org/sourceware/cygwin/
SET site=http://mirrors.xmission.com/cygwin/

:: define the list separator
SET separator=,

ECHO Installing Cygwin %architecture%
ECHO Categories: %categories%

:: Get all the packages and make a well formated list
FOR /F "delims=" %%a IN (%local_package_dir%) DO (
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

:: Execute installer
%installer% --arch %architecture% --categories %categories% --delete-orphans --download --local-install --local-package-dir %local_package_dir% --no-shortcuts --packages %packages% --quiet-mode --root %root% --site %site% --upgrade-also

ENDLOCAL