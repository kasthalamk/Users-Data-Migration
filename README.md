# Migration of User Profile Data

## Introduction
<details>
  <summary>Click to expand</summary>
  The `MigrateUserProfile.ps1` script is designed to facilitate the migration of user profile data from an old profile directory to a new one. It includes functionalities for checking administrative privileges, browsing directories, migrating files, and logging the process to ensure smooth and reliable data transfer.
</details>

## Requirements
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><strong>PowerShell</strong>: The script is written in PowerShell and requires a compatible environment.</li>
    <li><strong>Administrative Rights</strong>: The script must be run with administrative privileges to access and modify user profile directories.</li>
    <li><strong>Sufficient Storage Space</strong>: Ensure that the destination profile directory has enough space to accommodate the migrated files.</li>
  </ul>
</details>

## Usage Instructions
<details>
  <summary>Click to expand</summary>
  <ol>
    <li><strong>Open PowerShell as an Administrator</strong>:
      <ul>
        <li>Search for `PowerShell` in the Windows Start menu.</li>
        <li>Right-click on `Windows PowerShell` and select `Run as administrator`.</li>
      </ul>
    </li>
    <li><strong>Navigate to the Script Directory</strong>:
      <ul>
        <li>Use the `cd` command in PowerShell to navigate to the directory where `MigrateUserProfile.ps1` is located.</li>
      </ul>
    </li>
    <li><strong>Execute the Script</strong>:
      <pre><code>./MigrateUserProfile.ps1</code></pre>
    </li>
    <li><strong>Follow the Prompts</strong>:
      <ul>
        <li>Select the old and new user profile directories using the graphical interface.</li>
        <li>Choose whether to move (deletes files from the original location) or copy (keeps original files intact) the files.</li>
      </ul>
    </li>
  </ol>
</details>

## Code Explanation
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><strong>Admin Privilege Check</strong>: The script verifies that it is running with administrative privileges before proceeding.</li>
    <li><strong>Directory Browsing</strong>: Users are presented with a graphical interface to choose the source (old profile) and destination (new profile) directories.</li>
    <li><strong>File Migration Options</strong>:
      <ul>
        <li><strong>Move</strong>: Transfers files to the new profile and removes them from the original location.</li>
        <li><strong>Copy</strong>: Duplicates files while preserving them in the original location.</li>
      </ul>
    </li>
    <li><strong>Selected Directories</strong>: The script migrates specific folders such as `Desktop`, `Documents`, `Pictures`, `Downloads`, `Music`, and `Videos`.</li>
    <li><strong>Logging System</strong>: The script creates a log file named `MigrationLog.txt` in the destination directory.</li>
    <li><strong>Summary Report</strong>: At the end of the migration, the script provides a detailed summary including:
      <ul>
        <li>The total number of files processed.</li>
        <li>The number of successful migrations.</li>
        <li>Any directories skipped due to errors or permissions issues.</li>
      </ul>
    </li>
  </ul>
</details>

## Logging and Output
<details>
  <summary>Click to expand</summary>
  <ul>
    <li>A log file (`MigrationLog.txt`) is generated in the new profile directory.</li>
    <li>This file records all migration actions, making it easy to track progress and troubleshoot issues.</li>
  </ul>
</details>

## Troubleshooting
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><strong>Ensure You Have Administrative Rights</strong>: If you receive an error about permissions, rerun the script as an administrator.</li>
    <li><strong>Check the Log File</strong>: If files fail to migrate, review `MigrationLog.txt` for specific errors.</li>
    <li><strong>Verify Available Storage Space</strong>: The new profile directory should have enough storage to accommodate the files.</li>
    <li><strong>Check File Permissions</strong>: Some system-protected files may not be migrated due to restrictions.</li>
  </ul>
</details>

## Examples
<details>
  <summary>Click to expand</summary>
  To run the script, open PowerShell and execute:
  <pre><code>./MigrateUserProfile.ps1</code></pre>
  You will then be guided through the migration process interactively.
</details>

## FAQs
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><strong>What if I don't have admin rights?</strong> You need to run PowerShell as an administrator to execute this script.</li>
    <li><strong>Can I choose specific folders to migrate?</strong> No, the script automatically migrates predefined user folders.</li>
    <li><strong>Will my files be deleted after migration?</strong> If you choose "Move," files will be removed from the original location. If you choose "Copy," they will remain in both locations.</li>
  </ul>
</details>

## Version History
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><strong>Version 1.0</strong>: Initial release of the migration script.</li>
  </ul>
</details>

## References
<details>
  <summary>Click to expand</summary>
  <ul>
    <li><a href="https://docs.microsoft.com/en-us/powershell/">PowerShell Documentation</a></li>
  </ul>
</details>
