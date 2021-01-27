/* 1  Viết đoạn code thực hiện việc chuyển đổi đầu số điện thoại di động 
theo quy định của bộ Thông tin và truyền thông cho một khách hàng bất kì, ví dụ với: Dương Ngọc Long */

 declare @cust_phone char(15)
 select @cust_phone =Cust_phone from customer where Cust_name =N'Hà Công Lực'
 
 if left(@cust_phone,4) in ('0120','0121','0122','0126','0128')
 begin 
   Update customer 
   set Cust_phone = REPLACE(@Cust_phone, '012','07')
   where Cust_name = N'Hà Công Lực'
   print N'Đã update lại số điện hoại khách hàng'
 end
else if left(@cust_phone,4) in ('0123', '0124','0125','0127','0129')
 begin 
       Update customer 
	   set Cust_phone = REPLACE(@Cust_phone, '012','08')
	   where Cust_name = N'Hà Công Lực'
	   print N'Đã update số điện hoại khách hàng'
 end
else if  left(@cust_phone,4) like '016%'
  begin 
       Update customer 
	   set Cust_phone = REPLACE(@Cust_phone, '016','03')
	   where Cust_name = N'Hà Công Lực'
	   print N'Đã update số điện hoại khách hàng'
  end
else if left(@cust_phone,4) like '018%'
  begin 
       Update customer 
	   set Cust_phone = REPLACE(@Cust_phone, '018','05')
	   where Cust_name =N'Hà Công Lực'
	   print N'Đã update số điện hoại khách hàng'
  end
else 
  print N'Số điện thoại đã đổi trước đó'


/* 2.	Trong vòng 1 năm trở lại đây Nguyễn Lê Minh Quân có thực hiện giao dịch nào không? Nếu có, 
hãy trừ 50.000 phí duy trì tài khoản. */ 
declare @acount int
select @acount = (select count(*) from transactions join account ON transactions.ac_no =account.Ac_no
                                                    join customer on account.cust_id =customer.Cust_id
				  where Cust_name =N'Nguyễn Lê Minh Quân'and year(getdate()) -year(t_date) =5)
print @acount 
IF @acount >0
begin
     UPDATE account set ac_balance =ac_balance -500000
     from account join customer on account.cust_id =customer.Cust_id
     where Cust_name =N'Nguyễn Lê Minh Quân'
end
else 
print ' Nguyen Le Minh Quan Chua thuc hien giao dich nao'

/*3.	Trần Quang Khải thực hiện giao dịch gần đây nhất vào thứ mấy? (thứ hai, thứ ba, thứ tư,…, chủ nhật) 
và vào mùa nào (mùa xuân, mùa hạ, mùa thu, mùa đông)? */ 
declare @t_date date, @thu varchar(50),@mua varchar(50)
select @t_date =(select top 1 t_date from transactions join account ON transactions.ac_no =account.Ac_no
                                                        join customer on account.cust_id =customer.Cust_id 
		     where Cust_name =N'Trần Quang Khải'
			 order by t_date desc ,t_time desc)
set @thu = case when   datepart(dw,@thu)=1 then 'Chu Nhat'
                when DATEPART(dw,@t_date) =2 then 'Thu Hai'
				when DATEPART(dw,@t_date) =3 then 'Thu Ba'
				when DATEPART(dw,@t_date) =4 then 'Thu Tu'
				when DATEPART(dw,@t_date) =5 then 'Thu Nam'
				when DATEPART(dw,@t_date) =6 then 'Thu Sau'
				else 'Thu bay'
			end
  print @thu
			
 set @mua= case DATEPART(QQ,@t_date) when 1 then 'Mua Xuan'
                                      when 2 then 'Mua Ha'
									  when 3 then 'Mua Thu'
									  else 'Mua Dong'
            end
 print @mua

--4.	Đưa ra nhận xét về nhà mạng mà Lê Anh Huy đang sử dụng? (Viettel, Mobi phone, Vinaphone, Vietnamobile, khác)
declare @phone nchar(15)
select @phone =(select cust_phone from customer where Cust_name =N'Lê Anh Huy')

IF @phone LIKE '016[2,3,4,5,6,7,8,9]%'OR @phone LIKE '03[2,3,4,5,6,7,8,9]%' or @phone like '09[6,7,8]%'
       print N'Lê Anh Huy sử dụng Viettel'
ELSE IF @phone like '012[0,1,2,6,8]%' or  @phone like '07[0,6,7,8,9]'
       print N'Lê Anh Huy sử dụng Mobiphone'
