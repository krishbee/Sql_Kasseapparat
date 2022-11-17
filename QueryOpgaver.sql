-- Opgave 2
-- a
SELECT Product.productNr, productName, priceValue, S.situationName from Product
Inner join Price as P
on P.productNr = Product.productNr
inner join Situation as S
on S.situationName = P.situationName
where Product.productNr = 2


-------------------------------------------------------------------------------------

SELECT Sale.saleNumber, SUM(ISNULL(O.fixedPrice, Pri.priceValue * O.amount * (1.0 - Pri.percentDiscount /100.0))) as total from Sale
Inner join OrderLine as O
on Sale.saleNumber = O.saleNumber
Inner join Product as Pro
on Pro.productNr = O.productNr
inner join Price as Pri 
on Pri.productNr = Pro.productNr
inner join Situation
on Situation.situationName = Pri.situationName
where Sale.saleNumber = 11 and Situation.situationName = 'Standard'
GROUP BY Sale.saleNumber
order by total DESC 

SELECT * FROM Price


-- c
select PCP.title, PRO.productName, SUM(OL.amount) as 'Number Sold', S.endDate
from Product PRO
inner join ProductCategoryProduct PCP
on PRO.productNr = PCP.productNr
inner join OrderLine OL
on OL.productNr = PRO.productNr
inner join Sale S
on OL.saleNumber = S.saleNumber
group by PCP.title, PRO.productName, S.endDate
having SUM(OL.amount) >= 5 AND MONTH(S.endDate) = 11


--D

SELECT ProductCategory.title, Pro.productName from ProductCategory
inner join ProductCategoryProduct as ProCat
on ProCat.title = ProductCategory.title
inner join Product as Pro
on Pro.productNr = ProCat.productNr
inner join Price as Pri
on Pri.productNr = pro.productNr
inner join Situation as Sit
on sit.situationName = Pri.situationName
EXCEPT
SELECT ProductCategory.title, Pro.productName from ProductCategory
inner join ProductCategoryProduct as ProCat
on ProCat.title = ProductCategory.title
inner join Product as Pro
on Pro.productNr = ProCat.productNr
inner join Price as Pri
on Pri.productNr = pro.productNr
inner join Situation as Sit
on sit.situationName = Pri.situationName
WHERE sit.situationName = 'Fredagsbar'


-- e
SELECT Sale.saleNumber, SUM(Pri.priceValue * O.amount) as total from Sale
Inner join OrderLine as O
on Sale.saleNumber = O.saleNumber
Inner join Product as Pro
on Pro.productNr = O.productNr
inner join Price as Pri
on Pri.productNr = Pro.productNr
where Sale.saleNumber > 0
GROUP BY Sale.saleNumber
order by saleNumber ASC

-- Gennesnit for alle salg
SELECT AVG(asset_sums)
FROM
(
SELECT Sale.saleNumber, SUM(Pri.priceValue * O.amount) AS asset_sums FROM Sale
Inner join OrderLine as O
on Sale.saleNumber = O.saleNumber
Inner join Product as Pro
on Pro.productNr = O.productNr
inner join Price as Pri
on Pri.productNr = Pro.productNr
where Sale.saleNumber > 0
    GROUP BY Sale.saleNumber
) AS inner_query

-- f
select PCP.title, MAX(PRI.priceValue) as 'Max Price'
from ProductCategoryProduct PCP
inner join Product PR
on PCP.productNr = PR.productNr
inner join Price PRI
on PR.productNr = PRI.productNr
group by PCP.title


-- g
select pc.title, p.productName,pr.priceValue from ProductCategoryProduct pcp
inner join ProductCategory pc
on pcp.title = pc.title
inner join Price pr
on pr.productNr = pcp.productNr
inner join Product p
on p.productNr = pr.productNr
inner join
(select pcp.title, MAX(pr.priceValue) as MaxPris from ProductCategoryProduct pcp
inner join Price pr
on pr.productNr = pcp.productNr
GROUP BY PCp.title) MaxInCategory
on maxInCategory.title = pc.title
where MaxInCategory.MaxPris = pr.priceValue


