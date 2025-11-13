PRZETWARZANIE DANYCH – BIG DATA 

**Zaawansowany**    
**SQL** 

Arkadiusz Kasprzak 

07.11.2020 

Copyright © Arkadiusz Kasprzak. All rights reserved.  
AGENDA 

1\. Sprawy organizacyjne 

2\. Podstawy SQL – krótkie przypomnienie 3\. Funkcje grupowania i agregacji 4\. Common Table Expression (CTE) 5\. Funkcje analityczne 

6\. Funkcje użytkownika 

7\. Operator APPLY 

8\. Co jeszcze warto wiedzieć…  
Type here if add info needed for every slide **GFT Group: 5700 experts in 15 countries** 

Switzerland (45) 

Basel   
Zurich 

Belgium (10) 

Brussels 

France (25) 

Niort   
Paris   
Germany (450) 

Bonn   
Eschborn/Frankfurt Karlsruhe   
St. Georgen   
Stuttgart 

Italy (710) 

Florence   
Genoa   
Canada (260) 

Toronto   
Quebec  

USA (55) 

Boston   
New York 

Mexico (300) Mexico City 

Costa Rica (110) Heredia 

Brazil (890) 

Alphaville   
Curitiba    
Sorocaba 

UK (190) London 

**Poland (800)** 

**Lodz**   
**Poznan**   
**Warsaw**   
**Cracow** 

Spain (1975) 

Alicante   
Barcelona   
Lleida   
Madrid   
Valencia   
Zaragoza 

Milano   
Montecatini Terme Padova   
Piacenza   
Siena   
Torino 

China (5) 

Hongkong 

Singapore (5) 

Singapore

Locations   
Numbers include employees (FTE) and external staff Nearshore locations 

GFT Group 06.11.2020 3 **06/11/2020**   
W PROWADZENIE  
**Arkadiusz Kasprzak – o mnie** 

▪ Head of Data Poland w GFT 

▪ Ponad 10 lat doświadczenia w IT 

▪ Autor bloga o przetwarzaniu danych: https://oceandanych.pl ▪ Współtwórca GDG Cloud Poznań 

▪ Namiary na mnie: 

▪ akasprzak@wmi.amu.edu.pl / arek@oceandanych.pl ▪ LinkedIn 

GFT Group 06.11.2020 4   
SPRAW Y ORGANIZACYJNE  
**Sprawy organizacyjne** 

▪ Warunki zaliczenia 

▪ 4.0 – x\*0.5 \= ocena, gdzie x – liczba nieobecności (dla x=1,2) 

▪ Przy \>=3 nieobecnościach \- ndst 

▪ Aktywność na wykładach i/lub laboratoriach \+1.0 

▪ Korzystamy z bazy Northwind – skrypty na MS Teams w katalogu Baza danych ▪ Ankieta 

GFT Group 06.11.2020 5   
SPRAW Y ORGANIZACYJNE  
**Zasady pracy na zajęciach** 

▪ Wypracujmy kontrakt. Moja propozycja: 

▪ Włączone kamery 

▪ Wyciszone mikrofony 

▪ Zasada Vegas 

▪ Nie nagrywamy wykładów 

▪ Materiały zostały udostępnione\* 

▪ Nie oszukujemy z obecnością 

▪ Zwracamy się do siebie formalnie czy nie? 

GFT Group 06.11.2020 6   
Podstawy SQL – krótkie przypomnienie  
PODSTAW Y SQL   
**Pojęcia związane z przetwarzaniem zapytań SQL \- teoria** Pojęcia związane z przetwarzaniem zapytań SQL:   
▪ Selekcja – wybór odpowiednich wierszy ▪ Projekcja – wybór odpowiednich kolumn  

WHERE SELECT 

▪ Złączenie – operacja pozwalająca pobrać dane z wielu tabel   
JOIN 

▪ Operatory algebraiczne – suma, różnica…   
UNION, UNION ALL, EXCEPT, INTERSECT 

▪ Agregacja – agregacja danych przy użyciu dostępnych funkcji agregujących 

MIN, MAX, SUM, …

GFT Group 06.11.2020 8   
PODSTAW Y SQL   
**Pojęcia związane z przetwarzaniem zapytań SQL \- praktyka** 5\. Określenie wyniku zapytania – kolumny,    
SELECT 

FROM … JOIN … WHERE 

GROUP BY 

HAVING 

ORDER BY   
transformacje itp..

1\. Określenie obiektów źródłowych i relacji między    
nimi 

2\. Określenie warunków w celu odfiltrowania  

odpowiednich rekordów 

3\. Grupowanie rekordów (agregacja) 

4\. Określenie warunków w celu odfiltrowania    
odpowiednich grup 

6\. Sortowanie wyniku 

GFT Group 06.11.2020 9   
PODSTAW Y SQL  
**Klauzula WHERE** 

▪ Klauzula **WHERE** umożliwia odfiltrowanie rekordów za pomocą warunku lub kilka warunków  połączonych operatorami logicznymi 

▪ Operatory logiczne: **AND**, **OR** 

▪ Operatory porównania: **\=, \!= , \<\>, \<, \>, LIKE, IN**… 

GFT Group 06.11.2020 10   
PODSTAW Y SQL   
**Klauzula WHERE**

SELECT OrderID, CustomerID, ShipName, … SELECT \* 

FROM Orders 

WHERE DATEPART(YEAR, OrderDate) \> 1997 

GFT Group 06.11.2020 11   
PODSTAW Y SQL  
**Złączenia \- JOINs** 

▪ Rodzaje złączeń: 

▪ Połączenia wewnętrzne – **INNER JOIN** 

▪ Połączenia zewnętrzne – **OUTER JOIN**: ▪ LEFT \[OUTER\] JOIN 

▪ RIGHT \[OUTER\] JOIN 

▪ FULL \[OUTER\] JOIN 

▪ Iloczyn kartezjański \- **CROSS JOIN** 

GFT Group 06.11.2020 12   
PODSTAW Y SQL  
**Złączenia \- JOINs** 

**![][image1]**  
GFT Group 06.11.2020 13   
PODSTAW Y SQL  
**Funkcje grupowania i agregacji** 

▪ Funkcje agregacji służą do wykonywania kalkulacji na zbiorze danych i zwracają pojedynczą wartość 

▪ Za pomocą klauzuli **GROUP BY** możemy grupować rekordy i na każdej z grup przeprowadzić  kalkulację. Grupy są wyznaczane unikalne wartości atrybutów podanych w **GROUP BY** 

GFT Group 06.11.2020 14   
PODSTAW Y SQL   
**Funkcje agregujące – krótkie przypomnienie** 

SELECT COUNT(\*) AS CNT1, COUNT(1) AS CNT2, COUNT(id) AS CNT3, 

COUNT(testValue) AS CNT4  

FROM TestAggr; 

![][image2]  
![][image3]![][image4]  
SELECT AVG(id) AS AVG FROM TestAggr; 

SELECT AVG(CAST(id as DECIMAL(10,2))) AS AVG 

FROM TestAggr;

![][image5]

GFT Group 06.11.2020 15   
PODSTAW Y SQL   
**Funkcje agregujące – krótkie przypomnienie** 

SELECT ISNULL(MAX(id),0)+1 AS ID  

FROM EmptyTable; 

SELECT id, value  

FROM NotEmptyTable

![][image6]

SELECT ISNULL(MAX(id),0)+1 AS ID  

FROM NotEmptyTable 

WHERE value \= 'NonExistingValue'; 

SELECT MAX(ISNULL(id,0))+1 AS ID  FROM EmptyTable; 

![][image7]

SELECT MAX(ISNULL(id,0))+1 AS ID  FROM NotEmptyTable 

WHERE value \= 'NonExistingValue'; 

![][image8]![][image9]

GFT Group 06.11.2020 16   
PODSTAW Y SQL  
**GROUP BY – krótkie przypomnienie** 

Zadanie: 

Korzystając z tabeli ***Orders*** wyświetl wszystkie identyfikatory klientów (wraz z liczbą dokonanych przez nich zamówień), którzy dokonali co najmniej 10-ciu zamówień pomiędzy majem 1997 a czerwcem 1998 (***OrderDate** \[datetime\]*). Wyniki posortuj malejąco zgodnie z liczbą zamówień. 

SELECT CustomerID, COUNT(\*) AS CNT 

FROM Orders 

