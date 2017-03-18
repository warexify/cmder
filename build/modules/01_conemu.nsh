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

@package      ConEmu
@package_link https://github.com/Maximus5/ConEmu/
@description  ConEmu is a Windows console emulator with tabs, which presents multiple consoles and
              simple GUI applications as one customizable GUI window with various features.
----------------------------------------------------------------------------------------------------*/
Section "ConEmu" section_conemu
  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  StrCpy $GitHub_User "Maximus5"
  StrCpy $GitHub_Repository "ConEmu"
  StrCpy $GitHub_FilePattern "(.*).7z"
  StrCpy $INSTALLER "conemu.7z"
  StrCpy $NAME "conemu"
  StrCpy $SHORTCUT "ConEmu"

  ## Delete previous version
  RMDir /r "$DIR_modules\$NAME"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    nsExec::ExecToStack '"curl.exe" -L "$GitHub_URL/$GitHub_User/$GitHub_Repository/$GitHub_Releases" -o "$NAME" -s'
    nsExec::ExecToStack '"grep.exe" -E -m 1 -o "/$GitHub_User/$GitHub_Repository/$GitHub_Releases/download/$GitHub_FilePattern" "$NAME"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}
    inetc::get /NOCANCEL "$GitHub_URL$1" "$INSTALLER" /END
  skip_download:

  ## Install
  nsExec::ExecToStack '7z.exe x -aoa -o"$DIR_modules\$NAME" -y "$INSTALLER"'
  ${CreateSymbolicLinkFile} "$DIR_modules\$NAME\conemu.xml" "$DIR_config\conemu.xml" $0
  ## Register ConEmu as the default console manager
  ExecWait 'ConEmu.exe /NoUpdate /LoadCfgFile "$DIR_config\conemu.xml" /Icon "$DIR_icons\shark.ico" /SetDefTerm /UpdateJumpList /Exit'

  ## Copy Shark icon in CenEmu folder to use as default icon
  SetOverwrite on
  CopyFiles /silent "$DIR_icons\shark.ico" "$DIR_modules\$NAME\conemu.ico"
  SetOverwrite ifnewer

  ## Create shortcuts
  ${If} ${RunningX64}
    StrCpy $2 "ConEmu64.exe"
  ${Else}
    StrCpy $2 "ConEmu.exe"
  ${EndIf}

  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\CMD (Admin).lnk"                "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{CMD (Admin)}$\""                 "$DIR_icons\shark_cyan_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PowerShell (Admin).lnk"         "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{PowerShell (Admin)}$\""          "$DIR_icons\shark_blue_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Cygwin (Admin).lnk"             "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{Cygwin (Admin)}$\""              "$DIR_icons\shark_green_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\Git Bash (Admin).lnk"           "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{Git Bash (Admin)}$\""            "$DIR_icons\shark_magenta_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\PuTTY.lnk"                      "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{PuTTY}$\""                       "$DIR_icons\shark_yellow.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\CMD.lnk"                   "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::CMD}$\""                   "$DIR_icons\shark_cyan.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\PowerShell.lnk"            "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::PowerShell}$\""            "$DIR_icons\shark_blue.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\Cygwin.lnk"                "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::Cygwin}$\""                "$DIR_icons\shark_green.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\Git Bash.lnk"              "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::Git Bash}$\""              "$DIR_icons\shark_magenta.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\CMD 32 bit.lnk"            "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::CMD 32 bit}$\""            "$DIR_icons\shark_cyan.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\CMD 32 bit (Admin).lnk"    "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::CMD 32 bit (Admin)}$\""    "$DIR_icons\shark_cyan_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\CMD 32/64 bit.lnk"         "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::CMD 32/64 bit}$\""         "$DIR_icons\shark_cyan.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\CMD 32/64 bit (Admin).lnk" "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::CMD 32/64 bit (Admin)}$\"" "$DIR_icons\shark_cyan_bold.ico"
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\More\Show ANSI colors.lnk"      "$DIR_modules\$NAME\$2" "-title ${PRODUCT_NAME} -run $\"{More::Show ANSI colors}$\""      "$DIR_icons\shark_white.ico"

  ## Cleanup installation files
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
    Delete "$NAME"
  !endif
SectionEnd

LangString desc_conemu ${LANG_ENGLISH} "ConEmu is a Windows console emulator with tabs, which presents multiple consoles and simple GUI applications as one customizable GUI window with various features."
