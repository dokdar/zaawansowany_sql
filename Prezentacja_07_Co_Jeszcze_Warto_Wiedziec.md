# CO JESZCZE WARTO WIEDZIEĆ
## Optymalizacja, Best Practices, Produkcyjne Tips

---

# AGENDA SEKCJI

## Co omówimy (45 minut):

1. **Optymalizacja zapytań** - jak pisać szybki SQL (10 min)
2. **Indeksowanie** - co to jest i jak działa (10 min)
3. **Partycjonowanie** - podział danych dla wydajności (10 min)
4. **Transakcje** - ACID properties i praktyka (8 min)
5. **Best Practices** - zasady profesjonalnego SQL (7 min)

**Cel:** Praktyczne wskazówki które przydadzą się w codziennej pracy.

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Dobra, jesteśmy na finiszu! Ostatnia merytoryczna sekcja - 'Co jeszcze warto wiedzieć'. To będzie 45 minut praktycznych wskazówek które pomogą Wam w codziennej pracy.

Do tej pory uczyliśmy się technik SQL - CTE, window functions, itd. Teraz pokażę jak pisać SQL który jest:
- **Szybki** - optymalizacja
- **Skalowalny** - indeksy, partycjonowanie
- **Niezawodny** - transakcje
- **Profesjonalny** - best practices

To nie będzie głęboki dive techniczny - to overview najważniejszych tematów. Jeśli coś Was zainteresuje, możecie pogłębiać indywidualnie.

Zaczynamy od optymalizacji zapytań - jak sprawić żeby SQL był szybki!"

**Wskazówki:**
- To praktyczna sekcja - podkreśl użyteczność
- Zapowiedz że będzie overview, nie deep dive
- Entuzjazm - finiszujemy!

---

# OPTYMALIZACJA ZAPYTAŃ

## Podstawowe zasady:

1. **SELECT tylko potrzebne kolumny** - nie `SELECT *`
2. **WHERE zamiast HAVING** gdzie możliwe
3. **Unikaj funkcji na kolumnach indeksowanych w WHERE**
4. **Używaj EXISTS zamiast IN dla dużych zbiorów**
5. **LIMIT wyników** w testach
6. **Analizuj plan wykonania**

## Przykład - źle vs dobrze:

**Źle:**
```sql
SELECT * FROM Orders WHERE YEAR(OrderDate) = 1997;
```

**Dobrze:**
```sql
SELECT OrderID, CustomerID, OrderDate, Freight
FROM Orders
WHERE OrderDate >= '1997-01-01' AND OrderDate < '1998-01-01';
```

---

# NOTATKI DLA PROWADZĄCEGO - OPTYMALIZACJA

**Czas trwania:** 8-10 minut

**Co powiedzieć:**
"Optymalizacja zapytań - jak sprawić żeby SQL był szybki. To kluczowe w produkcji, gdzie macie miliony rekordów.

**Zasada 1: SELECT tylko to co potrzebujecie**

Źle:
```sql
SELECT * FROM Orders;  -- pobiera wszystkie kolumny
```

Dobrze:
```sql
SELECT OrderID, CustomerID, OrderDate FROM Orders;
```

Czemu? `SELECT *`:
- Pobiera kolumny których nie używacie (marnuje bandwidth, pamięć)
- Jeśli ktoś doda kolumnę do tabeli, Wasze zapytanie zmienia się (breaking change!)
- Optymalizator nie wie czego naprawdę potrzebujecie

W małej bazie różnica niewielka. W produkcji z milionami wierszy - ogromna!

**Zasada 2: WHERE zamiast HAVING**

WHERE filtruje PRZED grupowaniem, HAVING PO. WHERE jest szybsze.

Źle:
```sql
SELECT CategoryID, SUM(UnitPrice)
FROM Products
GROUP BY CategoryID
HAVING CategoryID IN (1, 2, 3);  -- filtr po grupowaniu
```

Dobrze:
```sql
SELECT CategoryID, SUM(UnitPrice)
FROM Products
WHERE CategoryID IN (1, 2, 3)  -- filtr przed grupowaniem
GROUP BY CategoryID;
```

Mniej wierszy do grupowania = szybciej.

**Zasada 3: Unikaj funkcji na kolumnach w WHERE**

To jest KILLER performance issue!

Źle:
```sql
SELECT * FROM Orders
WHERE YEAR(OrderDate) = 1997;  -- funkcja na kolumnie!
```

Czemu źle? Dla każdego wiersza SQL musi wywołać YEAR(). Indeks na OrderDate nie działa!

