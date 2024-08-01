
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
	FILENAME='D:\isdb\SQL\Evidence\code\file\t_sql_data_file.mdf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=10%

)
LOG ON(
	NAME='t_sql_log_file',
	FILENAME='D:\isdb\SQL\Evidence\code\file\t_sql_log_file.ldf',
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

--Evidence 4

/*
Evidence 4 
 
A. Create a table ‘Trainees’ with columns as below 
 
Column Name Key Data Type Length Constraint Allow Nulls 
TraineeID Primary Key CHAR 9 Value must have 
9 digits 
no 
TraineeName  Varchar 40  No 
Batch  Varchar 20  No 
B. Show the constraints present in the table 
C. Insert some test data 
*/
IF EXISTS (
	SELECT * FROM sys.objects where object_id= OBJECT_ID('Trainees') AND type in ('U')
)
BEGIN
	DROP TABLE Trainees
END;
GO
CREATE TABLE Trainees
(
	TraineeID CHAR(9) NOT NULL PRIMARY KEY CHECK(LEN(TraineeID)=9),
	TraineeName VARCHAR(40) NOT NULL,
	Batch VARCHAR(20)
);
GO
-- Query to show the constraints present in the Trainees table
EXEC sp_helpconstraint Trainees;
GO
-- Query to show the constraints present in the Trainees table
SELECT 
    tc.CONSTRAINT_NAME, 
    tc.CONSTRAINT_TYPE, 
    ccu.COLUMN_NAME 
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc 
    JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu 
    ON tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME 
WHERE 
    tc.TABLE_NAME = 'Trainees';
GO
--C. Insert some test data 
INSERT INTO Trainees
VALUES('001284615','Samaul','61');
GO
INSERT INTO Trainees
VALUES
('001284616', 'Arafat','61');
GO

SELECT * FROM Trainees;
GO


/*
Evidence 5 
 
A. Create tables ‘tsps’ and  ‘Trainees’ with columns and relation as below 
 
 
   
tsps
 tspid int No
 tspname varchar(50) Yes
 Column Name Condensed Type Nullable Identity
 Trainees
 traineeid int No
 traineename varchar(50) No
 tspid int Yes
 Column Name Condensed Type Nullable Identity
 
 
B. Insert some test data into both tables 
C. Create a view that shows all trainee info with which tsp each trainee is in. 
*/

IF EXISTS(SELECT * FROM sys.objects WHERE object_id= OBJECT_ID('tsps') AND type in('U'))
BEGIN
	DROP TABLE tsps
END
CREATE TABLE tsps(
	tspid INT NOT NULL IDENTITY PRIMARY KEY,
	tspname VARCHAR(50)
);
GO




IF EXISTS (SELECT * FROM  sys.objects WHERE object_id=OBJECT_ID('Trainees') AND type in('U')

)
BEGIN
	DROP TABLE Trainees
END
CREATE TABLE Trainees
(
	traineeid INT NOT NULL PRIMARY KEY IDENTITY,
	traineename VARCHAR(50),
	tspid INT REFERENCES tsps(tspid)
);
GO

--B. Insert some test data into both tables 
INSERT INTO tsps
VALUES('US Software ltd');
GO

INSERT INTO Trainees
VALUES
('Md Samaul Islam',1),
('Arafat',1),
('Mimma',1);
GO

--C. Create a view that shows all trainee info with which tsp each trainee is in. 
CREATE VIEW JustView 
	AS
	SELECT tr.traineeid, tr.traineename,ts.tspname
	FROM Trainees tr
	JOIN tsps ts
	ON tr.tspid=ts.tspid
	GO


select * from JustView;
go

/*
Evidence 6 
 
A. create a table persons which has two columns 
person id: auto incrementing value by the SQL server starting from 100 and incrementing by 5 
person name: holds textual data, maximum 30 characters 
B. Enter the following person names to the table 
Kamal, Jamal, Aslam 
C. Show me the data is present in the table 
*/

--A. create a table persons which has two columns 
--person id: auto incrementing value by the SQL server starting from 100 and incrementing by 5 
--person name: holds textual data, maximum 30 characters 
CREATE TABLE persons
(
	personid INT NOT NULL IDENTITY(100,5) PRIMARY KEY,
	personname VARCHAR(30)
);
GO
--Enter the following person names to the table 
--Kamal, Jamal, Aslam 
INSERT INTO persons
VALUES
('Kamal'),('Jamal'),('Aslam');
GO