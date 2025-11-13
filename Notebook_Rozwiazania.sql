-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Zaawansowany SQL w Databricks - Rozwiązania Ćwiczeń
-- MAGIC
-- MAGIC Ten notebook zawiera rozwiązania wszystkich ćwiczeń z notebooka praktycznego.
-- MAGIC
-- MAGIC **Uwaga:**
-- MAGIC - Spróbuj najpierw rozwiązać ćwiczenia samodzielnie!
-- MAGIC - Tego notebooka używaj tylko do sprawdzenia swoich rozwiązań
-- MAGIC - Pamiętaj: często jest wiele poprawnych rozwiązań tego samego problemu
-- MAGIC
-- MAGIC **Struktura:**
-- MAGIC - Każde rozwiązanie zawiera pełne zapytanie SQL
-- MAGIC - Wyjaśnienie kluczowych elementów
-- MAGIC - Alternatywne podejścia (gdy istnieją)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Inicjalizacja

-- COMMAND ----------

USE northwind;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 1: Podstawy SQL - Rozgrzewka

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 1.1: Filtrowanie i sortowanie

-- COMMAND ----------

SELECT
    ProductName,
    UnitPrice,
    UnitsInStock
FROM Products
WHERE UnitsInStock > 0
  AND UnitPrice BETWEEN 10 AND 50
  AND Discontinued = false
ORDER BY UnitPrice DESC;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - WHERE łączy trzy warunki używając AND
-- MAGIC - BETWEEN jest wygodniejsze niż >= AND <=
-- MAGIC - ORDER BY DESC sortuje od najdroższych

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 1.2: JOIN i agregacje

-- COMMAND ----------

-- Rozwiązanie z podzapytaniem
SELECT
    c.CategoryName,
    COUNT(*) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    (
        SELECT p2.ProductName
        FROM Products p2
        WHERE p2.CategoryID = c.CategoryID
        ORDER BY p2.UnitPrice DESC
        LIMIT 1
    ) AS MostExpensiveProduct
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY AvgPrice DESC;

-- COMMAND ----------

-- Alternatywne rozwiązanie z window function
WITH RankedProducts AS (
    SELECT
        c.CategoryName,
        p.ProductName,
        p.UnitPrice,
        ROW_NUMBER() OVER (PARTITION BY c.CategoryID ORDER BY p.UnitPrice DESC) AS rn
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    MAX(CASE WHEN rp.rn = 1 THEN rp.ProductName END) AS MostExpensiveProduct
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN RankedProducts rp ON c.CategoryName = rp.CategoryName AND rp.rn = 1
GROUP BY c.CategoryName
ORDER BY AvgPrice DESC;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - Pierwsze rozwiązanie używa skorelowanego podzapytania
-- MAGIC - Drugie rozwiązanie używa window function ROW_NUMBER()
-- MAGIC - Oba podejścia są poprawne, window function jest bardziej skalowalne

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 2: Zaawansowane Funkcje Grupowania

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 2.1: ROLLUP

-- COMMAND ----------

WITH SalesData AS (
    SELECT
        o.ShipCountry,
        MONTH(o.OrderDate) AS Month,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.ShipCountry, MONTH(o.OrderDate)
)
SELECT
    CASE
        WHEN GROUPING(ShipCountry) = 1 THEN 'GRAND TOTAL'
        ELSE ShipCountry
    END AS Country,
    CASE
        WHEN GROUPING(Month) = 1 AND GROUPING(ShipCountry) = 0 THEN 'ALL MONTHS'
        WHEN GROUPING(Month) = 1 THEN ''
        ELSE CAST(Month AS STRING)
    END AS Month,
    ROUND(SUM(TotalSales), 2) AS TotalSales,
    GROUPING_ID(ShipCountry, Month) AS AggLevel
FROM SalesData
GROUP BY ROLLUP(ShipCountry, Month)
ORDER BY
    GROUPING(ShipCountry),
    ShipCountry,
    GROUPING(Month),
    Month;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - ROLLUP tworzy hierarchię: (Country, Month), (Country), ()
-- MAGIC - GROUPING() = 1 oznacza, że kolumna jest agreagowana
-- MAGIC - GROUPING_ID() koduje poziom agregacji jako liczbę
-- MAGIC - Sortowanie zapewnia czytelną kolejność: szczegóły, potem sumy

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 2.2: CUBE

-- COMMAND ----------

SELECT
    CASE
        WHEN GROUPING(c.CategoryName) = 1 AND GROUPING(o.ShipCountry) = 1 THEN 'Grand Total'
        WHEN GROUPING(c.CategoryName) = 1 THEN 'By Country'
        WHEN GROUPING(o.ShipCountry) = 1 THEN 'By Category'
        ELSE 'Detail'
    END AS AggregationLevel,
    COALESCE(c.CategoryName, 'ALL CATEGORIES') AS Category,
    COALESCE(o.ShipCountry, 'ALL COUNTRIES') AS Country,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY CUBE(c.CategoryName, o.ShipCountry)
ORDER BY
    GROUPING_ID(c.CategoryName, o.ShipCountry),
    c.CategoryName,
    o.ShipCountry;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CUBE tworzy WSZYSTKIE możliwe kombinacje: (Cat, Country), (Cat), (Country), ()
-- MAGIC - GROUPING_ID pozwala na łatwe sortowanie według poziomu agregacji
-- MAGIC - COALESCE zastępuje NULL opisowym tekstem
-- MAGIC - CASE WHEN tworzy czytelną nazwę poziomu agregacji

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 2.3: PIVOT

-- COMMAND ----------

SELECT *
FROM (
    SELECT
        o.ShipCountry,
        MONTH(o.OrderDate) AS Month,
        o.OrderID
    FROM Orders o
)
PIVOT (
    COUNT(DISTINCT OrderID)
    FOR Month IN (7 AS July, 8 AS August, 9 AS September)
)
ORDER BY ShipCountry;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - PIVOT przekształca wiersze w kolumny
-- MAGIC - Agregujemy COUNT(DISTINCT OrderID) - liczba zamówień
-- MAGIC - FOR Month IN (...) określa które wartości stają się kolumnami
-- MAGIC - AS July, AS August - aliasy dla czytelności
-- MAGIC - Podzapytanie przygotowuje dane w formacie (Country, Month, OrderID)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 3: Common Table Expressions (CTE)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 3.1: Podstawowe CTE

-- COMMAND ----------

WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName
),
AvgSales AS (
    SELECT AVG(TotalSales) AS AvgAllProducts
    FROM ProductSales
)
SELECT
    ps.ProductName,
    ROUND(ps.TotalSales, 2) AS TotalSales,
    ROUND(av.AvgAllProducts, 2) AS AvgAllProducts,
    ROUND(ps.TotalSales - av.AvgAllProducts, 2) AS DifferenceFromAvg,
    ROUND(100.0 * (ps.TotalSales - av.AvgAllProducts) / av.AvgAllProducts, 1) AS PctDiffFromAvg
