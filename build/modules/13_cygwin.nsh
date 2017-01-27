/*----------------------------------------------------------------------------------------------------
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

@package      Cygwin
@package_link https://www.cygwin.com/
@description  Cygwin is a large collection of GNU and Open Source tools which provide functionality
              similar to a Linux distribution on Windows.
----------------------------------------------------------------------------------------------------*/
Section "Cygwin" section_cygwin 
  SetOutPath "$DIR_config"
  SetOverwrite ifnewer
  
  ${If} ${RunningX64}
    StrCpy $0 "x86_64"
  ${Else}
    StrCpy $0 "x86"
  ${EndIf}  
  
  ## Install config files
  File /r "config\cygwin.packages"
   
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer
 
  StrCpy $INSTALLER "cygwin-$0.exe"
  StrCpy $NAME "cygwin"
  StrCpy $SHORTCUT "Cygwin"

  ## Delete previous version
  RMDir /r "$DIR_modules\$NAME"
  
  ## Check if installer has already been downloaded 
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    inetc::get /NOCANCEL "https://cygwin.com/setup-$0.exe" "$INSTALLER" /END
  skip_download:
  
  ## Install
  nsExec::ExecToStack 'cygwin.cmd "$INSTALLER" "$0" "$DIR_modules\$NAME" "$DIR_installer\cygwin-packages"'

  SetOutPath "$DIR_modules\$NAME"
  File /r "config\cygwin\*"
  System::Call "advapi32GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
  SetOutPath "$DIR_modules\$NAME\home\$0"
  File /r "config\cygwin\home\profile\*"

  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT Terminal.lnk" "$DIR_modules\$NAME\bin\mintty.exe" "-i '$DIR_icons\bash.ico' -" "'$DIR_icons\bash.ico'"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT Packages.lnk" "$DIR_installer\Cygwin-x86_64.exe" "" "$INSTDIR\$INSTALLER"

/*
  ## Right click for Cygwin Bash
  WriteRegStr HKCR "*\shell\Open Cygwin Bash Here" "Icon" "$INSTDIR\icons\bash.ico"
  WriteRegStr HKCR "*\shell\Open Cygwin Bash Here\command" "" '$DIR_modules\$GithubRepository\ConEmu.exe /cmd {cygwin bash}'

  WriteRegStr HKCR "Directory\Background\shell\Open Cygwin Bash Here" "Icon" "$INSTDIR\icons\bash.ico"
  WriteRegStr HKCR "Directory\Background\shell\Open Cygwin Bash Here\command" "" '$DIR_modules\$GithubRepository\ConEmu.exe /cmd {cygwin bash}'

  WriteRegStr HKCR "Directory\shell\Open Cygwin Bash Here" "Icon" "$INSTDIR\icons\bash.ico"
  WriteRegStr HKCR "Directory\shell\Open Cygwin Bash Here\command" "" '$DIR_modules\$GithubRepository\ConEmu.exe /cmd {cygwin bash}'

  WriteRegStr HKCR "Drive\shell\Open Cygwin Bash Here" "Icon" "$INSTDIR\icons\bash.ico"
  WriteRegStr HKCR "Drive\shell\Open Cygwin Bash Here\command" "" '$DIR_modules\$GithubRepository\ConEmu.exe /cmd {cygwin bash}'

  WriteRegStr HKCR "LibraryFolder\Background\shell\Open Cygwin Bash Here" "Icon" "$INSTDIR\icons\bash.ico"
  WriteRegStr HKCR "LibraryFolder\Background\shell\Open Cygwin Bash Here\command" "" '$DIR_modules\$GithubRepository\ConEmu.exe /cmd {cygwin bash}'
*/
 
  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_cygwin ${LANG_ENGLISH} "Cygwin is a large collection of GNU and Open Source tools which provide functionality similar to a Linux distribution on Windows."
