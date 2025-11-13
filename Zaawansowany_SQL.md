PRZETW ARZANIE  DANYCH  – BIG DATA

Zaawansowany
SQL

Arkadiusz Kasprzak
07.11.2020

Copyright © Arkadiusz Kasprzak. All rights reserved.

AGENDA
1. Sprawy organizacyjne
2. Podstawy SQL – krótkie przypomnienie
3. Funkcje grupowania i agregacji
4. Common Table Expression (CTE)
5. Funkcje analityczne
6. Funkcje użytkownika
7. Operator APPLY
8. Co jeszcze warto wiedzieć…

Type here if  add info needed  for every slide

GFT Group: 5700 experts in 15 countries

Switzerland (45)

Basel
Zurich

Belgium (10)

Brussels

France (25)

Niort
Paris

UK (190)

London

Canada (260)

Toronto
Quebec

USA (55)

Boston
New York

Mexico (300)

Mexico City

Costa Rica (110)

Heredia

Brazil (890)

Alphaville
Curitiba
Sorocaba

Numbers include employees (FTE) and external staff

GFT Group

06/11/2020

Germany (450)

Bonn
Eschborn/Frankfurt
Karlsruhe
St. Georgen
Stuttgart

Italy (710)

Florence
Genoa
Milano
Montecatini Terme
Padova
Piacenza
Siena
Torino

China (5)

Hongkong

Singapore (5)

Singapore

Locations

Nearshore locations

06.11.2020

3

Poland (800)

Lodz
Poznan
Warsaw
Cracow

Spain (1975)

Alicante
Barcelona
Lleida
Madrid
Valencia
Zaragoza

W P R O W A D Z E N I E
Arkadiusz Kasprzak – o mnie

▪ Head of Data Poland w GFT

▪ Ponad 10 lat doświadczenia w IT

▪ Autor bloga o przetwarzaniu danych: https://oceandanych.pl

▪ Współtwórca GDG Cloud Poznań

▪ Namiary na mnie:

▪ akasprzak@wmi.amu.edu.pl / arek@oceandanych.pl
▪ LinkedIn

GFT Group

06.11.2020

4

S P R A W Y  O R G A N I Z A C Y J N E
Sprawy organizacyjne

▪ Warunki zaliczenia

▪ 4.0 – x*0.5 = ocena, gdzie x – liczba nieobecności (dla x=1,2)

▪ Przy >=3 nieobecnościach - ndst

▪ Aktywność na wykładach i/lub laboratoriach +1.0

▪ Korzystamy z bazy Northwind – skrypty na MS Teams w katalogu Baza danych

▪ Ankieta

GFT Group

06.11.2020

5

S P R A W Y  O R G A N I Z A C Y J N E
Zasady pracy na zajęciach

▪ Wypracujmy kontrakt. Moja propozycja:

▪ Włączone kamery

▪ Wyciszone mikrofony

▪ Zasada Vegas

▪ Nie nagrywamy wykładów

▪ Materiały zostały udostępnione*

▪ Nie oszukujemy z obecnością

▪ Zwracamy się do siebie formalnie czy nie?

GFT Group

06.11.2020

6

Podstawy SQL –
krótkie przypomnienie

P O D S T A W Y  S Q L
Pojęcia związane z przetwarzaniem zapytań SQL - teoria

Pojęcia związane z przetwarzaniem zapytań SQL:

▪ Selekcja – wybór odpowiednich wierszy

WHERE

▪ Projekcja – wybór odpowiednich kolumn

SELECT

▪ Złączenie – operacja pozwalająca pobrać dane z wielu tabel

JOIN

▪ Operatory algebraiczne – suma, różnica…

UNION, UNION ALL, EXCEPT, INTERSECT

▪ Agregacja – agregacja danych przy użyciu dostępnych funkcji agregujących

MIN, MAX, SUM, …

GFT Group

06.11.2020

8

P O D S T A W Y  S Q L
Pojęcia związane z przetwarzaniem zapytań SQL - praktyka

SELECT
FROM … JOIN …
WHERE
GROUP BY
HAVING
ORDER BY

5. Określenie wyniku zapytania – kolumny,
transformacje itp..

1. Określenie obiektów źródłowych i relacji między
nimi

2. Określenie warunków w celu odfiltrowania
odpowiednich rekordów

3. Grupowanie rekordów (agregacja)

4. Określenie warunków w celu odfiltrowania
odpowiednich grup

6. Sortowanie wyniku

GFT Group

06.11.2020

9

P O D S T A W Y  S Q L
Klauzula WHERE

▪ Klauzula WHERE umożliwia odfiltrowanie rekordów za pomocą warunku lub kilka warunków

połączonych operatorami logicznymi

▪ Operatory logiczne: AND, OR

▪ Operatory porównania: =, != , <>, <, >, LIKE, IN…

GFT Group

06.11.2020

10

P O D S T A W Y  S Q L
Klauzula WHERE

SELECT OrderID, CustomerID, ShipName, …

SELECT *

FROM

Orders

WHERE DATEPART(YEAR, OrderDate) > 1997

GFT Group

06.11.2020

11

P O D S T A W Y  S Q L
Złączenia - JOINs

▪ Rodzaje złączeń:

▪ Połączenia wewnętrzne – INNER JOIN

▪ Połączenia zewnętrzne – OUTER JOIN:

▪ LEFT [OUTER] JOIN
▪ RIGHT [OUTER] JOIN
▪ FULL [OUTER] JOIN

▪ Iloczyn kartezjański - CROSS JOIN

GFT Group

06.11.2020

12

P O D S T A W Y  S Q L
Złączenia - JOINs

GFT Group

06.11.2020

13

P O D S T A W Y  S Q L
Funkcje grupowania i agregacji

▪ Funkcje agregacji służą do wykonywania kalkulacji na zbiorze danych i zwracają pojedynczą wartość

▪ Za pomocą klauzuli GROUP BY możemy grupować rekordy i na każdej z grup przeprowadzić

kalkulację. Grupy są wyznaczane unikalne wartości atrybutów podanych w GROUP BY

GFT Group

06.11.2020

14

P O D S T A W Y  S Q L
Funkcje agregujące – krótkie przypomnienie

SELECT

FROM

COUNT(*) AS CNT1, COUNT(1) AS CNT2, COUNT(id) AS CNT3,
COUNT(testValue) AS CNT4
TestAggr;

SELECT

AVG(id) AS AVG FROM TestAggr;

SELECT
FROM

AVG(CAST(id as DECIMAL(10,2))) AS AVG
TestAggr;

GFT Group

06.11.2020

15

P O D S T A W Y  S Q L
Funkcje agregujące – krótkie przypomnienie

SELECT
FROM

ISNULL(MAX(id),0)+1 AS ID
EmptyTable;

SELECT
FROM

MAX(ISNULL(id,0))+1 AS ID
EmptyTable;

SELECT id, value
FROM

NotEmptyTable

SELECT
FROM
WHERE

ISNULL(MAX(id),0)+1 AS ID
NotEmptyTable
value = 'NonExistingValue';

SELECT
FROM
WHERE

MAX(ISNULL(id,0))+1 AS ID
NotEmptyTable
value = 'NonExistingValue';

GFT Group

06.11.2020

16

P O D S T A W Y  S Q L
GROUP BY – krótkie przypomnienie

Zadanie:

Korzystając z tabeli Orders wyświetl wszystkie identyfikatory klientów (wraz z
liczbą dokonanych przez nich zamówień), którzy dokonali co najmniej 10-ciu
zamówień pomiędzy majem 1997 a czerwcem 1998 (OrderDate [datetime]).
Wyniki posortuj malejąco zgodnie z liczbą zamówień.

SELECT

CustomerID, COUNT(*) AS CNT

FROM

Orders

WHERE

