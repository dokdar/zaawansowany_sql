# FUNKCJE GRUPOWANIA I AGREGACJI
## ROLLUP, CUBE, GROUPING SETS, PIVOT

---

# WPROWADZENIE DO ZAAWANSOWANEGO GRUPOWANIA

## Przypomnijmy GROUP BY:
```sql
SELECT CategoryID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID;
```
Zwraca liczbę produktów **dla każdej kategorii**.

## Ale co jeśli chcemy TAKŻE:
- ✅ Podsumowanie dla każdej kategorii
- ✅ **Podsumowanie CAŁKOWITE**
- ✅ Podsumowania na wielu poziomach hierarchii

**Rozwiązanie:** ROLLUP, CUBE, GROUPING SETS

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Okej, zaczynamy pierwszą prawdziwie zaawansowaną technikę - funkcje grupowania i agregacji. To narzędzia które wielu programistów SQL nie zna, a szkoda, bo są niesamowicie potężne.

**Problem biznesowy:**
Wyobraźcie sobie że szef prosi Was o raport sprzedaży. Chce zobaczyć:
- Sprzedaż dla każdego kraju
- Sprzedaż dla każdego regionu w kraju
- Sprzedaż dla każdego miasta w regionie
- PLUS sumę całkowitą na końcu

Klasyczne podejście? Trzeba wykonać kilka zapytań i ręcznie posklejać wyniki. Albo napisać strasznie złożone zapytanie z UNION ALL.

Jest lepszy sposób: **ROLLUP**.

A co jeśli chcecie WSZYSTKIE możliwe kombinacje grup? **CUBE**.

A co jeśli chcecie WYBRANE kombinacje? **GROUPING SETS**.

Przez następne 45 minut zobaczycie jak te narzędzia działają i dlaczego są genialne. Zaczynamy od ROLLUP."

**Wskazówki:**
- Pokaż problem biznesowy - ludzie lepiej rozumieją kiedy widzą praktyczny use case
- Zapowiedz że będą przykłady z Northwind
- Entuzjazm! To naprawdę fajne techniki

---

# ROLLUP - PODSUMOWANIA HIERARCHICZNE

## Co robi ROLLUP:
Tworzy podsumowania **hierarchiczne** - od najniższego poziomu do całkowitego.

## Składnia:
```sql
SELECT kolumna1, kolumna2, SUM(wartość)
FROM tabela
GROUP BY ROLLUP(kolumna1, kolumna2);
```

## Równoważne:
```sql
GROUP BY ROLLUP(A, B, C)
```
Tworzy grupy:
- (A, B, C) - najniższy poziom
- (A, B) - podsumowanie dla A i B
- (A) - podsumowanie dla A
- () - suma całkowita

---

# NOTATKI DLA PROWADZĄCEGO - ROLLUP TEORIA

**Czas trwania:** 3-4 minuty

**Co powiedzieć:**
"ROLLUP to pierwszy z naszych super-narzędzi. Nazwa pochodzi od 'roll up' - zwijać w górę hierarchii.

**Jak działa:**

Załóżmy że mamy: `GROUP BY ROLLUP(Kraj, Region, Miasto)`

ROLLUP automatycznie tworzy następujące poziomy grupowania:
1. (Kraj, Region, Miasto) - najpierw najdokładniejszy poziom
2. (Kraj, Region) - potem grupuje po kraju i regionie
3. (Kraj) - potem tylko po kraju
4. () - na koniec suma całkowita

**Hierarchia jest ważna!**
```sql
GROUP BY ROLLUP(A, B)  ≠  GROUP BY ROLLUP(B, A)
```

Pierwsza da: (A,B), (A), ()
Druga da: (B,A), (B), ()

ROLLUP idzie od lewej do prawej, usuwając kolumny od końca.

**Wizualizacja:**

Wyobraźcie sobie piramidę:
```
Poziom 0:  [Polska, Mazowieckie, Warszawa] = 100 zamówień
           [Polska, Mazowieckie, Radom] = 50 zamówień
           [Polska, Śląskie, Katowice] = 80 zamówień

Poziom 1:  [Polska, Mazowieckie] = 150 zamówień (suma miast)
           [Polska, Śląskie] = 80 zamówień

Poziom 2:  [Polska] = 230 zamówień (suma regionów)

Poziom 3:  [] = 230 zamówień (suma krajów - tu tylko Polska)
```

ROLLUP robi to wszystko w jednym zapytaniu!

Zobaczmy na prawdziwych danych z Northwind."

**Wskazówki:**
- Narysuj hierarchię na tablicy jeśli możesz
- Podkreśl że kolejność kolumn ma znaczenie
- Przejdź szybko do przykładu - teoria bez praktyki jest nudna

---

# ROLLUP - PRZYKŁAD 1

