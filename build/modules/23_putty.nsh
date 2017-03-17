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

@package      putty
@package_link https://puttytray.goeswhere.com/
              http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html
              http://kitty.9bis.net/
              http://www.9bis.net/kitty/?page=Download
@description  PuTTY is a free implementation of Telnet and SSH for Win32 and Unix platforms,
              along with an xterm terminal emulator.
              The actual PuTTY.exe is being replaced by KiTTY which is a fork from version 0.67.
              KiTTY has all the features from the original PuTTY, and adds many others.
----------------------------------------------------------------------------------------------------*/
Section /o "PuTTY" section_putty
  StrCpy $NAME "putty"
  StrCpy $SHORTCUT "PuTTY"

  SetOutPath "$DIR_modules\$NAME\"
  SetOverwrite ifnewer

  ## Delete previous version
  Delete "kitty.exe"
  Delete "putty.exe"
  Delete "pscp.exe"
  Delete "psftp.exe"
  Delete "plink.exe"
  Delete "pageant.exe"
  Delete "puttygen.exe"

  ## Download latest version
    ## Copy kitty_portable.exe from bin folder as putty.exe (until a direct link is found to download it)
    CopyFiles /SILENT "$DIR_installer\kitty_portable.exe" "putty.exe"
    ## Disable download from the original PuTTY
    #inetc::get /NOCANCEL "http://puttytray.goeswhere.com/download/putty.exe"         "putty.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe"      "pscp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/psftp.exe"     "psftp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe"     "plink.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pageant.exe"   "pageant.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe"  "puttygen.exe" /END

  ## Create symbolic links to the config files of KiTTY
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Commands"           "$DIR_config\$NAME\Commands"          $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Folders"            "$DIR_config\$NAME\Folders"           $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Jumplist"           "$DIR_config\$NAME\Jumplist"          $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Launcher"           "$DIR_config\$NAME\Launcher"          $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Sessions"           "$DIR_config\$NAME\Sessions"          $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\Sessions_Commands"  "$DIR_config\$NAME\Sessions_Commands" $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\SshHostKeys"        "$DIR_config\$NAME\SshHostKeys"       $0
  ${CreateSymbolicLinkFile}   "$DIR_modules\$NAME\kitty.ini"          "$DIR_config\$NAME\kitty.ini"         $0

  ## Import existing settings from PuTTY that might be in the registry
  ExecWait "$DIR_modules\$NAME\putty.exe -convert-dir"

  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\PuTTY.lnk"                "$DIR_modules\$NAME\putty.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\PuTTY Launcher.lnk"       "$DIR_modules\$NAME\putty.exe -launcher"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\PSCP.lnk"                 "$DIR_modules\$NAME\pscp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\PSFTP.lnk"                "$DIR_modules\$NAME\psftp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\Plink.lnk"                "$DIR_modules\$NAME\plink.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\Pageant.lnk"              "$DIR_modules\$NAME\pageant.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT\PuTTY Key Generator.lnk"  "$DIR_modules\$NAME\puttygen.exe"

  ## Remove PuTTY provided by Gow if ${section_gow} is selected
  SectionGetFlags ${section_gow} $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} execute
    ## We keep PuTTY provided by Gow
    Goto end
  execute:
    ## We delete PuTTY provided by Gow
    Delete "$DIR_modules\gow\puttygen.exe"
    Delete "$DIR_modules\gow\pageant.exe"
    Delete "$DIR_modules\gow\plink.exe"
    Delete "$DIR_modules\gow\pscp.exe"
    Delete "$DIR_modules\gow\psftp.exe"
    Delete "$DIR_modules\gow\putty.exe"
  end:
SectionEnd

LangString desc_putty ${LANG_ENGLISH} "PuTTY is a free implementation of Telnet and SSH for Win32 and Unix platforms, along with an xterm terminal emulator."
