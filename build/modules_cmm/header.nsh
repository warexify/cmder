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

@package      Context Menu Manager
@description  This script is the header to create a utility to manage the context menu
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
## Registry keys
!define ROOT_KEY                              "HKLM"
!define UNINST_KEY                            "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
## MUI Settings
!define MUI_ICON                              "..\icons\shark.ico"
!define MUI_UI                                "nsis_contrib\shark_cmm_ui.exe"
##--------------------------------------------------------------------------------------------------
## Define Output
##--------------------------------------------------------------------------------------------------
BrandingText                                  " "
InstallDir                                    "\${PRODUCT_NAME}"
InstallDirRegKey                              "${ROOT_KEY}" "${UNINST_KEY}" "InstallDir"
Name                                          "${PRODUCT_NAME} Context Menu Manager"
OutFile                                       "shark_context_menu_manager.exe"
RequestExecutionLevel                         admin
SetCompressor                                 /SOLID lzma
ShowInstDetails                               show
##--------------------------------------------------------------------------------------------------
## Include NSIS Libraries
##--------------------------------------------------------------------------------------------------
## NSIS include files
!include                                      "MUI2.nsh"
!include                                      "Sections.nsh"
!include                                      "x64.nsh"
##--------------------------------------------------------------------------------------------------
## Declare variables
##--------------------------------------------------------------------------------------------------
Var /GLOBAL CMM_EXE
##--------------------------------------------------------------------------------------------------
## Define MUI Pages
##--------------------------------------------------------------------------------------------------
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE                     "English"

##--------------------------------------------------------------------------------------------------
## Functions for Context Manu Manager
##--------------------------------------------------------------------------------------------------
Function set_context_menu
  ## Set Context Menu Variables
  ## $0 Context Menu Name
  ## $1  Context Menu Icon
  ## $2  Executable + Arguments (-dir)
  ## $3  Executable + Arguments (-here)
  ## $4  Context Menu Registry Key

  ## HKCR 32 bits
  WriteRegStr HKCR "Directory\Background\shell\$4"                           "Icon"  "$1"
  WriteRegStr HKCR "Directory\Background\shell\$4"                           ""      "$0"
  WriteRegStr HKCR "Directory\Background\shell\$4\command"                   ""      '$3'
  WriteRegStr HKCR "Directory\shell\$4"                                      "Icon"  "$1"
  WriteRegStr HKCR "Directory\shell\$4"                                      ""      "$0"
  WriteRegStr HKCR "Directory\shell\$4\command"                              ""      '$2'
  WriteRegStr HKCR "Drive\shell\$4"                                          "Icon"  "$1"
  WriteRegStr HKCR "Drive\shell\$4"                                          ""      "$0"
  WriteRegStr HKCR "Drive\shell\$4\command"                                  ""      '$2'

  ## HKCR 64 bits
  WriteRegStr HKCR "Wow6432Node\Directory\Background\shell\$4"               "Icon"  "$1"
  WriteRegStr HKCR "Wow6432Node\Directory\Background\shell\$4"               ""      "$0"
  WriteRegStr HKCR "Wow6432Node\Directory\Background\shell\$4\command"       ""      '$3'
  WriteRegStr HKCR "Wow6432Node\Directory\shell\$4"                          "Icon"  "$1"
  WriteRegStr HKCR "Wow6432Node\Directory\shell\$4"                          ""      "$0"
  WriteRegStr HKCR "Wow6432Node\Directory\shell\$4\command"                  ""      '$2'
  WriteRegStr HKCR "Wow6432Node\Drive\shell\$4"                              "Icon"  "$1"
  WriteRegStr HKCR "Wow6432Node\Drive\shell\$4"                              ""      "$0"
  WriteRegStr HKCR "Wow6432Node\Drive\shell\$4\command"                      ""      '$2'

  ## HKCU 32 bits
  WriteRegStr HKCU "Directory\Background\shell\$4"                           "Icon"  "$1"
  WriteRegStr HKCU "Directory\Background\shell\$4"                           ""      "$0"
  WriteRegStr HKCU "Directory\Background\shell\$4\command"                   ""      '$3'
  WriteRegStr HKCU "Directory\shell\$4"                                      "Icon"  "$1"
  WriteRegStr HKCU "Directory\shell\$4"                                      ""      "$0"
  WriteRegStr HKCU "Directory\shell\$4\command"                              ""      '$2'
  WriteRegStr HKCU "Drive\shell\$4"                                          "Icon"  "$1"
  WriteRegStr HKCU "Drive\shell\$4"                                          ""      "$0"
  WriteRegStr HKCU "Drive\shell\$4\command"                                  ""      '$2'

  ## HKCU 64 bits
  WriteRegStr HKCU "Wow6432Node\Directory\Background\shell\$4"               "Icon"  "$1"
  WriteRegStr HKCU "Wow6432Node\Directory\Background\shell\$4"               ""      "$0"
  WriteRegStr HKCU "Wow6432Node\Directory\Background\shell\$4\command"       ""      '$3'
  WriteRegStr HKCU "Wow6432Node\Directory\shell\$4"                          "Icon"  "$1"
  WriteRegStr HKCU "Wow6432Node\Directory\shell\$4"                          ""      "$0"
  WriteRegStr HKCU "Wow6432Node\Directory\shell\$4\command"                  ""      '$2'
  WriteRegStr HKCU "Wow6432Node\Drive\shell\$4"                              "Icon"  "$1"
  WriteRegStr HKCU "Wow6432Node\Drive\shell\$4"                              ""      "$0"
  WriteRegStr HKCU "Wow6432Node\Drive\shell\$4\command"                      ""      '$2'
FunctionEnd

Function del_context_menu
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
