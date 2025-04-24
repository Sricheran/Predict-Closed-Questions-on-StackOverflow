# Set size limit (in MB)
$SizeLimitMB = 25
$SizeLimitBytes = $SizeLimitMB * 1024 * 1024

# Ensure .gitignore exists
if (-not (Test-Path ".gitignore")) {
    New-Item -ItemType File -Path ".gitignore" | Out-Null
}

# Get large files
$LargeFiles = Get-ChildItem -Recurse -File | Where-Object { $_.Length -gt $SizeLimitBytes }

if ($LargeFiles.Count -eq 0) {
    Write-Host "No large files found above $SizeLimitMB MB."
    exit
}

foreach ($file in $LargeFiles) {
    # Create a Git-style relative path with Unix slashes
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "").Replace("\", "/")

    # Only add to .gitignore if not already present
    $gitIgnoreContent = Get-Content .gitignore
    if ($gitIgnoreContent -notcontains $relativePath) {
        Add-Content .gitignore $relativePath
        Write-Host "Ignoring: $relativePath"
    }

    # Remove from Git tracking
    git rm --cached "$relativePath" 2>$null
}

# Stage and commit
git add .gitignore
git commit -m "Ignore large files > $SizeLimitMB MB and remove from tracking"

Write-Host "Done! Large files have been untracked and added to .gitignore."
