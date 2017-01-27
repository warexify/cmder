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

@package      footer
@description  This is the end part of the shark installer
--------------------------------------------------------------------------------------------------*/
##--------------------------------------------------------------------------------------------------
## This is a post process section (this section is mandatory and hidden from the user)
##--------------------------------------------------------------------------------------------------
Section "-post_section"
  SetOverwrite  off
  SetOutPath    "$DIR_config"
  File /r "config\*"
  
  ## Create an uninstaller and a shortcut to it.
  SetShellVarContext all
	CreateDirectory   "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut    "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninstall.exe"

  ## Add to "Add/Remove Programs" or "Programs and Features"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "DisplayIcon"     "$DIR_icons\shark.ico"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "DisplayName"     "${PRODUCT_NAME}"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "InstallDir"      "$INSTDIR"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "Publisher"       "Kenijo"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "URLInfoAbout"    "http://kenijo.github.io/shark/"
  
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD "${ROOT_KEY}" "${UNINST_KEY}" "EstimatedSize" "$0"
  
  WriteUninstaller  "$INSTDIR\uninstall.exe"
SectionEnd

Function .onInit
  ## Don't override if define through parameter or $InstallDirRegKey
  ${If} $INSTDIR == "\${PRODUCT_NAME}"
    ${If} ${RunningX64}
      ## 64 bit code
      StrCpy $INSTDIR "$ProgramFiles64\${PRODUCT_NAME}"
    ${Else}
      ## 32 bit code  
      StrCpy $INSTDIR "$ProgramFiles32\${PRODUCT_NAME}"
    ${EndIf}
  ${EndIf}
  
  ## This cope is used to define option selection instead of checkboxes
  ## StrCpy $1 ${section_cygwin} ## Cygwin is selected by default
FunctionEnd

## This cope is used to define option selection instead of checkboxes
##Function .onSelChange
##    !insertmacro StartRadioButtons $1
##    !insertmacro RadioButton ${section_cygwin}
##    !insertmacro RadioButton ${section_git}
##    !insertmacro RadioButton ${section_gow}
##    !insertmacro RadioButton ${section_msys2}
##  !insertmacro EndRadioButtons
##FunctionEnd

##--------------------------------------------------------------------------------------------------
## This section creates the uninstaller
##--------------------------------------------------------------------------------------------------
Section Uninstall
  SetShellVarContext all

  RMDir /r /REBOOTOK "$DIR_installer"

  RMDir   "$SMPROGRAMS\${PRODUCT_NAME}"

  DeleteRegKey "${ROOT_KEY}" "${UNINST_KEY}"

  DeleteRegKey HKCR "*\shell\Open ${PRODUCT_NAME} Here"
  DeleteRegKey HKCR "Directory\Background\shell\Open ${PRODUCT_NAME} Here"
  DeleteRegKey HKCR "Directory\shell\Open ${PRODUCT_NAME} Here"
  DeleteRegKey HKCR "Drive\shell\Open ${PRODUCT_NAME} Here"
  DeleteRegKey HKCR "LibraryFolder\Background\shell\Open ${PRODUCT_NAME} Here"

  DeleteRegKey HKCU "Console\ConEmu"
  DeleteRegKey HKCU "Software\ConEmu"

  DeleteRegKey HKCR "Folder\shell\Command Prompt Here Gow"

  SetAutoClose true
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove ${PRODUCT_NAME} and all of its components?" IDYES +2
  Abort
FunctionEnd
