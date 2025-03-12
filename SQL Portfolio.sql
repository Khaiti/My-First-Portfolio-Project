--AdventureWorks Sales & Customer Insight
--Queries focusing strictly on Joins and Subqueries AdventureWorks file

--1. Retrieve Employee Full Name and Job Title
SELECT 
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    e.JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID;

--2. Retrieve Vendor Names and the Number of Products They Supply
SELECT 
    v.Name AS VendorName,
    COUNT(pv.ProductID) AS ProductSupplied
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.Name;

--3. Get the Most Purchased Product
SELECT TOP 1
    p.Name AS ProductName,
    SUM(sod.OrderQty) AS TotalOrdered
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY SUM(sod.OrderQty) DESC;

--4. Get Customers Who Have Placed More Than 5 Orders
SELECT 
    c.CustomerID,
    p.FirstName + ' ' + p.LastName AS CustomerName,
    COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 5;

--5. Find the Number of Employees per Department
SELECT 
    d.Name AS Department,
    COUNT(e.BusinessEntityID) AS EmployeeCount
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
GROUP BY d.Name;

--6. Find the Top 5 Most Expensive Products
SELECT TOP 5 
    Name AS ProductName,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

--7.  Find the Customers Who Have Never Placed an Order
SELECT 
    c.CustomerID, 
    p.FirstName + ' ' + p.LastName AS CustomerName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
WHERE soh.SalesOrderID IS NULL;


--8. Find the Most Recent Purchase for Each Vendor
SELECT poh.*
FROM Purchasing.PurchaseOrderHeader poh
WHERE poh.OrderDate = (
    SELECT MAX(OrderDate)
    FROM Purchasing.PurchaseOrderHeader
    WHERE VendorID = poh.VendorID
);

--9. Find Products with Their Current Inventory Stock Level
SELECT 
    p.Name AS ProductName,
    il.Quantity
FROM Production.Product p
JOIN Production.ProductInventory il ON p.ProductID = il.ProductID;

--10.List Employees Who Have No Department Assigned
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
LEFT JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.DepartmentID IS NULL;

--11.  List Products That Have Been Ordered at Least Once
SELECT DISTINCT 
    p.ProductID, 
    p.Name AS ProductName
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID;

--12.  Retrieve Employees and Their Department Names
SELECT 
    e.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    d.Name AS Department
FROM HumanResources.Employee e
JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID;

--13 Find Customers Who Have Made a Purchase
SELECT CustomerID, PersonID 
FROM Sales.Customer
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader);

--14 Retrieve Employees Who Have a Pay Rate Higher Than Their Department's Average
SELECT e.BusinessEntityID, e.JobTitle, ep.Rate 
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory ep ON e.BusinessEntityID = ep.BusinessEntityID
WHERE ep.Rate > (SELECT AVG(Rate) FROM HumanResources.EmployeePayHistory);

--15 Get the Most Recent Order for Each Customer
SELECT CustomerID, SalesOrderID, OrderDate
FROM Sales.SalesOrderHeader soh
WHERE OrderDate = (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = soh.CustomerID);











