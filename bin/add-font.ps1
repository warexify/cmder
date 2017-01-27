##----------------------------------------------------------------------------------------------------
## shark
## The shell environment of your dreams
##
## Shark is a package installer that will allow you to create a fully customized shell environment
## through a single simple installer. It takes the hard work out of downloading and configuring all
## the components you need. Shark simplifies the installation by asking simple questions and taking
## care of downloading and installing everything FOR you from trusted sources (official repositories).
## It has a modular architecture that allows anyone to add and improve the installer easilly.
##
## @author       Kenrick JORUS
## @copyright    2016 Kenrick JORUS
## @license      MIT License
## @link         http://kenijo.github.io/shark/
##
## @package      add-font
## @description  Script that installs fonts
## @usage        add-font.ps1 -FontPath "C:\folder\with\fonts\to\install"
## ----------------------------------------------------------------------------------------------------
param
(
  [string] $path,
  [switch] $help = $false
)

## ----------------------------------------------------------------------------------------------------
## Function Show-Usage()
## Purpose:   Shows the correct usage to the user.
## Input:     None
## Output:    Help messages are displayed on screen.
## ----------------------------------------------------------------------------------------------------
function Show-Usage()
{
$usage = @'
Add-Font-Recursive.ps1
  This script is used to install Windows fonts recursively from a folder.

Usage:
  Add-Font-Recursive.ps1 [-help] [-path "<Font folder path>"]

Parameters:
  -help
   Displays usage information.

  -path
   May be either the path to a font file to install or the path to a folder 
   containing font files to install.  Valid file types are .fon, .fnt,
   .ttf,.ttc, .otf, .mmm, .pbf, and .pfm

Examples:
  Add-Font-Recursive.ps1 -path "C:\Custom Fonts"
'@

$usage
}

## ----------------------------------------------------------------------------------------------------
## Function Process-Arguments()
## Purpose: To validate parameters and their values
## Input:   All parameters
## Output:  Exit script if parameters are invalid
## ----------------------------------------------------------------------------------------------------
function Process-Arguments()
{
    ## Write-host 'Processing Arguments'

    if ($unnamedArgs.Length -gt 0)
    {
        write-host "The following arguments are not defined:"
        $unnamedArgs
    }

    if ($help -eq $true) 
    { 
        Show-Usage
        break
    }
}

## ----------------------------------------------------------------------------------------------------
## Main Script
## ----------------------------------------------------------------------------------------------------
if ($help -eq $true) 
{ 
    Show-Usage
    break
}

ForEach ($font in (dir $FontPath -Include *.otf, *.ttf -Recurse))
{
  & ((Split-Path $MyInvocation.InvocationName) + "\Add-Font.ps1") -Path "$font"
}