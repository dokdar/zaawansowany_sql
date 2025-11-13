-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Zaawansowany SQL w Databricks - Notebook Demonstracyjny
-- MAGIC
-- MAGIC Ten notebook zawiera wszystkie przykłady demonstracyjne z szkolenia.
-- MAGIC Możesz uruchamiać każdą komórkę osobno, eksperymentować z kodem i obserwować wyniki.
-- MAGIC
-- MAGIC **Struktura:**
-- MAGIC 1. Inicjalizacja bazy Northwind
-- MAGIC 2. Podstawy SQL - przypomnienie
-- MAGIC 3. Zaawansowane funkcje grupowania
-- MAGIC 4. Common Table Expressions (CTE)
-- MAGIC 5. Funkcje analityczne (Window Functions)
-- MAGIC 6. Funkcje użytkownika (UDF)
-- MAGIC 7. Optymalizacja i best practices
-- MAGIC
-- MAGIC **Instrukcja:**
-- MAGIC - Uruchom najpierw sekcję inicjalizacji (komórki 1-9)
-- MAGIC - Następnie możesz uruchamiać dowolne przykłady w dowolnej kolejności
-- MAGIC - Eksperymentuj! Zmieniaj zapytania i zobacz co się stanie

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 1. Inicjalizacja Bazy Danych Northwind
-- MAGIC
-- MAGIC Najpierw tworzymy bazę danych i tabele z przykładowymi danymi.

-- COMMAND ----------

-- Tworzenie bazy danych
CREATE DATABASE IF NOT EXISTS northwind;
USE northwind;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Tabela Categories

-- COMMAND ----------

DROP TABLE IF EXISTS Categories;

CREATE TABLE Categories (
  CategoryID INT NOT NULL,
  CategoryName STRING NOT NULL,
  Description STRING,
  PRIMARY KEY (CategoryID)
) USING DELTA;

