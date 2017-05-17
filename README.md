# shark
This project started as a fork of [Cmder](http://cmder.net) and became its own full fledge version allowing users to select which components they want to include in their installation.
The structure design of [Cmder](http://cmder.net) has been slightly modified and the scripts reworked.

## Create the shell environment of your dreams
Shark is a packaged installer that will allow you to create a fully customized shell environment through a single simple installer.
It takes the hard work out of downloading and configuring all the components you need.
Shark simplifies the installation by asking simple questions and taking care of downloading and installing everything for you from trusted sources (official repositories).
It has a modular architecture that allows anyone to add and improve the installer easily.

## Repository
The repository contains the code to to generate the simple installer based mostly on [NSIS](http://nsis.sourceforge.net) scripts and PowerShell commands.
The releases are the compiled version of Shark.

---

## Packages
  - [Chocolatey](https://chocolatey.org)
  - [Clink](http://mridgers.github.io/clink) ([repo](https://github.com/mridgers/clink))
  - Clink-Completions ([repo](https://github.com/vladimir-kotikov/clink-completions))
  - [ConEmu](https://conemu.github.io) ([repo](https://github.com/Maximus5/ConEmu))
  - [ConsoleZ](https://github.com/cbucher/console/wiki) ([repo](https://github.com/cbucher/console))
  - [Cygwin](https://www.cygwin.com)
  - [Git](https://git-scm.com) ([repo](https://github.com/git-for-windows/git))
  - [Gow](https://github.com/bmatzelle/gow/wiki) ([repo](https://github.com/bmatzelle/gow))
  - [Free Programing Fonts](http://cdn.sixrevisions.com/0441-01_programming-fonts/demo/programming-fonts.html)
  - [KiTTY](http://kitty.9bis.net)
  - Kou1okada APT-CYG ([repo](https://github.com/kou1okada/apt-cyg)) based on Trasncode-Open APT-CYG ([repo](https://github.com/transcode-open/apt-cyg))
  - [PHP](http://php.net)
  - Powerline Fonts ([repo](https://github.com/powerline/fonts))
  - [PuTTY](http://www.putty.org) and [PuTTY Tray](http://puttytray.goeswhere.com)
  - [Scoop](http://scoop.sh)

  ## Packages to work on
  - [Oh My Zsh](http://ohmyz.sh) ([repo](https://github.com/robbyrussell/oh-my-zsh))
  - [Zsh](http://zsh.sourceforge.net) ([repo](https://sourceforge.net/p/zsh/code/ci/master/tree))

  ## Inspirational links
  - [Babun](http://babun.github.io) ([repo](https://github.com/babun/babun))
  - [Cmder](http://cmder.net) ([repo](https://github.com/cmderdev/cmder))
  - [Package manager for Cygwin](http://stackoverflow.com/questions/9260014/how-do-i-install-cygwin-components-from-the-command-line/23143997#23143997)
  - Sage ([repo](https://github.com/svnpenn/sage))

## Color assignment

<pre>
  - CMD                 icon cyan
  - CMD (Admin)         icon cyan bold
  - Powershell          icon blue
  - Powershell (Admin)  icon blue bold
  - Cygwin              icon green
  - Cygwin (Admin)      icon green bold
  - Git                 icon magenta
  - Git (Admin)         icon magenta bold
  - PuTTY               icon yellow
  - Anything else       icon white
</pre>

---
## TODO
## Those are not a priority to me right now as I don't use them much
  - Git
      Define profile

## How to compile your own version of Shrak
  1. Download and install [NSIS](http://nsis.sourceforge.net). Currently tested with NSIS 3.0
  2. All NSIS dependancies used are included in the `nsis_contrib`, `nsis_include` and `nsis_plugin` folders
  3. Edit modules or create new ones in the `build\modules` folder. Modules have an `*.nsh` extension
  4. Compile the `.\build\make.nsi` script and you'll get a `.build\shark.exe` installer

---

## License
MIT

[//]: < @author      Kenrick JORUS >
[//]: < @copyright   2017 Kenrick JORUS >
[//]: < @license     MIT License >
[//]: < @link        http://kenijo.github.io/shark/ >