```sql
-- Liczba zamówień według kraju i regionu z podsumowaniami
SELECT
    ShipCountry,
    ShipRegion,
    COUNT(OrderID) AS NumberOfOrders
FROM Orders
GROUP BY ROLLUP(ShipCountry, ShipRegion)
ORDER BY ShipCountry, ShipRegion;
```

**Wynik zawiera:**
- Liczbę zamówień dla każdej kombinacji (kraj, region)
- Podsumowanie dla każdego kraju (wszystkie regiony)
- Podsumowanie całkowite (wszystkie kraje)

**Problem:** Jak rozróżnić poziomy? Gdzie NULL oznacza brak danych, a gdzie podsumowanie?

**Rozwiązanie:** Funkcja `GROUPING()`

---

# NOTATKI DLA PROWADZĄCEGO - ROLLUP PRZYKŁAD 1

**Czas trwania:** 5-6 minut

**Co powiedzieć:**
"Czas na pierwszy praktyczny przykład. Policzymy zamówienia według kraju i regionu.

[Uruchom zapytanie]

```sql
SELECT
    ShipCountry,
    ShipRegion,
    COUNT(OrderID) AS NumberOfOrders
FROM Orders
GROUP BY ROLLUP(ShipCountry, ShipRegion)
ORDER BY ShipCountry, ShipRegion;
```

Zobaczmy wyniki... [Scroll przez wyniki]

Widzicie? Mamy różne poziomy:

1. **Kraj + Region:** np. 'Germany', 'NULL', 122 - to Niemcy bez określonego regionu
2. **Tylko Kraj:** 'Germany', NULL, 122 - czekaj, to wygląda tak samo!

I tu jest **problem**: Jak odróżnić NULL który oznacza 'brak danych w oryginalnej tabeli' od NULL który oznacza 'to jest wiersz podsumowujący'?

W naszych danych w kolumnie ShipRegion jest dużo NULL-i - wiele krajów nie używa regionów. Więc nie wiemy czy:
- NULL = brak regionu w danych
- NULL = suma dla wszystkich regionów danego kraju

**Rozwiązanie: Funkcja GROUPING()**

```sql
SELECT
    ShipCountry,
    ShipRegion,
    COUNT(OrderID) AS NumberOfOrders,
    GROUPING(ShipCountry) AS Country_Grouped,
    GROUPING(ShipRegion) AS Region_Grouped
FROM Orders
GROUP BY ROLLUP(ShipCountry, ShipRegion)
ORDER BY ShipCountry, ShipRegion;
```

[Uruchom poprawione zapytanie]

Teraz widzicie dodatkowe kolumny:
- **GROUPING(kolumna) = 0** - ta kolumna NIE jest agregowana (zwykły wiersz)
- **GROUPING(kolumna) = 1** - ta kolumna JEST agregowana (wiersz podsumowujący)

Patrzcie na wyniki:

```
ShipCountry | ShipRegion | Count | Country_Grouped | Region_Grouped
------------|------------|-------|-----------------|----------------
France      | NULL       | 77    | 0               | 0              <- to prawdziwy NULL w danych
France      | NULL       | 77    | 0               | 1              <- to podsumowanie dla Francji
NULL        | NULL       | 830   | 1               | 1              <- to podsumowanie całości
```

Kiedy Region_Grouped = 1, wiemy że to podsumowanie!

**Praktyczne użycie - czytelne etykiety:**

```sql
SELECT
    CASE GROUPING(ShipCountry)
        WHEN 1 THEN 'TOTAL'
        ELSE ShipCountry
    END AS Country,
    CASE GROUPING(ShipRegion)
        WHEN 1 THEN 'All Regions'
        ELSE COALESCE(ShipRegion, 'Not Provided')
    END AS Region,
    COUNT(OrderID) AS NumberOfOrders
FROM Orders
GROUP BY ROLLUP(ShipCountry, ShipRegion)
ORDER BY ShipCountry, ShipRegion;
```

[Uruchom]

Teraz jest czytelnie! Zamiast NULL widzimy 'TOTAL' albo 'All Regions'.

Spróbujcie sami (3 minuty):
Policzcie liczbę produktów według kategorii i dostawcy używając ROLLUP. Użyjcie GROUPING() żeby oznaczyć poziomy podsumowań."

**Wskazówki:**
- Wyjaśnij dokładnie problem z NULL
- Pokaż jak GROUPING() rozwiązuje problem
- Przykład z CASE pokazuje jak zrobić czytelny raport
- Daj ćwiczenie praktyczne

---

# ROLLUP - PRZYKŁAD 2 (TRZY POZIOMY)

