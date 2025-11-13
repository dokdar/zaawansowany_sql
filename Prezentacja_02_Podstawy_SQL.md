# PODSTAWY SQL
## Krótkie przypomnienie

---

# PO CO PRZYPOMNIENIE?

## Sprawdzamy fundamenty:
- SELECT, WHERE, JOIN
- Funkcje agregujące podstawowe
- GROUP BY i HAVING
- ORDER BY i LIMIT
- Podstawowe typy danych

## Cel:
Upewnić się, że wszyscy mówimy tym samym językiem przed przejściem do zaawansowanych technik.

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE DO PODSTAW

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Dobra, zaczynamy część merytoryczną! Pierwsza sekcja to przypomnienie podstaw SQL. Wiem, że wszyscy macie doświadczenie z SQL-em, ale chcę się upewnić, że mówimy tym samym językiem zanim wejdziemy w zaawansowane techniki.

To będzie szybkie przypomnienie - około 30 minut. Jeśli coś jest Wam dobrze znane, to świetnie - będziemy szybko naprzód. Jeśli ktoś gdzieś zaciął - to okazja do odświeżenia.

Przejdziemy przez:
- SELECT i filtrowanie danych
- JOIN-y (różne typy)
- Podstawowe funkcje agregujące
- GROUP BY i HAVING
- Sortowanie i limitowanie

Nie będziemy wchodzić głęboko - to tylko rozgrzewka przed głównym daniem. Każdy temat pokażę na przykładzie z bazy Northwind, a wy spróbujecie prostego ćwiczenia. Okej? To zaczynamy!"

**Wskazówki:**
- Mów z energią - to początek właściwej części
- Sprawdź szybko poziom grupy: "Kto pracuje z SQL-em codziennie?" "Kto pracuje okazjonalnie?"
- Dostosuj tempo do poziomu grupy - jeśli widzisz że wszyscy świetnie znają podstawy, możesz przyspieszyć

---

# SELECT - PODSTAWY

## Składnia podstawowa:
```sql
SELECT kolumna1, kolumna2, kolumna3
FROM nazwa_tabeli
WHERE warunek
ORDER BY kolumna1
LIMIT liczba;
```

## Przykład:
```sql
SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC
LIMIT 10;
```

**Wynik:** 10 najdroższych produktów (cena > 20)

---

# NOTATKI DLA PROWADZĄCEGO - SELECT PODSTAWY

**Czas trwania:** 3-4 minuty

**Co powiedzieć:**
"Zaczynamy od absolutnych podstaw - polecenia SELECT. To fundament każdego zapytania SQL.

**Anatomia zapytania SELECT:**

Patrzcie na ten przykład: [wskaż na slajd]

```sql
SELECT ProductName, UnitPrice, UnitsInStock
FROM Products
WHERE UnitPrice > 20
ORDER BY UnitPrice DESC
LIMIT 10;
```

Rozłóżmy to na części:

**SELECT** - mówimy JAKIE kolumny chcemy zobaczyć. Tutaj: nazwę produktu, cenę i stan magazynowy.

**FROM** - mówimy SKĄD bierzemy dane. Tutaj: z tabeli Products.

**WHERE** - to FILTR. Pokazujemy tylko produkty droższe niż 20 jednostek waluty. WHERE działa PRZED agregacją.

**ORDER BY** - jak SORTOWAĆ wyniki. DESC znaczy descending - malejąco. Więc najdroższe będą na górze.

**LIMIT** - ile MAKSYMALNIE rekordów pokazać. Tutaj: 10. W niektórych SQL-ach (jak SQL Server) używa się TOP zamiast LIMIT, ale w Databricks/Spark SQL mamy LIMIT.

**Uruchommy to:**
[Skopiuj zapytanie do notebooka i uruchom]

Widzicie? Dostaliśmy 10 najdroższych produktów. Na pierwszym miejscu mamy 'Côte de Blaye' - wino za 263.50.

**Kilka wskazówek:**

