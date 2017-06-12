#----------------------------------------------------------------------------------------------------
# shark
# The shell environment of your dreams
#
# Shark is a package installer that will allow you to create a fully customized shell environment
# through a single simple installer. It takes the hard work out of downloading and configuring all
# the components you need. Shark simplifies the installation by asking simple questions and taking
# care of downloading and installing everything for you from trusted sources (official repositories).
# It has a modular architecture that allows anyone to add and improve the installer easilly.
#
# @author       Kenrick JORUS
# @copyright    2016 Kenrick JORUS
# @license      MIT License
# @link         http://kenijo.github.io/shark/
#
# @package      init.ps1
# @description  Init script for PowerShell
#                !!! THIS FILE IS OVERWRITTEN WHEN SHARK IS UPDATED
#                !!! Use "%SHARK_ROOT%\config\profile.ps1" to add your own startup commands
# ----------------------------------------------------------------------------------------------------

# Compatibility with PS major versions <= 2
if(!$PSScriptRoot) {
    $PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path
}

# Remove trailing '\'
$PSScriptRoot = (($PSScriptRoot).trimend("\"))

# We do this for Powershell as Admin Sessions because SHARK_ROOT is not being set.
if (! $ENV:SHARK_ROOT ) {
    $ENV:SHARK_ROOT = resolve-path( $PSScriptRoot + "\.." )
}

$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\bin;"
$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\modules\cygwin\bin;"
$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\modules\git\bin;"
$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\modules\gow\bin;"
$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\modules\php;"
$ENV:PATH = $ENV:PATH + ";" + $ENV:SHARK_ROOT + "\modules\putty;"

# Add shark modules directory to the autoload path.
$SharkModulePath = Join-path $ENV:SHARK_ROOT "bin/"

try {
    Get-command -Name "vim" -ErrorAction Stop >$null
} catch {
    # # You could do this but it may be a little drastic and introduce a lot of
    # # unix tool overlap with powershel unix like aliases
    # $env:Path += $(";" + $env:SHARK_ROOT + "\modules\git\usr\bin")
    # set-alias -name "vi" -value "vim"
    # # I think the below is safer.

    new-alias -name "vim" -value $($ENV:SHARK_ROOT + "\modules\git\usr\bin\vim.exe")
    new-alias -name "vi" -value vim
}

try {
    # Check if git is on PATH, i.e. Git already installed on system
    Get-command -Name "git" -ErrorAction Stop >$null
} catch {
    $env:Path += $(";" + $env:SHARK_ROOT + "\modules\git\cmd")
    # for bash.exe, which in the cmd version is found as <GIT>\usr\bin\bash.exe
    $env:Path += $(";" + $env:SHARK_ROOT + "\modules\git\bin")
}

$gitLoaded = $false
function Import-Git($Loaded){
    if($Loaded) { return }
    $GitModule = Get-Module -Name Posh-Git -ListAvailable
    if($GitModule | select version | where version -le ([version]"0.6.1.20160330")){
        Import-Module Posh-Git > $null
    }
    if(-not ($GitModule) ) {
        Write-Warning "Missing git support, install posh-git with 'Install-Module posh-git' and restart shark."
    }
    # Make sure we only run once by alawys returning true
    return $true
}

function checkGit($Path) {
    if (Test-Path -Path (Join-Path $Path '.git') ) {
        $gitLoaded = Import-Git $gitLoaded
        Write-VcsStatus
        return
    }
    $SplitPath = split-path $path
    if ($SplitPath) {
        checkGit($SplitPath)
    }
}

# Move to the wanted location
# This is either a env variable set by the user or the result of
# cmder.exe setting this variable due to a commandline argument or a "shark here"
if ( $ENV:SHARK_START ) {
    Set-Location -Path "$ENV:SHARK_START"
}

if (Get-Module PSReadline -ErrorAction "SilentlyContinue") {
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

# Enhance Path
$env:Path = "$Env:SHARK_ROOT\bin;$env:Path;$Env:SHARK_ROOT"

#
# Prompt Section
#   Users should modify their profile.ps1 as it will be safe from updates.
#

# Pre assign the hooks so the first run of shark gets a working prompt.
[ScriptBlock]$PrePrompt = {}
[ScriptBlock]$PostPrompt = {}
[ScriptBlock]$SharkPrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    checkGit($pwd.ProviderPath)
}

<#
This scriptblock runs every time the prompt is returned.
Explicitly use functions from MS namespace to protect from being overridden in the user session.
Custom prompt functions are loaded in as constants to get the same behaviour
#>
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    PrePrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    SharkPrompt
    Microsoft.PowerShell.Utility\Write-Host "`nλ " -NoNewLine -ForegroundColor "DarkGray"
    PostPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

$SharkUserProfilePath = Join-Path $env:SHARK_ROOT "config\profile.ps1"
if(Test-Path $SharkUserProfilePath) {
    # Create this file and place your own command in there.
    . "$SharkUserProfilePath"
} else {
# This multiline string cannot be indented, for this reason I've not indented the whole block

Write-Host -BackgroundColor Darkgreen -ForegroundColor White "First Run: Creating user startup file: $SharkUserProfilePath"

$UserProfileTemplate = @'
# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><SHARK DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\shark [master]
    λ <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {

}

# Replace the shark prompt entirely with this.
# [ScriptBlock]$SharkPrompt = {}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>


'@

New-Item -ItemType File -Path $SharkUserProfilePath -Value $UserProfileTemplate > $null

}

# Once Created these code blocks cannot be overwritten
Set-Item -Path function:\PrePrompt   -Value $PrePrompt   -Options Constant
Set-Item -Path function:\SharkPrompt -Value $SharkPrompt -Options Constant
Set-Item -Path function:\PostPrompt  -Value $PostPrompt  -Options Constant

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
Set-Item -Path function:\prompt  -Value $Prompt  -Options ReadOnly