```sql
-- Liczba zamówień: kraj -> region -> miasto + podsumowania
SELECT
    ShipCountry,
    ShipRegion,
    ShipCity,
    COUNT(OrderID) AS NumberOfOrders,
    GROUPING(ShipCountry) AS Ctry_Grp,
    GROUPING(ShipRegion) AS Reg_Grp,
    GROUPING(ShipCity) AS City_Grp
FROM Orders
GROUP BY ROLLUP(ShipCountry, ShipRegion, ShipCity)
ORDER BY ShipCountry, ShipRegion, ShipCity;
```

**Poziomy agregacji:**
1. (Kraj, Region, Miasto) - szczegółowe
2. (Kraj, Region) - suma dla regionu
3. (Kraj) - suma dla kraju
4. () - suma całkowita

---

# NOTATKI DLA PROWADZĄCEGO - ROLLUP 3 POZIOMY

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Zobaczmy ROLLUP z trzema poziomami hierarchii - to lepiej pokazuje jego moc.

[Uruchom zapytanie]

Mamy cztery poziomy podsumowań:

```
Ctry_Grp=0, Reg_Grp=0, City_Grp=0  -> najniższy poziom (konkretne miasto)
Ctry_Grp=0, Reg_Grp=0, City_Grp=1  -> podsumowanie regionu
Ctry_Grp=0, Reg_Grp=1, City_Grp=1  -> podsumowanie kraju
Ctry_Grp=1, Reg_Grp=1, City_Grp=1  -> podsumowanie TOTAL
```

To jest dokładnie to czego potrzebuje szef do raportu! Jeden query, wszystkie poziomy hierarchii.

W Excel-u musielibyście robić pivot tables i ręcznie sumować. Tu dostajecie gotowca.

**Kiedy używać ROLLUP:**
- Raporty hierarchiczne (kraj->region->miasto, kategoria->podkategoria->produkt)
- Raporty finansowe (rok->kwartał->miesiąc)
- Struktury organizacyjne (dział->zespół->pracownik)

**Kiedy NIE używać:**
- Kiedy nie macie naturalnej hierarchii - użyjcie CUBE
- Kiedy chcecie konkretnych kombinacji - użyjcie GROUPING SETS

O CUBE i GROUPING SETS za chwilę, ale najpierw szybkie pytanie: Czy widzicie praktyczne zastosowanie ROLLUP w waszych projektach?"

**Wskazówki:**
- Pokaż jak odczytywać kolumny GROUPING
- Podkreśl praktyczne zastosowania biznesowe
- Zapytaj o ich doświadczenia - interakcja angażuje

---

# CUBE - WSZYSTKIE KOMBINACJE

## Czym różni się od ROLLUP:
- **ROLLUP:** Hierarchia A -> B -> C
- **CUBE:** WSZYSTKIE kombinacje A, B, C

## Składnia:
```sql
GROUP BY CUBE(A, B, C)
```

## Tworzy grupy:
- (A, B, C)
- (A, B), (A, C), (B, C)
- (A), (B), (C)
- ()

**CUBE(A, B)** = 2² = 4 kombinacje
**CUBE(A, B, C)** = 2³ = 8 kombinacji

---

# NOTATKI DLA PROWADZĄCEGO - CUBE TEORIA

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"CUBE jest bardziej potężny i... bardziej 'wybuchowy' niż ROLLUP.

**Różnica:**

ROLLUP(A, B, C) daje: (A,B,C), (A,B), (A), ()  -> 4 poziomy, hierarchia

CUBE(A, B, C) daje: WSZYSTKIE możliwe kombinacje:
- (A, B, C)
- (A, B), (A, C), (B, C)
- (A), (B), (C)
- ()

To jest 2³ = 8 kombinacji!

**Matematyka:**
CUBE z N kolumn = 2^N kombinacji

- CUBE(A) = 2 kombinacje
- CUBE(A, B) = 4 kombinacje
- CUBE(A, B, C) = 8 kombinacji
- CUBE(A, B, C, D) = 16 kombinacji
- CUBE(A, B, C, D, E) = 32 kombinacje

Widzicie problem? Rośnie wykładniczo! Więc UWAGA z CUBE na wielu kolumnach - możecie dostać MILIONY wierszy.

**Kiedy używać CUBE:**

Kiedy nie macie naturalnej hierarchii ale chcecie analizować dane z różnych perspektyw.

Przykład biznesowy:
Analizujecie sprzedaż według:
- Kraju
- Kategorii produktu
- Roku

Chcecie widzieć:
- Sprzedaż per kraj (wszystkie kategorie, wszystkie lata)
- Sprzedaż per kategoria (wszystkie kraje, wszystkie lata)
- Sprzedaż per rok (wszystkie kraje, wszystkie kategorie)
- Sprzedaż per kraj+kategoria
- Sprzedaż per kraj+rok
- Sprzedaż per kategoria+rok
- Sprzedaż per kraj+kategoria+rok
- Sprzedaż całkowita

