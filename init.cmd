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
:: @package      init
:: @description  Initialize the application
::               This file is a heavy modification of Cmder .\vendor\init.bat
:: ----------------------------------------------------------------------------------------------------
:: Turn off output
@echo off

:: Set to > 0 for verbose output to aid in debugging.
if not defined verbose-output ( set verbose-output=0 )

:: Set root directory
set shark_root=%~dp0

:: Remove trailing '\'
@if "%shark_root:~-1%" == "\" set shark_root=%shark_root:~0,-1%

:: Enhance Path
set "PATH=%PATH%;%shark_root%;%shark_root%\bin"

:: Set directories
set shark_config=%shark_root%\config
set shark_default=%shark_config%\default
set shark_profile=%shark_config%\%username%
set shark_modules=%shark_root%\modules

:: Create a user profile on first use
if not exist "%shark_profile%" (
  echo Creating a user profile in "%shark_profile%"
  echo You can customize and backup your profile there. It won't be overwritten.
  echo Creating aliases store in "aliases.cmd"
  echo Creating profile in "profile.cmd", use it to run your own startup commands
  mkdir "%shark_profile%"
  xcopy "%shark_default%" "%shark_profile%" /e /i /q > nul
)

:: Make sure we have a self-extracting aliases.cmd file
if not exist "%shark_profile%\aliases.cmd" (
  echo Creating aliases store in "aliases.cmd"
  copy "%shark_default%\aliases.cmd" "%shark_profile%\aliases.cmd" > nul
)

:: Make sure we have a self-extracting profile.cmd file
if not exist "%shark_profile%\profile.cmd" (
  echo Creating profile in "profile.cmd", use it to run your own startup commands
  copy "%shark_default%\profile.cmd" "%shark_profile%\profile.cmd" > nul
)

:: Set Clink directory
if /i "%processor_architecture%" == "x86" (
  set shark_clink=%shark_modules%\clink\clink_x86.exe
) else if /i "%processor_architecture%" == "amd64" (
  if defined processor_architew6432 (
    set shark_clink=%shark_modules%\clink\clink_x86.exe
  ) else (
    set shark_clink=%shark_modules%\clink\clink_x64.exe
  )
)

:: Execute Clink
"%shark_clink%" inject --quiet --profile "%shark_profile%\clink" --scripts "%shark_config%"

:: Drop *.bat and *.cmd files into "%shark_profile%" to run them at startup.
pushd "%shark_profile%"
for /f "usebackq" %%x in ( `dir /b *.bat *.cmd 2^>nul` ) do (
  call :verbose-output Calling "%shark_profile%\%%x"...
  call "%shark_profile%\%%x"
)
popd

:: Set home path
:: TODO: might have to set it to cygwin /profile
if not defined HOME set "HOME=%userprofile%"

:: Add aliases to the environment
call "%shark_profile%\aliases.cmd"

:: This is a environment variable set by the user through a command line argument
:: or a right click "Open Command Line Here"
if defined shark_start (
  cd /d "%shark_start%"
)

:: Execute user startup scripts
call "%shark_profile%\profile.cmd"

exit /b

::
:: sub-routines below here
::
:verbose-output
  if %verbose-output% gtr 0 echo %*
  exit /b