else if @phone like '012[3,4,5,7,9]%' or @phone like '09[1,4]%' or @phone like '08[1,5,8]%'
       print N'Lê Anh Huy sử dụng Vietnamobile'
else
       print N'Lê Anh Huy sử dụng số khác'
--5.	Số điện thoại của Trần Quang Khải là số tiến, số lùi hay số lộn xộn. 
--Định nghĩa: trừ 3 số đầu tiên, các số còn lại tăng dần gọi là số tiến, ví dụ: 098356789 là số tiến.
--6.	Hà Công Lực thực hiện giao dịch gần đây nhất vào buổi nào(sáng, trưa, chiều, tối, đêm)?
declare @buoi varchar(50)
set @buoi = (select top 1 t_time from transactions join account ON transactions.ac_no =account.Ac_no
                                              join customer on account.cust_id =customer.Cust_id 
		     where Cust_name =N'Hà Công Lực' 
			 order by t_date desc ,t_time desc )
if @buoi between '1:00'and'11:00'
   print 'Buoi sang'
else if @buoi between '11:00'and'12:00'
   print 'Buoi trua'
else if @buoi between '13:00'and'17:00'
   print 'Buoi chieu'
else if @buoi between '17:00'and'23:00'
   print 'Buoi toi'
else 
print 'Buoi dem'
--7.	Chi nhánh ngân hàng mà Trương Duy Tường đang sử dụng thuộc miền nào? 
--Gợi ý: nếu mã chi nhánh là VN  miền nam, VT  miền trung, VB  miền bắc, còn lại: bị sai mã.
declare @ac_brach varchar(50)
set @ac_brach = (select BR_id from  customer 
                 WHERE Cust_name =N'Trương Duy Tường')
IF @ac_brach like 'VB%'
    PRINT N'Chi nhánh Miền Bắc'
ELSE IF @ac_brach like 'VN%'
    PRINT N'Chi nhánh Miền Nam'
IF @ac_brach like 'Vt%'
    PRINT N'Chi nhánh Miền Trung'
else 
    PRINT N'Bị sai mã'

--8.	Căn cứ vào số điện thoại của Trần Phước Đạt, 
--hãy nhận định anh này dùng dịch vụ di động của hãng nào: Viettel, Mobi phone, Vina phone, hãng khác.
 DECLARE @t_Phone char(15)
 set @t_Phone = (select Cust_phone from customer where Cust_name =N'Trần Phước Đạt')

 IF @t_Phone LIKE '016[2,3,4,5,6,7,8,9]%'OR @t_phone LIKE '03[2,3,4,5,6,7,8,9]%' or @t_Phone like '09[6,7,8]%'
       print 'Viettel'
ELSE IF @t_Phone like '012[0,1,2,6,8]%' or  @t_Phone like '07[0,6,7,8,9]'
       print 'Mobiphone'
else if @t_Phone like '012[3,4,5,7,9]%' or @t_phone like '09[1,4]%' or @t_phone like '08[1,5,8]%'
       print 'Vinaphone'
else
       print N'lê Nguên Anh sử dụng hãng khác'

--9.	Hãy nhận định Lê Anh Huy ở vùng nông thôn hay thành thị.
-- Gợi ý: nông thôn thì địa chỉ thường có chứa chữ “thôn” hoặc “xóm” hoặc “đội” hoặc “xã” hoặc “huyện”
declare @vung varchar(50)
set @vung =(select Cust_ad from customer where Cust_name =N'Lê Anh Huy')
IF @vung LIKE N'%thon%' OR @vung LIKE N'%xóm%'OR @vung LIKE N'%xã%'or @vung LIKE N'%huyện%'
   print N'Nông thôn'
else
 print N'Thành thị'
--10.	Hãy kiểm tra tài khoản của Trần Văn Thiện Thanh, 
--nếu tiền trong tài khoản của anh ta nhỏ hơn không hoặc bằng không nhưng 6 tháng gần đây không 
--có giao dịch thì hãy đóng tài khoản bằng cách cập nhật ac_type = ‘K’
declare @acountt int, @ngay date
set @ngay = (select top 1 t_date from transactions join account on transactions.ac_no = account.Ac_no
                                             join customer on account.cust_id = customer.Cust_id  
											 where Cust_name = N'Trần Văn Thiện Thanh' 
											 order by t_date desc)
set @acountt = (select ac_balance from account 
                                             join customer on account.cust_id = customer.Cust_id 
											 where Cust_name = N'Trần Văn Thiện Thanh')
