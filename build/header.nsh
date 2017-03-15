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

@package      header
@description  This is the begining part of the shark installer
--------------------------------------------------------------------------------------------------*/

##--------------------------------------------------------------------------------------------------
## Create a unicode installer
##--------------------------------------------------------------------------------------------------
unicode                                       true
##--------------------------------------------------------------------------------------------------
## Define Constants
##--------------------------------------------------------------------------------------------------
## Installer name
!define PRODUCT_NAME                          "shark"
## Installer version
#!define PRODUCT_VERSION                       "1.0"
## Registry keys
!define ROOT_KEY                              "HKLM"
!define UNINST_KEY                            "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
## MUI Settings
!define MUI_ICON                              "..\icons\shark.ico"
!define MUI_STARTMENUPAGE_REGISTRY_KEY        "Software\${PRODUCT_NAME}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT       "${ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME  "${PRODUCT_NAME}"
!define MUI_UI                                "nsis_contrib\shark_ui.exe"
!define MUI_UNICON                            "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-full.ico"
##--------------------------------------------------------------------------------------------------
## Define Output
##--------------------------------------------------------------------------------------------------
BrandingText                                  " "
InstallDir                                    "\${PRODUCT_NAME}"
InstallDirRegKey                              "${ROOT_KEY}" "${UNINST_KEY}" "InstallDir"
Name                                          "${PRODUCT_NAME}"
OutFile                                       "${PRODUCT_NAME}.exe"
RequestExecutionLevel                         admin
SetCompressor                                 /SOLID lzma
ShowInstDetails                               show
ShowUnInstDetails                             show
##--------------------------------------------------------------------------------------------------
## Include Custom NSIS includes and plugins
##--------------------------------------------------------------------------------------------------
!addincludedir                                "nsis_include"
!addplugindir                                 "nsis_plugin\x64-unicode"
!addplugindir                                 "nsis_plugin\x86-unicode"
##--------------------------------------------------------------------------------------------------
## Include NSIS Libraries
##--------------------------------------------------------------------------------------------------
## NSIS include files
!include                                      "FileFunc.nsh"
!include                                      "LogicLib.nsh"
!include                                      "MUI2.nsh"
!include                                      "Sections.nsh"
!include                                      "StrFunc.nsh"
!include                                      "x64.nsh"
## Custom include files
!include                                      "Junction.nsh"
## Declare used functions from include librairies
${StrRep}
${StrStrAdv}
##--------------------------------------------------------------------------------------------------
## Declare variables
##--------------------------------------------------------------------------------------------------
Var INSTALLER
Var NAME
Var SHORTCUT
Var Github_FilePattern
Var Github_Releases
Var Github_Repository
Var Github_URL
Var Github_User
##--------------------------------------------------------------------------------------------------
## Define MUI Pages
##--------------------------------------------------------------------------------------------------
!insertmacro MUI_PAGE_LICENSE                 "..\Readme.md"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!if "${DEBUG}" == false
  !insertmacro MUI_PAGE_FINISH
!endif
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE                     "English"
##--------------------------------------------------------------------------------------------------
## This is a pre process section (this section is mandatory and hidden from the user)
##--------------------------------------------------------------------------------------------------
Section "-pre_section"
  Var /GLOBAL DIR_bin
  Var /GLOBAL DIR_config
  Var /GLOBAL DIR_icons
  Var /GLOBAL DIR_installer
  Var /GLOBAL DIR_modules

  StrCpy $DIR_bin             "$INSTDIR\bin"
  StrCpy $DIR_config          "$INSTDIR\config"
  StrCpy $DIR_icons           "$INSTDIR\icons"
  StrCpy $DIR_installer       "$INSTDIR\installer"
  StrCpy $DIR_modules         "$INSTDIR\modules"

  StrCpy $GitHub_URL          "https://github.com"
  StrCpy $GitHub_Releases     "releases"
 
  SetOverwrite  ifnewer
  
  SetOutPath    "$DIR_bin"
  File /r "..\bin\*"
  
  SetOutPath    "$DIR_config"
  File /r "..\config.default\*"

  SetOutPath    "$DIR_icons"
  File /r "..\icons\*"
  
  SetOutPath    "$DIR_installer"
  File /r "..\installer\*"
  
  SetOutPath    "$DIR_modules"
  File /r "..\modules\*"
  
  ## Create start menu shortcut folder
  SetShellVarContext all
	CreateDirectory   "$SMPROGRAMS\${PRODUCT_NAME}"
SectionEnd
