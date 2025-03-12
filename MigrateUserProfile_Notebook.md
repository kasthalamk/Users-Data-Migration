# Migration of User Profile Data

## Introduction
The `MigrateUserProfile.ps1` script is designed to facilitate the migration of user profile data from an old profile directory to a new one. It includes functionalities for checking administrative privileges, browsing directories, migrating files, and logging the process.

## Requirements
- PowerShell
- Administrative rights to run the script

## Usage Instructions
1. Open PowerShell as an administrator.
2. Run the script by executing `.\MigrateUserProfile.ps1`.
3. Follow the prompts to select the old and new user profile directories.
4. Choose whether to move or copy the files.

## Code Explanation
- **Admin Privilege Check**: Ensures the script is run with administrative privileges.
- **Directory Browsing**: Allows users to select the old and new profile directories through a graphical interface.
- **File Migration**: Offers options to either move or copy files from specified directories (Desktop, Documents, Pictures, Downloads, Music, Videos).
- **Logging**: Maintains a log of the migration process, including details about the files processed, their sizes, and any errors encountered.
- **Summary Report**: At the end of the migration, it provides a summary of the total files processed, successful migrations, and any skipped directories.

## Logging and Output
The script generates a log file named `MigrationLog.txt` in the new profile directory, documenting the migration process.

## Troubleshooting
- Ensure you have administrative rights to run the script.
- If you encounter issues, check the log file for error messages and details about the migration process.

## Examples
- To run the script, open PowerShell and execute:
  ```powershell
  .\MigrateUserProfile.ps1
  ```

## FAQs
- **What if I don't have admin rights?**
  You will need to run PowerShell as an administrator to execute this script.

## Version History
- **Version 1.0**: Initial release of the migration script.

## References
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