if (@acountt < 0 or @acountt = 0) and DATEDIFF(MONTH,@ngay,GETDATE()) < 6
begin
update account set ac_type = N'K'
from account join customer on customer.Cust_id = account.cust_id 
where Cust_name = N'Trần Văn Thiện Thanh'
end
else 
print N'Tài khoản bình thường'

--11.	Mã số giao dịch gần đây nhất của Huỳnh Tấn Dũng là số chẵn hay số lẻ? 
 declare @t_id int 
set @t_id = (select top 1 t_id from transactions join account on transactions.ac_no = account.Ac_no 
                                         join customer on .account.cust_id = customer.Cust_id 
									     where Cust_name = N'Huỳnh Tấn Dũng' 
										 order by t_date desc, t_time desc)
if (@t_id%2) = 0
print N'Mã số giao dịch là số chẵn'
else
print N'Mã số giao dịch là số lẻ'

--12.	Có bao nhiêu giao dịch diễn ra trong tháng 9/2016 với tổng tiền mỗi loại là bao nhiêu 
--(bao nhiêu tiền rút, bao nhiêu tiền gửi)
declare @soGD int, @tongTienRut INT , @tongTienGui INT
select @soGD = (select count(t_id) from transactions
				where month(t_date) = 9 and year(t_date) = 2016)
select @tongTienRut = (select sum(t_amount) from transactions
				where month(t_date) = 9 and year(t_date) = 2016 and t_type = 0)
select @tongTienGui = (select sum(t_amount) from transactions
				where month(t_date) = 9 and year(t_date) = 2016 and t_type = 1)
		print N'Có ' +cast(@sogd as nvarchar(15))+ N' giao dịch diễn ra trong tháng 9/2016'
		print N'Tổng tiền rút là ' +cast(@tongTienRut as nvarchar(15))
		print N'Tổng tiền gửi là ' +cast(@tongTienGui as nvarchar(15))

--13.	Ở Hà Nội ngân hàng Vietcombank có bao nhiêu chi nhánh và có bao nhiêu khách hàng? 
--Trả lời theo mẫu: “Ở Hà Nội, Vietcombank có … chi nhánh và có …khách hàng”
declare @chinhanh1 int, @khachhang int 
set @chinhanh1 = (select count(Branch.BR_id) from Branch where BR_name = N'Vietcombank Hà Nội')
set @khachhang = (select count(customer.Cust_id) from customer join Branch on customer.Br_id = Branch.BR_id
                                                where customer.Br_id = (select Branch.BR_id
												                        from Branch 
																		where BR_name = N'Vietcombank Hà Nội'))
print N'Ở Hà Nội, Vietcombank có ' + cast(@chinhanh1 as nvarchar) + N' chi nhánh và có ' + cast(@khachhang as nvarchar) + N' khách hàng'

--14.	Tài khoản có nhiều tiền nhất là của ai, số tiền hiện có trong tài khoản đó là bao nhiêu? 
--Tài khoản này thuộc chi nhánh nào?
declare @tien int
declare @danhsach table (Tenkhach nvarchar(50),	Chinhanh nvarchar(50), Sotien int )
select @tien = (select max(ac_balance) from account)
insert @danhsach select cust_name, BR_name, ac_balance from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id join Branch on customer.Br_id = Branch.Br_id
				where ac_balance = @tien
			group by Cust_name, BR_name, ac_balance
select @tien = (select max(ac_balance) from account)
select * from @danhsach

--15.	Có bao nhiêu khách hàng ở Đà Nẵng?
declare @KH int 
set @KH = (select count(customer.Cust_id) from customer where Cust_ad like N'%Đà Nẵng%')
print N'Có ' + cast(@KH as nvarchar) + N' khách hàng ở Đà Nẵng'

--16.	Có bao nhiêu khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn
declare @khachhang int
set @khachhang = (select count(customer.Cust_id) 
                   from customer join Branch on customer.Br_id = Branch.BR_id 
                   where BR_name like N'%Sài Gòn%' and Cust_ad like N'%Quảng Nam%')
print N'Có ' + cast(@khachhang as nvarchar) + N' khách hàng ở Quảng Nam nhưng mở tài khoản Sài Gòn'

--17.	Ai là người thực hiện giao dịch có mã số 0000000387, thuộc chi nhánh nào? Giao dịch này thuộc loại nào?
declare @nguoiGD nvarchar(50), @chinhanhnao nvarchar(50), @loaigd nvarchar(50)
set @nguoiGD= (select cust_name from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id
				where t_id = '0000000387')
