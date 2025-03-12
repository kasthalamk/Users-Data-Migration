# Author By Mr.Mohan Kasthala
# Set execution policy to allow script execution
Set-ExecutionPolicy Unrestricted -Scope Process -Force

# Function to check for admin privileges
function Check-Admin {
    $isAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    return $isAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to browse for a directory
function Browse-Directory {
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.ShowNewFolderButton = $true
    $folderBrowser.Description = "Select a folder"
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    }
    return $null
}

# Check for admin privileges
if (-not (Check-Admin)) {
    Write-Host "Admin privileges are required. Please run this script as an administrator."
    Write-Host "To do this, right-click on PowerShell and select 'Run as administrator'."
    Start-Sleep -Seconds 5
    exit
}

# Prompt for old and new profile paths using directory browsing
Write-Host "Please select the old user profile directory."
$oldProfilePath = Browse-Directory
if (-not $oldProfilePath) {
    Write-Host "No old profile directory selected. Exiting."
    exit
}

Write-Host "Please select the new user profile directory."
$newProfilePath = Browse-Directory
if (-not $newProfilePath) {
    Write-Host "No new profile directory selected. Exiting."
    exit
}

# Prompt for action
$action = Read-Host "Do you want to move or copy the files? (Enter 'move' or 'copy')"

# Directories to process
$directories = @("Desktop", "Documents", "Pictures", "Downloads", "Music", "Videos")

# Initialize counters
$totalFiles = 0
$totalSize = 0
$successfulMigrations = 0
$skippedDirectories = 0

# Log file path
$logFilePath = Join-Path -Path $newProfilePath -ChildPath "MigrationLog.txt"
"Migration Log - $(Get-Date)" | Out-File -FilePath $logFilePath -Encoding utf8

# Read and display old profile directory sizes and file counts
foreach ($dir in $directories) {
    $sourceDir = Join-Path -Path $oldProfilePath -ChildPath $dir

    if (Test-Path $sourceDir) {
        $files = Get-ChildItem -Path $sourceDir -Recurse
        if ($files.Count -eq 0) {
            Write-Host "Source directory $sourceDir is empty. Skipping."
            $skippedDirectories++
            continue
        }
        $dirSize = ($files | Measure-Object -Property Length -Sum).Sum
        $fileCount = $files.Count
        Write-Host "Directory: $sourceDir"
        Write-Host "Total Files: $fileCount"
        Write-Host "Total Size: $([math]::round($dirSize / 1MB, 2)) MB"
        Write-Host ""

        # Log directory information
        "Directory: $sourceDir" | Out-File -FilePath $logFilePath -Append -Encoding utf8
        "Total Files: $fileCount" | Out-File -FilePath $logFilePath -Append -Encoding utf8
        "Total Size: $([math]::round($dirSize / 1MB, 2)) MB" | Out-File -FilePath $logFilePath -Append -Encoding utf8
        "" | Out-File -FilePath $logFilePath -Append -Encoding utf8
    } else {
        Write-Host "Source directory $sourceDir does not exist."
    }
}

Write-Host "Starting the migration process..."

foreach ($dir in $directories) {
    $sourceDir = Join-Path -Path $oldProfilePath -ChildPath $dir
    $destinationDir = Join-Path -Path $newProfilePath -ChildPath $dir

    # Check if source directory exists
    if (Test-Path $sourceDir) {
        # Create destination directory if it doesn't exist
        if (-not (Test-Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir
        }

        # Move or copy items and track file count and size
        $files = Get-ChildItem -Path $sourceDir -Recurse
        if ($files.Count -eq 0) {
            Write-Host "Source directory $sourceDir is empty. Skipping."
            $skippedDirectories++
            continue
        }
        foreach ($file in $files) {
            $totalFiles++
            $totalSize += $file.Length
            $success = $false
            $attempts = 0

            # Determine the relative path for the destination
            $relativePath = $file.FullName.Substring($sourceDir.Length + 1)
            $destinationPath = Join-Path -Path $destinationDir -ChildPath $relativePath

            # Ensure the destination directory exists
            $destinationFileDir = [System.IO.Path]::GetDirectoryName($destinationPath)
            if (-not (Test-Path $destinationFileDir)) {
                New-Item -ItemType Directory -Path $destinationFileDir -Force
            }

            # Check for existing file and rename if necessary
            if (Test-Path $destinationPath) {
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
                $extension = [System.IO.Path]::GetExtension($file.Name)
                $counter = 1

                while (Test-Path $destinationPath) {
                    $newFileName = "{0}{1}{2}" -f $baseName, $counter, $extension
                    $destinationPath = Join-Path -Path $destinationDir -ChildPath $newFileName
                    $counter++
                }
            }

            while (-not $success -and $attempts -lt 3) {
                try {
                    if ($action -eq 'copy') {
                        Copy-Item -Path $file.FullName -Destination $destinationPath -Force
                        Write-Host "Copied: $($file.FullName) to $destinationPath"
                        "Copied: $($file.FullName) to $destinationPath" | Out-File -FilePath $logFilePath -Append -Encoding utf8
                    } else {
                        Move-Item -Path $file.FullName -Destination $destinationPath -Force
                        Write-Host "Moved: $($file.FullName) to $destinationPath"
                        "Moved: $($file.FullName) to $destinationPath" | Out-File -FilePath $logFilePath -Append -Encoding utf8
                    }
                    $success = $true
                    $successfulMigrations++
                } catch {
                    Write-Host "Error moving/copying file: $($file.FullName). Error: $_"
                    "Error moving/copying file: $($file.FullName). Error: $_" | Out-File -FilePath $logFilePath -Append -Encoding utf8
                    Start-Sleep -Seconds 1
                    $attempts++
                }
            }
        }
    } else {
        Write-Host "Source directory $sourceDir does not exist."
    }
}

# Summary
Write-Host "Migration complete."
Write-Host "Total files processed: $totalFiles"
Write-Host "Total size of files processed: $([math]::round($totalSize / 1MB, 2)) MB"
Write-Host "Successful migrations: $successfulMigrations"
Write-Host "Skipped directories: $skippedDirectories"

# Final matching of old and new profile folders
foreach ($dir in $directories) {
    $sourceDir = Join-Path -Path $oldProfilePath -ChildPath $dir
    $destinationDir = Join-Path -Path $newProfilePath -ChildPath $dir

    if (Test-Path $sourceDir) {
        if (Test-Path $destinationDir) {
            $oldFiles = Get-ChildItem -Path $sourceDir -Recurse
            $newFiles = Get-ChildItem -Path $destinationDir -Recurse

            foreach ($oldFile in $oldFiles) {
                $newFilePath = $oldFile.FullName.Replace($oldProfilePath, $newProfilePath)
                if (Test-Path $newFilePath) {
                    $oldFileSize = $oldFile.Length
                    $newFileSize = (Get-Item $newFilePath).Length
                    if ($oldFileSize -eq $newFileSize) {
                        Write-Host "Matched: $($oldFile.FullName) (Size: $([math]::round($oldFileSize / 1MB, 2)) MB) to $newFilePath (Size: $([math]::round($newFileSize / 1MB, 2)) MB)"
                    } else {
                        Write-Host "Size mismatch for: $($oldFile.FullName). Old Size: $([math]::round($oldFileSize / 1MB, 2)) MB, New Size: $([math]::round($newFileSize / 1MB, 2)) MB"
                    }
                } else {
                    Write-Host "File not found in new profile: $newFilePath"
                }
            }
        } else {
            Write-Host "Destination directory $destinationDir does not exist."
        }
    } else {
        Write-Host "Source directory $sourceDir does not exist."
    }
}