Dobrze:
```sql
SELECT * FROM Orders
WHERE OrderDate >= '1997-01-01'
  AND OrderDate < '1998-01-01';  -- zakres bez funkcji
```

Teraz indeks na OrderDate może być użyty. O rzędy wielkości szybciej!

Inne przykłady:

Źle:
```sql
WHERE UPPER(ProductName) = 'CHAI'  -- funkcja!
WHERE UnitPrice * 1.23 > 50  -- obliczenie!
```

Dobrze:
```sql
WHERE ProductName = 'Chai'  -- bez funkcji (lub case-insensitive collation)
WHERE UnitPrice > 50/1.23  -- obliczenie po drugiej stronie
```

**Zasada 4: EXISTS vs IN**

Dla dużych zbiorów, EXISTS jest często szybsze niż IN:

Wolniejsze (dla dużych list):
```sql
SELECT * FROM Products
WHERE SupplierID IN (SELECT SupplierID FROM Suppliers WHERE Country = 'USA');
```

Szybsze:
```sql
SELECT * FROM Products p
WHERE EXISTS (
    SELECT 1 FROM Suppliers s
    WHERE s.SupplierID = p.SupplierID
      AND s.Country = 'USA'
);
```

EXISTS kończy po znalezieniu pierwszego dopasowania. IN musi sprawdzić całą listę.

**Zasada 5: LIMIT w testach**

Podczas testowania zapytań ZAWSZE używajcie LIMIT:

```sql
SELECT ... FROM huge_table
WHERE ...
LIMIT 100;  -- testuj na małym zbiorze!
```

Nie chcecie czekać 10 minut żeby zobaczyć że zapytanie ma błąd!

**Zasada 6: Analizuj plan wykonania**

Databricks/Spark pokazuje plan wykonania:

```sql
EXPLAIN SELECT * FROM Orders WHERE OrderDate > '1997-01-01';
```

To pokazuje jak SQL wykonuje zapytanie - jakie operacje, w jakiej kolejności. Zaawansowane, ale czasem jedyny sposób żeby zrozumieć czemu zapytanie jest wolne.

**Szybki test: EXPLAIN**

[Możesz uruchomić]

```sql
-- Proste zapytanie
EXPLAIN
SELECT ProductName, UnitPrice
FROM Products
WHERE CategoryID = 1;
```

Widzicie plan - FileScan, Filter, Project. Dla małej tabeli to proste. Dla złożonych JOIN-ów to może być 50-liniowy plan.

**Cache w Databricks:**

Jeśli ta sama tabela jest używana wielokrotnie, możecie ją cache-ować:

```sql
CACHE TABLE Products;

-- Teraz zapytania na Products będą szybsze (dane w pamięci)

-- Po skończeniu:
UNCACHE TABLE Products;
```

Przydatne w notebookach gdzie robicie wiele analiz na tej samej tabeli.

Pytania do optymalizacji?"

**Wskazówki:**
- Konkretne przykłady źle/dobrze - ludzie zapamiętują
- Funkcje w WHERE to najczęstszy błąd - podkreśl!
- EXPLAIN to zaawansowane ale warto wspomnieć
- Nie wchodź za głęboko - to overview

---

# INDEKSOWANIE

## Co to jest indeks?

Indeks to struktura danych która przyspiesza wyszukiwanie.

**Analogia:** Indeks w książce - zamiast czytać całą książkę, patrzysz w indeks i skaczesz na właściwą stronę.

## W SQL:
```sql
-- Klasyczny SQL (SQL Server, PostgreSQL)
CREATE INDEX idx_products_category ON Products(CategoryID);
CREATE INDEX idx_orders_date ON Orders(OrderDate);
```

## W Databricks:
**Databricks używa Delta Lake** - zamiast klasycznych indeksów:
- **Z-Ordering** - optymalizacja układu danych
- **Data Skipping** - automatyczne pomijanie plików
- **Liquid Clustering** (nowa funkcja) - automatyczne klastrowanie

---

# NOTATKI DLA PROWADZĄCEGO - INDEKSOWANIE

**Czas trwania:** 8-10 minut

**Co powiedzieć:**
"Indeksowanie - jak sprawić żeby wyszukiwanie było szybkie. To fundamentalne narzędzie optymalizacji.

**Co to jest indeks?**

Wyobraźcie sobie książkę bez indeksu. Szukacie słowa 'rekurencja'. Musicie przeczytać CAŁĄ książkę od deski do deski. Długo!

Książka Z indeksem: Patrzcie w indeks -> 'rekurencja: strona 247' -> skaczecie na 247. Sekundy!

**W bazach danych podobnie:**

