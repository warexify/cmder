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

@package      Scoop
@package_link http://scoop.sh
@description  A command-line installer for Windows.
              Looking for familiar Unix tools? Tired of Powershell’s Verb-Noun verbosity?
              Scoop helps you get the programs you need, with a minimal amount of point-and-clicking.
----------------------------------------------------------------------------------------------------*/
Section /o "Scoop" section_scoop
  nsExec::ExecToStack "Powershell \
              iex (new-object net.webclient).downloadstring('https://get.scoop.sh') \
           "
SectionEnd

LangString desc_scoop ${LANG_ENGLISH} "A command-line installer for Windows. Looking for familiar Unix tools? Tired of Powershell’s Verb-Noun verbosity? Scoop helps you get the programs you need, with a minimal amount of point-and-clicking."
