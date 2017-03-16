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

@package      Powerline Fonts
@package_link https://github.com/powerline/fonts
@description  Patched fonts for Powerline users.
----------------------------------------------------------------------------------------------------*/
Section "-Powerline Fonts" section_powerline-fonts
  ## This module is hidden from selection and automaticaly installed
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  ## Set variables
  StrCpy $GitHub_User "powerline"
  StrCpy $GitHub_Repository "fonts"
  StrCpy $INSTALLER "powerline-fonts.zip"
  StrCpy $NAME "powerline-fonts"

  ## Delete previous fonts
  RMDir /r "$DIR_modules\$NAME"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    inetc::get /NOCANCEL "$GitHub_URL/$GitHub_User/$GitHub_Repository/archive/master.zip" "$INSTALLER" /END
 skip_download:

  ## Install
  nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\" -y "$INSTALLER" "$GitHub_Repository-master*\*"'
  Rename "$DIR_modules\$GitHub_Repository-master" "$DIR_modules\$NAME"

  ## Execute the font installation script
  nsExec::ExecToStack "Powershell \
              -ExecutionPolicy Bypass \
              -InputFormat None \
              -File $\"$DIR_bin\Add-Font.ps1$\" -Path $\"$DIR_modules\$NAME$\" \
           "

  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_powerline-fonts ${LANG_ENGLISH} "Patched fonts for Powerline users."
