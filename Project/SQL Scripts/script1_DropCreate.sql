/*
This script should drop all database objects in reverse order (in terms of the given relationships)
The database objects to be created are tables, stored procedures, and view
*/

-- DROPPING
-- drop all views
DROP VIEW IF EXISTS dbo.tlg_DistributionOfSalesInTopSellingMonth;
go

DROP VIEW IF EXISTS dbo.tlg_TopSellingMonth;
go

DROP VIEW IF EXISTS dbo.tlg_NewCustomersPerMonth;
go

DROP VIEW IF EXISTS dbo.tlg_CustomersByCity;
go

DROP VIEW IF EXISTS dbo.tlg_OrdersClosedByEmployee;
go

-- drop all stored procedures
DROP PROCEDURE IF EXISTS dbo.tlg_AddNewCustomer;
go

DROP PROCEDURE IF EXISTS dbo.tlg_AddNewEmployee;
go

DROP PROCEDURE IF EXISTS dbo.tlg_AddNewProduct;
go


-- drop all tables
DROP TABLE IF EXISTS dbo.tlg_OrderDetail;
go

DROP TABLE IF EXISTS dbo.tlg_InvoicePayment;
go

DROP TABLE IF EXISTS dbo.tlg_Invoice;
go

DROP TABLE IF EXISTS dbo.tlg_Order;
go

DROP TABLE IF EXISTS dbo.tlg_OrderStatus;
go

DROP TABLE IF EXISTS dbo.tlg_InvoiceStatus;
go

DROP TABLE IF EXISTS dbo.tlg_PaymentType;
go

DROP TABLE IF EXISTS dbo.tlg_Customer;
go

DROP TABLE IF EXISTS dbo.tlg_Employee;
go

DROP TABLE IF EXISTS dbo.tlg_Product;
go

DROP TABLE IF EXISTS dbo.tlg_ProductType;
go

-- CREATING
-- create all tables
-- Creating the ProductType table
CREATE TABLE tlg_ProductType(
	-- Columns for the ProductType table
	ProductTypeID int identity,
	Category varchar(10) not null,
	CategoryDescription varchar(100) not null,
	-- Constraints in the ProductType table
	CONSTRAINT PK_tlg_ProductType PRIMARY KEY (ProductTypeID),
	CONSTRAINT U1_tlg_ProductType UNIQUE(Category)
)
go
-- End creating the ProductType table

-- Creating the Product table
CREATE TABLE tlg_Product(
	-- Columns for the Product table
	ProductID int identity,
	ProductName varchar(30) not null,
	ProductTypeID int not null,
	Price decimal not null,
	ProductDescription varchar(100) not null,
	-- Constraints in the ProductType table
	CONSTRAINT PK_tlg_Product PRIMARY KEY (ProductID),
	CONSTRAINT U1_tlg_Product UNIQUE(ProductName),
	CONSTRAINT FK1_tlg_Product FOREIGN KEY (ProductTypeID) REFERENCES tlg_ProductType(ProductTypeID)
)
go
-- End creating the Product table

-- Creating the Employee table
CREATE TABLE tlg_Employee(
	-- Columns for the Employee table
	EmployeeID int identity,
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
	EmailAddress varchar(30) not null,
	-- Constraints in the Employee table
	CONSTRAINT PK_tlg_Employee PRIMARY KEY (EmployeeID),
	CONSTRAINT U1_tlg_Employee UNIQUE(EmailAddress)
)
go
-- End creating the Employee table

-- Creating the Customer table
CREATE TABLE tlg_Customer(
	-- Columns for the Customer table
	CustomerID int identity(83, 1),
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
	AddressStreetandNumber varchar(50) not null,
	AddressCity varchar(50) not null,
	EmailAddress varchar(30) not null,
	DateJoined datetime not null default GetDate(),
	-- Constraints in the Customer table
	CONSTRAINT PK_tlg_Customer PRIMARY KEY (CustomerID),
	CONSTRAINT U1_tlg_Customer UNIQUE(EmailAddress)
)
go
-- End creating the Customer table

-- Creating the PaymentType table
CREATE TABLE tlg_PaymentType(
	-- Columns for the PaymentType table
	PaymentTypeID int identity,
	PaymentTypetext varchar(30) not null,
	-- Constraints in the PaymentType table
	CONSTRAINT PK_tlg_PaymentType PRIMARY KEY (PaymentTypeID)
)
go
-- End creating the PaymentType table

