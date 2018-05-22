# Global Vairables
$scriptName = "GetLogs_Mk2"
$remoteName = ""
$startTime = ""
$stopTime = ""
$logType = "System"     #Options: System,application,Hardwareevents,security
$currentDate = (Get-Date -Format "MM-dd-yyyy_HH_mm")
# END - Global variables


#---------------------------------------------------------
# Functions 
#---------------------------------------------------------
function Pull-Errors {
Get-EventLog $script:logType -ComputerName $script:remoteName -After $script:startTime -Before $script:stopTime |format-table |select -Property TimeWritten,EntryType,Message |where {($_.EntryType -eq "Error") -or ($_.EntryType -eq "Warning")}| ConvertTo-Html |Out-File "C:\users\$env:USERNAME\desktop\$script:remoteName $(get-date -f MM-dd-yyyy)_EventLog.html"
$script:filePath = "C:\users\$env:USERNAME\desktop\$script:remoteName $(get-date -f MM-dd-yyyy)_EventLog.html"
}

function Pause {
   Read-Host 'Press Enter to continue…' | Out-Null
}

function Set-remoteName{
    $dnsFail = 0
    #Loop to check the DNS record of the given entry
    DO{
        write-host "Please enter a remote computer's domain name: " -nonewline
        $global:remoteName = Read-Host
        #Checks and catches the domain name if an error is found.
        try {
            Resolve-DnsName $remoteName -erroraction stop | Out-Null
            $dnsFail = 0
        } catch {
            echo "That DNS name did not resolve. Please try again."
            $dnsFail = 1
            start-sleep 2
            cls
        }
        }until($dnsFail -eq 0)
    
    echo "DNS name check OK."
    start-sleep 2
    cls
}

Function set-Logtype{
    DO{
        $exit = 0
        echo "What type of log would you like to pull? Valid Options are: application, security, setip, or system"
        $logType = Read-Host

        if ($logType -eq "application" -or $logType -eq "security" -or $logType -eq "setup" -or $logType -eq "system"){
            $exit = 1
            $script:logType = $logType
            break
        }
        echo "Invalid selection, please try again"
        sleep 2
        cls
    }until($exit -eq 1)
}
#---------------------------------------------------------
# END Functions
#---------------------------------------------------------

#---------------------------------------------------------
# Main Script 
#---------------------------------------------------------
cls
Echo "$scriptname - This script is used to pull errors & warning event logs from remote mahcines."
Echo "......................"
echo ""

Set-remoteName

#Gets the start time from user, or uses default of 12 hours ago if no entry is needed.
echo "Enter a start date/time, or press 'RETURN' to use the default:"
(Get-Date).addhours(-12)
echo ""
$startTime = Read-host
if (!$startTime){
    $startTime = (Get-Date).addhours(-12)}
$startTime = Get-Date($startTime)
cls


#Gets the stop time from user, or uses default of current time 
Echo "Enter an end date/time, or press 'RETURN' to use the default:"
echo ""
Get-Date
echo ""
$stopTime = Read-host
if (!$stopTime){
    $stopTime = (Get-Date)}
$stopTime = Get-Date($stopTime)
cls


set-logtype
Echo "Connecting to $remoteName..."
Pull-Errors
echo "Export complete."
sleep 3
echo "Remote Name $remoteName"
echo "Log Path: $filePath"
echo "Log Start: $startTime"
echo "Log Stop: $stopTime"
echo "Log Type: $logType"
#Invoke-Item $filePath
#---------------------------------------------------------
# END - Main Script
#---------------------------------------------------------