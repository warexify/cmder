/*--------------------------------------------------------------------------------------------------
shark
The shell environment of your dreams

Shark is a package installer that will allow you to create a fully customized shell environment
through a single simple installer. It takes the hard work out of downloading and configuring all
the components you need. Shark simplifies the installation by asking simple questions and taking
care of downloading and installing everything for you from trusted sources (official repositories).
It has a modular architecture that allows anyone to add and improve the installer easilly.

@author       Kenrick JORUS
@copyright    2016 Kenrick JORUS
@license      MIT License
@link         http://kenijo.github.io/shark/

@package      Context Menu Manager
@description  This script creates a utility to manage the context menu
--------------------------------------------------------------------------------------------------*/

##--------------------------------------------------------------------------------------------------
## Context Menu for ConsoleZ
##--------------------------------------------------------------------------------------------------
!define consolez_cmd_admin          "'CMD (Admin) in ConsoleZ'"
!define consolez_powershell_admin   "'PowerShell (Admin) in ConsoleZ'"
!define consolez_cygwin_admin       "'Cygwin (Admin) in ConsoleZ'"
!define consolez_git_bash_admin     "'Git Bash (Admin) in ConsoleZ'"
!define consolez_cmd                "'CMD in ConsoleZ'"
!define consolez_powershell         "'PowerShell in ConsoleZ'"
!define consolez_cygwin             "'Cygwin in ConsoleZ'"
!define consolez_git_bash           "'Git Bash in ConsoleZ'"

Section "!-- ConsoleZ Context Menu --"
  SectionIn RO

  ## Clear all Context Menu before re-adding them
  StrCpy $0 "shark_consolez_cmd_admin"
  Call del_context_menu
  StrCpy $0 "shark_consolez_powershell_admin"
  Call del_context_menu
  StrCpy $0 "shark_consolez_cygwin_admin"
  Call del_context_menu
  StrCpy $0 "shark_consolez_git_bash_admin"
  Call del_context_menu
  StrCpy $0 "shark_consolez_cmd"
  Call del_context_menu
  StrCpy $0 "shark_consolez_powershell"
  Call del_context_menu
  StrCpy $0 "shark_consolez_cygwin"
  Call del_context_menu
  StrCpy $0 "shark_consolez_git_bash"
  Call del_context_menu

  StrCpy $CMM_EXE "$INSTDIR\modules\consolez\ConsoleZ.exe"
SectionEnd

Section "CMD (Admin)" shark_consolez_cmd_admin
  StrCpy $0 ${consolez_cmd_admin}
  StrCpy $1 "$INSTDIR\icons\shark_cyan_bold.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{CMD (Admin)}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{CMD (Admin)}"'
  StrCpy $4 "shark_consolez_cmd_admin"
  Call set_context_menu
SectionEnd

Section "PowerShell (Admin)" shark_consolez_powershell_admin
  StrCpy $0 ${consolez_powershell_admin}
  StrCpy $1 "$INSTDIR\icons\shark_blue_bold.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{PowerShell (Admin)}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{PowerShell (Admin)}"'
  StrCpy $4 "shark_consolez_powershell_admin"
  Call set_context_menu
SectionEnd

Section "Cygwin (Admin)" shark_consolez_cygwin_admin
  StrCpy $0 ${consolez_cygwin_admin}
  StrCpy $1 "$INSTDIR\icons\shark_green_bold.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{Cygwin (Admin)}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{Cygwin (Admin)}"'
  StrCpy $4 "shark_consolez_cygwin_admin"
  Call set_context_menu
SectionEnd

Section "Git Bash (Admin)" shark_consolez_git_bash_admin
  StrCpy $0 ${consolez_git_bash_admin}
  StrCpy $1 "$INSTDIR\icons\shark_magenta_bold.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{Git Bash (Admin)}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{Git Bash (Admin)}"'
  StrCpy $4 "shark_consolez_git_bash_admin"
  Call set_context_menu
SectionEnd

Section "CMD" shark_consolez_cmd
  StrCpy $0 ${consolez_cmd}
  StrCpy $1 "$INSTDIR\icons\shark_cyan.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{More::CMD}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{More::CMD}"'
  StrCpy $4 "shark_consolez_cmd"
  Call set_context_menu
SectionEnd

Section "PowerShell" shark_consolez_powershell
  StrCpy $0 ${consolez_powershell}
  StrCpy $1 "$INSTDIR\icons\shark_blue.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{More::PowerShell}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{More::PowerShell}"'
  StrCpy $4 "shark_consolez_powershell"
  Call set_context_menu
SectionEnd

Section "Cygwin" shark_consolez_cygwin
  StrCpy $0 ${consolez_cygwin}
  StrCpy $1 "$INSTDIR\icons\shark_green.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{More::Cygwin}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{More::Cygwin}"'
  StrCpy $4 "shark_consolez_cygwin"
  Call set_context_menu
SectionEnd

Section "Git Bash" shark_consolez_git_bash
  StrCpy $0 ${consolez_git_bash}
  StrCpy $1 "$INSTDIR\icons\shark_cmagenta.ico"
  StrCpy $2 '"$CMM_EXE" -title "${PRODUCT_NAME}" -dir "%1" -run "{More::Git Bash}"'
  StrCpy $3 '"$CMM_EXE" -title "${PRODUCT_NAME}" -here -run "{More::Git Bash}"'
  StrCpy $4 "shark_consolez_git_bash"
  Call set_context_menu
SectionEnd

Function check_context_menu_consolez
  StrCpy $1 "shark_consolez_cmd_admin"
  StrCpy $2 ${shark_consolez_cmd_admin}
  Call check_context_menu

  StrCpy $1 "shark_consolez_powershell_admin"
  StrCpy $2 ${shark_consolez_powershell_admin}
  Call check_context_menu

  StrCpy $1 "shark_consolez_cygwin_admin"
  StrCpy $2 ${shark_consolez_cygwin_admin}
  Call check_context_menu

  StrCpy $1 "shark_consolez_git_bash_admin"
  StrCpy $2 ${shark_consolez_git_bash_admin}
  Call check_context_menu

  StrCpy $1 "shark_consolez_cmd"
  StrCpy $2 ${shark_consolez_cmd}
  Call check_context_menu

  StrCpy $1 "shark_consolez_powershell"
  StrCpy $2 ${shark_consolez_powershell}
  Call check_context_menu

  StrCpy $1 "shark_consolez_cygwin"
  StrCpy $2 ${shark_consolez_cygwin}
  Call check_context_menu

  StrCpy $1 "shark_consolez_git_bash"
  StrCpy $2 ${shark_consolez_git_bash}
  Call check_context_menu
FunctionEnd