(DATEPART(YEAR, OrderDate)*100

+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806

GROUP BY CustomerID

HAVING

CNT > 10

HAVING

COUNT(*) > 10

ORDER BY CNT DESC;

GFT Group

06.11.2020

17

P O D S T A W Y  S Q L
GROUP BY – krótkie przypomnienie

Zadanie:

Korzystając z tabeli Customers rozbuduj
i zaktualizuj poprzednie
zapytanie tak, aby zamiast identyfikatora klienta wyświetlała się jego
nazwa (Customers.CompanyName [nvarchar]).

SELECT

C.CompanyName, COUNT(*) AS CNT

FROM

ON

Orders O JOIN Customers C

(O.CustomerID = C.CustomerID)

WHERE

(DATEPART(YEAR, OrderDate)*100

+DATEPART(MM, OrderDate)) BETWEEN 199705 AND
199806

GROUP BY C.CompanyName

HAVING

COUNT(*) > 10

ORDER BY CNT DESC;

GFT Group

06.11.2020

18

P O D S T A W Y  S Q L
Common Table Expression – krótkie przypomnienie

▪ CTE to zapytanie reprezentujące tymczasowy zestaw rekordów

▪ Po konstrukcji WITH należy użyć jednego z poleceń SELECT, INSERT UPDATE lub DELETE

▪ Można definiować więcej niż jedno CTE w ramach polecenia WITH, natomiast nie można definiować

kolejnej klauzuli WITH w ramach CTE

▪ Można definiować wiele zapytań CTE nierekursywnie, korzystając z operatów: UNION, UNION ALL,

INTERSECT lub EXCEPT

▪ W zapytaniu głównym można wielokrotnie odwoływać się do CTE

GFT Group

06.11.2020

19

P O D S T A W Y  S Q L
Common Table Expression – krótkie przypomnienie

▪ W konstrukcji CTE nie można używać poleceń:

▪ ORDER BY (z wyjątkiem gdy klauzula TOP jest podana)
▪ INTO
▪ OPTION
▪ FOR BROWSE

▪ … -> dokumentacja: https://msdn.microsoft.com/pl-pl/library/ms175972(v=sql.110).aspx

▪ Składnia:

GFT Group

06.11.2020

20

P O D S T A W Y  S Q L
CTE - przykład

WITH

ProdAvgUnitPrice (AvgUnitPrice)

AS

(

),

SELECT AVG(UnitPrice)

FROM

Products

GreaterThanAvg (ProductName, CategoryID, UnitPrice)

AS

(

)

SELECT ProductName, CategoryID, UnitPrice

FROM

Products P

WHERE

UnitPrice > (SELECT AvgUnitPrice FROM ProdAvgUnitPrice)

SELECT

G.ProductName, C.CategoryName, G.UnitPrice

FROM

ON

GreaterThanAvg G JOIN Categories C

(C.CategoryID = G.CategoryID);

GFT Group

06.11.2020

21

P O D S T A W Y  S Q L
Podzapytania

▪ Podzapytania mogą być:

▪ skorelowane oraz nieskorelowane

▪ Podzapytania mogą zwracać:

▪ Pojedynczą wartość: zapytania skalarne
▪ Listę wartości
▪ Dane tabelaryczne

▪ Przy zapytaniach skalarnych możemy używać do porównania operatorów =, <, >, <>, !=…

▪ Przy zapytaniach zwracających więcej wartości musimy użyć dodatkowo jednego z operatorów:

▪ ALL
▪ ANY (SOME)

GFT Group

06.11.2020

22

P O D S T A W Y  S Q L
Podzapytania - przykłady

SELECT

COUNT(1) AS CNT

FROM

Products

WHERE

UnitPrice >

(SELECT AVG(UnitPrice) FROM Products)

SELECT

p1.ProductName, p1.CategoryID

FROM

Products p1

WHERE

UnitPrice =

(SELECT MAX(p2.UnitPrice) FROM Products p2
WHERE p1.CategoryID = p2.CategoryID)

GFT Group

06.11.2020

23

P O D S T A W Y  S Q L
Podzapytania - przykłady

SELECT

p1.ProductName, p1.CategoryID

FROM

Products p1

WHERE

UnitPrice > ALL

(SELECT AVG(p2.UnitPrice) FROM Products p2

WHERE

p1.CategoryID !=

p2.CategoryID

GROUP BY p2.CategoryID)

GFT Group

06.11.2020

24

P O D S T A W Y  S Q L
Podzapytania - przykłady

SELECT ProductName, (SELECT CategoryName

FROM Categories c

WHERE c.CategoryID =

p.CategoryID)

AS CategoryName

FROM Products p

GFT Group

06.11.2020

25

P O D S T A W Y  S Q L
Podzapytania - przykłady

SELECT

ProductName, CategoryID,

(SELECT MAX(UnitPrice) FROM Products)

AS MaxUnitPrice

FROM Products

WHERE CategoryID != 1

SELECT MAX(UnitPrice)

AS MaxUnitPricePerCategory,

CategoryID

FROM

Products

GROUP BY CategoryID

GFT Group

06.11.2020

26

P O D S T A W Y  S Q L
Podzapytania – EXISTS vs. IN

▪ Operator [NOT] EXISTS jest używany aby zweryfikować czy istnieje jakiś rekord w podzapytaniu

▪ Operator [NOT] IN pozwala wyspecyfikować wiele wartości w klauzuli WHERE (wpisanych ręcznie lub też poprzez zapytanie)

SELECT

COUNT(1) AS CNT

FROM

WHERE

Products

CategoryID IN (1,3)

SELECT

COUNT(1) AS CNT

FROM

WHERE

Products

CategoryID IN (

SELECT

CategoryID

FROM

JOIN

Products P

Suppliers S ON (P.SupplierID = S.SupplierID)

WHERE

S.Country = 'UK'

)

GFT Group

06.11.2020

27

P O D S T A W Y  S Q L
Podzapytania – EXISTS vs. IN

SELECT COUNT(*) AS CNT

FROM

Orders

WHERE ShipRegion IN

(SELECT ShipRegion

FROM Orders

SELECT COUNT(*) AS CNT

FROM

Orders O

WHERE EXISTS (

SELECT 1

FROM

Orders P

WHERE CustomerID = 'HANAR')

WHERE P.CustomerID =

'HANAR’

AND O.ShipRegion =

P.ShipRegion)

NOT EXISTS = NOT IN

GFT Group

06.11.2020

28

p AND q

p OR q

p = q

NOT p

P O D S T A W Y  S Q L
Logika trójwartościowa

p

True

True

True

False

False

False

Unknown

Unknown

q

True

False

Unknown

True

False

Unknown

True

False

Unknown

Unknown

GFT Group

06.11.2020

29

P O D S T A W Y  S Q L
Logika trójwartościowa

p

True

True

True

False

False

False

Unknown

Unknown

q

True

False

Unknown

True

False

Unknown

True

False

Unknown

Unknown

p AND q

p OR q

True

False

False

False

True

True

True

False

p = q

True

False

False

True

NOT p

False

False

False

True

True

True

GFT Group

06.11.2020

30

P O D S T A W Y  S Q L
Logika trójwartościowa

Unknown

Unknown

p AND q

p OR q

True

False

False

False

True

True

True

True

False

p

True

True

True

False

False

False

Unknown

Unknown

q

True

False

True

False

Unknown

True

False

p = q

True

False

Unknown

False

True

NOT p

False

False

False

True

True

True

Unknown

True

Unknown

Unknown

Unknown

GFT Group

06.11.2020

31

P O D S T A W Y  S Q L
Logika trójwartościowa

Unknown

Unknown

p

True

True

True

False

False

False

Unknown

Unknown

q

True

False

True

False

Unknown

True

False

p AND q

p OR q

True

False

False

False

False

True

True

True

True

False

p = q

True

False

Unknown

False

True

NOT p

False

False

False

True

True

True

Unknown

Unknown

Unknown

True

Unknown

False

Unknown

Unknown

Unknown

Unknown

GFT Group

06.11.2020

32

P O D S T A W Y  S Q L
Logika trójwartościowa

Unknown

Unknown

p

True

True

True

False

False

False

Unknown

Unknown

q

True

False

True

False

Unknown

True

False

p AND q

p OR q

True

False

False

False

False

True

True

True

True

False

p = q

True

False

Unknown

False

True

NOT p

False

False

False

True

True

True

Unknown

Unknown

Unknown

True

Unknown

Unknown

False

Unknown

Unknown

Unknown

Unknown

Unknown

Unknown

Unknown

Unknown

Unknown

GFT Group

06.11.2020

33

P O D S T A W Y  S Q L
Operatory na zbiorach

INTERSECT

UNION
UNION ALL

MINUS
EXCEPT

GFT Group

06.11.2020

34

P O D S T A W Y  S Q L
CASE

GFT Group

06.11.2020

35

P O D S T A W Y  S Q L
CASE - przykłady

SELECT C.CategoryName,

COUNT(*) AS NumberOfProducts,

CASE

WHEN COUNT(*) > 10 THEN

'High'

WHEN COUNT(*) BETWEEN 6 AND

10 THEN 'Average'

ELSE 'Low'

END AS Level

FROM

Products P JOIN Categories C

ON

P.CategoryID = C.CategoryID

GROUP BY C.CategoryID, C.CategoryName

GFT Group

06.11.2020

36

P O D S T A W Y  S Q L
CASE - przykład

WITH NumberOfProductsInCategory AS

(

)

SELECT

C.CategoryName,

FROM

ON

COUNT(*) AS NumberOfProducts

Products P JOIN Categories C

P.CategoryID = C.CategoryID

GROUP BY

C.CategoryID, C.CategoryName

SELECT

CategoryName,

NumberOfProducts,

CASE NumberOfProducts

WHEN (SELECT MAX(NumberOfProducts)

FROM   NumberOfProductsInCategory )

THEN

'Best'

WHEN (SELECT MIN(NumberOfProducts)

FROM   NumberOfProductsInCategory )

THEN

'Worst'

ELSE

'Not too bad'

END AS Level

FROM NumberOfProductsInCategory;

GFT Group

06.11.2020

37

P O D S T A W Y  S Q L
Przykładowe funkcje/polecenia

▪ ISNULL

▪ COALESCE

▪ DISTINCT

▪ DATEPART / YEAR / MONTH / DAY / DATEADD

▪ …

GFT Group

06.11.2020

38

Funkcje grupowania
i agregacji

P O D S T A W Y  S Q L
GROUP BY – krótkie przypomnienie

Zadanie:

Korzystając z tabeli Orders wyświetl wszystkie identyfikatory klientów (wraz z
liczbą dokonanych przez nich zamówień), którzy dokonali co najmniej 10-ciu
zamówień pomiędzy majem 1997 a czerwcem 1998 (OrderDate [datetime]).
Wyniki posortuj malejąco zgodnie z liczbą zamówień.

SELECT

CustomerID, COUNT(*) AS CNT

FROM

Orders

WHERE

(DATEPART(YEAR, OrderDate)*100

+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806

GROUP BY CustomerID

HAVING

CNT > 10

HAVING

COUNT(*) > 10

ORDER BY CNT DESC;

GFT Group

06.11.2020

40

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUP BY – krótkie przypomnienie

Zadanie:

Korzystając z tabeli Customers rozbuduj
i zaktualizuj poprzednie
zapytanie tak, aby zamiast identyfikatora klienta wyświetlała się jego
nazwa (Customers.CompanyName [nvarchar]).

SELECT

C.CompanyName, COUNT(*) AS CNT

FROM

ON

Orders O JOIN Customers C

(O.CustomerID = C.CustomerID)

WHERE

(DATEPART(YEAR, OrderDate)*100

+DATEPART(MM, OrderDate)) BETWEEN 199705 AND
199806

GROUP BY C.CompanyName

HAVING

COUNT(*) > 10

ORDER BY CNT DESC;

GFT Group

06.11.2020

41

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
Zadanie

Zadanie:

Korzystając z tabeli Orders zaprojektuj zapytanie przedstawiające sumaryczną
liczbą zamówień w roku 1997 (OrderDate [datetime]) dla poszczególnych państw
i miast (ShipCity [nvarchar]), samych państw oraz
(ShipCountry [nvarchar]),
całościowe podsumowanie. Wynik posortuj rosnąco tak, aby w pierwszej kolejności
były prezentowane wyniki dla danego kraju i miast, następnie tylko dla danego
kraju - podsumowanie jako ostatnia pozycja.

GFT Group

06.11.2020

42

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP

▪ ROLLUP jest rozwinięciem polecenia GROUP BY, które pozwala wyliczyć dodatkowe podsumowania

częściowe i ogólne dla podgrup generowanych „od prawej do lewej”

▪ Zapytanie:

SELECT
...
GROUP BY ROLLUP (a,b,c)

Wygeneruje grupowania:

(a,b,c)
(a,b)
(a)
()

Wykonane zostaną grupowania:
• GROUP BY a,b,c
• GROUP BY a,b
• GROUP BY a
• GROUP BY ()

Rekord agregujący cały zbiór

Co jest tożsame z brakiem
grupowania

N+1 grupowań

GFT Group

06.11.2020

43

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP

▪ Czy możemy ten sam efekt uzyskać nie korzystając z polecenia ROLLUP?

SELECT 1 as Level, NULL as colA,
...

NULL as colB,

NULL as colC,

COUNT(...)

UNION ALL

SELECT 2,
...
GROUP BY a

UNION ALL

SELECT 3,
...
GROUP BY a, b

UNION ALL

SELECT 4,
...
GROUP BY a, b, c

a,

a,

a,

NULL,

NULL,

COUNT(...)

Odp.: Tak, ale po co? ☺

ROLLUP jest znacząco
bardziej wydajny

b,

b,

NULL,

COUNT(...)

c,

COUNT(...)

GFT Group

06.11.2020

44

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP – przykład

Bez ROLLUP:

SELECT s.* FROM (

SELECT

ShipCountry, ShipCity, COUNT(OrderID) as CNT

FROM

Orders

WHERE

DATEPART(yyyy, OrderDate) = 1997

GROUP BY ShipCountry, ShipCity

UNION ALL

ROLLUP:

SELECT

ShipCountry, ShipCity, COUNT(OrderID) as CNT

FROM

WHERE

Orders

DATEPART(yyyy, OrderDate) = 1997

GROUP BY

ROLLUP (ShipCountry, ShipCity)

ORDER BY

CASE WHEN ShipCountry IS NULL THEN 1 ELSE 0 END ASC,

SELECT

ShipCountry, NULL , COUNT(OrderID) as CNT

ShipCountry ASC,

FROM

Orders

WHERE

DATEPART(yyyy, OrderDate) = 1997

GROUP BY ShipCountry

UNION ALL

SELECT

NULL, NULL, COUNT(OrderID) as CNT

FROM

Orders

WHERE

DATEPART(yyyy, OrderDate) = 1997) s

ORDER BY CASE WHEN ShipCountry IS NULL THEN 1 ELSE 0 END ASC,
ShipCountry ASC, CASE WHEN ShipCity IS NULL THEN 1 ELSE 0 END
ASC, ShipCity ASC

CASE WHEN ShipCity IS NULL THEN 1 ELSE 0 END ASC,

ShipCity ASC

GFT Group

06.11.2020

45

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP – plany zapytań

GFT Group

06.11.2020

46

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP – przykłady grupowań

▪ Przykłady (źródło: https://technet.microsoft.com/pl-pl/library/bb522495(v=sql.105).aspx):

GFT Group

06.11.2020

47

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP – przykłady grupowań

GFT Group

06.11.2020

48

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
CUBE

▪ Polecenie CUBE działa w podobny sposób do polecenia ROLLUP, z tą różnicą,
poszczególnych grupowań uwzględniane są wszystkie kombinacje wskazanych kolumn.

iż przy tworzeniu

▪ Zapytanie

SELECT
...
GROUP BY CUBE (a,b,c)

Wygeneruje grupowania:

(a, b, c)
(a, b)
(a, c)
(a)
(b, c)
(b)
(c)
()

Wykonane zostaną grupowania:
• GROUP BY a,b,c
• GROUP BY a,b
• GROUP BY a,c
• GROUP BY a
• GROUP BY b,c
• GROUP BY b
• GROUP BY c
• GROUP BY ()

2^N grupowań

GFT Group

06.11.2020

49

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
CUBE – przykłady grupowań

GFT Group

06.11.2020

50

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
CUBE – zadanie

Zadanie

?

z

tabeli Orders

Korzystając
analizę
przedstawiającą liczbą zamówień w 3 wymiarach: rok (Orders.OrderDate [datetime]),
[nvarchar],
klienta
kraj
Customers.City [nvarchar]). Wyświetl dane dla liczby zamówień większej od 15.

(Customers.Country

oraz Customers

przedstaw pełną

oraz miasto

zamieszkania

SELECT

DATEPART(yyyy,O.OrderDate) as Year, C.Country,
C.City, COUNT(*) as NumberOfOrders

FROM

Orders O JOIN Customers C

ON

(O.CustomerID = C.CustomerID)

GROUP BY CUBE(DATEPART(yyyy,O.OrderDate),

C.Country,

C.City)

HAVING COUNT(*) > 15

ORDER BY NumberOfOrders DESC;

GFT Group

06.11.2020

51

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP & CUBE – kolumny złożone

SELECT

...

SELECT

...

GROUP BY ROLLUP ((a, b), c)

GROUP BY CUBE ((a, b), c)

(a, b, c)

(a, b)

()

Brak:

(a)

(a, b, c)

(a, b)

(c)

()

Brak:

(a, c)

(a)

(b, c)

(b)

GFT Group

06.11.2020

52

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP & CUBE – redukcja grup

SELECT

...

SELECT

...

GROUP BY a, ROLLUP (b, c, d)

GROUP BY a, CUBE (b, c, d)

(a, b, c, d)

(a, b, c)

(a, b)

(a)

(a, b, c, d)

(a, b, c)

(a, b, d)

(a, b)

(a, c, d)

(a, c)

(a, d)

(a)

GFT Group

06.11.2020

53

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUPING SETS

▪ Polecenie GROUPING SETS pozwala określić konkretne poziomy grupowania:

▪ Poszczególne grupy wymieniamy po przecinku.
▪ Grupy złożone z kilku kolumn ujmujemy w nawiasy ()

▪ Za pomocą GROUPING SETS możemy opisać podzbiory tworzone przez CUBE i ROLLUP:

ROLLUP(ShipCountry, ShipCity) <=> GROUPING SETS((ShipCountry, ShipCity), (ShipCountry), ())

▪ Jest to np. pomocne, gdy chcemy zrezygnować, z niektórych poziomów grupowania wymuszonych przez ROLLUP

i/lub CUBE

▪ GROUPING SETS może być użyte razem z poleceniami ROLLUP i CUBE w klauzuli GROUP BY: np.:

GROUP BY ROLLUP

(DATEPART(yyyy, OrderDate),

DATEPART(qq, OrderDate)),

GROUPING SETS(

(ShipCountry,

ShipCity),

(ShipCountry))

GFT Group

06.11.2020

54

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
ROLLUP/CUBE/GROUPING SETS - potencjalnie problemy?

Zadanie:

liczbą

Korzystając z tabeli Orders zaprojektuj zapytanie przedstawiające
sumaryczną
państw
(ShipCountry [nvarchar]), regionów (ShipRegion [nvarchar]) oraz
(ShipCity [nvarchar]) wraz z pośrednimi oraz pełnym
miast
podsumowaniem (ROLLUP).

poszczególnych

zamówień

dla

SELECT

ShipCountry, ShipRegion, ShipCity,
COUNT(OrderID) as NumberOfOrders

FROM

Orders

GROUP BY ROLLUP (ShipCountry, ShipRegion, ShipCity)

GFT Group

06.11.2020

55

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUPING

▪ GROUPING jest funkcją wskazującą czy dana kolumna/wyrażenie jest agregowane

▪ Składnia:

GROUPING ( kolumna/wyrażenie )

▪ Zwracane wartości [tinyint]:

▪ 1 – kolumna/wyrażenie jest agregacją
▪ 0 – w przeciwnym razie

▪ Funkcja GROUPING może być użyta jedynie w poleceniu SELECT, HAVING oraz ORDER BY

(zakładając, że użyto polecenia grupującego GROUP BY)

GFT Group

06.11.2020

56

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUPING – przykład użycia

SELECT

ShipCountry,

ShipRegion,

ShipCity,

COUNT(OrderID) AS NumberOfOrders,

GROUPING(ShipCountry) AS

ShipCntryGrp,

GROUPING(ShipRegion) AS

ShipRegGrp,

GROUPING(ShipCity) AS

ShipCityGrp

FROM

Orders

GROUP BY ROLLUP (ShipCountry,

ShipRegion,

ShipCity)

GFT Group

06.11.2020

57

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUPING_ID

▪ GROUPING_ID jest funkcją wyliczającą poziom grupowania dla poszczególnych kolumn (wyrażeń) w

postaci wektora bitowego. Zwracana wartość jest decymalną reprezentacją tego wektora.

▪ Składnia:

▪ Zwracany typ: int

GROUPING_ID ( kolumna/wyrażenie [,…n] )

▪ Funkcja GROUPING_ID może być użyta jedynie w poleceniu SELECT, HAVING oraz ORDER BY

(zakładając, że użyto polecenia grupującego GROUP BY)

GFT Group

06.11.2020

58

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
GROUPING_ID - przykłady

Podzbiory

Agregowane kolumny GROUPING_ID (a, b, c)

Wynik funkcji
GROUPING_ID()

(a, b, c)

(a, b)

(a, c)

(b, c)

(a)

(b)

(c)

()

GFT Group

-

c

b

a

b c

a c

a b

a b c

0 0 0

0 0 1

0 1 0

1 0 0

0 1 1

1 0 1

1 1 0

1 1 1

0

1

2

4

3

5

6

7

06.11.2020

59

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
Przykład

Zadanie

Korzystając z tabeli Products, Categories, Suppliers przeanalizuj średnią
jednostkową, minimalną oraz maksymalną cenę produktu w 3 wymiarach:
kraj
kategoria
(Suppliers.City [nvarchar]) wraz z regionem dostawcy (Suppliers.Region
[nvarchar]) oraz wyłącznie dla kraju.

(Categories.CategoryName

[nvarchar]),

produktu

W rozwiązaniu uwzględnij jedynie produkty, które posiadają wskazanie na
dostawcę oraz przypisaną kategorie. Wartości puste w polu region, które
wynikają z danych zamień na wartość – „Not provided”.

Do rozwiązania dodaj kolumnę, która dla poszczególnych wymiarów
przyjmie następujące wartości:

▪ Kategoria produktu

– „Category”

▪ Kraj wraz z regionem

– „Country & Region”

▪ Kraj

– „Country”

GFT Group

06.11.2020

60

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
Przykład - rozwiązanie

SELECT

C.CategoryName

S.Country

CASE

WHEN

AS Category,

AS Country,

GROUPING(S.Region) = 0

AND S.Region IS NULL THEN 'Not Provided'

ELSE

S.Region

END

AS Region,

ROUND(AVG(P.UnitPrice), 2)

AS AvgUnitPrice,

MIN(UnitPrice)

MAX(UnitPrice)

AS MinUnitPrice,

AS MaxUnitPrice,

CASE GROUPING_ID (C.CategoryName, S.Country, S.Region)

WHEN 5 THEN 'Country'

WHEN 4 THEN 'Country & Region'

WHEN 3 THEN 'Category'

AS GroupingLevel

END

Products P

Categories C

P.CategoryID = C.CategoryID

Suppliers S

P.SupplierID = S.SupplierID

FROM

JOIN

ON

JOIN

ON

GROUP BY GROUPING SETS ((C.CategoryName),

(S.Country, S.Region),

(S.Country))

GFT Group

06.11.2020

61

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
PIVOT

▪ Polecenie PIVOT pozwala przekształcić wyniki z jednego układu tabelarycznego w inny układ

tabelaryczny

▪ Celem jest

transformacja danych z układu wierszowego na kolumnowy, w celu czytelniejszej

prezentacji danych

▪ Podczas przekształcenia wykonywana jest agregacja

▪ Wartości NULL nie są uwzględniane przy obliczaniu agregacji

GFT Group

06.11.2020

62

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
PIVOT

Zadanie
Korzystając z tabel Products, Categories, Order Details oraz Orders przedstaw sumę
wartości zamówień (Order Details.UnitPrice [money], Order Details.Quantity [smallint])
produktów w danej kategorii (Categories.CategoryName [nvarchar]) w poszczególnych
latach (Orders.OrderDate [datetime]), uwzględniając dane, które posiadają wszystkie
wymagane informacje.

SELECT

C.CategoryName AS CategoryName,

DATEPART(yyyy,O.OrderDate) AS Year,

SUM(OD.UnitPrice*OD.Quantity) AS Amount
[Products] P

[Order Details] OD

P.ProductID = OD.ProductID

[Orders] O

OD.OrderID = O.OrderID
[Categories] C

FROM

JOIN

ON

JOIN

ON
JOIN

ON
GROUP BY C.CategoryName, DATEPART(yyyy,OrderDate)

C.CategoryID = P.CategoryID

GFT Group

06.11.2020

63

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
PIVOT

Zadanie*

Zaktualizuj poprzednie zapytanie,
tak aby jako wiersze
otrzymać kategorie, a lata jako kolumny. Na przecięciu tych
wartości powinna być zaprezentowana kwota zamówień dla
danej kategorii w danym roku.

GFT Group

06.11.2020

64

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
PIVOT

SELECT [CategoryName], [1996], [1997], [1998]

FROM (

SELECT

C.CategoryName

AS CategoryName,

DATEPART(yyyy,OrderDate)

AS Year,

(OD.UnitPrice*OD.Quantity) AS Amount

FROM

JOIN
ON

JOIN

ON

JOIN

ON

[Products] P

[Order Details] OD
P.ProductID = OD.ProductID

[Orders] O

OD.OrderID = O.OrderID

[Categories] C

C.CategoryID = P.CategoryID) S

PIVOT

(

SUM(S.Amount)

FOR Year IN ([1996], [1997], [1998])

) AS AMT

GFT Group

06.11.2020

65

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
PIVOT

SELECT [CategoryName], [1996], [1997], [1998]

FROM (

SELECT

C.CategoryName

AS CategoryName,

DATEPART(yyyy,OrderDate)

AS Year,

(OD.UnitPrice*OD.Quantity) AS Amount

FROM

JOIN
ON

JOIN

ON

JOIN

ON

[Products] P

[Order Details] OD
P.ProductID = OD.ProductID

[Orders] O

OD.OrderID = O.OrderID

[Categories] C

C.CategoryID = P.CategoryID) S

PIVOT

(

SUM(S.Amount)

FOR Year IN ([1996], [1997], [1998])

) AS AMT

GFT Group

06.11.2020

66

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
UNPIVOT

▪ Polecenie UNPIVOT jest operacją odwrotną do operacji PIVOT w sensie układu (przekształca z
wierszowego układu tabelarycznego na kolumnowy), ale korzystając z UNPIVOT nie można odtworzyć
oryginalnej tabeli, która została przekształcona za pomocą polecenia PIVOT

▪ Wszystkie kolumny na liście UNPIVOT muszą być dokładnie tego samego typu oraz tej samej długości

GFT Group

06.11.2020

67

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
UNPIVOT

▪ Mamy tabelę:

▪ Chcemy przekształcić i zaprezentować wynik w

postaci:

GFT Group

06.11.2020

68

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
UNPIVOT

SELECT ID, CustomerID, ProductCode, Quantity

FROM

(

SELECT ID, CustomerID, ProductA, ProductB,

ProductC

FROM

SalesUnpivot) p

UNPIVOT

(Quantity FOR ProductCode IN (ProductA,

ProductB, ProductC )) AS unpvt

GFT Group

06.11.2020

69

F U N K C J E   G R U P O W A N I A   I   A G R E G A C J I
Podsumowanie

▪ NULL w funkcjach agregujących!

▪ Polecenia ROLLUP and CUBE umożliwiają tworzenie podsumowań na różnych poziomach agregacji

▪ Polecenie GROUPING SETS umożliwia określenie własnych zbiorów grupowań

▪ Polecenia PIVOT/UNPIVOT pozywają transformować wynik z jednego układu tabelarycznego w inny

(np. z rekordowego na kolumnowy i odwrotnie)

▪ GROUPING i GROUPING_ID – pomocne funkcje do określenia poziomu grupowania

GFT Group

06.11.2020

70

Common Table
Expression

C O M M O N T A B L E E XP R E S S I O N
CTE - przykład

WITH

ProdAvgUnitPrice (AvgUnitPrice)

AS

(

),

SELECT AVG(UnitPrice)

FROM

Products

GreaterThanAvg (ProductName, CategoryID, UnitPrice)

AS

(

)

SELECT ProductName, CategoryID, UnitPrice

FROM

Products P

WHERE

UnitPrice > (SELECT AvgUnitPrice FROM ProdAvgUnitPrice)

SELECT

G.ProductName, C.CategoryName, G.UnitPrice

FROM

ON

GreaterThanAvg G JOIN Categories C

(C.CategoryID = G.CategoryID);

GFT Group

06.11.2020

72

C O M M O N   T A B L E   E XP R E S S I O N
Rekurencja – definicja i przykłady

▪ Rekurencja, zwana także rekursją jest odwołaniem się np.

funkcji

lub definicji do samej siebie

(Wikipedia)

▪ Obliczanie silni jako przykład rekurencji:

▪ Przykłady:

▪ 4! = 4 ∗ 3! = 4 ∗ 3 ∗ 2! = 4 ∗ 3 ∗ 2 ∗ 1! = 4 ∗ 3 ∗ 2 ∗ 1 = 24
▪ 5! = 5 ∗ 4! = 5 ∗ 4 ∗ 3! = … = 5 ∗ 4! = 5 ∗ 24 = 120

GFT Group

06.11.2020

73

C O M M O N   T A B L E   E XP R E S S I O N
Rekurencyjne CTE

▪ Rekurencyjna definicja CTE musi zawierać co najmniej dwa zapytania: zapytanie zakotwiczające

(anchor member) oraz zapytanie rekurencyjne (recursive member).

▪ Można użyć wielu zapytań zakotwiczający oraz rekurencyjnych, natomiast wszystkie zapytania

zakotwiczający muszą być zdefiniowane przed zapytaniami rekurencyjnymi.

▪ Wszystkie zapytania zakotwiczające muszą być połączone za pomocą operatorów UNION ALL,

UNION, INTERSECT lub EXCEPT.

▪ Pomiędzy zapytaniem zakotwiczający a rekurencyjnym może być użyty jedynie UNION ALL

▪ Warunek stopu występuje, gdy zapytanie rekurencyjne nie zwróci żadnego rekordu

GFT Group

06.11.2020

74

C O M M O N   T A B L E   E XP R E S S I O N
Rekurencyjne CTE

▪ Liczba kolumn oraz typ zapytania zakotwiczającego oraz rekurencyjnego musi być taka sama

▪ Następujące elementy nie są dozwolone w rekurencyjnym zapytaniu:

▪ SELECT DISTINCT
▪ GROUP BY
▪ PIVOT (w zależności od poziomu kompatybilności bazy danych)
▪ HAVING
▪ Skalarna agregacja
▪ TOP
▪ OUTER JOIN
▪ Podzapytania
▪ Podpowiedź (hint) stosowana do zapytania rekurencyjnego wewnątrz definicji CTE

GFT Group

06.11.2020

75

C O M M O N   T A B L E   E XP R E S S I O N
Rekurencyjne CTE - silnia

WITH Factorial (N, FactorialValue) AS

(

)

SELECT 1, 1

UNION ALL

Zapytanie zakotwiczające

Tu się dzieje rekurencja

SELECT N+1, (N+1) * FactorialValue

FROM

Factorial

WHERE N < 10

Odwołanie do CTE

Warunek stopu

SELECT N, FactorialValue

FROM Factorial

Zapytanie rekurencyjne

GFT Group

06.11.2020

76

C O M M O N   T A B L E   E XP R E S S I O N
Zapytania hierarchiczne

Zadanie

Korzystając z tabeli Employees wyświetl
imię
(FirstName [nvarchar]) oraz nazwisko (LastName [nvarchar]) pracownika oraz
identyfikator, imię i nazwisko jego przełożonego. Do znalezienia przełożonego danego
pracowania użyj pola ReportsTo (FK, [int]).

(EmployeeID [int]),

identyfikator

GFT Group

06.11.2020

77

C O M M O N   T A B L E   E XP R E S S I O N
CTE

WITH EmployeesRecCTE

(

)

AS

(

)

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName

SELECT

EmployeeID, FirstName, LastName, ReportsTo,

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName,

CAST(NULL AS NVARCHAR(20))

AS ManagerLastName

FROM

WHERE

UNION ALL

Employees

ReportsTo IS NULL

SELECT

E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName,

R.LastName

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo = R.EmployeeID

SELECT

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName,

ManagerLastName

FROM

EmployeesRecCTE;

GFT Group

06.11.2020

78

C O M M O N   T A B L E   E XP R E S S I O N
CTE – Poziom rekurencji

WITH EmployeesRecCTE

(

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName,

Level

)

AS

(

SELECT

EmployeeID, FirstName, LastName, ReportsTo,

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName,

CAST(NULL AS NVARCHAR(20))

AS ManagerLastName,

0 AS Level

Employees

ReportsTo IS NULL

FROM

WHERE

UNION ALL

SELECT

E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName,

R.LastName, Level + 1

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo = R.EmployeeID

)

SELECT

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName,

ManagerLastName, Level

FROM

EmployeesRecCTE;

GFT Group

06.11.2020

79

C O M M O N   T A B L E   E XP R E S S I O N
CTE – MAXRECURSION – ograniczenie poziomu rekurencji

WITH EmployeesRecCTE

(

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName, Level

)

AS

(

SELECT

EmployeeID, FirstName, LastName, ReportsTo,

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName,

CAST(NULL AS NVARCHAR(20)) AS ManagerLastName,

0 AS Level

Employees

ReportsTo IS NULL

FROM

WHERE

UNION ALL

SELECT

E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName,

R.LastName, Level + 1

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo = R.EmployeeID

)

SELECT

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName,

ManagerLastName, Level

FROM

OPTION

EmployeesRecCTE

(MAXRECURSION 1);

GFT Group

06.11.2020

80

C O M M O N   T A B L E   E XP R E S S I O N

CTE - Podsumowanie

▪ Poprawia czytelność i przejrzystość kodu

▪ Umożliwia tworzenia zapytań rekurencyjnych

▪ Umożliwia tworzenie zapytań hierarchicznych (parent – child)

▪ …

GFT Group

06.11.2020

81

Funkcje analityczne

F U N K C J E   A N A L I T Y C Z N E
Funkcje analityczne

▪ Funkcje analityczne umożliwiają realizowanie obliczeń na zbiorach wierszy w elastyczny,
czytelny i efektywny sposób. (Itzik Ben-Gan, „Microsoft SQL Server 2012 Optymalizacja kwerend T-
SQL przy użyciu funkcji okna)

▪ Funkcje analityczne vs. funkcje okna

▪ Podział funkcji analitycznych:

▪ Funkcje agregujące
▪ Funkcje rankingowe
▪ Funkcje rozkładu
▪ Funkcje przesunięcia

GFT Group

06.11.2020

83

F U N K C J E   A N A L I T Y C Z N E
Agregacja na całym zbiorze vs. OVER()

SELECT

SUM(UnitPrice) AS SUM

SELECT

P.ProductName,

FROM

Products

C.CategoryName,

SUM(P.UnitPrice) OVER () AS SUM

FROM

ON

Products P JOIN Categories C

P.CategoryID = C.CategoryID

. . .

GFT Group

06.11.2020

84

F U N K C J E   A N A L I T Y C Z N E
GROUP BY vs OVER (PARTITION BY…)

SELECT

C.CategoryName,

SELECT

P.ProductName,

SUM(P.UnitPrice) AS SUM

C.CategoryName,

FROM

ON

Products P JOIN Categories C

P.CategoryID = C.CategoryID

GROUP BY C.CategoryName

SUM(P.UnitPrice) OVER (PARTITION BY C.CategoryName)

AS SUM

FROM

ON

Products P JOIN Categories C

P.CategoryID = C.CategoryID

. . .

GFT Group

06.11.2020

85

F U N K C J E   A N A L I T Y C Z N E
OVER () – składnia

nazwa_funkcji (<argumenty>) OVER (

Klauzula porządku w
ramach partycji lub całego
zbioru

)

[ <PARTITION BY ...> ]

[ <ORDER BY ...> ]

[ <ROW or RANGE ...> ]

Klauzula partycji

GFT Group

06.11.2020

86

Klauzula okna
(ramki)

F U N K C J E   A N A L I T Y C Z N E
OVER () – definicja pojęć

▪ Partycja – jest to podzbiór danych wyznaczony poprzez unikalne wartości podanych argumentów, na

którym jest wykonywana funkcja

▪ Klauzula porządku –

określa

kolejność wykonywania

operacji

na

podzbiorze

danych

wyspecyfikowanych poprzez partycję (o ile została zdefiniowana) lub na pełnym zbiorze

▪ Okno (ramki) – występuje tylko w przypadku funkcji okna i pozwala zdefiniować ruchomy zakres

wierszy w partycji, w ramach których funkcja będzie wyznaczała wartość

▪ Bieżący wiersz – wiersz, dla którego w danym momencie wyznaczany jest wynik funkcji analitycznej

GFT Group

06.11.2020

87

F U N K C J E   A N A L I T Y C Z N E
OVER (PARTITION BY …)

SELECT

ProductID, CategoryID, UnitPrice,

MAX(UnitPrice) OVER () AS MaxAll,

MAX(UnitPrice) OVER (PARTITION BY CategoryID)

AS MaxByCategory

FROM

Products

Funkcja MAX wykonana na
całym zbiorze

Funkcja MAX wykonana na
partycjach
wyznaczonych
poprzez identyfikator kategorii
CategoryID

GFT Group

06.11.2020

88

F U N K C J E   A N A L I T Y C Z N E
OVER (PARTITION BY … ORDER BY … + WINDOW)

SELECT

ProductID, CategoryID, UnitPrice, UnitsOnOrder,

MAX(UnitPrice) OVER () AS MaxAll,

MAX(UnitPrice) OVER (PARTITION BY CategoryID)

AS MaxByCategory,

MAX(UnitPrice) OVER (PARTITION BY CategoryID

ORDER BY UnitsOnOrder, ProductID DESC

ROWS BETWEEN 3 PRECEDING

AND 3 FOLLOWING)

AS MaxByCategoryWithWindow

FROM

Products

Okno/ramka – bieżący
rekord + 3 poprzedzające
oraz 3 następujące po
bieżącym

Bieżący rekord

GFT Group

06.11.2020

89

F U N K C J E   A N A L I T Y C Z N E
OVER (PARTITION BY … ORDER BY … + WINDOW)

SELECT

ProductID, CategoryID, UnitPrice, UnitsOnOrder,

MAX(UnitPrice) OVER () AS MaxAll,

MAX(UnitPrice) OVER (PARTITION BY CategoryID)

AS MaxByCategory,

MAX(UnitPrice) OVER (PARTITION BY CategoryID

ORDER BY UnitsOnOrder, ProductID DESC

ROWS BETWEEN 3 PRECEDING

AND 3 FOLLOWING)

AS MaxByCategoryWithWindow

FROM

Products

Okno/ramka – bieżący
rekord + 3 poprzedzające
oraz 3 następujące po
bieżącym

Bieżący rekord

GFT Group

06.11.2020

90

F U N K C J E   A N A L I T Y C Z N E
Partycje - PARTITION BY

▪ Do podziału na partycje używa się słów kluczowych

PARTITION BY

▪ Podział może być realizowany za pomocą jednego lub wielu

wyrażeń

▪ Przykłady

PARTITION BY CategoryID

PARTITION BY CategoryID, SupplierID

PARTITION BY DATEPART(yyyy, OrderDate)

GFT Group

06.11.2020

91

F U N K C J E   A N A L I T Y C Z N E
Sortowanie – ORDER BY

▪ Do ustalenia porządku wykorzystuje się polecenie

ORDER BY

▪ W niektórych funkcjach analitycznych ustalenie porządku

w ramach zbioru jest obligatoryjne

▪ Sortowanie może być wykonane w oparciu o jedno lub

wiele wyrażeń

▪ Przykłady:

ORDER BY ProductID ASC
ORDER BY ProductID ASC, UnitsOnOrder DESC
ORDER BY DATEPART(yyyy, OrderDate), ShipCity DESC
ORDER BY (SELECT NULL)

GFT Group

06.11.2020

92

F U N K C J E   A N A L I T Y C Z N E
Definiowanie okna - składnia

▪ Okno (ramka) pozwala na wyznaczenie wartości funkcji ruchomych, przyrostowych.

▪ Składnia:

ROWS | RANGE BETWEEN

<początek przedziału okna> AND <koniec przedziału okna>

▪ UNBOUNDED PRECEDING – wszystkie rekordy od początku partycji (poprzedzające bieżący wiersz)

▪ <n> PRECEDING

– n rekordów poprzedzający bieżący wiersz

▪ CURRENT ROW

– bieżący wiersz

▪ <n> FOLLOWING

– n rekordów następujący po bieżącym wierszu

▪ UNBOUNDED FOLLOWING – wszystkie rekordy następujące po danym wierszu (do końca partycji)

GFT Group

06.11.2020

93

F U N K C J E   A N A L I T Y C Z N E
Definiowanie okna – ROWS vs. RANGE

▪ ROWS – określa rozmiar okna (ramki) z dokładnością do jednego wiersza

▪ RANGE – oznacza zakres bazując na wartości danego wiersza. Dla RANGE CURRENT ROW oznacza
bieżący rekord oraz wszystkie poprzedzające/następujące rekordy, które mają taką samą wartość jak bieżący.
W RANGE można wykorzystać kombinacje:

UNBOUNDED PRECEDING AND CURRENT ROW

CURRENT ROW

CURRENT ROW AND UNBOUNDED FOLLOWING

▪ Dla funkcji okna (z ramką), gdy podamy ORDER BY a nie wyspecyfikujemy okna to domyślna wartość

okna/ramki przyjmuje postać:

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

GFT Group

06.11.2020

94

F U N K C J E   A N A L I T Y C Z N E
Definiowanie okna - przykłady

▪ Okno obejmujące 7 wierszy: bieżący, 4 poprzedzający i 2 następujące po bieżącym:

ROWS BETWEEN 4 PRECEDING AND 2 FOLLOWING

▪ Okno obejmujące bieżący wiersz i 3 następne:

ROWS BETWEEN CURRENT ROW AND 3 FOLLOWING

▪ Okno obejmujące wszystkie poprzednie do bieżącego wiersza włącznie:

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

ROWS UNBOUNDED PRECEDING

▪ Okno obejmujące wszystkie poprzedzające rekordy oraz wszystkie wiersze z taką samą wartością jak

wiersz bieżący:

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

RANGE UNBOUNDED PRECEDING

GFT Group

06.11.2020

95

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące

▪ Funkcje agregujące mogę być wykorzystywane zarówno z klauzulą OVER jak i w połączeniu z

GROUP BY

▪ Funkcje agregacji służą do wykonywania operacji na zbiorze wierszy

▪ Funkcje agregujące:

▪ SUM
▪ COUNT
▪ COUNT_BIG
▪ AVG
▪ MIN
▪ MAX
▪ STDEV
▪ STDEVP
▪ VAR
▪ VARP
▪ CHECKSUM_AGG

GFT Group

06.11.2020

96

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – AVG & SUM

SELECT

OrderID,

ProductID,

UnitPrice,

Quantity,

UnitPrice*Quantity AS Value,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN UNBOUNDED PRECEDING AND

CURRENT ROW) AS RunSum,

AVG(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN 1 PRECEDING AND

CURRENT ROW) AS MovAvg

FROM

[Order Details]

GFT Group

06.11.2020

97

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – AVG & SUM

SELECT

OrderID,

ProductID,

UnitPrice,

Quantity,

UnitPrice*Quantity AS Value,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN UNBOUNDED PRECEDING AND

CURRENT ROW) AS RunSum,

AVG(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN 1 PRECEDING AND

CURRENT ROW) AS MovAvg

FROM

[Order Details]

GFT Group

06.11.2020

98

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – AVG & SUM – różne partycje?

SELECT

OrderID,

ProductID,

UnitPrice,

Quantity,

Nie ma problemu! Trzeba tylko
odpowiednio zaprezentować wyniki.

UnitPrice*Quantity AS Value,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN UNBOUNDED PRECEDING AND

CURRENT ROW) AS RunSum,

