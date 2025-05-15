--Run the following command to create the service master key in the master database. 
--Remember to document the password used for encrypting the service master key and keep it in a secure place.

USE MASTER  
GO  
CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'StrongPasswordHere' 
GO 

--Run the following command to create a certificate to encrypt the database encryption keys on the TDE-enabled databases. 
--This certificate will be protected by the service master key. 

CREATE CERTIFICATE TDECert 
WITH SUBJECT = 'My TDE Certificate for all user database'

--Run the following command to associate the certificate to user database [<DB_NAME>]
USE [<DB_NAME>]  
GO  
CREATE DATABASE ENCRYPTION KEY  
WITH ALGORITHM = AES_256  
ENCRYPTION BY SERVER CERTIFICATE TDECert 
GO 

--Run the following command to turn on TDE on the database. 

ALTER DATABASE [<DB_NAME>] 
SET ENCRYPTION ON

--After this point of time, database is encrypted

--Run the following command to backup the certificate to a file.
USE MASTER  
GO  
BACKUP CERTIFICATE TDECert   
TO FILE = 'C:\TDECert_File.cer'  
WITH PRIVATE KEY (FILE = 'C:\TDECert_Key.pvk' ,  
ENCRYPTION BY PASSWORD = 'StrongPasswordHere' )  
GO
