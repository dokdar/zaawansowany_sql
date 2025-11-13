# Rozdział 8: Podsumowanie i zadania domowe

**Czas trwania:** 15 minut

---

## Slajd 1: Podsumowanie szkolenia

### Treść slajdu:
```
PODSUMOWANIE SZKOLENIA
Zaawansowany SQL w Databricks

Co dziś przeszliśmy:
✓ Podstawy SQL - przypomnienie
✓ Zaawansowane funkcje grupowania (ROLLUP, CUBE, GROUPING SETS, PIVOT)
✓ Common Table Expressions (CTE) - w tym rekurencyjne
✓ Funkcje analityczne (Window Functions) - ROW_NUMBER, RANK, LAG, LEAD
✓ Funkcje użytkownika (UDF)
✓ Optymalizacja, indeksowanie, partycjonowanie
```

### Notatki dla prowadzącego:
**Czas: 3 minuty**

"Dobra robota! Przeszliśmy dziś bardzo intensywny, 5-godzinny maraton zaawansowanego SQL. Podsumujmy, co udało nam się wspólnie zrealizować."

**Przejdź przez listę punktów:**

1. **Podstawy SQL** - "Zaczęliśmy od przypomnienia podstaw - SELECT, JOIN, GROUP BY. To fundament, na którym zbudowaliśmy dalsze umiejętności."

2. **Funkcje grupowania** - "Poznaliśmy zaawansowane techniki agregacji: ROLLUP do tworzenia sum pośrednich, CUBE do wielowymiarowej analizy, GROUPING SETS do elastycznych zestawień. Nauczyliśmy się też przekształcać dane za pomocą PIVOT i UNPIVOT."

3. **CTE** - "Spędziliśmy całą godzinę na Common Table Expressions. Widzieliście, jak CTE poprawia czytelność zapytań, pozwala na ponowne wykorzystanie wyników, a przede wszystkim - jak rekurencyjne CTE rozwiązują problemy hierarchiczne, które wcześniej wydawały się niemożliwe."

4. **Funkcje analityczne** - "To była najdłuższa i chyba najbardziej ekscytująca część - 90 minut na funkcje okienkowe! Nauczyliśmy się rangować dane, liczyć sumy bieżące, średnie kroczące, porównywać wartości między wierszami. To narzędzia, które całkowicie zmieniają sposób, w jaki myślimy o analizie danych."

5. **Funkcje użytkownika** - "Zobaczyliście, jak tworzyć własne funkcje w SQL i Pythonie, by enkapsulować logikę biznesową i unikać powtarzania kodu."

6. **Optymalizacja** - "Na koniec przeszliśmy przez praktyczne aspekty produkcyjnego SQL: jak pisać wydajne zapytania, jak używać Z-ordering i partycjonowania w Databricks, jak zarządzać transakcjami i korzystać z time travel w Delta Lake."

**Podkreśl:**
"To był naprawdę intensywny dzień, ale teraz macie solidne podstawy do pracy z zaawansowanym SQL w środowisku Databricks. Nie spodziewam się, że zapamiętacie wszystko - dlatego macie te materiały do powrotu."

---

## Slajd 2: Kluczowe wnioski

### Treść slajdu:
```
KLUCZOWE WNIOSKI

1. CTE zwiększa czytelność i umożliwia rekurencję
   → Używaj zamiast zagnieżdżonych podzapytań

2. Window Functions to potęga analityczna
   → Analizy bez konieczności grupowania

3. ROLLUP/CUBE/GROUPING SETS = elastyczne raporty
   → Jeden query zamiast wielu UNION ALL

4. Databricks != SQL Server
   → Delta Lake, Z-ordering, partycjonowanie, time travel

5. Optymalizacja od początku
   → Indeksy, partycje, dobre praktyki od pierwszego dnia
```

### Notatki dla prowadzącego:
**Czas: 2 minuty**

"Jeśli mielibyście zapamiętać tylko 5 rzeczy z dzisiejszego szkolenia, niech to będą te:"

**Przejdź przez każdy punkt:**

1. **CTE** - "Przestańcie pisać zagnieżdżone podzapytania na 5 poziomów. CTE to czytelność i utrzymywalność. A rekurencyjne CTE to jedyny sensowny sposób na hierarchie w SQL."

