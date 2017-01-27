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

@package      Free Programming Fonts
@package_link https://github.com/sixrevisions/free-programming-fonts
@description  Beautiful fonts for people who love to code.
----------------------------------------------------------------------------------------------------*/
Section "-Free Programming Fonts" section_free-programming-fonts
  ## This module is hidden from selection and automaticaly installed
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  ## Set variables
  StrCpy $GitHub_User "sixrevisions"
  StrCpy $GitHub_Repository "free-programming-fonts"
  StrCpy $INSTALLER "free-programming-fonts.zip"
  StrCpy $NAME "free-programming-fonts"
  
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
              -InputFormat None \
              -ExecutionPolicy RemoteSigned \
              -File $\"$DIR_modules\Add-Font-Recursive.ps1$\" \
              -FontPath $\"$DIR_modules\$NAME$\" \
           "
  
  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_free-programming-fonts ${LANG_ENGLISH} "Beautiful fonts for people who love to code."
