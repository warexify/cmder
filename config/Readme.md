## Config

All config files must be in this folder. If there is no option to set this folder directly,
a symbolic link has to be created.

* `clink\*.lua`: clink completions and prompt filters; called from vendor\cmder.lua
  after all other prompt filter and clink completions are initialized; add your own.
* `clink\.history`: the current commandline history; autoupdated on close
* `clink\settings`: settings for readline; overwritten on update
* `conemu.xml`: settings for ConEmu
* `conemu.xml`: settings for ConsoleZ
* `cygwin`: contains Cygwin's user profile
* `cygwin.packages`: this is the list of packages to install by default with Cygwin
* `kitty`: contains KiTTY's settings
* `user-aliases.cmd`: aliases in cmd; called form vendor\init.bat;
  autocreated from `vendor\user-aliases.cmd.example`.
* `user_profile.{sh|bat|ps1}`: startup files for bash|cmd|powershell tasks; called from their
  respective startup scripts in `vendor\`; autocreated on first start of such a task