Bez indeksu:
```sql
SELECT * FROM Products WHERE CategoryID = 3;
```
SQL musi przeczytać WSZYSTKIE 77 wierszy, sprawdzić każdy CategoryID. To **Full Table Scan** - wolne dla dużych tabel.

Z indeksem na CategoryID:
SQL patrzy w indeks -> 'CategoryID=3: wiersze 15,16,17,23,24...' -> czyta tylko te wiersze. **Index Seek** - szybkie!

**Klasyczne indeksy (SQL Server, MySQL, PostgreSQL):**

```sql
-- Tworzenie indeksu
CREATE INDEX idx_products_category ON Products(CategoryID);

-- Indeks wielokolumnowy
CREATE INDEX idx_orders_customer_date ON Orders(CustomerID, OrderDate);

-- Unikalny indeks
CREATE UNIQUE INDEX idx_products_name ON Products(ProductName);
```

Indeks przyspiesza WHERE, JOIN, ORDER BY na tych kolumnach.

**ALE... Databricks jest inny!**

Databricks używa **Delta Lake** - to nie klasyczna relacyjna baza. Dane są przechowywane w plikach Parquet, nie w B-tree structures jak tradycyjne bazy.

**Zamiast klasycznych indeksów, Databricks ma:**

**1. Z-Ordering:**

Optymalizuje fizyczny układ danych w plikach.

```sql
OPTIMIZE Products
ZORDER BY (CategoryID);
```

To reorganizetuje dane tak żeby wiersze z tym samym CategoryID były blisko siebie w plikach. Przyszłe zapytania filtrujące po CategoryID są szybsze.

**Kiedy używać:** Kolumny często używane w WHERE i JOIN.

**2. Data Skipping:**

Delta automatycznie śledzi min/max wartości w każdym pliku. Kiedy robicie:

```sql
SELECT * FROM Orders WHERE OrderDate = '1997-05-01';
```

Delta sprawdza: "Plik A ma OrderDate od 1996-01-01 do 1996-12-31 - SKIP!"
"Plik B ma OrderDate od 1997-04-01 do 1997-06-30 - CZYTAJ!"

Automatyczne, nie musicie nic robić!

**3. Liquid Clustering (nowość w Databricks):**

Nowa funkcja (2023+) - automatyczne klastrowanie danych:

```sql
CREATE TABLE orders_clustered (...)
CLUSTER BY (CustomerID, OrderDate);
```

Delta automatycznie optymalizuje układ dla tych kolumn. To jak Z-Ordering ale automatyczne i inteligentniejsze.

**Porównanie: Tradycyjne DB vs Databricks:**

| SQL Server/PostgreSQL | Databricks Delta Lake |
|-----------------------|-----------------------|
| CREATE INDEX | OPTIMIZE ... ZORDER BY |
| B-tree indeksy | Parquet + data skipping |
| Manual maintenance | Automatyczna optymalizacja |
| Dla małych-średnich danych | Dla big data |

**Przykład OPTIMIZE:**

```sql
-- Optymalizacja tabeli Products
OPTIMIZE Products;

-- Z Z-Ordering
OPTIMIZE Products
ZORDER BY (CategoryID, SupplierID);
```

[Możesz uruchomić to na Orders - potrwa chwilę]

To łączy małe pliki w większe i reorganizetuje dane. Przyszłe zapytania są szybsze.

**Kiedy robić OPTIMIZE:**

- Po dużych INSERT/UPDATE/DELETE
- Regularnie dla często używanych tabel (cron job)
- Przed ważnymi analizami

**Koszt indeksów:**

Zarówno klasyczne indeksy jak Z-Ordering mają koszt:
- ❌ Wolniejsze INSERT/UPDATE/DELETE (muszą aktualizować indeks)
- ❌ Zajmują miejsce na dysku
- ✅ Szybsze SELECT

Więc nie indeksujcie wszystkiego! Tylko kolumny często używane w WHERE/JOIN.

Pytania do indeksowania?"

**Wskazówki:**
- Wyjaśnij różnicę klasyczne DB vs Databricks - kluczowe!
- Z-Ordering to Databricks equivalent indeksów
- Data skipping jest automatyczne - fajny bonus
- Podkreśl koszty indeksów

---

# PARTYCJONOWANIE

## Co to jest partycjonowanie?

Podział dużej tabeli na mniejsze, łatwiejsze do zarządzania części (partycje).

## W Databricks Delta:
```sql
-- Tworzenie partycjonowanej tabeli
CREATE TABLE orders_partitioned (
    OrderID INT,
    CustomerID STRING,
    OrderDate DATE,
    ...
)
USING DELTA
PARTITIONED BY (YEAR(OrderDate));
```

