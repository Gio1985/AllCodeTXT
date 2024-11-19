# AllCodeTXT

A PowerShell script to recursively process a directory, merge file contents into a single output file, and generate a summary of empty folders and excluded items.

## Features
- **Concatenates file contents**: Combines all file contents into a single output file.
- **Exclusion rules**: Skips items based on customizable patterns (e.g., `.git`, `__pycache__`).
- **Empty folder detection**: Logs empty folders for easy identification.
- **Summary generation**: Provides stats on processed files, skipped items, and folder statuses.

## Usage
1. Clone this repository or download `_getfullcode.ps1`.
2. Open a PowerShell terminal.
3. Navigate to the script's directory:
   ```powershell
   cd path\to\script

