/*Câu 1. (1.5đ) Viết hàm tạo mã độc giả mới như mô tả dưới đây:
Nếu trong bảng chưa có dữ liệu thì hàm trả về giá trị bằng 1.
Trường hợp ngược lại, giá trị trả về là: 
giá trị lớn nhất của mã độc giả đang có trong cơ sở dữ liệu cộng thêm 1
*/
/*
input: MaSach
output: Thêm Mã độc giả
Process: 1(tồn tại), 0(chưa tồn tại) 
*/
CREATE FUNCTION fTaoMaDGM()
RETURNS VARCHAR(15)
AS
BEGIN
  DECLARE @count INT, @MaDGC VARCHAR(15), @MaDGM VARCHAR(15)
  SELECT @count = COUNT(MaThe) FROM DOC_GIA
    IF @count < 1
		  BEGIN
			SET @MaDGM = 1
		  END
  ELSE
		  BEGIN
			SELECT @MaDGC = MAX(MaThe) FROM DOC_GIA
			SET @MaDGM = @MaDGC + 1
		  END
	RETURN @MaDGM
END 

--test 
select*from DOC_GIA
select Dbo.fTaoMaDGM ()
/*
Câu 2. (1.5đ) Viết hàm tính số lượng sách độc giả còn đang mượn thư viện nếu biết mã độc giả.
input   : mã thẻ của độc giả
output	: số lượng sách
process : đếm tổng lượng sách    MaThe = @MaThe và Ngày trả null
*/
CREATE FUNCTION CountB (@MaThe int)
RETURNS int
AS
BEGIN
  DECLARE @countB INT;
  SELECT @countB = COUNT(SoLuong) FROM MUON where MaThe = @MaThe and NgayTra is null and NgayHenTra >= getdate()
  return @countB
END 

--test
print dbo.CountB()
go
...

/*
Câu 3. (5đ) Hãy tạo thủ tục thêm mới dữ liệu vào bảng MUON 
với các giá trị đầu vào là: Mã sách, mã thẻ, Mô tả, Số lượng
*/

Create procedure spThemMoiDLMUON (@MaSach Varchar(15), @MaThe varchar(15), @MoTa Nvarchar(200), @SoLuong int , @ret BIT OUT)
As
Begin
	    declare @Count int, @NgayMuon date, @NgayTra date
/* a)	Kiểm tra MaSach có tồn tại trong bảng SACH không? 
Nếu không tồn tại thì đưa ra thông báo “Không tồn tại thẻ đọc này!”, trả về giá trị 0 và kết thúc thủ tục.*/

  Set @count = (Select COUNT(MaSach) from SACH where MaSach = @MaSach )
	 if @count <=  0
	     begin
			print N'Mã sách không có thực!'
			set @ret = 0
			return
	      end
		  --test

/*b)	Kiểm tra MaThe có tồn tại trong bảng DOC_GIA không?
Nếu không tồn tại thì đưa ra thông báo “Không tồn tại thẻ đọc này!”, trả về giá trị 0 và kết thúc thủ tục. 
*/

	Set @count = 0;
	Set @count = (select COUNT(MaThe) from DOC_GIA where MaThe = @MaThe)
	if @count <= 0
		Begin
		    Print N'Không tồn tại mã này!'
			Set @ret = 0
			Return
		end
			

/*c)	Kiểm tra độc giả có được phép mượn sách hay không? Nếu không được phép mượn thì trả về giá trị 0 và kết thúc thủ tục. 
Quy định mượn sách như sau: 
•	Nếu độc giả đang mượn nhiều hơn 3 cuốn và chưa trả thư viện thì không được mượn thêm sách. */


/*d)	Tính giá trị cho ngày mượn và ngày hẹn trả: 
•	Ngày mượn là ngày hiện tại
•	Ngày hẹn trả là 10 ngày sau ngày mượn
*/
    SET @NgayMuon =  (select Getdate())
	SET @NgayTra = Dateadd(day, 10, @NgayMuon)

/* e)	Thêm mới dữ liệu cho bảng MUON với các giá trị đã có: 
Mã sách, mã thẻ, ngày mượn, ngày hẹn trả, số lượng. Trả về giá trị 1 nếu thêm mới thành công, 0 nếu thêm mới thất bại.*/
INSERT INTO MUON VALUES(@MaSach, @MaThe, N'N/A', @SoLuong, @NgayTra, null, null)
IF @SoLuong < 1
	Begin
		Print N'Số lượng không đúng!'
		Set @ret = 0
		Return
	End
	--test 

--Câu 4. (1đ) Khi thêm mới dữ liệu cho bảng MUON, hãy đảm bảo rằng ngày mượn luôn luôn là ngày hiện tại.
/*
bảng   :  Muon
loại   :  after
Sự kiện:	insert
			
*/
Create trigger C4
on MUON
for insert 
as
Begin
 declare @NgayMuon date 
 if @NgayMuon = (select NgayMuon  from inserted) 
 if @NgayMuon <> getdate()
   begin
     print N'K là ngày hiện tại'
    Rollback
   end
end
-- test
INSERT INTO MUON VALUES(2, 3,N'N/A',1,'2019-11-13','2019-11-20','2019-12-21',3000)
select * from  MUON


--Câu 5. (1đ) Sau khi cập nhật số lượng sách của một sách nào đó, hãy cập nhật số lượng của loại tương ứng. 
--bảng: SACH
--loại   :  for
--Sự kiện:	update
			
Create trigger c5
On MUON
After Insert
As
Begin
	Update SACH
	Set SoLuongTon = SoLuongTon - inserted.SoLuong
	From SACH join inserted on SACH.MaSach = inserted.MaSach
	Where SACH.MaSach = inserted.MaSach
End
--test