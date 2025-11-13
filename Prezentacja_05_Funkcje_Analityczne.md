# FUNKCJE ANALITYCZNE
## Window Functions - Potęga analityki SQL

---

# CO TO SĄ FUNKCJE ANALITYCZNE?

## Definicja:
Funkcje które **obliczają wartości na zbiorze wierszy** związanych z bieżącym wierszem.

## Główna różnica vs GROUP BY:
- **GROUP BY:** Zwija wiele wierszy w jeden (agregacja)
- **Window Functions:** Każdy wiersz pozostaje, ale dostaje dodatkowe informacje o swoim "otoczeniu"

## Przykład:
```sql
-- GROUP BY - 8 wierszy (po jednym na kategorię)
SELECT CategoryID, AVG(UnitPrice)
FROM Products
GROUP BY CategoryID;

-- Window Function - 77 wierszy (wszystkie produkty)
SELECT ProductID, ProductName, UnitPrice,
       AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
FROM Products;
```

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE

**Czas trwania:** 5 minut

**Co powiedzieć:**
"Witamy z powrotem! Teraz wchodzimy w NAJBARDZIEJ potężny temat dzisiejszego szkolenia - funkcje analityczne, znane też jako window functions.

To będzie nasza najdłuższa sekcja - 90 minut. Dlaczego tak długo? Bo funkcje analityczne to absolutna potęga SQL-a. Kiedy je opanujecie, Wasz poziom SQL wzrośnie o 200%.

**Co to są funkcje analityczne?**

To funkcje które operują na 'oknach' (windows) wierszy. Obliczają coś dla grupy wierszy, ALE nie zwijają wyniku jak GROUP BY.

**Kluczowa różnica:**

GROUP BY:
- Input: 77 produktów
- Output: 8 wierszy (po jednym na kategorię)
- Tracisz szczegóły

Window Function:
- Input: 77 produktów
- Output: 77 produktów (wszystkie!)
- Każdy produkt dostaje dodatkową informację o swojej kategorii/grupie

**Przykład biznesowy:**

Chcecie raport: każdy produkt + średnia cena w jego kategorii.

Bez window functions - musicie JOIN z podzapytaniem:
```sql
SELECT p.*, a.AvgPrice
FROM Products p
JOIN (SELECT CategoryID, AVG(UnitPrice) AS AvgPrice
      FROM Products GROUP BY CategoryID) a
  ON p.CategoryID = a.CategoryID
```

Z window functions - jedna linijka:
```sql
SELECT ProductName, UnitPrice,
       AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
FROM Products;
```

Czysto, elegancko, wydajnie!

