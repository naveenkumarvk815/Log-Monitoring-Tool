# Log Monitor - PowerShell Job Analysis Tool

A PowerShell script that monitors job execution logs and generates performance reports with duration analysis and status classification.

## Overview

This script analyzes job execution logs to track job performance, identify long-running processes, and generate comprehensive reports. It processes START/END events for jobs and categorizes them based on execution duration.

## Features

- **Job Duration Tracking**: Monitors job execution times from START to END events
- **Status Classification**: Automatically categorizes jobs as OK, WARNING, ERROR, or INCOMPLETE
- **Incomplete Job Detection**: Identifies jobs that started but never completed
- **Automated Reporting**: Generates formatted reports with execution statistics
- **Real-time Processing**: Processes log entries sequentially and maintains job state

## Prerequisites

- PowerShell 5.0 or later
- Windows operating system
- Read/write access to log and report directories

## Installation

1. Create the required directories:
```powershell
New-Item -ItemType Directory -Force -Path "C:\Log_monitor"
```

2. Save the script as `log-monitor.ps1` in your preferred location

3. Ensure the log file exists at the specified path or update the `$logFile` variable

## Usage

### Basic Usage

Run the script directly:
```powershell
.\log-monitor.ps1
```

### Configuration

Update these variables at the top of the script as needed:

```powershell
$logFile   = "C:\Log_monitor\logs.log"    # Path to input log file
$reportOut = "C:\Log_monitor\report.txt"  # Path to output report
```

### Log File Format

The script expects CSV-formatted log entries with the following structure:
```
timestamp,description,status,jobId
14:30:15,Database Backup,START,JOB001
14:35:20,Database Backup,END,JOB001
```

**Required Fields:**
- `timestamp`: Time in HH:mm:ss format
- `description`: Job description/name
- `status`: Either "START" or "END"
- `jobId`: Unique identifier for the job

## Status Classification

The script automatically classifies jobs based on execution duration:

| Duration | Status | Description |
|----------|--------|-------------|
| ≤ 5 minutes | `OK` | Normal execution time |
| 5-10 minutes | `WARNING` | Longer than expected |
| > 10 minutes | `ERROR` | Excessive execution time |
| No END event | `INCOMPLETE` | Job started but never completed |

## Output Format

The generated report includes:

- **jobId**: Unique job identifier
- **Description**: Job name/description
- **Start**: Start time (HH:mm:ss)
- **End**: End time (HH:mm:ss) or "-" for incomplete jobs
- **DurationMin**: Execution duration in minutes (rounded to 2 decimal places)
- **Result**: Status classification (OK/WARNING/ERROR/INCOMPLETE)

### Sample Report Output

```
jobId Description        Start    End      DurationMin Result
----- -----------        -----    ---      ----------- ------
JOB001 Database Backup   14:30:15 14:35:20        5.08 WARNING
JOB002 System Cleanup    15:00:00 15:02:30        2.50 OK
JOB003 Data Migration    16:00:00 16:15:45       15.75 ERROR
JOB004 Incomplete Task   17:00:00 -                  - INCOMPLETE
```

## File Structure

```
C:\Log_monitor\
├── logs.log          # Input log file (CSV format)
└── report.txt        # Generated report output
```

## Error Handling

- **Missing END Events**: Jobs without corresponding END events are marked as INCOMPLETE
- **Invalid Timestamps**: Script may fail if timestamp format doesn't match HH:mm:ss
- **Missing Files**: Ensure log file exists before running the script
- **File Permissions**: Verify read access to log file and write access to report directory

## Customization

### Modify Duration Thresholds

To change the status classification thresholds, update these conditions:

```powershell
if ($duration -gt 10) {          # ERROR threshold
    $statusMsg = "ERROR"
}
elseif ($duration -gt 5) {       # WARNING threshold
    $statusMsg = "WARNING"
}
else {
    $statusMsg = "OK"
}
```

### Change Date Format

To use a different timestamp format, modify the ParseExact call:

```powershell
$time = [datetime]::ParseExact($timestamp, "yyyy-MM-dd HH:mm:ss", $null)
```

### Add Additional Fields

Extend the PSCustomObject creation to include more fields:

```powershell
$results += [PSCustomObject]@{
    jobId         = $jobId
    Description = $jobs[$jobId].Description
    Start       = $start.ToString("HH:mm:ss")
    End         = $time.ToString("HH:mm:ss")
    DurationMin = [math]::Round($duration,2)
    Result      = $statusMsg
    Server      = $env:COMPUTERNAME  # Example additional field
}
```

## Troubleshooting

### Common Issues

1. **"Cannot find path" error**: Ensure the log file path exists and is accessible
2. **Parse errors**: Verify log file format matches expected CSV structure
3. **Permission denied**: Check file system permissions for both input and output paths
4. **Empty report**: Verify log file contains valid START/END pairs

### Debugging

Add debug output to troubleshoot issues:

```powershell
Write-Host "Processing job: $jobId, Status: $status, Time: $timestamp"
```



## Version History

- **v1.0**: Initial release with basic job monitoring and reporting functionality