WHERE (DATEPART(YEAR, OrderDate)\*100 

\+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806 GROUP BY CustomerID 

HAVING CNT \> 10 

HAVING COUNT(\*) \> 10 

ORDER BY CNT DESC; 

GFT Group 06.11.2020 17   
PODSTAW Y SQL  
**GROUP BY – krótkie przypomnienie** 

Zadanie: 

Korzystając z tabeli ***Customers*** rozbuduj i zaktualizuj poprzednie zapytanie tak, aby zamiast identyfikatora klienta wyświetlała się jego nazwa (***Customers.CompanyName** \[nvarchar\]*). 

SELECT C.CompanyName, COUNT(\*) AS CNT  

FROM Orders O JOIN Customers C  

ON (O.CustomerID \= C.CustomerID) 

WHERE (DATEPART(YEAR, OrderDate)\*100 

\+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806 

GROUP BY C.CompanyName 

HAVING COUNT(\*) \> 10  

ORDER BY CNT DESC; 

GFT Group 06.11.2020 18   
PODSTAW Y SQL  
**Common Table Expression – krótkie przypomnienie** 

▪ **CTE** to zapytanie reprezentujące tymczasowy zestaw rekordów 

▪ Po konstrukcji **WITH** należy użyć jednego z poleceń **SELECT, INSERT UPDATE** lub **DELETE** 

▪ Można definiować więcej niż jedno **CTE** w ramach polecenia **WITH**, natomiast nie można definiować kolejnej klauzuli **WITH** w ramach **CTE** 

▪ Można definiować wiele zapytań **CTE** nierekursywnie, korzystając z operatów: **UNION, UNION ALL, INTERSECT lub EXCEPT** 

▪ W zapytaniu głównym można wielokrotnie odwoływać się do **CTE** 

GFT Group 06.11.2020 19   
PODSTAW Y SQL  
**Common Table Expression – krótkie przypomnienie** 

▪ W konstrukcji **CTE** nie można używać poleceń: 

▪ ORDER BY (z wyjątkiem gdy klauzula TOP jest podana) 

▪ INTO 

▪ OPTION 

▪ FOR BROWSE 

▪ … \-\> dokumentacja: https://msdn.microsoft.com/pl-pl/library/ms175972(v=sql.110).aspx 

▪ Składnia: 

GFT Group 06.11.2020 20   
PODSTAW Y SQL   
**CTE \- przykład**

WITH 

ProdAvgUnitPrice (AvgUnitPrice) 

AS 

( 

SELECT AVG(UnitPrice) 

FROM Products 

), 

GreaterThanAvg (ProductName, CategoryID, UnitPrice) 

AS 

( 

SELECT ProductName, CategoryID, UnitPrice 

FROM Products P  

WHERE UnitPrice \> (SELECT AvgUnitPrice FROM ProdAvgUnitPrice) ) 

SELECT G.ProductName, C.CategoryName, G.UnitPrice 

FROM GreaterThanAvg G JOIN Categories C  

ON (C.CategoryID \= G.CategoryID); 

GFT Group 06.11.2020 21   
PODSTAW Y SQL  
**Podzapytania** 

▪ Podzapytania mogą być: 

▪ **skorelowane** oraz **nieskorelowane** 

▪ Podzapytania mogą zwracać: 

▪ Pojedynczą wartość: zapytania **skalarne** 

▪ Listę wartości 

▪ Dane tabelaryczne 

▪ Przy zapytaniach skalarnych możemy używać do porównania operatorów \=, \<, \>, \<\>, \!=… ▪ Przy zapytaniach zwracających więcej wartości musimy użyć dodatkowo jednego z operatorów: ▪ **ALL**   
▪ **ANY (SOME)** 

GFT Group 06.11.2020 22   
PODSTAW Y SQL   
**Podzapytania \- przykłady**

SELECT COUNT(1) AS CNT 

FROM Products 

WHERE UnitPrice \> 

(SELECT AVG(UnitPrice) FROM Products) 

SELECT p1.ProductName, p1.CategoryID 

FROM Products p1 

WHERE UnitPrice \= 

(SELECT MAX(p2.UnitPrice) FROM Products p2  WHERE p1.CategoryID \= p2.CategoryID) 

GFT Group 06.11.2020 23   
PODSTAW Y SQL   
**Podzapytania \- przykłady**

SELECT p1.ProductName, p1.CategoryID 

FROM Products p1 

WHERE UnitPrice \> ALL 

(SELECT AVG(p2.UnitPrice) FROM Products p2 WHERE p1.CategoryID \!= 

p2.CategoryID  

GROUP BY p2.CategoryID) 

GFT Group 06.11.2020 24   
PODSTAW Y SQL   
**Podzapytania \- przykłady**

SELECT ProductName, (SELECT CategoryName FROM Categories c  

WHERE c.CategoryID \= 

p.CategoryID) 

AS CategoryName 

FROM Products p 

GFT Group 06.11.2020 25   
PODSTAW Y SQL   
**Podzapytania \- przykłady**

SELECT ProductName, CategoryID, 

(SELECT MAX(UnitPrice) FROM Products) AS MaxUnitPrice 

FROM Products 

WHERE CategoryID \!= 1 

SELECT MAX(UnitPrice) 

AS MaxUnitPricePerCategory, 

CategoryID 

FROM Products 

GROUP BY CategoryID 

GFT Group 06.11.2020 26   
PODSTAW Y SQL  
**Podzapytania – EXISTS vs. IN** 

▪ Operator **\[NOT\] EXISTS** jest używany aby zweryfikować czy istnieje jakiś rekord w podzapytaniu ▪ Operator **\[NOT\] IN** pozwala wyspecyfikować wiele wartości w klauzuli WHERE (wpisanych ręcznie lub też poprzez zapytanie) 

SELECT COUNT(1) AS CNT 

FROM Products 

WHERE CategoryID IN (1,3) 

SELECT COUNT(1) AS CNT 

FROM Products 

WHERE CategoryID IN ( 

SELECT CategoryID 

FROM Products P 

JOIN Suppliers S ON (P.SupplierID \= S.SupplierID) 

WHERE S.Country \= 'UK' 

) 

GFT Group 06.11.2020 27   
PODSTAW Y SQL   
**Podzapytania – EXISTS vs. IN** 

SELECT COUNT(\*) AS CNT 

FROM Orders 

WHERE ShipRegion IN 

(SELECT ShipRegion 

FROM Orders 

WHERE CustomerID \= 'HANAR') 

SELECT COUNT(\*) AS CNT 

FROM Orders O 

WHERE EXISTS ( 

SELECT 1 

FROM Orders P 

WHERE P.CustomerID \= 

'HANAR’ 

AND O.ShipRegion \= 

P.ShipRegion) 

**NOT EXISTS \= NOT IN**

GFT Group 06.11.2020 28   
PODSTAW Y SQL  
**Logika trójwartościowa** 

| p  True  | q  True | p AND q  | p OR q  | p \= q  | NOT p |
| :---: | :---: | ----- | ----- | ----- | ----- |
| True  | False |  |  |  |  |
| True  | Unknown |  |  |  |  |
| False  | True |  |  |  |  |
| False  | False |  |  |  |  |
| False  | Unknown |  |  |  |  |
| Unknown  | True |  |  |  |  |
| Unknown  | False |  |  |  |  |
| Unknown  | Unknown |  |  |  |  |

GFT Group 06.11.2020 29   
PODSTAW Y SQL  
**Logika trójwartościowa** 

| p  True  | q  True  | p AND q  True  | p OR q  True  | p \= q  True  | NOT p  False |
| :---: | :---: | ----- | ----- | ----- | ----- |
| True  | False  | **False**  | **True**  | **False**  | **False** |
| True  | Unknown  |  |  |  | **False** |
| False  | True  | **False**  | **True**  | **False**  | **True** |
| False  | False  | **False**  | **False**  | **True**  | **True** |
| False  | Unknown  |  |  |  | **True** |
| Unknown  | True |  |  |  |  |
| Unknown  | False |  |  |  |  |
| Unknown  | Unknown |  |  |  |  |

GFT Group 06.11.2020 30   
PODSTAW Y SQL  
**Logika trójwartościowa** 

| p  True  | q  True  | p AND q  True  | p OR q  True  | p \= q  True  | NOT p  False |
| :---: | :---: | ----- | ----- | ----- | ----- |
| True  | False  | **False**  | **True**  | **False**  | **False** |
| True  | Unknown  | **Unknown**  | **True**  | **Unknown**  | **False** |
| False  | True  | **False**  | **True**  | **False**  | **True** |
| False  | False  | **False**  | **False**  | **True**  | **True** |
| False  | Unknown  |  |  |  | **True** |
| Unknown  | True  | **Unknown**  | **True**  | **Unknown** |  |
| Unknown  | False |  |  |  |  |
| Unknown  | Unknown |  |  |  |  |

GFT Group 06.11.2020 31   
PODSTAW Y SQL  
**Logika trójwartościowa** 

| p  True  | q  True  | p AND q  True  | p OR q  True  | p \= q  True  | NOT p  False |
| :---: | :---: | ----- | ----- | ----- | ----- |
| True  | False  | **False**  | **True**  | **False**  | **False** |
| True  | Unknown  | **Unknown**  | **True**  | **Unknown**  | **False** |
| False  | True  | **False**  | **True**  | **False**  | **True** |
| False  | False  | **False**  | **False**  | **True**  | **True** |
| False  | Unknown  | **False**  | **Unknown**  | **Unknown**  | **True** |
| Unknown  | True  | **Unknown**  | **True**  | **Unknown** |  |
| Unknown  | False  | **False**  | **Unknown**  | **Unknown** |  |
| Unknown  | Unknown |  |  |  |  |

GFT Group 06.11.2020 32   
PODSTAW Y SQL  
**Logika trójwartościowa** 

| p  True  | q  True  | p AND q  True  | p OR q  True  | p \= q  True  | NOT p  False |
| :---: | :---: | :---: | :---: | :---: | :---: |
| True  | False  | **False**  | **True**  | **False**  | **False** |
| True  | Unknown  | **Unknown**  | **True**  | **Unknown**  | **False** |
| False  | True  | **False**  | **True**  | **False**  | **True** |
| False  | False  | **False**  | **False**  | **True**  | **True** |
| False  | Unknown  | **False**  | **Unknown**  | **Unknown**  | **True** |
| Unknown  | True  | **Unknown**  | **True**  | **Unknown**  | **Unknown** |
| Unknown  | False  | **False**  | **Unknown**  | **Unknown**  | **Unknown** |
| Unknown  | Unknown  | **Unknown**  | **Unknown**  | **Unknown**  | **Unknown** |

GFT Group 06.11.2020 33   
PODSTAW Y SQL   
**Operatory na zbiorach** 

**INTERSECT UNION UNION ALL**   
**MINUS EXCEPT**

GFT Group 06.11.2020 34   
PODSTAW Y SQL  
**CASE** 

GFT Group 06.11.2020 35   
PODSTAW Y SQL   
**CASE \- przykłady**

SELECT C.CategoryName, 

COUNT(\*) AS NumberOfProducts, 

CASE 

WHEN COUNT(\*) \> 10 THEN 

'High' 

WHEN COUNT(\*) BETWEEN 6 AND 

10 THEN 'Average' 

ELSE 'Low' 

END AS Level 

FROM Products P JOIN Categories C ON P.CategoryID \= C.CategoryID GROUP BY C.CategoryID, C.CategoryName 

GFT Group 06.11.2020 36   
PODSTAW Y SQL   
**CASE \- przykład**

WITH NumberOfProductsInCategory AS 

( 

SELECT C.CategoryName, 

COUNT(\*) AS NumberOfProducts 

FROM Products P JOIN Categories C 

ON P.CategoryID \= C.CategoryID 

GROUP BY C.CategoryID, C.CategoryName 

) 

SELECT CategoryName, 

NumberOfProducts, 

CASE NumberOfProducts 

WHEN (SELECT MAX(NumberOfProducts) 

FROM NumberOfProductsInCategory ) 

THEN 'Best' 

WHEN (SELECT MIN(NumberOfProducts) 

FROM NumberOfProductsInCategory ) 

THEN 'Worst' 

ELSE 'Not too bad' 

END AS Level 

FROM NumberOfProductsInCategory; 

GFT Group 06.11.2020 37   
PODSTAW Y SQL   
**Przykładowe funkcje/polecenia** 

▪ ISNULL 

▪ COALESCE 

▪ DISTINCT 

▪ DATEPART / YEAR / MONTH / DAY / DATEADD ▪ …

GFT Group 06.11.2020 38   
Funkcje grupowania  i agregacji  
PODSTAW Y SQL  
**GROUP BY – krótkie przypomnienie** 

Zadanie: 

Korzystając z tabeli ***Orders*** wyświetl wszystkie identyfikatory klientów (wraz z liczbą dokonanych przez nich zamówień), którzy dokonali co najmniej 10-ciu zamówień pomiędzy majem 1997 a czerwcem 1998 (***OrderDate** \[datetime\]*). Wyniki posortuj malejąco zgodnie z liczbą zamówień. 

SELECT CustomerID, COUNT(\*) AS CNT 

FROM Orders 

WHERE (DATEPART(YEAR, OrderDate)\*100 

\+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806 GROUP BY CustomerID 

HAVING CNT \> 10 

HAVING COUNT(\*) \> 10 

ORDER BY CNT DESC; 

GFT Group 06.11.2020 40   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**GROUP BY – krótkie przypomnienie** 

Zadanie: 

Korzystając z tabeli ***Customers*** rozbuduj i zaktualizuj poprzednie zapytanie tak, aby zamiast identyfikatora klienta wyświetlała się jego nazwa (***Customers.CompanyName** \[nvarchar\]*). 

SELECT C.CompanyName, COUNT(\*) AS CNT  

FROM Orders O JOIN Customers C  

ON (O.CustomerID \= C.CustomerID) 

WHERE (DATEPART(YEAR, OrderDate)\*100 

\+DATEPART(MM, OrderDate)) BETWEEN 199705 AND 199806 

GROUP BY C.CompanyName 

HAVING COUNT(\*) \> 10  

ORDER BY CNT DESC; 

GFT Group 06.11.2020 41   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**Zadanie**

Zadanie: 

Korzystając z tabeli ***Orders*** zaprojektuj zapytanie przedstawiające sumaryczną 

liczbą zamówień w roku 1997 (***OrderDate** \[datetime\]*) dla poszczególnych państw 

(***ShipCountry** \[nvarchar\]*), i miast (***ShipCity** \[nvarchar\]*), samych państw oraz 

całościowe podsumowanie. Wynik posortuj rosnąco tak, aby w pierwszej kolejności 

były prezentowane wyniki dla danego kraju i miast, następnie tylko dla danego 

kraju \- podsumowanie jako ostatnia pozycja. 

GFT Group 06.11.2020 42   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP** 

▪ **ROLLUP** jest rozwinięciem polecenia GROUP BY, które pozwala wyliczyć dodatkowe podsumowania częściowe i ogólne dla podgrup generowanych „od prawej do lewej” 

▪ Zapytanie: 

SELECT   
...   
GROUP BY ROLLUP (a,b,c) 

Wygeneruje grupowania: 

(a,b,c) 

(a,b) 

(a) 

() 

Rekord agregujący cały zbiór 

Wykonane zostaną grupowania: 

• GROUP BY a,b,c 

• GROUP BY a,b 

• GROUP BY a 

• GROUP BY () 

Co jest tożsame z brakiem    
grupowania N+1 grupowań

GFT Group 06.11.2020 43   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP** 

▪ Czy możemy ten sam efekt uzyskać nie korzystając z polecenia ROLLUP? 

SELECT 1 as Level, NULL as colA, NULL as colB, NULL as colC, COUNT(...) ... 

UNION ALL 

SELECT 2, a, NULL, NULL, COUNT(...) ... 

GROUP BY a 

UNION ALL 

SELECT 3, a, b, NULL, COUNT(...) ... 

GROUP BY a, b 

UNION ALL 

SELECT 4, a, b, c, COUNT(...) ... 

GROUP BY a, b, c 

Odp.: Tak, ale po co? ☺ 

**ROLLUP** jest znacząco  bardziej wydajny

GFT Group 06.11.2020 44   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP – przykład**

Bez ROLLUP: 

SELECT s.\* FROM ( 

SELECT ShipCountry, ShipCity, COUNT(OrderID) as CNT FROM Orders 

WHERE DATEPART(yyyy, OrderDate) \= 1997 

GROUP BY ShipCountry, ShipCity 

UNION ALL 

SELECT ShipCountry, NULL , COUNT(OrderID) as CNT FROM Orders 

WHERE DATEPART(yyyy, OrderDate) \= 1997 

GROUP BY ShipCountry 

UNION ALL 

SELECT NULL, NULL, COUNT(OrderID) as CNT 

FROM Orders 

WHERE DATEPART(yyyy, OrderDate) \= 1997) s 

ORDER BY CASE WHEN ShipCountry IS NULL THEN 1 ELSE 0 END ASC, ShipCountry ASC, CASE WHEN ShipCity IS NULL THEN 1 ELSE 0 END ASC, ShipCity ASC 

ROLLUP: 

SELECT ShipCountry, ShipCity, COUNT(OrderID) as CNT FROM Orders 

WHERE DATEPART(yyyy, OrderDate) \= 1997 

GROUP BY ROLLUP (ShipCountry, ShipCity) 

ORDER BY CASE WHEN ShipCountry IS NULL THEN 1 ELSE 0 END ASC, ShipCountry ASC, 

CASE WHEN ShipCity IS NULL THEN 1 ELSE 0 END ASC, ShipCity ASC 

GFT Group 06.11.2020 45   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**ROLLUP – plany zapytań** 

GFT Group 06.11.2020 46   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**ROLLUP – przykłady grupowań** 

▪ Przykłady (źródło: *https://technet.microsoft.com/pl-pl/library/bb522495(v=sql.105).aspx*): 

GFT Group 06.11.2020 47   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**ROLLUP – przykłady grupowań** 

GFT Group 06.11.2020 48   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**CUBE** 

▪ Polecenie **CUBE** działa w podobny sposób do polecenia **ROLLUP**, z tą różnicą, iż przy tworzeniu poszczególnych grupowań uwzględniane są wszystkie kombinacje wskazanych kolumn. 

▪ Zapytanie 

Wykonane zostaną grupowania: 

SELECT   
...   
GROUP BY CUBE (a,b,c) Wygeneruje grupowania: 

(a, b, c) 

(a, b) 

(a, c) 

(a) 

(b, c) 

(b) 

(c) 

()   
• GROUP BY a,b,c 

• GROUP BY a,b 

• GROUP BY a,c 

• GROUP BY a 

• GROUP BY b,c 

• GROUP BY b 

• GROUP BY c 

• GROUP BY () 

2^N grupowań

GFT Group 06.11.2020 49   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**CUBE – przykłady grupowań** 

GFT Group 06.11.2020 50   
FUNKCJE GRUPOW ANIA I AGREGACJI **CUBE – zadanie** 

Zadanie 

? 

Korzystając z tabeli ***Orders*** oraz ***Customers*** przedstaw pełną analizę przedstawiającą liczbą zamówień w 3 wymiarach: rok (***Orders.OrderDate** \[datetime\]*), kraj oraz miasto zamieszkania klienta (***Customers.Country** \[nvarchar\]*, ***Customers.City** \[nvarchar\]*). Wyświetl dane dla liczby zamówień większej od 15\. 

SELECT DATEPART(yyyy,O.OrderDate) as Year, C.Country, C.City, COUNT(\*) as NumberOfOrders 

FROM Orders O JOIN Customers C  

ON (O.CustomerID \= C.CustomerID) 

GROUP BY CUBE(DATEPART(yyyy,O.OrderDate), 

C.Country, 

C.City) 

HAVING COUNT(\*) \> 15 

ORDER BY NumberOfOrders DESC;

GFT Group 06.11.2020 51   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP & CUBE – kolumny złożone**

SELECT 

... 

GROUP BY ROLLUP ((a, b), c) 

(a, b, c) 

(a, b) 

() 

Brak: 

(a) 

SELECT 

... 

GROUP BY CUBE ((a, b), c) 

(a, b, c) 

(a, b) 

(c) 

() 

Brak: 

(a, c) 

(a) 

(b, c) 

(b) 

GFT Group 06.11.2020 52   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP & CUBE – redukcja grup**

SELECT 

... 

GROUP BY a, ROLLUP (b, c, d) 

(a, b, c, d) 

(a, b, c) 

(a, b) 

(a) 

SELECT 

... 

GROUP BY a, CUBE (b, c, d) 

(a, b, c, d) 

(a, b, c) 

(a, b, d) 

(a, b) 

(a, c, d) 

(a, c) 

(a, d) 

(a) 

GFT Group 06.11.2020 53   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**GROUPING SETS** 

▪ Polecenie **GROUPING SETS** pozwala określić konkretne poziomy grupowania: ▪ Poszczególne grupy wymieniamy po przecinku. 

▪ Grupy złożone z kilku kolumn ujmujemy w nawiasy () 

▪ Za pomocą **GROUPING SETS** możemy opisać podzbiory tworzone przez CUBE i ROLLUP: ROLLUP(ShipCountry, ShipCity) \<=\> GROUPING SETS((ShipCountry, ShipCity), (ShipCountry), ()) 

▪ Jest to np. pomocne, gdy chcemy zrezygnować, z niektórych poziomów grupowania wymuszonych przez ROLLUP  i/lub CUBE 

▪ **GROUPING SETS** może być użyte razem z poleceniami ROLLUP i CUBE w klauzuli GROUP BY: np.: GROUP BY ROLLUP (DATEPART(yyyy, OrderDate), 

DATEPART(qq, OrderDate)), 

GROUPING SETS( (ShipCountry, ShipCity), 

(ShipCountry)) 

GFT Group 06.11.2020 54   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**ROLLUP/CUBE/GROUPING SETS \- potencjalnie problemy?**

Zadanie: 

Korzystając z tabeli ***Orders*** zaprojektuj zapytanie przedstawiające sumaryczną liczbą zamówień dla poszczególnych państw (***ShipCountry** \[nvarchar\]*), regionów (***ShipRegion** \[nvarchar\]*) oraz miast (***ShipCity** \[nvarchar\]*) wraz z pośrednimi oraz pełnym podsumowaniem (ROLLUP). 

SELECT ShipCountry, ShipRegion, ShipCity, 

COUNT(OrderID) as NumberOfOrders 

FROM Orders 

GROUP BY ROLLUP (ShipCountry, ShipRegion, ShipCity) 

GFT Group 06.11.2020 55   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**GROUPING** 

▪ **GROUPING** jest funkcją wskazującą czy dana kolumna/wyrażenie jest agregowane 

▪ Składnia: 

**GROUPING** ( kolumna/wyrażenie ) 

▪ Zwracane wartości \[tinyint\]: 

▪ 1 – kolumna/wyrażenie jest agregacją 

▪ 0 – w przeciwnym razie 

▪ Funkcja **GROUPING** może być użyta jedynie w poleceniu **SELECT**, **HAVING** oraz **ORDER BY** (zakładając, że użyto polecenia grupującego **GROUP BY**) 

GFT Group 06.11.2020 56   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**GROUPING – przykład użycia**

SELECT ShipCountry, 

ShipRegion, 

ShipCity, 

COUNT(OrderID) AS NumberOfOrders, GROUPING(ShipCountry) AS 

ShipCntryGrp, 

GROUPING(ShipRegion) AS 

ShipRegGrp, 

GROUPING(ShipCity) AS 

ShipCityGrp 

FROM Orders 

GROUP BY ROLLUP (ShipCountry, 

ShipRegion, 

ShipCity) 

GFT Group 06.11.2020 57   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**GROUPING\_ID** 

▪ **GROUPING\_ID** jest funkcją wyliczającą poziom grupowania dla poszczególnych kolumn (wyrażeń) w postaci wektora bitowego. Zwracana wartość jest decymalną reprezentacją tego wektora. 

▪ Składnia:  

**GROUPING\_ID** ( kolumna/wyrażenie \[,…n\] ) 

▪ Zwracany typ: **int** 

▪ Funkcja **GROUPING\_ID** może być użyta jedynie w poleceniu **SELECT**, **HAVING** oraz **ORDER BY** (zakładając, że użyto polecenia grupującego **GROUP BY**) 

GFT Group 06.11.2020 58   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**GROUPING\_ID \- przykłady** 

| Podzbiory  (a, b, c)  | Agregowane kolumny \-  | GROUPING\_ID (a, b, c) 0 0 0  | Wynik funkcji   GROUPING\_ID()  0 |
| ----- | :---- | :---- | ----- |
| (a, b)  | c  | 0 0 1  | 1 |
| (a, c)  | b  | 0 1 0  | 2 |
| (b, c)  | a  | 1 0 0  | 4 |
| (a)  | b c  | 0 1 1  | 3 |
| (b)  | a c  | 1 0 1  | 5 |
| (c)  | a b  | 1 1 0  | 6 |
| ()  | a b c  | 1 1 1  | 7 |

GFT Group 06.11.2020 59   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**Przykład**

Zadanie 

Korzystając z tabeli ***Products***, ***Categories***, ***Suppliers*** przeanalizuj średnią jednostkową, minimalną oraz maksymalną cenę produktu w 3 wymiarach: kategoria produktu (***Categories.CategoryName** \[nvarchar\]*), kraj (**Suppliers.City** *\[nvarchar\]*) wraz z regionem dostawcy (***Suppliers.Region** \[nvarchar\]*) oraz wyłącznie dla kraju. 

W rozwiązaniu uwzględnij jedynie produkty, które posiadają wskazanie na dostawcę oraz przypisaną kategorie. Wartości puste w polu region, które wynikają z danych zamień na wartość – *„Not provided”*. 

Do rozwiązania dodaj kolumnę, która dla poszczególnych wymiarów przyjmie następujące wartości: 

▪ Kategoria produktu – *„Category”* 

▪ Kraj wraz z regionem – *„Country & Region”* 

▪ Kraj – *„Country”* 

GFT Group 06.11.2020 60   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**Przykład \- rozwiązanie**

SELECT C.CategoryName AS Category, S.Country AS Country, 

CASE 

WHEN GROUPING(S.Region) \= 0  

AND S.Region IS NULL THEN 'Not Provided' 

ELSE S.Region 

END AS Region, 

ROUND(AVG(P.UnitPrice), 2\) AS AvgUnitPrice, 

MIN(UnitPrice) AS MinUnitPrice, 

MAX(UnitPrice) AS MaxUnitPrice, 

CASE GROUPING\_ID (C.CategoryName, S.Country, S.Region) 

WHEN 5 THEN 'Country' 

WHEN 4 THEN 'Country & Region' 

WHEN 3 THEN 'Category' 

END AS GroupingLevel 

FROM Products P  

JOIN Categories C 

ON P.CategoryID \= C.CategoryID 

JOIN Suppliers S 

ON P.SupplierID \= S.SupplierID 

GROUP BY GROUPING SETS ((C.CategoryName), 

(S.Country, S.Region), 

(S.Country)) 

GFT Group 06.11.2020 61   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**PIVOT** 

▪ Polecenie **PIVOT** pozwala przekształcić wyniki z jednego układu tabelarycznego w inny układ tabelaryczny 

▪ Celem jest transformacja danych z układu wierszowego na kolumnowy, w celu czytelniejszej prezentacji danych 

▪ Podczas przekształcenia wykonywana jest agregacja 

▪ Wartości NULL nie są uwzględniane przy obliczaniu agregacji 

GFT Group 06.11.2020 62   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**PIVOT**

Zadanie 

Korzystając z tabel ***Products***, ***Categories***, ***Order Details*** oraz ***Orders*** przedstaw sumę wartości zamówień (***Order Details.UnitPrice*** \[money\], ***Order Details.Quantity*** \[smallint\]) produktów w danej kategorii (***Categories**.**CategoryName*** \[nvarchar\]) w poszczególnych latach (***Orders.OrderDate*** \[datetime\]), uwzględniając dane, które posiadają wszystkie wymagane informacje. 

SELECT C.CategoryName AS CategoryName, 

DATEPART(yyyy,O.OrderDate) AS Year, 

SUM(OD.UnitPrice\*OD.Quantity) AS Amount 

FROM \[Products\] P 

JOIN \[Order Details\] OD 

ON P.ProductID \= OD.ProductID 

JOIN \[Orders\] O 

ON OD.OrderID \= O.OrderID 

JOIN \[Categories\] C 

ON C.CategoryID \= P.CategoryID 

GROUP BY C.CategoryName, DATEPART(yyyy,OrderDate) 

GFT Group 06.11.2020 63   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**PIVOT**

Zadanie\* 

Zaktualizuj poprzednie zapytanie, tak aby jako wiersze 

otrzymać kategorie, a lata jako kolumny. Na przecięciu tych 

wartości powinna być zaprezentowana kwota zamówień dla 

danej kategorii w danym roku. 

GFT Group 06.11.2020 64   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**PIVOT**

SELECT \[CategoryName\], \[1996\], \[1997\], \[1998\] FROM ( 

SELECT C.CategoryName AS CategoryName, DATEPART(yyyy,OrderDate) AS Year, 

(OD.UnitPrice\*OD.Quantity) AS Amount 

FROM \[Products\] P 

JOIN \[Order Details\] OD 

ON P.ProductID \= OD.ProductID 

JOIN \[Orders\] O 

ON OD.OrderID \= O.OrderID 

JOIN \[Categories\] C 

ON C.CategoryID \= P.CategoryID) S PIVOT 

( SUM(S.Amount) 

FOR Year IN (\[1996\], \[1997\], \[1998\]) 

) AS AMT 

GFT Group 06.11.2020 65   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**PIVOT**

SELECT \[CategoryName\], \[1996\], \[1997\], \[1998\] FROM ( 

SELECT C.CategoryName AS CategoryName, DATEPART(yyyy,OrderDate) AS Year, 

(OD.UnitPrice\*OD.Quantity) AS Amount 

FROM \[Products\] P 

JOIN \[Order Details\] OD 

ON P.ProductID \= OD.ProductID 

JOIN \[Orders\] O 

ON OD.OrderID \= O.OrderID 

JOIN \[Categories\] C 

ON C.CategoryID \= P.CategoryID) S PIVOT 

( SUM(S.Amount) 

FOR Year IN (\[1996\], \[1997\], \[1998\]) 

) AS AMT 

GFT Group 06.11.2020 66   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**UNPIVOT** 

▪ Polecenie **UNPIVOT** jest operacją odwrotną do operacji **PIVOT** w sensie układu (przekształca z wierszowego układu tabelarycznego na kolumnowy), ale korzystając z **UNPIVOT** nie można odtworzyć oryginalnej tabeli, która została przekształcona za pomocą polecenia **PIVOT** 

▪ Wszystkie kolumny na liście **UNPIVOT** muszą być dokładnie tego samego typu oraz tej samej długości 

GFT Group 06.11.2020 67   
FUNKCJE GRUPOW ANIA I AGREGACJI **UNPIVOT**

▪ Mamy tabelę: 

▪ Chcemy przekształcić i zaprezentować wynik w  postaci: 

GFT Group 06.11.2020 68   
FUNKCJE GRUPOW ANIA I AGREGACJI   
**UNPIVOT**

SELECT ID, CustomerID, ProductCode, Quantity 

FROM 

( 

SELECT ID, CustomerID, ProductA, ProductB, 

ProductC 

FROM SalesUnpivot) p  

UNPIVOT 

(Quantity FOR ProductCode IN (ProductA, 

ProductB, ProductC )) AS unpvt 

GFT Group 06.11.2020 69   
FUNKCJE GRUPOW ANIA I AGREGACJI  
**Podsumowanie** 

▪ **NULL** w funkcjach agregujących\! 

▪ Polecenia **ROLLUP** and **CUBE** umożliwiają tworzenie podsumowań na różnych poziomach agregacji ▪ Polecenie **GROUPING SETS** umożliwia określenie własnych zbiorów grupowań 

▪ Polecenia **PIVOT/UNPIVOT** pozywają transformować wynik z jednego układu tabelarycznego w inny  (np. z rekordowego na kolumnowy i odwrotnie) 

▪ **GROUPING** i **GROUPING\_ID** – pomocne funkcje do określenia poziomu grupowania 

GFT Group 06.11.2020 70   
Common Table Expression  
COMMON TABLE EXPRESSION   
**CTE \- przykład**

WITH 

ProdAvgUnitPrice (AvgUnitPrice) 

AS 

( 

SELECT AVG(UnitPrice) 

FROM Products 

), 

GreaterThanAvg (ProductName, CategoryID, UnitPrice) 

AS 

( 

SELECT ProductName, CategoryID, UnitPrice 

FROM Products P  

WHERE UnitPrice \> (SELECT AvgUnitPrice FROM ProdAvgUnitPrice) ) 

SELECT G.ProductName, C.CategoryName, G.UnitPrice 

FROM GreaterThanAvg G JOIN Categories C  

ON (C.CategoryID \= G.CategoryID); 

GFT Group 06.11.2020 72   
COMMON TABLE EXPRESSION  
**Rekurencja – definicja i przykłady** 

▪ **Rekurencja**, zwana także rekursją jest odwołaniem się np. funkcji lub definicji do samej siebie (Wikipedia) 

▪ Obliczanie silni jako przykład rekurencji: 

▪ Przykłady: 

▪ 4\! \= 4 ∗ 3\! \= 4 ∗ 3 ∗ 2\! \= 4 ∗ 3 ∗ 2 ∗ 1\! \= 4 ∗ 3 ∗ 2 ∗ 1 \= 24 

▪ 5\! \= 5 ∗ 4\! \= 5 ∗ 4 ∗ 3\! \= … \= 5 ∗ 4\! \= 5 ∗ 24 \= 120 

GFT Group 06.11.2020 73   
COMMON TABLE EXPRESSION  
**Rekurencyjne CTE** 

▪ Rekurencyjna definicja **CTE** musi zawierać co najmniej dwa zapytania: zapytanie zakotwiczające (*anchor member*) oraz zapytanie rekurencyjne (*recursive member*). 

▪ Można użyć wielu zapytań zakotwiczający oraz rekurencyjnych, natomiast wszystkie zapytania zakotwiczający muszą być zdefiniowane przed zapytaniami rekurencyjnymi. 

▪ Wszystkie zapytania zakotwiczające muszą być połączone za pomocą operatorów UNION ALL, UNION, INTERSECT lub EXCEPT. 

▪ Pomiędzy zapytaniem zakotwiczający a rekurencyjnym może być użyty jedynie UNION ALL ▪ Warunek stopu występuje, gdy zapytanie rekurencyjne nie zwróci żadnego rekordu 

GFT Group 06.11.2020 74   
COMMON TABLE EXPRESSION  
**Rekurencyjne CTE** 

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

GFT Group 06.11.2020 75   
COMMON TABLE EXPRESSION   
**Rekurencyjne CTE \- silnia** 

WITH Factorial (N, FactorialValue) AS 

( 

SELECT 1, 1 

UNION ALL 

Zapytanie zakotwiczające Tu się dzieje rekurencja 

SELECT N\+1, (N\+1) \* FactorialValue 

FROM Factorial 

WHERE N \< 10 

) 

SELECT N, FactorialValue 

FROM Factorial 

Zapytanie rekurencyjne   
Odwołanie do CTE Warunek stopu

GFT Group 06.11.2020 76   
COMMON TABLE EXPRESSION   
**Zapytania hierarchiczne**

Zadanie 

Korzystając z tabeli ***Employees*** wyświetl identyfikator (***EmployeeID** \[int\]*), imię 

(***FirstName** \[nvarchar\])* oraz nazwisko (***LastName** \[nvarchar\]*) pracownika oraz 

identyfikator, imię i nazwisko jego przełożonego. Do znalezienia przełożonego danego 

pracowania użyj pola ***ReportsTo*** (*FK, \[int\]*). 

GFT Group 06.11.2020 77   
COMMON TABLE EXPRESSION   
**CTE**

WITH EmployeesRecCTE 

( 

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName ) 

AS 

( 

SELECT EmployeeID, FirstName, LastName, ReportsTo, 

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName, 

CAST(NULL AS NVARCHAR(20)) AS ManagerLastName 

FROM Employees 

WHERE ReportsTo IS NULL 

UNION ALL 

SELECT E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName, R.LastName 

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo \= R.EmployeeID ) 

SELECT EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName 

FROM EmployeesRecCTE; 

GFT Group 06.11.2020 78   
COMMON TABLE EXPRESSION   
**CTE – Poziom rekurencji**

WITH EmployeesRecCTE 

( 

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName, Level 

) 

AS 

( 

SELECT EmployeeID, FirstName, LastName, ReportsTo, 

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName, 

CAST(NULL AS NVARCHAR(20)) AS ManagerLastName, 

0 AS Level 

FROM Employees 

WHERE ReportsTo IS NULL 

UNION ALL 

SELECT E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName, R.LastName, Level \+ 1 

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo \= R.EmployeeID ) 

SELECT EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName, Level 

FROM EmployeesRecCTE; 

GFT Group 06.11.2020 79   
COMMON TABLE EXPRESSION   
**CTE – MAXRECURSION – ograniczenie poziomu rekurencji**

WITH EmployeesRecCTE 

( 

EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, ManagerLastName, Level 

) 

AS 

( 

SELECT EmployeeID, FirstName, LastName, ReportsTo, 

CAST(NULL AS NVARCHAR(10)) AS ManagerFirstName, 

CAST(NULL AS NVARCHAR(20)) AS ManagerLastName, 

0 AS Level 

FROM Employees 

WHERE ReportsTo IS NULL 

UNION ALL 

SELECT E.EmployeeID, E.FirstName, E.LastName, R.EmployeeID, R.FirstName, 

R.LastName, Level \+ 1 

FROM Employees E JOIN EmployeesRecCTE R ON E.ReportsTo \= R.EmployeeID 

) 

SELECT EmployeeID, FirstName, LastName, ReportsTo, ManagerFirstName, 

ManagerLastName, Level 

FROM EmployeesRecCTE 

OPTION (MAXRECURSION 1); 

GFT Group 06.11.2020 80 

[image1]: <data:image/png;base64,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>

[image2]: <data:image/png;base64,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>

[image3]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEcAAAAnCAYAAABdRFVFAAAFBElEQVR4Xu2Y+0/TZxTG/ZeWLMvCth+2zLjMzM0smVuYE8G5myDIpsvAguIYSKmVm0XAwgQKyJS7gIhWLiKXSAGZDMu9UAqFclVs67OeQ9rB98tql/Q20yf5hD4v5y3n+4S83zdnF7ys+fl5WK1W4bLPRT1Rb1u1a5vzggLhOFEgHCcKhONELwvnaU8ePvwgFJXjZpvTMooDe5DVSX5TL2z7u1VJSJTWMH21crzxzlsICgraZP9JND0xgHb8s8u5/DycDaYjMxoJ8licVfbjmW2FmLgpwXFFr8NbLUsolIQiK1vBHA6RYnBjSwyjt5GgbMGS7SPhigLhOJF/h7M+yiikV9DW3wDZjxcxvAZmXd+KM+EpeLwKxmJoRnSoBNIUGXP1zmNYXgi/8L/Jj8N5AdOjWiZJUQjNQD8yzhzDH5pFxvx0ESXScKh65pnR8ihE5N3F5RQ5c6NzHNZlHYoTv2aC3nwde6NKQI+6/XH/Xf4bjnUNnVUy5su9u7Fv30d4b8+nSChsZVaeb6C7SgF5lpL5Lew4bk/PoEwuY4rUQ9v/c6arEHb0d8zaPhKuyG/DMa/oocpLYmq6DbYVK6a7KpCYpmTGTRuY7atHcvjHzPvHirCM59A15zPffJ+B4Q2LbZ+RacuIxO6DuYFwXvlw5kdvQnI4nuk2bL51zPN9SP5WwtwYnIFl4U9cPHKAiVB2bW5cNzL9Refw2tt0z9nDRJw4ik9ClK9GOP6gQDhOFAjHiQLhONGO4VgsFngTamBkZARGo5ExmUwYGxvDwsKCA/K0bq8hv7S0hLm5OYb8ysoKZmdnmfHxcfZ6vZ6ZnJxkPz09zUxNTbHX6XSONfJUNzMzw5Cnv70tnLW1NXgTeshYSRyuV1QyjU3NNh+Pmrp6B+Rp3V5DXt3SBlXpNYb8/QddKLhaxMSfPYcHXT3IyVMyiUnn2WdeymakMjl7mTwN6RlZDPmk81Jk5+QxUmnqtmAC4bwsHOGCp7W6uoqY03HQG5f9ipLSMmGrvgnnTku7qDlfExp2RNjqTuE8h+GJlhnTLYIu5e4UhRNxPErU3FY0rZXIL1ShQt3HjOrFNe6m7ma9sFVhOCbUpUXjs3eDmfPlPTxccqconOSUVFFzDh6pceRQMKLifsJ3ob8y1Q8nxXVu5nJOrrDVQDh2XAjnGUZ7GyEPj2EyPBSO0zNnUovmzr8wYZyEKuZnJqW2V1znZlw8c0xoupDO5HoonJDDYaLmtjJjMKJXXYyIz08xBR1aUY27aW1rF7bqm3CysnNFzW1FZ7uxVuXG4lhkNJPf7PlwpKkyYauBcOz4TTiVtfWi5sQsoKPgJPOVrGGH37uXyKgTwlZ9E46zM+dx4yXs/yUDrR0tuHz6EHMq/4Gozt24eOas4VFjE3Ova8x2JXSvKJxCVZmoua005kThi+CD+CG5mOkfM4pq3I0kLl7YaiAcOy6G41m5Eo4v8JtwnJ05vsLFM8ezcv1t5V12fFutr6/Dm9CwKyEhAQVXi5ksRQ56HmqQeyXfAXlat9eQl6dnorj0GkM+JfUCyq9XMDS4SpbKUFldx7S0d7Cva7jFNN9tYd90R42GW7cZ8vda21FdV8+k7nTPETbvaf5X4ZjNZngbCmh4eJgZHBzkwfbQ0JAD8rRuryE/MDAArVbLkNdoNDxoJ2hoT35iYoIxGAzsabBO0ACdPP2kITtBnobzNGQnyAv1N0Z9rlSSW8/3AAAAAElFTkSuQmCC>

[image4]: <data:image/png;base64,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>

[image5]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFwAAAAlCAYAAADPwo5RAAAFUUlEQVR4Xu3aW1MTZxgHcL9IP0B70evO9KZjrVoZscVOp9qTVVSoRUatguiAMopGORVpAEUUUREIAgFEIkgEAwQ05EDYJKxBTgFJAs2qgCD+u/soM82CzYVkycA+M7+L991nN+/+IW/YCWsgcbndbvHUqinh3teIJ4NdgQLv01XgRp2B+GYAT58ONRVa4nn5rmlykNRdrsfQSw+0FZdIcnIykhXZqDMMkhm/Ky9/yYFLXCEZeEnsJ9gcV0DMo9Pw2jU4cfIM6Rqeph6fqZhExl3Fg6JTiDycQVQaDTSVxUg4mUE0jjHR1Ze3Qi/wVzZkHExB7qXLpLrNiTdTLlxPTydl/BhzHO7nnSfKqlKciYzHI+9r8ka4xps5zM7OktdzNBMyFXKBc/o0JBSzsFVkkYRrWn52xm8847XhQmoaud+Qi537yuDluwQY7oBCoYAip5RYRzn/F1jmkgOXuEIocCEYDvcSv8LHn4dh/eefko++PgEPf+RVv4ZExV6E1aJB+nklYa23/AMfZ1GtuoKY6ARS/njQ71WWu0Im8FmXlvxx6iZ8Ph9vkKgORaLQ8Yrfl8eJ+sgeHExVIK2ok0zOuaCMjkGN/R8yy19rym3C2cPJpEIOfLHAJ2EpTiUHchv9jky0pGDX8UbwcRNh/OW63bjNvCBCOapz8HvsMXI6MxPnkmKxcd1eUioHLgceAoFPw2W1EKZfiPU/xT/c6LX2dzv827Gu0QAPv8sIqKY5WPUNRKVSoU6jw2OLg7jG55+UQqNCJPDVU3LgEpccuMQlBy5xUeDPnz+HlB48aMbfyhwSFRWNlpaHK36ckpJChGcMyX/DbTY7GpoeklEvtyoUFt0kVqtVDlwKcuASCxD4a0z6OPJieum/M2lubkZmlpKIFyZwPXODsTHEYGHAjizsGRoeIhYrAxPjxNNnHBGOsb1vzxP0PHVL0h+IwWghHo9HHPhLdNbk4VDEfpLbZPM/vARldzjQ1NJGxAsTtFdfxA/friXhW9fiaFonWOFG53tGhlGSFUe2RIThu20/QVluIwO9ndj5zWcI27qRbNtzGT3B7l/kHsQKrhaR7u5uceAv0FKSiuiwaJIThMB7GAZ3G7REvDCBUaeBuo0lQ95HSNh8AA0DHKEe1wDu1t8nrY4RdNQX4uSxfGIy61BQa0K/104yInbjBhPkfufCexC7frOEMPy9y4F/aP+HBS6UB+qkdHItCIEH2sMFrtExYtcX4MdNZ9E6xpEFfS4XKpVJ+DOxjPS4OYyMjeOJuZZEfRGD2lHp+t/nf/ZwoYIbeG8vi+bWDiJe2LwnejWJ2RWO47l3YOrniLiPuZuFiO3b8Vd5BxE+YAd6zUg/up3sOHwOOla6/ve5mH+FmM1m6QPvtvagtr6RiBe2kAuZ+8Oh1I6Qhcc52DqqEHcskTT1eN7Nj5H601sQUzogaf9iiktUxGazyYEvdf9iljXwQHt4SfYRnOXfvoLep0Yk/roJhXoPGRh0o89uQHKqglS1MmjV5ONQ3Amivnoav1xo4M9jSMH+tYgv0ge1P7Fu/ofwfgH2cB/ab1SQRvPSf0XFPnFCpzcQ8cIErKUNSXs3kHXrN0Bxp4+ft5OC2Fw85HuM9/LJb99vQPjP+3CrfZgI5+fHvz1PsCO1huaC3R9ITl4+MRqNiwUe3LJYuqG+oyHiha1UZeWVxME/9MmBS2BZAw+0h69EAfbw4Jazrw/tj0xEvLCVKluZR7q6urBmamoKUhL++D8SF08ed5mRkZWN25XVZKWOK6vUhGVZOXApxn6Bz/8vtZScTicR9jThbbZaxhMTE/gXMTv8eRKJD+8AAAAASUVORK5CYII=>

[image6]: <data:image/png;base64,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>

[image7]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE8AAAAmCAYAAACFz8YUAAAFVUlEQVR4Xu2Z7U9TZxiH/XeW7OOyb2b7tES/GDUxumwzLmxOXVZfqg4naKQMtKhV1EEAnS+jG1UBAS2VFpHaVmyl0BegsFLb0p6+gcCICNXfznNvp2l7DDYCbUl6J1ea33PO3T7P1Z4nJ6frkIN6/fo1Xr58SaylevXqFWZmZghW69KOZ6UK8pZRBXnLqCXlxfqguKDB5JyHUMr2Y9OGDdjAc+jSPSIyl96Uncp/ecEOFH13Ddy0nZAdlkM75MX0dBC9dfuJ4noTFtL7slBrT95RBUy+qf+OzRgJ6dYquFK7slIFecuotS0PXqJ2+z5oYslN2am1LS9uI2RflMAcT23LRq1heQsIGmuJH4/dxmR6XxZq7cnbtQNbd3yDoqKd+OlICaG2RdO7slIFecuo/Je3OItAYAqL8Xki4hvHkNMJJ48nOEks5GC/Y5X/8vK4CvKWUQV5yyiRvLdv3yLbzM/PIxaLEfF4nGQuLi4SQmavAkIWzskkv3nzJpEXFhYos1eBTLPwHiwL4hLyZmdnkW3YhzdcvUqoOzXY/cMe3LzVSLTca6PcpLqdgGU2LpzDMuurv3qNYFn3qAdXfqsh9uzdh179E5xXXCQkBw5SrjwjJ44cLaZ8qkxGlJw4SfmX46WQlVcQLEsPH4G86ixBWSpN/iHm5rJl3+QDdSehN1nAxWbyHh8XRUNDQ8o6CvIyJK/kWQdshGPELZpoPjIRnoTBYEhZx3vk/QOfcwLswe1KPrxl8urq6onWjk7RRLnIJEYcdsLs8MIf4cfCYQzYRomxQBTuv90YdPoIP/XxPfwxhtMTxrh7FNbhADEhvG+II55bRzEemhJ/7hK8mAhDIpGkrOMd8hbBDfUS1y8dwJZPSmHjRxkrVUxel1ZHmMxW0UQ5zoebpTuJz7aWweCOgHthwQlpJdFsdkF76zJkJ5uJEeobx3Xpr0R1qwW6ptMolncSbuF93XpC8n0lusc48ecuAbtsGxsbU9ZRkJchGcqLY8pnJ7raq7Dz05OrIq/vmYUYcLhEEyV58qPExs/Xo6zNmXN5E6FJaLXalHW8Q15yWVC6vnxV5C255zF5FysJuUKOIn6xppHcystwz0uu1ZP3uFdPPLPaRRNNlnde+RT3r+1BxZVWFPPiGLmQ5w/F0NzcnLKOgrwMySt5eoORsAw6RRNNlzc6bsHZg19j47YSotk8Cv3dOpyS3STsQb4nOIzqYxVEfadtVeS1t7enrCNn8jLd85g8bySEB/UH8PFH2wil2Q2b/g7KKk4RatMw+p9oIJVVES3PPND9WQ7J8T8Ig50/7uDvAR3dhOTbUqj0/ehn4wwXf68YmRbPI4kP2PPcaDpx9/8//FaumDzj0z6CTT59ouxGVtN6m7ijG6KbYI/DiPLTl4muoQn+vDB6mxTEru1bsOnLvbjQ2k94+fPN6hrs2ryF2MT4ajcUdzqJmhIJNgvjjJ9rYX8RFc8jCfbLU6vVKet4j7zVKSav+1EP0fd8UDTRfMTPxaBSqVLWUZCXIXklb8k9Lw/5gD1vdYrJszy3ErahMdFE8xH2VKWnpydlHevYc/lsMzc3h4cPHxIHDx2GxTqIG7eURG1dA+WG328kYJmNC+ewXH2lBsq/VATL5y9UQ3W3hTDzX4r8nAItbR2E8amZcscDDfFYb6Ss6dIR2u7HlHU9vVBrtATLeoMJbffVROWZKiiVyoK8FZPHLqFcYrPZ6I8gl8tFsD+3WR4eHk7AMhsXzmGZ9Y2NjREsDwwMwO12E9FoFFarFR6PhwiHw5S9Xi/BcRxlv99PBAIBysFgMDHGcigUSvSwnF7/AkVRBQDafPeOAAAAAElFTkSuQmCC>

[image8]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADsAAAAnCAYAAACxMTBTAAADZUlEQVR4Xu2Y60+SYRiH/aNq6x/oU5t9qNa3WjptrYOu5mytPLZOxio3TeemJVuSEFNCEZEwfEmLTA0PJKB2MFEjB57x8Ou975oJL5EaoOZ7bdf23C+847k2HmAkYZuYnZ3FzMwMG0/8fj+7sLCApPAHE4UcGwd2fOzyuBXF5Tb4A062IvsMDicnI/mXOUob5oLhd0Vmx8cujaiQck6Db74ONuPUTdi/jGFycphtvH0C17XDWKLnht8cxu6LTbsP98K6rKkWnD9WghFxSUZDjk00/xQLN+4dzUSbH2w0dn/syjvkHcxHt3iJjMYujqWP4CDGhAc4e60RU+JERmP3xSYfR/rFS8jKusBmX7kK8wfpfZGQYxNNtNjV+QkMeiYRDAZYT08nBEFYs3dkEksr4XdFZsfHxhI5NtHIsXEgJJYW09PTCZdeNz+/gBUEGzIyM1FUdJelOT39NEpKSlmz+QVSUlNRWVXFPtc38FyjesrWqjU819Xr8Li6mqW5udmEyspKdnV1FUn0wtvB4uIiGgxG1un5CK8vEHO73vfDbrezhBybCHZk7MryImYD81gW12SsoNg88bySrzt7JBsN9TuGhscxKq5J6eOR1RtMqBLPOEn8IfbnD25vfzuelOci42QVPolXyFhBsa1WgXWNjEo26vVNwdndzqpVhTi+Pxdt4nVS+tzI9g644HA4WOIPsfOs26rG9ctpSItTrFqjZfsGhyQb9fp86G7TsYob6Ti0L2fTsW/Ed4zVamUJOXY9E24dCuMUu/Ez+wKZB/I3HbvBM/ubeMbaO7vYoc9eyUZD3VrsoPgp73a7WWJbYx9VK9n3/S7JRkPdWqzQbofRaGQJOXY98Ywtuqtg33b3SjYa6tZim80voVKpWOKvsb6PZpRmP8NXcU3Gis2dWRsKjhSjQ1yT0scju+kzGy8otvRhGdvlcEo2Ggst1leoq6tjCTk2Eey52I2f2a0pObOBAP1dGUy4c3NzUCgUbGlZBRwDg+h428XWNzRhQPwJKXTYWX2TCU73MFqFdrbJZOHZ3CqwJouVZ2NLKyxtr1iab91RoLa2luVY+m9mu1Uqlejr64PNZmNpdrlcsFgsbE1NDTwez9p3pkaj4Vmv17M6nY5nrVYLg8HA0qxWq9e/mfZYbMj0n/MDS6FCUzo+em0AAAAASUVORK5CYII=>

[image9]: <data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE8AAAAmCAYAAACFz8YUAAAFVUlEQVR4Xu2Z7U9TZxiH/XeW7OOyb2b7tES/GDUxumwzLmxOXVZfqg4naKQMtKhV1EEAnS+jG1UBAS2VFpHaVmyl0BegsFLb0p6+gcCICNXfznNvp2l7DDYCbUl6J1ea33PO3T7P1Z4nJ6frkIN6/fo1Xr58SaylevXqFWZmZghW69KOZ6UK8pZRBXnLqCXlxfqguKDB5JyHUMr2Y9OGDdjAc+jSPSIyl96Uncp/ecEOFH13Ddy0nZAdlkM75MX0dBC9dfuJ4noTFtL7slBrT95RBUy+qf+OzRgJ6dYquFK7slIFecuotS0PXqJ2+z5oYslN2am1LS9uI2RflMAcT23LRq1heQsIGmuJH4/dxmR6XxZq7cnbtQNbd3yDoqKd+OlICaG2RdO7slIFecuo/Je3OItAYAqL8Xki4hvHkNMJJ48nOEks5GC/Y5X/8vK4CvKWUQV5yyiRvLdv3yLbzM/PIxaLEfF4nGQuLi4SQmavAkIWzskkv3nzJpEXFhYos1eBTLPwHiwL4hLyZmdnkW3YhzdcvUqoOzXY/cMe3LzVSLTca6PcpLqdgGU2LpzDMuurv3qNYFn3qAdXfqsh9uzdh179E5xXXCQkBw5SrjwjJ44cLaZ8qkxGlJw4SfmX46WQlVcQLEsPH4G86ixBWSpN/iHm5rJl3+QDdSehN1nAxWbyHh8XRUNDQ8o6CvIyJK/kWQdshGPELZpoPjIRnoTBYEhZx3vk/QOfcwLswe1KPrxl8urq6onWjk7RRLnIJEYcdsLs8MIf4cfCYQzYRomxQBTuv90YdPoIP/XxPfwxhtMTxrh7FNbhADEhvG+II55bRzEemhJ/7hK8mAhDIpGkrOMd8hbBDfUS1y8dwJZPSmHjRxkrVUxel1ZHmMxW0UQ5zoebpTuJz7aWweCOgHthwQlpJdFsdkF76zJkJ5uJEeobx3Xpr0R1qwW6ptMolncSbuF93XpC8n0lusc48ecuAbtsGxsbU9ZRkJchGcqLY8pnJ7raq7Dz05OrIq/vmYUYcLhEEyV58qPExs/Xo6zNmXN5E6FJaLXalHW8Q15yWVC6vnxV5C255zF5FysJuUKOIn6xppHcystwz0uu1ZP3uFdPPLPaRRNNlnde+RT3r+1BxZVWFPPiGLmQ5w/F0NzcnLKOgrwMySt5eoORsAw6RRNNlzc6bsHZg19j47YSotk8Cv3dOpyS3STsQb4nOIzqYxVEfadtVeS1t7enrCNn8jLd85g8bySEB/UH8PFH2wil2Q2b/g7KKk4RatMw+p9oIJVVES3PPND9WQ7J8T8Ig50/7uDvAR3dhOTbUqj0/ehn4wwXf68YmRbPI4kP2PPcaDpx9/8//FaumDzj0z6CTT59ouxGVtN6m7ijG6KbYI/DiPLTl4muoQn+vDB6mxTEru1bsOnLvbjQ2k94+fPN6hrs2ryF2MT4ajcUdzqJmhIJNgvjjJ9rYX8RFc8jCfbLU6vVKet4j7zVKSav+1EP0fd8UDTRfMTPxaBSqVLWUZCXIXklb8k9Lw/5gD1vdYrJszy3ErahMdFE8xH2VKWnpydlHevYc/lsMzc3h4cPHxIHDx2GxTqIG7eURG1dA+WG328kYJmNC+ewXH2lBsq/VATL5y9UQ3W3hTDzX4r8nAItbR2E8amZcscDDfFYb6Ss6dIR2u7HlHU9vVBrtATLeoMJbffVROWZKiiVyoK8FZPHLqFcYrPZ6I8gl8tFsD+3WR4eHk7AMhsXzmGZ9Y2NjREsDwwMwO12E9FoFFarFR6PhwiHw5S9Xi/BcRxlv99PBAIBysFgMDHGcigUSvSwnF7/AkVRBQDafPeOAAAAAElFTkSuQmCC>