To jest **EXACTLY** to co robi CUBE. Wszystkie możliwe kombinacje wymiarów.

Pokażę przykład."

**Wskazówki:**
- Podkreśl różnicę ROLLUP vs CUBE
- Ostrzeż przed wykładniczym wzrostem
- Biznesowy przykład pomaga zrozumieć

---

# CUBE - PRZYKŁAD

```sql
-- Liczba produktów według kategorii i dostawcy - WSZYSTKIE kombinacje
SELECT
    c.CategoryName,
    s.CompanyName AS Supplier,
    COUNT(p.ProductID) AS ProductCount,
    GROUPING(c.CategoryName) AS Cat_Grp,
    GROUPING(s.CompanyName) AS Sup_Grp
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY CUBE(c.CategoryName, s.CompanyName)
HAVING GROUPING(c.CategoryName) = 1 OR GROUPING(s.CompanyName) = 1
ORDER BY Cat_Grp, Sup_Grp;
```

**HAVING filtruje:** Pokazuję tylko wiersze podsumowujące (nie szczegóły)

**Wynik:**
- Suma per kategoria (wszystcy dostawcy)
- Suma per dostawca (wszystkie kategorie)
- Suma całkowita

---

# NOTATKI DLA PROWADZĄCEGO - CUBE PRZYKŁAD

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Zobaczmy CUBE w akcji. Policzymy produkty według kategorii i dostawcy.

[Uruchom zapytanie z komentarzem]

Bez HAVING dostalibyśmy MNÓSTWO wierszy - każda kombinacja kategorii + dostawcy. Użyłem HAVING żeby pokazać tylko podsumowania.

```sql
HAVING GROUPING(c.CategoryName) = 1 OR GROUPING(s.CompanyName) = 1
```

To znaczy: pokaż tylko te wiersze gdzie PRZYNAJMNIEJ jedna kolumna jest agregowana.

[Pokaż wyniki]

Widzicie trzy typy wierszy:

1. **Cat_Grp=1, Sup_Grp=0:** NULL, CompanyName, Count
   To suma dla dostawcy (wszystkie kategorie)

2. **Cat_Grp=0, Sup_Grp=1:** CategoryName, NULL, Count
   To suma dla kategorii (wszyscy dostawcy)

3. **Cat_Grp=1, Sup_Grp=1:** NULL, NULL, Count
   To suma całkowita

**Bez HAVING - cały CUBE:**

```sql
SELECT
    c.CategoryName,
    s.CompanyName AS Supplier,
    COUNT(p.ProductID) AS ProductCount
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY CUBE(c.CategoryName, s.CompanyName)
ORDER BY c.CategoryName, s.CompanyName;
```

[Uruchom]

Teraz widzicie WSZYSTKO - każda kombinacja kategorii i dostawcy + podsumowania.

**Praktyczny use case - raport Excel:**

Taki wynik możecie wyeksportować do CSV i w Excel-u mieć gotowy raport z wszystkimi możliwymi zestawieniami. Nie musicie robić 10 osobnych zapytań.

**Uwaga wydajnościowa:**

CUBE(A, B) gdzie A ma 8 wartości i B ma 20 wartości = 8*20 + 8 + 20 + 1 = 189 wierszy. Ok.

CUBE(A, B, C, D) gdzie każdy ma 10 wartości? To może być 10,000+ wierszy. Uważajcie!

Pytania do CUBE?"

**Wskazówki:**
- Wyjaśnij HAVING filtr - wielu nie rozumie
- Pokaż różnicę z i bez HAVING
- Ostrzeż przed performance issues na dużych danych

---

# GROUPING SETS - WYBRANE KOMBINACJE

## Problem:
- ROLLUP - tylko hierarchia
- CUBE - wszystkie kombinacje (często za dużo)

## Rozwiązanie: GROUPING SETS
Wybieramy **konkretne** kombinacje grupowania.

## Składnia:
```sql
GROUP BY GROUPING SETS (
    (kolumna1, kolumna2),
    (kolumna1),
    (kolumna3),
    ()
)
```

## Równoważność:
```sql
ROLLUP(A, B) = GROUPING SETS ((A,B), (A), ())
CUBE(A, B) = GROUPING SETS ((A,B), (A), (B), ())
```

---

# NOTATKI DLA PROWADZĄCEGO - GROUPING SETS TEORIA

**Czas trwania:** 2-3 minuty

**Co powiedzieć:**
"GROUPING SETS to najbardziej elastyczne narzędzie z tej trójki. Daje Wam pełną kontrolę.

**Problem z ROLLUP i CUBE:**

ROLLUP - świetny dla hierarchii, ale nie możecie pominąć poziomu środkowego.
CUBE - daje wszystko, często więcej niż potrzeba.

