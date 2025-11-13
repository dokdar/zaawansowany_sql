# COMMON TABLE EXPRESSION (CTE)
## Zapytania pomocnicze i rekurencja

---

# CO TO JEST CTE?

## Common Table Expression (CTE):
Tymczasowy wynik zapytania który istnieje tylko podczas wykonywania głównego zapytania.

## Składnia podstawowa:
```sql
WITH nazwa_cte AS (
    SELECT ...
    FROM ...
    WHERE ...
)
SELECT *
FROM nazwa_cte;
```

## Podobne do:
- Podzapytania (subquery)
- Widoki tymczasowe
- Tabele tymczasowe

**ALE:** Czytelniejsze i bardziej potężne!

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE CTE

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Witamy po przerwie! Mam nadzieję że odpoczęliście, bo teraz wchodzimy w jeden z najfajniejszych tematów SQL - Common Table Expressions czyli CTE.

**Co to jest CTE?**

CTE to sposób na stworzenie tymczasowego, nazwanego wyniku zapytania, którego możemy użyć w głównym zapytaniu. To jak zmienna w programowaniu - przechowujesz wynik i używasz go dalej.

**Składnia:**

```sql
WITH nazwa_cte AS (
    -- tutaj zapytanie które tworzy CTE
    SELECT ...
)
-- tutaj główne zapytanie które używa CTE
SELECT * FROM nazwa_cte;
```

Słowo kluczowe `WITH`, potem nazwa, `AS`, potem zapytanie w nawiasach. Proste!

**Dlaczego CTE, skoro mamy podzapytania?**

Dobra pytanie! Możesz przecież napisać:

```sql
SELECT *
FROM (
    SELECT ...
) AS podzapytanie;
```

CTE ma kilka przewag:

1. **Czytelność:** Kod jest bardziej linearny - najpierw definiujesz pomocnicze wyniki, potem główne zapytanie. Łatwiej czytać.

2. **Reużywalność:** CTE możesz użyć KILKA RAZY w tym samym zapytaniu. Podzapytanie musisz kopiować.

3. **Rekurencja:** CTE może się odwoływać do samego siebie! (To zobaczycie za chwilę - mega potężne)

4. **Debugging:** Możesz łatwo testować każde CTE osobno.

**CTE vs widoki vs tabele tymczasowe:**

