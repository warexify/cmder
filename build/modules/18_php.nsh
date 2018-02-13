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

@package      php
@package_link http://php.net
@description  PHP is a server-side scripting language designed for web development
              but also used as a general-purpose programming language.
----------------------------------------------------------------------------------------------------*/
Section "PHP" section_php
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  StrCpy $INSTALLER "php.zip"
  StrCpy $NAME "php"

  ## Delete previous version
  Delete $INSTALLER
  RMDir /r "$DIR_modules\$NAME"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download the checksum list for PHP
    inetc::get /NOCANCEL "http://windows.php.net/downloads/releases/sha1sum.txt" "php_sha1sum" /END

    ## Extract the PHP versions available
    nsExec::ExecToStack '"grep.exe" -E -o "php-[0-9]{1,2}.[0-9]{1,2}.[0-9]{1,2}-Win32-VC[0-9]{2}-x86.zip" "php_sha1sum"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}

    ## Write the PHP versions available in a file
    FileOpen $9 php_version w ;Opens a Empty File an fills it
    FileWrite $9 $1
    FileClose $9 ;Closes the filled file

    ## Grab the latest PHP version
    nsExec::ExecToStack '"tail.exe" -1 "php_version"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}

    ## Download the latest version of PHP
    inetc::get /NOCANCEL "http://windows.php.net/downloads/releases/$1" "php.zip" /END
  skip_download:

  ## Install
  nsExec::ExecToStack '7za.exe e -aoa -o"$DIR_modules\php" -y "$INSTALLER" "*"'

  ## Cleanup installation files
  Delete "$DIR_installer\php_sha1sum"
  Delete "$DIR_installer\php_version"
  Delete "$DIR_installer\$INSTALLER"
  Delete "$DIR_installer\$NAME"
SectionEnd

LangString desc_php ${LANG_ENGLISH} "PHP is a server-side scripting language designed for web development but also used as a general-purpose programming language."
