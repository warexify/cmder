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
@description  This script is the footer to create a utility to manage the context menu
--------------------------------------------------------------------------------------------------*/

Function .onInit
  Call check_context_menu_conemu
  Call check_context_menu_consolez
FunctionEnd

Function check_context_menu
  ClearErrors
  EnumRegKey $0 HKCR "Directory\Background\shell\$1" 0

  ${If} ${Errors}
    !insertmacro UnselectSection $2
  ${Else}
    !insertmacro SelectSection $2
  ${EndIf}
FunctionEnd