FROM ProductSales ps
CROSS JOIN AvgSales av
WHERE ps.TotalSales > av.AvgAllProducts
ORDER BY ps.TotalSales DESC;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CTE #1 (ProductSales): agreguje sprzedaż per produkt
-- MAGIC - CTE #2 (AvgSales): oblicza średnią ze wszystkich produktów
-- MAGIC - CROSS JOIN: każdy wiersz z ProductSales łączymy z jedynym wierszem AvgSales
-- MAGIC - WHERE filtruje tylko produkty powyżej średniej
-- MAGIC - Dodatkowe obliczenie: procent różnicy od średniej

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 3.2: Rekurencyjne CTE - Tabliczka mnożenia

-- COMMAND ----------

WITH RECURSIVE MultiplicationTable AS (
    -- Anchor member: 7 × 1
    SELECT 1 AS n, 7 AS result

    UNION ALL

    -- Recursive member: 7 × (n+1)
    SELECT
        n + 1,
        result + 7
    FROM MultiplicationTable
    WHERE n < 10
)
SELECT
    n,
    result AS Result,
    '7 × ' || CAST(n AS STRING) || ' = ' || CAST(result AS STRING) AS Equation
FROM MultiplicationTable
ORDER BY n;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - Anchor member: punkt startowy (7 × 1 = 7)
-- MAGIC - Recursive member: dodajemy 7 w każdej iteracji (zamiast mnożyć)
-- MAGIC - WHERE n < 10: warunek stopu (generujemy do n=10)
-- MAGIC - Dodatkowa kolumna Equation dla czytelności wyniku

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 3.3: Rekurencyjne CTE - Hierarchia

-- COMMAND ----------

CREATE OR REPLACE TEMP VIEW CategoryHierarchy AS
SELECT 1 as CategoryID, 'All Products' as CategoryName, NULL as ParentCategoryID
UNION ALL SELECT 2, 'Food', 1
UNION ALL SELECT 3, 'Beverages', 1
UNION ALL SELECT 4, 'Soft Drinks', 3
UNION ALL SELECT 5, 'Alcoholic Beverages', 3
UNION ALL SELECT 6, 'Dairy', 2
UNION ALL SELECT 7, 'Cheese', 6;

-- COMMAND ----------

WITH RECURSIVE CategoryTree AS (
    -- Anchor member: kategorie korzenia (bez rodzica)
    SELECT
        CategoryID,
        CategoryName,
        ParentCategoryID,
        0 AS Level,
        CAST(CategoryName AS STRING) AS Path
    FROM CategoryHierarchy
    WHERE ParentCategoryID IS NULL

    UNION ALL

    -- Recursive member: dzieci bieżących węzłów
    SELECT
        ch.CategoryID,
        ch.CategoryName,
        ch.ParentCategoryID,
        ct.Level + 1,
        ct.Path || ' > ' || ch.CategoryName AS Path
    FROM CategoryHierarchy ch
    INNER JOIN CategoryTree ct ON ch.ParentCategoryID = ct.CategoryID
)
SELECT
    REPEAT('  ', Level) || CategoryName AS CategoryIndented,
    Level,
    Path