-- Creating the InvoiceStatus table
CREATE TABLE tlg_InvoiceStatus(
	-- Columns for the InvoiceStatus table
	InvoiceStatusID int identity,
	InvoiceStatus varchar(30) not null,
	-- Constraints in the PaymentType table
	CONSTRAINT PK_tlg_InvoiceStatus PRIMARY KEY (InvoiceStatusID)
)
go
-- End creating the InvoiceStatus table

-- Creating the OrderStatus table
CREATE TABLE tlg_OrderStatus(
	-- Columns for the PaymentType table
	OrderStatusID int identity,
	OrderStatus varchar(30) not null,
	-- Constraints in the PaymentType table
	CONSTRAINT PK_tlg_OrderStatus PRIMARY KEY (OrderStatusID)
)
go
-- End creating the OrderStatus table

-- Creating the Order table
CREATE TABLE tlg_Order(
	-- Columns for the Order table
	OrderID int identity,
	OrderDate datetime not null default GetDate(),
	OrderStatusID int not null,
	CustomerID int not null,
	EmployeeID int not null,
	-- Constraints in the Order table
	CONSTRAINT PK_tlg_Order PRIMARY KEY (OrderID),
	CONSTRAINT FK1_tlg_Order FOREIGN KEY (OrderStatusID) REFERENCES tlg_OrderStatus(OrderStatusID),
	CONSTRAINT FK2_tlg_Order FOREIGN KEY (CustomerID) REFERENCES tlg_Customer(CustomerID),
	CONSTRAINT FK3_tlg_Order FOREIGN KEY (EmployeeID) REFERENCES tlg_Employee(EmployeeID)
)
go
-- End creating the Order table

-- Creating the Invoice table
CREATE TABLE tlg_Invoice(
	-- Columns for the Invoice table
	InvoiceID int identity,
	OrderID int not null,
	AmountOwed decimal not null,
	InvoiceStatusID int not null,
	-- Constraints in the Order table
	CONSTRAINT PK_tlg_Invoice PRIMARY KEY (InvoiceID),
	CONSTRAINT FK1_tlg_Invoice FOREIGN KEY (OrderID) REFERENCES tlg_Order(OrderID),
	CONSTRAINT FK2_tlg_Invoice FOREIGN KEY (InvoiceStatusID) REFERENCES tlg_InvoiceStatus(InvoiceStatusID)
)
go
-- End creating the Invoice table

-- Creating the InvoicePayment table
CREATE TABLE tlg_InvoicePayment(
	-- Columns for the InvoicePayment table
	InvoicePaymentID int identity,
	InvoiceID int not null,
	AmountPaid decimal not null,
	PaymentTypeID int not null,
	-- Constraints in the InvoicePayment table
	CONSTRAINT PK_tlg_InvoicePayment PRIMARY KEY (InvoicePaymentID),
	CONSTRAINT FK1_tlg_InvoicePayment FOREIGN KEY (InvoiceID) REFERENCES tlg_Invoice(InvoiceID),
	CONSTRAINT FK2_tlg_InvoicePayment FOREIGN KEY (PaymentTypeID) REFERENCES tlg_PaymentType(PaymentTypeID)
)
go
-- End creating the InvoicePayment table

-- Creating the OrderDetail table
CREATE TABLE tlg_OrderDetail(
	-- Columns for the OrderDetail table
	OrderDetailID int identity(16, 1),
	OrderID int not null,
	ProductID int not null,
	Quantity int not null,
	-- Constraints in the OrderDetail table
	CONSTRAINT PK_tlg_OrderDetail PRIMARY KEY (OrderDetailID),
	CONSTRAINT FK1_tlg_OrderDetail FOREIGN KEY (OrderID) REFERENCES tlg_Order(OrderID),
	CONSTRAINT FK2_tlg_OrderDetail FOREIGN KEY (ProductID) REFERENCES tlg_Product(ProductID)
)
go
-- End creating the OrderDetail table

-- create all stored procedures
-- stored procedure to insert a new product into the Product table
CREATE PROCEDURE tlg_AddNewProduct (@product_name varchar(30), @product_category varchar(10), @price decimal, @description varchar(100))
AS
BEGIN
	DECLARE @category_id int

	SELECT @category_id = ProductTypeID FROM dbo.tlg_ProductType
	WHERE Category = @product_category

	INSERT INTO dbo.tlg_Product(ProductName, ProductTypeID, Price, ProductDescription)
	VALUES
		(@product_name, @category_id, @price, @description)

	RETURN SCOPE_IDENTITY()