1. **SELECT *** - można wybrać wszystkie kolumny gwiazdką:
```sql
SELECT * FROM Products LIMIT 5;
```
Ale w produkcji NIE róbcie tego jeśli nie musicie. Lepiej wyraźnie wypisać kolumny - kod jest czytelniejszy i czasem wydajniejszy.

2. **Aliasy** - możemy nadawać kolumnom nowe nazwy:
```sql
SELECT
    ProductName AS Produkt,
    UnitPrice AS Cena,
    UnitsInStock AS Stan
FROM Products
LIMIT 5;
```
AS nie jest obowiązkowe, ale czytelniejsze.

3. **Obliczenia w SELECT:**
```sql
SELECT
    ProductName,
    UnitPrice,
    UnitsInStock,
    UnitPrice * UnitsInStock AS WartoścMagazynowa
FROM Products
LIMIT 10;
```

Możemy robić obliczenia bezpośrednio w SELECT - dodawanie, mnożenie, funkcje.

Jakieś pytania do SELECT? To jest banalnie proste ale wszystko na tym stoi."

**Wskazówki:**
- Demonstruj na żywo - uruchamiaj każde zapytanie
- Zachęć uczestników do uruchomienia tych samych zapytań u siebie
- Jeśli widzisz że wszyscy dobrze znają SELECT, nie rozwodź się - przejdź szybciej

---

# WHERE - FILTROWANIE DANYCH

## Operatory porównania:
- `=` - równe
- `<>` lub `!=` - różne
- `>`, `>=` - większe, większe lub równe
- `<`, `<=` - mniejsze, mniejsze lub równe

## Operatory logiczne:
- `AND` - i
- `OR` - lub
- `NOT` - negacja

## Przykłady:
```sql
-- Produkty z kategorii 1 i cenie poniżej 20
SELECT ProductName, CategoryID, UnitPrice
FROM Products
WHERE CategoryID = 1 AND UnitPrice < 20;

-- Produkty wycofane LUB brak w magazynie
SELECT ProductName, Discontinued, UnitsInStock
FROM Products
WHERE Discontinued = TRUE OR UnitsInStock = 0;
```

---

# NOTATKI DLA PROWADZĄCEGO - WHERE

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"WHERE to miejsce gdzie filtrujemy dane. Zanim dane trafią do wyniku, muszą przejść przez filtr WHERE.

**Operatory porównania** - proste i intuicyjne:
- Równość: `UnitPrice = 20`
- Nierówność: `UnitPrice <> 20` albo `UnitPrice != 20` (oba działają)
- Większe/mniejsze: `UnitPrice > 20`, `UnitPrice <= 50`

**Operatory logiczne** - łączymy warunki:

AND - oba warunki muszą być prawdziwe:
```sql
WHERE CategoryID = 1 AND UnitPrice < 20
```
'Kategoria 1 ORAZ cena poniżej 20'

OR - wystarczy jeden prawdziwy warunek:
```sql
WHERE Discontinued = TRUE OR UnitsInStock = 0
```
'Wycofany LUB brak w magazynie'

NOT - negacja:
```sql
WHERE NOT CategoryID = 1
-- to samo co:
WHERE CategoryID <> 1
```

**Ważna zasada: kolejność wykonywania:**
AND ma wyższy priorytet niż OR. Jeśli łączycie oba, używajcie nawiasów:

```sql
-- Źle - niejasne:
WHERE CategoryID = 1 OR CategoryID = 2 AND UnitPrice > 20

-- Dobrze - jasne:
WHERE (CategoryID = 1 OR CategoryID = 2) AND UnitPrice > 20
```

**Inne przydatne operatory WHERE:**

```sql
-- IN - sprawdza czy wartość jest na liście
WHERE CategoryID IN (1, 2, 3)

-- BETWEEN - zakres
WHERE UnitPrice BETWEEN 10 AND 50

-- LIKE - wzorce tekstowe (% = dowolne znaki)
WHERE ProductName LIKE '%Chocolate%'

-- IS NULL / IS NOT NULL - sprawdza NULL
WHERE Region IS NULL
```

