# FUNKCJE UŻYTKOWNIKA (UDF)
## User-Defined Functions w Databricks

---

# CO TO SĄ FUNKCJE UŻYTKOWNIKA?

## Definicja:
Funkcje stworzone przez użytkownika, które enkapsulują logikę biznesową i mogą być wielokrotnie używane.

## Rodzaje w SQL:
- **Funkcje skalarne** - zwracają pojedynczą wartość
- **Funkcje tabelaryczne** - zwracają tabelę

## W Databricks:
- **SQL UDF** - funkcje napisane w SQL
- **Python UDF** - funkcje napisane w Pythonie (bardziej potężne)
- **Scala UDF** - funkcje w Scali

**Dzisiaj:** Skupimy się na SQL UDF (najprostsze i najbardziej zbliżone do wzorcowej prezentacji)

---

# NOTATKI DLA PROWADZĄCEGO - WPROWADZENIE UDF

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Witamy po przerwie! Mam nadzieję że naładowaliście baterie, bo mamy jeszcze kilka ciekawych tematów. Teraz funkcje użytkownika - UDF (User-Defined Functions).

**Co to jest UDF?**

To funkcje które **Wy tworzycie** i możecie używać w zapytaniach jak wbudowane funkcje SQL. Enkapsulujecie logikę biznesową w funkcję i używacie jej wielokrotnie.

**Po co?**

Wyobraźcie sobie że często obliczacie VAT:
```sql
-- Bez UDF - piszecie to za każdym razem
SELECT ProductName, UnitPrice * 1.23 AS PriceWithVAT FROM Products;

-- Z UDF - piszecie raz, używacie wszędzie
SELECT ProductName, calculate_vat(UnitPrice) AS PriceWithVAT FROM Products;
```

**Zalety:**
1. **Reużywalność** - piszecie raz, używacie wielokrotnie
2. **Czytelność** - `calculate_discount(price, 0.15)` jest czytelniejsze niż `price * (1 - 0.15)`
3. **Spójność** - wszyscy używają tej samej logiki (nie ma 10 różnych implementacji VAT)
4. **Łatwiejszy maintenance** - zmiana w jednym miejscu, działa wszędzie

**Rodzaje funkcji:**

W klasycznym SQL (SQL Server, PostgreSQL):
- Funkcje skalarne - zwracają jedną wartość (liczba, tekst)
- Funkcje tabelaryczne - zwracają tabelę

W Databricks jest trochę inaczej:
- **SQL UDF** - funkcje w czystym SQL
- **Python UDF** - funkcje w Pythonie (potężniejsze, ale wolniejsze)
- **Scala UDF** - funkcje w Scali (najszybsze, ale trzeba znać Scalę)

**Dzisiaj skupimy się na SQL UDF** - są najprostsze i wystarczają w 90% przypadków. Nie będziemy wchodzić głęboko w Python/Scala - to bardziej zaawansowane tematy na osobne szkolenie.

Zaczynamy!"

**Wskazówki:**
- Wyjaśnij różnicę Databricks vs klasyczny SQL
- Podkreśl że będzie krótka sekcja - zgodnie z wymaganiami
- Przykład VAT jest prosty i zrozumiały
- Nie strasz Pythonem/Scalą - dzisiaj SQL

---

# SQL UDF - PODSTAWOWA SKŁADNIA

## Tworzenie funkcji skalarnej:
```sql
CREATE FUNCTION nazwa_funkcji(parametr1 typ, parametr2 typ, ...)
RETURNS typ_zwracany
RETURN wyrażenie;
```

## Przykład:
```sql
-- Funkcja obliczająca VAT (23%)
CREATE OR REPLACE FUNCTION calculate_vat(price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
RETURN price * 1.23;

-- Użycie:
SELECT
    ProductName,
    UnitPrice,
    calculate_vat(UnitPrice) AS PriceWithVAT
FROM Products;
```

**CREATE OR REPLACE** - tworzy nową lub nadpisuje istniejącą.

---

