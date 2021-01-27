
--2. lượng tiền trung bình có trong tk của khách thuộc chi nhánh đ nẵng
select avg(ac_balance)
from customer join account on customer.cust_id=account.cust_id
join branch on customer.br_id=branch.br_id
where br_name = N'Vietcombank Đà Nẵng'
--3. Có bn KH quê ở quảng nam nhưng mở ở CN đà nẵng
select count(cust_id) SLKH
from customer join Branch
on customer.Br_id=Branch.BR_id
where BR_name=N'Vietcombank Đà Nẵng' and Cust_ad LIKE N'%Quảng Nam%'
--4.Những chi nhánh nào thực hiện nhiều gd gửi tiền trong tháng 12/2015 hơn chi nhánh ĐN ?
select br_name, customer.br_id, count(t_id) SLGD
from Branch join customer on Branch.BR_id=customer.Br_id
join account on customer.Cust_id=account.cust_id
join transactions on transactions.ac_no=account.Ac_no
where t_type= '1'
and t_date between '2015/12/01' and '2015/12/31'
group by br_name, customer.br_id
having count(t_id) >
( select COUNT(t_id) SLGDĐN
from Branch join customer on Branch.BR_id = customer.Br_id
join account on customer.Cust_id = account.cust_id
join transactions on transactions.ac_no = account.Ac_no
where BR_name = N'Vietcombank Đà Nẵng'
group by Branch.BR_id
)
order by SLGD desc
--có bn kh có chi nhanh đn có tiền >100tr
select count(customer.Cust_id) SoLuongKH
from customer join account on customer.Cust_id=account.cust_id
join Branch on Branch.BR_id= customer.Br_id
where customer.Br_id = (select Br_id from Branch where BR_name like N'% Đà Nẵng')
and ac_balance > 100000000
--có bn kh cùng chi nhánh với Lê Tấn Anh Quốc
select count(cust_id)
from customer
where br_id = (select Br_id from customer where Cust_name = N'Lê Tấn Anh Quốc') and cust_name <> N'Lê Tấn Anh Quốc'
