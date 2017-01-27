/*--------------------------------------------------------------------------------------------------
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

@package      build_shark_installer
@description  This script generates a full NSIS script combining all the modules then builds it.
--------------------------------------------------------------------------------------------------*/

##--------------------------------------------------------------------------------------------------
## Define Constants
##--------------------------------------------------------------------------------------------------
## Debug mode keeps intermediate build files
!define DEBUG             false
## Compile and test only the defined module
!define MODULE            ""
## Build folder
!define BUILD_FOLDER      ".\build"
## Module folder
!define MODULE_FOLDER     "${BUILD_FOLDER}\modules"
## Full NSIS script name
!define NSI               "debug_shark_installer.nsi"
##--------------------------------------------------------------------------------------------------
## Define Output
##--------------------------------------------------------------------------------------------------
!define EXE "${BUILD_FOLDER}\build.exe"
OutFile ${EXE}
##--------------------------------------------------------------------------------------------------

Section ""
  ## Delete intermediary build files if left over
  !execute "CMD /C DEL /F /Q ${NSI}"
  
  ## Merge header.nsh
  !execute "CMD /C TYPE ${BUILD_FOLDER}\header.nsh >> ${NSI}"
  !execute "CMD /C ECHO. >> ${NSI}"

  !if "${MODULE}" == ""
    ## Loop through all the modules and concatenate them into a single NSIS script
    !execute "CMD /C FOR %F IN (${MODULE_FOLDER}\*.nsh) DO ( TYPE %~fF >> ${NSI} & ECHO. >> ${NSI} )"
  !else
    ## Concatenate the selected module into a single NSIS script
    !execute "CMD /C TYPE ${MODULE_FOLDER}\*_${MODULE}.nsh >> ${NSI}"
    !execute "CMD /C ECHO. >> ${NSI}"
  !endif
  
  !execute "CMD /C ECHO ## Section descriptions >> ${NSI}"
  !execute "CMD /C ECHO !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN >> ${NSI}"
  !if "${MODULE}" == ""
    ## Loop through all the modules and generate the description section for all the modules
    !execute 'CMD /C ${MODULE_FOLDER}\modules.cmd "${NSI}" "${MODULE_FOLDER}"'
  !else
    ## Generate the description section for the selected module
    !execute "CMD /C ECHO      ^!insertmacro MUI_DESCRIPTION_TEXT ${section_${MODULE}} $^(desc_${MODULE}^) >> ${NSI}"
  !endif
  !execute "CMD /C ECHO !insertmacro MUI_FUNCTION_DESCRIPTION_END >> ${NSI}"
  !execute "CMD /C ECHO. >> ${NSI}"

  ## Merge footer.nsh
  !execute "CMD /C TYPE ${BUILD_FOLDER}\footer.nsh >> ${NSI}"
  !execute "CMD /C ECHO. >> ${NSI}"
  
  ## Build the final installer based on the generated NSIS script  
  !makensis "${NSI}"

  ## Delete intermediary build files if not in debug mode 
  !if "${DEBUG}" == false
    !finalize "CMD /C DEL /F /Q ${NSI}"
  !endif
  
  !finalize "CMD /C DEL /F /Q ${EXE}"
SectionEnd
