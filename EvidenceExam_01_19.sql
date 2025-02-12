
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
--C. Add a data file �ESAD_data1� of size 5MB to the database with other default options 
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
A. Create a table �Trainees� with columns as below 
 
Column Name Key Data Type Length Auto increament Allow Nulls 
TraineeID Primary Key int  Yes no 
TraineeName  Varchar 40  No 
Batch  Varchar 20  No 
You have to make sure that if Trainees table in the current database, the table will be deleted first  
[Hint: use if exists(�.)] 
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
 
A. Create a table �Trainees� with columns as below 
 
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
 
A. Create tables �tsps� and  �Trainees� with columns and relation as below 
 
 
   
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
 
A. Create a table �Contacts� with columns as below 
 
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
--A. Create a table �Contacts� with columns as below
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
 
A. Create a table �Books with columns as below 
 
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
--A. Create a table �Books with columns as below
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
 
D. Create a table �Expenses� with columns as below 
 
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

--D. Create a table �Expenses� with columns as below
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
 
A. Create a table �Orders� with columns as below 
 
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

--A. Create a table �Orders� with columns as below

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
 
A. Create a table �Orders� with columns as below 
 
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

--A. Create a table �Orders� with columns as below 
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
alter table orders
add constraint chk_Quantity check(Quantity>0);
go

--D. Add Default value Current Date for OrderDate Column 
alter table orders
add constraint def_orderdata default getdate() for OrderDate;
go

--Check that constrains are created for the table 
exec sp_helpconstraint Orders;
go

/*
Evidence 13 
 
A. Create two tables and create relationship between then as shown below 
 
B. Insert Following Data in Categories Table 
CategoryId  CategoryName     ----------- ---------------  
1           Beverages 
2           Condiments 
3           Confections 
C. Insert Following data in Products table 
productid   productname                              categoryid  unitprice              
 ----------- ----------------------------------------  -----------  ---------------------  
 1           Chai                                      1            18.0000 
 2           Chang                                     1             19.0000 
 3           Aniseed Syrup                            2             10.0000 
 4           Chef Anton's Cajun Seasoning         2             22.0000 
 5           Chef Anton's Gumbo Mix                 2            21.3500 
 6           Grandma's Boysenberry Spread       2            25.0000 
*/

--A. Create two tables and create relationship between then as shown below 
create table Categories(
CategoryID int not null primary key,
CategoryName nvarchar(15) not null
);
go

create table Products(
	ProductID int not null primary key,
	ProductName nvarchar(40) not null,
	CategoryId int null,
	UnitPrice money null,
	foreign key (CategoryID) references Categories(CategoryID)
);
go

--Insert Following Data in Categories Table
insert into Categories
values
(1,'Beverages'),
(2,'Condiments'),
(3,'Confections');
go

-- Insert Following data in Products table 
insert into Products
values
(1,'Chai',1,18000),
(2,'Chang',1,19000),
(3,'Chef Anton''s Cajun Seasoning',2,10000),
(4,'Chef Anton''s Cajun Seasoning',2,22000),
(5,'Chef Anton''s Gumbo Mix',2,21000),
(6,'Grandma''Boysenberry Spread',2,25000);
go

--see the table
select * from Products;

/*
	Evidence 14 
 
A. Create two table as shown below 
 
B. Create relation between two table on CategoryId-to-CategoryId columns with cascade delete rule 
 
C. Insert Following Data in Categories Table 
CategoryId  CategoryName     ----------- ---------------  
1           Beverages 
2           Condiments 
3           Confections 
   
D. Insert Following data in Products table 
productid   productname                              categoryid  unitprice              
 ----------- ----------------------------------------  -----------  ---------------------  
 1           Chai                                      1            18.0000 
 2           Chang                                     1             19.0000 
 3           Aniseed Syrup                            2             10.0000 
 4           Chef Anton's Cajun Seasoning         2             22.0000 
 5           Chef Anton's Gumbo Mix                 2            21.3500 
 6           Grandma's Boysenberry Spread       2            25.0000 
E. Now delete the row with CategoryID 1 from Categories table 
F. Show that Children of the deleted category are deleted automatically 
*/

--A. Create two table as shown below 
create table Categories
(
	CategoruID int not null primary key,
	CategoryName nvarchar(15) not null
);
go

create table Products(
	ProductID int not null primary key,
	ProductName nvarchar(40) not null,
	CategoryID int null ,
	UnitPrice money null
);
go

