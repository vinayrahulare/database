
$workdir = 'D:\PSscripts' # change if you're using a directory other than D:\PSscripts\
$servers = '.\prodservers.txt'        # list of your SQL Servers
  
Set-Location $workdir
$sqlservers = Get-Content $servers | Sort-Object # read in and sort to order output 

# delete old output file if it exists
If (Test-Path $outfile){Remove-Item $outfile}

Get-DbaFeature -ComputerName $sqlservers | Export-Csv -Path $outfile -NoTypeInformation -Append
Get-DbaOperatingSystem -ComputerName $sqlservers | Export-Csv -Path $outfile2 -NoTypeInformation -Append