- **Widok (VIEW):** Permanent, stored w bazie. Dla wielokrotnego użycia w różnych zapytaniach.
- **Tabela tymczasowa (#temp):** Fizycznie stored, istnieje przez sesję. Dla dużych danych.
- **CTE:** Tylko na czas jednego zapytania. Lightweight, czytelny.

Pokażę prosty przykład."

**Wskazówki:**
- Wyjaśnij różnicę CTE vs podzapytania - wielu ma pytanie
- Podkreśl przewagi: czytelność i rekurencja
- Entuzjazm - CTE to naprawdę fajne narzędzie!

---

# CTE - PROSTY PRZYKŁAD

```sql
-- CTE: Średnia cena produktów
WITH AvgPrices AS (
    SELECT
        CategoryID,
        AVG(UnitPrice) AS AvgPrice
    FROM Products
    GROUP BY CategoryID
)
-- Główne zapytanie: Produkty droższe niż średnia w kategorii
SELECT
    p.ProductName,
    p.CategoryID,
    p.UnitPrice,
    a.AvgPrice,
    p.UnitPrice - a.AvgPrice AS PriceDiff
FROM Products p
JOIN AvgPrices a ON p.CategoryID = a.CategoryID
WHERE p.UnitPrice > a.AvgPrice
ORDER BY PriceDiff DESC;
```

**Wynik:** Produkty droższe niż średnia w swojej kategorii

---

# NOTATKI DLA PROWADZĄCEGO - CTE PRZYKŁAD 1

**Czas trwania:** 5 minut

**Co powiedzieć:**
"Zobaczmy proste CTE w akcji.

**Problem biznesowy:**
Chcę znaleźć produkty które są droższe niż średnia cena w swojej kategorii. Ile droższe? O ile?

**Bez CTE** - brzydkie podzapytanie:

```sql
SELECT
    p.ProductName,
    p.UnitPrice,
    (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = p.CategoryID) AS AvgPrice
FROM Products p
WHERE p.UnitPrice > (SELECT AVG(UnitPrice) FROM Products WHERE CategoryID = p.CategoryID);
```

Widzicie? Obliczam średnią DWA RAZY. Nieczytelne, nieefektywne.

**Z CTE** - czysto i elegancko:

[Uruchom zapytanie]

```sql
WITH AvgPrices AS (
    SELECT
        CategoryID,
        AVG(UnitPrice) AS AvgPrice
    FROM Products
    GROUP BY CategoryID
)
SELECT
    p.ProductName,
    p.CategoryID,
    p.UnitPrice,
    a.AvgPrice,
    p.UnitPrice - a.AvgPrice AS PriceDiff
FROM Products p
JOIN AvgPrices a ON p.CategoryID = a.CategoryID
WHERE p.UnitPrice > a.AvgPrice
ORDER BY PriceDiff DESC;
```

**Rozbiór:**

1. **CTE 'AvgPrices':** Obliczam średnie ceny dla każdej kategorii. To przechowuję jako tymczasowy wynik.

2. **Główne zapytanie:** JOIN-uję Products z moim CTE jak z normalną tabelą. Filtruję, obliczam różnicę.

**Rezultat:**

Widzicie produkty droższe niż średnia. 'Côte de Blaye' jest 221.05 droższe niż średnia w kategorii Beverages!

**Czytelność:**

Kod jest linearny:
- Krok 1: Przygotuj średnie (CTE)
- Krok 2: Użyj średnich (główne zapytanie)

To jak przepis kulinarny - najpierw przygotuj składniki, potem gotuj.

**Wydajność:**

Optymalizator SQL jest inteligentny - często wykona CTE efektywnie, czasem nawet lepiej niż podzapytanie.

Spróbujcie sami (3 minuty):
Stwórzcie CTE które policzy liczbę produktów per kategoria. Potem w głównym zapytaniu pokażcie kategorie które mają więcej niż średnia liczba produktów (średnia across wszystkich kategorii)."

**Wskazówki:**
- Porównaj z wersją bez CTE - kontrast pomaga zrozumieć wartość
- Uruchom zapytanie na żywo
- Daj ćwiczenie - sprawdzi czy rozumieją podstawy

---

# WIELE CTE W JEDNYM ZAPYTANIU

## Możesz zdefiniować KILKA CTE:
```sql
WITH
cte1 AS (SELECT ...),
cte2 AS (SELECT ...),
cte3 AS (SELECT ... FROM cte1 ...)  -- cte3 używa cte1!
SELECT ...
FROM cte1
JOIN cte2 ON ...
JOIN cte3 ON ...;
```

**Zasady:**
- Oddzielasz przecinkami (nie powtarzasz WITH)
- Późniejsze CTE mogą używać wcześniejszych
- Kolejność ma znaczenie!

---

# NOTATKI DLA PROWADZĄCEGO - WIELE CTE

**Czas trwania:** 4 minut

**Co powiedzieć:**
"CTE staje się naprawdę potężne kiedy łączysz kilka razem.

**Składnia:**

```sql
WITH
pierwsz_cte AS (
    SELECT ...
),
drugi_cte AS (
    SELECT ... FROM pierwszy_cte  -- mogę użyć poprzedniego!
),
trzeci_cte AS (
    SELECT ... FROM drugi_cte
)
SELECT ...
FROM trzeci_cte;
```

Zauważcie:
- Tylko JEDNO słowo WITH na początku
- Między CTE używamy przecinków
- Późniejsze CTE mogą odnosić się do wcześniejszych

**Praktyczny przykład:**

```sql
-- Krok 1: Średnia cena per kategoria
WITH CategoryAvg AS (
    SELECT
        CategoryID,
        AVG(UnitPrice) AS AvgPrice
    FROM Products
    GROUP BY CategoryID
),
-- Krok 2: Średnia cena globalna
GlobalAvg AS (
    SELECT AVG(UnitPrice) AS GlobalAvgPrice
    FROM Products
),
-- Krok 3: Kategorie z ceną powyżej globalnej średniej
ExpensiveCategories AS (
    SELECT ca.CategoryID
    FROM CategoryAvg ca
    CROSS JOIN GlobalAvg ga
    WHERE ca.AvgPrice > ga.GlobalAvgPrice
)
-- Główne zapytanie: Produkty z drogich kategorii
SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN ExpensiveCategories ec ON p.CategoryID = ec.CategoryID
ORDER BY p.UnitPrice DESC;
```

[Uruchom]

Widzicie strukturę? Buduję rozwiązanie krok po kroku:
1. CategoryAvg - obliczam średnie per kategoria
2. GlobalAvg - obliczam średnią globalną
3. ExpensiveCategories - wybieram kategorie droższe niż średnia (używam OBIE poprzednie CTE)
4. Główne zapytanie - pokazuję produkty z tych kategorii

**To jak programowanie imperatywne:**
```python
category_avg = calculate_category_averages()
global_avg = calculate_global_average()
expensive = filter(category_avg, global_avg)
products = get_products(expensive)
```

CTE pozwala pisać SQL w stylu proceduralnym, krok po kroku. Mega czytelne!

**Ograniczenia:**

- CTE nie są materializowane (nie są stored physically). Za każdym razem jak używasz CTE, jest re-computed.
- Jeśli to problem (duże dane), użyj tabeli tymczasowej zamiast CTE.

Pytania do wielokrotnych CTE?"

**Wskazówki:**
- Podkreśl czytelność - to główna zaleta
- Przykład z kilkoma CTE pokazuje moc
- Wspomnij o braku materializacji - ważne dla performance

---

# CTE REKURENCYJNE - WPROWADZENIE

## Co to jest rekurencja?
Funkcja/zapytanie które odwołuje się do samego siebie.

## Klasyczny przykład - silnia:
```
5! = 5 × 4!
4! = 4 × 3!
3! = 3 × 2!
2! = 2 × 1!
1! = 1  <- warunek stopu
```

## W SQL:
CTE może odwoływać się do samego siebie!

**Use cases:**
- Hierarchie organizacyjne (pracownik -> przełożony)
- Struktury drzewiaste (kategorie -> podkategorie)
- Grafy połączeń
- Serie numeryczne

---

# NOTATKI DLA PROWADZĄCEGO - REKURENCJA INTRO

**Czas trwania:** 3-4 minuty

**Co powiedzieć:**
"Teraz przechodzimy do NAJBARDZIEJ fascynującej części CTE - rekurencji. To jest magia SQL.

**Co to jest rekurencja?**

Rekurencja to kiedy coś odwołuje się do samego siebie. W programowaniu - funkcja która wywołuje samą siebie:

```python
def silnia(n):
    if n == 1:
        return 1
    else:
        return n * silnia(n-1)  # wywołuje siebie!
```

W matematyce - silnia:
```
5! = 5 × 4! = 5 × 4 × 3! = ... = 5 × 4 × 3 × 2 × 1 = 120
```

**W SQL - CTE rekurencyjne:**

CTE może odwoływać się do samego siebie! Brzmi szalenie? To jest genialne.

**Struktura rekurencyjnego CTE:**

```sql
WITH RECURSIVE nazwa_cte AS (
    -- CZĘŚĆ 1: Anchor member (zapytanie zakotwiczające)
    SELECT ... WHERE [warunek początkowy]

    UNION ALL

    -- CZĘŚĆ 2: Recursive member (zapytanie rekurencyjne)
    SELECT ...
    FROM nazwa_cte  -- odwołanie do samego siebie!
    WHERE [warunek kontynuacji]
)
SELECT * FROM nazwa_cte;
```

**Jak to działa:**

1. **Anchor:** Wykonaj zapytanie początkowe - to jest punkt startu (jak n=1 w silni)
2. **Recursive:** Użyj wyniku poprzedniej iteracji, przetwórz, dodaj do wyniku
3. **Powtarzaj** krok 2 dopóki zapytanie rekurencyjne zwraca wiersze
4. **Stop:** Kiedy zapytanie rekurencyjne nie zwróci żadnych wierszy - koniec

**UWAGA - różnica Databricks vs SQL Server:**

W SQL Server piszesz `WITH nazwa AS (...)`
W niektórych SQL-ach (PostgreSQL) piszesz `WITH RECURSIVE nazwa AS (...)`

Databricks/Spark SQL używa składni **bez RECURSIVE** ale działa rekurencyjnie.

Pokażę przykład - policzymy silnię w SQL. Tak, można!"

**Wskazówki:**
- Rekurencja może być trudna - wyjaśnij powoli
- Analogia do programowania pomaga
- Podkreśl strukturę: anchor + recursive + UNION ALL
- Entuzjazm - to naprawdę cool!

---

# CTE REKURENCYJNE - SILNIA

```sql
-- Obliczamy silnię (factorial) od 1 do 10
WITH RECURSIVE Factorial AS (
    -- Anchor: zaczynamy od 1! = 1
    SELECT
        1 AS N,
        CAST(1 AS BIGINT) AS FactorialValue

    UNION ALL

    -- Recursive: każda następna silnia
    SELECT
        N + 1,
        (N + 1) * FactorialValue
    FROM Factorial
    WHERE N < 10  -- warunek stopu
)
SELECT N, FactorialValue
FROM Factorial
ORDER BY N;
```

**Wynik:**
```
N | FactorialValue
--|----------------
1 | 1
2 | 2
3 | 6
4 | 24
5 | 120
...
```

---

# NOTATKI DLA PROWADZĄCEGO - REKURENCJA SILNIA

**Czas trwania:** 6-7 minut

**Co powiedzieć:**
"Obliczmy silnię używając rekurencyjnego CTE. To klasyczny przykład do nauki rekurencji.

**UWAGA Databricks:** Databricks może nie wspierać słowa RECURSIVE. Jeśli dostaniecie błąd, usuńcie słowo RECURSIVE - w Spark SQL rekurencja działa bez tego słowa.

[Uruchom zapytanie - jeśli błąd, usuń RECURSIVE i uruchom ponownie]

```sql
WITH Factorial AS (
    -- Anchor member
    SELECT
        1 AS N,
        CAST(1 AS BIGINT) AS FactorialValue

    UNION ALL

    -- Recursive member
    SELECT
        N + 1,
        (N + 1) * FactorialValue
    FROM Factorial
    WHERE N < 10
)
SELECT N, FactorialValue
FROM Factorial
ORDER BY N;
```

**Krok po kroku co się dzieje:**

**Iteracja 0 (Anchor):**
- Wykonuje się `SELECT 1 AS N, 1 AS FactorialValue`
- Wynik: (1, 1)
- To trafia do tymczasowego wyniku

**Iteracja 1 (Recursive):**
- Bierze wynik poprzedniej iteracji: (1, 1)
- Wykonuje: `SELECT 1+1, (1+1)*1` = (2, 2)
- Warunek: 1 < 10 ✓ więc kontynuuj
- Dodaje (2, 2) do wyniku

**Iteracja 2:**
- Bierze: (2, 2)
- Wykonuje: `SELECT 2+1, (2+1)*2` = (3, 6)
- Warunek: 2 < 10 ✓
- Dodaje (3, 6)

... i tak dalej ...

**Iteracja 10:**
- Bierze: (9, 362880)
- Wykonuje: `SELECT 9+1, (9+1)*362880` = (10, 3628800)
- Warunek: 9 < 10 ✓
- Dodaje (10, 3628800)

**Iteracja 11:**
- Bierze: (10, 3628800)
- Warunek: 10 < 10 ✗ FALSE
- Zapytanie nie zwraca wierszy
- **STOP - rekurencja kończy się**

Finalny wynik to UNION ALL wszystkich iteracji: od (1,1) do (10, 3628800).

[Pokaż wyniki]

Widzicie? 10! = 3,628,800. Matematyka się zgadza!

**Kluczowe elementy:**

1. **CAST(1 AS BIGINT)** - ważne! Silnia rośnie szybko, INT może nie wystarczyć.

2. **WHERE N < 10** - WARUNEK STOPU. Bez tego - nieskończona pętla! (Databricks ma domyślny limit iteracji, ale lepiej mieć explicit stop)

3. **UNION ALL** - nie UNION. UNION usunęłoby duplikaty i był by wolniejsze. UNION ALL dodaje wszystko.

**Praktyczne zastosowanie silni?**

Żadne. To jest przykład edukacyjny. ALE mechanizm rekurencji jest super użyteczny dla hierarchii. Zobaczcie..."

**Wskazówki:**
- Narysuj iteracje na tablicy jeśli możesz - wizualizacja pomaga
- Podkreśl znaczenie warunku stopu
- Wyjaśnij CAST - częsty błąd początkujących
- Zaznacz że to przykład edukacyjny, prawdziwa moc jest gdzie indziej

---

# REKURENCJA - HIERARCHIE PRACOWNIKÓW

## Problem biznesowy:
Tabela Employees ma kolumnę `ReportsTo` - każdy pracownik ma przełożonego (lub NULL jeśli jest CEO).

```
EmployeeID | FirstName | LastName | ReportsTo
-----------|-----------|----------|----------
1          | Nancy     | Davolio  | 2
2          | Andrew    | Fuller   | NULL      <- CEO
3          | Janet     | Leverling| 2
...
```

**Pytanie:** Kto komu raportuje? Jaka jest pełna hierarchia?

**Rozwiązanie:** Rekurencyjne CTE!

---

# NOTATKI DLA PROWADZĄCEGO - HIERARCHIE INTRO

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Teraz prawdziwa moc rekurencyjnych CTE - hierarchie organizacyjne.

**Nasza tabela Employees:**

Każdy pracownik ma EmployeeID i ReportsTo (ID przełożonego). To klasyczna struktura parent-child.

```
Nancy (ID=1) raportuje do Andrew (ID=2)
Andrew (ID=2) raportuje do NULL (jest CEO)
Janet (ID=3) raportuje do Andrew (ID=2)
```

Mamy hierarchię:
```
Andrew (CEO)
  ├── Nancy
  ├── Janet
  ├── ...
```

**Zadanie:**

Chcę zobaczyć każdego pracownika + jego przełożonego (imię i nazwisko przełożonego).

Bez rekurencji? Prosty JOIN:

```sql
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.ReportsTo,
    m.FirstName AS ManagerFirstName,
    m.LastName AS ManagerLastName
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeID;
```

To działa! Ale pokazuje tylko JEDEN poziom. A co jeśli chcę PEŁNĄ hierarchię? Kto jest szefem szefa? Ile poziomów w dół od CEO?

Rekurencja!"

**Wskazówki:**
- Wyjaśnij strukturę parent-child
- Pokaż prosty JOIN jako rozwiązanie na 1 poziom
- Zaznacz że potrzebujemy więcej - wprowadzenie do rekurencji

---

# REKURENCJA - HIERARCHIA PRZYKŁAD

```sql
-- Pełna hierarchia pracowników
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor: CEO (brak przełożonego)
    SELECT
        EmployeeID,
        FirstName,
        LastName,
        ReportsTo,
        CAST(NULL AS STRING) AS ManagerFirstName,
        CAST(NULL AS STRING) AS ManagerLastName,
        0 AS Level  -- poziom hierarchii
    FROM Employees
    WHERE ReportsTo IS NULL

    UNION ALL

    -- Recursive: pracownicy raportujący do poprzedniego poziomu
    SELECT
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        r.EmployeeID AS ReportsTo,
        r.FirstName AS ManagerFirstName,
        r.LastName AS ManagerLastName,
        r.Level + 1
    FROM Employees e
    JOIN EmployeeHierarchy r ON e.ReportsTo = r.EmployeeID
)
SELECT *
FROM EmployeeHierarchy
ORDER BY Level, LastName;
```

---

# NOTATKI DLA PROWADZĄCEGO - HIERARCHIA PRZYKŁAD

**Czas trwania:** 7-8 minut

**Co powiedzieć:**
"Zbudujmy pełną hierarchię pracowników używając rekurencji.

[Uruchom zapytanie - usuń RECURSIVE jeśli Databricks wymaga]

**Rozbiór:**

**Anchor - punkt startowy:**
```sql
SELECT
    EmployeeID, FirstName, LastName, ReportsTo,
    CAST(NULL AS STRING) AS ManagerFirstName,
    CAST(NULL AS STRING) AS ManagerLastName,
    0 AS Level
FROM Employees
WHERE ReportsTo IS NULL
```

Zaczynam od CEO - osoby która nie raportuje do nikogo (ReportsTo IS NULL). To jest Andrew Fuller. Jego poziom = 0 (top). Nie ma przełożonego więc ManagerFirstName/LastName = NULL.

**Recursive - następne poziomy:**
```sql
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    r.EmployeeID AS ReportsTo,
    r.FirstName AS ManagerFirstName,
    r.LastName AS ManagerLastName,
    r.Level + 1
FROM Employees e
JOIN EmployeeHierarchy r ON e.ReportsTo = r.EmployeeID
```

JOIN-uję Employees z wynikiem poprzedniej iteracji (EmployeeHierarchy). Szukam pracowników którzy raportują do osób znalezionych w poprzedniej iteracji. Ich poziom = poziom przełożonego + 1.

**Wykonanie:**

**Iteracja 0 (Anchor):**
Znajduje Andrew Fuller (CEO), Level=0

**Iteracja 1 (Recursive):**
Znajduje pracowników którzy raportują do Andrew (EmployeeID=2):
- Nancy Davolio, Level=1
- Janet Leverling, Level=1
- Steven Buchanan, Level=1
- Laura Callahan, Level=1

**Iteracja 2:**
Znajduje pracowników którzy raportują do osób z Level=1.
Steven Buchanan ma podwładnych:
- Michael Suyama, Level=2
- Robert King, Level=2
- Anne Dodsworth, Level=2

**Iteracja 3:**
Szuka pracowników raportujących do Level=2. Nie ma żadnych. Koniec.

[Pokaż wyniki]

Widzicie pełną hierarchię! Andrew na górze (Level=0), jego bezpośredni podwładni (Level=1), ich podwładni (Level=2).

**Kolumna Level - bonus:**

Dodałem Level żeby pokazać głębokość hierarchii. To ułatwia wizualizację:

```
Level 0: Andrew Fuller (CEO)
Level 1: Nancy, Janet, Steven, Laura (managerowie)
Level 2: Michael, Robert, Anne (specjaliści)
```

**Praktyczne zastosowania:**

- Organigramytycznie organizacji - kto komu raportuje
- BOM (Bill of Materials) - produkt składa się z części, część z pod-części...
- Kategorie - kategoria -> podkategoria -> pod-podkategoria
- Foldery - folder -> subfolder -> sub-subfolder

Każda struktura drzewiasta!

Ćwiczenie (opcjonalne, 5 min):
Zmodyfikujcie zapytanie żeby pokazywało TYLKO pracowników na poziomie 2 i głębiej (bez CEO i top managerów)."

**Wskazówki:**
- Szczegółowo wyjaśnij iteracje - to kluczowe dla zrozumienia
- Podkreśl praktyczne zastosowania - ludzie lubią widzieć real-world use cases
- Kolumna Level to świetny dodatek dla wizualizacji
- Jeśli czas pozwala, daj ćwiczenie

---

# MAXRECURSION - OGRANICZENIE GŁĘBOKOŚCI

## Problem:
Rekurencja może wpaść w nieskończoną pętlę!

## Rozwiązanie:
Limit głębokości rekurencji.

**W SQL Server:**
```sql
OPTION (MAXRECURSION 100)
```

**W Databricks/Spark SQL:**
```sql
SET spark.sql.cte.maxIterations = 100;
```

**Domyślnie:**
- SQL Server: 100 iteracji
- Databricks: 100 iteracji (może się różnić w wersjach)

**0 = unlimited** (niebezpieczne!)

---

# NOTATKI DLA PROWADZĄCEGO - MAXRECURSION

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Ważna uwaga o bezpieczeństwie rekurencji - MAXRECURSION.

**Problem:**

Co się stanie jeśli zapomnimy warunku stopu albo dane mają cykl?

Przykład cyklu:
```
Pracownik A raportuje do B
Pracownik B raportuje do C
Pracownik C raportuje do A  <- cykl!
```

Rekurencja będzie się kręcić w nieskończoność: A->B->C->A->B->C->...

**Zabezpieczenie:**

SQL ma wbudowany limit głębokości rekurencji.

**SQL Server:**
```sql
... rekurencyjne CTE ...
SELECT * FROM cte
OPTION (MAXRECURSION 100);  -- max 100 iteracji
```

**Databricks/Spark SQL:**
```sql
SET spark.sql.cte.maxIterations = 100;
-- potem Twoje rekurencyjne zapytanie
```

Albo w konfiguracji klastra.

**Domyślnie** większość SQL-i ma limit ~100 iteracji. Jeśli przekroczysz, dostaniesz błąd.

**Ustawienie 0 = unlimited:**

```sql
OPTION (MAXRECURSION 0);  -- SQL Server
```

UWAGA! To niebezpieczne. Używaj tylko jeśli na 100% wiesz że rekurencja się skończy.

**Best practice:**

1. Zawsze miej explicité warunek stopu w WHERE
2. Jeśli hierarchia może być głębsza niż 100, ustaw większy limit
3. Loguj/monitoruj głębokie rekurencje - mogą wskazywać na błąd w danych

**Testowanie:**

Możesz specjalnie ustawić niski limit żeby przetestować:

```sql
SET spark.sql.cte.maxIterations = 3;
-- teraz rekurencja zatrzyma się po 3 iteracjach
```

Użyteczne do debugowania.

Pytania do rekurencji ogólnie?"

**Wskazówki:**
- Ostrzeż przed nieskończonymi pętlami
- Wyjaśnij różnicę SQL Server vs Databricks
- Podkreśl best practices
- To dobry moment na pytania o całą rekurencję

---

# CTE - ZAAWANSOWANE PRZYKŁADY

## 1. Seriesne numeryczne (generator liczb)
```sql
WITH RECURSIVE Numbers AS (
    SELECT 1 AS N
    UNION ALL
    SELECT N + 1
    FROM Numbers
    WHERE N < 100
)
SELECT * FROM Numbers;
```
Generuje liczby od 1 do 100.

## 2. Daty w zakresie
```sql
WITH RECURSIVE DateRange AS (
    SELECT CAST('2024-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATE_ADD(DateValue, 1)
    FROM DateRange
    WHERE DateValue < '2024-12-31'
)
SELECT * FROM DateRange;
```

---

# NOTATKI DLA PROWADZĄCEGO - ZAAWANSOWANE PRZYKŁADY

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Pokażę Wam kilka praktycznych tricków z rekurencyjnymi CTE.

**1. Generator liczb:**

Czasem potrzebujesz serii liczb - np. do JOIN-a z danymi, do testów, do raportów.

[Uruchom]

```sql
WITH RECURSIVE Numbers AS (
    SELECT 1 AS N
    UNION ALL
    SELECT N + 1
    FROM Numbers
    WHERE N < 100
)
SELECT * FROM Numbers;
```

Dostajecie 100 wierszy z liczbami od 1 do 100. Super przydatne!

**Przykład użycia - raport z zerami:**

Chcecie raport sprzedaży dla każdego miesiąca roku, nawet jeśli nie było sprzedaży.

```sql
WITH RECURSIVE Months AS (
    SELECT 1 AS Month
    UNION ALL
    SELECT Month + 1 FROM Months WHERE Month < 12
)
SELECT
    m.Month,
    COALESCE(SUM(o.Freight), 0) AS TotalFreight
FROM Months m
LEFT JOIN Orders o ON m.Month = MONTH(o.OrderDate)
GROUP BY m.Month
ORDER BY m.Month;
```

Bez CTE nie dostalibyście wierszy dla miesięcy bez zamówień. Z CTE macie pełny rok!

**2. Generator dat:**

Podobnie - seria dat:

```sql
WITH RECURSIVE DateRange AS (
    SELECT CAST('2024-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATE_ADD(DateValue, 1)
    FROM DateRange
    WHERE DateValue < '2024-01-31'
)
SELECT * FROM DateRange;
```

Wszystkie dni stycznia 2024. Przydatne do:
- Raportów dziennych (nawet jak brak danych)
- Wypełniania luk w danych
- Planowania (kalendarz)

**3. Tally table (tabela liczb) - performance trick:**

W produkcji często tworzy się stałą tabelę z liczbami 1-10000 dla performance. Zamiast generować rekurencyjnie za każdym razem, masz gotową:

```sql
CREATE TABLE Numbers (N INT);
INSERT INTO Numbers SELECT N FROM (WITH RECURSIVE ... do 10000);
```

Potem JOIN-ujesz z Numbers zamiast generować CTE. Szybsze dla częstych zapytań.

Te tricki pokazują elastyczność CTE. To nie tylko dla hierarchii!"

**Wskazówki:**
- Generatory liczb/dat to bardzo praktyczne
- Pokaż przykład użycia (raport z zerami) - ludzie rozumieją lepiej
- Wspomnij o tally tables jako optimization

---

# CTE - PODSUMOWANIE

## ✅ Co omówiliśmy:
- **CTE podstawowe** - czytelność, reużywalność
- **Wiele CTE** - budowanie rozwiązania krok po kroku
- **CTE rekurencyjne** - hierarchie, struktury drzewiaste
- **Anchor + Recursive** - struktura rekurencji
- **MAXRECURSION** - bezpieczeństwo
- **Praktyczne przykłady** - pracownicy, generatory

## Kiedy używać CTE:
| Sytuacja | Rozwiązanie |
|----------|-------------|
| Złożone zapytanie | Podziel na CTE steps |
| Hierarchia/drzewo | Rekurencyjne CTE |
| Wielokrotne użycie podzapytania | CTE zamiast subquery |
| Czytelność kodu | CTE! |

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE CTE

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Fantastycznie! Mamy za sobą Common Table Expressions. To był intensywny godzinny blok.

**Podsumujmy:**

**CTE podstawowe:**
- WITH nazwa AS (...) SELECT ...
- Czytelniejsze niż podzapytania
- Można reużywać w tym samym zapytaniu
- Świetne do dzielenia złożonej logiki na kroki

**Wiele CTE:**
- Budujemy rozwiązanie krok po kroku
- Każde CTE może używać poprzednich
- Jak przepis kulinarny - przygotuj składniki, potem gotuj

**Rekurencja:**
- CTE może odwoływać się do siebie
- Anchor (start) + Recursive (iteracja) + UNION ALL
- Warunek stopu w WHERE - KRYTYCZNE!
- Hierarchie, drzewa, grafy

**Praktyczne zastosowania:**
- Raportowanie wielopoziomowe
- Organigramyty
- BOM (Bill of Materials)
- Struktury kategorii
- Generatory (liczby, daty)

**Kluczowe wnioski:**

1. CTE to nie tylko syntactic sugar - to narzędzie do myślenia o problemach krok po kroku.

2. Rekurencja otwiera drzwi do rozwiązań niemożliwych w zwykłym SQL.

3. Czytelność kodu = łatwiejszy maintenance. Kolega za pół roku podziękuje.

**Pytania do CTE?**

[Pauza]

CTE to była trudna część. Jeśli nie wszystko wsiąkło - to normalne. Praktyka robi mistrza. W notebookach macie więcej przykładów do ćwiczeń.

Jesteśmy po około 2.5h szkolenia. Mamy jeszcze 2.5h przed sobą. Następny temat to KWINTESENCJA zaawansowanego SQL - **funkcje analityczne**. To będzie najdłuższa sekcja - 90 minut - bo jest masa do pokazania.

Zróbmy może 5-minutową mikro-przerwę? Rozciągnijcie nogi, dolączcie kawy, wracamy za 5 minut do funkcji analitycznych!"

**Wskazówki:**
- Podsumuj kluczowe punkty
- Daj czas na pytania
- To dobry moment na krótką przerwę (5 min) - ludzie będą świeżsi na funkcje analityczne
- Zapowiedz następny temat z entuzjazmem

---

**KONIEC ROZDZIAŁU 4: COMMON TABLE EXPRESSION**

Szacowany czas realizacji: 60 minut

**MIKRO-PRZERWA: 5 minut**

Następny rozdział: **Funkcje analityczne (Window Functions) - 90 minut** ⭐⭐ (najdłuższa sekcja)
