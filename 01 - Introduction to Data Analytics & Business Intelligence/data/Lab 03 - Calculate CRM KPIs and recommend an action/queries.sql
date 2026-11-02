SELECT 'customers' AS Dataset,COUNT(*) AS RowsFound FROM dbo.customers
UNION ALL SELECT 'products',COUNT(*) FROM dbo.products
UNION ALL SELECT 'sales',COUNT(*) FROM dbo.sales
UNION ALL SELECT 'opportunities',COUNT(*) FROM dbo.opportunities
UNION ALL SELECT 'targets',COUNT(*) FROM dbo.targets;


SELECT SUM(CAST(Revenue AS decimal(18,2))) AS JanuaryRevenue,
       COUNT(DISTINCT CustomerID) AS PurchasingCustomers,
       SUM(CAST(Quantity AS int)) AS Units
FROM dbo.sales
WHERE CAST(SaleDate AS date)>='2026-01-01'
  AND CAST(SaleDate AS date)<'2026-02-01';


SELECT c.Region,SUM(CAST(s.Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.CustomerID=c.CustomerID
WHERE CAST(s.SaleDate AS date)>='2026-01-01'
  AND CAST(s.SaleDate AS date)<'2026-02-01'
GROUP BY c.Region
ORDER BY Revenue DESC;


SELECT p.ProductName,SUM(CAST(s.Revenue AS decimal(18,2))) AS Revenue
FROM dbo.sales s
JOIN dbo.products p ON s.ProductID=p.ProductID
WHERE CAST(s.SaleDate AS date)>='2026-01-01'
  AND CAST(s.SaleDate AS date)<'2026-02-01'
GROUP BY p.ProductName
ORDER BY Revenue DESC;


SELECT
 SUM(CASE WHEN Stage IN ('Proposal','Negotiation')
     THEN CAST(EstimatedValue AS decimal(18,2)) ELSE 0 END) AS OpenPipeline,
 SUM(CASE WHEN Stage='Won' THEN 1 ELSE 0 END) AS WonCount,
 SUM(CASE WHEN Stage='Lost' THEN 1 ELSE 0 END) AS LostCount,
 CAST(100.0*SUM(CASE WHEN Stage='Won' THEN 1 ELSE 0 END)
 /NULLIF(SUM(CASE WHEN Stage IN ('Won','Lost') THEN 1 ELSE 0 END),0)
 AS decimal(10,2)) AS WinRatePercent,
 AVG(CASE WHEN Stage='Won' THEN CAST(EstimatedValue AS decimal(18,2)) END)
 AS AverageWonDealValue
FROM dbo.opportunities;


WITH Actual AS (
 SELECT SUM(CAST(Revenue AS decimal(18,2))) AS Revenue
 FROM dbo.sales
 WHERE CAST(SaleDate AS date)>='2026-01-01'
   AND CAST(SaleDate AS date)<'2026-02-01'
), Target AS (
 SELECT SUM(CAST(RevenueTarget AS decimal(18,2))) AS RevenueTarget
 FROM dbo.targets WHERE [Month]='2026-01'
)
SELECT a.Revenue,t.RevenueTarget,
       a.Revenue-t.RevenueTarget AS Variance,
       CAST(100.0*a.Revenue/NULLIF(t.RevenueTarget,0)
            AS decimal(10,2)) AS AchievementPercent
FROM Actual a CROSS JOIN Target t;
