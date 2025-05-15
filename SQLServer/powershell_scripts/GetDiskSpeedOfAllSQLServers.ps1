<# 
Gets the disk space of all the disk on SQL Servers 
from a list of SQL Servers specified in a file to a .csv file.
#>
 
$workdir = 'D:\PSscripts\GetDiskSpeedOfAllSQLServers' # change if you're using a directory other than C:\scripts\GetCpuCount
$outfile = 'SQLServerDiskSpeed.csv'           # output file name
$servers = '.\servers.txt'                       # list of your SQL Servers
 
$EmailOn = 'n'                                   # y to email logs (case insensitive)
 
# $Email variables must be populated if $EmailOn = 'y'  
$PSEmailServer = 'smtp.office365.com'  # mail server 
$EmailFrom = 'svc-sql-alerts@teladochealth.com' # mail from - must be populated with properly formatted (name@domain.ext) but doesn't have to be real 
$EmailTo = 'SQLAlerts@bestdoctors.com'  # mail to
$EmailSubject = 'ServerInfoAndCpuCount'   # mail subject
 
Set-Location $workdir
$sqlservers = Get-Content $servers | Sort-Object # read in and sort to order output 

# delete old output file if it exists
If (Test-Path $outfile){Remove-Item $outfile}
 
# gather info from each server in file and export to .csv
Foreach ($ss in $sqlservers) 
{
   Test-DbaDiskSpeed -SqlInstance $ss -AggregateBy Disk | Export-Csv $outfile -NoTypeInformation -Append
}
 
# email $outfile
If ($EmailOn -eq 'y') 
{
   Send-MailMessage -From "$EmailFrom" -To "$EmailTo" -Subject "$EmailSubject" -Attachments "$outfile"
}
	