INSERT INTO Categories VALUES
(1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
(2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
(3, 'Confections', 'Desserts, candies, and sweet breads'),
(4, 'Dairy Products', 'Cheeses'),
(5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
(6, 'Meat/Poultry', 'Prepared meats'),
(7, 'Produce', 'Dried fruit and bean curd'),
(8, 'Seafood', 'Seaweed and fish');

SELECT * FROM Categories;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Tabela Products

-- COMMAND ----------

DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
  ProductID INT NOT NULL,
  ProductName STRING NOT NULL,
  SupplierID INT,
  CategoryID INT,
  QuantityPerUnit STRING,
  UnitPrice DECIMAL(10,2),
  UnitsInStock INT,
  UnitsOnOrder INT,
  ReorderLevel INT,
  Discontinued BOOLEAN,
  PRIMARY KEY (ProductID)
) USING DELTA;

INSERT INTO Products VALUES
(1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10, false),
(2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00, 17, 40, 25, false),
(3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00, 13, 70, 25, false),
(4, 'Chef Anton''s Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00, 53, 0, 0, false),
(5, 'Chef Anton''s Gumbo Mix', 2, 2, '36 boxes', 21.35, 0, 0, 0, true),
(6, 'Grandma''s Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25.00, 120, 0, 25, false),
(7, 'Uncle Bob''s Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30.00, 15, 0, 10, false),
(8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40.00, 6, 0, 0, false),
(9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97.00, 29, 0, 0, true),
(10, 'Ikura', 4, 8, '12 - 200 ml jars', 31.00, 31, 0, 0, false),
(11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21.00, 22, 30, 30, false),
(12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38.00, 86, 0, 0, false),
(13, 'Konbu', 6, 8, '2 kg box', 6.00, 24, 0, 5, false),
(14, 'Tofu', 6, 7, '40 - 100 g pkgs.', 23.25, 35, 0, 0, false),
(15, 'Genen Shouyu', 6, 2, '24 - 250 ml bottles', 15.50, 39, 0, 5, false),
(16, 'Pavlova', 7, 3, '32 - 500 g boxes', 17.45, 29, 0, 10, false),
(17, 'Alice Mutton', 7, 6, '20 - 1 kg tins', 39.00, 0, 0, 0, true),
(18, 'Carnarvon Tigers', 7, 8, '16 kg pkg.', 62.50, 42, 0, 0, false),
(19, 'Teatime Chocolate Biscuits', 8, 3, '10 boxes x 12 pieces', 9.20, 25, 0, 5, false),
(20, 'Sir Rodney''s Marmalade', 8, 3, '30 gift boxes', 81.00, 40, 0, 0, false);

SELECT * FROM Products LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Tabele: Customers, Employees, Orders, OrderDetails

-- COMMAND ----------

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
  CustomerID STRING NOT NULL,
  CompanyName STRING NOT NULL,
  ContactName STRING,
  Country STRING,
  City STRING,
  PRIMARY KEY (CustomerID)
) USING DELTA;

INSERT INTO Customers VALUES
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Germany', 'Berlin'),
('ANATR', 'Ana Trujillo Emparedados', 'Ana Trujillo', 'Mexico', 'México D.F.'),
('ANTON', 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mexico', 'México D.F.'),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'UK', 'London'),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Sweden', 'Luleå'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Germany', 'Mannheim'),
('BLONP', 'Blondesddsl père et fils', 'Frédérique Citeaux', 'France', 'Strasbourg'),
('BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Spain', 'Madrid'),
('BONAP', 'Bon app''', 'Laurence Lebihan', 'France', 'Marseille'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Canada', 'Tsawassen');

DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
  EmployeeID INT NOT NULL,
  FirstName STRING NOT NULL,
  LastName STRING NOT NULL,
  Title STRING,
  ReportsTo INT,
  PRIMARY KEY (EmployeeID)
) USING DELTA;

INSERT INTO Employees VALUES
(1, 'Nancy', 'Davolio', 'Sales Representative', 2),
(2, 'Andrew', 'Fuller', 'Vice President, Sales', NULL),
(3, 'Janet', 'Leverling', 'Sales Representative', 2),
(4, 'Margaret', 'Peacock', 'Sales Representative', 2),
(5, 'Steven', 'Buchanan', 'Sales Manager', 2),
(6, 'Michael', 'Suyama', 'Sales Representative', 5),
(7, 'Robert', 'King', 'Sales Representative', 5),
(8, 'Laura', 'Callahan', 'Inside Sales Coordinator', 2),
(9, 'Anne', 'Dodsworth', 'Sales Representative', 5);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
  OrderID INT NOT NULL,
  CustomerID STRING NOT NULL,
  EmployeeID INT,
  OrderDate TIMESTAMP,
  ShipCountry STRING,
  PRIMARY KEY (OrderID)
) USING DELTA;

INSERT INTO Orders VALUES
(10248, 'ALFKI', 5, '2023-07-04 00:00:00', 'Germany'),
(10249, 'ANATR', 6, '2023-07-05 00:00:00', 'Mexico'),
(10250, 'AROUT', 4, '2023-07-08 00:00:00', 'UK'),
(10251, 'ALFKI', 3, '2023-07-08 00:00:00', 'Germany'),
(10252, 'BERGS', 4, '2023-07-09 00:00:00', 'Sweden'),
(10253, 'BLAUS', 3, '2023-07-10 00:00:00', 'Germany'),
(10254, 'BLONP', 5, '2023-07-11 00:00:00', 'France'),
(10255, 'BONAP', 9, '2023-07-12 00:00:00', 'France'),
(10256, 'BOTTM', 3, '2023-07-15 00:00:00', 'Canada'),
(10257, 'ALFKI', 4, '2023-07-16 00:00:00', 'Germany'),
(10258, 'ANATR', 1, '2023-08-17 00:00:00', 'Mexico'),
(10259, 'AROUT', 2, '2023-08-18 00:00:00', 'UK'),
(10260, 'BERGS', 4, '2023-08-19 00:00:00', 'Sweden'),
(10261, 'BLONP', 4, '2023-08-19 00:00:00', 'France'),
(10262, 'BONAP', 8, '2023-08-22 00:00:00', 'France'),
(10263, 'BOTTM', 9, '2023-09-23 00:00:00', 'Canada'),
(10264, 'ALFKI', 6, '2023-09-24 00:00:00', 'Germany'),
(10265, 'ANATR', 2, '2023-09-25 00:00:00', 'Mexico'),
(10266, 'AROUT', 3, '2023-09-26 00:00:00', 'UK'),
(10267, 'BERGS', 4, '2023-09-29 00:00:00', 'Sweden');

DROP TABLE IF EXISTS OrderDetails;

CREATE TABLE OrderDetails (
  OrderID INT NOT NULL,
  ProductID INT NOT NULL,
  UnitPrice DECIMAL(10,2) NOT NULL,
  Quantity INT NOT NULL,
  Discount DECIMAL(3,2),
  PRIMARY KEY (OrderID, ProductID)
) USING DELTA;

INSERT INTO OrderDetails VALUES
(10248, 11, 14.00, 12, 0.00),
(10248, 42, 9.80, 10, 0.00),
(10248, 72, 34.80, 5, 0.00),
(10249, 14, 18.60, 9, 0.00),
(10249, 51, 42.40, 40, 0.00),
(10250, 41, 7.70, 10, 0.00),
(10250, 51, 42.40, 35, 0.15),
(10250, 65, 16.80, 15, 0.15),
(10251, 22, 16.80, 6, 0.05),
(10251, 57, 15.60, 15, 0.05),
(10252, 20, 64.80, 40, 0.05),
(10252, 33, 2.00, 25, 0.05),
(10253, 31, 10.00, 20, 0.00),
(10253, 39, 14.40, 42, 0.00),
(10254, 24, 3.60, 15, 0.15),
(10254, 55, 19.20, 21, 0.15),
(10255, 2, 15.20, 20, 0.00),
(10255, 16, 13.90, 35, 0.00),
(10256, 53, 26.20, 15, 0.00),
(10256, 77, 10.40, 12, 0.00);

SELECT 'Baza danych Northwind zainicjalizowana pomyślnie!' AS Status;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 2. Podstawy SQL - Przypomnienie
-- MAGIC
-- MAGIC Szybkie przypomnienie podstawowych konstrukcji SQL.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Proste SELECT z filtrami

-- COMMAND ----------

-- Wybierz produkty droższe niż 20
SELECT
    ProductName,
    UnitPrice,
    UnitsInStock
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC
LIMIT 5;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### JOIN - łączenie tabel

-- COMMAND ----------

-- Produkty z nazwami kategorii
SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    p.UnitsInStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
ORDER BY p.UnitPrice DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Agregacje podstawowe

-- COMMAND ----------

-- Średnia cena, liczba produktów i suma zapasów według kategorii
SELECT
    c.CategoryName,
    COUNT(*) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    SUM(p.UnitsInStock) AS TotalStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING AVG(p.UnitPrice) > 20
ORDER BY AvgPrice DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 3. Zaawansowane Funkcje Grupowania
-- MAGIC
-- MAGIC ROLLUP, CUBE, GROUPING SETS, PIVOT

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### ROLLUP - sumy hierarchiczne

-- COMMAND ----------

-- Sprzedaż według kraju i miesiąca z sumami częściowymi
SELECT
    o.ShipCountry,
    MONTH(o.OrderDate) AS Month,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ROLLUP(o.ShipCountry, MONTH(o.OrderDate))
ORDER BY o.ShipCountry, Month;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### ROLLUP z GROUPING - formatowanie sum

-- COMMAND ----------

-- Ładnie sformatowane sumy z oznaczeniem poziomów
SELECT
    CASE
        WHEN GROUPING(o.ShipCountry) = 1 THEN 'TOTAL ALL COUNTRIES'
        ELSE o.ShipCountry
    END AS Country,
    CASE
        WHEN GROUPING(MONTH(o.OrderDate)) = 1 AND GROUPING(o.ShipCountry) = 0 THEN 'TOTAL FOR COUNTRY'
        WHEN GROUPING(MONTH(o.OrderDate)) = 1 THEN ''
        ELSE CAST(MONTH(o.OrderDate) AS STRING)
    END AS Month,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalSales,
    GROUPING_ID(o.ShipCountry, MONTH(o.OrderDate)) AS AggLevel
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ROLLUP(o.ShipCountry, MONTH(o.OrderDate))
ORDER BY
    GROUPING(o.ShipCountry),
    o.ShipCountry,
    GROUPING(MONTH(o.OrderDate)),
    Month;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### CUBE - wszystkie kombinacje

-- COMMAND ----------

-- Analiza wielowymiarowa: kategoria × kraj
SELECT
    COALESCE(c.CategoryName, 'TOTAL') AS Category,
    COALESCE(o.ShipCountry, 'TOTAL') AS Country,
    COUNT(DISTINCT o.OrderID) AS Orders,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Sales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY CUBE(c.CategoryName, o.ShipCountry)
ORDER BY
    GROUPING(c.CategoryName),
    c.CategoryName,
    GROUPING(o.ShipCountry),
    o.ShipCountry;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### GROUPING SETS - wybrane kombinacje

-- COMMAND ----------

-- Tylko wybrane poziomy agregacji
SELECT
    c.CategoryName,
    o.ShipCountry,
    COUNT(DISTINCT o.OrderID) AS Orders,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS Sales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY GROUPING SETS (
    (c.CategoryName, o.ShipCountry),  -- Szczegóły
    (c.CategoryName),                  -- Suma per kategoria
    ()                                 -- Suma całkowita
)
ORDER BY
    GROUPING(c.CategoryName),
    c.CategoryName,
    o.ShipCountry;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### PIVOT - transponowanie danych

-- COMMAND ----------

-- Sprzedaż według kraju (wiersze) i miesiąca (kolumny)
SELECT *
FROM (
    SELECT
        o.ShipCountry,
        MONTH(o.OrderDate) AS Month,
        SUM(od.Quantity * od.UnitPrice) AS Sales
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.ShipCountry, MONTH(o.OrderDate)
)
PIVOT (
    ROUND(SUM(Sales), 2)
    FOR Month IN (7 AS July, 8 AS August, 9 AS September)
);

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 4. Common Table Expressions (CTE)
-- MAGIC
-- MAGIC Podstawowe i rekurencyjne CTE

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### CTE podstawowe - czytelność

-- COMMAND ----------

-- Zamiast zagnieżdżonych podzapytań - użyj CTE
WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName, p.CategoryID
),
CategoryAvg AS (
    SELECT
        CategoryID,
        AVG(TotalSales) AS AvgSalesInCategory
    FROM ProductSales
    GROUP BY CategoryID
)
SELECT
    ps.ProductName,
    ps.TotalSales,
    ca.AvgSalesInCategory,
    ROUND(ps.TotalSales - ca.AvgSalesInCategory, 2) AS DiffFromAvg
FROM ProductSales ps
JOIN CategoryAvg ca ON ps.CategoryID = ca.CategoryID
WHERE ps.TotalSales > ca.AvgSalesInCategory
ORDER BY DiffFromAvg DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rekurencyjne CTE - silnia

-- COMMAND ----------

-- Obliczenie silni liczby 5 (5!)
WITH RECURSIVE Factorial(n, result) AS (
    -- Anchor member: 1! = 1
    SELECT 1 AS n, 1 AS result

    UNION ALL

    -- Recursive member: n! = n * (n-1)!
    SELECT
        n + 1,
        (n + 1) * result
    FROM Factorial
    WHERE n < 5
)
SELECT
    n,
    result AS Factorial
FROM Factorial
ORDER BY n;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rekurencyjne CTE - hierarchia pracowników

-- COMMAND ----------

-- Drzewo raportowania pracowników
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor: pracownicy bez przełożonego (root)
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        Title,
        ReportsTo,
        CAST(NULL AS STRING) AS ManagerName,
        0 AS Level,
        CAST(LastName AS STRING) AS Path
    FROM Employees
    WHERE ReportsTo IS NULL

    UNION ALL

    -- Recursive: pracownicy raportujący do kogoś
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Title,
        e.ReportsTo,
        eh.FirstName || ' ' || eh.LastName AS ManagerName,
        eh.Level + 1 AS Level,
        eh.Path || ' > ' || e.LastName AS Path
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ReportsTo = eh.EmployeeID
)
SELECT
    REPEAT('  ', Level) || FirstName || ' ' || LastName AS Employee,
    Title,
    ManagerName,
    Level,
    Path
FROM EmployeeHierarchy
ORDER BY Path;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rekurencyjne CTE - ciąg Fibonacciego

-- COMMAND ----------

-- Pierwsze 10 liczb Fibonacciego
WITH RECURSIVE Fibonacci(n, fib_n, fib_n_plus_1) AS (
    -- Anchor: F(0) = 0, F(1) = 1
    SELECT 0 AS n, 0 AS fib_n, 1 AS fib_n_plus_1

    UNION ALL

    -- Recursive: F(n+1) = F(n) + F(n-1)
    SELECT
        n + 1,
        fib_n_plus_1,
        fib_n + fib_n_plus_1
    FROM Fibonacci
    WHERE n < 9
)
SELECT
    n,
    fib_n AS Fibonacci
FROM Fibonacci
ORDER BY n;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 5. Funkcje Analityczne (Window Functions)
-- MAGIC
-- MAGIC ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, agregaty okienkowe

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### ROW_NUMBER - numerowanie wierszy

-- COMMAND ----------

-- Nadaj numer każdemu produktowi w ramach kategorii (od najdroższego)
SELECT
    c.CategoryName,
    p.ProductName,
    p.UnitPrice,
    ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS PriceRank
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, PriceRank;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Top N per group - praktyczne zastosowanie ROW_NUMBER

-- COMMAND ----------

-- Top 3 najdroższe produkty w każdej kategorii
WITH RankedProducts AS (
    SELECT
        c.CategoryName,
        p.ProductName,
        p.UnitPrice,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryName ORDER BY p.UnitPrice DESC) AS PriceRank
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT
    CategoryName,
    ProductName,
    UnitPrice,
    PriceRank
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY CategoryName, PriceRank;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### RANK vs DENSE_RANK

-- COMMAND ----------

-- Porównanie funkcji rankingowych
SELECT
    ProductName,
    UnitPrice,
    ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum,
    RANK() OVER (ORDER BY UnitPrice DESC) AS Rank,
    DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS DenseRank,
    NTILE(4) OVER (ORDER BY UnitPrice DESC) AS Quartile
FROM Products
ORDER BY UnitPrice DESC
LIMIT 15;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Agregaty jako funkcje okienkowe

-- COMMAND ----------

-- Porównaj każdy produkt ze średnią w jego kategorii
SELECT
    c.CategoryName,
    p.ProductName,
    p.UnitPrice,
    ROUND(AVG(p.UnitPrice) OVER (PARTITION BY c.CategoryName), 2) AS AvgInCategory,
    ROUND(p.UnitPrice - AVG(p.UnitPrice) OVER (PARTITION BY c.CategoryName), 2) AS DiffFromAvg,
    ROUND(100.0 * (p.UnitPrice - AVG(p.UnitPrice) OVER (PARTITION BY c.CategoryName)) /
          AVG(p.UnitPrice) OVER (PARTITION BY c.CategoryName), 1) AS PctDiffFromAvg
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, p.UnitPrice DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Suma bieżąca (Running Total)

-- COMMAND ----------

-- Suma bieżąca zamówień w czasie
SELECT
    OrderID,
    OrderDate,
    ShipCountry,
    SUM(1) OVER (ORDER BY OrderDate, OrderID ROWS UNBOUNDED PRECEDING) AS RunningOrderCount
FROM Orders
ORDER BY OrderDate, OrderID;

-- COMMAND ----------

-- Suma bieżąca wartości zamówień
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate
)
SELECT
    OrderID,
    OrderDate,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(SUM(OrderValue) OVER (ORDER BY OrderDate, OrderID ROWS UNBOUNDED PRECEDING), 2) AS RunningTotal
FROM OrderTotals
ORDER BY OrderDate, OrderID;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Średnia krocząca (Moving Average)

-- COMMAND ----------

-- 3-zamówieniowa średnia krocząca
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate
)
SELECT
    OrderID,
    OrderDate,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(AVG(OrderValue) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS MovingAvg3
FROM OrderTotals
ORDER BY OrderDate, OrderID;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### LAG i LEAD - porównanie z poprzednimi/następnymi wierszami

-- COMMAND ----------

-- Porównaj wartość zamówienia z poprzednim i następnym
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate
)
SELECT
    OrderID,
    OrderDate,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(LAG(OrderValue, 1) OVER (ORDER BY OrderDate, OrderID), 2) AS PreviousOrderValue,
    ROUND(LEAD(OrderValue, 1) OVER (ORDER BY OrderDate, OrderID), 2) AS NextOrderValue,
    ROUND(OrderValue - LAG(OrderValue, 1) OVER (ORDER BY OrderDate, OrderID), 2) AS ChangeFromPrevious
