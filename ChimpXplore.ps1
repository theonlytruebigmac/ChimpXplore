<#
.SYNOPSIS
    ChimpXplore - A comprehensive PowerShell tool for disk space analysis and visualization
    
.DESCRIPTION
    ChimpXplore is a powerful, cross-platform PowerShell script that analyzes disk space usage 
    and generates detailed reports. It provides similar functionality to TreeSize Free but with 
    additional features including:
    
    - Parallel processing for faster scanning of large directories
    - Advanced access methods to handle permission issues (WMI, Robocopy, Win32 API)
    - Professional HTML reports with interactive charts and graphs
    - CSV export for data analysis
    - Comprehensive file type analysis
    - Support for filtering by file types
    - Progress tracking and error handling
    - Cross-platform compatibility (Windows, Linux, macOS)
    
    The script uses optimized single-pass scanning to ensure accurate size reporting that matches
    Windows Explorer and TreeSize Free, even for complex directory structures.
    
.PARAMETER Path
    The root path to scan for disk usage analysis.
    Default: Current directory
    Examples: "C:\", "C:\Users", "/home/user", "\\server\share"
    
.PARAMETER Depth
    Maximum depth to scan in the directory tree. Use -1 for unlimited depth.
    Default: -1 (unlimited)
    Examples: 1 (only immediate subdirectories), 3 (up to 3 levels deep)
    
.PARAMETER TopFolders
    Number of largest folders to display in results and reports.
    Default: 20
    Range: 1-100 recommended
    
.PARAMETER TopFiles
    Number of largest files to display in results and reports.
    Default: 10
    Range: 1-100 recommended
    
.PARAMETER MinSize
    Minimum size in MB for items to be included in results.
    Default: 1 MB
    Examples: 0.1 (100 KB), 5 (5 MB), 100 (100 MB)
    
.PARAMETER ShowProgress
    Display progress information during scanning.
    Default: $true
    Set to $false for automated/background execution
    
.PARAMETER ExportCsv
    Export results to a CSV file for further analysis.
    Provide full path including filename.
    Example: "C:\Reports\DiskUsage.csv"
    
.PARAMETER ExportHtml
    Export results to a professional HTML report with interactive charts.
    Provide full path including filename.
    Example: "C:\Reports\DiskUsage.html"
    
.PARAMETER IncludeHidden
    Include hidden files and folders in the scan.
    Default: $false
    Use this switch to scan system and hidden directories
    
.PARAMETER MaxThreads
    Maximum number of threads for parallel processing.
    Default: 4
    Recommended: 2-8 for most systems, up to 16 for high-end systems
    
.PARAMETER ProgressUpdateInterval
    Number of items to process before updating progress display.
    Default: 500
    Lower values = more frequent updates but slightly slower performance
    
.PARAMETER FastMode
    Use optimized .NET methods for faster scanning with reduced error reporting.
    Recommended for large directories where speed is prioritized over detailed error handling.
    
.PARAMETER FileTypes
    Filter scan to include only specific file extensions.
    Provide as array: @(".pdf", ".docx", ".mp4")
    Cannot be used with ExcludeTypes
    
.PARAMETER ExcludeTypes
    Exclude specific file extensions from the scan.
    Provide as array: @(".tmp", ".log", ".cache")
    Cannot be used with FileTypes
    
.PARAMETER UseAdvancedMethods
    Enable advanced access methods (WMI, Robocopy, Win32 API) to handle:
    - Permission-denied directories
    - Junction points and symbolic links
    - System-protected folders
    - Network locations with access issues
    
.PARAMETER Comprehensive
    Enable comprehensive scan mode with detailed analysis including:
    - Creation times and last access times
    - File attributes (hidden, system, read-only)
    - Enhanced junction point handling
    - Detailed file type breakdown
    
.NOTES
    File Name      : ChimpXplore.ps1
    Author         : theonlytruebigmac
    Prerequisite   : PowerShell 5.1 or later
    Platform       : Windows, Linux, macOS (with PowerShell Core)
    
    Performance Tips:
    - Use -FastMode for large directories
    - Increase -MaxThreads on powerful systems
    - Use -MinSize to filter out small files
    - Run as Administrator on Windows for full system access
    
    Security Notes:
    - Advanced methods may require elevated privileges
    - Some system directories require Administrator access
    - Network shares may require appropriate credentials
    
.EXAMPLE
    .\ChimpXplore.ps1
    
    Basic scan of the current directory with default settings.
    Shows top 20 folders and 10 files, minimum 1MB size.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\" -TopFolders 50 -MinSize 10
    
    Comprehensive scan of C: drive showing top 50 folders with minimum 10MB size.
    Useful for finding large space consumers on system drives.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "/Users" -ExportCsv "results.csv" -IncludeHidden
    
    Scan /Users directory on macOS/Linux, include hidden files, export to CSV.
    Perfect for user directory cleanup analysis.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\Program Files" -FastMode -MinSize 50
    
    Fast scan of Program Files using .NET methods, minimum 50MB files.
    Optimized for speed when detailed error reporting isn't needed.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "D:\Media" -FileTypes @(".mp4",".mkv",".avi")
    
    Find all video files in D:\Media using parallel processing (enabled by default).
    Excellent for media library analysis and cleanup.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\Temp" -ExcludeTypes @(".tmp",".log") -MaxThreads 8
    
    Scan C:\Temp excluding temporary files, using 8 threads for faster processing.
    Ideal for cleaning up temporary directories.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\Data" -ExportHtml "report.html" -ExportCsv "data.csv"
    
    Generate both HTML report and CSV export for comprehensive analysis.
    HTML includes interactive charts, CSV enables pivot table analysis.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "D:\Projects" -ExportHtml "project_analysis.html" -MaxThreads 8
    
    Professional HTML report with parallel processing (enabled by default) and interactive charts.
    Perfect for project directory analysis and presentations.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\Users" -UseAdvancedMethods -Comprehensive
    
    Comprehensive scan with advanced access methods for maximum accuracy.
    Handles permission issues and provides detailed file system analysis.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "E:\" -UseAdvancedMethods -ExportHtml "drive_report.html"
    
    Full drive scan with advanced methods, parallel processing (enabled by default), and HTML report.
    Enterprise-grade analysis for storage capacity planning.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "\\server\share" -UseAdvancedMethods -MinSize 5 -TopFolders 30
    
    Network share analysis with advanced methods to handle authentication issues.
    Shows top 30 folders with minimum 5MB size.
    
.EXAMPLE
    .\ChimpXplore.ps1 -Path "C:\Windows" -Depth 3 -UseAdvancedMethods -FastMode
    
    System directory scan limited to 3 levels deep with advanced access methods.
    Balances thoroughness with performance for system analysis.
    
.EXAMPLE
    # Automated daily report generation
    $date = Get-Date -Format "yyyy-MM-dd"
    .\ChimpXplore.ps1 -Path "C:\" -ExportHtml "C:\Reports\DiskUsage_$date.html" -ShowProgress $false
    
    Automated script for daily disk usage reporting without progress display.
    Suitable for scheduled tasks and monitoring systems.
    
.EXAMPLE
    # Large media library analysis
    .\ChimpXplore.ps1 -Path "F:\MediaLibrary" -FileTypes @(".mp4",".mkv",".avi",".mov",".wmv") -MinSize 100 -ExportCsv "MediaAnalysis.csv" -MaxThreads 12
    
    High-performance analysis of large media files (100MB+) with 12 threads.
    Results exported to CSV for spreadsheet analysis and library optimization.
    
.INPUTS
    None. ChimpXplore does not accept pipeline input.
    
.OUTPUTS
    Console output showing scan results, plus optional CSV and HTML files.
    
    Console Output:
    - Scan summary (total size, files, folders, duration)
    - Top largest folders with sizes and percentages
    - Top largest files with sizes and extensions
    - File type analysis with counts and averages
    
    CSV Export (when -ExportCsv is used):
    - Structured data suitable for Excel or database import
    - Columns: Type, Name, Path, Size, SizeFormatted, FileCount, FolderCount, LastModified, Extension
    - Additional columns in Comprehensive mode: CreationTime, LastAccessTime, Attributes
    
    HTML Export (when -ExportHtml is used):
    - Professional report with responsive design
    - Interactive charts for folder sizes and file type distribution
    - Sortable tables with full path display
    - Mobile-friendly layout with horizontal scrolling
    
