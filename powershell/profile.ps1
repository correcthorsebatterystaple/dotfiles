function prompt() {
    # Get dir name
    $directory = ($pwd -split '\\')[-2] + '\' + ($pwd -split '\\')[-1]
    Write-Host "$($directory)" -nonewline -ForegroundColor blue
    
    # Check if it is a git repo
    $isGit = (git rev-parse --git-dir) 2> $null
    if ($isGit) {
        $branchName = git rev-parse --abbrev-ref HEAD
        $status = (git status -s)
        $totalChanged = ($status | Measure-Object -line).Lines
        
        # Get new files not in index (Untracked files)
        $totalUnstagedAdded = (git ls-files --others --exclude-standard | Measure-Object -line).Lines
        # Get modified files not in index
        $totalUnstagedModified = (git diff --name-only --diff-filter=M | Measure-Object -line).Lines
        # Get deleted files not in index
        $totalUnstagedDeleted = (git diff --name-only --diff-filter=D | Measure-Object -line).Lines
        # Get conflicted files
        $totalConflicted = (git diff --name-only --diff-filter=U| Measure-Object -line).Lines

        # Get the name of the remote branch
        $remote = (git rev-parse --abbrev-ref --symbolic-full-name '@{u}') 2> $null
        
        Write-Host " [" -nonewline
            if ($totalChanged -eq 0) { # if any changes not commited
                Write-Host "$($branchName)" -ForegroundColor green -nonewline
            } else {
                Write-Host "$($branchName)" -ForegroundColor yellow -nonewline

                # Get new files in index
                $totalStagedAdded = (git diff --name-only --cached --diff-filter=A | Measure-Object -line).Lines
                # Get modified files in index
                $totalStagedModified = (git diff --name-only --cached --diff-filter=M | Measure-Object -line).Lines
                # Get deleted files in index
                $totalStagedDeleted = (git diff --name-only --cached --diff-filter=D | Measure-Object -line).Lines
                Write-Host " +$($totalStagedAdded) ~$($totalStagedModified) -$($totalStagedDeleted)" -ForegroundColor green -nonewline

                Write-Host " | " -nonewline

                # Get new files not in index (Untracked files)
                $totalUnstagedAdded = (git ls-files --others --exclude-standard | Measure-Object -line).Lines
                # Get modified files not in index
                $totalUnstagedModified = (git diff --name-only --diff-filter=M | Measure-Object -line).Lines
                # Get deleted files not in index
                $totalUnstagedDeleted = (git diff --name-only --diff-filter=D | Measure-Object -line).Lines
                Write-Host "+$($totalUnstagedAdded) ~$($totalUnstagedModified) -$($totalUnstagedDeleted)" -ForegroundColor red -nonewline

                if ($totalConflicted -gt 0) {
                    Write-Host " !$($totalConflicted)" -ForegroundColor red -nonewline
                }

            }
        Write-Host "]" -nonewline

        if ($remote) {
            # Get how many commit the current branch is ahead of remote
            $ahead = (git rev-list $branchName --not $remote --count)
            # Get how many commit the current branch is behind remote
            $behind = (git rev-list $remote --not $branchName --count)

            if ($ahead -gt 0) {
                Write-Host " ↑$($ahead)" -ForegroundColor green -nonewline
            }
            if ($behind -gt 0) {
                Write-Host " ↓$($behind)" -ForegroundColor red -nonewline
            }
        }
        
    }
    "`n> "
}

# Aliases
Set-Alias -Name gti -Value git
Set-Alias -Name which -Value Get-Command

function Test-Administrator
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator);
}
