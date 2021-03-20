/*
This script contains the SQL statements to answer business questions
*/

--- BUSINESS QUESTIONS
-- Which product is the top seller by dollar value?
SELECT 
	tlg_Product.ProductName,
	sum(tlg_Invoice.AmountOwed) as TotalDollarsSold
FROM tlg_OrderDetail
JOIN tlg_Product ON tlg_OrderDetail.ProductID = tlg_Product.ProductID
JOIN tlg_Invoice ON tlg_OrderDetail.OrderID = tlg_Invoice.OrderID
GROUP BY
	tlg_Product.ProductName
ORDER BY TotalDollarsSold DESC

-- Which product is the top seller by quantity sold?
SELECT
	tlg_Product.ProductName,
	sum(tlg_OrderDetail.Quantity) as QuantitySold
FROM tlg_OrderDetail
JOIN tlg_Product ON tlg_OrderDetail.ProductID = tlg_Product.ProductID
GROUP BY
	tlg_Product.ProductName
ORDER BY QuantitySold DESC

-- How many customers have purchased more than once?
SELECT
	A.NumberOfOrders,
	count(A.CustomerID) as NumberOfCustomers
FROM
	(SELECT
		tlg_Order.CustomerID,
		count(tlg_Order.OrderID) as NumberOfOrders
	FROM tlg_Order
	GROUP BY
		tlg_Order.CustomerID) as A
GROUP BY
	A.NumberOfOrders
ORDER BY A.NumberOfOrders

-- How many new customers are gained in a month?
SELECT * FROM dbo.tlg_NewCustomersPerMonth
ORDER BY YearJoined, MonthJoined

-- Which city has the greatest number of customers?
SELECT * FROM dbo.tlg_CustomersByCity
ORDER BY NumberOfCustomers DESC

-- What is the distribution of the amount spent by customers in the highest grossing month?
SELECT * FROM dbo.tlg_DistributionOfSalesInTopSellingMonth
ORDER BY AmountSpent

-- Which employee completes the most orders?
SELECT * FROM dbo.tlg_OrdersClosedByEmployee
ORDER BY NumberOfOrdersClosed DESC

-- DONE! :)