AVG(UnitPrice*Quantity) OVER (

PARTITION BY ProductID

ORDER BY ProductID ROWS BETWEEN 3

PRECEDING AND CURRENT ROW) AS MovAvg

FROM

[Order Details]

GFT Group

06.11.2020

99

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – AVG & SUM – różne partycje?

SELECT

OrderID,

ProductID,

UnitPrice,

Quantity,

UnitPrice*Quantity AS Value,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OrderID

ORDER BY ProductID

ROWS BETWEEN UNBOUNDED PRECEDING AND

CURRENT ROW) AS RunSum,

AVG(UnitPrice*Quantity) OVER (

PARTITION BY ProductID

ORDER BY ProductID ROWS BETWEEN 3

PRECEDING AND CURRENT ROW) AS MovAvg

FROM

[Order Details]

ORDER BY OrderID

GFT Group

06.11.2020

100

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – domyślne okno/ramka

SELECT

OD.ProductID,

O.OrderDate,

OD.UnitPrice*OD.Quantity AS Amount,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)) AS Total,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)

ORDER BY O.OrderDate) AS RunTotal

FROM

JOIN

ON

[Orders] O

[Order Details] OD

(O.OrderID = OD.OrderID)

GFT Group

06.11.2020

101

F U N K C J E   A N A L I T Y C Z N E
Funkcje agregujące – domyślne okno/ramka