Spróbujcie sami:
Znajdźcie wszystkie produkty, które:
- Są z kategorii 3 lub 4
- Kosztują między 10 a 30
- Nie są wycofane

[Daj czas ~2 minuty]

Rozwiązanie:
```sql
SELECT ProductName, CategoryID, UnitPrice, Discontinued
FROM Products
WHERE CategoryID IN (3, 4)
  AND UnitPrice BETWEEN 10 AND 30
  AND Discontinued = FALSE;
```

Pytania? Nie? Idziemy dalej - JOIN-y!"

**Wskazówki:**
- To podstawy, ale upewnij się że wszyscy pamiętają różnicę AND/OR
- Podkreśl ważność nawiasów przy złożonych warunkach
- Daj proste ćwiczenie do samodzielnego rozwiązania

---

# JOIN - ŁĄCZENIE TABEL

## Typy JOIN:

**INNER JOIN** - tylko rekordy które mają dopasowanie w obu tabelach

**LEFT JOIN** - wszystkie z lewej + dopasowane z prawej

**RIGHT JOIN** - wszystkie z prawej + dopasowane z lewej

**FULL OUTER JOIN** - wszystkie z obu tabel

**CROSS JOIN** - iloczyn kartezjański (każdy z każdym)

---

# NOTATKI DLA PROWADZĄCEGO - JOIN TYPY

**Czas trwania:** 1-2 minuty (wprowadzenie)

**Co powiedzieć:**
"No dobra, teraz JOIN-y. To jest serce relacyjnych baz danych - łączenie danych z różnych tabel.

Mamy kilka typów JOIN-ów i ważne żeby rozumieć różnicę:

**INNER JOIN** - najbardziej popularny. Pokazuje tylko te rekordy, które mają dopasowanie w OBIE tabelach. Jak wezmę Products i Categories, dostanę tylko produkty które mają przypisaną kategorię.

**LEFT JOIN** (albo LEFT OUTER JOIN) - bierzemy WSZYSTKIE rekordy z lewej tabeli, plus dopasowane z prawej. Jeśli nie ma dopasowania, kolumny z prawej będą NULL.

**RIGHT JOIN** - odwrotność LEFT. W praktyce rzadko używany - łatwiej zamienić kolejność tabel i użyć LEFT.

**FULL OUTER JOIN** - wszystkie rekordy z obu tabel. Jeśli nie ma dopasowania, druga strona NULL.

**CROSS JOIN** - iloczyn kartezjański. Każdy rekord z jednej tabeli z każdym z drugiej. Uwaga: może dać OGROMNĄ liczbę rekordów! Rzadko potrzebny w praktyce.

W 99% przypadków używacie INNER JOIN lub LEFT JOIN. Pokażę Wam przykłady."

**Wskazówki:**
- Możesz narysować prostdiagram Venna dla JOIN-ów jeśli masz tablicę
- Nie męcz zbytnio teorią - zaraz pokażesz praktyczne przykłady

---

# INNER JOIN - PRZYKŁAD

```sql
SELECT
    p.ProductName,
    c.CategoryName,
    s.CompanyName AS Supplier,
    p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY p.ProductName
LIMIT 10;
```

**Wyjaśnienie:**
- Łączymy 3 tabele: Products, Categories, Suppliers
- `p`, `c`, `s` to aliasy tabel (krócej pisać)
- `ON` określa warunek łączenia (klucz obcy = klucz główny)

---

# NOTATKI DLA PROWADZĄCEGO - INNER JOIN

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Zobaczmy INNER JOIN w akcji. To jest typowe zapytanie biznesowe - chcemy zobaczyć produkty z nazwami kategorii i dostawców.

[Wskaż na kod]

```sql
SELECT
    p.ProductName,
    c.CategoryName,
    s.CompanyName AS Supplier,
    p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY p.ProductName
LIMIT 10;
```

