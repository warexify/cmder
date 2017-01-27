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

@package      msys2
@package_link https://msys2.github.io/
@description  MSYS2 is an independent rewrite of MSYS, based on modern Cygwin
              (POSIX compatibility layer) and MinGW-w64 with the aim of better interoperability
              with native Windows software.
----------------------------------------------------------------------------------------------------*/
Section /o "MSYS2" section_msys2
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer
  
  ${If} ${RunningX64}
    StrCpy $0 "msys2-x86_64"
  ${Else}
    StrCpy $0 "msys2-i686"
  ${EndIf}  
 
  StrCpy $INSTALLER "$0.tar.xz"
  StrCpy $NAME "msys2"
  StrCpy $SHORTCUT "MSYS2"

  ## Delete previous version
  RMDir /r "$DIR_modules\$NAME"

  ## Check if installer has already been downloaded 
  IfFileExists $INSTALLER skip_download 0   
    ## Download latest version
    inetc::get /NOCANCEL "http://repo.msys2.org/distrib/$0-latest.tar.xz" "$INSTALLER" /END
  skip_download:
  
  ## Install
  nsExec::ExecToStack '7z.exe x -y "$INSTALLER"'
  nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules" -ttar -y "$0.tar"'
  ${If} ${RunningX64}
    Rename "$DIR_modules\msys64" "$DIR_modules\msys2"
  ${Else}
    Rename "$DIR_modules\msys32" "$DIR_modules\msys2"
  ${EndIf}

  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$0.tar"
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_msys2 ${LANG_ENGLISH} "MSYS2 is an independent rewrite of MSYS, based on modern Cygwin (POSIX compatibility layer) and MinGW-w64 with the aim of better interoperability with native Windows software."