Dane są fizycznie zapisane w osobnych folderach per rok:
```
/orders_partitioned/year=1996/...
/orders_partitioned/year=1997/...
/orders_partitioned/year=1998/...
```

**Korzyść:** Zapytanie tylko dla 1997 czyta tylko folder 1997!

---

# NOTATKI DLA PROWADZĄCEGO - PARTYCJONOWANIE

**Czas trwania:** 8-10 minut

**Co powiedzieć:**
"Partycjonowanie - podział danych na mniejsze kawałki. To kluczowe dla big data!

**Wyobraźcie sobie bibliotekę:**

Bez partycji: Wszystkie książki w jednej ogromnej sali. Szukacie książki z 2020 roku - musicie przejrzeć CAŁĄ salę.

Z partycjami: Książki podzielone na sale według roku. Sala 2015, 2016, 2017... Szukacie książki z 2020? Idziecie do sali '2020'. Szybko!

**W bazach danych tak samo:**

Duża tabela Orders (10 milionów wierszy). Często filtrujeszkształtu OrderDate. Bez partycjonowania - SQL musi przeskanować 10M wierszy.

Z partycjonowaniem po roku:
```
year=1996: 100k wierszy
year=1997: 200k wierszy
year=1998: 150k wierszy
...
year=2023: 500k wierszy
```

Zapytanie:
```sql
SELECT * FROM Orders WHERE OrderDate >= '2023-01-01';
```

SQL czyta TYLKO partycję year=2023 (500k wierszy zamiast 10M). **Partition pruning** - automatyczne pomijanie partycji.

**W Databricks Delta:**

```sql
-- Tworzenie partycjonowanej tabeli
CREATE TABLE orders_partitioned (
    OrderID INT,
    CustomerID STRING,
    OrderDate DATE,
    Freight DECIMAL(10,2)
)
USING DELTA
PARTITIONED BY (YEAR(OrderDate), MONTH(OrderDate));
```

Dane będą zapisane w strukturze folderów:
```
/orders_partitioned/
  year=1996/month=1/...parquet files
  year=1996/month=2/...parquet files
  year=1997/month=1/...parquet files
  ...
```

**Przykład - INSERT do partycjonowanej tabeli:**

```sql
-- Wstawianie danych
INSERT INTO orders_partitioned
SELECT OrderID, CustomerID, OrderDate, Freight
FROM Orders;
```

Delta automatycznie rozdziela wiersze do właściwych partycji!

**Query z partition pruning:**

```sql
-- Tylko styczeń 1997
SELECT * FROM orders_partitioned
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 1;
```

Delta czyta tylko `/year=1997/month=1/` - pomija resztę!

[Możesz pokazać EXPLAIN żeby zobaczyli partition pruning]

**Dobre praktyki partycjonowania:**

✅ **Partycjonuj po kolumnie często używanej w WHERE:**
- Daty (rok, miesiąc) - najczęstsze
- Region geograficzny
- Typ użytkownika

✅ **Nie przesadzaj z liczbą partycji:**
- Databricks rekomenduje: każda partycja min 1GB
- Tysiące małych partycji (< 100MB) = WOLNO (overhead)

❌ **Nie partycjonuj po high-cardinality kolumnach:**
- User ID - miliony partycji = źle
- Timestamp (sekundy) - miliony partycji = źle

✅ **Dobre:**
- Rok/Miesiąc - dziesiątki/setki partycji
- Region - kilka/kilkadziesiąt partycji
- Kategoria - kilka partycji

**Przykład zły:**

```sql
-- ŹLE! Timestamp co sekundę = miliony partycji
PARTITIONED BY (OrderDate)  -- gdzie OrderDate to TIMESTAMP
```

**Przykład dobry:**

```sql
-- DOBRZE! Rok+Miesiąc = ~50 partycji dla 4 lat danych
PARTITIONED BY (YEAR(OrderDate), MONTH(OrderDate))
```

**Partycjonowanie vs Z-Ordering:**

| Partycjonowanie | Z-Ordering |
|-----------------|------------|
| Fizycznie oddzielne foldery | Reorganizacja w ramach plików |
| Dla kolumn low-cardinality | Dla kolumn any-cardinality |
| Partition pruning (pominięcie partycji) | Data skipping (pominięcie wierszy) |
| PARTITION BY w CREATE TABLE | OPTIMIZE ... ZORDER BY |

Możecie używać OBIE techniki razem!

```sql
-- Partycjonowanie + Z-Ordering
CREATE TABLE orders_optimized (...)
PARTITIONED BY (YEAR(OrderDate));

OPTIMIZE orders_optimized
ZORDER BY (CustomerID);
```

