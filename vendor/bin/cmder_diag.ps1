Write-Host ------------------------------------
Write-Host get-childitem "$env:CMDER_ROOT"
Write-Host ------------------------------------
Get-ChildItem "$env:CMDER_ROOT"

Write-Host ''
Write-Host ------------------------------------
Write-Host get-childitem "$env:CMDER_ROOT/vendor"
Write-Host ------------------------------------
Get-ChildItem "$env:CMDER_ROOT/vendor"

Write-Host ''
Write-Host ------------------------------------
Write-Host get-childitem -s "$env:CMDER_ROOT/bin"
Write-Host ------------------------------------
Get-ChildItem -s "$env:CMDER_ROOT/bin"

Write-Host ''
Write-Host ------------------------------------
Write-Host get-childitem -s "$env:CMDER_ROOT/config"
Write-Host ------------------------------------
Get-ChildItem -s "$env:CMDER_ROOT/config"

Write-Host ''
Write-Host ------------------------------------
Write-Host get-childitem env:
Write-Host ------------------------------------
Get-ChildItem env: | Format-Table -AutoSize -Wrap

Write-Host ''
Write-Host ------------------------------------
Write-Host get-command git
Write-Host ------------------------------------
Get-Command git

write-host ''
write-host ------------------------------------
write-host systeminfo
write-host ------------------------------------
systeminfo

write-host ''
write-host ------------------------------------
write-host Make sure you sanitize this output of private data prior to posting it online for review by the CMDER Team!
write-host ------------------------------------
