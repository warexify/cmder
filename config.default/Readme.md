## Config

All config files must be in this folder.
If there is no option to set this folder directly, a symbolic link has to be created.

* .\aliases.cmd:            Aliases in cmd; called form .\init.cmd;
                              autocreated from .\config\default\aliases.cmd.
* .\clink\*.lua:            Clink completions and prompt filters;
                              called from .\config\clink.lua after all other prompt filter
                              and clink completions are initialized; add your own.
* .\clink\.history:         The current commandline history; autoupdated on close
* .\clink\settings:         Settings for Clink
* .\conemu\conemu.xml:      Settings for ConEmu
* .\consolez\console.xml:   Settings for ConsoleZ
* .\cygwin:                 Cygwin user profile
* .\cygwin\cygwin.packages: List of packages to install by default with Cygwin
* .\kitty:                  Settings for KiTTY
* .\profile.{cmd|ps1|sh}:   Startup files for cmd|powershell|bash tasks;
                              called from their respective startup scripts;
                              autocreated on first start of such a task