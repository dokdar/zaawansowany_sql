# ZAAWANSOWANY SQL
## Szkolenie praktyczne z Databricks

---

# AGENDA SZKOLENIA

## Program 5-godzinnego szkolenia:

1. **Sprawy organizacyjne** (15 min)
2. **Podstawy SQL - krótkie przypomnienie** (30 min)
3. **Funkcje grupowania i agregacji** (45 min)
4. **Common Table Expression (CTE)** (60 min) ⭐
5. **Funkcje analityczne** (90 min) ⭐⭐
6. **Funkcje użytkownika** (30 min)
7. **Co jeszcze warto wiedzieć...** (45 min)
8. **Podsumowanie i zadania do domu** (15 min)

**Łączny czas:** 5 godzin (300 minut)

⭐ - tematy z większym naciskiem czasowym

---

# NOTATKI DLA PROWADZĄCEGO - SLAJD TYTUŁOWY

**Czas trwania:** 2 minuty

**Co powiedzieć:**
"Dzień dobry! Witam Was na szkoleniu z zaawansowanego SQL. Nazywam się [IMIĘ] i przez najbliższe 5 godzin będziemy wspólnie zgłębiać zaawansowane techniki pracy z bazami danych.

To szkolenie ma charakter praktyczny - będziemy łączyć teorię z ćwiczeniami, które każdy z Was będzie mógł wykonać na platformie Databricks. Używamy bazy danych Northwind, która jest klasyczną bazą treningową - zawiera dane o produktach, zamówieniach, klientach i pracownikach fikcyjnej firmy handlowej.

Przed nami intensywny dzień, ale obiecuję, że będzie wartościowy i pełen praktycznej wiedzy, którą będziecie mogli wykorzystać w codziennej pracy."

**Wskazówki:**
- Mów pewnie i entuzjastycznie
- Nawiąż kontakt wzrokowy z uczestnikami
- Uśmiechnij się - to tworzy przyjazną atmosferę
- Zapytaj czy wszyscy widzą ekran dobrze

---

# SPRAWY ORGANIZACYJNE

## Plan szkolenia:
- **Format:** teoria + praktyka (50/50)
- **Platforma:** Databricks
- **Baza danych:** Northwind
- **Czas:** 5 godzin z przerwą
- **Materiały:** Prezentacja + notebooki SQL

---

# NOTATKI DLA PROWADZĄCEGO - SPRAWY ORGANIZACYJNE

**Czas trwania:** 5-7 minut

**Co powiedzieć:**
"Zanim zaczniemy merytoryczną część, kilka spraw organizacyjnych, które ułatwią nam wspólną pracę.

**Format szkolenia:**
Dzisiejsze szkolenie będzie miało hybrydowy charakter. Nie będę Was zanudzał godzinami teorii - każdy temat omówimy teoretycznie, a następnie od razu przejdziemy do praktyki. Pokazuję przykład, wy go analizujecie, a potem sami rozwiązujecie podobne zadanie. Taki model nazywam 'see-do-practice'.

**Platforma Databricks:**
Będziemy pracować na platformie Databricks - jeśli ktoś nie pracował wcześniej z Databricks, nie martwcie się. To środowisko oparte na Apache Spark, ale my będziemy używać standardowego SQL-a. Databricks ma świetny interfejs notebooków, podobny do Jupyter Notebook, co ułatwia eksperymentowanie z kodem.

**Baza Northwind:**
Nasza treningowa baza to klasyczna Northwind - zawiera dane fikcyjnej firmy zajmującej się sprzedażą żywności. Macie tam produkty, kategorie, dostawców, klientów, pracowników i zamówienia. Jest idealna do nauki, bo dane są realistyczne ale nie zawierają wrażliwych informacji.

**Harmonogram:**
Mamy przed sobą 5 godzin. Zrobimy jedną przerwę około połowy szkolenia - około 15 minut. Jeśli w międzyczasie ktoś potrzebuje krótkiej przerwy, nie ma problemu - sygnalizujcie.

**Materiały:**
Po szkoleniu otrzymacie:
- Tę prezentację z notatkami
- Notebooki z przykładami
- Notebooki z ćwiczeniami i rozwiązaniami
- Dodatkowe zadania do samodzielnej pracy

