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

@package      Gow
@package_link https://github.com/bmatzelle/gow/
@description  Gow (Gnu On Windows) is the lightweight alternative to Cygwin.
              It installs over 100 extremely useful open source UNIX applications compiled as
              native win32 binaries. It is designed to be as small as possible, about 18 MB,
              as opposed to Cygwin which can run well over 100 MB depending upon options.
----------------------------------------------------------------------------------------------------*/
Section /o "Gow" section_gow
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  ## Set variables
  StrCpy $GitHub_User "bmatzelle"
  StrCpy $GitHub_Repository "gow"
  StrCpy $INSTALLER "gow.zip"

  ## Delete previous version
  Delete $INSTALLER
  RMDir /r "$DIR_modules\$GitHub_Repository"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    inetc::get /NOCANCEL "$Github_URL/$GitHub_User/$GitHub_Repository/archive/master.zip" "$GitHub_Repository.zip" /END
  skip_download:

  ## Install
  nsExec::ExecToStack '7za.exe e -aoa -o"$DIR_modules\$GitHub_Repository" -y "$INSTALLER" "gow-master\bin\*"'

  ## Cleanup installation files
  Delete "$DIR_installer\$INSTALLER"
SectionEnd

LangString desc_gow ${LANG_ENGLISH} "Gow (Gnu On Windows) is the lightweight alternative to Cygwin. It installs over 100 extremely useful open source UNIX applications compiled as native win32 binaries. It is designed to be as small as possible, about 18 MB, as opposed to Cygwin which can run well over 100 MB depending upon options."