2. **Window Functions** - "To absolutny game-changer. Kiedyś musieliśmy robić GROUP BY i tracić szczegóły. Teraz możemy liczyć agregaty zachowując każdy wiersz. ROW_NUMBER, RANK, LAG, LEAD, sumy bieżące - to wszystko, czego potrzebujecie do zaawansowanej analityki."

3. **ROLLUP/CUBE** - "Zamiast pisać 10 osobnych zapytań z UNION ALL żeby dostać różne poziomy agregacji, wystarczy jedno zapytanie z ROLLUP czy CUBE. To oszczędność czasu i wydajności."

4. **Databricks to nie SQL Server** - "Bardzo ważne! Wiele rzeczy działa inaczej. Delta Lake daje nam ACID na data lake, Z-ordering zamiast klasycznych indeksów, time travel do przywracania danych. Wykorzystujcie te możliwości, ale pamiętajcie o różnicach."

5. **Optymalizacja** - "Nie czekajcie, aż query będzie działał 10 godzin. Piszcie od razu dobrze: wybierajcie tylko potrzebne kolumny, używajcie odpowiednich indeksów, partycjonujcie duże tabele, formatujcie kod. Dobry SQL to nie tylko działający SQL."

**Pauza:**
"Dobrze, to tyle teorii. Teraz najważniejsze - praktyka!"

---

## Slajd 3: Zadania domowe - Część 1

### Treść slajdu:
```
ZADANIA DOMOWE (1/2)

Zadanie 1: Zaawansowane grupowanie
Stwórz raport sprzedaży używając CUBE, który pokaże:
- Sprzedaż według kraju i kategorii produktu
- Wszystkie możliwe kombinacje sum pośrednich
- Użyj GROUPING_ID() do identyfikacji poziomu agregacji
- Sformatuj wyniki z wyraźnym oznaczeniem sum pośrednich

Zadanie 2: Rekurencyjne CTE
Stwórz hierarchię produktów i kategorii:
- Wyobraź sobie, że kategorie mogą być zagnieżdżone
- Użyj rekurencyjnego CTE do traverse całego drzewa
- Pokaż poziom zagnieżdżenia i ścieżkę od korzenia
- BONUS: Policz liczbę produktów w każdej kategorii i podkategoriach
```

### Notatki dla prowadzącego:
**Czas: 3 minuty**

"Przygotowałem dla was zestaw zadań domowych. Jest ich 5, po jednym z każdego głównego tematu. Nie musicie ich robić wszystkich naraz, ale bardzo zachęcam, żebyście spróbowali - to najlepszy sposób na utrwalenie materiału."

**Zadanie 1: Zaawansowane grupowanie**
"To zadanie sprawdza, czy rozumiecie CUBE i GROUPING_ID. Chcę, żebyście stworzyli kompletny raport analityczny - taki, jaki mógłby iść do managera. Wszystkie poziomy agregacji w jednym zapytaniu, ładnie sformatowane."

**Podpowiedź:** "Użyjcie CUBE(ShipCountry, CategoryName), a potem GROUPING_ID do rozróżnienia, co jest sumą cząstkową, a co sumaryczną. Możecie też użyć CASE WHEN GROUPING(...) = 1 THEN 'TOTAL' ELSE ... do ładnego formatowania."

**Zadanie 2: Rekurencyjne CTE**
"To bardziej kreatywne zadanie. W Northwind kategorie są płaskie, ale wyobraźcie sobie hierarchiczną strukturę - np. 'Electronics' → 'Computers' → 'Laptops'. Stwórzcie przykładową tabelę z taką hierarchią i użyjcie rekurencyjnego CTE do jej analizy."

**Podpowiedź:** "Możecie najpierw stworzyć prostą tabelę pomocniczą:
```sql
CREATE TEMP VIEW CategoryHierarchy AS
SELECT 1 as CategoryID, 'All Products' as Name, NULL as ParentID
UNION ALL SELECT 2, 'Beverages', 1
UNION ALL SELECT 3, 'Soft Drinks', 2
UNION ALL SELECT 4, 'Alcoholic', 2;
```
A potem napisać rekurencyjne CTE do traversowania."