# NOTATKI DLA PROWADZĄCEGO - PODSTAWOWA SKŁADNIA

**Czas trwania:** 4-5 minut

**Co powiedzieć:**
"Zobaczmy jak stworzyć prostą funkcję SQL UDF w Databricks.

**Składnia:**

```sql
CREATE FUNCTION nazwa(parametr typ, ...)
RETURNS typ_zwracany
RETURN wyrażenie;
```

Bardzo prosta! Definiujecie parametry, typ zwracany, i wyrażenie które oblicza wynik.

**Przykład - funkcja VAT:**

[Uruchom w notebooku]

```sql
-- Tworzenie funkcji
CREATE OR REPLACE FUNCTION calculate_vat(price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
RETURN price * 1.23;
```

**Rozbiór:**
- `CREATE OR REPLACE` - jeśli funkcja istnieje, nadpisz ją
- `calculate_vat` - nazwa funkcji
- `(price DECIMAL(10,2))` - jeden parametr typu DECIMAL
- `RETURNS DECIMAL(10,2)` - zwraca DECIMAL
- `RETURN price * 1.23` - obliczenie (cena * 1.23 = cena z VAT 23%)

**Użycie:**

```sql
SELECT
    ProductName,
    UnitPrice,
    calculate_vat(UnitPrice) AS PriceWithVAT
FROM Products
LIMIT 10;
```

[Uruchom]

Widzicie? Używamy `calculate_vat()` jak zwykłej funkcji SQL - SUM, AVG, itd.

**Parametry mogą być używane w wyrażeniu:**

```sql
-- Funkcja z dwoma parametrami
CREATE OR REPLACE FUNCTION calculate_discount(price DECIMAL(10,2), discount_pct DECIMAL(5,2))
RETURNS DECIMAL(10,2)
RETURN price * (1 - discount_pct / 100);

-- Użycie:
SELECT
    ProductName,
    UnitPrice,
    calculate_discount(UnitPrice, 15) AS DiscountedPrice  -- 15% rabat
FROM Products
LIMIT 10;
```

[Uruchom]

Funkcja bierze cenę i procent rabatu, zwraca cenę po rabacie.

**Gdzie są przechowywane funkcje?**

W Databricks funkcje są przechowywane w **katalogu/schemacie**:

```sql
-- Pokazanie funkcji w schemacie
SHOW FUNCTIONS IN northwind;

-- Lub wszystkich użytkownika
SHOW USER FUNCTIONS;
```

[Uruchom]

Widzicie `calculate_vat` i `calculate_discount` na liście.

**Usuwanie funkcji:**

```sql
DROP FUNCTION IF EXISTS calculate_vat;
```

**Ważne ograniczenia SQL UDF:**

1. Tylko wyrażenia SQL - nie możecie robić pętli, IF/ELSE (użyjcie CASE)
2. Nie możecie modyfikować danych (INSERT, UPDATE, DELETE)
3. Musi być deterministyczna - te same inputy zawsze dają ten sam output

Dla bardziej złożonej logiki - Python UDF. Ale 90% potrzeb pokrywa SQL.

Pytania do podstaw UDF?"

**Wskazówki:**
- Pokażna żywo - tworzenie i użycie funkcji
- Przykład z dwoma parametrami rozszerza zrozumienie
- SHOW FUNCTIONS pokazuje że funkcje są persisted
- Wyjaśnij ograniczenia - ludzie będą pytać "czy mogę..."

---

# SQL UDF - PRZYKŁADY PRAKTYCZNE

## 1. Formatowanie tekstu:
```sql
CREATE OR REPLACE FUNCTION format_product_code(category_id INT, product_id INT)
RETURNS STRING
RETURN CONCAT('CAT', LPAD(CAST(category_id AS STRING), 2, '0'),
              '-PROD', LPAD(CAST(product_id AS STRING), 4, '0'));

-- Użycie:
SELECT ProductName, format_product_code(CategoryID, ProductID) AS ProductCode
FROM Products;
```