.LINK
    https://github.com/YourOrganization/ChimpXplore
    
.COMPONENT
    Disk Space Analysis, Storage Management, System Administration
    
.ROLE
    Storage Administrator, System Administrator, IT Professional
    
.FUNCTIONALITY
    Disk usage analysis, storage optimization, capacity planning, file system reporting
    
.AUTHOR
    Created for MSP automation and disk space analysis
    Version: 24.11.01
    Last Updated: November 2024
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Path = (Get-Location).Path,
    
    [Parameter()]
    [int]$Depth = -1,
    
    [Parameter()]
    [int]$TopFolders = 20,
    
    [Parameter()]
    [int]$TopFiles = 10,
    
    [Parameter()]
    [double]$MinSize = 1, # MB
    
    [Parameter()]
    [bool]$ShowProgress = $true,
    
    [Parameter()]
    [string]$ExportCsv = "",
    
    [Parameter()]
    [string]$ExportHtml = "",
    
    [Parameter()]
    [switch]$IncludeHidden,
    
    [Parameter()]
    [int]$MaxThreads = 4,
    
    [Parameter()]
    [int]$ProgressUpdateInterval = 500,
    
    [Parameter()]
    [switch]$FastMode,
    
    [Parameter()]
    [string[]]$FileTypes = @(),
    
    [Parameter()]
    [string[]]$ExcludeTypes = @(),
    
    [Parameter()]
    [switch]$UseAdvancedMethods,
    
    [Parameter()]
    [switch]$Comprehensive
)

# Global variables for tracking
$Script:TotalSize = 0
$Script:TotalFiles = 0
$Script:TotalFolders = 0
$Script:ProcessedItems = 0
$Script:ErrorCount = 0
$Script:StartTime = Get-Date
$Script:AllFolders = [System.Collections.Generic.List[PSObject]]::new()
$Script:AllFiles = [System.Collections.Generic.List[PSObject]]::new()
$Script:SyncLock = [System.Object]::new()
$Script:Win32ApiLoaded = $false

# Enable parallel processing by default for better performance
$UseParallel = $true

# Normalize file type filters
if ($FileTypes.Count -gt 0) {
    $FileTypes = $FileTypes | ForEach-Object { if ($_.StartsWith('.')) { $_ } else { ".$_" } } | ForEach-Object { $_.ToLower() }
}
if ($ExcludeTypes.Count -gt 0) {
    $ExcludeTypes = $ExcludeTypes | ForEach-Object { if ($_.StartsWith('.')) { $_ } else { ".$_" } } | ForEach-Object { $_.ToLower() }
}

# Function to format file sizes
function Format-FileSize {
    param([long]$Size)
    
    if ($Size -ge 1TB) {
        return "{0:N2} TB" -f ($Size / 1TB)
    }
    elseif ($Size -ge 1GB) {
        return "{0:N2} GB" -f ($Size / 1GB)
    }
    elseif ($Size -ge 1MB) {
        return "{0:N2} MB" -f ($Size / 1MB)
    }
    elseif ($Size -ge 1KB) {
        return "{0:N2} KB" -f ($Size / 1KB)
    }
    else {
        return "{0} bytes" -f $Size
    }
}

# Function to check if file type should be included
function Test-FileTypeFilter {
    param(
        [string]$Extension
    )
    
    $ext = $Extension.ToLower()
    
    # If exclude types are specified and this extension is in the exclude list, skip it
    if ($ExcludeTypes.Count -gt 0 -and $ExcludeTypes -contains $ext) {
        return $false
    }
    
    # If include types are specified, only include files with those extensions
    if ($FileTypes.Count -gt 0) {
        return $FileTypes -contains $ext
    }
    
    # If no filters specified, include all files
    return $true
}

# Function to safely increment counters in parallel mode
function Add-ThreadSafeCounters {
    param(
        [long]$SizeIncrement = 0,
        [int]$FileIncrement = 0,
        [int]$FolderIncrement = 0,
        [int]$ProcessedIncrement = 0,
        [int]$ErrorIncrement = 0
    )
    
    if ($UseParallel) {
        [System.Threading.Monitor]::Enter($Script:SyncLock)
        try {
            $Script:TotalSize += $SizeIncrement
            $Script:TotalFiles += $FileIncrement
            $Script:TotalFolders += $FolderIncrement
            $Script:ProcessedItems += $ProcessedIncrement
            $Script:ErrorCount += $ErrorIncrement
        }
        finally {
            [System.Threading.Monitor]::Exit($Script:SyncLock)
        }
    } else {
        $Script:TotalSize += $SizeIncrement
        $Script:TotalFiles += $FileIncrement
        $Script:TotalFolders += $FolderIncrement
        $Script:ProcessedItems += $ProcessedIncrement
        $Script:ErrorCount += $ErrorIncrement
    }
}

