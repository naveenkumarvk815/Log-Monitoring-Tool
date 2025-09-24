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
37980 scheduled task 032 11:35:23 11:35:56        0.55 OK        
57672 scheduled task 796 11:36:11 11:36:18        0.12 OK        
10515 scheduled task 386 11:38:33 11:40:24        1.85 OK        
23118 scheduled task 188 11:40:49 11:41:28        0.65 OK        
60134 background job ulp 11:41:11 11:41:55        0.73 OK        
90962 scheduled task 996 11:40:51 11:42:46        1.92 OK        
90812 background job dej 11:39:26 11:43:32         4.1 OK        
75164 scheduled task 173 11:45:47 11:46:51        1.07 OK        
36709 background job djw 11:47:04 11:47:54        0.83 OK        
26831 scheduled task 538 11:46:04 11:48:16         2.2 OK        
47139 scheduled task 946 11:44:56 11:48:22        3.43 OK        
39547 scheduled task 051 11:37:53 11:49:22       11.48 ERROR     
45135 scheduled task 515 11:37:14 11:49:37       12.38 ERROR     
32904 scheduled task 697 11:49:12 11:49:46        0.57 OK        
71766 scheduled task 074 11:45:04 11:50:51        5.78 WARNING   
24799 scheduled task 536 11:51:21 11:51:28        0.12 OK        
81258 background job wmy 11:36:58 11:51:44       14.77 ERROR     
32674 scheduled task 626 11:51:06 11:52:32        1.43 OK        
38579 background job you 11:50:09 11:53:42        3.55 OK        
87228 scheduled task 268 11:44:25 11:53:53        9.47 WARNING   
50295 scheduled task 811 11:48:45 11:55:20        6.58 WARNING   
55722 background job cmx 11:54:56 11:55:43        0.78 OK        
33528 scheduled task 706 11:52:47 11:56:09        3.37 OK        
27222 scheduled task 294 11:50:07 11:56:15        6.13 WARNING   
64591 scheduled task 521 11:57:05 11:58:55        1.83 OK        
67833 scheduled task 080 11:57:16 12:00:51        3.58 OK        
87570 scheduled task 794 11:53:57 12:01:50        7.88 WARNING   
99672 background job sqm 11:57:08 12:02:21        5.22 WARNING   
96183 scheduled task 678 11:58:12 12:02:26        4.23 OK        
16168 scheduled task 773 12:02:39 12:02:55        0.27 OK        
34189 scheduled task 920 11:59:43 12:03:02        3.32 OK        
86716 background job xfg 11:59:29 12:05:03        5.57 WARNING   
22003 scheduled task 004 11:55:29 12:06:42       11.22 ERROR     
85742 scheduled task 064 11:55:16 12:07:33       12.28 ERROR     
81470 background job wiy 12:08:30 12:09:33        1.05 OK        
98746 scheduled task 746 12:04:18 12:11:35        7.28 WARNING   
39860 scheduled task 460 11:53:17 12:13:09       19.87 ERROR     
52532 background job tqc 12:00:03 12:13:56       13.88 ERROR     
62922 scheduled task 531 12:14:20 12:15:09        0.82 OK        
62401 scheduled task 936 12:05:59 12:16:23        10.4 ERROR     
23703 scheduled task 374 12:04:57 12:18:23       13.43 ERROR     
70808 scheduled task 182 11:44:43 12:18:26       33.72 ERROR     
24482 scheduled task 672 12:10:38 12:19:14         8.6 WARNING   
72897 scheduled task 016 12:12:27 -                  - INCOMPLETE
72029 scheduled task 333 12:03:20 -                  - INCOMPLETE



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