**Co omówimy:**
- OVER() - podstawowa składnia
- PARTITION BY - podział na grupy
- ORDER BY - kolejność w oknie
- Funkcje rankingowe (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
- Funkcje agregujące jako window functions
- Funkcje przesunięcia (LAG, LEAD, FIRST_VALUE, LAST_VALUE)
- Window frames (ROWS, RANGE)

To masa materiału. Będę pokazywał dużo przykładów na żywych danych. Gotowi? Zaczynamy!"

**Wskazówki:**
- Wyjaśnij różnicę window functions vs GROUP BY - to fundamentalne
- Pokaż prostą przewagę składniową
- Zbuduj entuzjazm - to naprawdę cool temat!
- Zapowiedz strukturę - ludzie lubią wiedzieć co ich czeka

---

# OVER() - PODSTAWOWA SKŁADNIA

## Klauzula OVER:
Mówi SQL że funkcja ma działać jako window function.

## Minimalna składnia:
```sql
funkcja() OVER ()
```

Pusta klauzula OVER() = jedno okno dla wszystkich wierszy.

## Przykład:
```sql
SELECT
    ProductName,
    UnitPrice,
    COUNT(*) OVER () AS TotalProducts,
    AVG(UnitPrice) OVER () AS AvgPriceAll,
    MAX(UnitPrice) OVER () AS MaxPriceAll
FROM Products;
```

Każdy produkt widzi statystyki dla **wszystkich** produktów.

---

# NOTATKI DLA PROWADZĄCEGO - OVER() PODSTAWY

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Zacznijmy od podstawowej składni - klauzula OVER().

OVER() to 'magiczne słowo' które zmienia zwykłą funkcję agregującą w window function.

**Puste OVER():**

```sql
AVG(UnitPrice) OVER ()
```

To znaczy: oblicz średnią UnitPrice dla WSZYSTKICH wierszy, ale pokaż wynik przy każdym wierszu.

[Uruchom przykład]

```sql
SELECT
    ProductName,
    UnitPrice,
    COUNT(*) OVER () AS TotalProducts,
    AVG(UnitPrice) OVER () AS AvgPriceAll,
    MAX(UnitPrice) OVER () AS MaxPriceAll
FROM Products
LIMIT 10;
```

Widzicie? Każdy produkt ma:
- Swoją cenę (UnitPrice)
- TotalProducts = 77 (tyle jest wszystkich produktów)
- AvgPriceAll = ~28.87 (średnia cena wszystkich produktów)
- MaxPriceAll = 263.50 (najdroższy produkt w całej bazie)

**Każdy wiersz ma TĘ SAMĄ wartość w kolumnach OVER()** - bo okno obejmuje wszystkie wiersze.

**Po co to?**

Możecie obliczać rzeczy typu:
- Jaki % całkowitej wartości stanowi ten produkt?
- O ile ten produkt jest droższy/tańszy od średniej?

```sql
SELECT
    ProductName,
    UnitPrice,
    AVG(UnitPrice) OVER () AS AvgPrice,
    UnitPrice - AVG(UnitPrice) OVER () AS PriceDiffFromAvg,
    ROUND(100.0 * UnitPrice / SUM(UnitPrice) OVER (), 2) AS PctOfTotal
FROM Products
ORDER BY PctOfTotal DESC
LIMIT 10;
```

[Uruchom]

Teraz widzicie które produkty stanowią największy % całkowitej wartości!

**OVER() to fundament.** Teraz dodajmy PARTITION BY żeby podzielić okna."

**Wskazówki:**
- Wyjaśnij że OVER() bez parametrów = jedno okno
- Pokaż że każdy wiersz ma tę samą wartość
- Przykład z % total jest praktyczny - pokazuje użyteczność

---

# PARTITION BY - PODZIAŁ NA OKNA

## Składnia:
```sql
funkcja() OVER (PARTITION BY kolumna [, kolumna2, ...])
```

Dzieli dane na grupy (partycje). Funkcja działa **osobno dla każdej partycji**.

## Przykład:
```sql
SELECT
    ProductName,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory,
    MAX(UnitPrice) OVER (PARTITION BY CategoryID) AS MaxInCategory
FROM Products;
```

Każdy produkt widzi statystyki **tylko dla swojej kategorii**.

---

# NOTATKI DLA PROWADZĄCEGO - PARTITION BY

**Czas trwania:** 5-6 minut

**Co powiedzieć:**
"PARTITION BY to miejsce gdzie window functions stają się naprawdę użyteczne.

**Koncepcja:**

PARTITION BY dzieli dane na grupy (partycje), i funkcja działa **niezależnie w każdej grupie**.

To jak GROUP BY, ale NIE zwija wierszy!

**Analogia:**

Wyobraźcie sobie uczniów w klasach. Chcecie dla każdego ucznia pokazać średnią ocen w jego klasie.

GROUP BY dałoby: Klasa A - średnia 4.2, Klasa B - średnia 3.8
PARTITION BY da: Jan (klasa A) - średnia w klasie: 4.2, Maria (klasa A) - średnia w klasie: 4.2, Piotr (klasa B) - średnia w klasie: 3.8

[Uruchom przykład]

```sql
SELECT
    ProductName,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory,
    MAX(UnitPrice) OVER (PARTITION BY CategoryID) AS MaxInCategory,
    UnitPrice - AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS DiffFromCategoryAvg
FROM Products
ORDER BY CategoryID, UnitPrice DESC;
```

Zobaczmy wyniki...

Produkty z CategoryID=1 (Beverages):
- Każdy ma AvgInCategory = ~37.98
- Każdy ma MaxInCategory = 263.50 (Côte de Blaye)
- Ale różne DiffFromCategoryAvg

Produkty z CategoryID=2 (Condiments):
- Każdy ma AvgInCategory = ~23.06
- Każdy ma MaxInCategory = 43.90
- Inne wartości niż kategoria 1!

**Każda partycja (CategoryID) ma swoje własne okno.**

**Praktyczne zastosowanie:**

```sql
-- Produkty droższe niż średnia W SWOJEJ kategorii
SELECT
    ProductName,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
FROM Products
WHERE UnitPrice > AVG(UnitPrice) OVER (PARTITION BY CategoryID)
ORDER BY CategoryID;
```

Czekaj, to nie zadziała! Dlaczego?

**Ważna zasada:** Nie możecie używać window functions w WHERE!

WHERE wykonuje się PRZED window functions. Musicie użyć CTE lub podzapytania:

```sql
WITH ProductsWithAvg AS (
    SELECT
        ProductName,
        CategoryID,
        UnitPrice,
        AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
    FROM Products
)
SELECT *
FROM ProductsWithAvg
WHERE UnitPrice > AvgInCategory
ORDER BY CategoryID, UnitPrice DESC;
```

[Uruchom]

Teraz działa! Widzicie produkty droższe niż średnia w swojej kategorii.

**Partycjonowanie po wielu kolumnach:**

```sql
PARTITION BY CategoryID, SupplierID
```

Okna będą dla każdej kombinacji kategorii i dostawcy.

Pytania do PARTITION BY?"

**Wskazówki:**
- Analogia z klasami uczniów pomaga zrozumieć
- Pokaż ograniczenie WHERE - częsty błąd
- Rozwiązanie z CTE pokazuje jak obejść ograniczenie
- Wyjaśnij że można partycjonować po wielu kolumnach

---

# ORDER BY W WINDOW FUNCTIONS

## Składnia:
```sql
funkcja() OVER (PARTITION BY kolumna ORDER BY kolumna2)
```

ORDER BY w OVER:
- Określa **kolejność** wierszy w oknie
- Niektóre funkcje **wymagają** ORDER BY (np. ROW_NUMBER)
- Zmienia zachowanie funkcji agregujących (cumulative!)

## Przykład:
```sql
SELECT
    OrderID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;
```

Running total - suma narastająca!

---

# NOTATKI DLA PROWADZĄCEGO - ORDER BY

**Czas trwania:** 5 minut

**Co powiedzieć:**
"ORDER BY w klauzuli OVER to trzeci kluczowy element. Określa kolejność wierszy w oknie.

**Różnica ORDER BY w OVER vs ORDER BY zapytania:**

```sql
SELECT ..., funkcja() OVER (ORDER BY kolumna)  -- kolejność w oknie
FROM tabela
ORDER BY inna_kolumna;  -- kolejność wyniku
```

To DWIE różne rzeczy!

**Po co ORDER BY w oknie?**

1. **Niektóre funkcje WYMAGAJĄ kolejności:** ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD
2. **Zmienia zachowanie funkcji agregujących** - robi je kumulatywnymi (cumulative)

**Przykład - running total (suma narastająca):**

[Uruchom]

```sql
SELECT
    OrderID,
    OrderDate,
    Freight,
    SUM(Freight) OVER (ORDER BY OrderDate) AS RunningTotal,
    AVG(Freight) OVER (ORDER BY OrderDate) AS RunningAvg
FROM Orders
ORDER BY OrderDate
LIMIT 20;
```

Patrzcie na RunningTotal:
- Pierwsze zamówienie: Freight=32.38, RunningTotal=32.38
- Drugie zamówienie: Freight=11.61, RunningTotal=43.99 (32.38+11.61)
- Trzecie: Freight=65.83, RunningTotal=109.82 (43.99+65.83)

**Suma NARASTA** - każdy wiersz zawiera sumę od początku do bieżącego wiersza!

Bez ORDER BY:
```sql
SUM(Freight) OVER ()  -- suma wszystkich wierszy, stała wartość
```

Z ORDER BY:
```sql
SUM(Freight) OVER (ORDER BY OrderDate)  -- suma od początku do bieżącego
```

**Łączenie PARTITION BY i ORDER BY:**

```sql
SELECT
    ProductID,
    OrderID,
    OrderDate,
    Quantity,
    SUM(Quantity) OVER (
        PARTITION BY ProductID
        ORDER BY OrderDate
    ) AS CumulativeQuantityPerProduct
FROM `Order Details` od
JOIN Orders o ON od.OrderID = o.OrderID;
```

[Możesz uruchomić]

Teraz mamy running total **osobno dla każdego produktu**. Partition dzieli, order sortuje w ramach partycji.

**Domyślne okno (frame):**

Kiedy użyjecie ORDER BY, domyślne okno to:
```
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

To znaczy: od początku partycji do bieżącego wiersza. Stąd cumulative behavior.

Za chwilę pokażę jak zmienić frame. Ale najpierw - funkcje rankingowe!"

**Wskazówki:**
- Wyjaśnij różnicę ORDER BY w OVER vs na końcu zapytania
- Running total to najlepszy przykład użycia ORDER BY
- Pokaż kombinację PARTITION + ORDER - potężna
- Wspomnij o domyślnym frame - będzie rozwinięte później

---

# FUNKCJE RANKINGOWE

## Cztery główne funkcje:

1. **ROW_NUMBER()** - unikalny numer wiersza (1, 2, 3, 4, ...)
2. **RANK()** - ranking z lukami (1, 2, 2, 4, ...)
3. **DENSE_RANK()** - ranking bez luk (1, 2, 2, 3, ...)
4. **NTILE(n)** - podział na n równych grup

**Wszystkie wymagają ORDER BY!**

## Składnia:
```sql
ROW_NUMBER() OVER (ORDER BY kolumna)
RANK() OVER (PARTITION BY grupa ORDER BY wartość DESC)
```

---

# NOTATKI DLA PROWADZĄCEGO - FUNKCJE RANKINGOWE INTRO

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Teraz funkcje rankingowe - to są 'gwiazdki' window functions. Super użyteczne w raportach.

Mamy cztery funkcje:

**ROW_NUMBER()** - najprostsza. Daje każdemu wierszowi unikalny numer: 1, 2, 3, 4, 5...

**RANK()** - ranking z lukami. Jeśli dwa wiersze są równe (ex aequo), dostaną ten sam rank, ale następny będzie z luką:
Wynik: 1, 2, 2, 4 (nie ma 3!)

**DENSE_RANK()** - ranking bez luk. Ex aequo dostają ten sam rank, ale następny jest kolejny:
Wynik: 1, 2, 2, 3 (3 jest zaraz po dwóch 2)

**NTILE(n)** - dzieli wiersze na n równych grup (percentile groups):
NTILE(4) = quartiles (kwartyle): 1, 1, 2, 2, 3, 3, 4, 4

**Wszystkie WYMAGAJĄ ORDER BY** - bo ranking bez kolejności nie ma sensu.

Pokażę każdą z przykładami."

**Wskazówki:**
- Wyjaśnij różnicę RANK vs DENSE_RANK - to często mylone
- NTILE jest mniej znane ale przydatne
- Szybkie intro, przykłady będą zaraz

---

# ROW_NUMBER() - PRZYKŁAD

```sql
-- Numeruj produkty od najtańszego do najdroższego
SELECT
    ROW_NUMBER() OVER (ORDER BY UnitPrice) AS RowNum,
    ProductName,
    UnitPrice
FROM Products
ORDER BY UnitPrice
LIMIT 10;
```

**Zastosowanie:** Stronicowanie (pagination)

```sql
-- Strona 2, 10 produktów na stronę
WITH NumberedProducts AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ProductName) AS RowNum,
        ProductID,
        ProductName,
        UnitPrice
    FROM Products
)
SELECT ProductID, ProductName, UnitPrice
FROM NumberedProducts
WHERE RowNum BETWEEN 11 AND 20;  -- strona 2
```

---

# NOTATKI DLA PROWADZĄCEGO - ROW_NUMBER

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"ROW_NUMBER() - najprostsza funkcja rankingowa. Daje każdemu wierszowi unikalny numer.

[Uruchom pierwszy przykład]

```sql
SELECT
    ROW_NUMBER() OVER (ORDER BY UnitPrice) AS RowNum,
    ProductName,
    UnitPrice