SELECT

OD.ProductID,

O.OrderDate,

OD.UnitPrice*OD.Quantity AS Amount,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)) AS Total,

SUM(UnitPrice*Quantity) OVER (

PARTITION BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)

ORDER BY O.OrderDate) AS RunTotal

FROM

JOIN

ON

[Orders] O

[Order Details] OD

(O.OrderID = OD.OrderID)

GFT Group

06.11.2020

102

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe

▪ Funkcje rankingowe:

▪ ROW_NUMBER

▪ NTILE

▪ RANK

▪ DENSE_RANK

GFT Group

06.11.2020

103

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – ROW_NUMBER - stronicowanie

DECLARE

@pageNum AS INT = 2,

@pageSize AS INT = 25;

WITH OrdersWithRowNum AS

(

)

SELECT ROW_NUMBER() OVER (ORDER BY OrderID) as rowNum,

OrderID, CustomerID, EmployeeID, OrderDate

FROM

Orders

SELECT

OrderID, CustomerID, EmployeeID, OrderDate,

@pageNum AS pageNum

OrdersWithRowNum

rowNum BETWEEN (@pageNum - 1)*@pagesize + 1 AND
@pageNum * @pageSize

FROM

WHERE

GFT Group

06.11.2020

104

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – ROW_NUMBER - stronicowanie