**Pytania:**
Pytania są mile widziane! Możecie pytać na bieżąco - jeśli pytanie jest szybkie, odpowiem od razu. Jeśli wymaga dłuższej dyskusji, zaproponuję omówienie w przerwie lub po konkretnej sekcji."

**Wskazówki:**
- Sprawdź czy wszyscy mają dostęp do Databricks
- Zapytaj o poziom doświadczenia z SQL (pokażcie rękę: podstawowy / średniozaawansowany / zaawansowany)
- Zapytaj czy są konkretne oczekiwania lub tematy, które szczególnie ich interesują
- Zachęć do aktywności - to nie wykład, to warsztat!

---

# ŚRODOWISKO PRACY - DATABRICKS

## Co potrzebujemy:
1. ✅ Dostęp do Databricks Workspace
2. ✅ Uruchomiony klaster
3. ✅ Zainicjalizowana baza Northwind
4. ✅ Notebooki SQL

## Weryfikacja przed startem:
```sql
USE northwind;
SHOW TABLES;
```

Powinniśmy zobaczyć: Categories, Customers, Employees, Orders, Order Details, Products, Shippers, Suppliers

---

# NOTATKI DLA PROWADZĄCEGO - ŚRODOWISKO PRACY

**Czas trwania:** 5-8 minut

**Co powiedzieć:**
"Dobrze, czas sprawdzić czy wszyscy macie działające środowisko pracy. To będzie krótki test techniczny, żeby upewnić się, że możecie śledzić ćwiczenia.

**Krok 1: Dostęp do Databricks**
Wszyscy powinniście mieć dostęp do naszego workspace'u Databricks. Jeśli widzicie interfejs Databricks ze swoją nazwą użytkownika w prawym górnym rogu - jest dobrze.

**Krok 2: Klaster**
W Databricks musimy mieć uruchomiony klaster - to nasz silnik obliczeniowy. Sprawdźcie w zakładce 'Compute' czy widzicie zielony punkt przy nazwie klastra. Jeśli jest szary lub czerwony - kliknijcie 'Start'. Uruchomienie może potrwać 2-3 minuty.

**Krok 3: Baza Northwind**
Teraz najważniejsze - musimy zainicjalizować bazę danych Northwind. Dostaliście skrypt inicjalizacyjny `northwind_databricks_init.sql`.

Stwórzmy nowy notebook:
1. Kliknijcie 'Workspace' po lewej stronie
2. 'Create' -> 'Notebook'
3. Nazwę: 'Northwind_Init'
4. Język: SQL
5. Wybierzcie nasz klaster

Teraz:
1. Skopiujcie zawartość skryptu `northwind_databricks_init.sql`
2. Wklejcie do pierwszej komórki notebooka
3. Naciśnijcie Shift+Enter lub kliknijcie 'Run Cell'

Skrypt stworzy bazę danych 'northwind' i wypełni ją danymi. To może potrwać minutę lub dwie.

**Krok 4: Weryfikacja**
Kiedy skrypt się wykona, stwórzmy nową komórkę i wpiszmy:

```sql
USE northwind;
SHOW TABLES;
```

Uruchomcie (Shift+Enter). Powinniście zobaczyć listę 8 tabel:
- Categories
- Customers
- Employees
- Order Details
- Orders
- Products
- Shippers
- Suppliers

Jeśli widzicie wszystkie tabele - jesteście gotowi do pracy!

**Sprawdzenie danych:**
Zróbmy jeszcze szybki test czy dane się załadowały:

```sql
SELECT COUNT(*) as product_count FROM Products;
```

Powinniście zobaczyć 77 produktów.

Kto ma jakiekolwiek problemy? Pomogę Wam indywidualnie."

**Wskazówki:**
- Chodź między uczestnikami i sprawdzaj czy mają działające środowisko
- Przygotuj się na typowe problemy: brak uprawnień, klaster nie startuje, błędy w skrypcie
- Jeśli ktoś ma problemy techniczne, poproś o zrzut ekranu lub podejdź osobiście
- Nie przechodź dalej dopóki wszyscy nie będą mieli działającego środowiska
- Możesz przygotować zapasowy dostęp do bazy na wypadek problemów

---

# STRUKTURA BAZY NORTHWIND

## Główne tabele:

**Dane podstawowe:**
- **Categories** - kategorie produktów (8 kategorii)
- **Suppliers** - dostawcy (20 firm)
- **Products** - produkty (77 produktów)