--B. Create relation between two table on CategoryId-to-CategoryId columns with cascade delete rule 
alter table Products
add constraint fk_productid foreign key (CategoryID)
references Categories(CategoruID)
on delete cascade;
go

--Insert Following Data in Categories Table
insert into categories
values
(1,'Beverages'),
(2,'Condiments'),
(3,'Confections');
go

--Insert Following data in Products table 
insert into Products
values
(1,'Chai',1,18000),
(2,'Chang',1,19000),
(3,'Aniseed Syrup',2,10000),
(4,'Chef Anton''s Cajun Seasoning',2,22000),
(5,'Chef Anton''s Gumbo Mix',2,21000),
(6,'Grandma''s Boysenberry Spread',2,25000);
go

--E. Now delete the row with CategoryID 1 from Categories table 
delete Categories
where CategoruID=1;
go

---F. Show that Children of the deleted category are deleted automatically 
select * from Categories;
go

select * from Products;
go

/*
Evidence 15 
 
A. Create a table Reservations as defined 
 
Column Datatype Nullability 
Id IDENTITY NOT NULL 
Room INT NOT NULL 
Date DateTime NOT NULL 
B. Create a stored procedure with appropriate parameters to insert data into the Reservations table.  
C. Insert the following data into the table using the procedure you created 
Id Room Date 
1 105 2008-01-01 
2 109 2008-02-21 
3 114 2008-02-01 
D. Create a view that shows all the reservations in year 2008. 
E. Create a view that shows all the reservations in February of 2008.
*/
--A. Create a table Reservations as defined 

create table Reservations
(
	Id int identity not null primary key,
	Room int not null,
	Date datetime not null
);
go

--B. Create a stored procedure with appropriate parameters to insert data into the Reservations table.  
create procedure InsertReservations 
@room int,
@date datetime
as
begin 
	insert into Reservations (Room, Date)
	values(@room,@date);
end


--C. Insert the following data into the table using the procedure you created 
exec InsertReservations @room=105, @date = '2008-01-01'; 
exec  InsertReservations @room=109, @date='2008-02-21';
exec  InsertReservations @room=114, @date='2008-02-01';

--D. Create a view that shows all the reservations in year 2008. 
create view showReservations as
select id, Room, date
from Reservations
where year(date)=2008;
go

--E. Create a view that shows all the reservations in February of 2008. 
create view showReservationsFeb as
select *
from Reservations
where year(date) = 2008 and month(date)=2;
go


select * 
from showReservations;
go

select * 
from showReservationsFeb;
go

/*
Evidence 16 
 
A. Create the �Promotion Sales� as described below 
Column Datatype Nullability 
Product VARCHAR(30) NOT NULL 
Price MONEY NOT NULL 
DiscountRate INT NOT NULL 
 
B. Create a stored procedure to insert data into the �Promotion Sales� table. Define necessary parameter and make sure 
the parameter for DiscountRate value has default value 5 so that if DiscountRate is not supplied, the default value is 
inserted. 
C.  Insert the following records into  �Promotion Sales� using the procedure 
Product Price DiscountRate 
Jeans 1050 12 
Shoe 1200 7 
Shirt 800 5 
 
D. Create a view that select all the column in �Promotion Sales� and an extra column that shows discounted price by 
deducting discount from price. A query on the view will a resultset like below 
Product Price DiscountRate DiscountedPrice 
Jeans 1050.00 12 924.00 
Shoe 1200.00 7 1116.00 
Shirt 800.00 5 760.00 
*/

--A. Create the �Promotion Sales� as described below 
create table PromotionSales
(
	Product varchar(30) not null,
	Price money not null,
	DiscountRate int not null
);
go

--Create a stored procedure to insert data into the �Promotion Sales� table. Define necessary parameter and make sure 
--the parameter for DiscountRate value has default value 5 so that if DiscountRate is not supplied, the default value is 
--inserted. 
create procedure insertPromotionSales 
@Product varchar(30),
@Price money,
@DiscountRate int = 5
as
begin
	insert into PromotionSales
	values(@Product, @Price, @DiscountRate);

end;
go

--C.  Insert the following records into  �Promotion Sales� using the procedure
exec insertPromotionSales 'Jeans',1050,12;
exec insertPromotionSales 'Shoe',1200,7;
exec insertPromotionSales 'Shirt',800,5;

select  * from PromotionSales;


--Create a view that select all the column in �Promotion Sales� and an extra column that shows discounted price by 
--deducting discount from price. A query on the view will a resultset like below 
create view viewPromotionSales
as
select Product, Price, DiscountRate, Price- (Price*DiscountRate/100) as DiscountPrice
from PromotionSales;

