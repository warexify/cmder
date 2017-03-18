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

@package      Git for Windows
@package_link https://github.com/git-for-windows/git
@description  Git for Windows is a fast, scalable, distributed revision control system with an unusually rich
              command set that provides both high-level operations and full access to internals.
----------------------------------------------------------------------------------------------------*/
Section /o "Git for Windows" section_git-for-windows
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  StrCpy $GitHub_User "git-for-windows"
  StrCpy $GitHub_Repository "git"
  ${If} ${RunningX64}
    StrCpy $GitHub_FilePattern "(.*)-64-bit.7z.exe"
  ${Else}
    StrCpy $GitHub_FilePattern "(.*)-32-bit.7z.exe"
  ${EndIf}
  StrCpy $INSTALLER "git.exe"

  ## Delete previous version
  RMDir /r "$DIR_modules\$GitHub_Repository"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    nsExec::ExecToStack '"curl.exe" -L "$GitHub_URL/$GitHub_User/$GitHub_Repository/$GitHub_Releases" -o "$GitHub_Repository" -s'
    nsExec::ExecToStack '"grep.exe" -E -m 1 -o "/$GitHub_User/$GitHub_Repository/$GitHub_Releases/download/.*/$GitHub_FilePattern" "$GitHub_Repository"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}
    ${StrRep} $2 $1 "/" "\"

    inetc::get /NOCANCEL "$GitHub_URL$1" "$INSTALLER" /END
  skip_download:

  ## Install
  nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\$GitHub_Repository" -y "$INSTALLER" "*"'
  nsExec::ExecToStack '$DIR_modules\$GitHub_Repository\post-install.bat'

  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$GitHub_Repository"
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_git-for-windows ${LANG_ENGLISH} "Git for Windows is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals."