**Klienci i pracownicy:**
- **Customers** - klienci (91 firm)
- **Employees** - pracownicy (9 osób)

**Zamówienia:**
- **Orders** - nagłówki zamówień
- **Order Details** - szczegóły zamówień (pozycje)
- **Shippers** - firmy kurierskie (3 firmy)

---

# NOTATKI DLA PROWADZĄCEGO - STRUKTURA BAZY

**Czas trwania:** 3-5 minut

**Co powiedzieć:**
"Zanim zaczniemy pisać zaawansowane zapytania, musimy zrozumieć z czym pracujemy. Baza Northwind to klasyczna baza treningowa używana od lat w nauczaniu SQL. Przedstawia typową bazę firmy handlowej.

**Dane podstawowe - serce biznesu:**
Mamy trzy kluczowe tabele produktowe:
- **Categories** - 8 kategorii produktów: napoje, przyprawy, słodycze, nabiał, zboża, mięso, produkty roślinne i owoce morza
- **Suppliers** - 20 dostawców z całego świata - USA, Europa, Japonia, Australia
- **Products** - 77 różnych produktów z cenami, stanami magazynowymi

**Ludzie:**
- **Customers** - 91 firm będących naszymi klientami
- **Employees** - 9 pracowników, którzy obsługują zamówienia. Co ciekawe, tabela ma pole ReportsTo - czyli mamy hierarchię organizacyjną! To wykorzystamy przy omawianiu CTE.

**Sprzedaż:**
- **Orders** - nagłówek zamówienia: kto zamówił, kiedy, gdzie wysłać, jaki koszty transportu
- **Order Details** - szczegóły: jakie produkty, ile sztuk, po jakiej cenie, jaki rabat
- **Shippers** - 3 firmy kurierskie obsługujące dostawy

**Relacje:**
To jest relacyjna baza danych, więc tabele są ze sobą powiązane:
- Product łączy się z Category i Supplier
- Order łączy się z Customer, Employee i Shipper
- Order Details łączy Order z Products

Dzięki tym relacjom możemy budować złożone zapytania łączące wiele perspektyw biznesowych.

Pokażę Wam szybki przykład, żebyście zobaczyli dane:

```sql
SELECT
    p.ProductName,
    c.CategoryName,
    s.CompanyName as Supplier,
    p.UnitPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
JOIN Suppliers s ON p.SupplierID = s.SupplierID
LIMIT 5;
```

Widzicie? Połączyliśmy produkt z kategorią i dostawcą. Takie joiny będziemy używać często w dzisiejszych ćwiczeniach."

**Wskazówki:**
- Możesz narysować prosty schemat relacji na tablicy/flipcharcie
- Zachęć uczestników do eksploracji: "Wpiszcie SELECT * FROM Categories i zobaczcie co tam jest"
- Wyjaśnij że dane są z lat 90., więc daty zamówień są historyczne (1996-1998)
- Podkreśl że to bezpieczne środowisko treningowe - można eksperymentować

---

# DOBRE PRAKTYKI NA SZKOLENIU

## 👍 Zachęcam:
- Zadawać pytania
- Eksperymentować z kodem
- Dzielić się spostrzeżeniami
- Notować ważne rzeczy

## 🎯 Cele szkolenia:
- Zrozumieć zaawansowane konstrukcje SQL
- Nauczyć się pisać wydajne zapytania
- Umieć zastosować wiedzę w praktyce
- Poznać możliwości Databricks

---

# NOTATKI DLA PROWADZĄCEGO - DOBRE PRAKTYKI

**Czas trwania:** 2-3 minuty

**Co powiedzieć:**
"Ostatnia rzecz zanim zaczniemy właściwą część merytoryczną - chcę ustalić kilka zasad, które pomogą nam efektywnie wykorzystać te 5 godzin.

**Pytania są kluczowe:**
Proszę, pytajcie! Nie ma głupich pytań. Jeśli czegoś nie rozumiecie, prawdopodobnie połowa grupy ma ten sam problem, tylko się nie odzywa. Zadając pytanie, pomagacie nie tylko sobie, ale i innym. Będę starał się odpowiadać na bieżąco, a jeśli temat jest zbyt złożony, wrócę do niego w odpowiednim momencie.

**Eksperymentujcie:**
Databricks to bezpieczne środowisko. Możecie modyfikować moje przykłady, próbować różnych wariantów, testować swoje hipotezy. Najlepiej uczy się przez robienie błędów i ich naprawianie. Jeśli coś nie działa - super! To okazja do nauki.