**Zachęta:** "Te dwa pierwsze zadania są najbardziej skomplikowane. Nie zniechęcajcie się, jeśli nie wyjdą od razu. Spróbujcie, a jak będą problemy - mamy przecież całą dokumentację z dzisiejszego szkolenia."

---

## Slajd 4: Zadania domowe - Część 2

### Treść slajdu:
```
ZADANIA DOMOWE (2/2)

Zadanie 3: Funkcje analityczne
Analiza trendów sprzedażowych:
- Dla każdego produktu: suma bieżąca sprzedaży w czasie
- Ranking produktów według sprzedaży w ramach kategorii
- Porównanie sprzedaży miesiąc do miesiąca (MoM growth)
- 3-miesięczna średnia krocząca

Zadanie 4: Optymalizacja
Zoptymalizuj ten query (zostanie podany):
- Zidentyfikuj problemy wydajnościowe
- Przepisz używając dobrych praktyk
- Zaproponuj partycjonowanie/Z-ordering
- Uzasadnij każdą zmianę

Zadanie 5: Kompletne rozwiązanie (integracyjne)
Stwórz dashboard analityczny łączący wszystkie techniki:
- CTE do przygotowania danych
- Window functions do analizy
- ROLLUP do podsumowań
- Dobra struktura i komentarze
```

### Notatki dla prowadzącego:
**Czas: 4 minuty**

**Zadanie 3: Funkcje analityczne**
"To zadanie sprawdza, czy opanowaliście funkcje okienkowe. Musicie połączyć kilka technik:"

- **Suma bieżąca:** "SUM(quantity) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)"
- **Ranking:** "ROW_NUMBER() OVER (PARTITION BY CategoryID ORDER BY TotalSales DESC)"
- **MoM growth:** "Tutaj przyda się LAG() żeby porównać z poprzednim miesiącem, a potem obliczyć procent zmiany"
- **Średnia krocząca:** "AVG(...) OVER (ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)"

"To zadanie najbardziej przypomina rzeczywiste problemy analityczne, z którymi spotykacie się w pracy. Warto je zrobić, nawet jeśli będzie trudne."

**Zadanie 4: Optymalizacja**
"Podam wam konkretny, źle napisany query do zoptymalizowania. Będzie tam wszystko, o czym mówiliśmy: SELECT *, brak WHERE przed HAVING, funkcje na indeksowanych kolumnach, brak partycjonowania."

**Przykład problematycznego query:**
```sql
-- Ten query będzie w materiałach
SELECT *
FROM Orders o
JOIN (SELECT * FROM OrderDetails) od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 2023
GROUP BY ...
HAVING COUNT(*) > 0
ORDER BY o.OrderDate
```

"Wasze zadanie: znaleźć wszystkie problemy i przepisać to optymalnie. Potem uzasadnić każdą zmianę."

**Zadanie 5: Kompletne rozwiązanie**
"To zadanie finałowe, integracyjne. Chcę, żebyście stworzyli kompletne rozwiązanie analityczne, które używa WSZYSTKIEGO, czego się dzisiaj nauczyliśmy."

**Scenariusz:** "Stwórzcie dashboard analityczny dla managera sprzedaży. Przykładowo:
1. CTE z danymi podstawowymi (sprzedaż, produkty, klienci)
2. CTE z obliczeniami analitycznymi (trendy, rankingi)
3. Window functions do analiz czasowych
4. ROLLUP do różnych poziomów agregacji
5. Wszystko ładnie sformatowane, z komentarzami

Pomyślcie o tym jak o projekcie końcowym. To pokazuje, że rozumiecie nie tylko składnię, ale i to, jak te wszystkie elementy współpracują."

**Motywacja:**
"Wiem, że to dużo pracy. Nie musicie robić wszystkiego naraz. Możecie brać po jednym zadaniu na tydzień. Ale uwierzcie mi - jeśli przejdziecie przez te zadania samodzielnie, już nigdy nie będziecie mieli problemu z zaawansowanym SQL."

---

## Slajd 5: Przykładowy query - do optymalizacji (Zadanie 4)

