-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Zaawansowany SQL w Databricks - Ćwiczenia Praktyczne
-- MAGIC
-- MAGIC Ten notebook zawiera ćwiczenia do samodzielnego rozwiązania.
-- MAGIC
-- MAGIC **Instrukcja:**
-- MAGIC 1. Uruchom sekcję inicjalizacji bazy danych (jeśli jeszcze nie została zainicjalizowana)
-- MAGIC 2. Dla każdego ćwiczenia:
-- MAGIC    - Przeczytaj uważnie polecenie
-- MAGIC    - Napisz zapytanie SQL w przeznaczonej komórce
-- MAGIC    - Uruchom i sprawdź wynik
-- MAGIC    - Porównaj z oczekiwanym wynikiem (jeśli podano)
-- MAGIC 3. Jeśli utkniesz - zajrzyj do notatek ze szkolenia lub notebooka demonstracyjnego
-- MAGIC
-- MAGIC **Poziomy trudności:**
-- MAGIC - 🟢 Łatwy - podstawowe zastosowanie poznanej techniki
-- MAGIC - 🟡 Średni - wymaga połączenia kilku koncepcji
-- MAGIC - 🔴 Trudny - zaawansowane, wymaga przemyślenia

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Inicjalizacja Bazy Danych
-- MAGIC
-- MAGIC Upewnij się, że baza Northwind jest zainicjalizowana. Jeśli nie, uruchom poniższe komórki.

-- COMMAND ----------

USE northwind;