**Rozbiór:**

**Aliasy tabel:** `Products p` - nazywam tabelę Products krótko 'p'. Potem mogę pisać `p.ProductName` zamiast `Products.ProductName`. To oszczędza pisania i czyni kod czytelniejszym.

**Pierwszy JOIN:**
```sql
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
```
Łączę Products z Categories. ON mówi JAK łączyć - pole CategoryID z Products musi być równe CategoryID z Categories. To jest relacja klucz obcy - klucz główny.

**Drugi JOIN:**
```sql
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
```
Podobnie łączę z Suppliers.

**Wynik:** [Uruchom zapytanie]

Widzicie? Każdy produkt ma teraz nazwę kategorii i nazwę dostawcy. Nie pokazujemy ID-ków - pokazujemy czytelne nazwy.

**Ważna uwaga:** INNER JOIN pokazuje tylko produkty które MAJĄ kategorię i dostawcę. Gdyby jakiś produkt miał NULL w CategoryID, nie pojawiłby się w wynikach.

**Kolejność JOIN-ów** może być ważna dla czytelności, ale SQL przeważnie optymalizuje to sam. Piszcie w kolejności logicznej dla człowieka.

**Ćwiczenie dla Was (3 minuty):**
Napiszcie zapytanie które pokaże:
- Nazwę produktu (Products)
- Kategorię (Categories)
- Cenę (Products)
- Stan magazynowy (Products)

Tylko produkty z kategorii 'Beverages' (napoje), posortowane po cenie malejąco.

[Pauza 3 minuty na pracę]

Kto chce pokazać rozwiązanie? [Weź zgłoszenie]

Moje rozwiązanie:
```sql
SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice,
    p.UnitsInStock
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages'
ORDER BY p.UnitPrice DESC;
```

Zauważcie: WHERE działa PO JOIN-ie. Najpierw łączę tabele, potem filtruję."

**Wskazówki:**
- Uruchom zapytanie na żywo
- Wyjaśnij dlaczego używamy aliasów
- Daj proste ćwiczenie - to utrwala wiedzę
- Jeśli ktoś ma błąd w ćwiczeniu, pomóż zrozumieć dlaczego

---

# LEFT JOIN - PRZYKŁAD

```sql
-- Produkty z kategoriami (nawet jeśli kategoria nieznana)
SELECT
    p.ProductName,
    c.CategoryName,
    p.UnitPrice
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
ORDER BY c.CategoryName, p.ProductName;
```

**Różnica vs INNER JOIN:**
- INNER: tylko produkty z kategorią
- LEFT: wszystkie produkty, kategoria może być NULL

```sql
-- Kategorie bez produktów (sprawdzamy "dziury")
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
```

---

# NOTATKI DLA PROWADZĄCEGO - LEFT JOIN

**Czas trwania:** 3-4 minuty

**Co powiedzieć:**
"LEFT JOIN to drugi najczęściej używany typ JOIN-a. Różnica vs INNER jest subtelna ale ważna.

**INNER JOIN:** Produkt bez kategorii? Nie pokażę go.
**LEFT JOIN:** Produkt bez kategorii? Pokażę go, kategoria będzie NULL.

[Uruchom pierwszy przykład]

W naszej bazie wszystkie produkty mają kategorie, więc wynik jest identyczny jak przy INNER JOIN. Ale gdyby jakiś produkt miał NULL w CategoryID, przy LEFT JOIN zobaczylibyśmy go z pustą kategorią.

**Gdzie LEFT JOIN jest naprawdę przydatny?**

Kiedy chcemy znaleźć 'dziury' w danych - rekordy które NIE mają dopasowania.

[Wskaż na drugi przykład]

```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;
```

Co tu robimy?
- Bierzemy wszystkie kategorie (LEFT)
- Łączymy z produktami
- Liczymy ile produktów w każdej kategorii