FROM Products
ORDER BY UnitPrice
LIMIT 10;
```

Widzicie? Każdy produkt ma unikalny RowNum od 1 wzwyż. Najtańszy produkt = 1, następny = 2, itd.

**WAŻNE:** Nawet jeśli dwa produkty mają TĘ SAMĄ cenę, dostaną RÓŻNE numery. ROW_NUMBER zawsze daje unikalne wartości.

**Praktyczne zastosowanie #1: Stronicowanie (pagination)**

To jest KLASYCZNE użycie ROW_NUMBER - stronicowanie wyników.

[Uruchom przykład ze stronicowaniem]

```sql
WITH NumberedProducts AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY ProductName) AS RowNum,
        ProductID,
        ProductName,
        UnitPrice
    FROM Products
)
SELECT ProductID, ProductName, UnitPrice
FROM NumberedProducts
WHERE RowNum BETWEEN 11 AND 20;
```

To daje produkty 11-20 (strona 2, jeśli 10 na stronę).

W web aplikacjach:
- Strona 1: WHERE RowNum BETWEEN 1 AND 10
- Strona 2: WHERE RowNum BETWEEN 11 AND 20
- Strona N: WHERE RowNum BETWEEN ((N-1)*10+1) AND (N*10)

**Praktyczne zastosowanie #2: Top N per grupa**

```sql
-- Top 3 najdroższe produkty W KAŻDEJ kategorii
WITH RankedProducts AS (
    SELECT
        ProductName,
        CategoryID,
        UnitPrice,
        ROW_NUMBER() OVER (
            PARTITION BY CategoryID
            ORDER BY UnitPrice DESC
        ) AS PriceRank
    FROM Products
)
SELECT ProductName, CategoryID, UnitPrice
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY CategoryID, PriceRank;
```

[Uruchom]

Patrzcie! Dla każdej kategorii dostajecie top 3 najdroższe produkty. PARTITION BY CategoryID dzieli na grupy, ORDER BY UnitPrice DESC sortuje malejąco, ROW_NUMBER numeruje.

Potem WHERE PriceRank <= 3 wybiera tylko top 3 z każdej kategorii.

To jest MEGA użyteczny pattern! Top N per grupa - używa się tego codziennie w analityce.

Spróbujcie sami (2 minuty):
Znajdźcie 5 najnowszych zamówień dla każdego klienta. Użyjcie ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC)."

**Wskazówki:**
- Podkreśl że ROW_NUMBER jest zawsze unikalny
- Stronicowanie to killer use case - wszyscy to rozumieją
- Top N per grupa - pokaż dokładnie, to bardzo przydatne
- Daj ćwiczenie - utrwala wzorzec

---

# RANK() vs DENSE_RANK()

```sql
SELECT
    ProductName,
    UnitPrice,
    ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum,
    RANK() OVER (ORDER BY UnitPrice DESC) AS Rank,
    DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS DenseRank