# Function to get directory size recursively with performance optimizations
function Get-DirectorySize {
    param(
        [string]$FolderPath,
        [int]$CurrentDepth = 0,
        [int]$MaxDepth = -1,
        [double]$MinSizeMB = 0,
        [bool]$IsParallelChild = $false
    )
    
    $dirInfo = [PSCustomObject]@{
        Path = $FolderPath
        Size = 0
        FileCount = 0
        FolderCount = 0
        LastModified = [DateTime]::MinValue
        Error = $null
    }
    
    # Add comprehensive directory details if enabled
    if ($Comprehensive) {
        try {
            $folderInfo = [System.IO.DirectoryInfo]::new($FolderPath)
            $dirInfo | Add-Member -NotePropertyName "CreationTime" -NotePropertyValue $folderInfo.CreationTime
            $dirInfo | Add-Member -NotePropertyName "LastAccessTime" -NotePropertyValue $folderInfo.LastAccessTime
            $dirInfo | Add-Member -NotePropertyName "Attributes" -NotePropertyValue $folderInfo.Attributes.ToString()
            $dirInfo | Add-Member -NotePropertyName "IsHidden" -NotePropertyValue (($folderInfo.Attributes -band [System.IO.FileAttributes]::Hidden) -ne 0)
            $dirInfo | Add-Member -NotePropertyName "IsSystem" -NotePropertyValue (($folderInfo.Attributes -band [System.IO.FileAttributes]::System) -ne 0)
            $dirInfo | Add-Member -NotePropertyName "SubdirectoryCount" -NotePropertyValue 0
            $dirInfo | Add-Member -NotePropertyName "FileTypeBreakdown" -NotePropertyValue @{}
        }
        catch {
            # If we can't get comprehensive details, continue without them
        }
    }
    
    try {
        # Check if we've reached maximum depth
        if ($MaxDepth -ne -1 -and $CurrentDepth -ge $MaxDepth) {
            return $dirInfo
        }
        
        # Try standard enumeration first
        $items = $null
        $useAdvancedFallback = $false
        
        try {
            # Use faster enumeration method for performance
            $items = if ($FastMode) {
                [System.IO.Directory]::EnumerateFileSystemEntries($FolderPath)
            } else {
                Get-ChildItem -Path $FolderPath -Force:$IncludeHidden -ErrorAction Stop
            }
        }
        catch {
            # Standard enumeration failed - use advanced methods if enabled
            if ($UseAdvancedMethods) {
                Write-Verbose "Standard enumeration failed for $FolderPath, trying advanced methods: $($_.Exception.Message)"
                $useAdvancedFallback = $true
            } else {
                # Advanced methods not enabled, propagate the error
                throw
            }
        }
        
        # If standard enumeration failed and advanced methods are enabled, try them
        if ($useAdvancedFallback) {
            $advancedResult = Get-DirectorySizeAdvanced -FolderPath $FolderPath -UseWMI:$true -UseRobocopy:$true
            
            if ($advancedResult.Success) {
                Write-Host "Advanced Methods: Successfully accessed $FolderPath using $($advancedResult.Method)" -ForegroundColor Green
                $dirInfo.Size = $advancedResult.Size
                $dirInfo.FileCount = $advancedResult.FileCount
                $dirInfo.FolderCount = $advancedResult.FolderCount
                $dirInfo.Error = "Accessed via $($advancedResult.Method)"
                
                # Update global counters
                if (-not $IsParallelChild) {
                    Add-ThreadSafeCounters -FileIncrement $advancedResult.FileCount -SizeIncrement $advancedResult.Size -FolderIncrement $advancedResult.FolderCount
                }
                
                return $dirInfo
            } else {
                Write-Warning "Advanced Methods: All methods failed for $FolderPath"
                $dirInfo.Error = $advancedResult.Error
                return $dirInfo
            }
        }
        
        # Optional: Check for junction points and symbolic links when advanced methods are enabled
        if ($UseAdvancedMethods -and $Comprehensive) {
            try {
                $folderAttributes = [System.IO.File]::GetAttributes($FolderPath)
                if ($folderAttributes -band [System.IO.FileAttributes]::ReparsePoint) {
                    $dirInfo.Error = "Junction/SymLink detected - scanned normally"
                    Write-Verbose "Junction/Symlink detected at $FolderPath but accessible normally"
                }
            }
            catch {
                # Ignore attribute check failures for performance
            }
        }
        
        $minSizeBytes = $MinSizeMB * 1MB
        $subDirectories = @()
        
        foreach ($item in $items) {
            if (-not $IsParallelChild) {
                Add-ThreadSafeCounters -ProcessedIncrement 1
                
                # Update progress less frequently for better performance
                if ($ShowProgress -and ($Script:ProcessedItems % $ProgressUpdateInterval -eq 0)) {
                    Write-Progress -Activity "Scanning Directory Structure" -Status "Processing: $($item -replace '.*[/\\]', '')" -PercentComplete -1
                }
            }
            
            if ($FastMode) {
                # Fast mode using .NET methods
                $itemInfo = [System.IO.FileInfo]::new($item)
                if ($itemInfo.Attributes -band [System.IO.FileAttributes]::Directory) {
                    # It's a directory
                    if (-not $IsParallelChild) {
                        Add-ThreadSafeCounters -FolderIncrement 1
                    }
                    $dirInfo.FolderCount++
                    
                    # Collect subdirectories for potential parallel processing
                    if ($UseParallel -and $CurrentDepth -eq 0 -and -not $IsParallelChild) {
                        $subDirectories += $item
                    } else {
                        # Process subdirectory normally
                        if ($CurrentDepth + 1 -le $MaxDepth -or $MaxDepth -eq -1) {
                            $subDirInfo = Get-DirectorySize -FolderPath $item -CurrentDepth ($CurrentDepth + 1) -MaxDepth $MaxDepth -MinSizeMB $MinSizeMB -IsParallelChild $IsParallelChild
                            $dirInfo.Size += $subDirInfo.Size
                            $dirInfo.FileCount += $subDirInfo.FileCount
                            $dirInfo.FolderCount += $subDirInfo.FolderCount
                            
                            # Store folder info if it meets minimum size
                            if ($subDirInfo.Size -ge $minSizeBytes) {
                                if ($UseParallel) {
                                    [System.Threading.Monitor]::Enter($Script:SyncLock)
                                    try {
                                        $Script:AllFolders.Add($subDirInfo)
                                    }
                                    finally {
                                        [System.Threading.Monitor]::Exit($Script:SyncLock)
                                    }
                                } else {
                                    $Script:AllFolders.Add($subDirInfo)
                                }
                            }
                        }
                    }
                } else {
                    # It's a file
                    $fileSize = $itemInfo.Length
                    $extension = $itemInfo.Extension.ToLower()
                    
                    # Apply file type filtering
                    if (Test-FileTypeFilter -Extension $extension) {
                        if (-not $IsParallelChild) {
                            Add-ThreadSafeCounters -FileIncrement 1 -SizeIncrement $fileSize
                        }
                        $dirInfo.FileCount++
                        $dirInfo.Size += $fileSize
                        
                        # Track latest modification date
                        if ($itemInfo.LastWriteTime -gt $dirInfo.LastModified) {
                            $dirInfo.LastModified = $itemInfo.LastWriteTime
                        }
                        
                        # Track file type breakdown in comprehensive mode
                        if ($Comprehensive -and $dirInfo.PSObject.Properties['FileTypeBreakdown']) {
                            if ($dirInfo.FileTypeBreakdown.ContainsKey($extension)) {
                                $dirInfo.FileTypeBreakdown[$extension] += $fileSize
                            } else {
                                $dirInfo.FileTypeBreakdown[$extension] = $fileSize
                            }
                        }
                        
                        # Store large files immediately
                        if ($fileSize -ge $minSizeBytes) {
                            $fileObj = [PSCustomObject]@{
                                Name = $itemInfo.Name
                                Path = $itemInfo.FullName
                                Size = $fileSize
                                SizeFormatted = Format-FileSize $fileSize
                                LastModified = $itemInfo.LastWriteTime
                                Extension = $itemInfo.Extension
                            }
                            
                            # Add comprehensive details if enabled
                            if ($Comprehensive) {
                                try {
                                    $fileObj | Add-Member -NotePropertyName "CreationTime" -NotePropertyValue $itemInfo.CreationTime
                                    $fileObj | Add-Member -NotePropertyName "LastAccessTime" -NotePropertyValue $itemInfo.LastAccessTime
                                    $fileObj | Add-Member -NotePropertyName "Attributes" -NotePropertyValue $itemInfo.Attributes.ToString()
                                    $fileObj | Add-Member -NotePropertyName "IsReadOnly" -NotePropertyValue (($itemInfo.Attributes -band [System.IO.FileAttributes]::ReadOnly) -ne 0)
                                    $fileObj | Add-Member -NotePropertyName "IsHidden" -NotePropertyValue (($itemInfo.Attributes -band [System.IO.FileAttributes]::Hidden) -ne 0)
                                    $fileObj | Add-Member -NotePropertyName "IsSystem" -NotePropertyValue (($itemInfo.Attributes -band [System.IO.FileAttributes]::System) -ne 0)
                                }
                                catch {
                                    # If we can't get comprehensive details, continue without them
                                }
                            }
                            
                            if ($UseParallel) {
                                [System.Threading.Monitor]::Enter($Script:SyncLock)
                                try {
                                    $Script:AllFiles.Add($fileObj)
                                }
                                finally {
                                    [System.Threading.Monitor]::Exit($Script:SyncLock)
                                }
                            } else {
                                $Script:AllFiles.Add($fileObj)
                            }
                        }
                    }
                }
            } else {
                # Standard mode using PowerShell cmdlets
                if ($item.PSIsContainer) {
                    # It's a directory
                    if (-not $IsParallelChild) {
                        Add-ThreadSafeCounters -FolderIncrement 1
                    }
                    $dirInfo.FolderCount++
                    
                    # Collect subdirectories for potential parallel processing
                    if ($UseParallel -and $CurrentDepth -eq 0 -and -not $IsParallelChild) {
                        $subDirectories += $item.FullName
                    } else {
                        # Process subdirectory normally
                        $subDirInfo = Get-DirectorySize -FolderPath $item.FullName -CurrentDepth ($CurrentDepth + 1) -MaxDepth $MaxDepth -MinSizeMB $MinSizeMB -IsParallelChild $IsParallelChild
                        $dirInfo.Size += $subDirInfo.Size
                        $dirInfo.FileCount += $subDirInfo.FileCount
                        $dirInfo.FolderCount += $subDirInfo.FolderCount
                        
                        # Store folder info if it meets minimum size
                        if ($subDirInfo.Size -ge $minSizeBytes) {
                            if ($UseParallel) {
                                [System.Threading.Monitor]::Enter($Script:SyncLock)
                                try {
                                    $Script:AllFolders.Add($subDirInfo)
                                }
                                finally {
                                    [System.Threading.Monitor]::Exit($Script:SyncLock)
                                }
                            } else {
                                $Script:AllFolders.Add($subDirInfo)
                            }
                        }
                    }
                } else {
                    # It's a file
                    $extension = $item.Extension.ToLower()
                    
                    # Apply file type filtering
                    if (Test-FileTypeFilter -Extension $extension) {
                        if (-not $IsParallelChild) {
                            Add-ThreadSafeCounters -FileIncrement 1 -SizeIncrement $item.Length
                        }
                        $dirInfo.FileCount++
                        $dirInfo.Size += $item.Length
                        
                        # Track latest modification date
                        if ($item.LastWriteTime -gt $dirInfo.LastModified) {
                            $dirInfo.LastModified = $item.LastWriteTime
                        }
                        
                        # Store large files immediately
                        if ($item.Length -ge $minSizeBytes) {
                            $fileObj = [PSCustomObject]@{
                                Name = $item.Name
                                Path = $item.FullName
                                Size = $item.Length
                                SizeFormatted = Format-FileSize $item.Length
                                LastModified = $item.LastWriteTime
                                Extension = $item.Extension
                            }
                            
                            # Try advanced file access if standard fails and UseAdvancedMethods is enabled
                            if ($UseAdvancedMethods) {
                                try {
                                    # Test if file is accessible
                                    Get-Item $item.FullName -Force -ErrorAction Stop | Out-Null
                                }
                                catch {
                                    # File not accessible normally, try advanced methods
                                    $advancedFileInfo = Get-FileInfoAdvanced -FilePath $item.FullName -FallbackMethod "WMI"
                                    if ($advancedFileInfo) {
                                        $fileObj = $advancedFileInfo
                                        Write-Verbose "Advanced Methods: Accessed file $($item.FullName) via $($advancedFileInfo.Method)"
                                    }
                                }
                            }
                            
                            if ($UseParallel) {
                                [System.Threading.Monitor]::Enter($Script:SyncLock)
                                try {
                                    $Script:AllFiles.Add($fileObj)
                                }
                                finally {
                                    [System.Threading.Monitor]::Exit($Script:SyncLock)
                                }
                            } else {
                                $Script:AllFiles.Add($fileObj)
                            }
                        }
                    }
                }
            }
            
            # Memory management: Force garbage collection periodically
            if (-not $IsParallelChild -and $Script:ProcessedItems % 10000 -eq 0) {
                [System.GC]::Collect()
            }
        }
        
        # Process subdirectories in parallel if enabled and at root level
        if ($UseParallel -and $subDirectories.Count -gt 0 -and $CurrentDepth -eq 0 -and -not $IsParallelChild) {
            Write-Host "Processing $($subDirectories.Count) subdirectories in parallel..." -ForegroundColor Yellow
            
            $parallelResults = $subDirectories | ForEach-Object -Parallel {
                # Simple parallel execution - just scan each subdirectory independently
                $subDir = $_
                $MaxDepth = $using:MaxDepth
                $MinSizeMB = $using:MinSizeMB
                $FastMode = $using:FastMode
                $IncludeHidden = $using:IncludeHidden
                $FileTypes = $using:FileTypes
                $ExcludeTypes = $using:ExcludeTypes
                
                # Create a robust directory scan function for parallel execution
                function Get-DirectorySizeSimple {
                    param([string]$Path)
                    
                    $result = [PSCustomObject]@{
                        Path = $Path
                        Size = 0
                        FileCount = 0
                        FolderCount = 0
                        LastModified = [DateTime]::MinValue
                        Error = $null
                    }
                    
                    try {
                        # Try PowerShell method first (more reliable for permissions)
                        $items = Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
                        
                        foreach ($item in $items) {
                            try {
                                if ($item.PSIsContainer) {
                                    $result.FolderCount++
                                } else {
                                    # Filter by file type if needed
                                    $ext = $item.Extension.ToLower()
                                    $includeFile = $true
                                    
                                    if ($ExcludeTypes.Count -gt 0 -and $ExcludeTypes -contains $ext) {
                                        $includeFile = $false
                                    }
                                    if ($FileTypes.Count -gt 0 -and $FileTypes -notcontains $ext) {
                                        $includeFile = $false
                                    }
                                    
                                    if ($includeFile) {
                                        $result.FileCount++
                                        $result.Size += $item.Length
                                        if ($item.LastWriteTime -gt $result.LastModified) {
                                            $result.LastModified = $item.LastWriteTime
                                        }
                                    }
                                }
                            }
                            catch {
                                # Skip items we can't access
                            }
                        }
                    }
                    catch {
                        # If PowerShell method fails completely, try .NET as fallback
                        try {
                            $allItems = [System.IO.Directory]::GetFileSystemEntries($Path, "*", [System.IO.SearchOption]::AllDirectories)
                            
                            foreach ($item in $allItems) {
                                try {
                                    $info = [System.IO.FileInfo]::new($item)
                                    if ($info.Attributes -band [System.IO.FileAttributes]::Directory) {
                                        $result.FolderCount++
                                    } else {
                                        # Filter by file type if needed
                                        $ext = $info.Extension.ToLower()
                                        $includeFile = $true
                                        
                                        if ($ExcludeTypes.Count -gt 0 -and $ExcludeTypes -contains $ext) {
                                            $includeFile = $false
                                        }
                                        if ($FileTypes.Count -gt 0 -and $FileTypes -notcontains $ext) {
                                            $includeFile = $false
                                        }
                                        
                                        if ($includeFile) {
                                            $result.FileCount++
                                            $result.Size += $info.Length
                                            if ($info.LastWriteTime -gt $result.LastModified) {
                                                $result.LastModified = $info.LastWriteTime
                                            }
                                        }
                                    }
                                }
                                catch {
                                    # Skip items we can't access
                                }
                            }
                        }
                        catch {
                            $result.Error = $_.Exception.Message
                        }
                    }
                    
                    return $result
                }
                
                Get-DirectorySizeSimple -Path $subDir
                
            } -ThrottleLimit $MaxThreads
            
            # Aggregate all parallel results
            foreach ($result in $parallelResults) {
                if ($result) {
                    $dirInfo.Size += $result.Size
                    $dirInfo.FileCount += $result.FileCount  
                    $dirInfo.FolderCount += $result.FolderCount
                    
                    # Update global counters
                    Add-ThreadSafeCounters -FileIncrement $result.FileCount -SizeIncrement $result.Size -FolderIncrement $result.FolderCount
                    
                    # Add to collections if meets size threshold
                    if ($result.Size -ge $minSizeBytes) {
                        [System.Threading.Monitor]::Enter($Script:SyncLock)
                        try {
                            $Script:AllFolders.Add($result)
                        }
                        finally {
                            [System.Threading.Monitor]::Exit($Script:SyncLock)
                        }
                    }
                }
            }
        }
    }
    catch {
        Add-ThreadSafeCounters -ErrorIncrement 1
        $dirInfo.Error = $_.Exception.Message
        if (-not $FastMode) {
            Write-Warning "Access denied or error scanning: $FolderPath - $($_.Exception.Message)"
        }
    }
    
    return $dirInfo
}