Gdybym użył INNER JOIN, nie zobaczyłbym kategorii bez produktów. LEFT JOIN pokazuje wszystkie kategorie, nawet puste.

[Uruchom]

Widzicie? Każda kategoria ma jakieś produkty. Ale gdybyśmy dodali nową kategorię:

```sql
INSERT INTO Categories VALUES (9, 'Napoje alkoholowe', 'Alkohole mocne');
```

I powtórzyli zapytanie LEFT JOIN, zobaczylibyśmy tę nową kategorię z 0 produktów.

**Praktyczny use case:**
Chcesz raport 'Którzy klienci NIE złożyli zamówień w ostatnim miesiącu?'
```sql
SELECT c.CompanyName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
  AND o.OrderDate >= '1998-04-01'
WHERE o.OrderID IS NULL  -- klienci BEZ zamówień
GROUP BY c.CompanyName;
```

LEFT JOIN + WHERE ... IS NULL = potężna kombinacja do znajdowania braków.

Pytania do JOIN-ów?"

**Wskazówki:**
- Podkreśl różnicę INNER vs LEFT - to częsty source błędów
- Przykład z znajdowaniem "dziur" jest bardzo praktyczny
- Nie wchodź w RIGHT i FULL OUTER jeśli nie musisz - rzadko używane

---

# FUNKCJE AGREGUJĄCE

## Podstawowe funkcje:
- `COUNT(*)` - liczba rekordów
- `COUNT(kolumna)` - liczba wartości not-NULL
- `SUM(kolumna)` - suma
- `AVG(kolumna)` - średnia
- `MIN(kolumna)` - minimum
- `MAX(kolumna)` - maksimum

## Przykład:
```sql
SELECT
    COUNT(*) AS TotalProducts,
    COUNT(DISTINCT CategoryID) AS CategoryCount,
    AVG(UnitPrice) AS AvgPrice,
    MIN(UnitPrice) AS MinPrice,
    MAX(UnitPrice) AS MaxPrice,
    SUM(UnitsInStock * UnitPrice) AS TotalStockValue
FROM Products;
```

---

# NOTATKI DLA PROWADZĄCEGO - FUNKCJE AGREGUJĄCE

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Funkcje agregujące - czyli funkcje które biorą wiele wierszy i zwracają jeden wynik. To fundament analityki SQL.

Podstawowa szóstka:

**COUNT** - liczenie:
- `COUNT(*)` - liczy WSZYSTKIE rekordy, włącznie z NULL
- `COUNT(kolumna)` - liczy tylko wartości NOT NULL
- `COUNT(DISTINCT kolumna)` - liczy unikalne wartości

**SUM** - sumuje wartości numeryczne

**AVG** - średnia arytmetyczna

**MIN** i **MAX** - minimum i maksimum

[Uruchom przykład]

```sql
SELECT
    COUNT(*) AS TotalProducts,          -- 77 produktów
    COUNT(DISTINCT CategoryID) AS CategoryCount,  -- 8 kategorii
    AVG(UnitPrice) AS AvgPrice,         -- średnia cena
    MIN(UnitPrice) AS MinPrice,         -- najtańszy
    MAX(UnitPrice) AS MaxPrice,         -- najdroższy
    SUM(UnitsInStock * UnitPrice) AS TotalStockValue  -- wartość magazynu
FROM Products;
```

Widzicie wynik? Jedno podsumowanie całej tabeli.

**Ważne - NULL-e:**
NULL-e są ignorowane w funkcjach agregujących (poza COUNT(*)):

```sql
SELECT
    COUNT(*) AS AllOrders,        -- wszystkie zamówienia
    COUNT(ShipRegion) AS WithRegion  -- tylko te z regionem (nie-NULL)
FROM Orders;
```

**DISTINCT w agregacjach:**
```sql
SELECT
    COUNT(CustomerID) AS OrderCount,          -- ile zamówień
    COUNT(DISTINCT CustomerID) AS CustomerCount  -- ilu unikalnych klientów
FROM Orders;
```

