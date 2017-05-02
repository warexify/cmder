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

@package      CMD Settings
@description  Set the settings for the standard CMD (to match color and window size)
----------------------------------------------------------------------------------------------------*/
Section "-CMD Settings" section_cmd_settings
  ## This module is hidden from selection and automaticaly installed
  StrCpy $NAME "cmd_settings.reg"

	WriteRegDWORD HKEY_CURRENT_USER "Console" "CurrentPage" 						0x0
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ScreenColors" 						0x7
	WriteRegDWORD HKEY_CURRENT_USER "Console" "PopupColors" 						0x60
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable00"						0x2d2d2d
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable01" 						0xa06e41
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable02" 						0x559b64
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable03" 						0xa0a05a
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable04" 						0x3c41be
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable05" 						0x9b558c
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable06" 						0xb4e6
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable07" 						0xbebebe
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable08" 						0x5a5a5a
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable09" 						0xd2a073
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable10" 						0x6eb47d
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable11" 						0xd2d28c
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable12" 						0x555ad7
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable13" 						0xb97daa
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable14" 						0x19cdff
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ColorTable15" 						0xebebeb
	WriteRegDWORD HKEY_CURRENT_USER "Console" "InsertMode" 							0x1
	WriteRegDWORD HKEY_CURRENT_USER "Console" "QuickEdit" 							0x1
	WriteRegDWORD HKEY_CURRENT_USER "Console" "ScreenBufferSize" 				0x27007c
	WriteRegDWORD HKEY_CURRENT_USER "Console" "WindowSize" 							0x27007c
	WriteRegDWORD HKEY_CURRENT_USER "Console" "FontSize" 								0xd0000
	WriteRegDWORD HKEY_CURRENT_USER "Console" "FontFamily" 							0x36
	WriteRegDWORD HKEY_CURRENT_USER "Console" "FontWeight" 							0x190
	WriteRegStr 	HKEY_CURRENT_USER "Console" "FaceName"								"Lucida Console"
	WriteRegDWORD HKEY_CURRENT_USER "Console" "CursorSize"							0x19
	WriteRegDWORD HKEY_CURRENT_USER "Console" "HistoryBufferSize"				0x3e7
	WriteRegDWORD HKEY_CURRENT_USER "Console" "NumberOfHistoryBuffers"	0x5
	WriteRegDWORD HKEY_CURRENT_USER "Console" "HistoryNoDup"						0x1
SectionEnd

LangString desc_cmd_settings ${LANG_ENGLISH} "Set the settings for the standard CMD (to match color and window size)"
