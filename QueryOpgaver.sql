-- Opgave 2
-- a
SELECT Product.productNr, productName, priceValue, S.situationName from Product
Inner join Price as P
on P.productNr = Product.productNr
inner join Situation as S
on S.situationName = P.situationName
where Product.productNr = 2


-- b
--SELECT Pro.productName, Pri.priceValue as 'Pris Pr. Stk.', O.amount, SUM(Pri.priceValue * O.amount) as total from Sale
--Inner join OrderLine as O
--on Sale.saleNumber = O.saleNumber
--Inner join Product as Pro
--on Pro.productNr = O.productNr
--inner join Price as Pri
--on Pri.productNr = Pro.productNr
--where Sale.saleNumber = 2
--GROUP by productName, priceValue, amount
--order by total DESC


-------------------------------------------------------------------------------------
SELECT Sale.saleNumber, SUM(Pri.priceValue * O.amount) as total from Sale
Inner join OrderLine as O
on Sale.saleNumber = O.saleNumber
Inner join Product as Pro
on Pro.productNr = O.productNr
inner join Price as Pri
on Pri.productNr = Pro.productNr
where Sale.saleNumber = 2
GROUP BY Sale.saleNumber
order by total DESC



-- c
SELECT ProductCategory.title, Product.productName, OrderLine.amount from ProductCategory
inner join ProductCategoryProduct
on ProductCategory.title = ProductCategoryProduct.title
inner join Product
on ProductCategoryProduct.productNr = Product.productNr
inner join OrderLine
on OrderLine.productNr = Product.productNr
inner join Sale
on sale.saleNumber = OrderLine.saleNumber
--WHERE OrderLine.amount > 5
group by ProductCategory.title, productName