To pokaże że mamy więcej zamówień niż klientów - bo jeden klient robi wiele zamówień.

Szybkie ćwiczenie: Policzcie średnią, minimum i maksimum dla kolumny Freight (koszt transportu) w tabeli Orders."

**Wskazówki:**
- Podkreśl różnicę COUNT(*) vs COUNT(kolumna)
- Wyjaśnij jak NULL-e są traktowane
- Proste ćwiczenie na utrwalenie

---

# GROUP BY - GRUPOWANIE

## Składnia:
```sql
SELECT
    kolumna_grupująca,
    funkcja_agregująca(kolumna)
FROM tabela
GROUP BY kolumna_grupująca;
```

## Przykład:
```sql
-- Liczba produktów i średnia cena w każdej kategorii
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    MIN(p.UnitPrice) AS MinPrice,
    MAX(p.UnitPrice) AS MaxPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY AvgPrice DESC;
```

**Zasada:** Każda kolumna w SELECT która nie jest funkcją agregującą musi być w GROUP BY!

---

# NOTATKI DLA PROWADZĄCEGO - GROUP BY

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"GROUP BY to miejsce gdzie dzieje się magia analityczna. Dzielimy dane na grupy i liczymy statystyki dla każdej grupy.

**Koncepcja:**
Wyobraźcie sobie że bierzecie wszystkie produkty i sortujecie je na kupki według kategorii. Potem dla każdej kupki liczycie statystyki - średnią cenę, liczność, itd.

[Uruchom przykład]

```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice,
    MIN(p.UnitPrice) AS MinPrice,
    MAX(p.UnitPrice) AS MaxPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY AvgPrice DESC;
```

Widzicie? Dostaliśmy 8 wierszy - po jednym dla każdej kategorii. Dla każdej mamy statystyki.

**ZŁOTA ZASADA GROUP BY:**

Jeśli kolumna jest w SELECT i NIE jest funkcją agregującą, MUSI być w GROUP BY.

To zadziała:
```sql
SELECT CategoryID, COUNT(*)
FROM Products
GROUP BY CategoryID;
```

To NIE zadziała:
```sql
SELECT CategoryID, ProductName, COUNT(*)  -- błąd!
FROM Products
GROUP BY CategoryID;
```

Dlaczego? Dla jednej kategorii mamy wiele ProductName. SQL nie wie którą wybrać.

**Grupowanie po wielu kolumnach:**

```sql
SELECT
    CategoryID,
    SupplierID,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID, SupplierID;
```

Teraz grupujemy po kombinacji kategorii i dostawcy.

**ROUND - bonus:**
`ROUND(AVG(p.UnitPrice), 2)` - zaokrągla do 2 miejsc po przecinku. Ładniej wygląda.

**Częsty błąd początkujących:**
```sql
-- ŹLE:
SELECT CategoryName, AVG(UnitPrice)
FROM Products
GROUP BY CategoryID;  -- grupuję po ID ale pokazuję Name!
```

To może dać nieoczekiwane wyniki. Grupuj po TYM co pokazujesz, albo dołącz tabelę z JOIN.

Pytania do GROUP BY? To jest kluczowe dla dalszej części szkolenia."

**Wskazówki:**
- Wyjaśnij wyraźnie zasadę "co w SELECT to w GROUP BY"
- Pokaż częsty błąd - pomoże uniknąć go w przyszłości
- Upewnij się że wszyscy rozumieją koncepcję grupowania

---

# HAVING - FILTROWANIE GRUP

## WHERE vs HAVING:
- **WHERE** - filtruje REKORDY przed grupowaniem
- **HAVING** - filtruje GRUPY po agregacji

## Przykład:
```sql
-- Kategorie z więcej niż 10 produktami
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.UnitPrice) AS AvgPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING COUNT(p.ProductID) > 10
ORDER BY ProductCount DESC;
```