Teraz macie:
- Partition pruning po roku
- Z-Ordering po CustomerID w ramach każdej partycji

**Repartitioning istniejącej tabeli:**

Niestety nie można zmienić partycjonowania istniejącej tabeli. Musicie stworzyć nową:

```sql
-- Nowa partycjonowana tabela
CREATE TABLE orders_new (...)
PARTITIONED BY (YEAR(OrderDate));

-- Przepisanie danych
INSERT INTO orders_new SELECT * FROM orders_old;

-- Zamiana tabel
DROP TABLE orders_old;
ALTER TABLE orders_new RENAME TO orders;
```

**Sprawdzanie partycji:**

```sql
-- Pokaż partycje
SHOW PARTITIONS orders_partitioned;

-- Statystyki per partycja
DESCRIBE EXTENDED orders_partitioned;
```

Pytania do partycjonowania?"

**Wskazówki:**
- Analogia z biblioteką pomaga zrozumieć
- Podkreśl partition pruning - główna korzyść
- Ostrzeż przed over-partitioning - częsty błąd
- Pokaż różnicę vs Z-Ordering

---

# TRANSAKCJE

## ACID Properties:

- **Atomicity** - wszystko albo nic
- **Consistency** - dane zawsze spójne
- **Isolation** - transakcje nie kolidują
- **Durability** - zatwierdzone zmiany są trwałe

## W Databricks Delta Lake:

Delta Lake wspiera transakcje ACID!

```sql
-- Każda operacja to transakcja
INSERT INTO Products VALUES (...);  -- atomowa

-- Jeśli błąd - automatyczny rollback
-- Jeśli sukces - automatyczny commit
```

**Delta Lake journal** śledzi wszystkie zmiany - możliwy time travel!

```sql
-- Zobacz wersje tabeli
DESCRIBE HISTORY Products;

-- Przywróć starą wersję
RESTORE TABLE Products TO VERSION AS OF 10;
```

---

# NOTATKI DLA PROWADZĄCEGO - TRANSAKCJE

**Czas trwania:** 6-8 minut

**Co powiedzieć:**
"Transakcje - jak zapewnić spójność danych. To fundament niezawodnych systemów.

**ACID - cztery właściwości transakcji:**

**Atomicity (Atomowość):**
Transakcja to wszystko albo nic. Albo wszystkie operacje się udają, albo żadna.

Przykład: Przelew bankowy.
```sql
BEGIN TRANSACTION;
  UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;  -- odejmij
  UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;  -- dodaj
COMMIT;
```

Jeśli pierwsze UPDATE się uda, ale drugie failuje (błąd, brak połączenia) - ROLLBACK. Oba się cofają. Nie zgubicie 100 zł w eterze!

**Consistency (Spójność):**
Dane zawsze spełniają reguły (constraints, foreign keys).

Nie możecie dodać Order z CustomerID który nie istnieje (jeśli jest foreign key).

**Isolation (Izolacja):**
Dwie równoczesne transakcje nie kolidują. Każda widzi spójny stan.

User A i User B jednocześnie robią SELECT -> UPDATE. Isolation zapewnia że jeden nie nadpisze drugiego przypadkowo.

**Durability (Trwałość):**
Jak transakcja jest COMMITnięta, dane są zapisane NA ZAWSZE. Nawet jeśli server crashuje sekundę później.

**W klasycznym SQL (SQL Server, PostgreSQL):**

```sql
BEGIN TRANSACTION;

INSERT INTO Orders (...) VALUES (...);
INSERT INTO `Order Details` (...) VALUES (...);

-- Jeśli wszystko ok:
COMMIT;

-- Jeśli błąd:
ROLLBACK;
```

Macie pełną kontrolę nad transakcjami.

**W Databricks Delta Lake - inaczej!**

Delta Lake automatycznie opakowuje operacje w transakcje:

```sql
-- To JUŻ JEST transakcja - automatycznie atomic
INSERT INTO Products VALUES (100, 'New Product', ...);

-- Jeśli się uda - auto COMMIT
-- Jeśli failuje - auto ROLLBACK
```

Nie musicie pisać BEGIN/COMMIT/ROLLBACK. Delta robi to za Was!

**Każda operacja = transakcja:**

```sql
UPDATE Products SET UnitPrice = UnitPrice * 1.1 WHERE CategoryID = 1;
-- Atomowa - albo wszystkie wiersze zaktualizowane, albo żaden
```

**Delta Lake Transaction Log:**

Delta śledzi KAŻDĄ transakcję w specjalnym logu (`_delta_log` folder). To daje super możliwości:

