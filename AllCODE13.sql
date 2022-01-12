-- 1
USE AdventureWorks2019;
GO
CREATE VIEW dbo.vProduct
AS
SELECT ProductNumber, Name FROM Production.Product;
GO
SELECT * FROM dbo.vProduct;
GO
-- 2
BEGIN TRANSACTION
GO
USE AdventureWorks2019;
GO
CREATE TABLE Company (
Id_Num int IDENTITY (100, 5),
Company_Name nvarchar (100))
GO
INSERT Company (Company_Name) VALUES (N'A Bike Store')
INSERT Company (Company_Name) VALUES (N'Progressive Sports')
INSERT Company (Company_Name) VALUES (N'Modular Cycle Systems')
INSERT Company (Company_Name) VALUES (N'Advanced Bike Components')
INSERT Company (Company_Name) VALUES (N'Metropolitan Sports Supply')
INSERT Company (Company_Name) VALUES (N'Aerobic Exercise Company')
INSERT Company (Company_Name) VALUES (N'Associated Bikes')
INSERT Company (Company_Name) VALUES (N'Exemplary Cycles')
GO
SELECT Id_Num, Company_Name FROM dbo. Company
ORDER BY Company_Name ASC;
go
COMMIT;
GO
-- 3
USE AdventureWorks2019;
GO
DECLARE @find varchar (30)  ='Man%'; 
SELECT p.LastName, p.FirstName, ph. PhoneNumber FROM Person. Person AS P
JOIN Person.PersonPhone AS ph ON p.BusinesSEntityID = ph.BusinessEntityID
WHERE LastName LIKE @find;
                            
