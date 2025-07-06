# ChimpXplore - Quick Reference Guide

**Version 24.11.01** | **MSP Automation Team** | **PowerShell 5.1+**

## ⚡ Essential Commands

### Basic Scans (Parallel Processing Always Enabled)
```powershell
# Current directory with default 4 threads
.\ChimpXplore.ps1

# Specific path with performance optimization
.\ChimpXplore.ps1 -Path "C:\Users" -MaxThreads 8

# Large directory with enhanced FastMode (proper hidden file handling)
.\ChimpXplore.ps1 -Path "C:\" -MinSize 10 -FastMode -IncludeHidden
```

### Professional Reports
```powershell
# Interactive HTML report with charts
.\ChimpXplore.ps1 -Path "C:\Data" -ExportHtml "analysis.html"

# Comprehensive CSV export
.\ChimpXplore.ps1 -Path "C:\Data" -ExportCsv "data.csv" -Comprehensive

# Dual export with advanced access
.\ChimpXplore.ps1 -Path "C:\Windows" -ExportHtml "system.html" -ExportCsv "system.csv" -UseAdvancedMethods
```

### High-Performance Scanning
```powershell
# Maximum speed for large directories (enhanced FastMode)
.\ChimpXplore.ps1 -Path "E:\Archive" -FastMode -IncludeHidden -MaxThreads 12 -MinSize 50

# System directories with permission handling and FastMode
.\ChimpXplore.ps1 -Path "C:\Windows\System32" -UseAdvancedMethods -FastMode -IncludeHidden -Depth 3

# Enterprise storage analysis
.\ChimpXplore.ps1 -Path "\\server\share" -UseAdvancedMethods -MinSize 10 -TopFolders 50
```

### Targeted File Analysis
```powershell
# Media files only (enhanced parallel file collection)
.\ChimpXplore.ps1 -Path "F:\Media" -FileTypes @(".mp4",".mkv",".avi",".mov") -MinSize 100 -FastMode -IncludeHidden

# Exclude temporary files
.\ChimpXplore.ps1 -Path "C:\Temp" -ExcludeTypes @(".tmp",".log",".cache") -TopFiles 50

# Hidden files and system directories
.\ChimpXplore.ps1 -Path "C:\Users\$env:USERNAME" -IncludeHidden -Comprehensive
```

## 📋 Parameter Quick Reference

| Parameter | Type | Default | Purpose | Example |
|-----------|------|---------|---------|---------|
| `-Path` | String | Current dir | Directory to scan | `-Path "C:\"` |
| `-MinSize` | Double | 1.0 | Minimum size (MB) | `-MinSize 10` |
| `-TopFolders` | Int | 20 | Folders to display | `-TopFolders 50` |
| `-TopFiles` | Int | 10 | Files to display | `-TopFiles 30` |
| `-MaxThreads` | Int | 4 | Parallel threads | `-MaxThreads 8` |
| `-Depth` | Int | -1 | Scan depth limit | `-Depth 3` |
| `-ExportHtml` | String | None | HTML report path | `-ExportHtml "report.html"` |
| `-ExportCsv` | String | None | CSV export path | `-ExportCsv "data.csv"` |
| `-FastMode` | Switch | False | Speed optimization with proper hidden file handling | `-FastMode -IncludeHidden` |
| `-UseAdvancedMethods` | Switch | False | Permission handling | `-UseAdvancedMethods` |
| `-Comprehensive` | Switch | False | Detailed analysis | `-Comprehensive` |
| `-IncludeHidden` | Switch | False | Include hidden files | `-IncludeHidden` |
| `-FileTypes` | Array | All | Include extensions | `-FileTypes @(".pdf",".docx")` |
| `-ExcludeTypes` | Array | None | Exclude extensions | `-ExcludeTypes @(".tmp",".log")` |
| `-ShowProgress` | Bool | True | Display progress | `-ShowProgress $false` |

## 🎯 Common Use Cases

