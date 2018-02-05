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

@package      Cygwin
@package_link https://www.cygwin.com/
@description  Cygwin is a large collection of GNU and Open Source tools which provide functionality
              similar to a Linux distribution on Windows.
----------------------------------------------------------------------------------------------------*/
Section "Cygwin" section_cygwin
  Var /GLOBAL arch

  SetOutPath "$DIR_config"
  SetOverwrite ifnewer

  ${If} ${RunningX64}
    StrCpy $arch "x86_64"
  ${Else}
    StrCpy $arch "x86"
  ${EndIf}

  SetOutPath "$DIR_installer"
  SetOverwrite ifnewer

  StrCpy $INSTALLER "setup-$arch.exe"
  StrCpy $NAME "cygwin"
  StrCpy $SHORTCUT "Cygwin"

  ## Delete previous version
  Delete $INSTALLER
  RMDir /r "$DIR_modules\$NAME"

  ## Download latest version
  CreateDirectory "$DIR_modules\cygwin\setup"
  inetc::get /NOCANCEL "https://cygwin.com/$INSTALLER" "$DIR_modules\cygwin\setup\$INSTALLER" /END
 
  ## Install
  nsExec::ExecToStack 'cygwin.cmd "$arch" "$DIR_modules\$NAME" "$DIR_modules\cygwin\setup\\$INSTALLER" "$DIR_modules\cygwin\setup" "$DIR_config\$NAME\cygwin-packages" "install"'

  ## Create a default cygwin profile with preset settings
  SetOutPath "$DIR_config\$NAME\home\"
  System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
  CreateDirectory "$0"
  CopyFiles "profile" "$0"

  ## Copy some default settings over to Cygwin
  SetOverwrite on
  CopyFiles /silent "$DIR_config\$NAME\etc\fstab" "$DIR_modules\$NAME\etc"
  SetOverwrite ifnewer

  ## Create a symbolink link between the Cygwin home folder and the our home folder
  RMDir /r "$DIR_modules\$NAME\home"
  ${CreateSymbolicLinkFolder} "$DIR_modules\$NAME\home" "$DIR_config\$NAME\home" $0

  ## Create shortcuts
  CreateShortCut /NoWorkingDir "$SMPROGRAMS\${PRODUCT_NAME}\$SHORTCUT Packages.lnk" "$DIR_installer\cygwin.cmd" '"$arch" "$DIR_modules\$NAME" "$DIR_modules\cygwin\setup\$INSTALLER" "$DIR_modules\cygwin\setup" "$DIR_config\$NAME\cygwin-packages" "update"' "$DIR_modules\$NAME\Cygwin-Terminal.ico"

	## Configure Cygserver and set it up as a service
	nsExec::ExecToStack "$DIR_modules\$NAME\bash.exe -c 'cygserver-config --yes'" 
	## Start Cygserver service
	nsExec::ExecToStack "$DIR_modules\$NAME\cygrunsrv.exe --start cygserver" 
	
  ## Cleanup installation files
  Delete "setup.log"
  Delete "setup.log.full"
  !if "${DEBUG}" == false
    Delete "$INSTALLER"
  !endif
SectionEnd

LangString desc_cygwin ${LANG_ENGLISH} "Cygwin is a large collection of GNU and Open Source tools which provide functionality similar to a Linux distribution on Windows."