FROM Products
ORDER BY UnitPrice DESC
LIMIT 15;
```

**Porównanie** (jeśli dwa produkty mają cenę 18.00):

| ProductName | UnitPrice | RowNum | Rank | DenseRank |
|-------------|-----------|--------|------|-----------|
| Côte de Blaye | 263.50 | 1 | 1 | 1 |
| Thüringer... | 123.79 | 2 | 2 | 2 |
| Product A | 18.00 | 5 | 5 | 5 |
| Product B | 18.00 | 6 | **5** | **5** |
| Product C | 17.45 | 7 | **7** | **6** |

RANK ma lukę (5,5,7), DENSE_RANK nie ma (5,5,6).

---

# NOTATKI DLA PROWADZĄCEGO - RANK vs DENSE_RANK

**Czas trwania:** 5 minut

**Co powiedzieć:**
"Teraz różnica między RANK a DENSE_RANK. To często mylone, więc wyjaśnię dokładnie.

[Uruchom zapytanie]

```sql
SELECT
    ProductName,
    UnitPrice,
    ROW_NUMBER() OVER (ORDER BY UnitPrice DESC) AS RowNum,
    RANK() OVER (ORDER BY UnitPrice DESC) AS Rank,
    DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS DenseRank
FROM Products
ORDER BY UnitPrice DESC
LIMIT 15;
```

Patrzcie na wyniki...

**ROW_NUMBER:**
Zawsze unikalne: 1, 2, 3, 4, 5, 6, 7, 8...
Nawet jeśli dwa produkty mają tę samą cenę, dostaną różne numery. SQL musi jakoś rozróżnić (zwykle według kolejności w tabeli).

**RANK:**
Przy równych wartościach - ten sam rank, potem luka:

```
Produkt A: 20.00 -> Rank=5
Produkt B: 20.00 -> Rank=5 (taki sam!)
Produkt C: 19.00 -> Rank=7 (pominęło 6!)
```

Luka ma wielkość liczby tied records. Jeśli 3 produkty mają rank 5, następny ma rank 8.

**DENSE_RANK:**
Przy równych wartościach - ten sam rank, BEZ luki:

```
Produkt A: 20.00 -> DenseRank=5
Produkt B: 20.00 -> DenseRank=5 (taki sam!)
Produkt C: 19.00 -> DenseRank=6 (kolejny numer!)
```

Nie ma luk. Ranki są 'gęste' (dense).

**Które użyć?**

**RANK:** Kiedy chcecie 'sportowego' rankingu. W zawodach sportowych - jeśli dwóch na 2 miejscu, następny jest na 4.

```
1. Złoto: Jan
2. Srebro: Maria i Piotr (ex aequo)
4. Brąz: Anna
```

**DENSE_RANK:** Kiedy chcecie numerować 'poziomy'. Np. kategoryzacja klientów:

```
1. VIP (najwyższa wartość)
2. Premium
3. Standard
4. Basic
```

Nawet jeśli wielu klientów jest VIP, Basic to nadal poziom 4.

**ROW_NUMBER:** Kiedy potrzebujecie absolutnie unikalnych numerów (stronicowanie, deduplication).

**Przykład praktyczny - top 3 with ties:**

```sql
-- Top 3 najdroższe produkty, ALE jeśli jest remis na 3 miejscu, pokaż wszystkich
WITH RankedProducts AS (
    SELECT
        ProductName,
        UnitPrice,
        DENSE_RANK() OVER (ORDER BY UnitPrice DESC) AS Rank
    FROM Products
)
SELECT ProductName, UnitPrice, Rank
FROM RankedProducts
WHERE Rank <= 3;
```

DENSE_RANK zapewnia że dostaniecie wszystkie produkty z top 3 poziomów cenowych, nawet jeśli jest więcej niż 3 produktów (przez remisy).

Pytania do funkcji rankingowych?"

**Wskazówki:**
- Wyjaśnij różnicę RANK vs DENSE_RANK wizualnie
- Sportowa analogia dla RANK pomaga
- Pokaż praktyczny case kiedy co używać
- Upewnij się że wszyscy rozumieją różnicę

---

# NTILE(n) - PODZIAŁ NA GRUPY

```sql
-- Podziel produkty na 4 grupy (kwartyle) według ceny
SELECT
    ProductName,
    UnitPrice,
    NTILE(4) OVER (ORDER BY UnitPrice) AS PriceQuartile
FROM Products
ORDER BY UnitPrice;
```

**Wynik:** Każdy produkt dostaje numer grupy 1-4.
- Grupa 1: najtańsze 25%
- Grupa 2: następne 25%
- Grupa 3: następne 25%
- Grupa 4: najdroższe 25%

**Zastosowanie:**
- Segmentacja klientów (top/medium/low value)
- Analiza percentyli
- A/B testing groups

---

# NOTATKI DLA PROWADZĄCEGO - NTILE

**Czas trwania:** 4 minut

**Co powiedzieć:**
"NTILE to mniej znana funkcja rankingowa, ale bardzo użyteczna. Dzieli wiersze na N równych grup.

[Uruchom zapytanie]

```sql
SELECT
    ProductName,
    UnitPrice,
    NTILE(4) OVER (ORDER BY UnitPrice) AS PriceQuartile
FROM Products
ORDER BY UnitPrice;
```

NTILE(4) dzieli 77 produktów na 4 grupy (kwartyle):
- Grupa 1: produkty 1-20 (najtańsze 25%)
- Grupa 2: produkty 21-39
- Grupa 3: produkty 40-58
- Grupa 4: produkty 59-77 (najdroższe 25%)

Grupy są **mniej więcej równe**. Jeśli liczba wierszy nie dzieli się równo przez N, pierwsze grupy są odrobinę większe.

**Praktyczne zastosowania:**

**1. Segmentacja klientów:**

```sql
SELECT
    CustomerID,
    TotalPurchases,
    NTILE(5) OVER (ORDER BY TotalPurchases DESC) AS CustomerSegment,
    CASE NTILE(5) OVER (ORDER BY TotalPurchases DESC)
        WHEN 1 THEN 'VIP'
        WHEN 2 THEN 'Premium'
        WHEN 3 THEN 'Standard'
        WHEN 4 THEN 'Occasional'
        WHEN 5 THEN 'Rare'
    END AS SegmentName
FROM (
    SELECT CustomerID, SUM(Freight) AS TotalPurchases
    FROM Orders
    GROUP BY CustomerID
) customer_totals;
```

[Możesz uruchomić]

Top 20% klientów = VIP, bottom 20% = Rare.

**2. Analiza percentyli:**

```sql
-- Który percentyl danego produktu?
SELECT
    ProductName,
    UnitPrice,
    NTILE(100) OVER (ORDER BY UnitPrice) AS Percentile
