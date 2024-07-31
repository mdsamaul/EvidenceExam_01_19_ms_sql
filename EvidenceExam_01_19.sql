--evidence 1

--A. Show me all the databases under the SQL Server you are working 
SELECT * FROM SYS.DATABASES;
GO
--B. Create a database named ESAD 
CREATE DATABASE ESAD
ON PRIMARY(
	NAME='esad_data_file',
	FILENAME='D:\isdb\SQL\Evidence\code\EvidenceExam_01_19\file\esad_data_file.mdf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%
)
LOG ON(
	NAME='esad_log_file',
	FILENAME='D:\isdb\SQL\Evidence\code\EvidenceExam_01_19\file\esad_log_file.ldf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%
);
GO
--C. Show me what files are created by SQL Server and their locations, size etc. 
USE ESAD;
GO
EXEC sp_helpfile;
GO
--D. Drop the database 
USE master;
GO
DROP DATABASE ESAD;
GO
--[You must use only T-SQL statements] 

--evidence 2
/*
A. Create a database using T-SQL with  
One primary data file of 
    Size: 10MB 
  Filegrowth: 10% 
  Maxsize: 100MB 
One Log file of 
    Size: 10MB 
  Filegrowth: 10% 
  Maxsize: 100MB 
*/
CREATE DATABASE T_SQL
ON PRIMARY(
	NAME='t_sql_data_file',
	FILENAME='D:\isdb\SQL\Evidence\code\EvidenceExam_01_19\file\t_sql_data_file.mdf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%

)
LOG ON(
	NAME='t_sql_log_file',
	FILENAME='D:\isdb\SQL\Evidence\code\EvidenceExam_01_19\file\t_sql_log_file.ldf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%

);
GO
USE T_SQL;
GO
drop database T_SQL;
go
--B. Change the size of data file to 20MB 
ALTER DATABASE T_SQL
MODIFY FILE (
	NAME='t_sql_data_file',
	SIZE=20MB
);
GO
--C. Add a data file ‘ESAD_data1’ of size 5MB to the database with other default options 
ALTER DATABASE T_SQL
ADD FILE(
	NAME='ESAD_data1',
	FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ESAD_data1.ndf',
	SIZE=5MB
);
GO
--D. Rename the database to TraineeDB
ALTER DATABASE T_SQL
MODIFY  NAME=[1284615]
GO

EXEC sp_renamedb '1284615','T_SQL';
GO

--evidences 3
/*
A. Create a table ‘Trainees’ with columns as below 
 
Column Name Key Data Type Length Auto increament Allow Nulls 
TraineeID Primary Key int  Yes no 
TraineeName  Varchar 40  No 
Batch  Varchar 20  No 
You have to make sure that if Trainees table in the current database, the table will be deleted first  
[Hint: use if exists(….)] 
*/

CREATE DATABASE EV3;
GO
USE EV3;
GO
IF EXISTS (
SELECT * FROM sys.objects where object_id=OBJECT_ID('Trainees') AND type in (N'U'))
BEGIN 
	DROP TABLE Trainees;
END
GO

--CREATE
CREATE TABLE Trainees(
	TraineeID INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TraineeName VARCHAR(40) NOT NULL,
	Batch VARCHAR(20)
);
GO