select *
from viewPromotionSales;



/*
Evidence 17
A. Create a table �Classes� as Described
Column Datatype Nullability
ClassId INT NOT NULL
Description VARCHAR(100) NOT NULL
ClassHour INT NOT NULL
B. You want to apply procedural integrity on column CourseHour instead of check constraint. Create procedure to insert data 
into �Classes� table and make sure that value in ClassHour column is not less than 2. 
C. Insert some test values and show that the integrity rule is working 
*/

--A. Create a table �Classes� as Described
create table Classes
(
	ClassId int not null primary key,
	Description varchar(100) not null,
	ClassHour int not null
);
go

create procedure InsertClass
@ClassId int,
@ClassName varchar(50),
@CourseHour int
as
begin
	if @CourseHour>2
	begin
	insert into Classes
	values(@ClassId, @ClassName, @CourseHour);
	end;
	else
	begin
	raiserror('Class hour must be at least 2.',16,1);
	end
end;
go

--C. Insert some test values and show that the integrity rule is working
exec InsertClass 1,'sql server',3;
exec InsertClass 1,'sql server',1;

/*
Evidence 18
A. You have the following two tables as described 
B. The two tables have the following data 
Trainees Exam_results
id name id marks
1 Kamal 1 75.5
2 Rahmat 2 89.3
3 salma 3 67
4 Enam
C. Show me the name of the trainees along with marks like below 
Kamal 75.5
Rahmat 89.3
Salma 67
D. Show me the name of the trainees along with marks but include all the trainees whose marks is not available like below 
Kamal 75.5
Rahmat 89.3
Salma 67
Enam NULL
E. Find out the name of the trainees who got highest marks 
F. Find out the name of the trainees who got lowest marks 
G. Find out average marks obtained by trainees 
*/

--A. You have the following two tables as described 

drop table Trainees;
create table Trainees(
	id int primary key,
	name varchar(40)
);
go

create table exam_result(
id int primary key,
marks float,
constraint fk_trainees_id foreign key(id) references Trainees(id)
);
go

--The two tables have the following data
insert into Trainees
values
(1,'Kamal'),
(2,'Rahmat'),
(3,'Salma'),
(4,'Enam');
go


insert into exam_result
values
(1,75.5),
(2,83.3),
(3,67);
go

--Show me the name of the trainees along with marks like below 
select t.name, e.marks
from Trainees t join exam_result e
on t.id=e.id;

--D. Show me the name of the trainees along with marks but include all the trainees whose marks is not available like below

select distinct t.name, e.marks
from Trainees t left join exam_result e
on t.id=e.id;
go

--E. Find out the name of the trainees who got highest marks 
select t.name, max(marks)
from Trainees t
join exam_result e
on t.id=e.id
group by e.marks, t.name
go

select max(marks) as h
from exam_result;

select t.name
from Trainees t
join exam_result e on t.id= e.id
where e.marks = (select max(marks) from exam_result);
go

--. Find out the name of the trainees who got lowest marks
select min(marks) from exam_result;

select t.name 
from Trainees t join exam_result e
on t.id= e.id 
where e.marks = (select min(marks) from exam_result);
go

--Find out average marks obtained by trainees
select cast(avg(marks) as decimal(10,2))
from exam_result;

/*
Evidence 19
All the works are based on Northwind sample database in SQL Server 2016. 
A. Create view that selects CustomerId, CompanyName, Country, City column from Customers table 
a. test the view 
b. extract SQL commands used in creating the view 
B. Show customers who live in USA, UK and Germany along with CustomerId, CompanyName,and Country. And also sort the 
resultset by Country in Descending order 
C. Show customers who live in USA, UK and Germany along with CustmerId, CompanyName,and County. But you want to 
change column heads � Customer Code for CustomerID column, �Company� for ComanyName column and �Origin� for 
Country column. 
D. Show order information from Orders table for orders placed between date January 01, 1997 and December 31, 2000. 
E. Show cusomers� information from Customers table only for those customers whose CompanyName starts with letter �A�.
F. Show the latest 3 orders from Orders table. 
G. Show the oldest 3 orders from Orders table. 
H. Show all orders from Orders for each customer along with CustomerID, ComapnyName, OrderID, OrderDate. 
I. Show all orders from Orders for each customer along with cusomerID, ComapnyName, OrderID, OrderDate and also you 
want to include all the rows from Customers table. [Hint: left outer join] 
J. You have to prepare a list of cities in which there are customers along with any employees in these cities. In addition, if 
there is an employee in a city with no customers, they should be included. Include customerID, City from Customers table 
and FirstName, City from employees table. 
K. Show No of Customers in Customers table. 
L. Show No of Customers by Country from Customers table 
M. Show No of Customers living in �USA� from Customers table 
N. Show how many orders each customer placed. 
O. Show each customer and the dollar amount (sum of order value) for that customer. 
P. Show the list of customers� cities but including duplicate cities once. 
Q. Show the list of customers� cities from both Customers and Employees but including duplicate cities once
R. Select information of Customers who live in cities where at least one Employee lives.
*/
--All the works are based on Northwind sample database in SQL Server 2016. 
use Northwind;
go