FROM Products;
```

NTILE(100) daje percentyle (0-100%). Produkt w percentylu 90 = droższy niż 90% produktów.

**3. Równe grupy do testów:**

```sql
-- Podziel zamówienia na 3 grupy dla A/B/C testing
SELECT
    OrderID,
    NTILE(3) OVER (ORDER BY OrderID) AS TestGroup
FROM Orders;
```

Grupa 1 = kontrola, Grupa 2 = wariant A, Grupa 3 = wariant B.

**NTILE vs RANK:**

NTILE dba o równość grup - każda grupa ma podobną liczebność.
RANK dba o wartości - ranki odpowiadają dokładnie wartościom.

NTILE(4) z wartościami [1,2,3,3,3,10] da [1,1,2,2,3,4] - grupy po 1-2 elementy.
RANK z wartościami [1,2,3,3,3,10] da [1,2,3,3,3,6] - ranki według wartości.

Pytania do NTILE?"

**Wskazówki:**
- Wyjaśnij że grupy są równoliczne, nie równowartościowe
- Segmentacja klientów to killer use case
- Percentyle łatwo zrozumieć
- A/B testing pokazuje praktyczne użycie

---

# FUNKCJE AGREGUJĄCE JAKO WINDOW FUNCTIONS

## Każda funkcja agregująca może być window function:
- SUM()
- AVG()
- COUNT()
- MIN()
- MAX()
- Itd.

## Z OVER():
```sql
-- Zamiast GROUP BY
SELECT
    ProductID,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
FROM Products;
```

**Każdy wiersz pozostaje, ale dostaje informację o agregacji.**

---

# NOTATKI DLA PROWADZĄCEGO - AGREGATY JAKO WINDOW

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Do tej pory pokazywaliśmy dedykowane window functions (ROW_NUMBER, RANK, itd.). Ale KAŻDA funkcja agregująca może być użyta z OVER()!

SUM, AVG, COUNT, MIN, MAX - wszystkie.

**Różnica:**

Bez OVER (klasyczny GROUP BY):
```sql
SELECT CategoryID, AVG(UnitPrice)
FROM Products
GROUP BY CategoryID;
```
Wynik: 8 wierszy (po jednym na kategorię)

Z OVER:
```sql
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS AvgInCategory
FROM Products;
```
Wynik: 77 wierszy (wszystkie produkty), każdy MA informację o średniej w swojej kategorii

**Po co?**

Możecie robić porównania per-wiersz:

```sql
SELECT
    ProductName,
    CategoryID,
    UnitPrice,
    AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS CategoryAvg,
    UnitPrice - AVG(UnitPrice) OVER (PARTITION BY CategoryID) AS DiffFromAvg,
    CASE
        WHEN UnitPrice > AVG(UnitPrice) OVER (PARTITION BY CategoryID)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS PriceLevel
FROM Products;
```

[Uruchom]

Każdy produkt widzi czy jest droższy czy tańszy niż średnia w kategorii.

**Z ORDER BY - cumulative:**

```sql
SELECT
    OrderDate,
    Freight,
    SUM(Freight) OVER (ORDER BY OrderDate) AS RunningTotal,
    AVG(Freight) OVER (ORDER BY OrderDate) AS RunningAvg,
    COUNT(*) OVER (ORDER BY OrderDate) AS CumulativeOrders
FROM Orders
ORDER BY OrderDate
LIMIT 20;
```

Running total, running average, cumulative count - wszystko w jednym zapytaniu!

To są potężne narzędzia. Zapamiętajcie: każda agregat + OVER = window function."

**Wskazówki:**
- Podkreśl że WSZYSTKIE agregaty działają z OVER
- Przykład z porównaniem do średniej jest praktyczny
- Running totals/averages to częsty use case

---

# FUNKCJE PRZESUNIĘCIA - LAG i LEAD

## LAG() - wartość z poprzedniego wiersza
## LEAD() - wartość z następnego wiersza

## Składnia:
```sql
LAG(kolumna, offset, default) OVER (ORDER BY ...)
LEAD(kolumna, offset, default) OVER (ORDER BY ...)
```

- **offset:** ile wierszy w tył/przód (domyślnie 1)
- **default:** wartość jeśli nie ma wiersza (domyślnie NULL)

## Przykład:
```sql
SELECT
    OrderDate,
    Freight,
    LAG(Freight, 1) OVER (ORDER BY OrderDate) AS PrevFreight,
    LEAD(Freight, 1) OVER (ORDER BY OrderDate) AS NextFreight
FROM Orders;
```

---

# NOTATKI DLA PROWADZĄCEGO - LAG/LEAD

**Czas trwania:** 6-7 minut

**Co powiedzieć:**
"Teraz funkcje przesunięcia - LAG i LEAD. To są super użyteczne funkcje do analizy trendów i zmian w czasie.

**LAG** - patrzy WSTECZ. Daje wartość z poprzedniego wiersza.
**LEAD** - patrzy W PRZÓD. Daje wartość z następnego wiersza.

[Uruchom przykład]

```sql
SELECT
    OrderID,
    OrderDate,
    Freight,
    LAG(Freight) OVER (ORDER BY OrderDate) AS PrevFreight,
    LEAD(Freight) OVER (ORDER BY OrderDate) AS NextFreight
FROM Orders
ORDER BY OrderDate
LIMIT 10;
```

Patrzcie na wyniki:

Pierwsze zamówienie: PrevFreight=NULL (nie ma poprzedniego), NextFreight=wartość z drugiego
Drugie zamówienie: PrevFreight=wartość z pierwszego, NextFreight=wartość z trzeciego
...
Ostatnie: NextFreight=NULL (nie ma następnego)

**Parametry:**

```sql
LAG(kolumna, offset, default_value)
```

- **offset:** o ile wierszy w tył. LAG(Freight, 2) = wartość sprzed 2 wierszy
- **default_value:** co zwrócić jeśli nie ma wiersza. LAG(Freight, 1, 0) = 0 zamiast NULL

**Praktyczne zastosowanie #1: Obliczanie zmian (delta):**

```sql
SELECT
    OrderID,
    OrderDate,
    Freight,
    LAG(Freight) OVER (ORDER BY OrderDate) AS PrevFreight,
    Freight - LAG(Freight) OVER (ORDER BY OrderDate) AS FreightChange,
    ROUND(
        100.0 * (Freight - LAG(Freight) OVER (ORDER BY OrderDate))
        / LAG(Freight) OVER (ORDER BY OrderDate),
        2
    ) AS FreightChangePct