**Dzielcie się:**
Jeśli znajdziecie ciekawe rozwiązanie, odkryjecie coś ciekawego w danych, albo macie pytanie, które może być inspirujące dla innych - podzielcie się. To wzbogaca szkolenie dla wszystkich.

**Notujcie:**
Dostaniecie wszystkie materiały, ale własne notatki są bezcenne. Zapisujcie to, co Was zaskoczyło, co było trudne, co chcecie pogłębić. Możecie robić notatki w notebookach Databricks - można dodawać komórki typu Markdown (tekst), nie tylko SQL.

**Cele:**
Naszym celem nie jest zapamiętanie składni na pamięć. Chcę, żebyście:
1. **Zrozumieli** koncepcje - po co służą CTE, funkcje analityczne, kiedy je stosować
2. **Umieli** pisać zapytania - żeby po szkoleniu potrafili samodzielnie rozwiązywać podobne problemy
3. **Wiedzieli** gdzie szukać - dokumentacja Databricks, Stack Overflow, dobre praktyki
4. **Poznali** możliwości - żeby wiedzieli co jest możliwe, nawet jeśli nie pamiętacie dokładnej składni

**Tempo:**
Mamy ambitny program. Będę starał się utrzymać tempo, ale jeśli widzę, że temat wymaga więcej czasu - zatrzymamy się. Lepiej dobrze zrozumieć mniej tematów niż przeskoczyć wszystko powierzchownie.

No dobra, koniec organizacyjnych nudności. Czas na prawdziwy SQL!"

**Wskazówki:**
- Uśmiechnij się i stwórz luz - ludzie uczą się lepiej w relaksującej atmosferze
- Zapytaj czy ktoś ma pytania organizacyjne przed startem
- Sprawdź czy wszyscy nadal mają działające środowisko
- Możesz zrobić szybką rundkę: "Kto z Was już używał CTE?" "Kto używał funkcji analitycznych?" - to da Ci rozeznanie o poziomie grupy

---

# ZASADY PRACY Z NOTEBOOKAMI

## W Databricks:
1. **Tworzenie komórek:** Kliknij (+) lub naciśnij B
2. **Uruchamianie:** Shift+Enter lub przycisk ▶
3. **Typ komórki:** %sql, %python, %md (markdown)
4. **Komentarze:** -- dla SQL, # dla Python
5. **Autouzupełnianie:** Tab

## Porady:
- Zapisuj często (Ctrl+S)
- Nazywaj notebooki opisowo
- Używaj komentarzy w kodzie
- Testuj zapytania na małych próbkach danych

---

# NOTATKI DLA PROWADZĄCEGO - ZASADY PRACY Z NOTEBOOKAMI

**Czas trwania:** 3-4 minuty (demonstracja praktyczna)

**Co powiedzieć:**
"Zanim przejdziemy do SQL-a, szybki tutorial jak efektywnie pracować w notebookach Databricks. Część z Was pewnie zna Jupyter Notebooks - Databricks działa podobnie, ale ma kilka różnic.

**Tworzenie komórek - demonstracja na żywo:**
Patrzcie na mój ekran. [Otwórz notebook]

Żeby dodać nową komórkę, mam dwie opcje:
- Kliknąć ten mały plus (+) między komórkami
- Albo nacisnąć klawisz B kiedy jestem w trybie komend (nie edycji)

**Uruchamianie kodu:**
Żeby uruchomić zapytanie:
- Shift+Enter - uruchamia i przechodzi do następnej komórki
- Ctrl+Enter - uruchamia i zostaje w tej samej komórce
- Albo klikamy strzałkę ▶ po prawej stronie komórki

[Pokaż przykład: SELECT * FROM Categories LIMIT 3;]

Widzicie? Wynik pojawia się od razu pod komórką. Możemy sortować kolumny, eksportować do CSV.

**Typy komórek:**
Databricks wspiera różne języki w jednym notebooku. Na początku komórki wpisujemy:
- `%sql` - dla zapytań SQL (to będziemy używać najczęściej)
- `%python` - dla kodu Pythona
- `%md` - dla notatek tekstowych w Markdown

[Pokaż przykład każdego]

Komórka Markdown to świetne miejsce na notatki:
```
%md
# To jest nagłówek
To jest **pogrubiony** tekst
- Lista
- Element 2
```