### Treść slajdu:
```sql
-- ZADANIE 4: Zoptymalizuj ten query

SELECT *
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE YEAR(o.OrderDate) = 2023
  AND MONTH(o.OrderDate) BETWEEN 1 AND 6
  AND UPPER(c.CategoryName) LIKE '%BEV%'
GROUP BY o.CustomerID, c.CategoryName, YEAR(o.OrderDate), MONTH(o.OrderDate)
HAVING SUM(od.Quantity * od.UnitPrice) > 0
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);

-- Pytania:
-- 1. Jakie są problemy wydajnościowe?
-- 2. Jak można to przepisać lepiej?
-- 3. Jakie indeksy/partycjonowanie zaproponujesz?
-- 4. Czy wszystkie warunki są sensowne?
```

### Notatki dla prowadzącego:
**Czas: 2 minuty**

"To jest konkretny query do zadania 4. Wyświetlam go teraz, żebyście mogli sobie zrobić screenshot albo skopiować. Jest też w materiałach."

**Wskaż problemy (ale nie wszystkie - niech sami znajdą):**

1. **SELECT *** - "Pierwsze co rzuca się w oczy. Pobieramy wszystkie kolumny, a potem grupujemy. To nie ma sensu."

2. **YEAR() i MONTH() na kolumnie w WHERE** - "Funkcje na kolumnach w WHERE uniemożliwiają użycie indeksów."

3. **UPPER() w LIKE** - "Znowu funkcja w WHERE. Jeśli CategoryName jest indeksowane, to indeks się nie użyje."

4. **HAVING SUM(...) > 0** - "Ten warunek jest praktycznie zawsze prawdziwy, chyba że są ujemne wartości. Czy to potrzebne?"

5. **Brak partycjonowania** - "Dla dużej tabeli Orders, partycjonowanie po dacie znacznie by pomogło."

**Podpowiedź do rozwiązania:**
"Pomyślcie jak przepisać to używając:
- Konkretnych kolumn zamiast SELECT *
- Zakresu dat zamiast YEAR() i MONTH()
- Dokładnego porównania zamiast UPPER() i LIKE
- Może ten HAVING w ogóle usunąć?
- Partycjonowania tabeli Orders po dacie
- Z-ordering na często filtrowanych kolumnach"

**Nie podawaj pełnego rozwiązania!** "Zostawiam wam to jako wyzwanie. W materiałach macie wszystkie narzędzia potrzebne do rozwiązania."

---

## Slajd 6: Zasoby do dalszej nauki

### Treść slajdu:
```
ZASOBY DO DALSZEJ NAUKI

📚 Dokumentacja oficjalna:
• Databricks SQL Reference: docs.databricks.com/sql
• Delta Lake Guide: docs.delta.io
• Apache Spark SQL: spark.apache.org/sql

💡 Praktyka:
• Databricks Community Edition (darmowa!)
• SQLZoo, LeetCode, HackerRank - SQL challenges
• Kaggle datasets do eksperymentowania

📖 Książki:
• "SQL Performance Explained" - Markus Winand
• "The Art of SQL" - Stephane Faroult

🎯 Następne kroki:
• Performance tuning zaawansowany
• Spark optimization strategies
• Real-time streaming SQL
```

### Notatki dla prowadzącego:
**Czas: 1 minuta**

"Zanim zakończymy, chcę wam pokazać kilka zasobów do dalszej nauki."

**Dokumentacja:**
"Przede wszystkim - oficjalna dokumentacja Databricks i Delta Lake. Jest bardzo dobra, z przykładami. Wracajcie do niej regularnie."

**Praktyka:**
"Najważniejsze: praktyka! Databricks ma darmową Community Edition - możecie ćwiczyć wszystko, czego się dzisiaj nauczyliśmy. Polecam też platformy z wyzwaniami SQL - LeetCode i HackerRank mają świetne sekcje SQL."

**Książki:**
"Jeśli lubicie książki - 'SQL Performance Explained' to biblia optymalizacji. Krótka, konkretna, pełna przykładów."

**Następne kroki:**
"Jeśli chcielibyście pogłębić wiedzę, polecam kursy o:
- Zaawansowanej optymalizacji Spark
- Real-time streaming w SQL (Structured Streaming)
- Machine learning w SQL (Databricks ML)"

---