**Różnica:**
```sql
WHERE UnitPrice > 20    -- filtruj produkty przed grupowaniem
HAVING AVG(UnitPrice) > 20  -- filtruj kategorie po obliczeniu średniej
```

---

# NOTATKI DLA PROWADZĄCEGO - HAVING

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"HAVING to często mylony koncept z WHERE. Obydwa filtrują, ale w różnych momentach.

**Kolejność wykonywania zapytania:**
1. FROM + JOIN - pobierz i połącz tabele
2. WHERE - przefiltruj rekordy
3. GROUP BY - zgrupuj
4. Funkcje agregujące (COUNT, AVG, etc.)
5. HAVING - przefiltruj grupy
6. SELECT - wybierz kolumny
7. ORDER BY - posortuj
8. LIMIT - ogranicz wynik

**WHERE działa PRZED grupowaniem:**
```sql
WHERE UnitPrice > 20  -- bierzemy tylko produkty droższe niż 20
```

**HAVING działa PO agregacji:**
```sql
HAVING AVG(UnitPrice) > 20  -- bierzemy tylko kategorie gdzie średnia > 20
```

[Uruchom przykład]

```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.UnitPrice) AS AvgPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING COUNT(p.ProductID) > 10  -- tylko kategorie z >10 produktami
ORDER BY ProductCount DESC;
```

Widzicie? Pokazujemy tylko kategorie które mają więcej niż 10 produktów. To nie jest filtr na produktach - to filtr na GRUPACH.

**Można łączyć WHERE i HAVING:**

```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    AVG(p.UnitPrice) AS AvgPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice > 10           -- filtr: tylko produkty droższe niż 10
GROUP BY c.CategoryName
HAVING COUNT(p.ProductID) > 5    -- filtr: tylko kategorie z >5 produktami
ORDER BY AvgPrice DESC;
```

Najpierw WHERE wybiera produkty >10, potem grupujemy, potem HAVING wybiera grupy >5 produktów.

**Reguła praktyczna:**
- Filtrujesz kolumnę zwykłą? WHERE
- Filtrujesz wynik funkcji agregującej? HAVING

Pytania?"

**Wskazówki:**
- Narysuj diagram kolejności wykonywania - to bardzo pomaga
- Podkreśl różnicę WHERE vs HAVING - to częsty błąd
- Przykład łączący obydwa klauzule pokazuje pełną moc

---

# ORDER BY i LIMIT

## Sortowanie:
```sql
ORDER BY kolumna [ASC|DESC]
```
- ASC - rosnąco (domyślne)
- DESC - malejąco

## Ograniczanie wyników:
```sql
LIMIT liczba
```

## Przykład:
```sql
-- Top 5 najdroższych produktów
SELECT ProductName, UnitPrice, CategoryID
FROM Products
ORDER BY UnitPrice DESC, ProductName ASC
LIMIT 5;
```

**Sortowanie po wielu kolumnach:** Najpierw po cenie malejąco, przy tej samej cenie po nazwie rosnąco.

---

# NOTATKI DLA PROWADZĄCEGO - ORDER BY i LIMIT

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Ostatnie dwa podstawowe elementy: sortowanie i limitowanie.

**ORDER BY** - bardzo proste:
```sql
ORDER BY UnitPrice DESC  -- malejąco (najdroższe pierwsze)
ORDER BY ProductName ASC  -- rosnąco (alfabetycznie)
ORDER BY ProductName      -- ASC jest domyślne
```

**Sortowanie wielokolumnowe:**
```sql
ORDER BY CategoryID ASC, UnitPrice DESC
```
Najpierw sortuj po kategorii rosnąco, w ramach każdej kategorii po cenie malejąco.

**LIMIT** - ile wyników maksymalnie:
```sql
LIMIT 10  -- pokaż maksymalnie 10 rekordów
```

W SQL Server zamiast LIMIT używa się TOP:
```sql
SELECT TOP 10 ...  -- SQL Server
```
Ale w Databricks/Spark SQL mamy LIMIT.

