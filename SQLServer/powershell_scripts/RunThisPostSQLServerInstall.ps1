$ss = 'BDDC1SQLDEV00'
$ds = 'TDDC1SQLDEV00'

# Copy SQL Agent jobs
Copy-DbaAgentJob -Source $ss -Destination $ds

# Copy Logins
Copy-DbaLogin -Source SourceServer -Destination DestinationServer

# A wrapper function that calls the associated Copy command for each of the object types seen in SSMS under SQL Server Agent. 
# This also copies all of the the SQL Agent properties (job history max rows, DBMail profile name, etc.).
#Copy-DbaAgentServer -Source $ss -Destination $ds

# Copy SQL Agent Operator
Copy-DbaAgentOperator -Source $ss -Destination $ds

# Copy SQL Agent alerts
Copy-DbaAgentAlert -Source $ss -Destination $ds

# Copy Linked servers 
Copy-DbaLinkedServer -Source $ss -Destination $ds -Force

# Copy Database Mail
Copy-DbaDbMail -Source $ss -Destination $ds



#$params1 = @{
#Source = "BDDC1SQLDEV00"
#Destination = "TDDC1SQLDEV00"
#EncryptionPassword = $passwd
#MasterKeyPassword = $passwd
#SharedPath = "\\BDDC1BTS02\SQLBackup\SQLCerts\BDDC1SQLDEV00\dbatools"
#}
#Copy-DbaDbCertificate @params1 -Confirm:$false -OutVariable results

$serverList = @(
'server_01',
'server_02',
    'server_03'
)

foreach ($server in $serverList) {
    Set-DbaSpConfigure -SqlInstance $server -ConfigName CostThresholdForParallelism -Value 50
    Set-DbaSpConfigure -SqlInstance $server -ConfigName DefaultBackupCompression -Value 1
    Set-DbaSpConfigure -SqlInstance $server -ConfigName OptimizeAdhocWorkloads -Value 1
    Set-DbaSpConfigure -SqlInstance $server -ConfigName RemoteDacConnectionsEnabled -Value 1
    Set-DbaSpConfigure -SqlInstance $server -ConfigName ShowAdvancedOptions -Value 1
    # Insert all your config options here

    Set-DbaPowerPlan -ComputerName $server
    Set-DbaDbOwner -SqlInstance $server

    # Suppress all successful backups in SQL server error log
    Enable-DbaTraceFlag -SqlInstance $server -TraceFlag 3226

    # Set max memory to the recommended MB
    Set-DbaMaxMemory -SqlInstance $server
}