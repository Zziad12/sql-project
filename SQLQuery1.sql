
SELECT c.CustomerID, p.Name AS ProductName,
ROUND(SUM(sod.LineTotal), 2) AS TotalSpent
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE sod.LineTotal > 1000
GROUP BY c.CustomerID, p.Name
ORDER BY TotalSpent DESC;



UPDATE Production.Product
SET Color = 'Other'
WHERE Color IS NULL OR Color = '';



SELECT ROUND(SUM(LineTotal), 2) AS TotalSales
FROM Sales.SalesOrderDetail;

SELECT TOP 10
p.Name AS ProductName,
ROUND(SUM(sod.LineTotal), 2) AS TotalProfit
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalProfit DESC;


SELECT CustomerID, COUNT(SalesOrderID) AS OrdersCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY OrdersCount DESC;


SELECT 
pc.Name AS CategoryName,
COUNT(p.ProductID) AS TotalProducts
FROM Production.Product p
JOIN Production.ProductSubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalProducts DESC;

SELECT MONTH(OrderDate) AS Month,
ROUND(SUM(TotalDue), 2) AS MonthlySales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = (SELECT MAX(YEAR(OrderDate)) FROM Sales.SalesOrderHeader)
GROUP BY MONTH(OrderDate)
ORDER BY Month;

SELECT TOP 10
a.City,
ROUND(COUNT(soh.SalesOrderID), 2) AS TotalOrders
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
GROUP BY a.City
ORDER BY TotalOrders DESC;


USE AdventureWorks2022;


IF OBJECT_ID('vw_DimCustomer', 'V') IS NOT NULL
    DROP VIEW vw_DimCustomer;
GO

CREATE VIEW vw_DimCustomer AS
SELECT 
    c.CustomerID,
    CASE 
        WHEN p.FirstName IS NOT NULL THEN p.FirstName
        ELSE 'John' 
    END AS FirstName,
    CASE 
        WHEN p.LastName IS NOT NULL THEN p.LastName
        ELSE 'Doe' 
    END AS LastName,
    CONCAT(ISNULL(p.FirstName,'John'), ' ', ISNULL(p.LastName,'Doe')) AS FullName,
    a.City,
    sp.Name AS StateProvince,
    cr.Name AS CountryRegion
FROM Sales.Customer c
LEFT JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
LEFT JOIN Person.Address a ON bea.AddressID = a.AddressID
LEFT JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
LEFT JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode;
GO