DECLARE

@pageNum AS INT = 3,

@pageSize AS INT = 25;

WITH OrdersWithRowNum AS

(

)

SELECT ROW_NUMBER() OVER (ORDER BY OrderID) as rowNum,

OrderID, CustomerID, EmployeeID, OrderDate

FROM

Orders

SELECT

OrderID, CustomerID, EmployeeID, OrderDate,

@pageNum AS pageNum

OrdersWithRowNum

rowNum BETWEEN (@pageNum - 1)*@pagesize + 1 AND
@pageNum * @pageSize

FROM

WHERE

GFT Group

06.11.2020

105

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – RANK vs. DENSE_RANK

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

RANK() OVER (ORDER BY UnitPrice) AS rank,

DENSE_RANK() OVER (ORDER BY UnitPrice)

FROM

AS denseRank

Products P

LEFT OUTER JOIN

Categories C

ON

(P.CategoryID = C.CategoryID)

GFT Group

06.11.2020

106

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – RANK vs. DENSE_RANK

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

RANK() OVER (ORDER BY UnitPrice) AS rank,

DENSE_RANK() OVER (ORDER BY UnitPrice)

FROM

AS denseRank

Products P

LEFT OUTER JOIN

Categories C

ON

(P.CategoryID = C.CategoryID)

