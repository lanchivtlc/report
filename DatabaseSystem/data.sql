use master 
go 
create database HCSDL_VOTHILANCHI_52200320
go
use HCSDL_VOTHILANCHI_52200320
go 
create table SANPHAM(
    masp varchar(10) primary key,
    tensp nvarchar(50),
    loại nvarchar(50),
    dongia int
)
go 

create table GIACAM(
    masp varchar(10) primary key,
    loài nvarchar(50),
    tuoi nvarchar(50),
    foreign key (masp) references SANPHAM(masp)
)
go 

create table GIASUC(
    masp varchar(10) primary key,
    loài nvarchar(50),
    thoiki nvarchar(50),
    foreign key (masp) references SANPHAM(masp)
)
go 

create table QUANLY(
    manv varchar(10) primary key,
    hoten nvarchar(50),
    quequan nvarchar(50),
    sodt varchar(10)
)
go 
create table THANNHAN(
    manv varchar(10) primary key,
    hoten nvarchar(50),
    moiquanhe nvarchar(20),
    gioitinh nvarchar(5),
    ngaysinh date,
    foreign key (manv) references QUANLY(manv)
)
go 
create table CUAHANG(
    mach varchar(10) primary key,
    manv varchar(10),
    tench nvarchar(50),
    sodt varchar(10),
    foreign key (manv) references QUANLY(manv)
)
go 

create table SOHUU(
    mach varchar(10),
    masp varchar(10),
    primary key(mach,masp),
    foreign key (mach) references CUAHANG(mach),
    foreign key (masp) references SANPHAM(masp)
)
go 

create table PHIEU_NHAPHANG(
    sophieu varchar(10) primary key,
    tensp nvarchar(50),
    soluong int, 
    dongia int,
    ngaynhap date,
    mach varchar(10),
    foreign key (mach) references CUAHANG(mach)
)
go 

create function fuTaoMaSP()
returns varchar(10)
as 
begin 
    declare @masp varchar(10)
    if(not exists(select masp from SANPHAM))
        begin 
            set @masp = 'SP001'
        end 
    else begin
        declare @newnumber int = convert(int,(select max(right(masp,3)) from SANPHAM)) + 1
        set @masp = 
        (
            case 
                when @newnumber < 10 then concat('SP00',convert(varchar,@newnumber))
                when @newnumber >= 10 then concat('SP0',convert(varchar,@newnumber))
            end
        )
        end
    return @masp
end 
go 

create procedure procNhapSanPham
@tensp nvarchar(50), @loại nvarchar(50), @dongia int
as 
begin 
    insert into SANPHAM(masp,tensp,loại,dongia)
    values(dbo.fuTaoMaSP(),@tensp,@loại,@dongia)
end 
go

create function fuTaoMaNV()
returns varchar(10)
as 
begin 
    declare @manv varchar(10)
    if(not exists(select manv from QUANLY))
        begin 
            set @manv = 'NV001'
        end 
    else begin
        declare @newnumber int = convert(int,(select max(right(manv,3)) from QUANLY)) + 1
        set @manv = 
        (
            case 
                when @newnumber < 10 then concat('NV00',convert(varchar,@newnumber))
                when @newnumber >= 10 then concat('NV0',convert(varchar,@newnumber))
            end
        )
        end
    return @manv
end 
go 

create procedure procNhapQuanLy
@hoten nvarchar(50),@quequan nvarchar(50),@sodt varchar(10)
as 
begin 
    insert into QUANLY(manv,hoten,quequan,sodt)
    values(dbo.fuTaoMaNV(),@hoten,@quequan,@sodt)
end 
go 

create trigger checkMaCuaHang
on PHIEU_NHAPHANG 
after insert
as
begin 
    if exists (select * from PHIEU_NHAPHANG
                where mach not in (select mach from CUAHANG))
    begin 
        print('Không tồn tại mã cửa hàng')
    end 
end 
go

create trigger checkSoLuongNhapHang
on PHIEU_NHAPHANG
after update 
as 
begin 
    if(
        select soluong from PHIEU_NHAPHANG
        where soluong < 0
    )is not null 
    begin 
        print('Cập nhật lại số lượng')
    end 

    if(
        select dongia from PHIEU_NHAPHANG
        where dongia < 0
    )is not null 
    begin 
        print('Cập nhật lại đơn giá')
    end 
end 
go 

exec procNhapSanPham N'Thức ăn thủy sản',N'P0 (bột)',350000
exec procNhapSanPham N'Thức ăn thủy sản',N'P1 (hạt 1 ly)',300000
exec procNhapSanPham N'Thức ăn thủy sản',N'P2 (hạt 2 ly)',400000
exec procNhapSanPham N'Thức ăn thủy sản',N'Dành cho cá kiểng', 450000
exec procNhapSanPham N'Thức ăn thủy sản',N'Cá Ba Sa', 355000

exec procNhapQuanLy N'Nguyễn Văn A',N'TP.HCM','0123456789'
exec procNhapQuanLy N'Trần Thị Diệu Lâm',N'Đồng Nai','0234567819'
exec procNhapQuanLy N'Võ Minh Luân',N'Cà Mau','0341256987'
exec procNhapQuanLy N'Hồ Hồng Ngọc',N'Bạc Liêu','0987654321'
exec procNhapQuanLy N'Bùi Xuân Diệu',N'Gia Lai','0894567312'

select * from SANPHAM
select * from QUANLY