FROM CategoryTree
ORDER BY Path;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - Anchor: zaczynamy od kategorii bez rodzica (ParentCategoryID IS NULL)
-- MAGIC - Recursive: dołączamy dzieci (ch.ParentCategoryID = ct.CategoryID)
-- MAGIC - Level: inkrementujemy w każdej iteracji (ct.Level + 1)
-- MAGIC - Path: budujemy konkatenując: parent_path + ' > ' + current_name
-- MAGIC - REPEAT('  ', Level): wcięcia dla wizualizacji poziomu
-- MAGIC - ORDER BY Path: sortuje alfabetycznie, zachowując hierarchię

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 4: Funkcje Analityczne (Window Functions)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 4.1: Top N per group

-- COMMAND ----------

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
WHERE PriceRank <= 2
ORDER BY CategoryName, PriceRank;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - ROW_NUMBER() nadaje unikalny numer w ramach każdej partycji
-- MAGIC - PARTITION BY CategoryName: osobne numerowanie dla każdej kategorii
-- MAGIC - ORDER BY UnitPrice DESC: od najdroższego
-- MAGIC - WHERE PriceRank <= 2: filtrujemy top 2
-- MAGIC - Wzorzec "Top N per group" to jedno z najczęstszych zastosowań window functions

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 4.2: Porównanie z średnią

-- COMMAND ----------

SELECT
    p.ProductName,
    p.UnitPrice,
    ROUND(AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID), 2) AS AvgInCategory,
    ROUND(p.UnitPrice - AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID), 2) AS DiffFromAvg,
    ROUND(100.0 * (p.UnitPrice - AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID)) /
          AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID), 1) AS PctDiffFromAvg,
    CASE
        WHEN p.UnitPrice > AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Status
FROM Products p
ORDER BY p.CategoryID, p.UnitPrice DESC;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - AVG() OVER (PARTITION BY CategoryID): średnia per kategoria
-- MAGIC - Window function nie grupuje - zachowujemy wszystkie wiersze!
-- MAGIC - Powtarzamy AVG() OVER w każdym obliczeniu (lub użyj CTE dla optymalizacji)
-- MAGIC - CASE WHEN porównuje z tą samą window function
-- MAGIC - To pokazuje moc window functions: agregaty BEZ GROUP BY

-- COMMAND ----------

-- Alternatywne rozwiązanie z CTE (bardziej wydajne):
WITH ProductsWithAvg AS (
    SELECT
        p.ProductName,
        p.UnitPrice,
        p.CategoryID,
        AVG(p.UnitPrice) OVER (PARTITION BY p.CategoryID) AS AvgInCategory
    FROM Products p
)
SELECT
    ProductName,
    UnitPrice,
    ROUND(AvgInCategory, 2) AS AvgInCategory,
    ROUND(UnitPrice - AvgInCategory, 2) AS DiffFromAvg,
    ROUND(100.0 * (UnitPrice - AvgInCategory) / AvgInCategory, 1) AS PctDiffFromAvg,
    CASE
        WHEN UnitPrice > AvgInCategory THEN 'Above Average'
        ELSE 'Below Average'
    END AS Status
FROM ProductsWithAvg
ORDER BY CategoryID, UnitPrice DESC;

-- MAGIC %md
-- MAGIC **Uwaga:** Drugie rozwiązanie z CTE oblicza AVG() tylko raz, co jest bardziej wydajne

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 4.3: Suma bieżąca i średnia krocząca

-- COMMAND ----------