**Offset (pomijanie pierwszych N):**
```sql
LIMIT 10 OFFSET 20  -- pomiń pierwsze 20, pokaż następne 10
```
Przydatne do stronicowania.

[Uruchom przykład - top 5 produktów]

Pytania do podstaw? Wszystko jasne? To fantastycznie, bo właśnie skończyliśmy przypomnienie!"

**Wskazówki:**
- To prosty temat, nie rozwijaj zbytnio
- Wspomnij o różnicy LIMIT vs TOP (Databricks vs SQL Server)

---

# PRZYPOMNIENIE - PODSUMOWANIE

## ✅ Co przypomnieliśmy:
- SELECT, WHERE, FROM
- JOIN-y (INNER, LEFT)
- Funkcje agregujące (COUNT, SUM, AVG, MIN, MAX)
- GROUP BY i HAVING
- ORDER BY i LIMIT

## Przykład kompleksowy:
```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = FALSE
GROUP BY c.CategoryName
HAVING AVG(p.UnitPrice) > 20
ORDER BY AvgPrice DESC;
```

Kategorie z aktywnymi produktami, średnia cena >20, sortowane po cenie.

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE PODSTAW

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Świetnie! Mamy za sobą przypomnienie podstaw SQL. Szybko przeszliśmy przez SELECT, JOIN-y, agregacje, grupowanie i filtrowanie.

Zobaczmy kompleksowy przykład który łączy wszystko:

[Uruchom zapytanie]

```sql
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS ProductCount,
    ROUND(AVG(p.UnitPrice), 2) AS AvgPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Discontinued = FALSE
GROUP BY c.CategoryName
HAVING AVG(p.UnitPrice) > 20
ORDER BY AvgPrice DESC;
```

Przeanalizujmy co się dzieje krok po kroku:

1. **FROM + JOIN** - biorę Products i łączę z Categories
2. **WHERE** - filtruję tylko aktywne produkty (nie wycofane)
3. **GROUP BY** - grupuję po nazwie kategorii
4. **Agregacja** - liczę produkty i średnią cenę w każdej grupie
5. **HAVING** - zostawiam tylko kategorie gdzie średnia > 20
6. **SELECT** - wybieram kolumny do pokazania
7. **ORDER BY** - sortuję po średniej cenie malejąco

To jest fundament. Wszystkie zaawansowane techniki które zaraz zobaczycie bazują na tych podstawach.

**Szybki sprawdzian - pytanie do Was:**
Dlaczego nie mogę napisać:
```sql
WHERE AVG(UnitPrice) > 20
```
Zamiast HAVING?

[Czekaj na odpowiedź]

Dokładnie! WHERE działa PRZED grupowaniem, więc AVG jeszcze nie jest obliczony. Musimy użyć HAVING który działa PO agregacji.

Pytania do podstaw przed przejściem do zaawansowanych tematów?

[Pauza na pytania]

Okej, to teraz zapiijmy pasy - zaczynamy prawdziwe zaawansowane SQL-owe szaleństwo! Pierwsza przystań: funkcje grupowania i agregacji - ROLLUP, CUBE, GROUPING SETS. Kto z Was kiedykolwiek używał ROLLUP?

[Prawdopodobnie niewiele rąk]

No właśnie! To potężne narzędzia które wielu developerów nie zna. Czas to zmienić!"

**Wskazówki:**
- Podsumuj co było omówione
- Upewnij się że wszyscy nadążają
- To dobry moment na krótką przerwę (5 min) jeśli ludzie wyglądają na zmęczonych
- Jeśli nie, od razu przechodź do następnej sekcji z energią
- Zapytaj bezpośrednio kilka osób czy wszystko jasne - niektórzy nie odważą się sami zapytać

---

**KONIEC ROZDZIAŁU 2: PODSTAWY SQL**

Szacowany czas realizacji: 25-30 minut

Następny rozdział: **Funkcje grupowania i agregacji (ROLLUP, CUBE, GROUPING SETS, PIVOT)**