**GROUPING SETS - wybierasz co chcesz:**

```sql
GROUP BY GROUPING SETS (
    (Country, City),    -- zamówienia per kraj+miasto
    (Category),         -- zamówienia per kategoria
    ()                  -- suma całkowita
)
```

Nie dostajesz (Country), nie dostajesz (City), nie dostajesz (Country, Category). Tylko to co wypisałeś.

**Matematyczna równoważność:**

ROLLUP i CUBE to tak naprawdę skróty dla GROUPING SETS:

```sql
-- Te dwa są identyczne:
GROUP BY ROLLUP(A, B)
GROUP BY GROUPING SETS ((A, B), (A), ())

-- Te dwa są identyczne:
GROUP BY CUBE(A, B)
GROUP BY GROUPING SETS ((A, B), (A), (B), ())
```

Databricks/Spark SQL pod spodem konwertuje ROLLUP i CUBE na GROUPING SETS.

**Kiedy używać:**

Kiedy potrzebujecie konkretnych kombinacji i wiecie dokładnie czego chcecie. Np.:
- Raport sprzedaży per (rok, kwartał) i per (kategoria) ale bez kombinacji rok+kategoria
- Analiza per (kraj+miasto) i per (produkt) ale bez kraju bez miasta

Pokażę przykład."

**Wskazówki:**
- Podkreśl elastyczność GROUPING SETS
- Wyjaśnij że ROLLUP/CUBE to syntactic sugar
- Przejdź do przykładu

---

# GROUPING SETS - PRZYKŁAD

```sql
-- Liczba produktów w wybranych kombinacjach
SELECT
    c.CategoryName,
    s.Country,
    s.Region,
    COUNT(p.ProductID) AS ProductCount,
    GROUPING_ID(c.CategoryName, s.Country, s.Region) AS GroupLevel
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY GROUPING SETS (
    (c.CategoryName),           -- per kategoria
    (s.Country, s.Region),      -- per kraj+region
    (s.Country),                -- per kraj
    ()                          -- total
)
ORDER BY GroupLevel, c.CategoryName, s.Country;
```

**GROUPING_ID:** Zwraca unikalny numer dla każdego poziomu grupowania (jako bitmask)

---

# NOTATKI DLA PROWADZĄCEGO - GROUPING SETS PRZYKŁAD

**Czas trwania:** 5 minut

**Co powiedzieć:**
"Przykład GROUPING SETS. Chcemy policzyć produkty w kilku różnych przekrojach, ale nie we wszystkich kombinacjach.

[Uruchom zapytanie]

```sql
GROUP BY GROUPING SETS (
    (c.CategoryName),          -- analiza per kategoria
    (s.Country, s.Region),     -- analiza per kraj+region
    (s.Country),               -- analiza per kraj
    ()                         -- suma całkowita
)
```

Definiujemy dokładnie 4 poziomy grupowania. Nie dostaniemy (CategoryName, Country) ani (Region) - nie chcemy tych kombinacji.

**GROUPING_ID - super funkcja:**

GROUPING() zwraca 0/1 dla jednej kolumny.
GROUPING_ID() zwraca unikalny identyfikator dla całej kombinacji.

Działa jak bitmask:

```
CategoryName  Country  Region  -> Bitmask  -> GROUPING_ID
----------------------------------------------------
0             0        0           000          0  (Cat, Country, Region)
1             0        0           100          4  (Country, Region)
1             1        0           110          6  (Country)
0             1        1           011          3  (Category)
1             1        1           111          7  (TOTAL)
```

Każda kombinacja ma unikalny numer. Dzięki temu możecie łatwo filtrować:

```sql
-- Tylko sumy per kraj (bez regionów):
WHERE GROUPING_ID(...) = 6
```

Albo dodać czytelne etykiety:

```sql
SELECT
    CASE GROUPING_ID(c.CategoryName, s.Country, s.Region)
        WHEN 3 THEN 'Category Summary'
        WHEN 4 THEN 'Country+Region Summary'
        WHEN 6 THEN 'Country Summary'
        WHEN 7 THEN 'Grand Total'
    END AS Level,
    ...
```

[Możesz uruchomić rozszerzoną wersję z CASE]

**Praktyczne zastosowanie:**

Raporty gdzie potrzebujesz różnych perspektyw ale nie wszystkich możliwych. Np:
- Analiza sprzedaży per (region, produkt) i per (czas) ale bez kombinacji region+czas
- Wydajność per (pracownik, projekt) i per (departament) bez pracownik+departament

GROUPING SETS daje precyzyjną kontrolę i lepszą wydajność niż CUBE (mniej kombinacji = szybsze zapytanie).

Ćwiczenie (5 minut):
Stwórzcie GROUPING SETS dla Orders pokazujący:
- Liczbę zamówień per ShipCountry
- Liczbę zamówień per rok (użyjcie YEAR(OrderDate))
- Sumę całkowitą

