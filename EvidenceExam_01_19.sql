
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
--C. Show me the data is present in the table 
SELECT * FROM persons;
GO

/*
Evidence 7 
 
A. A table has two column 
Column 1 : auto incrementing integer value, SQL Server to generate automatically 
Column 2 : GUID value, SQL Server to generate automatically 
B. Insert 5 rows of data into the table 
C. Find out the last values inserted into the column 1 
D. You want to insert a row with value 250 in Column 1. Show how you do it. 
E. Show me all the rows in the table
*/

create table ev7(
column1 INT IDENTITY,
column2 UNIQUEIDENTIFIER
);
GO

INSERT INTO ev7
VALUES
(NEWID()),
(NEWID()),
(NEWID()),
(NEWID()),
(NEWID()),
(NEWID());
GO

SELECT * FROM ev7;

--C. Find out the last values inserted into the column 1 
select @@IDENTITY


--D. You want to insert a row with value 250 in Column 1. Show how you do it.
set identity_insert ev7 on;
insert into ev7 (column1, column2)
values(250, newid());
go
set identity_insert ev7 off;
--E. Show me all the rows in the table 
select * from ev7;


/*
Evidence 8 
 
A. Create a table ‘Contacts’ with columns as below 
 
Column Name Data Type Length Allow Nulls 
ContactID Int  No 
ContactName Varchar 30 No 
B. Change the length of ContactName column to 50 
C. Add the following columns to the table 
 
Column Name Data Type Length Allow Nulls 
ContactTel Varchar 16 Yes 
ContactCell Varchar 16 Yes 
 
 
D. Insert following data into the table 
 
ContactID ContactName ContactTel ContactCell 
1 Quazi Ashique  0172889933 
2 Hasinur Shahid 805098 0152980890 
3 Mir Mosharaf  0181076543 
4 Shaheen Akter   
   
E. Add the following column to the table 
 
Column Name Data Type Length Allow Nulls Default value 
ContactAddress Varchar 100 No Not available 
F. Show me all the rows in the table. 
*/
use T_SQL;
go
--A. Create a table ‘Contacts’ with columns as below
create table Contacts
(
	ContactID int not null,
	ContactName varchar(30) not null
);
go
--B. Change the length of ContactName column to 50 
alter table Contacts
alter column ContactName varchar(50);
go
--see the size
exec sp_help Contacts;
go

--C. Add the following columns to the table
alter table Contacts
add 
	ContactTel varchar(16),
	ContactCell varchar(16);
go
--Insert following data into the table
insert into Contacts
values
(1,'Quazi Ashique','','0172889933'),
(2,'Hasinur Shahid','805098','0152980890'),
(3,'Mir Mosharaf','','0181076543'),
(4,'Shaheen Akter','','');
go

--E. Add the following column to the table
alter table Contacts
add ContactAddress varchar(100) not null default 'Not avilable';
go

--F. Show me all the rows in the table. 
select * from Contacts;
go


/*
Evidence 9 
 
A. Create a table ‘Books with columns as below 
 
Column Name Data Type Length Allow Nulls Default value 
Name char 30 No  
Publisher Varchar 30 No N/A 
Price Money  Yes  
Publish Smalldatetime  Yes  
CurrentEdition Int  No 1 
Available Bit  No 0 
B. Insert following data into the table 
 
Name Publisher Price Publish CurrentEdition Available 
Programming Practice Show&Tell Consulting 600.00 2004-01-01 3 1 
Introducing C# Show&Tell Consulting 700.00 2003-03-03 4 0 
SQL Server 2000 BPB 1000.00 2002-01-01 2 1 
XML N/A 700.00  1 0
*/
--A. Create a table ‘Books with columns as below
create table Books
(
	Name char(30) not null default 'N/A',
	Publisher varchar(30) not null ,
	Price money,
	Publish smalldatetime,
	CurrentEdition int not null default 1,
	Available bit not null default 0
);
go

--B. Insert following data into the table 
insert into  Books 
values
('Programming Practice','Show&Tell Consulting',600.00,'2004-01-01',3,1),
('Introducing C#','Show&Tell Consulting',700.00,'2003-01-01',3,0),
('SQL Server 2000','BPB',1000.00,'2002-01-01',2,1),
('XML','N/A',700.00,'',1,0);
go

SELECT * from books;

/*
Evidence 10 
 
D. Create a table ‘Expenses’ with columns as below 
 
Column Name Computed Data Type Length Allow Nulls Formula 
date  Smalldatetime  No  
Item  Varchar 40 No  
Price  Money  No  
Quantity  Int  No  
Amount Yes    Price * Quantity 
E. Today you have the following expenses 
 
Item Price Quantity 
Travel Bag 450 1 
Punjabi 250 2 
Tooth brush 15 3 
 Insert these data to expenses table 
F. Show all data from the table 
*/

--D. Create a table ‘Expenses’ with columns as below
create table Expenses(
	date smalldatetime not null,
	Item varchar(40) not null,
	Price money not null,
	Quantity int not null,
	Amount AS (price*Quantity)
);
go
--E. Today you have the following expenses
insert into Expenses
values
(getdate(),'Travel Bag',450,1),
(getdate(),'Punjabi',250,2),
(getdate(),'Tooth Brush',15,3);
go

--Show all data from the table 
select * from Expenses;
go


/*
Evidence 11 
 
A. Create a table ‘Orders’ with columns as below 
 
Column Name Data Type Auto increament Allow Nulls Constraint 
OrderId Int Yes No Primary Key 
OrderDate SmalldateTime  No Default value Current 
Date 
ProductId Int  No  
Quantity Int  No it is always over 0 
ShipDate SmalldateTime  Yes It must be greater 
than Orderdate 
B. Show me Constraints in the table 
C. Drop default constraint from OrderDate column in the table 
D. Drop the table
*/

--A. Create a table ‘Orders’ with columns as below

create table Orders
(
	OrderId int identity not null primary key,
	OderDate smalldatetime not null default getdate(),
	ProductId int not null,
	Quantity int not null check(Quantity>0),
	ShipDate smalldatetime ,
	check(ShipDate>OderDate)
);
go

--B. Show me Constraints in the table
exec  sp_helpconstraint Orders;
go

--C. Drop default constraint from OrderDate column in the table
alter table Orders
drop constraint DF__Orders__OderDate__48CFD27E;
go

--D. Drop the table 
drop table Orders;
go

/*
Evidence 12 
 
A. Create a table ‘Orders’ with columns as below 
 
Column Name Data Type Auto increament Allow Nulls 
OrderId Int Yes No 
OrderDate SmalldateTime  Not Null 
ProductId Int  No 
 
   
Quantity Int  No 
ShipDate SmalldateTime  Yes 
 
B. Add Primary Key to OrderId Column at Orders Table 
C. Add Check constraint for Quantity column so that it is always greater than 0 
D. Add Default value Current Date for OrderDate Column 
E. Check that constrains are created for the table
*/

--A. Create a table ‘Orders’ with columns as below 
create table Orders(
	OrderId int identity not null,
	OrderDate smalldatetime not null,
	ProductId int not null,
	Quantity int not null,
	ShipDate smalldatetime ,
);
go

--B. Add Primary Key to OrderId Column at Orders Table 
alter table Orders
add constraint PK_OrderId primary key (Orderid);

--C. Add Check constraint for Quantity column so that it is always greater than 0