## Slajd 7: Pytania i odpowiedzi

### Treść slajdu:
```
PYTANIA I ODPOWIEDZI

Czas na wasze pytania!

💬 Możecie pytać o:
• Wyjaśnienie konkretnych koncepcji
• Jak zastosować to w waszej pracy
• Sugestie do dalszej nauki
• Rekomendacje narzędzi

Dziękuję za uwagę i aktywny udział! 🎉
```

### Notatki dla prowadzącego:
**Czas: Pozostały czas (elastycznie)**

"Dobra, to już koniec przygotowanego materiału. Teraz czas na was - macie jakieś pytania?"

**Moderowanie Q&A:**

**Bądź przygotowany na typowe pytania:**

1. **"Czy to wszystko działa na innych platformach niż Databricks?"**
   - "Większość rzeczy tak! CTE, window functions, ROLLUP/CUBE to standard SQL. Ale Delta Lake, Z-ordering - to specyfika Databricks. Na SQL Server mielibyście klasyczne indeksy, na PostgreSQL inne mechanizmy."

2. **"Które z tych rzeczy używasz najczęściej w praktyce?"**
   - "Window functions bez dwóch zdań. To codzienne narzędzie. CTE też bardzo często - kod jest po prostu czytelniejszy. ROLLUP/CUBE rzadziej, ale jak trzeba zrobić raport analityczny, to oszczędzają godziny pracy."

3. **"Jak długo zajmie mi opanowanie tego wszystkiego?"**
   - "Zależy od praktyki. Podstawy window functions - tydzień, dwa. Rekurencyjne CTE - trochę dłużej, to wymaga innego myślenia. Ale najważniejsze - zaczynajcie używać od zaraz. Nawet proste ROW_NUMBER() czy LAG() już daje wartość."

4. **"Co powinienem nauczyć się następne?"**
   - "Jeśli SQL już dobrze opanujecie - polecam poznać Spark i jego optymalizację. Albo przejść w stronę danych strumieniowych. Albo machine learning - Databricks ma świetne integracje z ML."

**Zamknięcie:**
"Jeśli nie ma więcej pytań - to oficjalnie kończymy! Mam nadzieję, że było wartościowo. Wszystkie materiały macie w repozytorium - prezentacje, notebooki, zadania. Powodzenia z zadaniami domowymi i trzymam kciuki za waszą przygodę z zaawansowanym SQL!"

**Podziękowanie:**
"Dziękuję wam za uwagę, zaangażowanie i wszystkie świetne pytania podczas szkolenia. To była przyjemność! Powodzenia! 🎉"

---

## Dodatek: Szczegółowe specyfikacje zadań domowych

### Zadanie 1: Zaawansowane grupowanie (CUBE)

**Opis:**
Stwórz kompletny raport sprzedażowy pokazujący:
- Wartość sprzedaży według kraju dostawy i kategorii produktu
- Wszystkie poziomy agregacji (kraj, kategoria, łącznie)
- Wyraźne oznaczenie sum częściowych i całkowitych
- Posortowane wyniki

**Wymagania techniczne:**
- Użyj CUBE(ShipCountry, CategoryName)
- Użyj GROUPING_ID() do identyfikacji poziomu agregacji
- Sformatuj nazwy używając CASE WHEN z GROUPING()
- Zaokrąglij wartości finansowe do 2 miejsc po przecinku

**Przykładowy wynik:**
```
ShipCountry  | CategoryName | TotalSales | AggLevel
-------------|--------------|------------|----------
Germany      | Beverages    | 15000.00   | Detail
Germany      | Dairy        | 12000.00   | Detail
Germany      | TOTAL        | 27000.00   | Country
France       | Beverages    | 18000.00   | Detail
TOTAL        | Beverages    | 33000.00   | Category
TOTAL        | TOTAL        | 100000.00  | Grand Total
```

**Wskazówki:**
- Bazuj na tabelach Orders, OrderDetails, Products, Categories
- Użyj SUM(od.Quantity * od.UnitPrice) jako wartość sprzedaży
- GROUPING_ID(ShipCountry, CategoryName) da wartości: 0 (szczegół), 1 (suma po kraju), 2 (suma po kategorii), 3 (suma całkowita)

---