Użyjcie GROUPING_ID żeby oznaczyć poziomy."

**Wskazówki:**
- GROUPING_ID może być trudny - wyjaśnij dokładnie bitmask
- Pokaż praktyczne użycie z CASE
- Daj ćwiczenie - utrwala

---

# PIVOT - TRANSFORMACJA WIERSZY NA KOLUMNY

## Problem:
Dane w formacie "długim" (wiersze), chcemy format "szeroki" (kolumny)

**Przed (wiersze):**
```
Category    | Year | Amount
------------|------|--------
Beverages   | 1996 | 10000
Beverages   | 1997 | 12000
Confections | 1996 | 8000
```

**Po (kolumny):**
```
Category    | 1996  | 1997
------------|-------|-------
Beverages   | 10000 | 12000
Confections | 8000  | NULL
```

---

# NOTATKI DLA PROWADZĄCEGO - PIVOT INTRO

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Następna technika: PIVOT. To nie jest grupowanie, ale transform transformacja układu danych.

**Problem:**
Macie dane w formacie 'długim' - każdy wiersz to obserwacja. Chcecie format 'szeroki' - lata/kategorie jako kolumny.

[Pokaż slajd z przykładem]

Excel-owcy znają to jako 'pivot table'. W SQL-u robimy podobnie.

**Use case:**
- Raporty z latami jako kolumnami
- Zestawienia z produktami jako kolumnami
- Cross-tabulacje

Np. chcecie raport 'ile sprzedaliśmy każdej kategorii w każdym roku' gdzie lata są kolumnami, nie wierszami.

Bez PIVOT musielibyście robić:
```sql
SELECT
    Category,
    SUM(CASE WHEN Year = 1996 THEN Amount ELSE 0 END) AS Y1996,
    SUM(CASE WHEN Year = 1997 THEN Amount ELSE 0 END) AS Y1997,
    ...
```

Z PIVOT jest prościej. Pokażę."

**Wskazówki:**
- Pokaż wizualnie różnicę wiersze vs kolumny
- Wspomnij Excel pivot tables - większość zna

---

# PIVOT - PRZYKŁAD DATABRICKS

**Uwaga:** Databricks używa innej składni niż SQL Server!

```sql
-- Wartość zamówień per kategoria i rok
SELECT *
FROM (
    SELECT
        c.CategoryName,
        YEAR(o.OrderDate) AS OrderYear,
        (od.UnitPrice * od.Quantity) AS Amount
    FROM `Order Details` od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
PIVOT (
    SUM(Amount)
    FOR OrderYear IN (1996, 1997, 1998)
);
```

**Wynik:** Kategorie jako wiersze, lata jako kolumny

---

# NOTATKI DLA PROWADZĄCEGO - PIVOT PRZYKŁAD

**Czas trwania:** 6-7 minut

**Co powiedzieć:**
"PIVOT w Databricks działa trochę inaczej niż w SQL Server. Pokażę składnię Databricks.

**Struktura:**

1. Najpierw przygotowujemy dane w podzapytaniu (to co ma być pivotowane)
2. Potem używamy PIVOT z funkcją agregującą

[Uruchom zapytanie]

```sql
SELECT *
FROM (
    -- Podzapytanie: przygotowanie danych
    SELECT
        c.CategoryName,
        YEAR(o.OrderDate) AS OrderYear,
        (od.UnitPrice * od.Quantity) AS Amount
    FROM `Order Details` od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
PIVOT (
    SUM(Amount)              -- funkcja agregująca
    FOR OrderYear IN (1996, 1997, 1998)  -- które wartości jako kolumny
);
```

**Rozbiór:**

**Podzapytanie:** Przygotowujemy dane w formacie długim:
- CategoryName - to będą wiersze wyniku
- OrderYear - to będą kolumny wyniku
- Amount - to będzie agregowane

**PIVOT:**
- `SUM(Amount)` - jak agregować (może być AVG, COUNT, MAX, itd.)
- `FOR OrderYear` - która kolumna ma się stać kolumnami
- `IN (1996, 1997, 1998)` - jakie wartości tej kolumny (musimy wypisać!)

**Wynik:**

```
CategoryName | 1996      | 1997      | 1998
-------------|-----------|-----------|----------
Beverages    | 102074.31 | 115387.50 | 50011.88
Confections  | 99789.56  | 106336.77 | 71270.96
...
```

Kategorie jako wiersze, lata jako kolumny! Idealny format do raportu czy wykresu.

**Ważne ograniczenia:**

1. **Musicie znać wartości z góry:** `IN (1996, 1997, 1998)` - nie możecie użyć podzapytania. Jeśli lata się zmieniają, musicie aktualizować zapytanie.