-- Opgave 3.
-- 3A
GO
CREATE VIEW antalAfProduktersolgt
AS
SELECT ProductCategory.title, Product.productName, COUNT(OrderLine.saleNumber) as antal from ProductCategory
inner join ProductCategoryProduct as ProCatPro
on ProCatPro.title = productCategory.title
inner join Product
on Product.productNr = ProCatPro.productNr
LEFT JOIN OrderLine
on OrderLine.productNr = Product.productNr
GROUP BY ProductCategory.title, Product.productName

go
SELECT * From antalAfProduktersolgt

-- 3b
GO
CREATE VIEW SaleOverview 
AS
select S.saleNumber, C.personName as Customer, E.personName as Salesman, (SELECT SUM(ISNULL(O.fixedPrice, Pri.priceValue * (1-PRI.percentDiscount/100) * O.amount)) as total 
													from Sale
													Inner join OrderLine as O
													on Sale.saleNumber = O.saleNumber
													Inner join Product as Pro
													on Pro.productNr = O.productNr
													inner join Price as Pri
													on Pri.productNr = Pro.productNr
													where Sale.saleNumber = S.saleNumber
													GROUP BY Sale.saleNumber
													) as SaleTotal
from Sale S
inner join Customer C
on C.customerId = S.customerId
inner join Employee E
on E.employeeId = S.employeeId

select Salesman, SUM(SaleTotal) as 'Total sold'
from SaleOverview
group by Salesman


-- Opgave 4.
go
Create PROC WritePriceList
@situationName VARCHAR(40)
AS
SELECT Product.productName, sum(priceValue * (1 + (percentDiscount/ 100))) from Product
inner join Price as P
on P.productNr = Product.productNr
inner join Situation
on Situation.situationName = P.situationName
WHERE Situation.situationName = 'Fredagsbar'
Group by Product.productName

-- b
go
CREATE PROCEDURE setDiscountOnProductCategory @percent Integer, @category varchar(40)
as
Update Price
set percentDiscount = @percent
where Price.productNr in (select PCP.productNr
						from ProductCategoryProduct PCP)



-- 4C
/* Opgave 4c
Givet en streng som parameter udskriver navn på alle de medarbejdere og kunder, hvis
navne starter med den pågældende streng.
*/
go
Create proc FindPersonMedNavn
--input parameter
@personName varchar(30)
as
Begin
Select e.personName, e.phoneNumber
from Employee e
where 
e.personName = @personName
Union all
select c.personName, c.phoneNumber
from Customer c
where 
c.personName = @personName
End

-- KØR proc 4c
exec FindPersonMedNavn 'Peter'

-- DROP proc 4c
drop proc FindPersonMedNavn
-- OPGAVEN ER IKKE LØST KORREKT. JEG KAN FINDE ALLE DER KUN HEDDER 'PETER', IKKE ALLE HVIS NAVN STARTER MED 'PETER'.

-- Opgave 5
-- A
go
Create trigger sletTomProduktKategori
       on product
       instead of delete
       as
       declare @produktetsProduktgruppe as varchar(40)
       declare @produktNr as integer
       set @produktNr = (select productNr from deleted)
       set @produktetsProduktgruppe = (select title from ProductCategoryProduct where productNr = @produktNr)
       delete from ProductCategoryProduct
       where productNr = @produktNr
IF not exists (select title from ProductCategoryProduct where title = @produktetsProduktgruppe)
       begin
       delete from ProductCategory
       where title = @produktetsProduktgruppe
delete from Product
       where productNr = @produktNr
print 'produktet og produktgruppen blev slettet'
       end
       else
       begin
       print 'der skete ingenting'
       end




-- B
GO
CREATE TRIGGER OpdatereAntal on orderline
after INSERT
AS
DECLARE @productNr as INT
set @productNr = (Select productNr from inserted)
DECLARE @amount as INT
set @amount = (select amount from inserted)
BEGIN
UPDATE Product
set currentAmount = currentAmount - @amount
WHERE productNr = @productNr
END

drop TRIGGER OpdatereAntal
