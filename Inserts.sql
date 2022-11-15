

DECLARE @cnt int = 1
-- Product
while @cnt < 20
BEGIN
    INSERT Into Product
    VALUES('Pilsner' + convert(varchar(30), @cnt),30, 40, 'Smager dejligt')
    set @cnt = @cnt + 1

END

-- Customer
DECLARE @cnt int = 1

while @cnt < 20
BEGIN
    INSERT Into Customer
    VALUES(2189132, 'Prutskid', @cnt)
    set @cnt = @cnt + 1

END

-- Employee
DECLARE @cnt int = 1

while @cnt < 20
BEGIN
    INSERT Into Employee
    VALUES('1231213' + convert(varchar(30), @cnt), 'Prutskid', convert(varchar(30), @cnt))
    set @cnt = @cnt + 1

END



--Orderline
Set @cnt = 1

while @cnt < 20
BEGIN
    INSERT Into OrderLine
    VALUES(@cnt, @cnt)
    set @cnt = @cnt + 1

END

SELECT * FROM Product

Insert into Sale VALUES(GETDATE(),1,1)
Insert into Sale VALUES(GETDATE(),2,2)
Insert into Sale VALUES(GETDATE(),3,3)
Insert into Sale VALUES(GETDATE(),4,4)

DECLARE @cnt int = 1

while @cnt < 4
BEGIN
    INSERT Into OrderLine
    VALUES(@cnt, @cnt, @cnt, @cnt)
    set @cnt = @cnt + 1

END

SELECT * FROM ProductCategory
Insert into ProductCategory VALUES('Prut', 'prut')
Insert into ProductCategory VALUES('skid', 'skid')

Insert into ProductCategoryProduct VALUES('prut', 5)
Insert into ProductCategoryProduct VALUES('skid', 7)


Insert into Situation VALUES('Fredagsbar')
Insert into Situation VALUES('Butik')

insert into Price VALUES(
    1,1,1,'Fredagsbar'
)
Insert into Price VALUES(2,2,2,'Butik')