create database QuanLy
go 
use QuanLy
Create table Store
(
	S_id char(5),
	S_name nvarchar(50),
	S_ad nvarchar(150),
	S_phone varchar(15),
	S_wifi varchar(20),
	Primary key (S_id)
)
Create table Employees
(
	E_id char(5),
	E_name nvarchar(50),
	E_dateofBirth date,
	E_phone varchar(15),
	E_ad nvarchar(50),
	E_identitycard varchar(10),
	E_position varchar(5),
	S_id char(5),
	Primary key (E_id),
	Foreign key (S_id) references Store
)
Create table Account
(
	A_account varchar(10),
	A_password varchar(10),
	E_id char(5),
	Primary key (A_account),
	Foreign key (E_id) references Employees
)
Create table Bills
(
	Bi_id char(5),
	Bi_date date,
	Bi_timeIn time,
	Bi_timeOut time,
	Bi_moneyTotal numeric(15),
	Bi_payment numeric(15),
	Bi_extraMoney numeric(15),
	E_id char(5),
	Primary key (Bi_id),
	Foreign key (E_id) references Employees
)
Create table Items
(
	I_Id char(5),
	I_name nvarchar(50),
	I_price numeric(15),
	Primary key (I_id)
)
Create table BillsDetail
(
	Bi_id char(5),
	I_Id char(5),
	I_name nvarchar(50),
	I_price numeric(15),
	I_Money numeric(15),
	Primary key(Bi_id,I_id),
	Foreign key (Bi_id) references Bills,
	Foreign key (I_id) references Items
)
go
Insert into Store values('S001',N'Ocha House',N'106 Ông Ích Khiêm, TP Đà Nẵng','0905967377',N'oachahouseoik')
select *from Store
go
Insert into Employees values('TN000',N'Trần Thị Hà','2000-02-27',335332906,N'k87/22 Ngũ Hành Sơn,TP Đà Nẵng','187852059',N'QL','S001')
Insert into Employees values('TN001',N'Trần Thị Hà','2000-02-27',335332906,N'k87/22 Ngũ Hành Sơn,TP Đà Nẵng','187852059',N'TN','S001')
Insert into Employees values('TN002',N'Nguyễn Thị Kim Oanh','2000-03-24',9888807404,N'10 Phan Tứ, TP Đà Nẵng','19625835',N'TN','S001')
select*from Employees
GO
Insert into Items values('I0001',N' ','0')
Insert into Items values('I0002',N'Việt Quất Đá Xay ','38000')
Insert into Items values('I0003',N'Trà Sữa Truyền Thống ','19000')
Insert into Items values('I0004',N'Trà Sữa Olong ','19000')
select*from Items
go
Insert into Account values(335332906,N'admin','TN001')
Insert into Account values(9888807404,N'admin','TN002')
Insert into Account values(N'admin',N'admin','TN000')
select*from Account
go
Insert into Bills values('BI001','2019-09-18','17:39:00.0000000','17:40:00.0000000','76000','100000','24000','TN001')
select*from Bills
go
Insert into BillsDetail values('BI001','I0001','1','38000','38000')
Insert into BillsDetail values('BI001','I0002','12','19000','19000')
Insert into BillsDetail values('BI001','I0003','2','19000','19000')
Select*from BillsDetail
--tạo index cho các thuôc tính
Create index ixAccount
on Account (A_account);
go
create index ixEmployees
on Employees (E_id);

---
Select*from BillsDetail
select*from Bills
select*from Account
select*from Items
select*from Employees
select *from Store