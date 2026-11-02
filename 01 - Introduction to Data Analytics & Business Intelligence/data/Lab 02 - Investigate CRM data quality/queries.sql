SELECT COUNT(*) AS CustomerRows,
       COUNT(DISTINCT CustomerID) AS DistinctCustomerIDs
FROM dbo.customers_dirty;

SELECT COUNT(*) AS SalesRows,
       SUM(CAST(Revenue AS decimal(18,2))) AS RawRevenue
FROM dbo.sales_dirty;


SELECT CustomerID, COUNT(*) AS Occurrences
FROM dbo.customers_dirty
GROUP BY CustomerID
HAVING COUNT(*) > 1;


SELECT CustomerID,CustomerName,Region
FROM dbo.customers_dirty
WHERE Region IS NULL OR LTRIM(RTRIM(Region))='';


SELECT CustomerID,Region,
       UPPER(LTRIM(RTRIM(Region))) AS SuggestedRegionKey
FROM dbo.customers_dirty
ORDER BY CustomerID;


SELECT s.SalesLineID,s.CustomerID,s.Revenue
FROM dbo.sales_dirty s
WHERE NOT EXISTS (
 SELECT 1 FROM dbo.customers_dirty c
 WHERE c.CustomerID=s.CustomerID
);


SELECT * FROM dbo.sales_dirty
WHERE CAST(Revenue AS decimal(18,2)) < 0;


SELECT SUM(CAST(s.Revenue AS decimal(18,2))) AS LeftJoinRevenue
FROM dbo.sales_dirty s
LEFT JOIN dbo.customers_dirty c ON s.CustomerID=c.CustomerID;


SELECT SUM(CAST(s.Revenue AS decimal(18,2))) AS InnerJoinRevenue
FROM dbo.sales_dirty s
JOIN dbo.customers_dirty c ON s.CustomerID=c.CustomerID;
