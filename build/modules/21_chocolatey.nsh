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

@package      Chocolatey
@package_link https://chocolatey.org/
@description  The package manager for Windows. Easily manage all aspects of Windows software
              (installation, configuration, upgrade, and uninstallation). Chocolatey works best
              when software is included in the package, but can easily download resources.
----------------------------------------------------------------------------------------------------*/
Section "Chocolatey" section_chocolatey
  nsExec::ExecToStack "Powershell \
              iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex \
           "
SectionEnd

LangString desc_chocolatey ${LANG_ENGLISH} "The package manager for Windows. Easily manage all aspects of Windows software (installation, configuration, upgrade, and uninstallation). Chocolatey works best when software is included in the package, but can easily download resources."