2. **Tylko jedna kolumna FOR:** Nie możecie `FOR (Year, Category)`. Tylko jedna.

3. **Typy danych:** Kolumny wyniku muszą być tego samego typu.

**Dynamiczny PIVOT:**

Jeśli nie znacie wartości z góry, możecie użyć dynamicznego SQL (w Pythonie w Databricks):

```python
# Pobierz lata
years = spark.sql(\"SELECT DISTINCT YEAR(OrderDate) FROM Orders\").collect()
year_list = [str(row[0]) for row in years]

# Zbuduj zapytanie
pivot_query = f\"\"\"
SELECT * FROM (...) PIVOT (
    SUM(Amount) FOR OrderYear IN ({','.join(year_list)})
)
\"\"\"

spark.sql(pivot_query)
```

Ale to zaawansowane - na razie zostańmy przy prostym PIVOT.

Ćwiczenie (4 minuty):
Zróbcie PIVOT pokazujący liczbę produktów (COUNT) per kategoria (wiersze) i dostawca (kolumny). Wybierzcie 3-4 dostawców do kolumn."

**Wskazówki:**
- Podkreśl różnicę składni Databricks vs SQL Server
- Wyjaśnij ograniczenie IN (musi być hardcoded)
- Przykład dynamiczny to bonus dla zaawansowanych
- Daj ćwiczenie

---

# UNPIVOT - TRANSFORMACJA KOLUMN NA WIERSZE

## Odwrotność PIVOT:
Z formatu "szerokiego" na "długi"

**Przed (kolumny):**
```
ID | CustomerID | ProductA | ProductB | ProductC
---|------------|----------|----------|----------
1  | ALFKI      | 10       | 20       | 15
```

**Po (wiersze):**
```
ID | CustomerID | ProductCode | Quantity
---|------------|-------------|----------
1  | ALFKI      | ProductA    | 10
1  | ALFKI      | ProductB    | 20
1  | ALFKI      | ProductC    | 15
```

---

# NOTATKI DLA PROWADZĄCEGO - UNPIVOT INTRO

**Czas trwania:** 1-2 minuty

**Co powiedzieć:**
"UNPIVOT to odwrotność PIVOT - z szerokiego formatu na długi.

**Kiedy to potrzebne?**

Czasem dostajesz dane w formacie Excel gdzie każda kolumna to osobny produkt/miesiąc/kategoria. Ale w bazie danych chcesz mieć format znormalizowany - każda obserwacja to wiersz.

Przykład: Macie arkusz Excel z kolumnami: Styczeń, Luty, Marzec... Chcecie w bazie: Miesiąc, Wartość.

UNPIVOT robi tę transformację.

W Databricks jest trochę inaczej niż SQL Server. Pokażę."

**Wskazówki:**
- Szybkie intro - UNPIVOT jest mniej popularny niż PIVOT
- Jeśli czas nagli, można pominąć lub skrócić

---

# UNPIVOT - PRZYKŁAD DATABRICKS

**Uwaga:** Databricks nie ma natywnego UNPIVOT. Używamy STACK() lub EXPLODE().

## Metoda 1: STACK
```sql
SELECT ID, CustomerID, ProductCode, Quantity
FROM (
    SELECT 1 AS ID, 'ALFKI' AS CustomerID, 10 AS ProductA, 20 AS ProductB, 15 AS ProductC
)
LATERAL VIEW STACK(3,
    'ProductA', ProductA,
    'ProductB', ProductB,
    'ProductC', ProductC
) AS ProductCode, Quantity;
```

## Metoda 2: Alternatywnie - UNION ALL
```sql
SELECT ID, CustomerID, 'ProductA' AS ProductCode, ProductA AS Quantity FROM source
UNION ALL
SELECT ID, CustomerID, 'ProductB', ProductB FROM source
UNION ALL
SELECT ID, CustomerID, 'ProductC', ProductC FROM source;
```

---

# NOTATKI DLA PROWADZĄCEGO - UNPIVOT PRZYKŁAD

**Czas trwania:** 3-4 minuty (opcjonalnie można skrócić)

**Co powiedzieć:**
"UNPIVOT w Databricks jest... nietypowy. Nie mamy bezpośredniej klauzuli UNPIVOT jak w SQL Server.

**Metoda 1: STACK (rekomendowana):**

```sql
LATERAL VIEW STACK(3,          -- 3 to liczba kolumn do unpivot
    'ProductA', ProductA,       -- nazwa, wartość
    'ProductB', ProductB,
    'ProductC', ProductC
) AS ProductCode, Quantity
```

STACK tworzy 3 wiersze z 3 kolumn. LATERAL VIEW to Spark SQL sposób na 'rozwinięcie' tabeli.

[Uruchom przykład]

