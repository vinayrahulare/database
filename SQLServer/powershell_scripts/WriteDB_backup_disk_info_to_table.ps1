$workdir = 'D:\PSscripts' # change if you're using a directory other than D:\PSscripts\
$servers = '.\prodservers.txt'        # list of your SQL Servers
  
Set-Location $workdir
$sqlservers = Get-Content $servers | Sort-Object # read in and sort to order output 

Get-DbaDatabase -SqlInstance $sqlservers -ExcludeSystem | Select ComputerName, Name, RecoveryModel ,LastFullBackup, LastDiffBackup, LastLogBackup | Write-DbaDataTable -SqlInstance BDDC1SQLCMS00 -Database DBAUtility -Table BackupHistory -Schema info -KeepIdentity -AutoCreateTable -Truncate 
Get-DbaDiskSpace -ComputerName $sqlservers -Unit MB | Select ComputerName, Name, Label, Capacity, Free, PercentFree | Write-DbaDataTable -SqlInstance BDDC1SQLCMS00 -Database DBAUtility -Table DiskSpaceFree -Schema info -KeepIdentity -AutoCreateTable -Truncate 