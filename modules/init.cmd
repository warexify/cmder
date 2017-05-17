::----------------------------------------------------------------------------------------------------
:: shark
:: The shell environment of your dreams
::
:: Shark is a package installer that will allow you to create a fully customized shell environment
:: through a single simple installer. It takes the hard work out of downloading and configuring all
:: the components you need. Shark simplifies the installation by asking simple questions and taking
:: care of downloading and installing everything for you from trusted sources (official repositories).
:: It has a modular architecture that allows anyone to add and improve the installer easilly.
::
:: @author       Kenrick JORUS
:: @copyright    2016 Kenrick JORUS
:: @license      MIT License
:: @link         http://kenijo.github.io/shark/
::
:: @package      init.cmd
:: @description  Init script for CMD
::                !!! THIS FILE IS OVERWRITTEN WHEN SHARK IS UPDATED
::                !!! Use "%SHARK_ROOT%\config\profile.cmd" to add your own startup commands
:: ----------------------------------------------------------------------------------------------------
:: Turn off output
@echo off

:: Set to > 0 for verbose output to aid in debugging.
if not defined verbose-output ( set verbose-output=0 )

:: Find root dirs
if not defined SHARK_ROOT (
  set "SHARK_ROOT=%~dp0.."
)

:: Remove trailing '\'
if "%SHARK_ROOT:~-1%" == "\" SET "SHARK_ROOT=%SHARK_ROOT:~0,-1%"

set "PATH=%PATH%;%SHARK_ROOT%\bin"
set "PATH=%PATH%;%SHARK_ROOT%\modules\cygwin\bin"
set "PATH=%PATH%;%SHARK_ROOT%\modules\git\bin"
set "PATH=%PATH%;%SHARK_ROOT%\modules\gow\bin"
set "PATH=%PATH%;%SHARK_ROOT%\modules\php"
set "PATH=%PATH%;%SHARK_ROOT%\modules\putty"

:: Force the architecture if an argument is passed
if "%1"=="x86" (
  set "PROCESSOR_ARCHITECTURE=x86"
)
if "%1"=="x64" (
  set "PROCESSOR_ARCHITECTURE=x64"
)

:: Pick right version of clink
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
  set architecture=86
) else (
  set architecture=64
)

:: Tell the user about the clink config files...
if not exist "%SHARK_ROOT%\config\clink" (
  echo Generating clink initial settings in "%SHARK_ROOT%\config\clink"
  echo Additional *.lua files in "%SHARK_ROOT%\config\clink" are loaded on startup.
)

:: Run clink
"%SHARK_ROOT%\modules\clink\clink_x%architecture%.exe" inject --quiet --profile "%SHARK_ROOT%\config\clink" --scripts "%SHARK_ROOT%\config"

:: Prepare for git-for-windows

:: I do not even know, copypasted from their .bat
set PLINK_PROTOCOL=ssh
if not defined TERM set TERM=cygwin

:: The idea:
:: * if the users points as to a specific git, use that
:: * test if a git is in path and if yes, use that
:: * last, use our vendored git
:: also check that we have a recent enough version of git (e.g. test for GIT\cmd\git.exe)
if defined GIT_INSTALL_ROOT (
  if exist "%GIT_INSTALL_ROOT%\cmd\git.exe" (goto :FOUND_GIT)
)

:: check if git is in path...
setlocal enabledelayedexpansion
for /F "delims=" %%F in ('where git.exe 2^>nul') do @(
  pushd %%~dpF
  cd ..
  set "test_dir=!CD!"
  popd
  if exist "!test_dir!\cmd\git.exe" (
    set "GIT_INSTALL_ROOT=!test_dir!"
    set test_dir=
    goto :FOUND_GIT
  ) else (
    echo Found old git version in "!test_dir!", but not using...
    set test_dir=
  )
)

:: our last hope: our own git...
:VENDORED_GIT
if exist "%SHARK_ROOT%\modules\git" (
  set "GIT_INSTALL_ROOT=%SHARK_ROOT%\modules\git"
  call :verbose-output Add the minimal git commands to the front of the path
  set "PATH=!GIT_INSTALL_ROOT!\cmd;%PATH%"
) else (
  goto :NO_GIT
)

:FOUND_GIT
:: Add git to the path
if defined GIT_INSTALL_ROOT (
  rem add the unix commands at the end to not shadow windows commands like more
  call :verbose-output Enhancing PATH with unix commands from git in "%GIT_INSTALL_ROOT%\usr\bin"
  set "PATH=%PATH%;%GIT_INSTALL_ROOT%\usr\bin;%GIT_INSTALL_ROOT%\usr\share\vim\vim74"
  :: define SVN_SSH so we can use git svn with ssh svn repositories
  if not defined SVN_SSH set "SVN_SSH=%GIT_INSTALL_ROOT:\=\\%\\bin\\ssh.exe"
)

:NO_GIT
endlocal & set "PATH=%PATH%" & set "SVN_SSH=%SVN_SSH%" & set "GIT_INSTALL_ROOT=%GIT_INSTALL_ROOT%"

:: Enhance Path
set "PATH=%SHARK_ROOT%\bin;%PATH%;%SHARK_ROOT%\"

:: Run custom startup script
call "%SHARK_ROOT%\config\profile.cmd"

:: Add aliases to the environment
call  "%SHARK_ROOT%\config\aliases.cmd"

:: See modules\git\README.portable for why we do this
:: Basically we need to execute this post-install.bat because we are
:: manually extracting the archive rather than executing the 7z sfx
if exist "%SHARK_ROOT%\modules\git\post-install.bat" (
  call :verbose-output Running Git for Windows one time Post Install....
  cd /d "%SHARK_ROOT%\modules\git\"
  "%SHARK_ROOT%\modules\git\git-bash.exe" --no-needs-console --hide --no-cd --command=post-install.bat
  cd /d %USERPROFILE%
)

:: Set home path
if not defined HOME set "HOME=%USERPROFILE%"

exit /b

::
:: sub-routines below here
::
:verbose-output
  if %verbose-output% gtr 0 echo %*
  exit /b
