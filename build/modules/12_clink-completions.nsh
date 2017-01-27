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

@package      Clink-Completions
@package_link https://github.com/vladimir-kotikov/clink-completions/
@description  Completion files for Clink.
----------------------------------------------------------------------------------------------------*/
Section "-Clink-Completions" section_clink-completions
  ## This module is hidden from selection and automaticaly selected if the Clink module is selected
  SectionGetFlags ${section_clink} $0 
  IntOp $0 $0 & ${SF_SELECTED} 
  IntCmp $0 ${SF_SELECTED} execute
    ## If the Clink module is not selected then skip to the end
    Goto end
  execute:
    ## If the Clink module is selected then execute the clink-completions module installation
    SetOutPath "$DIR_installer"
    SetOverwrite ifnewer

    ## Set variables
    StrCpy $GitHub_User "vladimir-kotikov"
    StrCpy $GitHub_Repository "clink-completions"
    StrCpy $INSTALLER "clink-completions.zip"
    
    ## Delete previous version
    RMDir /r "$DIR_modules\$GitHub_Repository"

    ## Check if installer has already been downloaded 
    IfFileExists $INSTALLER skip_download 0
      ## Download latest version
      inetc::get /NOCANCEL "$GitHub_URL/$GitHub_User/$GitHub_Repository/archive/master.zip" "$INSTALLER" /END
   skip_download:
   
    ## Install
    nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\" -y "$INSTALLER" "$GitHub_Repository-master*\*"'
    Rename "$DIR_modules\$GitHub_Repository-master" "$DIR_modules\$Github_Repository"
    
    ## Cleanup installation files
    !if "${DEBUG}" == false
      Delete "$INSTALLER"
    !endif
  end:
SectionEnd

LangString desc_clink-completions ${LANG_ENGLISH} "Completion files for Clink."