**1. Time Travel - cofanie zmian:**

```sql
-- Zobacz historię zmian
DESCRIBE HISTORY Products;
```

[Uruchom - pokaże wszystkie operacje na tabeli]

Każda operacja ma:
- Version number
- Timestamp
- Operation (INSERT, UPDATE, DELETE, OPTIMIZE)
- User
- Metrics (ile wierszy)

**2. Przywracanie starych wersji:**

```sql
-- Zapytanie o dane z przeszłości
SELECT * FROM Products VERSION AS OF 5;  -- wersja 5
SELECT * FROM Products TIMESTAMP AS OF '2024-01-15';  -- stan na datę

-- Przywrócenie tabeli
RESTORE TABLE Products TO VERSION AS OF 10;
```

To jak Git dla danych! Commitujecie zmiany, możecie cofnąć się do dowolnego momentu.

**3. Audyt:**

```sql
-- Kto co zmienił i kiedy?
SELECT version, timestamp, operation, operationMetrics
FROM (DESCRIBE HISTORY Products)
WHERE operation IN ('UPDATE', 'DELETE');
```

Super dla compliance, debugowania.

**Isolation Levels:**

Delta Lake używa **Snapshot Isolation** - każda transakcja widzi spójny snapshot danych w momencie startu.

Dwie równoczesne transakcje:
- Czytają różne snapshoty (nie blokują się nawzajem)
- Jeśli próbują zmienić te same wiersze - jedna wygrywa, druga dostaje konflikt

**Konflikt przykład:**

```sql
-- User A:
UPDATE Products SET UnitPrice = 20 WHERE ProductID = 1;

-- User B (jednocześnie):
UPDATE Products SET UnitPrice = 25 WHERE ProductID = 1;
```

Jeden z nich dostanie błąd ConcurrentModificationException. Musi retry.

W praktyce rzadko problem - większość operacji nie koliduje.

**Praktyczne wskazówki:**

1. **Delta robi transakcje za Ciebie** - nie martw się o BEGIN/COMMIT
2. **Time Travel jest darmowy** - używaj do audytu i disaster recovery
3. **VACUUM** czyści stare wersje (oszczędność miejsca):
```sql
VACUUM Products RETAIN 168 HOURS;  -- usuń wersje starsze niż 7 dni
```

4. **Testuj na COPY** zamiast ryzykować produkcję:
```sql
CREATE TABLE products_test AS SELECT * FROM Products;
-- testuj na products_test, jak ok - na produkcji
```

Pytania do transakcji?"

**Wskazówki:**
- ACID to fundament - wyjaśnij każdą literę
- Delta Lake robi to automatycznie - podkreśl!
- Time Travel to killer feature Delta - pokaż
- Porównaj z klasycznym SQL

---

# BEST PRACTICES

## Zasady profesjonalnego SQL:

### 1. Czytelność kodu
```sql
-- ŹLE: wszystko w jednej linii
SELECT o.OrderID,c.CompanyName,p.ProductName,od.Quantity FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID JOIN `Order Details` od ON o.OrderID=od.OrderID JOIN Products p ON od.ProductID=p.ProductID WHERE o.OrderDate>'1997-01-01'

-- DOBRZE: formatowanie, wcięcia
SELECT
    o.OrderID,
    c.CompanyName,
    p.ProductName,
    od.Quantity
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN `Order Details` od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate > '1997-01-01';
```

### 2. Komentarze
```sql
-- Obliczam całkowitą wartość zamówień per kategoria w 1997
WITH OrderValues AS (
    SELECT
        p.CategoryID,
        SUM(od.UnitPrice * od.Quantity) AS TotalValue  -- wartość bez rabatów
    FROM `Order Details` od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE YEAR(o.OrderDate) = 1997  -- tylko 1997
    GROUP BY p.CategoryID
)
SELECT * FROM OrderValues;
```

---

# NOTATKI DLA PROWADZĄCEGO - BEST PRACTICES

**Czas trwania:** 6-7 minut

**Co powiedzieć:**
"Na koniec - best practices. Zasady profesjonalnego SQL które sprawią że Wasz kod będzie czysty, czytelny i łatwy w utrzymaniu.

**1. Czytelność kodu - NAJWAŻNIEJSZE**

Kod piszecie raz, czytacie 100 razy. Inwestujcie w czytelność!

**Formatowanie:**

Źle - wszystko w jednej linii:
```sql
SELECT o.OrderID,c.CompanyName FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID WHERE o.OrderDate>'1997-01-01'
```

Nieczytelne! Trudno zrozumieć strukturę.