FROM OrderTotals
ORDER BY OrderDate, OrderID;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### FIRST_VALUE i LAST_VALUE

-- COMMAND ----------

-- Porównaj z pierwszą i ostatnią wartością w oknie
WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        o.ShipCountry,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate, o.ShipCountry
)
SELECT
    ShipCountry,
    OrderID,
    OrderDate,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(FIRST_VALUE(OrderValue) OVER (
        PARTITION BY ShipCountry
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ), 2) AS FirstOrderInCountry,
    ROUND(LAST_VALUE(OrderValue) OVER (
        PARTITION BY ShipCountry
        ORDER BY OrderDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ), 2) AS LastOrderInCountry
FROM OrderTotals
ORDER BY ShipCountry, OrderDate;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Zaawansowany przykład: Analiza kohort

-- COMMAND ----------

-- Dla każdego kraju: kiedy było pierwsze zamówienie i jak rosła sprzedaż
WITH CountryOrders AS (
    SELECT
        o.ShipCountry,
        o.OrderDate,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue,
        MIN(o.OrderDate) OVER (PARTITION BY o.ShipCountry) AS FirstOrderDate
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.ShipCountry, o.OrderDate
)
SELECT
    ShipCountry,
    OrderDate,
    FirstOrderDate,
    DATEDIFF(OrderDate, FirstOrderDate) AS DaysSinceFirstOrder,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(SUM(OrderValue) OVER (
        PARTITION BY ShipCountry
        ORDER BY OrderDate
        ROWS UNBOUNDED PRECEDING
    ), 2) AS CumulativeValue
