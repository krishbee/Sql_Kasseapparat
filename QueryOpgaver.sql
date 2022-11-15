-- Opgave 2
-- a
SELECT Product.productNr, productName, priceValue, Situation.situationName from Product
Inner join Price
on Price.productNr = Product.productNr
inner join Situation
on Situation.situationName = Price.situationName

-- b
SELECT Product.productName, Price.priceValue as 'Pris Pr. Stk.', Orderline.amount, SUM(Price.priceValue * Orderline.amount) as total from Sale
Inner join OrderLine
on Sale.saleNumber = OrderLine.saleNumber
Inner join Product
on Product.productNr = OrderLine.productNr
inner join Price
on Product.productNr = Price.productNr
GROUP by productName, priceValue, amount
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