Widzicie? Jedna kolumna stała się trzema wierszami.

**Metoda 2: UNION ALL (prosta, ale verbose):**

Jeśli micie mało kolumn, możecie po prostu:

```sql
SELECT ..., 'ProductA', ProductA FROM ...
UNION ALL
SELECT ..., 'ProductB', ProductB FROM ...
```

Proste, działa, ale dużo pisania.

**Praktycznie:**

UNPIVOT jest rzadziej potrzebny niż PIVOT. Przeważnie dane już są w formacie długim w bazie. Ale jeśli importujecie z Excel-a albo legacy systemów - przyda się.

**Alternatywa - przetwarzanie w Pythonie:**

W Databricks możecie też użyć PySpark:

```python
df.selectExpr(\"ID\", \"CustomerID\",  \"stack(3, 'ProductA', ProductA, 'ProductB', ProductB, 'ProductC', ProductC) as (ProductCode, Quantity)\")
```

Czasem łatwiej w Pythonie niż w SQL.

Pytania do UNPIVOT? Nie? To dobrze, bo to najmniej ważna część dzisiejszego szkolenia."

**Wskazówki:**
- UNPIVOT to bonus topic - jeśli czas nagli, możesz skrócić
- Podkreśl że STACK to Databricks specific
- Wspomnij alternatywę PySpark

---

# PODSUMOWANIE - FUNKCJE GRUPOWANIA

## ✅ Co omówiliśmy:
- **ROLLUP** - podsumowania hierarchiczne (kraj->region->miasto)
- **CUBE** - wszystkie możliwe kombinacje grup
- **GROUPING SETS** - wybrane kombinacje (pełna kontrola)
- **GROUPING() / GROUPING_ID()** - identyfikacja poziomów agregacji
- **PIVOT** - transformacja wierszy na kolumny
- **UNPIVOT** - transformacja kolumn na wiersze

## Kiedy co używać:
| Technika | Kiedy używać |
|----------|--------------|
| ROLLUP | Hierarchie, raporty wielopoziomowe |
| CUBE | Wszystkie wymiary analityczne |
| GROUPING SETS | Konkretne kombinacje |
| PIVOT | Raporty z dynamicznymi kolumnami |

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Świetnie! Mamy za sobą funkcje grupowania i agregacji. To był intensywny rozdział - dużo nowych pojęć.

**Podsumujmy:**

**ROLLUP** - hierarchiczne podsumowania. Używaj kiedy masz naturalną hierarchię: geografia (kraj->region->miasto), czas (rok->kwartał->miesiąc), organizacja (dział->zespół->osoba).

**CUBE** - wszystkie możliwe kombinacje. Używaj do analiz wielowymiarowych gdzie każdy wymiar może być niezależnie agregowany. Uwaga na eksplozję kombinacji!

**GROUPING SETS** - precyzyjna kontrola. Używaj kiedy wiesz dokładnie których kombinacji potrzebujesz. Najwydajniejsza opcja.

**GROUPING/GROUPING_ID** - niezbędne do rozróżnienia NULL-i i poziomów agregacji. Zawsze używaj przy ROLLUP/CUBE/GROUPING SETS.

**PIVOT/UNPIVOT** - transformacje układu. PIVOT częściej (raporty), UNPIVOT rzadziej (import danych).

**Kluczowe wnioski:**

1. Te techniki oszczędzają mnóstwo kodu. Bez ROLLUP musielibyście robić multiple UNION ALL.

2. To nie jest tylko syntactic sugar - optymalizator SQL wykonuje to wydajniej niż ręczne UNION-y.

3. W raportowaniu biznesowym to game changer. Jeden query zamiast dziesięciu.

**Pytania ogólne do tego rozdziału?**

[Pauza na pytania]

To był trudniejszy materiał. Jeśli nie wszystko jest jasne - normalne. To techniki które trzeba użyć kilka razy żeby 'wsiąkły'. Dlatego dostajecie notebooki z ćwiczeniami.

**Dobry moment na przerwę?**

Mieliśmy intensywne 45 minut. Zróbmy 10-15 minut przerwy. Po przerwie wchodzimy w Common Table Expressions - CTE. To będzie fascynujące!

Zostawiam na ekranie podsumowanie - możecie zrobić screenshot jeśli chcecie."

**Wskazówki:**
- Podsumuj kluczowe punkty
- Zapytaj o pytania
- To DOSKONAŁY moment na przerwę (ok 1.5h szkolenia)
- Po przerwie będzie CTE - nowy temat, świeże umysły

---

**KONIEC ROZDZIAŁU 3: FUNKCJE GRUPOWANIA I AGREGACJI**

Szacowany czas realizacji: 45 minut

**PRZERWA: 10-15 minut**

Następny rozdział: **Common Table Expression (CTE) - 60 minut**