Wynik: `CAT01-PROD0001`, `CAT02-PROD0015`, itd.

## 2. Kategoryzacja wartości:
```sql
CREATE OR REPLACE FUNCTION price_category(price DECIMAL(10,2))
RETURNS STRING
RETURN CASE
    WHEN price < 10 THEN 'Budget'
    WHEN price < 50 THEN 'Standard'
    WHEN price < 100 THEN 'Premium'
    ELSE 'Luxury'
END;
```

---

# NOTATKI DLA PROWADZĄCEGO - PRZYKŁADY PRAKTYCZNE

**Czas trwania:** 5-6 minut

**Co powiedzieć:**
"Zobaczmy kilka praktycznych przykładów UDF które moglibyście używać w projektach.

**Przykład 1: Formatowanie kodów produktów**

Często potrzebujecie standardowego formatu kodów. Zamiast pisać złożone CONCAT za każdym razem:

[Uruchom]

```sql
CREATE OR REPLACE FUNCTION format_product_code(category_id INT, product_id INT)
RETURNS STRING
RETURN CONCAT('CAT', LPAD(CAST(category_id AS STRING), 2, '0'),
              '-PROD', LPAD(CAST(product_id AS STRING), 4, '0'));

-- Użycie:
SELECT
    ProductName,
    CategoryID,
    ProductID,
    format_product_code(CategoryID, ProductID) AS ProductCode
FROM Products
LIMIT 10;
```

Wynik: `CAT01-PROD0001`, `CAT03-PROD0042` - ładnie sformatowane kody.

LPAD dodaje zera z lewej, CONCAT skleja. Złożona logika, ale schowana w funkcji - czytelnie!

**Przykład 2: Kategoryzacja wartości**

Klasyczny use case - przypisywanie kategorii na podstawie wartości:

[Uruchom]

```sql
CREATE OR REPLACE FUNCTION price_category(price DECIMAL(10,2))
RETURNS STRING
RETURN CASE
    WHEN price IS NULL THEN 'Unknown'
    WHEN price < 10 THEN 'Budget'
    WHEN price < 50 THEN 'Standard'
    WHEN price < 100 THEN 'Premium'
    ELSE 'Luxury'
END;

-- Użycie:
SELECT
    ProductName,
    UnitPrice,
    price_category(UnitPrice) AS Category,
    COUNT(*) OVER (PARTITION BY price_category(UnitPrice)) AS ProductsInCategory
FROM Products
ORDER BY UnitPrice;
```

Teraz możecie używać `price_category()` wszędzie - w SELECT, WHERE, GROUP BY:

```sql
-- Ile produktów w każdej kategorii cenowej?
SELECT
    price_category(UnitPrice) AS Category,
    COUNT(*) AS Count,
    AVG(UnitPrice) AS AvgPrice
FROM Products
GROUP BY price_category(UnitPrice)
ORDER BY AvgPrice;
```

**Przykład 3: Obliczenia biznesowe**

```sql
-- Marża handlowa (profit margin)
CREATE OR REPLACE FUNCTION profit_margin(sell_price DECIMAL(10,2), cost_price DECIMAL(10,2))
RETURNS DECIMAL(5,2)
RETURN CASE
    WHEN cost_price = 0 OR cost_price IS NULL THEN NULL
    ELSE ROUND(((sell_price - cost_price) / sell_price) * 100, 2)
END;

-- Użycie (symulowane - Northwind nie ma cost price):
SELECT
    ProductName,
    UnitPrice AS SellPrice,
    UnitPrice * 0.6 AS CostPrice,  -- symulowany koszt (60% ceny)
    profit_margin(UnitPrice, UnitPrice * 0.6) AS MarginPct
FROM Products
LIMIT 10;
```

Logika marży jest złożona (trzeba obsłużyć dzielenie przez zero). W funkcji - schowane, reużywalne.

**Przykład 4: Walidacja**