Dobrze - wcięcia, nowe linie:
```sql
SELECT
    o.OrderID,
    c.CompanyName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate > '1997-01-01';
```

Każdy element w osobnej linii. Struktura jasna.

**Używajcie UPPERCASE dla słów kluczowych:**

```sql
SELECT name FROM users WHERE age > 18;  -- lowercase
SELECT Name FROM Users WHERE Age > 18;  -- mixed case - najgorzej!
SELECT name FROM users WHERE age > 18;  -- all lowercase - ok dla niektórych
SELECT Name FROM Users WHERE Age > 18;  -- all uppercase keywords - preferowane
```

Konwencja: **UPPERCASE dla SQL keywords, lowercase dla nazw kolumn/tabel**. Ale najważniejsza spójność w projekcie!

**2. Komentarze - dokumentujcie intencje**

Nie komentujcie CO robi kod (to widać). Komentujcie CZEMU tak robicie.

Źle:
```sql
SELECT * FROM Products WHERE UnitPrice > 50;  -- wybierz produkty droższe niż 50
```

To widać z kodu!

Dobrze:
```sql
-- Produkty premium (>$50) dla kampanii marketingowej Q1
SELECT * FROM Products WHERE UnitPrice > 50;
```

Teraz wiem CZEMU filtrujemy po 50.

Złożone zapytania - komentarze per sekcja:

```sql
-- Analiza sprzedaży per kategoria dla klientów z USA w 1997
WITH
-- Krok 1: Klienci z USA
USACustomers AS (
    SELECT CustomerID
    FROM Customers
    WHERE Country = 'USA'
),
-- Krok 2: Zamówienia z 1997
Orders1997 AS (
    SELECT OrderID, CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) = 1997
)
-- Krok 3: Agregacja
SELECT ...
```

**3. Nazewnictwo - spójne i opisowe**

**Tabele:** Rzeczowniki, liczba mnoga lub pojedyncza (spójnie)
```sql
Products, Categories  -- mnoga (preferowane)
Product, Category  -- pojedyncza (też ok, ale spójnie)
```

**Kolumny:** Opisowe, bez skrótów które nie są oczywiste
```sql
CustomerFirstName  -- dobrze
CustFNm  -- źle, niejasne
```

**Aliasy tabel:** Krótkie ale zrozumiałe
```sql
FROM Orders o  -- ok
FROM Orders orders  -- za długo
FROM Orders x  -- niejasne, co to x?
```

**CTE:** Opisowe nazwy
```sql
WITH RecentOrders AS ...  -- dobrze
WITH tmp1 AS ...  -- źle
```

**4. Unikaj SELECT * w produkcji**

Już mówiliśmy - SELECT * to bad practice:
- Niewyraźne jakie dane potrzebne
- Zmiana struktury tabeli psuje kod
- Niepotrzebne dane = marnowany bandwidth

Wyjątek: ad-hoc analiza, eksploracja danych. Ok. Ale w produkcji - zawsze explicit kolumny.

**5. Obsługa NULL**

NULL to nie zero, nie pusty string. To 'nieznane'. Obsługujcie!

```sql
-- Źle - NULL będzie pomijany
SELECT AVG(Discount) FROM `Order Details`;

-- Dobrze - explicité obsługujemy NULL
SELECT AVG(COALESCE(Discount, 0)) FROM `Order Details`;
```

```sql
-- Źle - WHERE nie znajdzie NULL
WHERE ShipRegion = NULL  -- zawsze FALSE!

-- Dobrze
WHERE ShipRegion IS NULL
```

**6. Używajcie CTE zamiast zagnieżdżonych podzapytań**

Źle - zagnieżdżone subqueries:
```sql
SELECT *
FROM (
    SELECT *
    FROM (
        SELECT * FROM Orders WHERE OrderDate > '1997-01-01'
    ) WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country='USA')
) WHERE Freight > 50;
```

Nieczytelne! Struktura unclear.

Dobrze - CTE:
```sql
WITH
RecentOrders AS (
    SELECT * FROM Orders WHERE OrderDate > '1997-01-01'
),
USAOrders AS (
    SELECT * FROM RecentOrders
    WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE Country='USA')
)
SELECT * FROM USAOrders WHERE Freight > 50;
```

Linearna struktura, czytelna!

**7. Testujcie na małych danych**

ZAWSZE testujcie zapytania na LIMIT przed uruchomieniem na pełnych danych:

```sql
-- Testowanie
SELECT ... FROM huge_table LIMIT 100;

-- Jak działa - usuń LIMIT
SELECT ... FROM huge_table;
```

**8. Version control dla SQL**