set @chinhanhnao = (select BR_name from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id join Branch on customer.Br_id = Branch.Br_id
				where t_id= '0000000387')
set @loaigd = (select t_type from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id
				where t_id = '0000000387')
print N'người thực hiện giao dịch có mã số 0000000387 là ' +@nguoiGD+ N' thuộc chi nhánh ' +@chinhanhnao
print N'Giao dịch thuộc loại ' +@loaigd

--18.	Hiển thị danh sách khách hàng gồm: họ và tên, số điện thoại,
-- số lượng tài khoản đang có và nhận xét. Nếu < 1 tài khoản  “Bất thường”, còn lại “Bình thường”
declare @ds table(Hovaten nvarchar(50), Sodienthoai varchar(15), Soluongtaikhoandangco int, NhanxetTK nvarchar(50))
insert into @ds select cust_name, cust_phone, count(ac_no),	case when count(ac_no) <= 1 then N'Bất thường' else  N'Bình thường' end 
		        from customer join account on customer.Cust_id = account.Cust_id
		        group by cust_name, Cust_phone
select * from @ds

--19.	Viết đoạn code nhận xét tiền trong tài khoản của ông Hà Công Lực. <100.000: ít, < 5.000.000  trung bình, còn lại: nhiều

declare @tientk int 
set @tientk = (select sum(ac_balance) from account join customer on account.Cust_id = customer.Cust_id 
                                      where Cust_name = N'Hà Công Lực')
print @tientk
if(@tientk < 100000)
print N'ít'
else if(@tientk < 5000000)
print N'trung bình'
else
print N'nhiều'

--20.	Hiển thị danh sách các giao dịch của chi nhánh Huế với các thông tin: 
--mã giao dịch, thời gian giao dịch, số tiền giao dịch, loại giao dịch (rút/gửi), số tài khoản. 
declare @bang table (Magiaodich char(10), ThoigianGD time, SotienGD numeric(15,0), LoaiGD char(1), SoTK char(10))
insert into @bang 
		select t_id, t_time, t_amount, t_type, ac_no from transactions
select * from @bang

--21.	Kiểm tra xem khách hàng Nguyễn Đức Duy có ở Quang Nam hay không?
declare @ktra nvarchar(50)
set @ktra = (select cust_ad from customer
				where Cust_name = N'Nguyễn Đức Duy')
if @ktra like N'%Quảng Nam%'
	print N'Khách hàng Nguyễn Đức Duy ở Quảng Nam'
else print N'Khách hàng Nguyễn Đức Duy không ở Quảng Nam'

/* 22.	Điều tra số tiền trong tài khoản ông Lê Quang Phong có hợp lệ hay không?
(Hợp lệ: tổng tiền gửi – tổng tiền rút = số tiền hiện có trong tài khoản). 
Nếu hợp lệ, đưa ra thông báo “Hợp lệ”, ngược lại hãy cập nhật lại tài khoản sao cho số tiền trong tài khoản khớp với 
Tổng số tiền đã giao dịch (ac_balance = sum(tổng tiền gửi) – sum(tổng tiền rút) */

declare @sotk int, @sotiengui int, @sotienrut int
set @sotk = (select ac_balance from account join customer on account.Cust_id = customer.Cust_id
			where Cust_name = N'Lê Quang Phong') 
set @sotiengui = (select sum(t_amount) from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id
				where Cust_name = N'Lê Quang Phong' and t_type = 1)
set @sotienrut = (select sum(t_amount) from transactions join account on transactions.ac_no=account.Ac_no
				join customer on account.Cust_id = customer.Cust_id
				where Cust_name = N'Lê Quang Phong' and t_type = 0)
	if @sotk is null
	set @sotk = 0
	if @sotiengui is null
	set @sotiengui = 0
	if @sotienrut is null
	set @sotienrut = 0
if (@sotiengui - @sotienrut = @sotk) 
	print N'Hợp lệ'
else 
begin 
	print N'Không hợp lệ'
	update account
	set ac_balance = @sotiengui - @sotienrut
	from account join customer on account.Cust_id = customer.Cust_id
				where Cust_name = N'Lê Quang Phong'
	print N'Đã update'