FROM Orders
ORDER BY OrderDate
LIMIT 20;
```

[Uruchom]

Widzicie kolumnę FreightChange - to różnica między bieżącym a poprzednim zamówieniem. FreightChangePct to % zmiany.

**Zastosowanie #2: Wykrywanie trendów:**

```sql
-- Produkty gdzie cena rośnie w każdej kolejnej dostawie
WITH PriceChanges AS (
    SELECT
        p.ProductID,
        p.ProductName,
        o.OrderDate,
        od.UnitPrice,
        LAG(od.UnitPrice) OVER (
            PARTITION BY p.ProductID
            ORDER BY o.OrderDate
        ) AS PrevPrice
    FROM `Order Details` od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
)
SELECT
    ProductID,
    ProductName,
    COUNT(*) AS Observations,
    SUM(CASE WHEN UnitPrice > PrevPrice THEN 1 ELSE 0 END) AS PriceIncreases
FROM PriceChanges
WHERE PrevPrice IS NOT NULL
GROUP BY ProductID, ProductName
HAVING SUM(CASE WHEN UnitPrice > PrevPrice THEN 1 ELSE 0 END) > 0
ORDER BY PriceIncreases DESC;
```

Złożone, ale pokazuje produkty gdzie cena często rośnie.

**Zastosowanie #3: Gap analysis (znajdowanie luk):**

```sql
-- Zamówienia z luką >7 dni od poprzedniego
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PrevOrderDate,
    DATEDIFF(
        OrderDate,
        LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
    ) AS DaysSinceLast
FROM Orders
WHERE DATEDIFF(
        OrderDate,
        LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
    ) > 7
ORDER BY DaysSinceLast DESC;
```

Znajduje klientów którzy mieli długą przerwę między zamówieniami - może potrzebują follow-up?

**LEAD** działa identycznie, tylko w przód:

```sql
-- Następne zamówienie klienta
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    LEAD(OrderDate) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS NextOrderDate
FROM Orders;
```

Pytania do LAG/LEAD?"

**Wskazówki:**
- LAG/LEAD to bardzo praktyczne funkcje
- Obliczanie delta/change to killer use case
- Gap analysis pokazuje biznesową wartość
- Parametr offset i default są ważne - wyjaśnij

---

# FIRST_VALUE i LAST_VALUE

## FIRST_VALUE() - pierwsza wartość w oknie
## LAST_VALUE() - ostatnia wartość w oknie

## Przykład:
```sql
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    FIRST_VALUE(ProductName) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
    ) AS CheapestInCategory,
    LAST_VALUE(ProductName) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS MostExpensiveInCategory
FROM Products;
```

**UWAGA:** LAST_VALUE wymaga zdefiniowania pełnego okna!

---

# NOTATKI DLA PROWADZĄCEGO - FIRST/LAST VALUE

**Czas trwania:** 5 minut

**Co powiedzieć:**
"Ostatnie dwie funkcje przesunięcia: FIRST_VALUE i LAST_VALUE. Dają pierwszą i ostatnią wartość w oknie.

[Uruchom zapytanie - może trzeba będzie poprawić dla Databricks]

**FIRST_VALUE:**

Prosta - daje pierwszy wiersz w oknie (według ORDER BY).

```sql
FIRST_VALUE(ProductName) OVER (
    PARTITION BY CategoryID
    ORDER BY UnitPrice
)
```

Dla każdego produktu pokazuje najtańszy produkt w jego kategorii.

**LAST_VALUE - PUŁAPKA:**

```sql
LAST_VALUE(ProductName) OVER (
    PARTITION BY CategoryID
    ORDER BY UnitPrice
)
```

To NIE daje najdroższego produktu! Dlaczego?

**Domyślne okno:**

Kiedy używacie ORDER BY, domyślne okno to:
```
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

To znaczy: od początku DO BIEŻĄCEGO wiersza.

Więc LAST_VALUE daje... bieżący wiersz! Nie to co chcieliście.

**Rozwiązanie - explicit window frame:**

```sql
LAST_VALUE(ProductName) OVER (
    PARTITION BY CategoryID
    ORDER BY UnitPrice
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
```

UNBOUNDED FOLLOWING = do końca partycji. Teraz LAST_VALUE daje rzeczywiście ostatni (najdroższy) produkt.

**Praktyczny przykład:**

```sql
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    FIRST_VALUE(ProductName) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
    ) AS CheapestProduct,
    FIRST_VALUE(UnitPrice) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
    ) AS LowestPrice,
    LAST_VALUE(ProductName) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS MostExpensiveProduct,
    LAST_VALUE(UnitPrice) OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS HighestPrice
FROM Products
ORDER BY CategoryID, UnitPrice;
```

Każdy produkt widzi zakres cenowy w swojej kategorii - od najtańszego do najdroższego.

**Kiedy używać FIRST/LAST_VALUE:**

- Pokazanie min/max z nazwą (MIN/MAX dają tylko wartość, nie wiersz)
- Porównanie bieżącego do ekstrema w grupie
- Benchmark - jak daleko od najlepszego/najgorszego

**Alternatywa - MIN/MAX:**

Często prościej użyć MIN/MAX:

```sql
SELECT
    ProductName,
    UnitPrice,
    MIN(UnitPrice) OVER (PARTITION BY CategoryID) AS MinPrice,
    MAX(UnitPrice) OVER (PARTITION BY CategoryID) AS MaxPrice
FROM Products;
```

To daje wartości, ale nie nazwy produktów. FIRST/LAST_VALUE dają cały wiersz.

Pytania?"

**Wskazówki:**
- OSTRZEŻ o pułapce LAST_VALUE - to częsty błąd
- Wyjaśnij czemu potrzeba UNBOUNDED FOLLOWING
- Pokaż alternatywę MIN/MAX
- Window frames będą omówione zaraz - to prowadzi do następnego tematu

---

# WINDOW FRAMES (RAMKI)

## Co to jest frame?
**Frame (ramka)** = podzbiór wierszy w oknie, dla którego obliczana jest funkcja.

## Składnia:
```sql
funkcja() OVER (
    PARTITION BY ...
    ORDER BY ...
    [ROWS | RANGE] BETWEEN <start> AND <end>
)
```

## Granice ramki:
- **UNBOUNDED PRECEDING** - od początku partycji
- **n PRECEDING** - n wierszy przed bieżącym
- **CURRENT ROW** - bieżący wiersz
- **n FOLLOWING** - n wierszy po bieżącym
- **UNBOUNDED FOLLOWING** - do końca partycji