GFT Group

06.11.2020

107

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – RANK vs. DENSE_RANK vs. ROW_NUM

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

RANK() OVER (ORDER BY UnitPrice) AS rank,

DENSE_RANK() OVER (ORDER BY UnitPrice)

AS denseRank,

ROW_NUMBER() OVER (ORDER BY UnitPrice)

FROM

AS rowNum

Products P

LEFT OUTER JOIN

Categories C

ON

(P.CategoryID = C.CategoryID)

GFT Group

06.11.2020

108

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – RANK vs. DENSE_RANK vs. ROW_NUM

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

RANK() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS rank,

DENSE_RANK() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS denseRank,

ROW_NUMBER() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS rowNum

FROM

Products P

LEFT OUTER JOIN

Categories C

ON

(P.CategoryID = C.CategoryID)

GFT Group

06.11.2020

109

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – RANK vs. DENSE_RANK vs. ROW_NUM

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

RANK() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS rank,

DENSE_RANK() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS denseRank,

ROW_NUMBER() OVER (PARTITION BY P.CategoryID

ORDER BY UnitPrice) AS rowNum

FROM

Products P

LEFT OUTER JOIN

Categories C

ON

(P.CategoryID = C.CategoryID)

GFT Group

06.11.2020

110

F U N K C J E   A N A L I T Y C Z N E
Funkcje rankingowe – NTILE

SELECT SupplierID,

CompanyName,

NTILE(4) OVER (

ORDER BY CompanyName)

AS Grp

FROM

Suppliers

GFT Group

06.11.2020

111

F U N K C J E   A N A L I T Y C Z N E
Zawężanie wyników w funkcjach analitycznych

SELECT SupplierID,

CompanyName,

NTILE(4) OVER (

ORDER BY CompanyName)

AS Grp

FROM

Suppliers

WHERE

Grp = 2

WHERE

NTILE(4) OVER (ORDER BY
CompanyName) = 2

GFT Group

06.11.2020

112

F U N K C J E   A N A L I T Y C Z N E
Zawężanie wyników w funkcjach analitycznych

SELECT

s.SupplierID,

WITH SuppliersGrp AS

s.CompanyName,

s.Grp

FROM (

SELECT

SupplierID,

CompanyName,

NTILE(4) OVER (

ORDER BY CompanyName)

AS Grp

FROM

Suppliers

) s

WHERE s.Grp = 2

(

)

SELECT

SupplierID,

CompanyName,

NTILE(4) OVER (

ORDER BY CompanyName)

AS Grp

FROM

Suppliers

SELECT

SupplierID,

CompanyName,

Grp

FROM

SuppliersGrp

WHERE

Grp = 2

GFT Group

06.11.2020

113

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu

▪ Funkcje rozkładu dostarczają informacji o rozkładzie danych

▪ Funkcje rozkładu rankingu:

▪ PERCENT_RANK
▪ CUME_DIST

▪ Powyższe funkcje służą do wyznaczania tzw. percentyli, czyli określenia na jakim miejscu (wyrażonym

procentowo) w uporządkowanym zbiorze znajduje się dana wartość.

▪ Funkcje rozkładu odwrotnego:

▪ PERCENTILE_CONT
▪ PERCENTILE_DISC

▪ Funkcje PERCENTIE_CONT oraz PERCENTILE_DISC służą do operacji odwrotnych niż 2 pierwsze

funkcje – wyznaczają wartość znajdującą się na określonej pozycji w uporządkowanym zbiorze

GFT Group

06.11.2020

114

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu - PERCENT_RANK & CUME_DIST

▪ Założenia:

▪ rk – pozycja wiersza wyrażona w rankingu RANK
▪ nr – liczba wierszy w partycji
▪ np – liczba wierszy zajmujących niższą lub tę samą pozycję co wiersz bieżący

▪ PERCEN𝑇_𝑅𝐴𝑁𝐾 =

▪ 𝐶𝑈𝑀𝐸_𝐷𝐼𝑆𝑇 =

𝑛𝑝

𝑛𝑟

𝑟𝑘−1

𝑛𝑟−1