end
/* 23. Chi nhánh Đà Nẵng có giao dịch gửi tiền nào diễn ra vào ngày chủ nhật hay không? 
Nếu có, hãy hiển thị số lần giao dịch, nếu không, hãy đưa ra thông báo “không có” */
declare @gd2 int
set @gd2 = (select count(t_id) from Branch join customer on Branch.BR_id = customer.Br_id 
                                 join account on customer.Cust_id = account.cust_id
								 join transactions on account.Ac_no = transactions.ac_no
								 where BR_name = N'Vietcombank Đà Nẵng' and t_type = 1 and DATEPART(dw,t_date) = 1)
if( @gd2 <> 0)
print N'Có ' + cast(@gd2 as nvarchar) + N' lần giao dịch'
else
print N'Không có lần giao dịch'

/* 24. Kiểm tra xem khu vực miền bắc có nhiều phòng giao dịch hơn khu vực miền trung ko? 
Miền bắc có mã bắt đầu bằng VB, miền trung có mã bắt đầu bằng VT */
declare @mb int, @mt int
set @mb = (select count(BR_id) from  Branch where Branch.BR_id like '%VB%')
print N'Số lượng phòng giao dịch ở miền bắc: ' + cast(@mb as nvarchar)
set @mt = (select count(BR_id) from  Branch where Branch.BR_id like '%VT%')
print N'Số lượng phòng giao dịch ở miền trung: ' + cast(@mt as nvarchar)
if(@mb > @mt)
print N'Khu vực miền bắc có nhiều phòng giao dịch hơn khu vực miền trung'
else
print N'Khu vực miền trung có nhiều phòng giao dịch hơn khu vực miền bắc'

-- VÒNG LẶP
--1. In ra dãy số lẻ từ 1 – n, với n là giá trị tự chọn
declare @a int = 1, @b int = 100
while(@a <= @b )
begin
if(@a%2) <> 0
begin
print @a;
end
set @a = @a + 1;
end

--2. In ra dãy số chẵn từ 0 – n, với n là giá trị tự chọn
declare @c1 int = 0, @d1 int = 100
while(@c1 <= @d1 )
begin
if(@c1%2) = 0
begin
print @c1;
end
set @c1 = @c1 + 1;
end

--3. In ra 100 số đầu tiền trong dãy số Fibonaci
declare @e int = 0, @f int = 1, @g int = 1, @kq int
print @f
while( @g < 100)
begin
set @kq = @e + @f
print @kq
set @e = @f
set @f = @kq
set @g = @g + 1;
end

--4. In ra tam giác sao: 1 tam giác vuông, 1 tam tam giác cân 
-- tam giác vuông
declare @x int = 1
while @x <= 5 
begin
print replicate('*', @x) 
set @x = @x + 1 
end

-- tam giác cân
declare @x int, @y int
select @x=0,@y=5
while @y>0
begin
print space(@y)+replicate('*', @x)+replicate('*', @x + 1)
set @x=@x+1
set @y=@y-1
end

--5. In bảng cửu chương
declare @j int = 1, @ketqua int
while @j < 10
begin
print N'In bảng cửu chương ' + convert(varchar, @j)
declare @v int = 1
while @v <= 10
begin
set @ketqua = @j * @v
print (Convert (nvarchar(5), @j) + ' x ' + (Convert (nvarchar(5), @v) + ' = ' + (Convert (nvarchar(5), @ketqua))))
set @v = @v + 1
end
set @j = @j + 1
end

--7. Kiểm tra số điện thoại của Lê Quang Phong là số tiến hay số lùi hay lộn xộn.
declare @sdt varchar(11), @st1 int , @ss1 int, @kt11 int = 0, @kt22 int = 0
set @sdt = (select Cust_phone from customer where Cust_name = N'Lê Quang Phong') 
print N'Số điện thoại khi chưa cắt: ' + cast(@sdt as varchar)
if(len(@sdt) = 10)
set @sdt = substring(@sdt,4,8)
else
set @sdt = substring(@sdt,5,7)
print N'Số điện thoại khi cắt: ' + cast(@sdt as varchar)
set @st1 = @sdt % 10
set @sdt = @sdt/10
while(@sdt <> 0)
begin
set @ss1 = @sdt % 10
if(@st1 < @ss1) 
set @kt11 = 1 
else if (@st1 > @ss1) 
set @kt22 = 1
set @st1 = @ss1
set @sdt = @sdt/10
end 
if ( @kt11 = 0 and @kt22 = 1) 
print N'Số điện thoại của Lê Quang Phong là Số tiến'
else if ( @kt11 = 1 and @kt22 = 0) 
print N'Số điện thoại của Lê Quang Phong là Số lùi'
else 
print N'Số điện thoại của Lê Quang Phong là Lộn xộn'