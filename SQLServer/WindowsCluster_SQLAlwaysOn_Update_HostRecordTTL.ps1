#https://technet.microsoft.com/en-us/library/ee460984.aspx
 
Get-Cluster -Name "COGNOSSQLCLUST.teladoc.net" |FT *SUBNET*

Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" | Get-ClusterParameter
 
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'Cluster Name' | Get-ClusterParameter HostRecordTTL,RegisterAllProvidersIP
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'PSQL09AG01_PSQL09LG01' | Get-ClusterParameter HostRecordTTL,RegisterAllProvidersIP
  
#https://docs.microsoft.com/en-us/sql/database-engine/availability-groups/windows/create-or-configure-an-availability-group-listener-sql-server#HostRecordTTL
#Cluster PCLUSQL03 didnt have an issue. I just got the values to compare settings.
#Also, to compare I ran a Validate Cluster Report on both Clusters using the Failover Cluster Manager console.
#Needed to fix only Cluster COGNOSSQLCLUST.teladoc.net and Listener PSQL09LG01 TTLs and Registers for MultiSubnetFailover=True and Legacy clients.
 
#Update Cluster
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'Cluster Name' | Set-ClusterParameter RegisterAllProvidersIP 0
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'Cluster Name' | Set-ClusterParameter HostRecordTTL 300
#Update LG
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Set-ClusterParameter RegisterAllProvidersIP 0
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Set-ClusterParameter HostRecordTTL 300
 
#Restart Resources
Stop-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD'
Start-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD'
Start-Sleep -s 10
Stop-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'Cluster Name'
Start-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'Cluster Name'
 
####################### FIX #######################
#https://blogs.msdn.microsoft.com/alwaysonpro/2014/06/03/connection-timeouts-in-multi-subnet-availability-group/
 
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net"
 
#4. Set HostRecordTTL and RegisterAllProvidersIP
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Set-ClusterParameter HostRecordTTL 300
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Set-ClusterParameter RegisterAllProvidersIP 0
 
#5. Temporarily remove dependency between the availability group resource and the listener name resource.
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" | Remove-ClusterResourceDependency -Resource 'SQLCOGNOSPRD' -Provider 'SQLCOGNOSPRD_SQLCOGNOSPRD'
 
#Restart Resources
Stop-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD'
Start-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD'
 
#To force updating DNS on Windows Server 2012 or 2012 R2:
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Update-ClusterNetworkNameResource
 
#7. Re-add the dependency of the AG resource on the Listener name resource.
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" |  Add-ClusterResourceDependency -Resource 'SQLCOGNOSPRD' -Provider 'SQLCOGNOSPRD_SQLCOGNOSPRD'
 
#8. VERIFY
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" | Get-ClusterResourceDependency -Name 'SQLCOGNOSPRD'
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net" -Name 'SQLCOGNOSPRD_SQLCOGNOSPRD' | Get-ClusterParameter HostRecordTTL,RegisterAllProvidersIP
Get-ClusterResource -Cluster "COGNOSSQLCLUST.teladoc.net"
 
ping PSQL09LG01
ipconfig /flushdns
ping PSQL09LG01
ipconfig /flushdns
ping PSQL09LG01