▪ Funkcje zwracają wartości z zakresu (0;1> (PERCENT_RANK przyjmuje 0 dla pierwszego wiersza)

▪ PERCENT_RANK

– procent rekordów z rankingiem mniejszym niż bieżący

▪ CUME_DIST

– procent rekordów z rankingiem mniejszym bądź równym niż bieżący

GFT Group

06.11.2020

115

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu - PERCENT_RANK & CUME_DIST

WITH ProductsValue AS

(

)

SELECT

C.CategoryName, S.CompanyName,

SUM(P.UnitPrice * P.UnitsInStock) AS Value

FROM

JOIN

ON

JOIN

ON

Products P

Suppliers S

P.SupplierID = S.SupplierID

Categories C

C.CategoryID = P.CategoryID

GROUP BY

C.CategoryName, S.CompanyName

SELECT

CategoryName, CompanyName, Value,

RANK() OVER (PARTITION BY CategoryName

ORDER BY Value) AS Rank,

ROUND(PERCENT_RANK() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS PercentRank,

ROUND(CUME_DIST() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS CumeDist

FROM

ProductsValue

GFT Group

06.11.2020

116

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu - PERCENT_RANK & CUME_DIST

WITH ProductsValue AS

(

)

SELECT

C.CategoryName, S.CompanyName,

SUM(P.UnitPrice * P.UnitsInStock) AS Value

FROM

JOIN

ON

JOIN

ON

Products P

Suppliers S

P.SupplierID = S.SupplierID

Categories C

C.CategoryID = P.CategoryID

GROUP BY

C.CategoryName, S.CompanyName

SELECT

CategoryName, CompanyName, Value,

RANK() OVER (PARTITION BY CategoryName

ORDER BY Value) AS Rank,

ROUND(PERCENT_RANK() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS PercentRank,

ROUND(CUME_DIST() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS CumeDist

FROM

ProductsValue

GFT Group

06.11.2020

117

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu odwrotnego - PERCENTILE_CONT & PERCENTILE_DISC

▪ Funkcja PERCENTILE_DISC (model dyskretny) zwraca pierwszą wartość w grupie (uporządkowanym
zbiorze), dla której wartość funkcji CUME_DIST jest większa lub równa zadanej wartości wejściowej.

▪ Funkcja PERCENTILE_CONT działa podobnie do PERCENTILE_DISC z tym, że operuje na modelu
ciągłym, przez co jest trochę bardziej skomplikowana. Wartość wyznaczana jest poprzez liniową
interpolację wierszy otaczających wskazaną pozycję.

▪ Algorytm dla funkcji PERCENTILE_CONT (x):

▪ 𝑟𝑛 = (1 + 𝑥 ∗ 𝑛 − 1 ), gdzie 𝑛 jest liczbą wierszy w grupie, a 𝑟𝑛 numerem wiersza
▪ 𝑣𝑎𝑙𝑢𝑒(𝑟𝑛) – wartość wiersza 𝑟𝑛
▪ Jeżeli  𝑟𝑛 = 𝑟𝑛 , to 𝑃𝐸𝑅𝐶𝐸𝑇𝐼𝐿𝐸 𝐶𝑂𝑁𝑇 𝑥 = 𝑣𝑎𝑙𝑢𝑒 𝑟𝑛 , w przeciwnym wypadku:

𝑃𝐸𝑅𝐶𝐸𝑇𝐼𝐿𝐸 𝐶𝑂𝑁𝑇 𝑥 = 𝑟𝑛 − 𝑟𝑛 ∗ 𝑣𝑎𝑙𝑢𝑒 𝑟𝑛 + 𝑟𝑛 − 𝑟𝑛 ∗ 𝑣𝑎𝑙𝑢𝑒( 𝑟𝑛 )

GFT Group

06.11.2020

118

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu odwrotnego - PERCENTILE_CONT & PERCENTILE_DISC

WITH ProductsValue AS

(

)

SELECT

C.CategoryName, S.CompanyName,

SUM(P.UnitPrice * P.UnitsInStock) AS Value

FROM

JOIN

ON

JOIN

ON

Products P

Suppliers S

P.SupplierID = S.SupplierID

Categories C

C.CategoryID = P.CategoryID

GROUP BY

C.CategoryName, S.CompanyName

SELECT

CategoryName, CompanyName, Value,

ROUND(PERCENT_RANK() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS PercentRank,

ROUND(CUME_DIST() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS CumeDist,

PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY Value) OVER (

PARTITION BY CategoryName) AS PercDisc,

PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY Value) OVER (

PARTITION BY CategoryName) AS PercCont

FROM ProductsValue

GFT Group

06.11.2020

119

F U N K C J E   A N A L I T Y C Z N E
Funkcje rozkładu odwrotnego - PERCENTILE_CONT & PERCENTILE_DISC

WITH ProductsValue AS

(

)

SELECT

C.CategoryName, S.CompanyName,

SUM(P.UnitPrice * P.UnitsInStock) AS Value

FROM

JOIN

ON

JOIN

ON

Products P

Suppliers S

P.SupplierID = S.SupplierID

Categories C

C.CategoryID = P.CategoryID

GROUP BY

C.CategoryName, S.CompanyName

SELECT

CategoryName, CompanyName, Value,

ROUND(PERCENT_RANK() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS PercentRank,

ROUND(CUME_DIST() OVER (PARTITION BY CategoryName

ORDER BY Value),2) AS CumeDist,

PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY Value) OVER (

PARTITION BY CategoryName) AS PercDisc,

PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY Value) OVER (

PARTITION BY CategoryName) AS PercCont

FROM ProductsValue

GFT Group

06.11.2020

120

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia

▪ Funkcje przesunięcia w stosunku do bieżącego wiersza:

▪ LAG

▪ LEAD

▪ Funkcje przesunięcia względem początku i końca ramy okna:

▪ FIRST_VALUE

▪ LAST_VALUE

GFT Group

06.11.2020

121

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – LAG & LEAD

SELECT

OD.OrderID,

OD.ProductID,

O.OrderDate,

OD.UnitPrice*OD.Quantity AS Value,

LAG(OD.UnitPrice*OD.Quantity) OVER (

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS PrevValue,

LEAD(OD.UnitPrice*OD.Quantity) OVER (

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS NextValue

[Orders] O JOIN [Order Details] OD

(O.OrderID = OD.OrderID)

FROM

ON

GFT Group

06.11.2020

122

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – LAG & LEAD

SELECT

OD.OrderID,

OD.ProductID,

O.OrderDate,

OD.UnitPrice*OD.Quantity AS Value,

LAG(OD.UnitPrice*OD.Quantity, 2) OVER(

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS PrevValue,

LEAD(OD.UnitPrice*OD.Quantity, 2) OVER(

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS NextValue

[Orders] O JOIN [Order Details] OD

(O.OrderID = OD.OrderID)

FROM

ON

GFT Group

06.11.2020

123

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – LAG & LEAD

SELECT

OD.OrderID,

OD.ProductID,

O.OrderDate,

OD.UnitPrice*OD.Quantity AS Value,

LAG(OD.UnitPrice*OD.Quantity, 2, 0) OVER(

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS PrevValue,

LEAD(OD.UnitPrice*OD.Quantity, 2, 0) OVER(

PARTITION BY OD.ProductID

ORDER BY O.OrderDate)

AS NextValue

[Orders] O JOIN [Order Details] OD

(O.OrderID = OD.OrderID)

FROM

ON

GFT Group

06.11.2020

124

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – LAG & LEAD – obliczanie różnic

SELECT

OD.ProductID,

DATEPART(yyyy, O.OrderDate) AS

OrderYear,

SUM(UnitPrice*Quantity) AS Amount,

SUM(UnitPrice*Quantity) -

LAG(SUM(UnitPrice*Quantity), 1)

OVER (PARTITION BY OD.ProductID

ORDER BY DATEPART(yyyy,
O.OrderDate)) AS Diff

FROM

ON

[Orders] O JOIN [Order Details] OD

(O.OrderID = OD.OrderID)

GROUP BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)

GFT Group

06.11.2020

125

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – LAG & LEAD – obliczanie różnic

SELECT

OD.ProductID,

DATEPART(yyyy, O.OrderDate) AS

OrderYear,

SUM(UnitPrice*Quantity) AS Amount,

SUM(UnitPrice*Quantity) -

LAG(SUM(UnitPrice*Quantity), 1)

OVER (PARTITION BY OD.ProductID

ORDER BY DATEPART(yyyy,
O.OrderDate)) AS Diff

FROM

ON

[Orders] O JOIN [Order Details] OD

(O.OrderID = OD.OrderID)

GROUP BY OD.ProductID,

DATEPART(yyyy, O.OrderDate)

GFT Group

06.11.2020

126

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – FIRST_VALUE, LAST_VALUE

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

FIRST_VALUE(P.UnitPrice) OVER (

PARTITION BY

P.CategoryID

ORDER BY

P.UnitPrice

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS FirstValue,

LAST_VALUE(P.UnitPrice) OVER (

PARTITION BY

P.CategoryID

ORDER BY

P.UnitPrice

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) as LastValue

Products P LEFT OUTER JOIN Categories C

(P.CategoryID = C.CategoryID)

FROM

ON

GFT Group

06.11.2020

127

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – FIRST_VALUE, LAST_VALUE

SELECT

P.ProductName,

C.CategoryName,

P.UnitPrice,

FIRST_VALUE(P.UnitPrice) OVER (

PARTITION BY

P.CategoryID

ORDER BY

P.UnitPrice

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS FirstValue,

LAST_VALUE(P.UnitPrice) OVER (

PARTITION BY

P.CategoryID

ORDER BY

P.UnitPrice

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) as LastValue

Products P LEFT OUTER JOIN Categories C

(P.CategoryID = C.CategoryID)

FROM

ON

GFT Group

06.11.2020

128

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – FIRST_VALUE, LAST_VALUE

SELECT

O.OrderID,

C.CompanyName,

CAST(O.OrderDate AS date) AS OrderDate,

FIRST_VALUE(O.OrderID) OVER (

PARTITION BY

C.CustomerID

ORDER BY

O.OrderDate

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS FirstValue,

LAST_VALUE(O.OrderID) OVER (

PARTITION BY

C.CustomerID

ORDER BY

O.OrderDate

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS LastValue

FROM

ON

Orders O JOIN Customers C

O.CustomerID = C.CustomerID

GFT Group

06.11.2020

129

F U N K C J E   A N A L I T Y C Z N E
Funkcje przesunięcia – FIRST_VALUE, LAST_VALUE

SELECT

O.OrderID,

C.CompanyName,

CAST(O.OrderDate AS date) AS OrderDate,

FIRST_VALUE(O.OrderID) OVER (

PARTITION BY

C.CustomerID

ORDER BY

O.OrderDate

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS FirstValue,

LAST_VALUE(O.OrderID) OVER (

PARTITION BY

C.CustomerID

ORDER BY

O.OrderDate

ROWS BETWEEN 2 PRECEDING

AND 2 FOLLOWING) AS LastValue

FROM

ON

Orders O JOIN Customers C

O.CustomerID = C.CustomerID

GFT Group

06.11.2020

130

F U N K C J E   A N A L I T Y C Z N E
Podsumowanie

▪ Funkcje analityczne umożliwiają przeprowadzanie mniej

lub bardziej skomplikowanych analiz po

stronie bazy danych

▪ Funkcje analityczne pomagają między innymi w rozwiązywanie takich problemów jak:

▪ Stronicowanie
▪ Usuwanie powtarzających się danych
▪ Zwracanie n pierwszych wierszy dla każdej grupy
▪ Obliczanie sum bieżących
▪ Identyfikowanie luk i wysp
▪ Obliczania centyli
▪ Wyliczaniu wartości modalnej dla rozkładu
▪ …

GFT Group

06.11.2020

131

F U N K C J E   A N A L I T Y C Z N E
Podsumowanie

▪ Mogą być używane tylko w sekcjach: SELECT i ORDER BY

▪ Pamiętajmy o wartościach NULL

▪ Pamiętajmy o wydajności!

▪ Pamiętajmy o różnej nomenklaturze, która jest używana w odniesieniu do funkcji analitycznych/okna

GFT Group

06.11.2020

132

Funkcje użytkownika

F U N K C J E   U Ż Y T K O W N I K A
Funkcje użytkownika

▪ Funkcje użytkownika (user-defined functions) są to obiekty stworzone przez użytkownika, realizujące

pewną logikę i zwracające dane

▪ Funkcje mogą zwracać pojedynczą wartość danego typu (funkcje skalarne) lub tabelę (funkcje

tabelaryczne)

GFT Group

06.11.2020

134

F U N K C J E   U Ż Y T K O W N I K A
Funkcje użytkownika vs procedury składowane

Function (UDF – User Defined Function)

Stored Procedure (SP)

UDF zwraca jedynie jedną wartość – obowiązkowo! SP może zwrócić zero, pojedynczą lub wiele

wartości

Nie można używać transakcji

Można używać transakcji

Tylko parametry wejściowe

SP mogą posiadać parametry wejściowe oraz
wyjściowe

Nie można zawołać SP z funkcji

Można zawołać funkcję z SP

Funkcje można używać w poleceniach SELECT /
WHERE / HAVING

Nie można używać SP w poleceniach SELECT /
WHERE / HAVING

Nie można używać TRY…CATCH

Można używać TRY…CATCH

GFT Group

06.11.2020

135

F U N K C J E   U Ż Y T K O W N I K A
Funkcje użytkownika - zalety

▪ Pozwalają raz stworzony kod przechować w bazie danych i używać wielokrotnie

▪ Zwiększają czytelność kodu

▪ W niektórych przypadkach pozwalają zwiększyć wydajność przechowywanie planów zapytania

skompilowanych funkcji (podobnie jak w przypadku procedur składowanych)

▪ Pozwalają zrealizować zadania i obliczenia, które trudno lub niemożliwe jest do wykonania w czystym

SQL (T-SQL).

▪ Posiadają możliwość wywołań rekurencyjnych

▪ Pozwalają zmniejszyć ruch sieciowy

GFT Group

06.11.2020

136

F U N K C J E   U Ż Y T K O W N I K A
Funkcje użytkownika – niektóre ograniczenia

▪ Nie mogą modyfikować danych

▪ Nie mogą zwracać kilka zbiorów danych (result sets), w przeciwieństwie do procedur (w MS SQL!)

▪ Ograniczona obsługa błędów (nie wspierane TRY…CATCH, @ERROR, RAISERROR)

▪ Nie wolno używać dynamicznego SQL i tabel tymczasowych

▪ … -> https://msdn.microsoft.com/en-us/library/ms191320.aspx

GFT Group

06.11.2020

137

F U N K C J E   U Ż Y T K O W N I K A
Funkcje skalarne

IF OBJECT_ID (N'dbo.averageUnitPrice', N'FN') IS NOT NULL

DROP FUNCTION dbo.averageUnitPrice;

GO

CREATE FUNCTION dbo.averageUnitPrice(@CategoryID INT)

RETURNS MONEY

AS

BEGIN

DECLARE @avgUnitPrice MONEY;

SELECT @avgUnitPrice = AVG(p.UnitPrice)

FROM Products P

WHERE P.CategoryID = @CategoryID;

IF (@avgUnitPrice IS NULL)

SET @avgUnitPrice = 0;

RETURN @avgUnitPrice;

END;

GO

GFT Group

Kod odpowiedzialny za usuwanie funkcji przed
utworzeniem

Nagłówek funkcji, parametr, typ zwracany

Ciało funkcji

06.11.2020

138

F U N K C J E   U Ż Y T K O W N I K A
Funkcje skalarne – przykład użycia

SELECT ROUND(dbo.averageUnitPrice(1),2)

AS averageUnitPriceInCategory

SELECT

CategoryID,

ROUND (dbo.averageUnitPrice(CategoryID),2)

AS averageUnitPriceInCategory

FROM

Categories

GFT Group

06.11.2020

139

F U N K C J E   U Ż Y T K O W N I K A
Funkcje skalarne – rekurencja – liczymy silnię

SELECT dbo.factorial(5) AS Factorial

SELECT dbo.factorial(7) AS Factorial

CREATE FUNCTION dbo.factorial(@N INT)
RETURNS BIGINT
AS
BEGIN

DECLARE @ret BIGINT;

IF @N = 1

SELECT @ret = 1

ELSE

SELECT @ret =

@N * dbo.factorial(@N-1);

RETURN @ret;

END;

GFT Group

06.11.2020

140

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne

▪ Tabelaryczne funkcje użytkownika możemy podzielić na:

▪ Funkcje proste (inline)
▪ Funkcje złożone

▪ Tabelaryczne funkcje użytkownika często używane są z operatorem APPLY (więcej w następnym

rozdziale)

GFT Group

06.11.2020

141

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne – proste (inline)

IF OBJECT_ID (N'dbo.averageUnitPriceTab', N'IF') IS NOT NULL

DROP FUNCTION dbo.averageUnitPriceTab;

GO

CREATE FUNCTION dbo.averageUnitPriceTab(@CategoryID INT)

RETURNS TABLE

AS

RETURN (

SELECT ProductID,

@CategoryID AS CategoryID,

SupplierID,

AVG(p.UnitPrice) OVER (PARTITION BY SupplierID)

AS AverageUnitPrice

FROM  Products P

WHERE CategoryID = @CategoryID

)

GO

GFT Group

Kod odpowiedzialny za usuwanie funkcji
przed utworzeniem

Nagłówek funkcji, parametr, typ zwracany -
TABLE

Ciało funkcji zawierające jedno
zapytanie zawierające wynik funkcji

06.11.2020

142

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne – proste (inline)

SELECT ProductID, CategoryID, SupplierID, AverageUnitPrice

FROM

dbo.averageUnitPriceTab(4)

GFT Group

06.11.2020

143

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne – proste (inline)

SELECT T.ProductID, T.CategoryID, T.SupplierID, T.AverageUnitPrice, C.CategoryName

FROM

dbo.averageUnitPriceTab(4) T JOIN Categories C

ON     (T.CategoryID = C.CategoryID)

WHERE  AverageUnitPrice > 25

GFT Group

06.11.2020

144

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

IF OBJECT_ID (N'dbo.distinctRegionsAndCities', N'TF') IS NOT NULL

DROP FUNCTION dbo.distinctRegionsAndCities;

GO

CREATE FUNCTION dbo.distinctRegionsAndCities(@ProductID INT)

RETURNS @result TABLE

(

ProductID

INT,

Region

NVARCHAR(15),

City

NVARCHAR(15)

)

AS

BEGIN

INSERT INTO @result(ProductID, Region, City)

SELECT

DISTINCT OD.ProductID, O.ShipRegion, O.ShipCity

Kod odpowiedzialny za usuwanie funkcji przed
utworzeniem

Nagłówek funkcji, parametry, typ zwracany
- tabela

[Orders] O

[Order Details] OD ON (O.OrderID = OD.OrderID)

OD.ProductID = COALESCE(@ProductID, OD.ProductID);

Ciało funkcji

FROM

JOIN

WHERE

RETURN

END

GO

GFT Group

06.11.2020

145

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

SELECT ProductID, Region, City

FROM

dbo.distinctRegionsAndCities(4);

GFT Group

06.11.2020

146

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

SELECT ProductID, Region, City

FROM

dbo.distinctRegionsAndCities(NULL)

GFT Group

06.11.2020

147

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

SELECT

ProductID, Region, City

FROM

dbo.distinctRegionsAndCities(NULL)

ORDER BY City

GFT Group

06.11.2020

148

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

Czy można wyznaczyć unikalny region i miasto dla
każdego produktu z tabeli Products (wyświetlając również
dane z tabeli Products: ProductName)?

SELECT P.ProductName, F.City, F.Region

FROM

Products P

JOIN
dbo.distinctRegionsAndCities(NULL)) F

(SELECT ProductID, City, Region FROM

ON

F.ProductID = P.ProductID

Można, ale są lepsze sposoby
łączenia funkcji tabelarycznych z
innymi tabelami – operator APPLY

GFT Group

06.11.2020

149

F U N K C J E   U Ż Y T K O W N I K A
Funkcje tabelaryczne - złożone

GFT Group

06.11.2020

150

F U N K C J E   U Ż Y T K O W N I K A
Podsumowanie

▪ Funkcje użytkownika dzielą się na: skalarne i tabelaryczne (proste i złożone)

▪ W przedstawionej formie dotyczą jedynie bazy danych MS SQL Server

▪ Pozwalają zrealizować logikę, którą trudno zrealizować w samym SQL

▪ Mogą wpływać pozytywnie na wydajność

▪ Posiadają ograniczenia (patrz: dokumentacja)

GFT Group

06.11.2020

151

Operator APPLY

O P E R A T O R   A P P L Y
Operator APPLY

▪ Operator APPLY pozwala na połączenie dwóch wyrażeń tablicowych (table expressions).

▪ Wyrażenie tablicowe jest wywoływane dla każdego wiersza z lewej strony operatora.

▪ Posiada dwie formy: CROSS APPLY oraz OUTER APPLY

▪ CROSS APPLY – zwraca tylko wiersze z zewnętrznej tabeli (lewa strona) jeżeli istnieje odpowiednik w tabeli

wewnętrznej (prawa strona)

▪ OUTER APPLY – zwraca wszystkie rekordy z tabeli zewnętrznej (lewa strona) niezależnie czy istnieje odpowiednik w

tabeli wewnętrznej (prawa strona)

▪ Pozwala korelować zapytania

▪ Często używany w połączeniu z tabelarycznymi funkcjami użytkownika

GFT Group

06.11.2020

153

O P E R A T O R   A P P L Y
Operator APPLY – połączenie tabeli i funkcji

SELECT

P.ProductName, F.City, F.Region

SELECT

P.ProductName, F.City, F.Region

FROM

JOIN

Products P

FROM

Products P

(SELECT ProductID, City, Region FROM

CROSS APPLY

dbo.distinctRegionsAndCities(NULL)) F

dbo.distinctRegionsAndCities(

ON

F.ProductID = P.ProductID

P.ProductID) AS F

Jak można porównać czy jest taki sam rezultat?

GFT Group

06.11.2020

154

O P E R A T O R   A P P L Y
Operator APPLY – porównanie rezultatów

SELECT P.ProductName, F.City, F.Region

Products P

(SELECT ProductID, City, Region FROM dbo.distinctRegionsAndCities(NULL)) F

F.ProductID = P.ProductID

FROM

JOIN

ON

EXCEPT

SELECT P.ProductName, F.City, F.Region

FROM

Products P

CROSS APPLY dbo.distinctRegionsAndCities(P.ProductID) AS F

Wystarczające
sprawdzenie?

GFT Group

06.11.2020

155

O P E R A T O R   A P P L Y
Operator APPLY – porównanie rezultatów

(SELECT

P.ProductName, F.City, F.Region

FROM

JOIN

ON

EXCEPT

SELECT

FROM

Products P

(SELECT ProductID, City, Region FROM dbo.distinctRegionsAndCities(NULL)) F

F.ProductID = P.ProductID

P.ProductName, F.City, F.Region

Products P

CROSS APPLY dbo.distinctRegionsAndCities(P.ProductID) AS F)

UNION ALL

(SELECT

P.ProductName, F.City, F.Region

FROM

Products P

CROSS APPLY dbo.distinctRegionsAndCities(P.ProductID) AS F

P.ProductName, F.City, F.Region

Products P

(SELECT ProductID, City, Region FROM dbo.distinctRegionsAndCities(NULL)) F

F.ProductID = P.ProductID)

EXCEPT

SELECT

FROM

JOIN

ON

GFT Group

06.11.2020

156

O P E R A T O R   A P P L Y
Operator APPLY – połączenie dwóch tabel

JOIN:

APPLY:

SELECT P.ProductName, C.CategoryName

SELECT P.ProductName, C.CategoryName

FROM Products P LEFT OUTER JOIN
Categories C

ON P.CategoryID = C.CategoryID

FROM Products P

OUTER APPLY

(

) C

SELECT C2.CategoryName

FROM

Categories C2

WHERE C2.CategoryID =

P.CategoryID

GFT Group

06.11.2020

157

O P E R A T O R   A P P L Y
Operator APPLY – UNPIVOT przy wykorzystaniu APPLY?

▪ Mamy tabelę:

▪ Chcemy przekształcić i zaprezentować wynik w

postaci:

GFT Group

06.11.2020

158

O P E R A T O R   A P P L Y
Operator APPLY – UNPIVOT przy wykorzystaniu APPLY?

UNPIVOT:

CROSS APPLY:

SELECT ID, CustomerID, ProductCode,

Quantity

FROM

(

SELECT ID, CustomerID, ProductA,

ProductB, ProductC

FROM

SalesUnpivot) p

UNPIVOT

(Quantity FOR ProductCode IN (

ProductA,

ProductB, ProductC )) AS unpvt

SELECT S.ID, S.CustomerID,

C.ProductCode,C.Quantity

FROM

SalesUnpivot S

CROSS APPLY (VALUES

('ProductA',ProductA),

('ProductB', ProductB),

('ProductC', ProductC))

C (ProductCode, Quantity)

GFT Group

06.11.2020

159

O P E R A T O R   A P P L Y
Podsumowanie

▪ Operator APPLY pozwala na połączenie dwóch wyrażeń tablicowych (table expressions).

▪ W niektórych przypadkach jest wydajniejszy niż zwykły JOIN

GFT Group

06.11.2020

160

Co warto jeszcze
wiedzieć?

C O   W A R T O  J E S Z C Z E   W I E D Z I E Ć ?
Co warto jeszcze wiedzieć?

▪ Widoki, widoki zmaterializowane (widoki z indeksem klastrowym w SQL Server)

▪ Tabele tymczasowe

▪ Wyzwalacze (triggers)

▪ Sekwencery (sequences)

▪ Zarządzanie transakcjami

▪ Optymalizacja

GFT Group

06.11.2020

162

C O   W A R T O  J E S Z C Z E   W I E D Z I E Ć ?
Co warto jeszcze wiedzieć?

▪ Klauzula MODEL – Oracle

▪ T-SQL/PLSQL – kolekcje, instrukcje sterujące

▪ Dobre praktyki

▪ Obsługa błędów

▪ …

GFT Group

06.11.2020

163

B I L I O G R A F I A
Bibliografia i linki

▪ Itzik Ben-Gan, Microsoft SQL Server 2012. Optymalizacja kwerend T-SQL przy użyciu funkcji okna

▪ Materiały wykładowe dot. baz danych (funkcje analityczne) z Politechniki Poznańskiej

▪ Linki:

▪ http://dba-presents.com/index.php/databases/sql-server/36-order-by-and-nulls-last-in-sql-server
▪ http://www.sqlpedia.pl/
▪ https://mndevnotes.wordpress.com/2012/10/03/grupowanie-danych-przy-uzyciu-polecen-rollup-cube-oraz-grouping-

sets/

▪ https://edu.pjwstk.edu.pl/
▪ https://msdn.microsoft.com
▪ https://oracle-base.com/articles/misc/rollup-cube-grouping-functions-and-grouping-sets
▪ https://technet.microsoft.com
▪ https://oracle-base.com/articles/11g/pivot-and-unpivot-operators-11gr1
▪ https://explainextended.com/2009/07/16/inner-join-vs-cross-apply/
▪ http://stackoverflow.com/questions/1179758/function-vs-stored-procedure-in-sql-server

GFT Group

06.11.2020

164

Dziękuję za uwagę

Arkadiusz Kasprzak

akasprzak@wmi.amu.edu.pl

Copyright © Arkadiusz Kasprzak. All rights reserved.