### Zadanie 2: Rekurencyjne CTE - Hierarchia

**Opis:**
Stwórz i przeanalizuj hierarchiczną strukturę kategorii produktów.

**Krok 1: Stwórz hierarchię**
```sql
CREATE OR REPLACE TEMP VIEW ProductCategoryHierarchy AS
SELECT 1 as CategoryID, 'All Products' as CategoryName, NULL as ParentCategoryID, 0 as Level
UNION ALL SELECT 2, 'Food & Beverages', 1, 1
UNION ALL SELECT 3, 'Beverages', 2, 2
UNION ALL SELECT 4, 'Soft Drinks', 3, 3
UNION ALL SELECT 5, 'Alcoholic Beverages', 3, 3
-- Dodaj więcej poziomów według uznania
```

**Krok 2: Napisz rekurencyjne CTE**
Które:
- Przechodzi całe drzewo od korzenia
- Pokazuje poziom zagnieżdżenia
- Tworzy ścieżkę (np. "All Products > Food > Beverages > Soft Drinks")
- Liczy produkty w każdej kategorii (łącznie z podkategoriami)

**Wymagania:**
- Anchor member: kategorie bez rodzica (ParentCategoryID IS NULL)
- Recursive member: dołączanie dzieci
- Użyj CONCAT do budowania ścieżki
- BONUS: Policz liczbę produktów używając LEFT JOIN do tabeli Products

**Oczekiwany wynik:**
```
CategoryName        | Level | Path                                    | ProductCount
--------------------|-------|-----------------------------------------|-------------
All Products        | 0     | All Products                            | 77
Food & Beverages    | 1     | All Products > Food & Beverages         | 50
Beverages           | 2     | All Products > Food & Beverages > ...   | 12
Soft Drinks         | 3     | All Products > ... > Soft Drinks        | 5
```

---

### Zadanie 3: Funkcje analityczne - Analiza trendów

**Opis:**
Przeprowadź kompleksową analizę sprzedażową produktów używając funkcji okienkowych.

**Wymagane analizy:**

1. **Suma bieżąca sprzedaży**
   - Dla każdego produktu: skumulowana wartość sprzedaży w czasie
   - PARTITION BY ProductID, ORDER BY OrderDate

2. **Ranking produktów w kategorii**
   - ROW_NUMBER() dla unikalnego rankingu
   - RANK() pokazujący ex-aequo
   - PARTITION BY CategoryID, ORDER BY TotalSales DESC

3. **Porównanie miesiąc do miesiąca (MoM)**
   - Użyj LAG() do pobrania wartości z poprzedniego miesiąca
   - Oblicz procentową zmianę: ((current - previous) / previous) * 100
   - PARTITION BY ProductID, ORDER BY Year, Month

4. **Średnia krocząca 3-miesięczna**
   - AVG() OVER z ramką okna
   - ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
   - Pokazuje wygładzone trendy

**Wskazówki:**
- Zacznij od CTE, które agreguje sprzedaż miesięczną
- Użyj DATE_TRUNC('month', OrderDate) do grupowania
- Wszystkie analizy możesz połączyć w jednym finalnym query z wieloma kolumnami okienkowymi

---

### Zadanie 4: Optymalizacja - Szczegółowa analiza

**Problemy w oryginalnym query:**

```sql
-- ORYGINALNY QUERY (zły)
SELECT *
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE YEAR(o.OrderDate) = 2023
  AND MONTH(o.OrderDate) BETWEEN 1 AND 6
  AND UPPER(c.CategoryName) LIKE '%BEV%'
GROUP BY o.CustomerID, c.CategoryName, YEAR(o.OrderDate), MONTH(o.OrderDate)
HAVING SUM(od.Quantity * od.UnitPrice) > 0
ORDER BY YEAR(o.OrderDate), MONTH(o.OrderDate);
```

**Znalezione problemy (do zidentyfikowania):**
1. SELECT * przy GROUP BY - pobiera wszystkie kolumny, ale nie wiadomo które
2. YEAR() i MONTH() w WHERE - funkcje na indeksowanej kolumnie
3. UPPER() i LIKE z wildcardami - nie używa indeksów
4. HAVING SUM(...) > 0 - zbędny warunek
5. Brak specyfikacji kolumn w SELECT
6. Powtarzanie YEAR/MONTH w GROUP BY i ORDER BY