---

# NOTATKI DLA PROWADZĄCEGO - WINDOW FRAMES INTRO

**Czas trwania:** 4 minut

**Co powiedzieć:**
"Teraz najbardziej zaawansowany aspekt window functions - window frames (ramki).

**Co to jest frame?**

Frame to **podzbiór wierszy w oknie**, na którym obliczana jest funkcja w danym momencie.

Do tej pory używaliśmy domyślnych frames. Teraz pokażę jak je kontrolować.

**Po co?**

Przykład: chcecie **moving average** - średnia krocząca z ostatnich 3 zamówień.

Bez frames:
```sql
AVG(Freight) OVER (ORDER BY OrderDate)
-- to daje średnią od początku do bieżącego (cumulative)
```

Z frames:
```sql
AVG(Freight) OVER (
    ORDER BY OrderDate
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)
-- to daje średnią z 3 wierszy: 2 poprzednie + bieżący
```

**Składnia:**

```sql
[ROWS | RANGE] BETWEEN <start> AND <end>
```

**ROWS** = liczy fizyczne wiersze
**RANGE** = liczy według wartości (dla RANGE trzeba uważać)

**Granice:**

- UNBOUNDED PRECEDING = od samego początku partycji
- n PRECEDING = n wierszy przed bieżącym
- CURRENT ROW = bieżący wiersz
- n FOLLOWING = n wierszy po bieżącym
- UNBOUNDED FOLLOWING = do samego końca partycji

**Domyślne frames:**

Bez ORDER BY:
```
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
```
(cała partycja)

Z ORDER BY:
```
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```
(od początku do bieżącego - stąd cumulative behavior!)

Teraz pokażę przykłady."

**Wskazówki:**
- Frame to trudny koncept - wyjaśnij powoli
- Moving average to najlepszy przykład użyteczności
- Pokaż różnicę domyślnych frames z/bez ORDER BY
- Wizualizacja na tablicy pomaga

---

# WINDOW FRAMES - PRZYKŁADY

## 1. Moving Average (średnia krocząca):
```sql
SELECT
    OrderDate,
    Freight,
    AVG(Freight) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS MovingAvg7Days
FROM Orders
ORDER BY OrderDate;
```

Średnia z ostatnich 7 zamówień (6 poprzednich + bieżące).

## 2. Centered moving average:
```sql
AVG(Freight) OVER (
    ORDER BY OrderDate
    ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
)
```

Średnia z 7 wierszy: 3 przed, bieżący, 3 po.

---

# NOTATKI DLA PROWADZĄCEGO - FRAMES PRZYKŁADY

**Czas trwania:** 6-7 minut

**Co powiedzieć:**
"Zobaczmy praktyczne przykłady frame'ów.

**Moving Average (średnia krocząca):**

[Uruchom]

```sql
SELECT
    OrderDate,
    Freight,
    AVG(Freight) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS MovingAvg7,
    AVG(Freight) OVER (ORDER BY OrderDate) AS CumulativeAvg
FROM Orders
ORDER BY OrderDate
LIMIT 20;
```

Porównajcie MovingAvg7 vs CumulativeAvg:

- **CumulativeAvg:** rośnie stabilnie, bo uśrednia wszystko od początku
- **MovingAvg7:** fluktuuje więcej, bo uśrednia tylko ostatnie 7 zamówień

Moving average jest lepszy do wykrywania trendów - ignoruje stare dane.

**Centered moving average:**

```sql
SELECT
    OrderDate,
    Freight,
    AVG(Freight) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
    ) AS CenteredAvg
FROM Orders
ORDER BY OrderDate;
```

To uśrednia 3 przed + bieżący + 3 po. Używane w analizie szeregów czasowych - wygładza wykres symetrycznie.

**Running total z ograniczeniem:**

```sql
SELECT
    OrderDate,
    Freight,
    SUM(Freight) OVER (
        ORDER BY OrderDate
        ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
    ) AS Last10OrdersTotal
FROM Orders;
```

Suma z ostatnich 10 zamówień. To NIE jest cumulative - to sliding window sum.

**Porównanie do max/min w oknie:**

```sql
SELECT
    ProductID,
    OrderDate,
    Quantity,
    MAX(Quantity) OVER (
        PARTITION BY ProductID
        ORDER BY OrderDate
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS MaxInLast5Orders,
    MIN(Quantity) OVER (
        PARTITION BY ProductID
        ORDER BY OrderDate
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ) AS MinInLast5Orders
FROM `Order Details` od
JOIN Orders o ON od.OrderID = o.OrderID
ORDER BY ProductID, OrderDate;
```

Dla każdego produktu widzicie max i min quantity w ostatnich 5 zamówieniach.

**ROWS vs RANGE - różnica:**

**ROWS** liczy fizyczne wiersze:
```sql
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
```
= dokładnie 3 wiersze (2 poprzednie + bieżący)

**RANGE** liczy według wartości ORDER BY:
```sql
RANGE BETWEEN 2 PRECEDING AND CURRENT ROW
```
= wszystkie wiersze gdzie wartość ORDER BY jest między (current-2) a current

Przykład z datami:
```sql
-- ROWS: 3 poprzednie zamówienia
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW

-- RANGE: wszystkie zamówienia z ostatnich 3 dni
RANGE BETWEEN INTERVAL 3 DAYS PRECEDING AND CURRENT ROW
```

RANGE jest rzadziej używany, ale potężny dla analiz czasowych.

**Uwaga Databricks:**

Składnia RANGE z INTERVAL może się różnić w Databricks. Sprawdźcie dokumentację. ROWS zawsze działa.

Pytania do frames?"

**Wskazówki:**
- Moving average to must-know przykład
- Pokaż różnicę moving vs cumulative
- ROWS vs RANGE - wyjaśnij ale nie przesadzaj z RANGE (rzadko używany)
- Databricks może mieć ograniczenia w RANGE - ostrzeż

---

# WINDOW FRAMES - DOMYŚLNE ZACHOWANIA

## Podsumowanie domyślnych frames:

```sql
-- Bez ORDER BY:
funkcja() OVER (PARTITION BY ...)
-- Domyślnie: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- = cała partycja

-- Z ORDER BY:
funkcja() OVER (PARTITION BY ... ORDER BY ...)
-- Domyślnie: RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- = od początku do bieżącego (cumulative)
```

## Kiedy explicit frame:
- Moving averages/sums
- Centered calculations
- Ograniczone okna czasowe
- LAST_VALUE (potrzebuje UNBOUNDED FOLLOWING)

