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

@package      apt-cyg
@package_link https://github.com/kou1okada/apt-cyg
@description  apt-cyg is a command-line installer for Cygwin which cooperates with Cygwin Setup
              and uses the same repository. The syntax is similar to apt-get.
----------------------------------------------------------------------------------------------------*/
Section "-apt-cyg" section_apt-cyg
  ## This module is hidden from selection and automaticaly selected if the Cygwin module is selected
  SectionGetFlags ${section_cygwin} $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} execute
    ## If the Cygwin module is not selected then skip to the end
    Goto end
  execute:
    ## If the Cygwin module is selected then execute the apt-cyg module installation
    SetOutPath "$DIR_installer"
    SetOverwrite ifnewer

    ## Set variables
    StrCpy $GitHub_User "kou1okada"
    StrCpy $GitHub_Repository "apt-cyg"
    StrCpy $INSTALLER "apt-cyg.zip"
    StrCpy $NAME "cygwin"

    ## Delete previous version
    Delete $INSTALLER
    RMDir /r "$DIR_modules\$GitHub_Repository"

    ## Check if installer has already been downloaded
    IfFileExists $INSTALLER skip_download 0
      ## Download latest version
      inetc::get /NOCANCEL "$GitHub_URL/$GitHub_User/$GitHub_Repository/archive/master.zip" "$INSTALLER" /END
   skip_download:

    ## Install
    nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\" -y "$INSTALLER" "$GitHub_Repository-master*\*"'
    CopyFiles "$DIR_modules\$GitHub_Repository-master\apt-cyg" "$DIR_modules\$NAME\bin\apt-cyg"
    RMDir /r "$DIR_modules\$GitHub_Repository-master"
    nsExec::ExecToStack '"$DIR_modules\$NAME\bin\chmod.exe" +x "$DIR_modules\$NAME\bin\apt-cyg"'

    ## Cleanup installation files
    !if "${DEBUG}" == false
      Delete "$INSTALLER"
    !endif
  end:
SectionEnd

LangString desc_apt-cyg ${LANG_ENGLISH} "apt-cyg is a command-line installer for Cygwin which cooperates with Cygwin Setup and uses the same repository. The syntax is similar to apt-get."