-- Sprawdź czy tabele istnieją
SHOW TABLES;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 1: Podstawy SQL - Rozgrzewka
-- MAGIC
-- MAGIC Zanim przejdziemy do zaawansowanych technik, szybka rozgrzewka z podstaw.

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 1.1: Filtrowanie i sortowanie 🟢
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Wyświetl wszystkie produkty, które:
-- MAGIC - Są na stanie (UnitsInStock > 0)
-- MAGIC - Kosztują między 10 a 50
-- MAGIC - Nie są wycofane (Discontinued = false)
-- MAGIC
-- MAGIC Posortuj wyniki według ceny malejąco.
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** ProductName, UnitPrice, UnitsInStock

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 1.2: JOIN i agregacje 🟢
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Dla każdej kategorii wyświetl:
-- MAGIC - Nazwę kategorii
-- MAGIC - Liczbę produktów w kategorii
-- MAGIC - Średnią cenę produktów w kategorii (zaokrągloną do 2 miejsc)
-- MAGIC - Nazwę najdroższego produktu w kategorii
-- MAGIC
-- MAGIC Posortuj według średniej ceny malejąco.
-- MAGIC
-- MAGIC **Wskazówka:** Użyj JOIN, GROUP BY, podz zapytania lub window function dla najdroższego produktu

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 2: Zaawansowane Funkcje Grupowania

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 2.1: ROLLUP 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz raport sprzedaży według kraju i miesiąca z sumami częściowymi:
-- MAGIC - Wartość sprzedaży dla każdej kombinacji kraj + miesiąc
-- MAGIC - Suma dla każdego kraju (wszystkie miesiące)
-- MAGIC - Suma całkowita (wszystkie kraje i miesiące)
-- MAGIC
-- MAGIC Użyj ROLLUP i funkcji GROUPING do wyraźnego oznaczenia poziomów agregacji.
-- MAGIC
-- MAGIC **Oczekiwane kolumny:**
-- MAGIC - ShipCountry (z oznaczeniem 'TOTAL' dla sum)
-- MAGIC - Month (z oznaczeniem 'ALL MONTHS' dla sum)
-- MAGIC - TotalSales
-- MAGIC
-- MAGIC **Wskazówka:** Użyj CASE WHEN GROUPING(...) = 1 do formatowania

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 2.2: CUBE 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz wielowymiarową analizę sprzedaży według kategorii produktu i kraju dostawy.
-- MAGIC Wyświetl WSZYSTKIE możliwe kombinacje sum (CUBE).
-- MAGIC
-- MAGIC Dodaj kolumnę AggregationLevel która wyraźnie wskazuje poziom agregacji:
-- MAGIC - 'Detail' dla szczegółów (kategoria + kraj)
-- MAGIC - 'By Category' dla sumy per kategoria
-- MAGIC - 'By Country' dla sumy per kraj
-- MAGIC - 'Grand Total' dla sumy całkowitej
-- MAGIC
-- MAGIC **Wskazówka:** Użyj GROUPING_ID() lub kombinacji GROUPING() dla obu kolumn

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 2.3: PIVOT 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz raport pokazujący liczbę zamówień według kraju (wiersze) i miesiąca (kolumny).
-- MAGIC
-- MAGIC Format:
-- MAGIC ```
-- MAGIC Country  | July | August | September
-- MAGIC ---------|------|--------|----------
-- MAGIC Germany  |  3   |   1    |    2
-- MAGIC France   |  2   |   1    |    1
-- MAGIC ...
-- MAGIC ```
-- MAGIC
-- MAGIC **Wskazówka:** Użyj PIVOT z COUNT(DISTINCT OrderID)

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 3: Common Table Expressions (CTE)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 3.1: Podstawowe CTE 🟢
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Użyj CTE do znalezienia produktów, które sprzedały się powyżej średniej dla wszystkich produktów.
-- MAGIC
-- MAGIC Kroki:
-- MAGIC 1. CTE #1: Oblicz sprzedaż dla każdego produktu (SUM(Quantity * UnitPrice))
-- MAGIC 2. CTE #2: Oblicz średnią sprzedaż wszystkich produktów
-- MAGIC 3. Finalny SELECT: Produkty ze sprzedażą > średnia
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** ProductName, TotalSales, AvgAllProducts, DifferenceFromAvg

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 3.2: Rekurencyjne CTE - Liczby 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Użyj rekurencyjnego CTE do wygenerowania tabliczki mnożenia dla liczby 7 (od 7×1 do 7×10).
-- MAGIC
-- MAGIC **Oczekiwany wynik:**
-- MAGIC ```
-- MAGIC n  | result
-- MAGIC ---|-------
-- MAGIC 1  | 7
-- MAGIC 2  | 14
-- MAGIC 3  | 21
-- MAGIC ...
-- MAGIC 10 | 70
-- MAGIC ```
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - Anchor member: SELECT 1 AS n, 7 AS result
-- MAGIC - Recursive member: n + 1, result + 7
-- MAGIC - Warunek stopu: WHERE n < 10

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 3.3: Rekurencyjne CTE - Hierarchia 🔴
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz hierarchiczną strukturę kategorii i użyj rekurencyjnego CTE do jej analizy.
-- MAGIC
-- MAGIC Krok 1: Stwórz tabelę pomocniczą z hierarchią kategorii:
-- MAGIC
-- MAGIC ```sql
-- MAGIC CREATE OR REPLACE TEMP VIEW CategoryHierarchy AS
-- MAGIC SELECT 1 as CategoryID, 'All Products' as CategoryName, NULL as ParentCategoryID
-- MAGIC UNION ALL SELECT 2, 'Food', 1
-- MAGIC UNION ALL SELECT 3, 'Beverages', 1
-- MAGIC UNION ALL SELECT 4, 'Soft Drinks', 3
-- MAGIC UNION ALL SELECT 5, 'Alcoholic Beverages', 3
-- MAGIC UNION ALL SELECT 6, 'Dairy', 2
-- MAGIC UNION ALL SELECT 7, 'Cheese', 6;
-- MAGIC ```
-- MAGIC
-- MAGIC Krok 2: Napisz rekurencyjne CTE które:
-- MAGIC - Przechodzi całe drzewo od korzenia
-- MAGIC - Wyświetla poziom zagnieżdżenia (Level)
-- MAGIC - Tworzy ścieżkę od korzenia do danego węzła (np. "All Products > Beverages > Soft Drinks")
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** CategoryName, Level, Path
-- MAGIC
-- MAGIC **Wskazówka:** Użyj CONCAT() lub || do budowania ścieżki

-- COMMAND ----------

