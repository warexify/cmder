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

@package      kitty
@package_link http://kitty.9bis.net/
              http://www.9bis.net/kitty/?page=Download
@description  KiTTY is a fork from version 0.67 of PuTTY, the best telnet / SSH client in the world.
              KiTTY has all the features from the original software, and adds many others.
----------------------------------------------------------------------------------------------------*/
Section "KiTTY" section_kitty
  SetOutPath "$DIR_modules\kitty\"
  SetOverwrite ifnewer

  ## Delete previous version
  Delete "putty.exe"
  Delete "kitty.exe"
  Delete "pscp.exe"
  Delete "psftp.exe"
  Delete "plink.exe"
  Delete "pageant.exe"
  Delete "puttygen.exe"

  ## Download latest version
    ## Copy kitty_portable.exe from bin folder (until a direct link is found to download it
    CopyFiles /SILENT "$DIR_installer\kitty_portable.exe" "kitty.exe"
    #inetc::get /NOCANCEL "https://www.fosshub.com/KiTTY.html/kitty_portable.exe" "kitty.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe" "pscp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/psftp.exe" "psftp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe" "plink.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pageant.exe" "pageant.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe" "puttygen.exe" /END

  ## Create a symbolic link to use KiTTY when typing PuTTY
  ${CreateSymbolicLinkFile} "$DIR_modules\kitty\putty.exe" "$DIR_modules\kitty\kitty.exe" $0
  
  ## Create symbolic links to the config files of KiTTY
  ${CreateSymbolicLinkFolder} "$DIR_modules\kitty\Jumplist" "$DIR_config\kitty\Jumplist" $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\kitty\Sessions" "$DIR_config\kitty\Sessions" $0
  ${CreateSymbolicLinkFolder} "$DIR_modules\kitty\SshHostKeys" "$DIR_config\kitty\SshHostKeys" $0
  ${CreateSymbolicLinkFile} "$DIR_modules\kitty\kitty.ini" "$DIR_config\kitty\kitty.ini" $0  

  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\KiTTY.lnk"                "$DIR_modules\kitty\kitty.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PSCP.lnk"                 "$DIR_modules\kitty\pscp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PSFTP.lnk"                "$DIR_modules\kitty\psftp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Plink.lnk"                "$DIR_modules\kitty\plink.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Pageant.lnk"              "$DIR_modules\kitty\pageant.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PuTTY Key Generator.lnk"  "$DIR_modules\kitty\puttygen.exe"
  
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

LangString desc_kitty ${LANG_ENGLISH} "KiTTY is a fork from version 0.67 of PuTTY, the best telnet / SSH client in the world."