```sql
-- Sprawdzanie poprawności email (uproszczone)
CREATE OR REPLACE FUNCTION is_valid_email(email STRING)
RETURNS BOOLEAN
RETURN email IS NOT NULL
       AND email LIKE '%@%.%'
       AND LENGTH(email) >= 5;

-- Gdybyśmy mieli emaile w Customers:
-- SELECT CompanyName, Email, is_valid_email(Email) AS ValidEmail
-- FROM Customers;
```

Funkcje mogą zwracać BOOLEAN - przydatne do walidacji!

**Dobre praktyki:**

1. **Nazwy funkcji:** Opisowe, używajcie konwencji (np. `calculate_`, `format_`, `is_`)
2. **Obsługa NULL:** Zawsze obsługujcie NULL-e (CASE WHEN kolumna IS NULL)
3. **Dokumentacja:** W Databricks możecie dodać komentarz:
```sql
COMMENT ON FUNCTION calculate_vat IS 'Calculates price with 23% VAT';
```

4. **Testowanie:** Przetestujcie edge cases (NULL, zero, ujemne wartości)

Spróbujcie sami (3 minuty):
Stwórzcie funkcję `days_since(order_date DATE)` która zwraca ile dni minęło od zamówienia do dziś. Użyjcie DATEDIFF."

**Wskazówki:**
- Przykłady są praktyczne - ludzie widzą wartość
- Pokaż różne typy zwracane (STRING, DECIMAL, BOOLEAN)
- Podkreśl dobre praktyki
- Ćwiczenie pozwala sprawdzić zrozumienie

---

# FUNKCJE vs PROCEDURY SKŁADOWANE

## Różnice:

| Funkcje (UDF) | Procedury Składowane (SP) |
|---------------|---------------------------|
| Zwracają wartość (obowiązkowo) | Mogą zwracać 0, 1 lub wiele wartości |
| Tylko SELECT | Mogą modyfikować dane (INSERT, UPDATE, DELETE) |
| Używane w zapytaniach | Wywoływane osobno (CALL) |
| Parametry tylko wejściowe | Parametry wejściowe i wyjściowe |
| Nie mogą wywoływać SP | Mogą wywoływać funkcje |

**W Databricks:**
Procedury składowane są mniej popularne niż w SQL Server. Databricks preferuje:
- UDF dla transformacji
- Notebooki dla złożonych workflow

---

# NOTATKI DLA PROWADZĄCEGO - FUNKCJE vs PROCEDURY

**Czas trwania:** 3 minuty

**Co powiedzieć:**
"Szybko wyjaśnię różnicę między funkcjami a procedurami składowanymi, bo często to jest mylone.

**Funkcje (UDF):**
- MUSZĄ zwracać wartość
- Są 'read-only' - nie mogą modyfikować danych
- Używacie ich W zapytaniach: `SELECT funkcja(kolumna) FROM ...`
- Jak funkcje matematyczne - input -> output, bez side effects

**Procedury składowane (Stored Procedures):**
- Mogą zwracać wartości albo nie
- Mogą modyfikować dane (INSERT, UPDATE, DELETE)
- Wywołujecie je osobno: `CALL procedura(parametry)`
- Mogą mieć złożoną logikę: pętle, IF/ELSE, transakcje

**Przykład różnicy:**

Funkcja:
```sql
CREATE FUNCTION get_vat(price DECIMAL) RETURNS DECIMAL
RETURN price * 0.23;

-- Użycie W zapytaniu:
SELECT ProductName, get_vat(UnitPrice) FROM Products;
```

Procedura (pseudo-kod, Databricks ma ograniczone wsparcie):
```sql
CREATE PROCEDURE update_prices(category_id INT, increase_pct DECIMAL)
BEGIN
    UPDATE Products
    SET UnitPrice = UnitPrice * (1 + increase_pct/100)
    WHERE CategoryID = category_id;
END;

-- Wywołanie:
CALL update_prices(1, 10);  -- zwiększ ceny w kategorii 1 o 10%
```

**W Databricks:**