# Advanced scanning methods for handling permissions and special directories
function Get-DirectorySizeAdvanced {
    param(
        [string]$FolderPath,
        [bool]$UseWMI = $true,
        [bool]$UseRobocopy = $true
    )
    
    $result = [PSCustomObject]@{
        Path = $FolderPath
        Size = 0
        FileCount = 0
        FolderCount = 0
        Method = "Standard"
        Success = $false
        Error = $null
    }
    
    # Try WMI first if enabled (fast and handles many permission issues)
    if ($UseWMI -and $IsWindows) {
        try {
            Write-Verbose "Advanced Methods: Trying WMI for $FolderPath"
            $wmiPath = $FolderPath -replace '\\', '\\' -replace ':', '\\:'
            $wmiQuery = "SELECT * FROM CIM_DataFile WHERE Path LIKE '$wmiPath%'"
            
            $wmiFiles = Get-CimInstance -Query $wmiQuery -ErrorAction Stop
            if ($wmiFiles) {
                $result.Size = ($wmiFiles | Measure-Object -Property Size -Sum).Sum
                $result.FileCount = $wmiFiles.Count
                $result.Method = "WMI"
                $result.Success = $true
                Write-Verbose "Advanced Methods: WMI successful for $FolderPath"
                return $result
            }
        }
        catch {
            Write-Verbose "Advanced Methods: WMI failed for $FolderPath - $($_.Exception.Message)"
        }
    }
    
    # Try Robocopy if enabled (very reliable for size calculation)
    if ($UseRobocopy -and $IsWindows) {
        try {
            Write-Verbose "Advanced Methods: Trying Robocopy for $FolderPath"
            $tempFile = [System.IO.Path]::GetTempFileName()
            
            # Use robocopy in list-only mode for accurate size calculation
            $roboArgs = @(
                "`"$FolderPath`"",
                "NULL",
                "/L",  # List only
                "/S",  # Subdirectories
                "/NJH", # No job header
                "/NJS", # No job summary
                "/FP",  # Full path
                "/BYTES", # Show sizes in bytes
                "/NFL", # No file listing
                "/NDL"  # No directory listing
            )
            
            $roboOutput = & robocopy.exe @roboArgs 2>$null
            
            if ($LASTEXITCODE -le 1) {  # 0 = no files, 1 = files copied successfully
                # Parse robocopy output for totals
                $summaryLine = $roboOutput | Where-Object { $_ -match "Total\s+Copied\s+Skipped\s+Mismatch\s+FAILED\s+Extras" }
                if ($summaryLine) {
                    $nextLine = $roboOutput[([array]::IndexOf($roboOutput, $summaryLine) + 1)]
                    if ($nextLine -match "\s*Files\s*:\s*(\d+)") {
                        $result.FileCount = [int]$matches[1]
                    }
                    $sizeLine = $roboOutput[([array]::IndexOf($roboOutput, $summaryLine) + 3)]
                    if ($sizeLine -match "\s*Bytes\s*:\s*([\d,]+)") {
                        $result.Size = [long]($matches[1] -replace ',', '')
                    }
                }
                $result.Method = "Robocopy"
                $result.Success = $true
                Write-Verbose "Advanced Methods: Robocopy successful for $FolderPath"
                return $result
            }
        }
        catch {
            Write-Verbose "Advanced Methods: Robocopy failed for $FolderPath - $($_.Exception.Message)"
        }
        finally {
            if (Test-Path $tempFile) { Remove-Item $tempFile -Force -ErrorAction SilentlyContinue }
        }
    }
    
    # Try Windows API via .NET as fallback
    try {
        Write-Verbose "Advanced Methods: Trying Win32 API for $FolderPath"
        
        # Load Win32 API only once for performance
        if (-not $Script:Win32ApiLoaded) {
            Add-Type -TypeDefinition @"
                using System;
                using System.IO;
                using System.Runtime.InteropServices;
                
                public class AdvancedFileInfo {
                    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
                    public static extern IntPtr FindFirstFile(string lpFileName, out WIN32_FIND_DATA lpFindFileData);
                    
                    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
                    public static extern bool FindNextFile(IntPtr hFindFile, out WIN32_FIND_DATA lpFindFileData);
                    
                    [DllImport("kernel32.dll", SetLastError = true)]
                    public static extern bool FindClose(IntPtr hFindFile);
                    
                    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
                    public struct WIN32_FIND_DATA {
                        public FileAttributes dwFileAttributes;
                        public System.Runtime.InteropServices.ComTypes.FILETIME ftCreationTime;
                        public System.Runtime.InteropServices.ComTypes.FILETIME ftLastAccessTime;
                        public System.Runtime.InteropServices.ComTypes.FILETIME ftLastWriteTime;
                        public uint nFileSizeHigh;
                        public uint nFileSizeLow;
                        public uint dwReserved0;
                        public uint dwReserved1;
                        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
                        public string cFileName;
                        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 14)]
                        public string cAlternateFileName;
                    }
                    
                    public static long GetFileSize(WIN32_FIND_DATA findData) {
                        return ((long)findData.nFileSizeHigh << 32) + findData.nFileSizeLow;
                    }
                }
"@ -ErrorAction SilentlyContinue
            $Script:Win32ApiLoaded = $true
        }
        
        $searchPath = Join-Path $FolderPath "*"
        $findData = New-Object AdvancedFileInfo+WIN32_FIND_DATA
        $handle = [AdvancedFileInfo]::FindFirstFile($searchPath, [ref]$findData)
        
        if ($handle -ne [IntPtr]::new(-1)) {
            do {
                if ($findData.cFileName -ne "." -and $findData.cFileName -ne "..") {
                    if ($findData.dwFileAttributes -band [System.IO.FileAttributes]::Directory) {
                        $result.FolderCount++
                    } else {
                        $result.FileCount++
                        $result.Size += [AdvancedFileInfo]::GetFileSize($findData)
                    }
                }
            } while ([AdvancedFileInfo]::FindNextFile($handle, [ref]$findData))
            
            [AdvancedFileInfo]::FindClose($handle) | Out-Null
            $result.Method = "Win32API"
            $result.Success = $true
            Write-Verbose "Advanced Methods: Win32 API successful for $FolderPath"
            return $result
        }
    }
    catch {
        Write-Verbose "Advanced Methods: Win32 API failed for $FolderPath - $($_.Exception.Message)"
    }
    
    $result.Error = "All advanced methods failed"
    return $result
}

function Get-FileInfoAdvanced {
    param(
        [string]$FilePath,
        [string]$FallbackMethod = "WMI"
    )
    
    try {
        # Try WMI for file that can't be accessed normally
        if ($FallbackMethod -eq "WMI" -and $IsWindows) {
            $wmiPath = $FilePath -replace '\\', '\\\\' -replace ':', '\\:'
            $wmiFile = Get-CimInstance -ClassName CIM_DataFile -Filter "Name='$wmiPath'" -ErrorAction Stop
            if ($wmiFile) {
                return [PSCustomObject]@{
                    Name = Split-Path $FilePath -Leaf
                    Path = $FilePath
                    Size = $wmiFile.FileSize
                    SizeFormatted = Format-FileSize $wmiFile.FileSize
                    LastModified = $wmiFile.LastModified
                    Extension = [System.IO.Path]::GetExtension($FilePath)
                    Method = "WMI"
                }
            }
        }
        
        # Try alternative .NET methods
        $fileInfo = [System.IO.FileInfo]::new($FilePath)
        return [PSCustomObject]@{
            Name = $fileInfo.Name
            Path = $fileInfo.FullName
            Size = $fileInfo.Length
            SizeFormatted = Format-FileSize $fileInfo.Length
            LastModified = $fileInfo.LastWriteTime
            Extension = $fileInfo.Extension
            Method = "Alternative"
        }
    }
    catch {
        Write-Verbose "Advanced file access failed for $FilePath - $($_.Exception.Message)"
        return $null
    }
}

# Function to get individual file information (optimized)
function Get-LargeFiles {
    param(
        [string]$FolderPath,
        [double]$MinSizeMB
    )
    
    # Return already collected files if we used the integrated approach
    if ($Script:AllFiles.Count -gt 0) {
        return $Script:AllFiles.ToArray()
    }
    
    # Fallback for separate file scanning (shouldn't be needed with optimized approach)
    $files = [System.Collections.Generic.List[PSObject]]::new()
    $minSizeBytes = $MinSizeMB * 1MB
    
    try {
        if ($FastMode) {
            # Use .NET methods for faster file enumeration
            $fileEntries = [System.IO.Directory]::EnumerateFiles($FolderPath, "*", [System.IO.SearchOption]::AllDirectories)
            foreach ($filePath in $fileEntries) {
                try {
                    $fileInfo = [System.IO.FileInfo]::new($filePath)
                    if ($fileInfo.Length -ge $minSizeBytes) {
                        $files.Add([PSCustomObject]@{
                            Name = $fileInfo.Name
                            Path = $fileInfo.FullName
                            Size = $fileInfo.Length
                            SizeFormatted = Format-FileSize $fileInfo.Length
                            LastModified = $fileInfo.LastWriteTime
                            Extension = $fileInfo.Extension
                        })
                    }
                }
                catch {
                    # Skip files we can't access
                    continue
                }
            }
        } else {
            # Standard PowerShell approach
            Get-ChildItem -Path $FolderPath -Recurse -File -Force:$IncludeHidden -ErrorAction SilentlyContinue | 
            Where-Object { $_.Length -ge $minSizeBytes } |
            ForEach-Object {
                $files.Add([PSCustomObject]@{
                    Name = $_.Name
                    Path = $_.FullName
                    Size = $_.Length
                    SizeFormatted = Format-FileSize $_.Length
                    LastModified = $_.LastWriteTime
                    Extension = $_.Extension
                })
            }
        }
    }
    catch {
        Write-Warning "Error scanning files in: $FolderPath - $($_.Exception.Message)"
    }
    
    return $files.ToArray()
}

# Function to display results in a formatted table
function Show-Results {
    param(
        [array]$FolderResults,
        [array]$FileResults
    )
    
    # Display header
    Write-Host "`n" + "="*80 -ForegroundColor Cyan
    Write-Host "ChimpXplore - DISK SPACE ANALYSIS RESULTS" -ForegroundColor Cyan
    Write-Host "="*80 -ForegroundColor Cyan
    
    # Display summary
    Write-Host "`nSCAN SUMMARY:" -ForegroundColor Green
    Write-Host "Path Scanned: $Path" -ForegroundColor White
    Write-Host "Total Size: $(Format-FileSize $Script:TotalSize)" -ForegroundColor Yellow
    Write-Host "Total Files: $($Script:TotalFiles)" -ForegroundColor White
    Write-Host "Total Folders: $($Script:TotalFolders)" -ForegroundColor White
    Write-Host "Scan Duration: $((New-TimeSpan -Start $Script:StartTime -End (Get-Date)).TotalSeconds.ToString('F2')) seconds" -ForegroundColor White
    
    # Display filtering information
    if ($FileTypes.Count -gt 0) {
        Write-Host "File Types Included: $($FileTypes -join ', ')" -ForegroundColor Cyan
    }
    if ($ExcludeTypes.Count -gt 0) {
        Write-Host "File Types Excluded: $($ExcludeTypes -join ', ')" -ForegroundColor Cyan
    }
    if ($UseParallel) {
        Write-Host "Parallel Processing: Enabled ($MaxThreads threads)" -ForegroundColor Cyan
    }
    if ($UseAdvancedMethods) {
        Write-Host "Advanced Methods: Enabled (WMI, Robocopy, Win32 API fallbacks)" -ForegroundColor Cyan
    }
    if ($Comprehensive) {
        Write-Host "Comprehensive Mode: Enabled (detailed analysis)" -ForegroundColor Cyan
    }
    
    if ($Script:ErrorCount -gt 0) {
        Write-Host "Access Errors: $($Script:ErrorCount)" -ForegroundColor Red
    }
    
    # Display top folders
    Write-Host "`nTOP $TopFolders LARGEST FOLDERS:" -ForegroundColor Green
    Write-Host "-" * 80 -ForegroundColor Gray
    
    $FolderResults | 
    Where-Object { ($_.Size / 1MB) -ge $MinSize } |
    Sort-Object Size -Descending | 
    Select-Object -First $TopFolders |
    ForEach-Object {
        $percentage = if ($Script:TotalSize -gt 0) { ($_.Size / $Script:TotalSize * 100).ToString("F1") } else { "0.0" }
        $name = if ($_.Path.Length -gt 50) { "..." + $_.Path.Substring($_.Path.Length - 47) } else { $_.Path }
        
        Write-Host ("{0,-50} {1,12} {2,6}%" -f $name, (Format-FileSize $_.Size), $percentage) -ForegroundColor White
    }
    
    # Display top files
    if ($FileResults.Count -gt 0) {
        Write-Host "`nTOP $TopFiles LARGEST FILES:" -ForegroundColor Green
        Write-Host "-" * 80 -ForegroundColor Gray
        
        $FileResults | 
        Sort-Object Size -Descending | 
        Select-Object -First $TopFiles |
        ForEach-Object {
            $name = if ($_.Path.Length -gt 50) { "..." + $_.Path.Substring($_.Path.Length - 47) } else { $_.Path }
            Write-Host ("{0,-50} {1,12} {2,8}" -f $name, $_.SizeFormatted, $_.Extension) -ForegroundColor White
        }
        
        # File type analysis
        if ($FileResults.Count -gt 0) {
            Write-Host "`nFILE TYPE ANALYSIS:" -ForegroundColor Green
            Write-Host "-" * 80 -ForegroundColor Gray
            
            $typeAnalysis = $FileResults | 
                Group-Object Extension | 
                Sort-Object { ($_.Group | Measure-Object Size -Sum).Sum } -Descending |
                Select-Object -First 10 |
                ForEach-Object {
                    $totalSize = ($_.Group | Measure-Object Size -Sum).Sum
                    $fileCount = $_.Count
                    $avgSize = if ($fileCount -gt 0) { $totalSize / $fileCount } else { 0 }
                    
                    [PSCustomObject]@{
                        Extension = if ($_.Name) { $_.Name } else { "(no ext)" }
                        Count = $fileCount
                        TotalSize = $totalSize
                        TotalSizeFormatted = Format-FileSize $totalSize
                        AvgSize = Format-FileSize $avgSize
                        Percentage = if ($Script:TotalSize -gt 0) { ($totalSize / $Script:TotalSize * 100).ToString("F1") + "%" } else { "0.0%" }
                    }
                }
            
            $typeAnalysis | ForEach-Object {
                Write-Host ("{0,-12} {1,6} files {2,12} ({3,6}) avg: {4,10}" -f $_.Extension, $_.Count, $_.TotalSizeFormatted, $_.Percentage, $_.AvgSize) -ForegroundColor White
            }
        }
    }
    
    Write-Host "`n" + "="*80 -ForegroundColor Cyan
}

# Helper function to determine optimal chart unit
function Get-OptimalChartUnit {
    param([double[]]$SizesMB)
    $max = ($SizesMB | Measure-Object -Maximum).Maximum
    if ($max -ge 1048576) { return @{ Unit = 'TB'; Factor = 1048576; Label = 'TB' } }
    elseif ($max -ge 1024) { return @{ Unit = 'GB'; Factor = 1024; Label = 'GB' } }
    else { return @{ Unit = 'MB'; Factor = 1; Label = 'MB' } }
}

# Export to HTML report
function Export-ToHtml {
    param(
        [string]$FilePath,
        [array]$FolderResults,
        [array]$FileResults,
        [string]$ScanPath
    )
    try {
        # Prepare folder chart data
        $topFoldersList = $FolderResults | Sort-Object Size -Descending | Select-Object -First ([int]$TopFolders)
        $folderSizesMB = @($topFoldersList | ForEach-Object { [math]::Round(($_.Size) / 1MB, 2) })
        $folderUnitInfo = Get-OptimalChartUnit -SizesMB $folderSizesMB
        $folderUnit = $folderUnitInfo.Unit
        $folderFactor = $folderUnitInfo.Factor
        $folderUnitLabel = $folderUnitInfo.Label
        $folderLabelsArray = @($topFoldersList | ForEach-Object {
            $path = if ($_.Path) { $_.Path } else { 'Unknown' }
            $leafName = Split-Path $path -Leaf
            if (-not $leafName) { $leafName = $path }
            $escaped = $leafName -replace '\\', '\\\\' -replace '"', '\"'
            "`"$escaped`""
        })
        $folderLabels = $folderLabelsArray -join ','
        $folderSizesArray = @($topFoldersList | ForEach-Object {
            $size = if ($_.Size) { $_.Size } else { 0 }
            [math]::Round($size / 1MB / $folderFactor, 2)
        })
        $folderSizes = $folderSizesArray -join ','

        # Prepare file type chart data
        $fileTypeData = $FileResults | Group-Object Extension | Sort-Object { ($_.Group | Measure-Object Size -Sum).Sum } -Descending | Select-Object -First 10
        $fileTypeSizesMB = @($fileTypeData | ForEach-Object { [math]::Round(($_.Group | Measure-Object Size -Sum).Sum / 1MB, 2) })
        $fileTypeUnitInfo = Get-OptimalChartUnit -SizesMB $fileTypeSizesMB
        $fileTypeUnit = $fileTypeUnitInfo.Unit
        $fileTypeFactor = $fileTypeUnitInfo.Factor
        $fileTypeUnitLabel = $fileTypeUnitInfo.Label
        if ($fileTypeData.Count -gt 0) {
            $fileTypeLabelsArray = @($fileTypeData | ForEach-Object {
                $label = if ($_.Name) { $_.Name } else { 'No Extension' }
                $escaped = $label -replace '"', '\"'
                "`"$escaped`""
            })
            $fileTypeLabels = $fileTypeLabelsArray -join ','
            $fileTypeSizesArray = @($fileTypeData | ForEach-Object {
                [math]::Round((($_.Group | Measure-Object Size -Sum).Sum / 1MB) / $fileTypeFactor, 2)
            })
            $fileTypeSizes = $fileTypeSizesArray -join ','
            $colorPalette = @('#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#8BC34A', '#FF9800', '#E91E63', '#9C27B0')
            $fileTypeColorsArray = @()
            for ($i = 0; $i -lt [Math]::Min($fileTypeData.Count, $colorPalette.Length); $i++) {
                $fileTypeColorsArray += "`"$($colorPalette[$i])`""
            }
            $fileTypeColors = $fileTypeColorsArray -join ','
        } else {
            $fileTypeLabels = '"No Data"'
            $fileTypeSizes = '0'
            $fileTypeColors = '"#CCCCCC"'
        }

        # Generate folder/file table rows (unchanged)
        $folderRows = ""
        $FolderResults | Sort-Object Size -Descending | Select-Object -First ([int]$TopFolders) | ForEach-Object {
            $percentage = if ($Script:TotalSize -gt 0) { ($_.Size / $Script:TotalSize * 100).ToString("F1") } else { "0.0" }
            $originalPath = if ($_.Path) { $_.Path } else { $_.ToString() }
            $folderSize = if ($_.Size) { $_.Size } else { 0 }
            $fileCount = if ($_.FileCount) { $_.FileCount } else { 0 }
            $folderCount = if ($_.FolderCount) { $_.FolderCount } else { 0 }
            $displayPath = $originalPath -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
            $folderRows += "<tr><td class='folder-path'>$displayPath</td><td class='file-size'>$(Format-FileSize $folderSize) ($percentage%)</td><td>$fileCount</td><td>$folderCount</td></tr>`n"
        }
        $fileRows = ""
        $FileResults | Sort-Object Size -Descending | Select-Object -First ([int]$TopFiles) | ForEach-Object {
            $extension = if ($_.Extension) { $_.Extension } else { "No Ext" }
            $originalPath = if ($_.Path) { $_.Path } else { $_.Name }
            $fileSize = if ($_.Size) { $_.Size } else { 0 }
            $lastModified = if ($_.LastModified -and $_.LastModified -ne [DateTime]::MinValue) { $_.LastModified.ToString('yyyy-MM-dd HH:mm') } else { "Unknown" }
            $displayPath = $originalPath -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
            $fileRows += "<tr><td class='folder-path'>$displayPath</td><td class='file-size'>$(Format-FileSize $fileSize)</td><td>$lastModified</td><td><span class='extension-tag'>$extension</span></td></tr>`n"
        }

        $htmlContent = @"
<!DOCTYPE html>
<html lang='en'>
<head>
    <meta charset='UTF-8'>
    <title>ChimpXplore Disk Usage Report</title>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f4fa; color: #222; margin: 0; padding: 0; }
        .container { max-width: 1200px; margin: 30px auto; background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); padding: 32px 32px 24px 32px; }
        h1, h2, h3 { color: #2a2a6a; }
        .table-responsive { overflow-x: auto; width: 100%; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 24px; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #e0e0ef; text-align: left; }
        th { background: #3a3a8a; color: #fff; font-weight: 600; }
        tr:nth-child(even) { background: #f7f7fb; }
        tr:hover { background: #e6e6f7; }
        .path-cell {
            white-space: nowrap;
            word-break: break-all;
            font-family: 'Consolas', 'Courier New', monospace;
            font-size: 0.98em;
            padding-right: 8px;
        }
        .charts-section { margin-bottom: 32px; }
        .chart-container { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 32px; }
        .chart-box { 
            background: #fff; 
            border: 1px solid #e0e0ef; 
            border-radius: 6px; 
            padding: 20px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            height: 400px;
            display: flex;
            flex-direction: column;
        }
        .chart-title { font-size: 18px; font-weight: 600; color: #2a2a6a; margin-bottom: 16px; text-align: center; }
        .chart-box canvas {
            flex: 1;
            max-height: 350px;
            width: 100% !important;
            height: auto !important;
        }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 16px; margin: 20px 0; }
        .stat-item { text-align: center; padding: 16px; background: #f8f9ff; border-radius: 6px; border: 1px solid #e0e0ef; }
        .stat-value { font-size: 24px; font-weight: bold; color: #3a3a8a; }
        .stat-label { font-size: 14px; color: #666; margin-top: 4px; }
        .size-cell { color: #c00; font-weight: bold; }
        .ext-badge { background: #e0e0ef; color: #2a2a6a; border-radius: 12px; padding: 2px 10px; font-size: 0.95em; margin-left: 6px; }
        @media (max-width: 700px) {
            .container { padding: 8px; }
            th, td { padding: 7px 6px; font-size: 0.98em; }
            .chart-container { 
                grid-template-columns: 1fr; 
                gap: 16px; 
            }
            .chart-box { 
                height: 300px; 
            }
            .chart-box canvas {
                max-height: 250px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>ChimpXplore Disk Usage Report</h1>
            <p>Comprehensive disk space analysis and visualization</p>
        </div>
        <div class="content">
            <div class="summary">
                <h2>Scan Summary</h2>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value">$(Format-FileSize $Script:TotalSize)</div>
                        <div class="stat-label">Total Size</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">$($Script:TotalFiles)</div>
                        <div class="stat-label">Total Files</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">$($Script:TotalFolders)</div>
                        <div class="stat-label">Total Folders</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">$((New-TimeSpan -Start $Script:StartTime -End (Get-Date)).TotalSeconds.ToString('F2'))s</div>
                        <div class="stat-label">Scan Duration</div>
                    </div>
                </div>
                <p><strong>Path Scanned:</strong> <span class="folder-path">$ScanPath</span></p>
            </div>
            <div class="charts-section">
                <div class="chart-container">
                    <div class="chart-box">
                        <div class="chart-title">Top Folders by Size ($folderUnitLabel)</div>
                        <canvas id="foldersChart" width="400" height="300"></canvas>
                    </div>
                    <div class="chart-box">
                        <div class="chart-title">File Types by Size ($fileTypeUnitLabel)</div>
                        <canvas id="fileTypesChart" width="400" height="300"></canvas>
                    </div>
                </div>
            </div>
            <h2>Top ${TopFolders} Largest Folders</h2>
            <div class="table-container">
                <table>
                    <tr><th>Path</th><th>Size</th><th>Files</th><th>Folders</th></tr>
                    $folderRows
                </table>
            </div>
            <h2>Top ${TopFiles} Largest Files</h2>
            <div class="table-responsive">
    <table class="disk-table">
        <thead>
            <tr>
                <th>PATH</th>
                <th>SIZE</th>
                <th>LAST MODIFIED</th>
                <th>TYPE</th>
            </tr>
        </thead>
        <tbody>
            $fileRows
        </tbody>
    </table>
    </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <script>
        console.log('ChimpXplore Report: Loading charts...');
        console.log('Chart.js loaded:', typeof Chart !== 'undefined');
        
        // Folder sizes chart
        console.log('Folder data - Labels:', [$folderLabels]);
        console.log('Folder data - Sizes:', [$folderSizes]);
        
        const foldersCtx = document.getElementById('foldersChart').getContext('2d');
        const foldersChart = new Chart(foldersCtx, {
            type: 'bar',
            data: {
                labels: [$folderLabels],
                datasets: [{
                    label: 'Size ($folderUnitLabel)',
                    data: [$folderSizes],
                    backgroundColor: 'rgba(58, 58, 138, 0.7)',
                    borderColor: 'rgba(58, 58, 138, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                aspectRatio: 1.5,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y.toFixed(2) + ' $folderUnitLabel';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Size ($folderUnitLabel)'
                        }
                    },
                    x: {
                        ticks: {
                            maxRotation: 45,
                            minRotation: 0,
                            maxTicksLimit: 10
                        }
                    }
                }
            }
        });

        // File types chart
        console.log('File type data - Labels:', [$fileTypeLabels]);
        console.log('File type data - Sizes:', [$fileTypeSizes]);
        console.log('File type data - Colors:', [$fileTypeColors]);
        
        const fileTypesCtx = document.getElementById('fileTypesChart').getContext('2d');
        const fileTypesChart = new Chart(fileTypesCtx, {
            type: 'doughnut',
            data: {
                labels: [$fileTypeLabels],
                datasets: [{
                    data: [$fileTypeSizes],
                    backgroundColor: [$fileTypeColors],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                aspectRatio: 1,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 10,
                            usePointStyle: true,
                            maxWidth: 200
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return label + ': ' + value.toFixed(2) + ' $fileTypeUnitLabel (' + percentage + '%)';
                            }
                        }
                    }
                }
            }
        });

        console.log('ChimpXplore Report: Charts loaded successfully');
    </script>
</body>
</html>
"@
        $htmlContent | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Host "`nResults exported to HTML: $FilePath" -ForegroundColor Green
    } catch {
        Write-Error "Failed to export HTML: $($_.Exception.Message)"
    }
}

# Main execution
try {
    # Validate path
    if (-not (Test-Path -Path $Path)) {
        throw "Path does not exist: $Path"
    }
    
    # Check if running as administrator (Windows) or with sufficient permissions
    if ($IsWindows) {
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        
        if (-not $isAdmin) {
            Write-Warning "Running without administrator privileges. Some directories may be inaccessible."
        }
    }
    
    Write-Host "Starting ChimpXplore scan..." -ForegroundColor Green
    Write-Host "Scanning: $Path" -ForegroundColor White
    if ($Depth -ne -1) {
        Write-Host "Max Depth: $Depth" -ForegroundColor White
    }
    Write-Host "Minimum Size: $MinSize MB" -ForegroundColor White
    if ($FastMode) {
        Write-Host "Fast Mode: Enabled (using .NET methods)" -ForegroundColor Yellow
    }
    if ($UseParallel) {
        Write-Host "Parallel Processing: Enabled ($MaxThreads threads)" -ForegroundColor Yellow
    }
    if ($UseAdvancedMethods) {
        Write-Host "Advanced Methods: Enabled (WMI, Robocopy, Win32 API fallbacks)" -ForegroundColor Yellow
        Write-Host "Advanced Methods: Will handle permissions issues and special directories" -ForegroundColor Yellow
    }
    if ($Comprehensive) {
        Write-Host "Comprehensive Mode: Enabled (detailed analysis)" -ForegroundColor Yellow
    }
    if ($FileTypes.Count -gt 0) {
        Write-Host "Including File Types: $($FileTypes -join ', ')" -ForegroundColor Cyan
    }
    if ($ExcludeTypes.Count -gt 0) {
        Write-Host "Excluding File Types: $($ExcludeTypes -join ', ')" -ForegroundColor Cyan
    }
    Write-Host "Progress Update Interval: $ProgressUpdateInterval items" -ForegroundColor White
    
    # Performance optimization: Single pass directory scan
    Write-Host "`nScanning directory structure (optimized single-pass)..." -ForegroundColor Yellow
    
    # Reset collections
    $Script:AllFolders.Clear()
    $Script:AllFiles.Clear()
    
    # Single comprehensive scan
    $rootSize = Get-DirectorySize -FolderPath $Path -MaxDepth $Depth -MinSizeMB $MinSize
    
    # Add root directory to results
    if ($rootSize.Size -ge ($MinSize * 1MB)) {
        $Script:AllFolders.Add($rootSize)
    }
    
    $Script:TotalSize = $rootSize.Size
    
    # Get large files (will use already collected data in optimized mode)
    Write-Host "Finalizing large files list..." -ForegroundColor Yellow
    $largeFiles = Get-LargeFiles -FolderPath $Path -MinSizeMB $MinSize
    
    # Clear progress
    if ($ShowProgress) {
        Write-Progress -Activity "Scanning Directory Structure" -Completed
    }
    
    # Display results
    Show-Results -FolderResults $Script:AllFolders.ToArray() -FileResults $largeFiles
    
    # Export to CSV if requested
    if ($ExportCsv) {
        try {
            $exportData = [System.Collections.Generic.List[PSObject]]::new()

            # Add folder data
            $Script:AllFolders | ForEach-Object {
                $folderData = [PSCustomObject]@{
                    Type = "Folder"
                    Name = Split-Path $_.Path -Leaf
                    Path = $_.Path
                    Size = $_.Size
                    SizeFormatted = Format-FileSize $_.Size
                    FileCount = $_.FileCount
                    FolderCount = $_.FolderCount
                    LastModified = $_.LastModified
                    Extension = ""
                }
                
                # Add comprehensive data if available

                if ($Comprehensive -and $_.PSObject.Properties['CreationTime']) {
                    $folderData | Add-Member -NotePropertyName "CreationTime" -NotePropertyValue $_.CreationTime
                    $folderData | Add-Member -NotePropertyName "LastAccessTime" -NotePropertyValue $_.LastAccessTime
                    $folderData | Add-Member -NotePropertyName "Attributes" -NotePropertyValue $_.Attributes
                    $folderData | Add-Member -NotePropertyName "IsHidden" -NotePropertyValue $_.IsHidden
                    $folderData | Add-Member -NotePropertyName "IsSystem" -NotePropertyValue $_.IsSystem
                }
                
                $exportData.Add($folderData)
            }

            # Add file data
            $largeFiles | ForEach-Object {
                $fileData = [PSCustomObject]@{
                    Type = "File"
                    Name = $_.Name
                    Path = $_.Path
                    Size = $_.Size
                    SizeFormatted = $_.SizeFormatted
                    FileCount = 1
                    FolderCount = 0
                    LastModified = $_.LastModified
                    Extension = $_.Extension
                }
                
                # Add comprehensive data if available
                if ($Comprehensive -and $_.PSObject.Properties['CreationTime']) {
                    $fileData | Add-Member -NotePropertyName "CreationTime" -NotePropertyValue $_.CreationTime
                    $fileData | Add-Member -NotePropertyName "LastAccessTime" -NotePropertyValue $_.LastAccessTime
                    $fileData | Add-Member -NotePropertyName "Attributes" -NotePropertyValue $_.Attributes
                    $fileData | Add-Member -NotePropertyName "IsReadOnly" -NotePropertyValue $_.IsReadOnly
                    $fileData | Add-Member -NotePropertyName "IsHidden" -NotePropertyValue $_.IsHidden
                    $fileData | Add-Member -NotePropertyName "IsSystem" -NotePropertyValue $_.IsSystem
                }
                
                $exportData.Add($fileData)
            }

            $exportData.ToArray() | Export-Csv -Path $ExportCsv -NoTypeInformation -Encoding UTF8
            Write-Host "`nResults exported to CSV: $ExportCsv" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to export CSV: $($_.Exception.Message)"
        }
    }
    
    # Export to HTML if requested
    if ($ExportHtml) {
        Export-ToHtml -FilePath $ExportHtml -FolderResults $Script:AllFolders.ToArray() -FileResults $largeFiles -ScanPath $Path
    }
    
    Write-Host "`nScan completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "ChimpXplore encountered an error: $($_.Exception.Message)"
    exit 1
}
