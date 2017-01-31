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
@description  PuTTY is a free implementation of Telnet and SSH for Win32 and Unix platforms,
              along with an xterm terminal emulator.
----------------------------------------------------------------------------------------------------*/
Section /o "PuTTY" section_putty
  SetOutPath "$DIR_modules\putty\"
  SetOverwrite ifnewer

  ## Delete previous version
  Delete "putty.exe"
  Delete "pscp.exe"
  Delete "psftp.exe"
  Delete "plink.exe"
  Delete "pageant.exe"
  Delete "puttygen.exe"

  ## Download latest version
  inetc::get /NOCANCEL "http://puttytray.goeswhere.com/download/putty.exe" "putty.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe" "pscp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/psftp.exe" "psftp.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/plink.exe" "plink.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/pageant.exe" "pageant.exe" /END
  inetc::get /NOCANCEL "http://the.earth.li/~sgtatham/putty/latest/x86/puttygen.exe" "puttygen.exe" /END
  
  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PuTTY.lnk"                "$DIR_modules\putty\putty.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PSCP.lnk"                 "$DIR_modules\putty\pscp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PSFTP.lnk"                "$DIR_modules\putty\psftp.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Plink.lnk"                "$DIR_modules\putty\plink.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Pageant.lnk"              "$DIR_modules\putty\pageant.exe"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PuTTY Key Generator.lnk"  "$DIR_modules\putty\puttygen.exe"
  
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