**Komentarze w SQL:**
W SQL komentarz to dwa myślniki:
```sql
-- To jest komentarz
SELECT * FROM Products  -- komentarz na końcu linii
```

**Autouzupełnianie - bardzo przydatne:**
Zacznijcie pisać nazwę tabeli i naciśnijcie Tab:
```sql
SELECT * FROM Pro[TAB]
```
System podpowie nazwy tabel i kolumn.

**Porady praktyczne:**

1. **Zapisuj często:**
Databricks automatycznie zapisuje, ale możecie też Ctrl+S. Lepiej dmuchać na zimne.

2. **Nazywaj sensownie:**
Zamiast 'Notebook 1', nazwij 'Cwiczenia_CTE' albo 'Moje_Funkcje_Analityczne'. Za tydzień będziesz wdzięczny.

3. **Komentarze to Twój przyjaciel:**
Dodawaj komentarze wyjaśniające co robi kod:
```sql
-- Obliczam średnią cenę produktów w każdej kategorii
SELECT
    CategoryID,
    AVG(UnitPrice) as AvgPrice  -- zaokrąglam do 2 miejsc
FROM Products
GROUP BY CategoryID;
```

4. **Testuj na małych danych:**
Zanim uruchomisz zapytanie na milionach rekordów, przetestuj na małej próbce:
```sql
SELECT ... FROM big_table LIMIT 100;
```

W naszej bazie to mniej istotne (mamy niewiele danych), ale w produkcji to życiowa zasada.

Okej, macie jakieś pytania techniczne zanim zaczniemy właściwe szkolenie? Nie? To jedziemy z SQL-em!"

**Wskazówki:**
- To musi być demonstracja na żywo, nie tylko slajd
- Niech uczestnicy otworzą swoje notebooki i powtórzą za Tobą
- Sprawdź czy wszyscy widzą ekran
- Możesz poprosić kogoś o podzielenie się ekranem żeby sprawdzić czy u nich działa
- Jeśli ktoś ma problemy, pomóż indywidualnie ale nie zatrzymuj całej grupy zbyt długo

---

# KONIEC SEKCJI ORGANIZACYJNEJ

## ✅ Co zrobiliśmy:
- Poznaliśmy plan szkolenia
- Skonfigurowaliśmy środowisko Databricks
- Zainicjalizowaliśmy bazę Northwind
- Poznaliśmy zasady pracy

## ➡️ Co dalej:
**Przechodzimy do części merytorycznej!**

Zaczynamy od przypomnienia podstaw SQL.

---

# NOTATKI DLA PROWADZĄCEGO - KONIEC SEKCJI

**Czas trwania:** 1 minuta

**Co powiedzieć:**
"Świetnie! Mamy za sobą część organizacyjną. Sprawdźmy szybko czy wszyscy są gotowi:

Kto ma:
✅ Działający dostęp do Databricks? [Wszyscy podnoszą ręce]
✅ Załadowaną bazę Northwind? [Sprawdzenie]
✅ Utworzony notebook do ćwiczeń? [Sprawdzenie]

Jeśli ktoś ma jakikolwiek problem - sygnalizujcie teraz, zanim ruszymy dalej.

[Pauza na zgłoszenia]

Wszystko działa? Doskonale!

To był appetizer. Teraz przechodzimy do właściwego dania - zaawansowanego SQL-a. Zaczynamy od szybkiego przypomnienia podstaw, a potem wchodzimy w głęboką wodę z CTE, funkcjami analitycznymi i całą resztą.

Gotowi? To jedziemy!"

**Wskazówki:**
- To dobry moment na szybkie podsumowanie i sprawdzenie czy wszyscy nadążają
- Możesz zapytać: "Jak się czujecie? Zagubiony ktoś?" - daj ludziom szansę na feedback
- Jeśli widzisz że ktoś ma problemy techniczne, możesz zaproponować pracę w parach
- Energia! Pokazuj entuzjazm - to zaraźliwe
- Możesz zrobić bardzo krótką przerwę (2-3 min) jeśli ludzie potrzebują - lepiej teraz niż w trakcie merytoryki

---

**KONIEC ROZDZIAŁU 1: SPRAWY ORGANIZACYJNE**

Szacowany czas realizacji: 15-20 minut

Następny rozdział: **Podstawy SQL - krótkie przypomnienie**
