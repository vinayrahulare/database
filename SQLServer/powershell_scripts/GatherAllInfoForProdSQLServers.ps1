
$workdir = 'D:\PSscripts\GetServerInfoAndCpuCount' # change if you're using a directory other than C:\scripts\GetCpuCount
$servers = '.\serversListProdAndNonprod.txt'        # list of your SQL Servers
  
Set-Location $workdir
$sqlservers = Get-Content $servers | Sort-Object # read in and sort to order output 
$sqlinstance = 'BDDC1SQLCMS00.hrt.local'

# Put information about the SQL hosts into the DBA_Central database
Get-DbaFeature -ComputerName $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table Features -Schema info -AutoCreateTable

Get-DbaBuildReference -SqlInstance $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table SQLBuilds -Schema info -AutoCreateTable

Get-DbaComputerSystem -ComputerName $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table ComputerSystem -Schema info -AutoCreateTable

Get-DbaOperatingSystem -ComputerName $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table OperatingSystem -Schema info -AutoCreateTable

Get-DbaDatabase -SqlInstance $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table OperatingSystem -Schema info -AutoCreateTable

Find-DbaUserObject -SqlInstance $sqlservers | Write-DbaDataTable -SqlInstance $sqlinstance -Database DBA_Central -Table OperatingSystem -Schema info -AutoCreateTable

