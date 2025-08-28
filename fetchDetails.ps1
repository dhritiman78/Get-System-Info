# ====== CONFIGURATION ======
$firebaseUrl = "https://test-ca5a5-default-rtdb.asia-southeast1.firebasedatabase.app/systemReports.json"
$outputFile = "system_report.json"

# ====== COLLECT SYSTEM INFORMATION ======
$hostname   = $env:COMPUTERNAME
$os         = (Get-CimInstance Win32_OperatingSystem).Caption
$kernel     = (Get-CimInstance Win32_OperatingSystem).Version
$arch       = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$uptime     = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$cpu        = (Get-CimInstance Win32_Processor).Name
$cores      = (Get-CimInstance Win32_Processor).NumberOfCores
$memTotal   = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$memUsed    = [math]::Round($memTotal - ((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB), 2)
$disk       = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
              ForEach-Object { "{0} {1}GB free of {2}GB" -f $_.DeviceID, ([math]::Round($_.FreeSpace/1GB,2)), ([math]::Round($_.Size/1GB,2)) }
$ip         = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet","Wi-Fi" -ErrorAction SilentlyContinue).IPAddress -join ", "
$user       = $env:USERNAME
$date       = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

# ====== FORMAT AS JSON ======
$systemInfo = @{
    hostname = $hostname
    os = $os
    kernel = $kernel
    architecture = $arch
    uptime = $uptime
    cpu = $cpu
    cores = $cores
    memory = @{
        total = "$memTotal GB"
        used  = "$memUsed GB"
    }
    disk = $disk
    ip = $ip
    user = $user
    timestamp = $date
}

$systemInfo | ConvertTo-Json -Depth 3 | Out-File -Encoding UTF8 $outputFile

# ====== SEND TO FIREBASE ======
Invoke-RestMethod -Method Post -Uri $firebaseUrl -Body (Get-Content $outputFile -Raw) -ContentType "application/json"

Write-Host "System information collected and sent to Firebase."
Write-Host "Local copy saved in $outputFile"

