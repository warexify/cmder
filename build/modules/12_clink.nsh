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

@package      Clink
@package_link https://github.com/mridgers/clink/
@description  Clink combines the native Windows shell cmd.exe with the powerful command line editing
              features of the GNU Readline library, which provides rich completion, history,
              and line-editing capabilities.
----------------------------------------------------------------------------------------------------*/
Section "Clink" section_clink
  SetOutPath    "$DIR_installer"
  SetOverwrite  ifnewer

  StrCpy $GitHub_User         "mridgers"
  StrCpy $GitHub_Repository   "clink"
  StrCpy $GitHub_FilePattern  "(.*)_(.*).zip"
  StrCpy $INSTALLER           "clink.zip"

  ## Delete previous version
  Delete $INSTALLER
  RMDir /r "$DIR_modules\$GitHub_Repository"

  ## Check if installer has already been downloaded
  IfFileExists $INSTALLER skip_download 0
    ## Download latest version
    nsExec::ExecToStack '"curl.exe" -L "$GitHub_URL/$GitHub_User/$GitHub_Repository/$GitHub_Releases" -o "$GitHub_Repository" -s'
    nsExec::ExecToStack '"grep.exe" -E -m 1 -o "/$GitHub_User/$GitHub_Repository/$GitHub_Releases/download/$GitHub_FilePattern" "$GitHub_Repository"'
    Pop $0 # return value/error/timeout
    Pop $1 # printed text, up to ${NSIS_MAX_STRLEN}
    ${StrRep} $2 $1 "/" "\"
    #${StrStrAdv} "ResultVar" "String" "SubString" "SearchDirection" "StrInclusionDirection" "IncludeSubString" "Loops" "CaseSensitive"
    ${StrStrAdv}  $3          $2       "\"         "<"               ">"                     0                  0       0
    ${StrStrAdv}  $4          $3       ".zip"      "<"               "<"                     0                  0       0
    inetc::get /NOCANCEL "$GitHub_URL$1" "$INSTALLER" /END
  skip_download:

  ## Install
  nsExec::ExecToStack '7za.exe x -aoa -o"$DIR_modules" -y "$INSTALLER" "$GitHub_Repository*\*"'
  Sleep 1000
  Rename "$DIR_modules\$4" "$DIR_modules\$Github_Repository"

  ## Autorun Clink when cmd.exe starts
  #ReadEnvStr $0 USERNAME
  #${If} ${RunningX64}
  #  ExecShell "open" "$DIR_modules\$GitHub_Repository\clink_x64.exe" 'autorun --allusers uninstall' SW_HIDE
  #  ExecShell "open" "$DIR_modules\$GitHub_Repository\clink_x64.exe" 'autorun install --nolog --profile \"$DIR_config\$0\clink\" --quiet' SW_HIDE
  #${Else}
  #  ExecShell "open" "$DIR_modules\$GitHub_Repository\clink_x86.exe" 'autorun --allusers uninstall' SW_HIDE
  #  ExecShell "open" "$DIR_modules\$GitHub_Repository\clink_x86.exe" 'autorun install --nolog --profile \"$DIR_config\$0\clink\" --quiet' SW_HIDE
  #${EndIf}

  ## Cleanup installation files
  Delete "$DIR_installer\$GitHub_Repository"
  Delete "$DIR_installer\$INSTALLER"
SectionEnd

LangString desc_clink ${LANG_ENGLISH} "Clink combines the native Windows shell cmd.exe with the powerful command line editing features of the GNU Readline library, which provides rich completion, history, and line-editing capabilities."
