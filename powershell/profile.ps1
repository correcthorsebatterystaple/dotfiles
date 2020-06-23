# Shows navigable menu of all options when hitting Tab
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Git prompt settings
# https://github.com/dahlbyk/posh-git
$GitPromptSettings.DefaultPromptPath = "`$((Get-Item -Path '.\').BaseName)";
$GitPromptSettings.DefaultPromptSuffix = '`n$(''>'' * ($nestedPromptLevel + 1)) '

# Aliases
Set-Alias -Name gti -Value git
Set-Alias -Name which -Value Get-Command

function Test-Administrator
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
}
