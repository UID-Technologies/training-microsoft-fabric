SELECT COUNT(*) AS SalesLines,
       SUM(CAST(Quantity AS int)) AS Units,
       SUM(CAST(Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales;


SELECT s.SalesLineID,c.CustomerName,p.ProductName,s.Quantity,s.Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.CustomerID=c.CustomerID
JOIN dbo.products p ON s.ProductID=p.ProductID
ORDER BY s.SalesLineID;
