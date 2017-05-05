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

  ## Create an uninstaller and a shortcut to it.
  SetShellVarContext all
  CreateShortCut    "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninstall.exe"

  ## Add to "Add/Remove Programs" or "Programs and Features"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "DisplayIcon"     "$DIR_icons\shark.ico"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "DisplayName"     "${PRODUCT_NAME}"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "InstallDir"      "$INSTDIR"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "Publisher"       "Kenijo"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr "${ROOT_KEY}" "${UNINST_KEY}" "URLInfoAbout"    "http://kenijo.github.io/shark/"

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD "${ROOT_KEY}" "${UNINST_KEY}" "EstimatedSize" "$0"

  WriteUninstaller  "$INSTDIR\uninstall.exe"

  ## Execute the Context Menu Manager
  Exec "$DIR_installer\shark_context_menu_manager.exe"
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
FunctionEnd

##--------------------------------------------------------------------------------------------------
## This section creates the uninstaller
##--------------------------------------------------------------------------------------------------
Section Uninstall
  SetShellVarContext all

	## Stop Cygserver service
	nsExec::ExecToStack "$DIR_modules\$NAME\cygrunsrv.exe --stop cygserver" 
	## Remove Cygserver service
	nsExec::ExecToStack "$DIR_modules\$NAME\cygrunsrv.exe --remove cygserver" 
	
  ## Remove install folder
  RMDir /r /REBOOTOK "$INSTDIR"

  ## Remove Start Menu folder
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  ## Delete registry keys
  DeleteRegKey "${ROOT_KEY}" "${UNINST_KEY}"

  ## Clear all Context Menu
  StrCpy $0 "shark_conemu_cmd_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_powershell_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_cygwin_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_git_bash_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_cmd"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_powershell"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_cygwin"
  Call un.del_context_menu
  StrCpy $0 "shark_conemu_git_bash"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_cmd_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_powershell_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_cygwin_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_git_bash_admin"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_cmd"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_powershell"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_cygwin"
  Call un.del_context_menu
  StrCpy $0 "shark_consolez_git_bash"
  Call un.del_context_menu

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

Function un.del_context_menu
  ## Del Context Menu Variables
  ## $0 Context Menu Registry Key

  ## HKCR 32 bits
  DeleteRegKey HKCR "*\shell\$0"
  DeleteRegKey HKCR "Directory\Background\shell\$0"
  DeleteRegKey HKCR "Directory\shell\$0"
  DeleteRegKey HKCR "Drive\shell\$0"
  DeleteRegKey HKCR "LibraryFolder\Background\shell\$0"

  ## HKCR 64 bits
  DeleteRegKey HKCR "Wow6432Node\*\shell\$0"
  DeleteRegKey HKCR "Wow6432Node\Directory\Background\shell\$0"
  DeleteRegKey HKCR "Wow6432Node\Directory\shell\$0"
  DeleteRegKey HKCR "Wow6432Node\Drive\shell\$0"
  DeleteRegKey HKCR "Wow6432Node\LibraryFolder\Background\shell\$0"

  ## HKCU 32 bits
  DeleteRegKey HKCU "*\shell\$0"
  DeleteRegKey HKCU "Directory\Background\shell\$0"
  DeleteRegKey HKCU "Directory\shell\$0"
  DeleteRegKey HKCU "Drive\shell\$0"
  DeleteRegKey HKCU "LibraryFolder\Background\shell\$0"

  ## HKCU 64 bits
  DeleteRegKey HKCU "Wow6432Node\*\shell\$0"
  DeleteRegKey HKCU "Wow6432Node\Directory\Background\shell\$0"
  DeleteRegKey HKCU "Wow6432Node\Directory\shell\$0"
  DeleteRegKey HKCU "Wow6432Node\Drive\shell\$0"
  DeleteRegKey HKCU "Wow6432Node\LibraryFolder\Background\shell\$0"
FunctionEnd