END
go

-- stored procedure to insert a new employee into the Employee table
CREATE PROCEDURE tlg_AddNewEmployee (@first_name varchar(30), @last_name varchar(30), @email_address varchar(30))
AS
BEGIN
	INSERT INTO dbo.tlg_Employee(FirstName, LastName, EmailAddress)
	VALUES
		(@first_name, @last_name, @email_address)

	RETURN SCOPE_IDENTITY()
END
go

-- stored precedure to insert a new customer into the Customer table
CREATE PROCEDURE tlg_AddNewCustomer (@first_name varchar(30), @last_name varchar(30), @street_number varchar(50), @city varchar(50), @email_address varchar(30))
AS
BEGIN
	INSERT INTO dbo.tlg_Customer(FirstName, LastName, AddressStreetandNumber, AddressCity, EmailAddress)
	VALUES
		(@first_name, @last_name, @street_number, @city, @email_address)

	RETURN SCOPE_IDENTITY()
END
go

-- create all views
-- view to determine the number of orders closed per employee
CREATE VIEW dbo.tlg_OrdersClosedByEmployee AS
	SELECT
		concat(dbo.tlg_Employee.FirstName, ', ' , dbo.tlg_Employee.LastName) as EmployeeFullName,
		count(dbo.tlg_Order.OrderID) as NumberOfOrdersClosed
	FROM dbo.tlg_Order
	JOIN dbo.tlg_Employee ON dbo.tlg_Order.EmployeeID = dbo.tlg_Employee.EmployeeID
	WHERE dbo.tlg_Order.OrderStatusID = 2
	GROUP BY
		concat(dbo.tlg_Employee.FirstName, ', ' , dbo.tlg_Employee.LastName)	
go

-- view to determine the number of customers per city
CREATE VIEW dbo.tlg_CustomersByCity AS
	SELECT
		tlg_Customer.AddressCity,
		count(tlg_Customer.CustomerID) as NumberOfCustomers
	FROM tlg_Customer
	GROUP BY
		tlg_Customer.AddressCity
go

-- view to determine the number of new customers gained per month
CREATE VIEW dbo.tlg_NewCustomersPerMonth AS
	SELECT
		Month(tlg_Customer.DateJoined) as MonthJoined,
		Year(tlg_Customer.DateJoined) as YearJoined,
		count(tlg_Customer.CustomerID) as NumberOfCustomers
	FROM tlg_Customer
	GROUP BY
		Month(tlg_Customer.DateJoined),
		Year(tlg_Customer.DateJoined)
go

-- view to determine which month is the top selling month (mainly written to be passed to the next view)
CREATE VIEW dbo.tlg_TopSellingMonth AS
	SELECT TOP 1
		Month(tlg_Order.OrderDate) as OrderMonth,
		Year(tlg_Order.OrderDate) as OrderYear,
		sum(tlg_Invoice.AmountOwed) as TotalSales
	FROM tlg_Order
	JOIN tlg_Invoice ON tlg_Order.OrderID = tlg_Invoice.OrderID
	GROUP BY
		Month(tlg_Order.OrderDate),
		Year(tlg_Order.OrderDate)
	ORDER BY OrderYear, OrderMonth
go

-- view to determine the distribution of sales by number of customers within the top selling month
CREATE VIEW dbo.tlg_DistributionOfSalesInTopSellingMonth AS
	SELECT
		B.AmountSpent,
		count(B.CustomerID) as NumberOfCustomers,
		concat(B.OrderMonth, '-', B.OrderYear) as OrderMonthYear
	FROM
		(SELECT
			tlg_Order.CustomerID,
			Month(tlg_Order.OrderDate) as OrderMonth,
			Year(tlg_Order.OrderDate) as OrderYear,
			sum(tlg_Invoice.AmountOwed) as AmountSpent
		FROM tlg_Order
		JOIN tlg_Invoice ON tlg_Order.OrderID = tlg_Invoice.OrderID
		WHERE (
			(Month(tlg_Order.OrderDate) = (SELECT OrderMonth FROM dbo.tlg_TopSellingMonth)) and
			(Year(tlg_Order.OrderDate) =(SELECT OrderYear FROM dbo.tlg_TopSellingMonth))
		)
		GROUP BY
			tlg_Order.CustomerID,
			Month(tlg_Order.OrderDate),
			Year(tlg_Order.OrderDate)) as B
	GROUP BY
		B.AmountSpent,
		concat(B.OrderMonth, '-', B.OrderYear)
go
