# Path to the log file and report file
$logFile   = "C:\Log_monitor\logs.log"
$reportOut = "C:\Log_monitor\report.txt"


# Hashtable to track jobs
$jobs = @{}
# Array to collect results
$results = @()

# Read and parse log file
Get-Content $logFile | ForEach-Object {
    $parts = $_ -split ","
    $timestamp   = $parts[0].Trim()
    $description = $parts[1].Trim()
    $status      = $parts[2].Trim()
    $jobId         = $parts[3].Trim()

    $time = [datetime]::ParseExact($timestamp, "HH:mm:ss", $null)

    if ($status -eq "START") {
        # Store job start
        $jobs[$jobId] = @{ Start = $time; Description = $description }
    }
    elseif ($status -eq "END" -and $jobs.ContainsKey($jobId)) {
        $start = $jobs[$jobId].Start
        $duration = ($time - $start).TotalMinutes

        # Determine status
        if ($duration -gt 10) {
            $statusMsg = "ERROR"
        }
        elseif ($duration -gt 5) {
            $statusMsg = "WARNING"
        }
        else {
            $statusMsg = "OK"
        }

        # Add to results
        $results += [PSCustomObject]@{
            jobId         = $jobId
            Description = $jobs[$jobId].Description
            Start       = $start.ToString("HH:mm:ss")
            End         = $time.ToString("HH:mm:ss")
            DurationMin = [math]::Round($duration,2)
            Result      = $statusMsg
        }

        # Remove job after processing
        $jobs.Remove($jobId)
    }
}

# Handle incomplete jobs (no END found)
foreach ($jobId in $jobs.Keys) {
    $results += [PSCustomObject]@{
        jobId         = $jobId
        Description = $jobs[$jobId].Description
        Start       = $jobs[$jobId].Start.ToString("HH:mm:ss")
        End         = "-"
        DurationMin = "-"
        Result      = "INCOMPLETE"
    }
}

# Export results to a report file
$results | Format-Table -AutoSize | Out-String | Set-Content $reportOut

Write-Host "Report generated at $reportOut"