FROM CountryOrders
ORDER BY ShipCountry, OrderDate;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 6. Funkcje Użytkownika (UDF)
-- MAGIC
-- MAGIC Tworzenie własnych funkcji SQL i Python

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### SQL UDF - prosta funkcja

-- COMMAND ----------

-- Funkcja do obliczania ceny z VAT
CREATE OR REPLACE FUNCTION calculate_vat(price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
RETURN price * 1.23;

-- Użycie funkcji
SELECT
    ProductName,
    UnitPrice,
    calculate_vat(UnitPrice) AS PriceWithVAT,
    ROUND(calculate_vat(UnitPrice) - UnitPrice, 2) AS VATAmount
FROM Products
LIMIT 10;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### SQL UDF - funkcja z logiką biznesową

-- COMMAND ----------

-- Funkcja kategoryzująca produkty według ceny
CREATE OR REPLACE FUNCTION price_category(price DECIMAL(10,2))
RETURNS STRING
RETURN CASE
    WHEN price < 10 THEN 'Budget'
    WHEN price < 30 THEN 'Standard'
    WHEN price < 60 THEN 'Premium'
    ELSE 'Luxury'
END;

-- Użycie funkcji
SELECT
    ProductName,
    UnitPrice,
    price_category(UnitPrice) AS Category,
    COUNT(*) OVER (PARTITION BY price_category(UnitPrice)) AS ProductsInCategory
FROM Products
ORDER BY UnitPrice;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### SQL UDF - funkcja do obliczeń rabatów

-- COMMAND ----------

-- Funkcja obliczająca wartość po rabacie
CREATE OR REPLACE FUNCTION apply_discount(price DECIMAL(10,2), discount DECIMAL(3,2))
RETURNS DECIMAL(10,2)
RETURN price * (1 - discount);

-- Użycie w analizie zamówień
SELECT
    o.OrderID,
    p.ProductName,
    od.UnitPrice AS OriginalPrice,
    od.Discount,
    apply_discount(od.UnitPrice, od.Discount) AS FinalPrice,
    od.Quantity,
    ROUND(apply_discount(od.UnitPrice, od.Discount) * od.Quantity, 2) AS LineTotal
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.Discount > 0
ORDER BY o.OrderID
LIMIT 20;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Python UDF - zaawansowane obliczenia

-- COMMAND ----------

-- MAGIC %python
-- MAGIC # Funkcja Python do kategoryzacji produktów na podstawie wielu kryteriów
-- MAGIC from pyspark.sql.functions import udf
-- MAGIC from pyspark.sql.types import StringType
-- MAGIC
-- MAGIC def classify_product(price, stock, discontinued):
-- MAGIC     """
-- MAGIC     Klasyfikuje produkt na podstawie ceny, stanu magazynowego i dostępności
-- MAGIC     """
-- MAGIC     if discontinued:
-- MAGIC         return "Discontinued"
-- MAGIC     elif stock == 0:
-- MAGIC         return "Out of Stock"
-- MAGIC     elif stock < 10:
-- MAGIC         return "Low Stock - " + ("Premium" if price > 50 else "Standard")
-- MAGIC     elif price > 50:
-- MAGIC         return "Premium - In Stock"
-- MAGIC     else:
-- MAGIC         return "Standard - In Stock"
-- MAGIC
-- MAGIC # Rejestracja UDF
-- MAGIC classify_product_udf = udf(classify_product, StringType())
-- MAGIC spark.udf.register("classify_product", classify_product)

-- COMMAND ----------

-- Użycie Python UDF w SQL
SELECT
    ProductName,
    UnitPrice,
    UnitsInStock,
    Discontinued,
    classify_product(UnitPrice, UnitsInStock, Discontinued) AS ProductStatus
FROM Products
ORDER BY
    CASE classify_product(UnitPrice, UnitsInStock, Discontinued)
        WHEN 'Discontinued' THEN 1
        WHEN 'Out of Stock' THEN 2
        WHEN 'Low Stock - Premium' THEN 3
        WHEN 'Low Stock - Standard' THEN 4
        ELSE 5
    END,
    ProductName;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## 7. Optymalizacja i Best Practices

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Przykład ZŁY vs DOBRY

-- COMMAND ----------

-- ❌ ZŁY PRZYKŁAD
-- SELECT *
-- FROM Orders o
-- JOIN OrderDetails od ON o.OrderID = od.OrderID
-- WHERE YEAR(o.OrderDate) = 2023 AND MONTH(o.OrderDate) = 7;

-- ✅ DOBRY PRZYKŁAD
SELECT
    o.OrderID,
    o.CustomerID,
    o.OrderDate,
    od.ProductID,
    od.Quantity,
    od.UnitPrice
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '2023-07-01'
  AND o.OrderDate < '2023-08-01';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Optymalizacja: Z-Ordering w Delta Lake

-- COMMAND ----------

-- Z-Ordering dla często filtrowanych kolumn
-- UWAGA: To polecenie działa tylko na prawdziwych tabelach Delta, nie na tymczasowych

-- Przykład (zakomentowany, bo pracujemy na małych danych):
-- OPTIMIZE Products ZORDER BY (CategoryID, UnitPrice);
-- OPTIMIZE Orders ZORDER BY (OrderDate, CustomerID);

SELECT 'Z-Ordering zakomentowany - użyj na produkcyjnych tabelach Delta' AS Note;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Partycjonowanie tabel

-- COMMAND ----------

-- Przykład tworzenia partycjonowanej tabeli
-- (na produkcji - dla dużych zbiorów danych)

CREATE TABLE IF NOT EXISTS orders_partitioned (
    OrderID INT,
    CustomerID STRING,
    EmployeeID INT,
    OrderDate TIMESTAMP,
    ShipCountry STRING
)
USING DELTA
PARTITIONED BY (ShipCountry);

-- Wstaw przykładowe dane
INSERT INTO orders_partitioned
SELECT * FROM Orders;

-- Query korzystające z partycji (partition pruning)
SELECT COUNT(*)
FROM orders_partitioned
WHERE ShipCountry = 'Germany';

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Time Travel w Delta Lake

-- COMMAND ----------

-- Sprawdź historię zmian tabeli
DESCRIBE HISTORY Products LIMIT 5;

-- COMMAND ----------

-- Przywracanie do poprzedniej wersji (przykład)
-- RESTORE TABLE Products TO VERSION AS OF 0;

-- Zapytanie do konkretnej wersji
-- SELECT * FROM Products VERSION AS OF 0;

-- Zapytanie według timestampu
-- SELECT * FROM Products TIMESTAMP AS OF '2024-01-01';

SELECT 'Time travel commands dostępne w komentarzach powyżej' AS Note;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Vacuum - zarządzanie przestrzenią

-- COMMAND ----------

-- Usuwanie starych wersji plików (starszych niż 7 dni)
-- VACUUM Products RETAIN 168 HOURS;

-- Sprawdź, ile miejsca zajmuje tabela
-- DESCRIBE DETAIL Products;

SELECT 'VACUUM zakomentowany - użyj ostrożnie na produkcji' AS Note;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Podsumowanie
-- MAGIC
-- MAGIC Gratulacje! Przeszedłeś przez wszystkie przykłady demonstracyjne.
-- MAGIC
-- MAGIC **Nauczyłeś się:**
-- MAGIC - ✅ Zaawansowanych funkcji grupowania (ROLLUP, CUBE, GROUPING SETS, PIVOT)
-- MAGIC - ✅ Common Table Expressions (CTE) - podstawowych i rekurencyjnych
-- MAGIC - ✅ Funkcji analitycznych (Window Functions) - ROW_NUMBER, RANK, LAG, LEAD, agregaty
-- MAGIC - ✅ Tworzenia funkcji użytkownika (SQL UDF i Python UDF)
-- MAGIC - ✅ Optymalizacji zapytań i wykorzystania funkcji Delta Lake
-- MAGIC
-- MAGIC **Następne kroki:**
-- MAGIC 1. Przejdź do notebooka z ćwiczeniami i spróbuj rozwiązać zadania samodzielnie
-- MAGIC 2. Eksperymentuj z tym kodem - zmieniaj zapytania, dodawaj własne warunki
-- MAGIC 3. Spróbuj zastosować te techniki na własnych danych
-- MAGIC
-- MAGIC **Pamiętaj:**
-- MAGIC - Dokumentacja jest twoim przyjacielem: docs.databricks.com
-- MAGIC - Praktyka czyni mistrza - im więcej piszesz, tym lepszy się stajesz
-- MAGIC - Zadawaj pytania i dziel się wiedzą z zespołem
-- MAGIC
-- MAGIC Powodzenia! 🚀
