Use the scripts to get SQL server inventory across HRT and Teladoc domains. Due to lack of network connectivity between
ITH domain and the admin server (BDDC1SQLCMS00.hrt.local), this script cannot gather server information from ITH servers.
You would have to download the powershell_scripts folder in its entirety and run it on a ITH domain server in order to 
gather server information.

Prerequisites: You will need to have dbatools module installed on your local machine for the scripts to work.
Alternatively, you can run the scripts by logging into BDDC1SQLCMS00 server.