Databricks ma ograniczone wsparcie dla procedur składowanych w SQL. Filozofia jest inna:
- **Dla transformacji danych:** Użyj UDF lub Python w notebooku
- **Dla workflow:** Użyj Databricks Workflows / Jobs
- **Dla ETL:** Użyj notebooków Delta Live Tables

SQL Server czy PostgreSQL mają bogate wsparcie dla procedur. Databricks - mniej, bo jest zorientowany na big data processing w notebookach.

**Kiedy co używać:**

**UDF:** Obliczenia, transformacje, formatowanie - rzeczy które mogą być częścią SELECT
**Notebooki Python:** Złożona logika, modyfikacja danych, orchestration
**Databricks Jobs:** Zaplanowane zadania, pipeline'y ETL

Dla dzisiejszego szkolenia: **skupiamy się na SQL UDF** - są proste, użyteczne i wystarczające w większości przypadków."

**Wskazówki:**
- Wyjaśnij różnicę funkcje vs procedury
- Podkreśl że Databricks preferuje inny model (notebooki)
- Nie wchodź głęboko w procedury - to nie jest temat dzisiejszego szkolenia
- Daj jasne wytyczne kiedy co używać

---

# PYTHON UDF - KRÓTKIE WPROWADZENIE

## Dla bardziej złożonej logiki:

```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

# Definicja funkcji Python
def categorize_price(price):
    if price is None:
        return "Unknown"
    elif price < 10:
        return "Budget"
    elif price < 50:
        return "Standard"
    elif price < 100:
        return "Premium"
    else:
        return "Luxury"

# Rejestracja jako UDF
categorize_price_udf = udf(categorize_price, StringType())

# Użycie
df = spark.table("Products")
df.withColumn("PriceCategory", categorize_price_udf("UnitPrice")).show()
```

**Kiedy Python UDF:** Złożona logika, machine learning, zewnętrzne biblioteki.

**UWAGA:** Python UDF są **wolniejsze** niż SQL UDF (serializacja Python <-> JVM).

---

# NOTATKI DLA PROWADZĄCEGO - PYTHON UDF KRÓTKO

**Czas trwania:** 3-4 minuty

**Co powiedzieć:**
"Na szybko pokażę Python UDF - żebyście wiedzieli że istnieje, ale nie będziemy wchodzić głęboko. To materiał na osobne szkolenie.

**Python UDF:**

Kiedy SQL UDF nie wystarcza (np. potrzebujecie pętli, złożonych warunków, bibliotek zewnętrznych), możecie użyć Pythona:

[Pokaż kod, niekoniecznie uruchamiaj jeśli nie ma czasu]

```python
# Komórka Python w notebooku Databricks
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

def categorize_price(price):
    if price is None:
        return "Unknown"
    elif price < 10:
        return "Budget"
    elif price < 50:
        return "Standard"
    elif price < 100:
        return "Premium"
    else:
        return "Luxury"

# Rejestracja UDF
categorize_price_udf = udf(categorize_price, StringType())

# Użycie w DataFrame
df = spark.table("northwind.Products")
df.withColumn("PriceCategory", categorize_price_udf("UnitPrice")).show(10)
```

**Zalety Python UDF:**
- Pełna moc Pythona - pętle, biblioteki (numpy, pandas, sklearn)
- Złożona logika - regex, machine learning, custom algorithms
- Integracja z ML models

**Wady:**
- **Wolniejsze** niż SQL UDF (dane muszą być serializowane Python <-> Spark JVM)
- Trudniejsze do optymalizacji
- Wymaga znajomości PySpark

**Kiedy używać:**

✅ Python UDF:
- Machine learning predictions
- Złożone string manipulations (regex)
- Użycie zewnętrznych bibliotek
- Custom biznesowa logika nie do wyrażenia w SQL

❌ Nie Python UDF (użyj SQL):
- Proste obliczenia matematyczne
- Formatowanie, konkatenacja
- CASE statements
- Wszystko co można zrobić w SQL

