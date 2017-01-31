;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here

df=df -h
grep=grep --color                     
egrep=egrep --color=auto              
fgrep=fgrep --color=auto              

ls=ls --color --format=vertical -Ah   
ll=ls --color --format=long -Ah       
vdir=ls --color --format=vertical -Ah 
ldir=ls --color --format=vertical -Ah  

e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\clink\.history"
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"