--A. Create view that selects CustomerId, CompanyName, Country, City column from Customers table 


create view viewCustomers as
select CustomerID, CompanyName, Country, City
from Customers;
go

--a. test the view 

select * from viewCustomers;
go

--extract SQL commands used in creating the view

select OBJECT_DEFINITION(OBJECT_ID('viewCustomers'));
go
--B. Show customers who live in USA, UK and Germany along with CustomerId, CompanyName,and Country. And also sort the 
--resultset by Country in Descending order 

select CustomerID, CompanyName,Country
from customers
where Country in ('usa', 'uk','germany')
order by Country desc;
go

--C. Show customers who live in USA, UK and Germany along with CustmerId, CompanyName,and County. But you want to 
--change column heads � Customer Code for CustomerID column, �Company� for ComanyName column and �Origin� for 
--Country column

select CustomerID 'Customer Code', CompanyName 'company', Country 'Origin'
from customers
where Country in ('usa','uk', 'germany');
go


--D. Show order information from Orders table for orders placed between date January 01, 1997 and December 31, 2000. 
select *
from Orders
where OrderDate between '1997-01-01' and '2000-12-31';
go

--E. Show cusomers� information from Customers table only for those customers whose CompanyName starts with letter �A�
select *
from Customers 
where CompanyName like 'A%';
go

--F. Show the latest 3 orders from Orders table.
select top 3 * 
from Orders
order by OrderDate desc

--G. Show the oldest 3 orders from Orders table. 
--F. Show the latest 3 orders from Orders table.
select top 3 * 
from Orders
order by OrderDate asc


--H. Show all orders from Orders for each customer along with CustomerID, ComapnyName, OrderID, OrderDate.
select o.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
from Orders o, Customers c;

--I. Show all orders from Orders for each customer along with cusomerID, ComapnyName, OrderID, OrderDate and also you 
--want to include all the rows from Customers table. [Hint: left outer join]

select o.CustomerID, c.CompanyName, o.OrderID, o.OrderDate
from Orders o
left outer join Customers c
on o.CustomerID= c.CustomerID;
go

--J. You have to prepare a list of cities in which there are customers along with any employees in these cities. In addition, if 
--there is an employee in a city with no customers, they should be included. Include customerID, City from Customers table 
--and FirstName, City from employees table. 
select c.CustomerID, c.City as customercity , e.FirstName, e.City
from Customers c
full outer join Employees e
on c.City=e.City
order by coalesce(c.City, e.City);
go

--K. Show No of Customers in Customers table.
select count(*) NumberOfCustomers
from Customers;
go

--L. Show No of Customers by Country from Customers table
select country, count(country) NumberOfCountry
from Customers
group by Country
order by NumberOfCountry asc;
go

--M. Show No of Customers living in �USA� from Customers table
select count('usa')
from Customers
where Country = 'usa';
go

--N. Show how many orders each customer placed.
select c.CustomerID, c.CompanyName, count(OrderID) NumberOfOrders
from Customers c join Orders o
on c.CustomerID =o.CustomerID
group by c.CustomerID, c.CompanyName;

--O. Show each customer and the dollar amount (sum of order value) for that customer. 
select c.CustomerID, c.CompanyName, sum(o.Freight) totalOrderValue
from Customers c
join Orders o
on c.CustomerID= o.CustomerID
group by c.CustomerID, c.CompanyName;
go

--P. Show the list of customers� cities but including duplicate cities once

select distinct City
from Customers
go

--Q. Show the list of customers� cities from both Customers and Employees but including duplicate cities once
select City
from Customers
union
select city
from  Employees;


--R. Select information of Customers who live in cities where at least one Employee lives.

select *
from Customers c
inner join Employees e
on c.City= e.City;
go