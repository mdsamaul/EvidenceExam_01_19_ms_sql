select *
from sys.databases;

create database esad;
go
use esad;
exec sp_helpfile;
use master;
drop database esad;

