;= ::----------------------------------------------------------------------------------------------------
;= :: shark
;= :: The shell environment of your dreams
;= ::
;= :: Shark is a package installer that will allow you to create a fully customized shell environment
;= :: through a single simple installer. It takes the hard work out of downloading and configuring all
;= :: the components you need. Shark simplifies the installation by asking simple questions and taking
;= :: care of downloading and installing everything FOR you from trusted sources (official repositories).
;= :: It has a modular architecture that allows anyone to add and improve the installer easilly.
;= ::
;= :: @author       Kenrick JORUS
;= :: @copyright    2016 Kenrick JORUS
;= :: @license      MIT License
;= :: @link         http://kenijo.github.io/shark/
;= ::
;= :: @package      alias.cmd
;= :: @description  Use this file to define your own aliases
;= :: ----------------------------------------------------------------------------------------------------
;= :: Turn off output
;= @echo off

;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here

df=df -h
du=du -h

grep=grep --color=auto
egrep=egrep --color=auto
fgrep=fgrep --color=auto

ls=ls -1Ahopv --color=auto
ll=ls -1AChpv --color=auto

dir=dir /A /N $*
dib=dir /A /B /N $*
did=dir /A /D /N $*

clear=cls $*
e.=explorer .
history=cat "%SHARK_ROOT%\config\clink\.history"
pwd=cd
shark=cd /d "%SHARK_ROOT%"
unalias=alias /d $1
vi=vim $*