**Zadanie:**
- Przepisz query usuwając wszystkie problemy
- Zaproponuj strukturę partycjonowania dla tabeli Orders
- Zaproponuj Z-ordering dla często filtrowanych kolumn
- Napisz uzasadnienie każdej zmiany

**Oczekiwane rozwiązanie powinno zawierać:**
- Konkretne kolumny w SELECT
- Zakres dat zamiast YEAR()/MONTH()
- Dokładne porównanie zamiast UPPER() LIKE
- Usunięcie zbędnego HAVING
- Sugestie: PARTITIONED BY (YEAR(OrderDate), MONTH(OrderDate))
- Sugestie: OPTIMIZE ... ZORDER BY (CustomerID, CategoryID)

---

### Zadanie 5: Projekt integracyjny - Dashboard analityczny

**Scenariusz:**
Dyrektor sprzedaży potrzebuje comiesięcznego dashboard z kluczowymi metrykami sprzedażowymi.

**Wymagania funkcjonalne:**

1. **Przygotowanie danych (CTE)**
   - CTE #1: Agregacja sprzedaży miesięcznej (produkty, kategorie, kraje)
   - CTE #2: Obliczenia analityczne (trendy, rankingi)
   - CTE #3: Podsumowania wielopoziomowe (ROLLUP)

2. **Analityka (Window Functions)**
   - Ranking top 10 produktów w każdym miesiącu
   - Trend MoM dla każdej kategorii
   - Porównanie z średnią (każdy produkt vs średnia w kategorii)
   - Identyfikacja rosnących/spadających trendów

3. **Podsumowania (ROLLUP/CUBE)**
   - Sprzedaż według: kraju, kategorii, miesiąca
   - Sumy częściowe na każdym poziomie
   - Suma całkowita

4. **Jakość kodu**
   - Czytelne nazwy CTE i kolumn
   - Komentarze wyjaśniające logikę
   - Odpowiednie formatowanie
   - Optymalne użycie funkcji

**Struktura rozwiązania:**

```sql
-- Dashboard sprzedażowy - [Twoje Imię]
-- Data: [Data]
-- Opis: Comiesięczny raport dla dyrekcji

-- CTE 1: Dane podstawowe
WITH MonthlySales AS (
  -- Agregacja sprzedaży miesięcznej
  ...
),

-- CTE 2: Metryki analityczne
SalesMetrics AS (
  -- Obliczenia trendów, rankingów
  ...
),

-- CTE 3: Podsumowania wielopoziomowe
SalesSummaries AS (
  -- ROLLUP lub CUBE
  ...
)

-- Finalny SELECT łączący wszystko
SELECT ...
FROM ...
```

**Kryteria oceny (samoocena):**
- ✅ Czy używam wszystkich poznanych technik?
- ✅ Czy wyniki są poprawne i sensowne?
- ✅ Czy kod jest czytelny i dobrze skomentowany?
- ✅ Czy ktoś inny zrozumiałby ten kod bez mojej pomocy?
- ✅ Czy zastosowałem dobre praktyki SQL?

---

## Podsumowanie dla prowadzącego

To był ostatni slajd szkolenia. Pamiętaj:

1. **Bądź entuzjastyczny** - to koniec intensywnego dnia, ale uczestnicy powinni czuć się zmotywowani, nie przytłoczeni
2. **Podkreśl dostępność materiałów** - wszystko mają w repo, mogą wracać
3. **Zachęć do zadań domowych** - ale bez presji, to dla ich rozwoju
4. **Zostaw otwarte drzwi** - mogą pytać później przez email/Slack
5. **Podziękuj za zaangażowanie** - to było wymagające szkolenie

**Całkowity czas:** ~300 minut (5 godzin)
- Sprawy organizacyjne: 15 min
- Podstawy SQL: 30 min
- Funkcje grupowania: 45 min
- CTE: 60 min
- Funkcje analityczne: 90 min ⭐
- Funkcje użytkownika: 30 min
- Optymalizacja i best practices: 45 min
- Podsumowanie: 15 min

**Powodzenia! 🎉**
