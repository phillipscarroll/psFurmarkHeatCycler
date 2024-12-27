# Variables
# maxTime: The maximum time in seconds to run Furmark for each loop
$maxTime = 510
# maxCoolTime: The maximum off load time
$maxCoolTime = 90
# 432 cycles = 3 days of heavy heat load with 90 seconds of cooling
$loopCount = 432
# sleepTime: The time in seconds to sleep between runs, this should include the maxTime
$sleepTime = $maxTime + $maxCoolTime
$logFileName = "gpu_long_test.log"

# Check if the log file exists
if (Test-Path $logFileName) {
    # Get the current date and time
    $currentDateTime = Get-Date -Format "yyyy_MM_dd_HH_mm_ss"
    # Create a new log file name with the date and time appended
    $newLogFileName = "gpu_long_test_$currentDateTime.log"
    # Rename the existing log file
    Rename-Item -Path $logFileName -NewName $newLogFileName
}

# Function to log messages
function Write-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFileName -Value "$timestamp - $message"
}

# Loop X times
for ($i = 1; $i -le $loopCount; $i++) {
    # Log the current loop iteration to console
    Write-Host "Starting loop $i of $loopCount"
    # Log the current loop iteration to file
    Write-Message "Starting loop $i of $loopCount"

    # Log Furmark start
    Write-Message "Starting Furmark with max time $maxTime seconds"
    # Run Furmark with specified parameters, make sure furmark is in the path
    Start-Process -FilePath "furmark" -ArgumentList "--demo furmark-gl --width 1920 --height 1080 --max-time $maxTime --gpu-index 1"

    # Log sleep start
    Write-Message "Starting sleep for $sleepTime seconds"
    # Wait for the specified sleep time
    Start-Sleep -Seconds $sleepTime

    # Log end of loop
    Write-Message "Completed loop $i of $loopCount"
}