use bank
go
declare  @name varchar
select @name = cust_name 
from customer join account on customer.Cust_id=account.cust_id
where ac_type='1'
--gán biến id sẽ bằng cust id của KH có tên là Hà công lực, in biến id ra màn hình
-- @ls 
go
-- Thêm 1 customer "A" vào bảng customer
declare @id int
select top 1 @id= cust_id
from customer 
order by Cust_id desc

select concat('0000',cast((@id+1) as char))



insert into customer values('id','name','phone','ad','br')
--tính tổng tamount những giao dịch trog quý 3 202b
select  sum(t_amount) 
from transactions
where YEAR(t_date) = 2014 and MONTH(t_date) between 6 and 9
DATEDIFF(dangthoigian, thoigian1, thoigian2)
go
declare @n int, @i int
set @n =7
set @i=0
while(@i<=@n) 
	begin 
		if(@i%2=1) print @i
		set @i=@i+1
	end
go
declare @n int, @i int
set @n =7
set @i=0
while(@i<=@n) 
	begin 
		if(@i%2=0) print @i
		set @i=@i+1
	end
declare @hang int =1, @sao int, @max int =5, @chuoi varchar(50) =''
while @hang <=@max
begin
	set @sao = @hang 
	while @sao > 0
	begin
		set @chuoi = @chuoi + '*'
		set @sao = @sao - 1
	end
	print @chuoi
	set @chuoi = ''
	set @hang = @hang + 1
end