---

# NOTATKI DLA PROWADZĄCEGO - DOMYŚLNE FRAMES

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Podsumujmy domyślne zachowania frames - to ważne żeby rozumieć co się dzieje 'pod maską'.

**Bez ORDER BY:**

```sql
SUM(kolumna) OVER (PARTITION BY grupa)
```

Domyślny frame: cała partycja (UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING).
Każdy wiersz widzi sumę całej grupy. Logiczne - bez kolejności, nie ma sensu cumulative.

**Z ORDER BY:**

```sql
SUM(kolumna) OVER (PARTITION BY grupa ORDER BY data)
```

Domyślny frame: od początku do bieżącego (UNBOUNDED PRECEDING AND CURRENT ROW).
Stąd cumulative behavior - running total!

**Kiedy pisać explicit frame:**

Zawsze kiedy chcecie coś innego niż domyślne:
- Moving average: `ROWS BETWEEN n PRECEDING AND CURRENT ROW`
- Centered calculation: `ROWS BETWEEN n PRECEDING AND n FOLLOWING`
- Full window mimo ORDER BY: `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`

Zapamiętajcie: jeśli wynik nie jest taki jak oczekiwaliście, sprawdźcie domyślny frame!"

**Wskazówki:**
- Podkreśl różnicę z/bez ORDER BY
- To wyjaśnia dlaczego ORDER BY daje cumulative
- Krótko - to podsumowanie, szczegóły były wcześniej

---

# FUNKCJE ANALITYCZNE - PODSUMOWANIE

## ✅ Co omówiliśmy:
- **OVER()** - podstawowa składnia window functions
- **PARTITION BY** - podział na grupy
- **ORDER BY** - kolejność w oknie
- **ROW_NUMBER, RANK, DENSE_RANK, NTILE** - funkcje rankingowe
- **Agregaty jako window functions** - SUM, AVG, COUNT, MIN, MAX
- **LAG, LEAD** - wartości z poprzednich/następnych wierszy
- **FIRST_VALUE, LAST_VALUE** - pierwszy/ostatni w oknie
- **Window Frames** - ROWS/RANGE, kontrola ramki

## Kluczowe wzorce:
- Top N per grupa: `ROW_NUMBER() OVER (PARTITION BY grupa ORDER BY wartość)`
- Running total: `SUM(wartość) OVER (ORDER BY data)`
- Moving average: `AVG(wartość) OVER (ORDER BY data ROWS BETWEEN n PRECEDING AND CURRENT ROW)`
- Porównanie do średniej: `wartość - AVG(wartość) OVER (PARTITION BY grupa)`

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE

**Czas trwania:** 5 minut

**Co powiedzieć:**
"WOW! Mamy za sobą 90 minut funkcji analitycznych. To była najdłuższa i najbardziej złożona sekcja dzisiejszego szkolenia. Świetna robota!

**Podsumujmy co pokryliśmy:**

**OVER() - fundament:**
To zmienia agregaty w window functions. Każdy wiersz pozostaje, ale dostaje dodatkowe informacje.

**PARTITION BY i ORDER BY:**
PARTITION dzieli na grupy, ORDER sortuje w grupach. To dwa kluczowe elementy kontroli.

**Funkcje rankingowe:**
- ROW_NUMBER: unikalne numery (stronicowanie, top N)
- RANK: ranking z lukami (sportowy)
- DENSE_RANK: ranking bez luk (poziomy)
- NTILE: podział na równe grupy (segmentacja)

**Agregaty:**
SUM, AVG, COUNT, MIN, MAX - wszystkie działają z OVER. Z ORDER BY dają cumulative results.

**Przesunięcia:**
LAG/LEAD - wartości z sąsiednich wierszy (analiza zmian, trendy)
FIRST/LAST_VALUE - ekstrema w oknie

**Frames:**
Kontrola podzbioru wierszy. Moving averages, sliding windows, custom calculations.

**Najważniejsze wzorce - ZAPAMIĘTAJCIE:**

1. **Top N per grupa:**
```sql
WITH Ranked AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY grupa ORDER BY wartość DESC) AS rn
    FROM tabela
)
SELECT * FROM Ranked WHERE rn <= N;
```

2. **Running total:**
```sql
SUM(wartość) OVER (ORDER BY data)
```

3. **Moving average:**
```sql
AVG(wartość) OVER (ORDER BY data ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
```

4. **Porównanie do średniej w grupie:**
```sql
wartość - AVG(wartość) OVER (PARTITION BY grupa)
```

Te 4 wzorce pokrywają 80% use cases window functions!

**Kluczowe wnioski:**

1. Window functions = SQL na sterydach. Rzeczy niemożliwe w podstawowym SQL stają się banalne.

2. Eliminują potrzebę self-joins i złożonych podzapytań. Kod jest czystszy, szybszy.

3. To nie jest syntactic sugar - optymalizator wykonuje to WYDAJNIEJ niż alternatywne podejścia.

4. Wymaga praktyki. Pierwsze zapytania będą trudne. Po tygodniu będziecie pisać to z zamkniętymi oczami.

**Pytania ogólne do funkcji analitycznych?**

[Pauza na pytania]

To była trudna część. Jeśli głowa Was boli - to normalne. Window functions to najbardziej złożony temat zaawansowanego SQL-a. Ale też najbardziej powerful.

Dostajecie notebooki z dziesiątkami przykładów. Ćwiczcie, eksperymentujcie. Za tydzień-dwa to będzie druga natura.

Mamy jeszcze 1.5h szkolenia. Zostały 3 tematy:
- Funkcje użytkownika (30 min)
- Co jeszcze warto wiedzieć (45 min)
- Podsumowanie i zadania (15 min)

Zróbmy 10-minutową przerwę. Zasłużyliście! Zostawiam podsumowanie na ekranie - róbcie screenshot."

**Wskazówki:**
- Pogratuluj grupie - 90 min to było ciężkie
- Podkreśl kluczowe wzorce - ludzie lubią konkretne recipes
- Zachęć do praktyki - window functions wymagają użycia żeby wsiąknąć
- Przerwa jest KONIECZNA po tak intensywnej sekcji
- Następne tematy są lżejsze - daj im to poczuć

---

**KONIEC ROZDZIAŁU 5: FUNKCJE ANALITYCZNE**

Szacowany czas realizacji: 90 minut

**PRZERWA: 10 minut**

Następny rozdział: **Funkcje użytkownika (UDF) - 30 minut**