**Ogólna zasada:** Zostań przy SQL UDF dopóki możesz. Python tylko gdy musisz.

**Rejestracja dla SQL:**

Możecie zarejestrować Python UDF żeby używać go w SQL:

```python
spark.udf.register("categorize_price_py", categorize_price, StringType())
```

Potem w SQL:
```sql
SELECT ProductName, UnitPrice, categorize_price_py(UnitPrice) AS Category
FROM Products;
```

Ale to zaawansowana technika - na dzisiaj wystarczy że wiecie że istnieje.

Pytania do UDF ogólnie?"

**Wskazówki:**
- To krótkie wprowadzenie - nie wchodź głęboko
- Podkreśl że Python UDF są wolniejsze - ważne!
- Daj jasne wytyczne kiedy SQL a kiedy Python
- Zgodnie z wymaganiami - nie wybiegamy mocno w temat

---

# FUNKCJE UŻYTKOWNIKA - PODSUMOWANIE

## ✅ Co omówiliśmy:
- **SQL UDF** - funkcje w czystym SQL (proste, szybkie)
- **Tworzenie funkcji** - CREATE FUNCTION, parametry, RETURN
- **Praktyczne przykłady** - VAT, formatowanie, kategoryzacja
- **Funkcje vs Procedury** - różnice i kiedy co używać
- **Python UDF** - krótkie wprowadzenie (zaawansowane)

## Kluczowe wnioski:
- UDF = reużywalność + czytelność + spójność
- SQL UDF wystarczają w 90% przypadków
- Python UDF dla złożonej logiki (ale wolniejsze!)
- Databricks preferuje UDF + notebooki zamiast procedur składowanych

## Dobre praktyki:
1. Opisowe nazwy funkcji
2. Obsługa NULL-i
3. Testowanie edge cases
4. Dokumentacja (COMMENT)

---

# NOTATKI DLA PROWADZĄCEGO - PODSUMOWANIE UDF

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Świetnie! Mamy za sobą funkcje użytkownika. To była krótka sekcja - 30 minut - ale pokryliśmy podstawy.

**Podsumowanie:**

**SQL UDF:**
Proste funkcje w SQL. Enkapsulują logikę, są reużywalne, czytelne. `CREATE FUNCTION` + `RETURN`. Szybkie i wystarczające w większości przypadków.

**Praktyczne zastosowania:**
- Obliczenia biznesowe (VAT, marża, rabaty)
- Formatowanie (kody, daty, teksty)
- Kategoryzacja (price tiers, customer segments)
- Walidacja (email, phone, formats)

**Python UDF:**
Dla złożonej logiki, ML, zewnętrznych bibliotek. Wolniejsze ale potężniejsze.

**Databricks approach:**
UDF dla transformacji, notebooki dla workflow, jobs dla orchestration. Inne niż SQL Server/Oracle (gdzie procedury składowane są kingiem).

**Kluczowy wniosek:**

UDF to nie rocket science. Jeśli piszecie to samo obliczenie w 10 miejscach - zróbcie z tego funkcję. Kod będzie czystszy, łatwiej utrzymywalny.

Pytania finalne do UDF?

[Pauza]

Ok! Zostały nam 2 rzeczy:
- **Co jeszcze warto wiedzieć** (45 min) - optymalizacja, indeksy, best practices
- **Podsumowanie i zadania domowe** (15 min)

Jesteśmy na finiszu! Następna sekcja to praktyczne wskazówki które przydadzą się w codziennej pracy. Gotowi? Jedziemy!"

**Wskazówki:**
- Krótkie podsumowanie - była krótka sekcja
- Podkreśl praktyczność UDF
- Zapowiedz ostatnie 2 sekcje
- Energia - blisko końca szkolenia!

---

**KONIEC ROZDZIAŁU 6: FUNKCJE UŻYTKOWNIKA**

Szacowany czas realizacji: 30 minut

Następny rozdział: **Co jeszcze warto wiedzieć - 45 minut** (optymalizacja, indeksowanie, partycjonowanie, best practices)