go
-- 4
DECLARE @myvar char(20);
SET @myvar = 'This is a test';
go
-- 5
USE AdventureWorks2019;
GO
DECLARE @varl nvarchar (30);
SELECT @varl = 'Unnamed Company';
SELECT @varl = Name FROM Sales.Store WHERE BusinessEntityID = 10;
SELECT @varl AS 'Company Name';
go
-- 6
USE AdventureWorks2019;
GO
CREATE SYNONYM MyAddressType
FOR AdventureWorks2019. Person.AddressType;
GO
-- 7
USE AdventureWorks2019;
GO
BEGIN TRANSACTION;
GO
IF @@TRANCOUNT = 0 BEGIN
SELECT FirstName, MiddleName
FROM Person.Person WHERE LastName = 'Andy';
ROLLBACK TRANSACTION;
PRINT N'Rolling back the transaction two times would cause an error.';
END;
ROLLBACK TRANSACTION;
PRINT N'Rolled back the transaction.';
GO              
-- 8
USE AdventureWorks2019;
GO
DECLARE @ListPrice money;
SET @ListPrice = (SELECT MAX (p. ListPrice) FROM Production.Product AS p
JOIN Production.ProductSubcategory AS s
ON p. ProductSubcategoryID = s.ProductSubcategoryID WHERE s.[Name] = 'Mountain
Bikes');
                                                                 
PRINT @ListPrice
IF @ListPrice <3000
PRINT 'All the products in this category can be purchased for an amount less
than 3000'
ELSE
PRINT 'The prices for some products in this category exceed 3000'
go
-- 9
DECLARE @flag int SET @flag = 10 WHILE (@flag <=95) BEGIN
IF @flag%2 =0 PRINT @flag
SET @flag = @flag + 1 
CONTINUE; END
GO
-- 10
USE AdventureWorks2019;
GO
IF OBJECT_ID (N'Sales.ufn_CustDates', N'IF') IS NOT NULL DROP FUNCTION
Sales.ufn_ufn_CustDates;
GO
CREATE FUNCTION Sales.ufn_CustDates () RETURNS TABLE
AS RETURN (
SELECT A.CustomerID, B.DueDate, B.ShipDate FROM Sales.Customer A
LEFT OUTER JOIN
Sales.SalesOrderHeader B ON
A.CustomerID = B.CustomerID AND YEAR (B.DueDate) <2020  );   
go
-- 11
Select * From Sales.ufn_CustDates();
go
-- 12
USE AdventureWorks2019;
GO
ALTER FUNCTION [dbo].[ufnGetAccountingEndDate]() RETURNS [datetime]
AS BEGIN
RETURN DATEADD (millisecond, -2, CONVERT (datetime, '20040701', 112));
END;
go
-- 13
USE AdventureWorks2019;
GO
SELECT SalesOrderID, ProductID, OrderQty
,SUM (OrderQty) OVER (PARTITION BY SalesOrderID) AS Total
,MAX (OrderQty) OVER (PARTITION BY SalesOrderID) AS MaxOrderQty FROM
Sales.SalesOrderDetail
WHERE ProductId IN(776, 773);
GO
-- 14
SELECT CustomerID, StoreID,
RANK() OVER (ORDER BY StoreID DESC) AS Rnk_All, RANK () OVER (PARTITION BY
PersonID
ORDER BY CustomerID DESC) AS Rnk_Cust
FROM Sales.Customer;
go
-- 15
SELECT TerritoryID, Name, SalesYTD, RANK () OVER (ORDER BY SalesYTD DESC) AS
Rnk_One, RANK () OVER (PARTITION BY TerritoryID
ORDER BY SalesYTD DESC) AS Rnk_Two
FROM Sales.SalesTerritory;
go
-- 16
SELECT ProductID, Shelf, Quantity,
SUM (Quantity) OVER (PARTITION BY ProductID
ORDER BY LocationID
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunQty
FROM Production.ProductInventory;
go
-- 17
USE AdventureWorks2019;
GO
SELECT p.FirstName, p.LastName
,ROW_NUMBER () OVER (ORDER BY a.PostalCode) AS 'Row Number'
,NTILE (4) OVER (ORDER BY a.PostalCode) AS 'NTILE'
,s.SalesYTD, a.PostalCode FROM Sales.SalesPerson AS s
INNER JOIN Person.Person AS p
ON s.BusinessEntityID= p.BusinesSEntityID INNER JOIN Person.Address AS a
ON a.AddressID = p.BusinessEntityID
WHERE TerritoryID IS NOT NULL AND SalesYTD <> 0;
go
-- 18
CREATE TABLE Test (
ColDatetimeoffset datetimeoffset
);
GO
INSERT INTO Test
VALUES ('1998-09-20 7:45:50.71345 -5:00');
GO
SELECT SWITCHOFFSET (ColDatetimeoffset, '-08:00')
FROM Test;
GO
--Returns: 1998-09-20 04:45:50.7134500 -08:00
SELECT ColDatetimeoffset
FROM Test;
go
-- 19
SELECT DATETIMEOFFSETFROMPARTS (2010, 12, 31, 14, 23, 23, 0, 12, 0, 7)
AS Result;
go
-- 20
SELECT SYSDATETIME() AS SYSDATETIME
 ,SYSDATETIMEOFFSET () AS SYSDATETIMEOFFSET
 ,SYSUTCDATETIME () AS SYSUTCDATETIME
 go
-- 21
USE AdventureWorks2019;
GO
SELECT BusinessEntityID, YEAR (QuotaDate) AS QuotaYear, SalesQuota AS NewQuota,
LEAD (SalesQuota, 1,0) OVER (ORDER BY YEAR (QuotaDate)) AS FutureQuota FROM
Sales.SalesPersonQuotaHistory
WHERE BusinessEntityID = 275 and YEAR (QuotaDate) IN ('2011','2014');
go
-- 22
USE AdventureWorks2019;
GO
SELECT Name, ListPrice,
FIRST_VALUE (Name) OVER (ORDER BY ListPrice ASC) AS LessExpensive FROM
Production.Product
WHERE ProductSubcategoryID = 37 
go