WITH OrderValues AS (
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
    ROUND(SUM(OrderValue) OVER (
        ORDER BY OrderDate, OrderID
        ROWS UNBOUNDED PRECEDING
    ), 2) AS RunningTotal,
    ROUND(AVG(OrderValue) OVER (
        ORDER BY OrderDate, OrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS MovingAvg3
FROM OrderValues
ORDER BY OrderDate, OrderID;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CTE agreguje wartość każdego zamówienia
-- MAGIC - **RunningTotal:** SUM() z ROWS UNBOUNDED PRECEDING = od początku do bieżącego wiersza
-- MAGIC - **MovingAvg3:** AVG() z ROWS BETWEEN 2 PRECEDING AND CURRENT ROW = 3 wiersze (2 przed + bieżący)
-- MAGIC - ORDER BY w OVER: określa kolejność okna (chronologicznie)
-- MAGIC - ROWS: ramka okna oparta na wierszach (alternatywa: RANGE oparta na wartościach)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 4.4: LAG/LEAD - analiza trendów

-- COMMAND ----------

WITH MonthlySales AS (
    SELECT
        c.CategoryName,
        YEAR(o.OrderDate) AS Year,
        MONTH(o.OrderDate) AS Month,
        SUM(od.Quantity * od.UnitPrice) AS Sales
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY c.CategoryName, YEAR(o.OrderDate), MONTH(o.OrderDate)
),
SalesWithLag AS (
    SELECT
        CategoryName,
        Year,
        Month,
        Sales AS CurrentMonthSales,
        LAG(Sales, 1) OVER (
            PARTITION BY CategoryName
            ORDER BY Year, Month
        ) AS PreviousMonthSales
    FROM MonthlySales
)
SELECT
    CategoryName,
    Year,
    Month,
    ROUND(CurrentMonthSales, 2) AS CurrentMonthSales,
    ROUND(PreviousMonthSales, 2) AS PreviousMonthSales,
    ROUND(CurrentMonthSales - COALESCE(PreviousMonthSales, CurrentMonthSales), 2) AS MoMChange,
    ROUND(100.0 * (CurrentMonthSales - COALESCE(PreviousMonthSales, CurrentMonthSales)) /
          COALESCE(PreviousMonthSales, CurrentMonthSales), 1) AS MoMChangePct,
    CASE
        WHEN PreviousMonthSales IS NULL THEN 'First Month'
        WHEN 100.0 * (CurrentMonthSales - PreviousMonthSales) / PreviousMonthSales > 10 THEN 'Growing'
        WHEN 100.0 * (CurrentMonthSales - PreviousMonthSales) / PreviousMonthSales < -10 THEN 'Declining'
        ELSE 'Stable'
    END AS Trend
FROM SalesWithLag
ORDER BY CategoryName, Year, Month;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CTE #1: agregacja sprzedaży miesięcznej per kategoria
-- MAGIC - CTE #2: LAG(Sales, 1) pobiera wartość z poprzedniego wiersza
-- MAGIC   - PARTITION BY CategoryName: osobne "poprzednie" dla każdej kategorii
-- MAGIC   - ORDER BY Year, Month: chronologicznie
-- MAGIC - LAG zwraca NULL dla pierwszego wiersza w partycji
-- MAGIC - COALESCE obsługuje NULL (pierwszy miesiąc)
-- MAGIC - CASE WHEN klasyfikuje trend na podstawie % zmiany
-- MAGIC - To typowa analiza MoM (Month-over-Month) w BI

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 4.5: NTILE - kwartyle

-- COMMAND ----------

WITH ProductQuartiles AS (
    SELECT
        ProductName,
        UnitPrice,
        NTILE(4) OVER (ORDER BY UnitPrice) AS Quartile
    FROM Products
),
QuartileStats AS (
    SELECT
        Quartile,
        MIN(UnitPrice) AS MinPrice,
        MAX(UnitPrice) AS MaxPrice
    FROM ProductQuartiles
    GROUP BY Quartile
)
SELECT
    pq.ProductName,
    pq.UnitPrice,
    pq.Quartile,
    ROUND(qs.MinPrice, 2) AS QuartileMin,
    ROUND(qs.MaxPrice, 2) AS QuartileMax,
    CASE pq.Quartile
        WHEN 1 THEN 'Bottom 25%'
        WHEN 2 THEN '25-50%'
        WHEN 3 THEN '50-75%'
        WHEN 4 THEN 'Top 25%'
    END AS Description
FROM ProductQuartiles pq
JOIN QuartileStats qs ON pq.Quartile = qs.Quartile
ORDER BY pq.Quartile, pq.UnitPrice;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - NTILE(4): dzieli dane na 4 równe grupy
-- MAGIC - ORDER BY UnitPrice: podział według ceny
-- MAGIC - CTE #1: przypisanie kwartyla każdemu produktowi
-- MAGIC - CTE #2: obliczenie min/max dla każdego kwartyla
-- MAGIC - JOIN łączy informacje
-- MAGIC - NTILE jest świetne do tworzenia percentyli, kwartyli, decyli

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 5: Funkcje Użytkownika (UDF)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 5.1: Prosta SQL UDF

-- COMMAND ----------

-- Tworzenie funkcji
CREATE OR REPLACE FUNCTION calculate_margin(cost DECIMAL(10,2), price DECIMAL(10,2))
RETURNS DECIMAL(10,4)
RETURN ((price - cost) / cost) * 100;

-- COMMAND ----------

-- Użycie funkcji
SELECT
    ProductName,
    ROUND(UnitPrice * 0.6, 2) AS Cost,
    UnitPrice AS Price,
    ROUND(calculate_margin(UnitPrice * 0.6, UnitPrice), 1) AS MarginPct
FROM Products
WHERE calculate_margin(UnitPrice * 0.6, UnitPrice) > 50
ORDER BY MarginPct DESC;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CREATE FUNCTION: definiuje funkcję SQL
-- MAGIC - Parametry: cost i price jako DECIMAL
-- MAGIC - RETURNS: typ zwracany
-- MAGIC - RETURN: wzór obliczeniowy (marża = (cena-koszt)/koszt * 100)
-- MAGIC - Funkcja może być używana w SELECT, WHERE, ORDER BY
-- MAGIC - Marża 66.67% wynika z: (100-60)/60 * 100 = 66.67%

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 5.2: SQL UDF z logiką biznesową

-- COMMAND ----------

-- Tworzenie funkcji
CREATE OR REPLACE FUNCTION stock_status(
    units_in_stock INT,
    reorder_level INT,
    discontinued BOOLEAN
)
RETURNS STRING
RETURN CASE
    WHEN discontinued THEN 'Discontinued'
    WHEN units_in_stock < reorder_level THEN 'Critical - Reorder Now'
    WHEN units_in_stock < reorder_level * 2 THEN 'Low Stock'
    ELSE 'Adequate'
END;

-- COMMAND ----------

-- Użycie funkcji
SELECT
    ProductName,
    UnitsInStock,
    ReorderLevel,
    Discontinued,
    stock_status(UnitsInStock, ReorderLevel, Discontinued) AS Status,
    -- Dodatkowe: liczba produktów w każdym statusie
    COUNT(*) OVER (
        PARTITION BY stock_status(UnitsInStock, ReorderLevel, Discontinued)
    ) AS ProductsWithSameStatus
FROM Products
ORDER BY
    CASE stock_status(UnitsInStock, ReorderLevel, Discontinued)
        WHEN 'Discontinued' THEN 1
        WHEN 'Critical - Reorder Now' THEN 2
        WHEN 'Low Stock' THEN 3
        ELSE 4
    END,
    ProductName;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - Funkcja enkapsuluje logikę biznesową klasyfikacji produktów
-- MAGIC - Zagnieżdżone CASE WHEN: sprawdza warunki od najbardziej krytycznych
-- MAGIC - Funkcja używana wielokrotnie: w SELECT, window function, ORDER BY
-- MAGIC - Zamiast powtarzać CASE WHEN w wielu miejscach - jedna funkcja
-- MAGIC - To promuje reużywalność i konsystencję

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 6: Zadania Integracyjne

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 6.1: Dashboard sprzedażowy

-- COMMAND ----------

WITH ProductSales AS (
    -- CTE #1: Sprzedaż każdego produktu
    SELECT
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        c.CategoryName,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY p.ProductID, p.ProductName, p.CategoryID, c.CategoryName
),
CategoryRanking AS (
    -- CTE #2: Ranking produktów w kategorii + statystyki kategorii
    SELECT
        ProductName,
        CategoryName,
        TotalSales,
        -- Ranking w kategorii
        ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY TotalSales DESC) AS RankInCategory,
        -- Sprzedaż całej kategorii
        SUM(TotalSales) OVER (PARTITION BY CategoryID) AS CategoryTotalSales,
        -- Średnia w kategorii
        AVG(TotalSales) OVER (PARTITION BY CategoryID) AS CategoryAvgSales,
        -- Liczba produktów w kategorii
        COUNT(*) OVER (PARTITION BY CategoryID) AS ProductsInCategory
    FROM ProductSales
),
TopProducts AS (
    -- CTE #3: Top 3 produkty w każdej kategorii
    SELECT *
    FROM CategoryRanking
    WHERE RankInCategory <= 3
)
SELECT
    CategoryName,
    ProductName,
    RankInCategory,
    ROUND(TotalSales, 2) AS ProductSales,
    ROUND(CategoryTotalSales, 2) AS CategoryTotalSales,
    ROUND(100.0 * TotalSales / CategoryTotalSales, 1) AS PctOfCategorySales,
    ROUND(CategoryAvgSales, 2) AS AvgSalesInCategory,
    ROUND(TotalSales - CategoryAvgSales, 2) AS DiffFromAvg,
    ProductsInCategory
FROM TopProducts
ORDER BY CategoryName, RankInCategory;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - CTE #1: Podstawowa agregacja sprzedaży
-- MAGIC - CTE #2: Window functions dla rankingu i statystyk
-- MAGIC   - ROW_NUMBER(): ranking
-- MAGIC   - SUM(), AVG(), COUNT() jako window functions: statystyki kategorii
-- MAGIC - CTE #3: Filtrowanie top 3
-- MAGIC - Finalny SELECT: obliczenia pochodne (%, różnice)
-- MAGIC - Pokazuje moc łączenia CTE + window functions dla złożonych analiz

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 6.2: Analiza kohort klientów

-- COMMAND ----------

WITH CustomerOrders AS (
    SELECT
        o.OrderID,
        o.OrderDate,
        o.ShipCountry,
        SUM(od.Quantity * od.UnitPrice) AS OrderValue,
        -- Data pierwszego zamówienia dla kraju
        MIN(o.OrderDate) OVER (PARTITION BY o.ShipCountry) AS FirstOrderDate
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate, o.ShipCountry
),
CohorAnalysis AS (
    SELECT
        ShipCountry,
        OrderID,
        OrderDate,
        FirstOrderDate,
        DATEDIFF(OrderDate, FirstOrderDate) AS DaysSinceFirst,
        OrderValue,
        -- Skumulowana wartość zamówień
        SUM(OrderValue) OVER (
            PARTITION BY ShipCountry
            ORDER BY OrderDate, OrderID
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeValue,
        -- Liczba zamówień do tej pory
        ROW_NUMBER() OVER (
            PARTITION BY ShipCountry
            ORDER BY OrderDate, OrderID
        ) AS OrderNumber,
        -- Średnia wartość zamówienia do tej pory
        AVG(OrderValue) OVER (
            PARTITION BY ShipCountry
            ORDER BY OrderDate, OrderID
            ROWS UNBOUNDED PRECEDING
        ) AS AvgOrderValueToDate
    FROM CustomerOrders
)
SELECT
    ShipCountry,
    OrderID,
    OrderDate,
    FirstOrderDate,
    DaysSinceFirst,
    ROUND(OrderValue, 2) AS OrderValue,
    ROUND(CumulativeValue, 2) AS CumulativeValue,
    OrderNumber,
    ROUND(AvgOrderValueToDate, 2) AS AvgOrderValueToDate
FROM CohorAnalysis
ORDER BY ShipCountry, OrderDate, OrderID;

-- MAGIC %md
-- MAGIC **Wyjaśnienie:**
-- MAGIC - MIN() OVER (PARTITION BY Country): pierwsza data zamówienia per kraj
-- MAGIC - DATEDIFF: ile dni od pierwszego zamówienia
-- MAGIC - SUM() z ROWS UNBOUNDED PRECEDING: skumulowana wartość
-- MAGIC - ROW_NUMBER(): numer zamówienia w sekwencji
-- MAGIC - AVG() z ROWS UNBOUNDED PRECEDING: średnia do tej pory
-- MAGIC - Analiza kohort pokazuje jak rośnie wartość życiowa klienta (LTV)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Rozwiązanie 6.3: Optymalizacja zapytania

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Analiza problemów w oryginalnym zapytaniu:**
-- MAGIC
-- MAGIC 1. **SELECT *** - Pobiera wszystkie kolumny, ale GROUP BY wymaga konkretnych
-- MAGIC 2. **YEAR(OrderDate) i MONTH(OrderDate) w WHERE** - Funkcje na kolumnach uniemożliwiają użycie indeksów
-- MAGIC 3. **UPPER(CategoryName) LIKE '%BEV%'** - UPPER() blokuje indeks, LIKE z % na początku też
-- MAGIC 4. **HAVING SUM(...) > 0** - Zbędny warunek (sumy są zawsze >= 0 chyba że ujemne wartości)
-- MAGIC 5. **Brak specyfikacji kolumn w SELECT** - Conflict z GROUP BY
-- MAGIC 6. **Powtarzanie SUM() w ORDER BY** - Można użyć aliasu

-- COMMAND ----------

-- ✅ ZOPTYMALIZOWANE ZAPYTANIE:

-- Lepsze podejście do tego samego problemu
SELECT
    o.CustomerID,
    c.CategoryName,
    o.ShipCountry,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE
    -- Zamiast YEAR() i MONTH() - użyj zakresu dat
    o.OrderDate >= '2023-07-01'
    AND o.OrderDate < '2023-10-01'
    -- Zamiast UPPER() LIKE - dokładne porównanie (jeśli znamy wartości)
    AND c.CategoryName = 'Beverages'
    -- Lub jeśli naprawdę potrzebujemy LIKE, bez UPPER (zakładając że dane są konsystentne):
    -- AND c.CategoryName LIKE 'Bev%'  -- % tylko na końcu
GROUP BY o.CustomerID, c.CategoryName, o.ShipCountry
-- Usunięcie zbędnego HAVING
ORDER BY TotalSales DESC;

-- MAGIC %md
-- MAGIC **Zmiany i uzasadnienie:**
-- MAGIC
-- MAGIC 1. ✅ **Konkretne kolumny w SELECT** - pasują do GROUP BY
-- MAGIC 2. ✅ **Zakres dat zamiast YEAR()/MONTH()** - może użyć indeksu na OrderDate
-- MAGIC 3. ✅ **Dokładne porównanie zamiast UPPER() LIKE** - może użyć indeksu
-- MAGIC 4. ✅ **Usunięcie HAVING** - zbędny warunek
-- MAGIC 5. ✅ **Alias w ORDER BY** - bardziej czytelne

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Propozycje optymalizacji strukturalnej:**

-- COMMAND ----------

-- Partycjonowanie tabeli Orders według daty
-- (dla dużych tabel - znaczna poprawa wydajności dla zapytań z filtrem daty)

-- CREATE TABLE orders_optimized (
--     OrderID INT,
--     CustomerID STRING,
--     EmployeeID INT,
--     OrderDate TIMESTAMP,
--     ShipCountry STRING
-- )
-- USING DELTA
-- PARTITIONED BY (YEAR(OrderDate), MONTH(OrderDate));

-- Z-Ordering dla często filtrowanych kolumn
-- (Delta Lake optymalizacja - grupuje podobne wartości)

-- OPTIMIZE Orders ZORDER BY (OrderDate, CustomerID);
-- OPTIMIZE Products ZORDER BY (CategoryID);
-- OPTIMIZE OrderDetails ZORDER BY (OrderID, ProductID);

-- Dla bardzo dużych tabel - rozważ Liquid Clustering (nowsza funkcja Databricks)
-- ALTER TABLE Orders CLUSTER BY (OrderDate, CustomerID);

SELECT 'Propozycje optymalizacji w komentarzach powyżej' AS Note;

-- MAGIC %md
-- MAGIC **Dodatkowe wskazówki:**
-- MAGIC - Dla zapytań na zakresach dat: partycjonowanie po dacie
-- MAGIC - Dla często filtrowanych kolumn: Z-ordering
-- MAGIC - Regularnie uruchamiaj OPTIMIZE i VACUUM
-- MAGIC - Używaj ANALYZE TABLE do aktualizacji statystyk
-- MAGIC - Monitoruj query plans (EXPLAIN) do identyfikacji wąskich gardeł

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Bonus: Zadanie Finałowe - Przykładowe rozwiązanie

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Kompleksowy raport sprzedażowy dla dyrekcji

-- COMMAND ----------

-- Definiujemy UDF do klasyfikacji produktów
CREATE OR REPLACE FUNCTION product_performance(sales DECIMAL(10,2), avg_sales DECIMAL(10,2))
RETURNS STRING
RETURN CASE
    WHEN sales > avg_sales * 1.5 THEN 'Star Product'
    WHEN sales > avg_sales THEN 'Above Average'
    WHEN sales > avg_sales * 0.5 THEN 'Below Average'
    ELSE 'Underperforming'
END;

-- COMMAND ----------

-- Główny raport
WITH ProductSales AS (
    -- CTE #1: Podstawowa agregacja sprzedaży produktów
    SELECT
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        c.CategoryName,
        p.UnitsInStock,
        p.Discontinued,
        o.ShipCountry,
        MONTH(o.OrderDate) AS Month,
        SUM(od.Quantity * od.UnitPrice) AS Sales,
        SUM(od.Quantity) AS Quantity
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY
        p.ProductID, p.ProductName, p.CategoryID, c.CategoryName,
        p.UnitsInStock, p.Discontinued, o.ShipCountry, MONTH(o.OrderDate)
),
ProductMetrics AS (
    -- CTE #2: Metryki produktowe z window functions
    SELECT
        ProductName,
        CategoryName,
        ShipCountry,
        Month,
        Sales,
        Quantity,
        UnitsInStock,
        Discontinued,
        -- Trend sprzedażowy (porównanie z poprzednim miesiącem)
        LAG(Sales, 1) OVER (
            PARTITION BY ProductName, ShipCountry
            ORDER BY Month
        ) AS PrevMonthSales,
        -- Suma bieżąca sprzedaży
        SUM(Sales) OVER (
            PARTITION BY ProductName, ShipCountry
            ORDER BY Month
            ROWS UNBOUNDED PRECEDING
        ) AS CumulativeSales,
        -- Średnia sprzedaż produktu
        AVG(Sales) OVER (PARTITION BY ProductName) AS AvgProductSales,
        -- Ranking produktu w kategorii
        RANK() OVER (
            PARTITION BY CategoryName
            ORDER BY SUM(Sales) OVER (PARTITION BY ProductName) DESC
        ) AS CategoryRank
    FROM ProductSales
),
CountryMetrics AS (
    -- CTE #3: Metryki według kraju
    SELECT
        ShipCountry,
        Month,
        SUM(Sales) AS CountrySales,
        RANK() OVER (ORDER BY SUM(Sales) DESC) AS CountryRank,
        -- Wzrost MoM dla kraju
        LAG(SUM(Sales), 1) OVER (
            PARTITION BY ShipCountry
            ORDER BY Month
        ) AS PrevMonthCountrySales
    FROM ProductSales
    GROUP BY ShipCountry, Month
),
ProductRecommendations AS (
    -- CTE #4: Rekomendacje produktowe
    SELECT DISTINCT
        ProductName,
        CategoryName,
        MAX(UnitsInStock) AS UnitsInStock,
        MAX(Discontinued) AS Discontinued,
        SUM(Sales) OVER (PARTITION BY ProductName) AS TotalSales,
        AVG(Sales) OVER () AS OverallAvgSales,
        CASE
            -- Produkty do wycofania: niska sprzedaż + duże zapasy
            WHEN SUM(Sales) OVER (PARTITION BY ProductName) < AVG(Sales) OVER () * 0.3
                 AND MAX(UnitsInStock) > 50
            THEN 'Consider Discontinuing'
            -- Produkty gwiazdki: wysoka sprzedaż
            WHEN SUM(Sales) OVER (PARTITION BY ProductName) > AVG(Sales) OVER () * 1.5
            THEN 'Star Product - Increase Stock'
            ELSE 'Standard'
        END AS Recommendation
    FROM ProductSales
),
SummaryByCategory AS (
    -- CTE #5: Podsumowanie wielopoziomowe z ROLLUP
    SELECT
        COALESCE(CategoryName, 'TOTAL ALL CATEGORIES') AS Category,
        COALESCE(ShipCountry, 'ALL COUNTRIES') AS Country,
        ROUND(SUM(Sales), 2) AS TotalSales,
        SUM(Quantity) AS TotalQuantity,
        GROUPING_ID(CategoryName, ShipCountry) AS AggLevel
    FROM ProductSales
    GROUP BY ROLLUP(CategoryName, ShipCountry)
)

-- Finalny raport - łączymy wszystkie insights
SELECT
    '=== TOP PRODUCTS BY REVENUE ===' AS Section,
    NULL AS CategoryName,
    NULL AS ProductName,
    NULL AS Country,
    NULL AS Month,
    NULL AS Sales,
    NULL AS Trend,
    NULL AS Recommendation
UNION ALL
SELECT
    '',
    pm.CategoryName,
    pm.ProductName,
    pm.ShipCountry,
    CAST(pm.Month AS STRING),
    ROUND(pm.Sales, 2),
    CASE
        WHEN pm.PrevMonthSales IS NULL THEN 'First Month'
        WHEN pm.Sales > pm.PrevMonthSales * 1.1 THEN '↑ Growing'
        WHEN pm.Sales < pm.PrevMonthSales * 0.9 THEN '↓ Declining'
        ELSE '→ Stable'
    END,
    product_performance(pm.Sales, pm.AvgProductSales)
FROM ProductMetrics pm
WHERE pm.CategoryRank <= 5
UNION ALL
SELECT
    '=== COUNTRY PERFORMANCE ===' AS Section,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL
SELECT
    '',
    NULL,
    NULL,
    cm.ShipCountry,
    CAST(cm.Month AS STRING),
    ROUND(cm.CountrySales, 2),
    CASE
        WHEN cm.PrevMonthCountrySales IS NULL THEN 'First Month'
        WHEN cm.CountrySales > cm.PrevMonthCountrySales * 1.1 THEN '↑ Growing'
        WHEN cm.CountrySales < cm.PrevMonthCountrySales * 0.9 THEN '↓ Declining'
        ELSE '→ Stable'
    END,
    CONCAT('Rank #', CAST(cm.CountryRank AS STRING))
FROM CountryMetrics cm
UNION ALL
SELECT
    '=== PRODUCT RECOMMENDATIONS ===' AS Section,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL
UNION ALL
SELECT
    '',
    pr.CategoryName,
    pr.ProductName,
    NULL,
    NULL,
    ROUND(pr.TotalSales, 2),
    CONCAT('Stock: ', CAST(pr.UnitsInStock AS STRING)),
    pr.Recommendation
FROM ProductRecommendations pr
WHERE pr.Recommendation != 'Standard'
ORDER BY Section DESC, Sales DESC NULLS LAST;

-- MAGIC %md
-- MAGIC **Wyjaśnienie rozwiązania:**
-- MAGIC
-- MAGIC Raport odpowiada na wszystkie 4 pytania dyrekcji:
-- MAGIC
-- MAGIC **1. Które produkty generują największy przychód i trendy?**
-- MAGIC - ProductMetrics CTE: agregacja sprzedaży, LAG() do porównania MoM
-- MAGIC - RANK() dla rankingu w kategorii
-- MAGIC - Klasyfikacja trendu: rosnący (>10%), spadkowy (<-10%), stabilny
-- MAGIC
-- MAGIC **2. Które kraje są najważniejszymi rynkami?**
-- MAGIC - CountryMetrics CTE: agregacja per kraj
-- MAGIC - RANK() dla rankingu krajów
-- MAGIC - Analiza wzrostu MoM
-- MAGIC
-- MAGIC **3. Produkty do wycofania?**
-- MAGIC - ProductRecommendations CTE: identyfikuje produkty z niską sprzedażą + wysokimi zapasami
-- MAGIC - Używa UDF product_performance() do klasyfikacji
-- MAGIC
-- MAGIC **4. Wzorce sezonowości?**
-- MAGIC - Analiza miesięczna (Month) we wszystkich CTE
-- MAGIC - Porównania MoM pokazują wzorce czasowe
-- MAGIC
-- MAGIC **Użyte techniki:**
-- MAGIC - ✅ CTE (5 poziomów)
-- MAGIC - ✅ Window Functions (LAG, SUM, AVG, RANK)
-- MAGIC - ✅ ROLLUP (SummaryByCategory)
-- MAGIC - ✅ UDF (product_performance)
-- MAGIC - ✅ Dobre formatowanie i komentarze

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Podsumowanie
-- MAGIC
-- MAGIC Gratulacje! Przeszedłeś przez wszystkie rozwiązania.
-- MAGIC
-- MAGIC **Kluczowe wnioski:**
-- MAGIC - Często istnieje wiele poprawnych rozwiązań tego samego problemu
-- MAGIC - CTE poprawiają czytelność złożonych zapytań
-- MAGIC - Window functions to potężne narzędzie do analityki
-- MAGIC - Optymalizacja to nie tylko poprawne zapytanie, ale też struktura danych
-- MAGIC - Dobre praktyki (formatowanie, komentarze, nazwy) są równie ważne jak poprawność
-- MAGIC
-- MAGIC **Dalsze kroki:**
-- MAGIC - Porównaj swoje rozwiązania z tymi przykładami
-- MAGIC - Jeśli rozwiązałeś inaczej - świetnie! Przemyśl, które podejście jest bardziej wydajne/czytelne
-- MAGIC - Spróbuj zastosować te wzorce na własnych danych
-- MAGIC - Eksperymentuj i ucz się!
-- MAGIC
-- MAGIC Powodzenia! 🎉
