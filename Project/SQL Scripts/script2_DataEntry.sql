/*
This script should insert data into the appropriate tables
The entries are either done using `INSERT` statements or through the stored procedures using `EXEC`
*/

-- INSERTING
-- inserting data into tables
-- Inserting data into the Employee table
INSERT INTO tlg_Customer(FirstName, LastName, AddressStreetandNumber, AddressCity, EmailAddress, DateJoined)
VALUES
	('Firstname', 'Lastname', '123 Street name', 'City name', 'emailaddress@email.com', '1/2/2017 13:35')
go

EXEC tlg_AddNewCustomer 'Firstname 'Lastname', '987 Ave name', 'City', 'email@email.com'
go

-- Inserting data into the Employee table
INSERT INTO tlg_Employee (FirstName, LastName, EmailAddress)
VALUES
	('First name', 'Last name', 'emailaddress@email.com')
go

EXEC tlg_AddNewEmployee 'Fistname', 'Lastname', 'email@email.com'
go

-- Inserting data into the ProdyctType table
INSERT INTO tlg_ProductType(Category, CategoryDescription)
VALUES
	('A product category', 'some product category description'),
  ('Another product category', 'possible the same product category description')
 go

-- Inserting data into the Product table
INSERT INTO tlg_Product(ProductName, ProductTypeID, Price, ProductDescription)
VALUES
	('Product name', (SELECT ProductTypeID FROM dbo.tlg_ProductType WHERE Category = 'A product category'), 12.34, 'some product description')
go

EXEC tlg_AddNewProduct 'Another product name', 'Another product category', 56.78, 'possibly the same product description (or not...)'
go

-- Inserting data into the OrderStatus table
INSERT INTO tlg_OrderStatus(OrderStatus)
VALUES
	('Open'),
	('Close')
go

-- Inserting data into the Order table
INSERT INTO tlg_Order(OrderDate, OrderStatusID, CustomerID, EmployeeID)
VALUES
	('1/2/2020 8:05', (SELECT OrderStatusID FROM dbo.tlg_OrderStatus WHERE OrderStatus = 'Open'), (SELECT CustomerID FROM dbo.tlg_Customer WHERE FirstName = 'Fname' and LastName = 'Lname'), (SELECT EmployeeID FROM dbo.tlg_Employee WHERE FirstName = 'Fname'))
go

-- Inserting data into the OrderDetail table
INSERT INTO tlg_OrderDetail(OrderID, ProductID, Quantity)
VALUES
	((OrderID sub-select statement), (ProductID sub-select), 1)
go

-- Inserting data into the InvoiceStatus table
INSERT INTO tlg_InvoiceStatus(InvoiceStatus)
VALUES
	('Paid'),
	('In Progress'),
	('Unpaid')
go

-- Inserting data into the Invoice table
INSERT INTO tlg_Invoice(OrderID, AmountOwed, InvoiceStatusID)
VALUES
	((OrderID sub-select), (AmountOwed calc), (InvoiceStatusID sub-select))
go

-- Inserting data into the PaymentType table
INSERT INTO tlg_PaymentType(PaymentTypetext)
VALUES
	('Cash'),
	('Cheque'),
	('Debit'),
	('Credit')
go

-- Inserting data into the InvoicePayment table
INSERT INTO tlg_InvoicePayment(InvoiceID, AmountPaid, PaymentTypeID)
VALUES
	((InvoiceID sub-select), 30, (PaymentTyeID sub-select))
go

-- All entries were made