-- Krok 1: Stwórz hierarchię
CREATE OR REPLACE TEMP VIEW CategoryHierarchy AS
SELECT 1 as CategoryID, 'All Products' as CategoryName, NULL as ParentCategoryID
UNION ALL SELECT 2, 'Food', 1
UNION ALL SELECT 3, 'Beverages', 1
UNION ALL SELECT 4, 'Soft Drinks', 3
UNION ALL SELECT 5, 'Alcoholic Beverages', 3
UNION ALL SELECT 6, 'Dairy', 2
UNION ALL SELECT 7, 'Cheese', 6;

-- COMMAND ----------

-- Krok 2: Twoje rozwiązanie (rekurencyjne CTE):




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 4: Funkcje Analityczne (Window Functions)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 4.1: Top N per group 🟢
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Znajdź 2 najdroższe produkty w każdej kategorii.
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** CategoryName, ProductName, UnitPrice, PriceRank
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - Użyj ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
-- MAGIC - Zastosuj CTE lub podzapytanie + WHERE PriceRank <= 2

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 4.2: Porównanie z średnią 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Dla każdego produktu wyświetl:
-- MAGIC - Nazwę produktu i jego cenę
-- MAGIC - Średnią cenę w jego kategorii
-- MAGIC - Różnicę od średniej (w wartości i procentach)
-- MAGIC - Informację czy produkt jest "Above Average" czy "Below Average"
-- MAGIC
-- MAGIC **Oczekiwane kolumny:**
-- MAGIC - ProductName
-- MAGIC - UnitPrice
-- MAGIC - AvgInCategory
-- MAGIC - DiffFromAvg
-- MAGIC - PctDiffFromAvg
-- MAGIC - Status
-- MAGIC
-- MAGIC **Wskazówka:** Użyj AVG() OVER (PARTITION BY CategoryID)

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 4.3: Suma bieżąca i średnia krocząca 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Dla zamówień uporządkowanych chronologicznie wyświetl:
-- MAGIC - OrderID, OrderDate, wartość zamówienia
-- MAGIC - Sumę bieżącą wszystkich zamówień do tej pory
-- MAGIC - 3-zamówieniową średnią kroczącą
-- MAGIC
-- MAGIC **Oczekiwane kolumny:**
-- MAGIC - OrderID
-- MAGIC - OrderDate
-- MAGIC - OrderValue
-- MAGIC - RunningTotal
-- MAGIC - MovingAvg3
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - Najpierw stwórz CTE z wartościami zamówień
-- MAGIC - SUM(...) OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING)
-- MAGIC - AVG(...) OVER (ORDER BY ... ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 4.4: LAG/LEAD - analiza trendów 🔴
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Dla każdej kategorii, pogrupuj zamówienia według miesięcy i wyświetl:
-- MAGIC - Kategoria, miesiąc, sprzedaż w tym miesiącu
-- MAGIC - Sprzedaż w poprzednim miesiącu
-- MAGIC - Zmiana miesiąc-do-miesiąca (wartość i procent)
-- MAGIC - Status trendu: "Growing" (wzrost >10%), "Stable" (-10% do +10%), "Declining" (spadek >10%)
-- MAGIC
-- MAGIC **Oczekiwane kolumny:**
-- MAGIC - CategoryName
-- MAGIC - Month
-- MAGIC - CurrentMonthSales
-- MAGIC - PreviousMonthSales
-- MAGIC - MoMChange
-- MAGIC - MoMChangePct
-- MAGIC - Trend
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - CTE z agregacją miesięczną według kategorii
-- MAGIC - LAG() do pobrania wartości z poprzedniego miesiąca
-- MAGIC - CASE WHEN do określenia trendu

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 4.5: NTILE - kwartyle i percentyle 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Podziel produkty na 4 grupy (kwartyle) według ceny i wyświetl:
-- MAGIC - Nazwę produktu i cenę
-- MAGIC - Numer kwartyla (1-4)
-- MAGIC - Minimalną i maksymalną cenę w tym kwartylu
-- MAGIC - Opis kwartyla: "Bottom 25%", "25-50%", "50-75%", "Top 25%"
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - NTILE(4) OVER (ORDER BY UnitPrice)
-- MAGIC - MIN/MAX OVER (PARTITION BY quartile)
-- MAGIC - CASE WHEN dla opisu

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 5: Funkcje Użytkownika (UDF)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 5.1: Prosta SQL UDF 🟢
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz funkcję `calculate_margin(cost, price)` która oblicza marżę procentową.
-- MAGIC
-- MAGIC Wzór: margin = ((price - cost) / cost) * 100
-- MAGIC
-- MAGIC Następnie użyj jej do wyświetlenia produktów z marżą > 50%
-- MAGIC (Załóż, że koszt to 60% ceny sprzedaży: cost = UnitPrice * 0.6)
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** ProductName, Cost, Price, MarginPct

-- COMMAND ----------

-- Twoje rozwiązanie:
-- Krok 1: Stwórz funkcję




-- Krok 2: Użyj funkcji




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 5.2: SQL UDF z logiką biznesową 🟡
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz funkcję `stock_status(units_in_stock, reorder_level, discontinued)` która zwraca:
-- MAGIC - "Discontinued" jeśli produkt wycofany
-- MAGIC - "Critical - Reorder Now" jeśli stock < reorder_level
-- MAGIC - "Low Stock" jeśli stock < reorder_level * 2
-- MAGIC - "Adequate" w pozostałych przypadkach
-- MAGIC
-- MAGIC Użyj funkcji do wygenerowania raportu stanu magazynu.
-- MAGIC
-- MAGIC **Oczekiwane kolumny:** ProductName, UnitsInStock, ReorderLevel, Status

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Sekcja 6: Zadania Integracyjne (Łączą wiele technik)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 6.1: Dashboard sprzedażowy 🔴
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Stwórz kompleksowy dashboard sprzedażowy, który zawiera:
-- MAGIC
-- MAGIC 1. **CTE #1 - ProductSales**: Sprzedaż każdego produktu (suma z OrderDetails)
-- MAGIC 2. **CTE #2 - CategoryRanking**: Ranking produktów w ramach kategorii
-- MAGIC 3. **CTE #3 - CategorySummary**: Podsumowania per kategoria używając ROLLUP
-- MAGIC
-- MAGIC **Finalny wynik powinien pokazywać:**
-- MAGIC - Top 3 produkty w każdej kategorii
-- MAGIC - Sprzedaż produktu i procent sprzedaży kategorii
-- MAGIC - Ranking w kategorii
-- MAGIC - Różnicę od średniej w kategorii
-- MAGIC
-- MAGIC To jest zadanie otwarte - zaprojektuj dashboard według własnego uznania, używając poznanych technik!

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 6.2: Analiza kohort klientów 🔴
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Przeprowadź analizę kohort klientów według kraju:
-- MAGIC
-- MAGIC 1. Znajdź datę pierwszego zamówienia dla każdego kraju
-- MAGIC 2. Dla każdego kolejnego zamówienia z tego kraju oblicz:
-- MAGIC    - Ile dni minęło od pierwszego zamówienia
-- MAGIC    - Jaka jest skumulowana wartość zamówień
-- MAGIC    - Ile zamówień złożono do tej pory
-- MAGIC    - Jaka jest średnia wartość zamówienia do tej pory
-- MAGIC
-- MAGIC **Wskazówka:**
-- MAGIC - Użyj window functions do znalezienia pierwszej daty: MIN(...) OVER (PARTITION BY Country)
-- MAGIC - DATEDIFF() do obliczenia różnicy dni
-- MAGIC - SUM() OVER (... ROWS UNBOUNDED PRECEDING) dla skumulowanych wartości
-- MAGIC - COUNT() OVER dla liczby zamówień

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Ćwiczenie 6.3: Optymalizacja zapytania 🔴
-- MAGIC
-- MAGIC **Polecenie:**
-- MAGIC Poniżej znajduje się źle napisane zapytanie. Twoim zadaniem jest:
-- MAGIC
-- MAGIC 1. Zidentyfikować wszystkie problemy wydajnościowe
-- MAGIC 2. Przepisać zapytanie używając dobrych praktyk
-- MAGIC 3. Napisać komentarze wyjaśniające każdą poprawkę
-- MAGIC 4. Zaproponować indeksowanie/partycjonowanie dla tego przypadku użycia

-- COMMAND ----------

-- ❌ ŹLE NAPISANE ZAPYTANIE (do optymalizacji):

SELECT *
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE YEAR(o.OrderDate) = 2023
  AND MONTH(o.OrderDate) IN (7, 8, 9)
  AND UPPER(c.CategoryName) LIKE '%BEV%'
GROUP BY o.CustomerID, c.CategoryName, o.ShipCountry
HAVING SUM(od.Quantity * od.UnitPrice) > 0
ORDER BY SUM(od.Quantity * od.UnitPrice) DESC;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Twoja analiza problemów:**
-- MAGIC
-- MAGIC (Napisz tutaj listę znalezionych problemów)
-- MAGIC
-- MAGIC 1. ...
-- MAGIC 2. ...
-- MAGIC 3. ...

-- COMMAND ----------

-- ✅ TWOJE ZOPTYMALIZOWANE ZAPYTANIE:
-- (Z komentarzami wyjaśniającymi zmiany)




-- COMMAND ----------

-- MAGIC %md
-- MAGIC **Propozycje optymalizacji strukturalnej:**
-- MAGIC
-- MAGIC (Napisz tutaj propozycje partycjonowania, Z-ordering, itp.)
-- MAGIC
-- MAGIC ```sql
-- MAGIC -- Przykład:
-- MAGIC -- OPTIMIZE Orders ZORDER BY (OrderDate, CustomerID);
-- MAGIC ```

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Bonus: Zadanie Finałowe - Mini Projekt 🔴🔴🔴
-- MAGIC
-- MAGIC **Scenariusz:**
-- MAGIC Jesteś analitykiem danych w firmie Northwind. Dyrektor sprzedaży poprosił Cię o kompleksowy raport odpowiadający na pytania:
-- MAGIC
-- MAGIC 1. Które produkty generują największy przychód i czy ten trend jest rosnący czy spadkowy?
-- MAGIC 2. Które kraje są najważniejszymi rynkami i jak się rozwijają?
-- MAGIC 3. Czy są produkty, które powinniśmy wycofać (niska sprzedaż, duże zapasy)?
-- MAGIC 4. Jakie są wzorce sezonowości w sprzedaży?
-- MAGIC
-- MAGIC **Wymagania:**
-- MAGIC - Użyj minimum 3 różnych technik poznanych na szkoleniu (CTE, window functions, ROLLUP/CUBE, UDF)
-- MAGIC - Zapytanie powinno być dobrze sformatowane i skomentowane
-- MAGIC - Wynik powinien być czytelny i gotowy do prezentacji
-- MAGIC
-- MAGIC To jest zadanie otwarte - zaprojektuj rozwiązanie według własnego pomysłu!

-- COMMAND ----------

-- Twoje rozwiązanie:




-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Gratulacje! 🎉
-- MAGIC
-- MAGIC Ukończyłeś wszystkie ćwiczenia praktyczne z zaawansowanego SQL!
-- MAGIC
-- MAGIC **Następne kroki:**
-- MAGIC 1. Sprawdź swoje rozwiązania z notebookiem z odpowiedziami
-- MAGIC 2. Jeśli coś nie wyszło - nie martw się! Wróć do materiałów i spróbuj ponownie
-- MAGIC 3. Najlepszy sposób nauki to praktyka - spróbuj zastosować te techniki na własnych danych
-- MAGIC
-- MAGIC **Pamiętaj:**
-- MAGIC - SQL to język deklaratywny - często jest wiele poprawnych rozwiązań tego samego problemu
-- MAGIC - Liczy się zarówno poprawność jak i wydajność
-- MAGIC - Kod powinien być czytelny dla innych (i dla Ciebie za 6 miesięcy!)
-- MAGIC
-- MAGIC Powodzenia w dalszej przygodzie z SQL! 🚀
