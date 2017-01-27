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

@package      ConsoleZ
@package_link https://github.com/cbucher/console
@description  This is a modified version of Console 2 for a better experience under
              Windows Vista/7/8/10 and a better visual rendering.
----------------------------------------------------------------------------------------------------*/
Section /o "ConsoleZ" section_consolez
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  StrCpy $GitHub_User "cbucher"
  StrCpy $GitHub_Repository "console"
  StrCpy $GitHub_FilePattern "(.*)x86(.*).zip"
  StrCpy $INSTALLER "consolez.zip"
  StrCpy $NAME "consolez"
  StrCpy $SHORTCUT "ConsoleZ"
  
  ## Delete previous version
  RMDir /r "$DIR_modules\$NAME"

  ## Check if installer has already been downloaded 
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    nsExec::ExecToStack '"curl.exe" -L "$GitHub_URL/$GitHub_User/$GitHub_Repository/$GitHub_Releases" -o "$NAME" -s'
    nsExec::ExecToStack '"grep.exe" -E -m 1 -o "/$GitHub_User/$GitHub_Repository/$GitHub_Releases/download/$GitHub_FilePattern" "$NAME"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}
    ${StrRep} $2 $1 "/" "\"
    inetc::get /NOCANCEL "$GitHub_URL$1" "$INSTALLER" /END
  skip_download:
    
  ## Install
  nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\$NAME" -y "$INSTALLER" "*"'
  ${CreateSymbolicLinkFile} "$DIR_modules\$NAME\console.xml" "$DIR_config\console.xml" $0
  
  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT.lnk" "$DIR_modules\$NAME\Console.exe"

  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
    Delete "$NAME"
  !endif
SectionEnd

LangString desc_consolez ${LANG_ENGLISH} "This is a modified version of Console 2 for a better experience under Windows Vista/7/8/10 and a better visual rendering."
