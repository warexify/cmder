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

df=df -h $*
du=du -h $*

grep=grep --color=auto $*
egrep=egrep --color=auto $*
fgrep=fgrep --color=auto $*

;= :: ls --help
;= ::  -A, --almost-all           do not list implied . and ..
;= ::  -F, --classify             append indicator (one of */=>@|) to entries
;= ::  -h, --human-readable       with -l, print sizes in human readable format (e.g., 1K 234M 2G)
;= ::  -N, --literal              print entry names without quoting
;= ::  -v                         natural sort of (version) numbers within text
;= ::  --color[=WHEN]             colorize the output. WHEN defaults to 'always' or can be 'never' or 'auto'
;= ::  --format=WORD              long -l, single-column -1, vertical -C
;= ::  --time-style=STYLE         STYLE: full-iso, long-iso, iso, locale, +FORMAT
;= ::  --sort=WORD                sort by WORD instead of name: none (-U), size (-S), time (-t), version (-v), extension (-X)
;= ::  -g                         like -l, but do not list owner
;= ::  -o                         like -l, but do not list group information
ls=ls -AFhNv -go --color=auto --sort=none --time-style=long-iso --format=vertical $*
ll=ls -AFhNv -go --color=auto --sort=none --time-style=long-iso --format=long $*

dir=dir /A /N $*
dib=dir /A /B /N $*

clear=cls $*
e.=explorer .
history=cat "%SHARK_ROOT%\config\clink\.history"
pwd=cd
shark=cd /d "%SHARK_ROOT%"
unalias=alias /d $1
vi=vim $*