### 1. Daily System Monitoring
```powershell
# Automated daily drive report
$date = Get-Date -Format "yyyy-MM-dd"
.\ChimpXplore.ps1 -Path "C:\" -ExportHtml "Reports\Daily_$date.html" -ShowProgress $false -MinSize 5 -MaxThreads 6
```

### 2. User Directory Cleanup
```powershell
# Find large files in user profile for cleanup
.\ChimpXplore.ps1 -Path "C:\Users\$env:USERNAME" -TopFiles 100 -MinSize 0.5 -IncludeHidden -ExportHtml "UserCleanup.html"
```

### 3. Media Library Organization
```powershell
# Analyze video collection with enhanced parallel processing and FastMode
.\ChimpXplore.ps1 -Path "F:\Videos" -FileTypes @(".mp4",".mkv",".avi",".mov",".wmv") -MinSize 100 -MaxThreads 12 -FastMode -IncludeHidden -ExportCsv "VideoAnalysis.csv"
```

### 4. Network Share Audit
```powershell
# Enterprise network storage analysis
.\ChimpXplore.ps1 -Path "\\fileserver\departments" -UseAdvancedMethods -MinSize 10 -TopFolders 50 -ExportHtml "NetworkAudit.html"
```

### 5. System Drive Deep Analysis
```powershell
# Complete C: drive analysis with advanced access
.\ChimpXplore.ps1 -Path "C:\" -UseAdvancedMethods -Comprehensive -TopFolders 50 -TopFiles 50 -ExportHtml "SystemAnalysis.html"
```

### 6. Archive Storage Review
```powershell
# Fast scan of large archive with enhanced FastMode and size focus
.\ChimpXplore.ps1 -Path "E:\Archive" -FastMode -IncludeHidden -MinSize 50 -MaxThreads 10 -ExportCsv "ArchiveReport.csv"
```

### 7. Development Environment Scan
```powershell
# Code repository analysis excluding build artifacts
.\ChimpXplore.ps1 -Path "C:\Projects" -ExcludeTypes @(".obj",".exe",".dll",".pdb") -TopFolders 30 -ExportHtml "DevReport.html"
```

## ⚙️ Performance Tuning

### Thread Configuration Guidelines
| Directory Size | Recommended Threads | Use Case |
|----------------|-------------------|----------|
| Small (< 10K files) | 2-4 | User directories, small projects |
| Medium (10K-100K) | 4-8 | Application folders, departments |
| Large (100K+ files) | 8-16 | Full drives, enterprise storage |
| Network shares | 2-6 | Reduce network congestion |

### Speed vs Accuracy Modes
| Mode | Speed | Accuracy | Best For |
|------|-------|----------|----------|
| **Standard** | Medium | 99%+ | General purpose scanning |
| **FastMode** | High | 95%+ (98%+ with -IncludeHidden) | Large directories, speed priority |
| **Advanced** | Low | 100% | Permission issues, system dirs |
| **Comprehensive** | Lowest | 100% | Detailed forensic analysis |

### Memory Optimization
```powershell
# For very large scans (500K+ files)
.\ChimpXplore.ps1 -Path "C:\" -MinSize 10 -TopFolders 30 -TopFiles 30 -MaxThreads 8

# For systems with limited RAM
.\ChimpXplore.ps1 -Path "C:\" -FastMode -MinSize 5 -ProgressUpdateInterval 1000
```

## 🛠️ Troubleshooting Quick Fixes

### Access Denied Issues
```powershell
# Standard fix: Run as Administrator + Advanced Methods
.\ChimpXplore.ps1 -Path "C:\Windows" -UseAdvancedMethods

# Network share access
.\ChimpXplore.ps1 -Path "\\server\share" -UseAdvancedMethods -MaxThreads 4
```

### Performance Issues
```powershell
# Slow scanning? Try enhanced FastMode
.\ChimpXplore.ps1 -Path "D:\LargeDirectory" -FastMode -IncludeHidden -MaxThreads 8

# High memory usage? Reduce scope
.\ChimpXplore.ps1 -Path "C:\" -MinSize 10 -TopFolders 20 -TopFiles 10
```

