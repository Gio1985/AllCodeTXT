# AllCodeTXT

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A PowerShell utility that recursively processes directories to generate a consolidated code file, perfect for code analysis, documentation, and backup purposes.

## 🚀 Features

- **Smart File Concatenation**: Seamlessly combines contents of all files into a single organized output
- **Intelligent Filtering**: 
  - Automatically excludes common development artifacts (`.git`, `__pycache__`, etc.)
  - Customizable exclusion patterns
  - Self-exclusion to prevent script recursion
- **Directory Analysis**:
  - Identifies and logs empty directories
  - Generates comprehensive processing statistics
  - Creates detailed execution summaries
- **Minimal Setup**: Single script solution with no external dependencies

## 📋 Prerequisites

- Windows PowerShell 5.1 or later
- Write permissions in the target directory

## 🛠️ Installation

1. Clone this repository:
```powershell
git clone https://github.com/yourusername/AllCodeTXT.git
```

2. Or download the `_getfullcode.ps1` script directly to your target directory

## 💻 Usage

1. Navigate to your target directory in PowerShell:
```powershell
cd path/to/your/directory
```

2. Execute the script:
```powershell
./_getfullcode.ps1
```

3. Find your generated output file:
```
<root_directory_name>.txt
```

## 📝 Output Format

The script generates a consolidated text file with the following characteristics:

- Named after the root directory
- Contains all processed file contents
- Includes file separators and headers for easy navigation
- Preserves original file structure information

## ⚙️ Configuration

### Default Exclusions

The script automatically excludes:
- `.git` directories
- `__pycache__` folders
- Script file itself (`_getfullcode.ps1`)
- Additional patterns can be configured in the script

### Customizing Exclusions

Modify the exclusion patterns in the script:
```powershell
$excludePatterns = @(
    '.git',
    '__pycache__',
    # Add your patterns here
)
```

## 📊 Generated Summary

The script provides a detailed summary including:
- Total files processed
- Skipped items (with reasons)
- Empty folder locations
- Processing duration
- Output file location

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Acknowledgments

- Inspired by the need for efficient code consolidation
- Built with PowerShell best practices in mind

## 📞 Support

- Open an issue for bug reports or feature requests
- Submit PRs for any improvements
- Star the repository if you find it useful!

---
Made with ❤️ by [Your Name/Organization]