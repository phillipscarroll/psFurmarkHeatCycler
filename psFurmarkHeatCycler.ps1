# Variables
$maxTime = 75
# 3000 cycles = 1 week of pulsing on/off
$loopCount = 3000
$sleepTime = 200
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
function Log-Message {
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
    Log-Message "Starting loop $i of $loopCount"

    # Log Furmark start
    Log-Message "Starting Furmark with max time $maxTime seconds"
    # Run Furmark with specified parameters, make sure furmark is in the path
    Start-Process -FilePath "furmark" -ArgumentList "--demo furmark-gl --width 1920 --height 1080 --max-time $maxTime --gpu-index 1"

    # Log sleep start
    Log-Message "Starting sleep for $sleepTime seconds"
    # Wait for the specified sleep time
    Start-Sleep -Seconds $sleepTime

    # Log end of loop
    Log-Message "Completed loop $i of $loopCount"
}