### HTML Report Issues
```powershell
# Charts not loading? Check browser console
# Ensure modern browser (Chrome/Firefox/Edge)
# Disable ad blockers that might block Chart.js CDN
```

## 📊 Output Examples

### Console Output Sample
```
ChimpXplore - DISK SPACE ANALYSIS RESULTS
==========================================
Path Scanned: C:\Users\John
Total Size: 45.67 GB
Total Files: 125,432  
Total Folders: 8,765
Scan Duration: 12.34 seconds
Parallel Processing: Enabled (8 threads)

TOP 20 LARGEST FOLDERS:
AppData\Local\Microsoft\OneDrive    12.34 GB   27.0%
Documents\Projects                   8.76 GB   19.2%
Downloads                           3.45 GB    7.6%
...
```

### HTML Report Features
- 📊 **Interactive Charts**: Bar chart (folders), doughnut chart (file types)  
- 📱 **Mobile Responsive**: Works on all devices
- 🔍 **Full Path Display**: Horizontal scrolling, no truncation
- 📈 **Smart Units**: Auto-scales MB/GB/TB based on data size
- 🎨 **Professional Design**: Clean, modern appearance

### CSV Export Columns
**Standard**: Type, Name, Path, Size, SizeFormatted, FileCount, FolderCount, LastModified, Extension
**Comprehensive**: + CreationTime, LastAccessTime, Attributes, IsHidden, IsSystem

## 🔧 Advanced Tips

### Automation Examples
```powershell
# Weekly scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\Scripts\ChimpXplore.ps1 -Path C:\ -ExportHtml C:\Reports\Weekly.html -ShowProgress `$false"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "02:00"
Register-ScheduledTask -TaskName "ChimpXplore-Weekly" -Action $action -Trigger $trigger

# Batch multiple locations
@("C:\Users", "C:\Program Files", "D:\Data") | ForEach-Object {
    .\ChimpXplore.ps1 -Path $_ -ExportHtml "$($_ -replace ':','').html" -MinSize 5
}
```

### PowerShell Profile Integration
```powershell
# Add to PowerShell profile for quick access
function Analyze-DiskSpace {
    param([string]$Path = "C:\", [int]$MinSize = 5)
    & "C:\Scripts\ChimpXplore.ps1" -Path $Path -MinSize $MinSize -ExportHtml "QuickAnalysis.html"
    Invoke-Item "QuickAnalysis.html"
}

# Usage: Analyze-DiskSpace -Path "D:\Projects" -MinSize 10
```

### Cross-Platform Notes
- **Windows**: Full feature support including advanced methods
- **Linux/macOS**: Standard and FastMode work, advanced methods limited
- **PowerShell Core**: Recommended for cross-platform usage
- **Network Shares**: Test connectivity and permissions first

---

## 📚 Quick Links
- **Full Documentation**: ChimpXplore_README.md  
- **Advanced Examples**: 15+ scenarios in main README
- **Performance Benchmarks**: Timing data for different configurations
- **Troubleshooting**: Detailed solutions for common issues

**Version 24.11.01** - Enhanced parallel processing with fixed large file collection and improved FastMode
- **Fixed Issue**: Large files now properly collected from all parallel threads
- **Enhanced FastMode**: Proper hidden file handling in both main and parallel execution
- **Improved Platform Detection**: Better cross-platform compatibility
- **Quick overview**: Depth 2-3
- **Standard analysis**: Unlimited depth
- **Performance critical**: Depth 1-2

## Help Commands

```powershell
# Get detailed help
Get-Help .\ChimpXplore.ps1 -Full

# Show examples only
Get-Help .\ChimpXplore.ps1 -Examples

# Parameter details
Get-Help .\ChimpXplore.ps1 -Parameter Path
```

---
*For complete documentation, see README.md*