Traktujcie SQL jak kod - Git, commits, pull requests!

```sql
-- migrations/001_create_products.sql
CREATE TABLE Products (...);

-- migrations/002_add_discount_column.sql
ALTER TABLE Products ADD COLUMN Discount DECIMAL(5,2);
```

Każda zmiana = osobny plik, wersjonowany, reviewowany.

**9. Bezpieczeństwo - parametryzowane zapytania**

NIGDY nie konkatenujcie SQL z input użytkownika:

```python
# ŹLE - SQL injection!
query = f"SELECT * FROM Users WHERE username = '{user_input}'"

# DOBRZE - parametryzowane
query = "SELECT * FROM Users WHERE username = ?"
cursor.execute(query, (user_input,))
```

W Databricks używajcie widgets dla parametrów.

**10. Dokumentacja**

Duże projekty - dokumentujcie strukturę bazy:
- ERD (Entity Relationship Diagram)
- Opis każdej tabeli i kolumny
- Przykładowe zapytania

Używajcie narzędzi: dbt (data build tool), schemaspy, itd.

Pytania do best practices?"

**Wskazówki:**
- To praktyczne wskazówki - ludzie będą używać od zaraz
- Przykłady źle/dobrze działają najlepiej
- Podkreśl czytelność - to najważniejsze
- NULL handling to częsty błąd

---

# CO JESZCZE WARTO WIEDZIEĆ - PODSUMOWANIE

## ✅ Co omówiliśmy:

1. **Optymalizacja** - SELECT konkretne kolumny, unikaj funkcji w WHERE, WHERE przed HAVING, EXISTS vs IN
2. **Indeksowanie** - Z-Ordering w Delta, data skipping, partition pruning
3. **Partycjonowanie** - PARTITIONED BY, dobre praktyki (nie za dużo partycji!)
4. **Transakcje** - ACID, Delta transaction log, time travel
5. **Best Practices** - czytelność, komentarze, nazewnictwo, CTE, NULL handling

## Kluczowe wnioski:
- **Wydajność** = mądry wybór kolumn + indeksy + partycje
- **Niezawodność** = transakcje ACID + time travel
- **Profesjonalizm** = czytelny kod + komentarze + best practices

## Databricks to nie klasyczna baza:
Delta Lake, Parquet, distributed processing - inna filozofia niż SQL Server/Oracle. Ale fundamenty są te same!

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE

**Czas trwania:** 2-3 minuty

**Co powiedzieć:**
"Świetnie! Mamy za sobą ostatnią merytoryczną sekcję - 'Co jeszcze warto wiedzieć'.

**Podsumujmy:**

**Optymalizacja:** Piszcie efficient SQL - SELECT tylko co potrzeba, unikajcie funkcji na kolumnach w WHERE, używajcie WHERE przed HAVING. To basics, ale robi ogromną różnicę.

**Indeksowanie:** W Databricks to Z-Ordering + data skipping zamiast klasycznych indeksów. OPTIMIZE ... ZORDER BY dla często filtrowanych kolumn.

**Partycjonowanie:** Dziel i rządź - partycjonujcie duże tabele po dacie/regionie. Ale nie przesadzajcie - każda partycja min 1GB.

**Transakcje:** Delta Lake daje ACID za darmo + time travel. Możecie cofnąć zmiany, zobaczyć historię. To game changer.

**Best Practices:** Czytelność, komentarze, spójne nazewnictwo, obsługa NULL. Kod piszecie raz, czytacie 100 razy - inwestujcie w jakość!

**Najważniejszy wniosek:**

Technologie się zmieniają (Databricks ≠ SQL Server), ale fundamenty pozostają:
- Optymalizacja to myślenie o danych
- Indeksy to kompromis read vs write speed
- Transakcje to niezawodność
- Best practices to profesjonalizm

Te zasady działają czy piszecie dla Databricks, PostgreSQL, MySQL czy Oracle.

Pytania finalne do tej sekcji?

[Pauza]

Okej! To była ostatnia część merytoryczna. Zostało tylko 15-minutowe podsumowanie całego szkolenia i zadania domowe. Robimy finałową prostą!"

**Wskazówki:**
- Krótkie podsumowanie - to była gęsta sekcja
- Podkreśl uniwersalność zasad
- Pozytywna energia - jesteśmy blisko końca!
- Zapowiedz finał

---

**KONIEC ROZDZIAŁU 7: CO JESZCZE WARTO WIEDZIEĆ**

Szacowany czas realizacji: 45 minut

Następny rozdział: **Podsumowanie i zadania domowe - 15 minut** (finał szkolenia)
