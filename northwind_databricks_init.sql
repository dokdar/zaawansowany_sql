-- =====================================================
-- Skrypt inicjalizacji bazy danych Northwind dla Databricks
-- Wersja: 1.0
-- Data: 2025-11-13
-- Platforma: Databricks (Spark SQL / Delta Lake)
-- =====================================================

-- Utworzenie bazy danych (schematu)
CREATE DATABASE IF NOT EXISTS northwind;
USE northwind;

-- =====================================================
-- TWORZENIE TABEL
-- =====================================================

-- Tabela: Categories
DROP TABLE IF EXISTS Categories;
CREATE TABLE Categories (
  CategoryID INT NOT NULL,
  CategoryName STRING NOT NULL,
  Description STRING,
  PRIMARY KEY (CategoryID)
) USING DELTA;

-- Tabela: Suppliers
DROP TABLE IF EXISTS Suppliers;
CREATE TABLE Suppliers (
  SupplierID INT NOT NULL,
  CompanyName STRING NOT NULL,
  ContactName STRING,
  ContactTitle STRING,
  Address STRING,
  City STRING,
  Region STRING,
  PostalCode STRING,
  Country STRING,
  Phone STRING,
  Fax STRING,
  HomePage STRING,
  PRIMARY KEY (SupplierID)
) USING DELTA;

-- Tabela: Products
DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
  ProductID INT NOT NULL,
  ProductName STRING NOT NULL,
  SupplierID INT,
  CategoryID INT,
  QuantityPerUnit STRING,
  UnitPrice DECIMAL(10,2),
  UnitsInStock INT,
  UnitsOnOrder INT,
  ReorderLevel INT,
  Discontinued BOOLEAN,
  PRIMARY KEY (ProductID)
) USING DELTA;

-- Tabela: Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
  CustomerID STRING NOT NULL,
  CompanyName STRING NOT NULL,
  ContactName STRING,
  ContactTitle STRING,
  Address STRING,
  City STRING,
  Region STRING,
  PostalCode STRING,
  Country STRING,
  Phone STRING,
  Fax STRING,
  PRIMARY KEY (CustomerID)
) USING DELTA;

-- Tabela: Employees
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
  EmployeeID INT NOT NULL,
  LastName STRING NOT NULL,
  FirstName STRING NOT NULL,
  Title STRING,
  TitleOfCourtesy STRING,
  BirthDate DATE,
  HireDate DATE,
  Address STRING,
  City STRING,
  Region STRING,
  PostalCode STRING,
  Country STRING,
  HomePhone STRING,
  Extension STRING,
  Notes STRING,
  ReportsTo INT,
  PhotoPath STRING,
  PRIMARY KEY (EmployeeID)
) USING DELTA;

-- Tabela: Shippers
DROP TABLE IF EXISTS Shippers;
CREATE TABLE Shippers (
  ShipperID INT NOT NULL,
  CompanyName STRING NOT NULL,
  Phone STRING,
  PRIMARY KEY (ShipperID)
) USING DELTA;

-- Tabela: Orders
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID INT NOT NULL,
  CustomerID STRING,
  EmployeeID INT,
  OrderDate TIMESTAMP,
  RequiredDate TIMESTAMP,
  ShippedDate TIMESTAMP,
  ShipVia INT,
  Freight DECIMAL(10,2),
  ShipName STRING,
  ShipAddress STRING,
  ShipCity STRING,
  ShipRegion STRING,
  ShipPostalCode STRING,
  ShipCountry STRING,
  PRIMARY KEY (OrderID)
) USING DELTA;

-- Tabela: Order Details
DROP TABLE IF EXISTS `Order Details`;
CREATE TABLE `Order Details` (
  OrderID INT NOT NULL,
  ProductID INT NOT NULL,
  UnitPrice DECIMAL(10,2) NOT NULL,
  Quantity INT NOT NULL,
  Discount DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (OrderID, ProductID)
) USING DELTA;

-- =====================================================
-- WSTAWIANIE DANYCH PRZYKŁADOWYCH
-- =====================================================

-- Dane do tabeli Categories
INSERT INTO Categories VALUES
(1, 'Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
(2, 'Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
(3, 'Confections', 'Desserts, candies, and sweet breads'),
(4, 'Dairy Products', 'Cheeses'),
(5, 'Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
(6, 'Meat/Poultry', 'Prepared meats'),
(7, 'Produce', 'Dried fruit and bean curd'),
(8, 'Seafood', 'Seaweed and fish');

-- Dane do tabeli Suppliers (20 dostawców)
INSERT INTO Suppliers VALUES
(1, 'Exotic Liquids', 'Charlotte Cooper', 'Purchasing Manager', '49 Gilbert St.', 'London', NULL, 'EC1 4SD', 'UK', '(171) 555-2222', NULL, NULL),
(2, 'New Orleans Cajun Delights', 'Shelley Burke', 'Order Administrator', 'P.O. Box 78934', 'New Orleans', 'LA', '70117', 'USA', '(100) 555-4822', NULL, '#CAJUN.HTM#'),
(3, 'Grandma Kellys Homestead', 'Regina Murphy', 'Sales Representative', '707 Oxford Rd.', 'Ann Arbor', 'MI', '48104', 'USA', '(313) 555-5735', '(313) 555-3349', NULL),
(4, 'Tokyo Traders', 'Yoshi Nagase', 'Marketing Manager', '9-8 Sekimai Musashino-shi', 'Tokyo', NULL, '100', 'Japan', '(03) 3555-5011', NULL, NULL),
(5, 'Cooperativa de Quesos Las Cabras', 'Antonio del Valle Saavedra', 'Export Administrator', 'Calle del Rosal 4', 'Oviedo', 'Asturias', '33007', 'Spain', '(98) 598 76 54', NULL, NULL),
(6, 'Mayumis', 'Mayumi Ohno', 'Marketing Representative', '92 Setsuko Chuo-ku', 'Osaka', NULL, '545', 'Japan', '(06) 431-7877', NULL, 'Mayumis (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/mayumi.htm#'),
(7, 'Pavlova, Ltd.', 'Ian Devling', 'Marketing Manager', '74 Rose St. Moonie Ponds', 'Melbourne', 'Victoria', '3058', 'Australia', '(03) 444-2343', '(03) 444-6588', NULL),
(8, 'Specialty Biscuits, Ltd.', 'Peter Wilson', 'Sales Representative', '29 Kings Way', 'Manchester', NULL, 'M14 GSD', 'UK', '(161) 555-4448', NULL, NULL),
(9, 'PB Knäckebröd AB', 'Lars Peterson', 'Sales Agent', 'Kaloadagatan 13', 'Göteborg', NULL, 'S-345 67', 'Sweden', '031-987 65 43', '031-987 65 91', NULL),
(10, 'Refrescos Americanas LTDA', 'Carlos Diaz', 'Marketing Manager', 'Av. das Americanas 12.890', 'São Paulo', NULL, '5442', 'Brazil', '(11) 555 4640', NULL, NULL),
(11, 'Heli Süßwaren GmbH & Co. KG', 'Petra Winkler', 'Sales Manager', 'Tiergartenstraße 5', 'Berlin', NULL, '10785', 'Germany', '(010) 9984510', NULL, NULL),
(12, 'Plutzer Lebensmittelgroßmärkte AG', 'Martin Bein', 'International Marketing Mgr.', 'Bogenallee 51', 'Frankfurt', NULL, '60439', 'Germany', '(069) 992755', NULL, 'Plutzer (on the World Wide Web)#http://www.microsoft.com/accessdev/sampleapps/plutzer.htm#'),
(13, 'Nord-Ost-Fisch Handelsgesellschaft mbH', 'Sven Petersen', 'Coordinator Foreign Markets', 'Frahmredder 112a', 'Cuxhaven', NULL, '27478', 'Germany', '(04721) 8713', '(04721) 8714', NULL),
(14, 'Formaggi Fortini s.r.l.', 'Elio Rossi', 'Sales Representative', 'Viale Dante, 75', 'Ravenna', NULL, '48100', 'Italy', '(0544) 60323', '(0544) 60603', '#FORMAGGI.HTM#'),
(15, 'Norske Meierier', 'Beate Vileid', 'Marketing Manager', 'Hatlevegen 5', 'Sandvika', NULL, '1320', 'Norway', '(0)2-953010', NULL, NULL),
(16, 'Bigfoot Breweries', 'Cheryl Saylor', 'Regional Account Rep.', '3400 - 8th Avenue Suite 210', 'Bend', 'OR', '97101', 'USA', '(503) 555-9931', NULL, NULL),
(17, 'Svensk Sjöföda AB', 'Michael Björn', 'Sales Representative', 'Brovallavägen 231', 'Stockholm', NULL, 'S-123 45', 'Sweden', '08-123 45 67', NULL, NULL),
(18, 'Aux joyeux ecclésiastiques', 'Guylène Nodier', 'Sales Manager', '203, Rue des Francs-Bourgeois', 'Paris', NULL, '75004', 'France', '(1) 03.83.00.68', '(1) 03.83.00.62', NULL),
(19, 'New England Seafood Cannery', 'Robb Merchant', 'Wholesale Account Agent', 'Order Processing Dept. 2100 Paul Revere Blvd.', 'Boston', 'MA', '02134', 'USA', '(617) 555-3267', '(617) 555-3389', NULL),
(20, 'Leka Trading', 'Chandra Leka', 'Owner', '471 Serangoon Loop, Suite #402', 'Singapore', NULL, '0512', 'Singapore', '555-8787', NULL, NULL);

-- Dane do tabeli Products (77 produktów)
INSERT INTO Products VALUES
(1, 'Chai', 1, 1, '10 boxes x 20 bags', 18.00, 39, 0, 10, false),
(2, 'Chang', 1, 1, '24 - 12 oz bottles', 19.00, 17, 40, 25, false),
(3, 'Aniseed Syrup', 1, 2, '12 - 550 ml bottles', 10.00, 13, 70, 25, false),
(4, 'Chef Antons Cajun Seasoning', 2, 2, '48 - 6 oz jars', 22.00, 53, 0, 0, false),
(5, 'Chef Antons Gumbo Mix', 2, 2, '36 boxes', 21.35, 0, 0, 0, true),
(6, 'Grandmas Boysenberry Spread', 3, 2, '12 - 8 oz jars', 25.00, 120, 0, 25, false),
(7, 'Uncle Bobs Organic Dried Pears', 3, 7, '12 - 1 lb pkgs.', 30.00, 15, 0, 10, false),
(8, 'Northwoods Cranberry Sauce', 3, 2, '12 - 12 oz jars', 40.00, 6, 0, 0, false),
(9, 'Mishi Kobe Niku', 4, 6, '18 - 500 g pkgs.', 97.00, 29, 0, 0, true),
(10, 'Ikura', 4, 8, '12 - 200 ml jars', 31.00, 31, 0, 0, false),
(11, 'Queso Cabrales', 5, 4, '1 kg pkg.', 21.00, 22, 30, 30, false),
(12, 'Queso Manchego La Pastora', 5, 4, '10 - 500 g pkgs.', 38.00, 86, 0, 0, false),
(13, 'Konbu', 6, 8, '2 kg box', 6.00, 24, 0, 5, false),
(14, 'Tofu', 6, 7, '40 - 100 g pkgs.', 23.25, 35, 0, 0, false),
(15, 'Genen Shouyu', 6, 2, '24 - 250 ml bottles', 15.50, 39, 0, 5, false),
(16, 'Pavlova', 7, 3, '32 - 500 g boxes', 17.45, 29, 0, 10, false),
(17, 'Alice Mutton', 7, 6, '20 - 1 kg tins', 39.00, 0, 0, 0, true),
(18, 'Carnarvon Tigers', 7, 8, '16 kg pkg.', 62.50, 42, 0, 0, false),
(19, 'Teatime Chocolate Biscuits', 8, 3, '10 boxes x 12 pieces', 9.20, 25, 0, 5, false),
(20, 'Sir Rodneys Marmalade', 8, 3, '30 gift boxes', 81.00, 40, 0, 0, false),
(21, 'Sir Rodneys Scones', 8, 3, '24 pkgs. x 4 pieces', 10.00, 3, 40, 5, false),
(22, 'Gustafs Knäckebröd', 9, 5, '24 - 500 g pkgs.', 21.00, 104, 0, 25, false),
(23, 'Tunnbröd', 9, 5, '12 - 250 g pkgs.', 9.00, 61, 0, 25, false),
(24, 'Guaraná Fantástica', 10, 1, '12 - 355 ml cans', 4.50, 20, 0, 0, true),
(25, 'NuNuCa Nuß-Nougat-Creme', 11, 3, '20 - 450 g glasses', 14.00, 76, 0, 30, false),
(26, 'Gumbär Gummibärchen', 11, 3, '100 - 250 g bags', 31.23, 15, 0, 0, false),
(27, 'Schoggi Schokolade', 11, 3, '100 - 100 g pieces', 43.90, 49, 0, 30, false),
(28, 'Rössle Sauerkraut', 12, 7, '25 - 825 g cans', 45.60, 26, 0, 0, true),
(29, 'Thüringer Rostbratwurst', 12, 6, '50 bags x 30 sausgs.', 123.79, 0, 0, 0, true),
(30, 'Nord-Ost Matjeshering', 13, 8, '10 - 200 g glasses', 25.89, 10, 0, 15, false),
(31, 'Gorgonzola Telino', 14, 4, '12 - 100 g pkgs', 12.50, 0, 70, 20, false),
(32, 'Mascarpone Fabioli', 14, 4, '24 - 200 g pkgs.', 32.00, 9, 40, 25, false),
(33, 'Geitost', 15, 4, '500 g', 2.50, 112, 0, 20, false),
(34, 'Sasquatch Ale', 16, 1, '24 - 12 oz bottles', 14.00, 111, 0, 15, false),
(35, 'Steeleye Stout', 16, 1, '24 - 12 oz bottles', 18.00, 20, 0, 15, false),
(36, 'Inlagd Sill', 17, 8, '24 - 250 g jars', 19.00, 112, 0, 20, false),
(37, 'Gravad lax', 17, 8, '12 - 500 g pkgs.', 26.00, 11, 50, 25, false),
(38, 'Côte de Blaye', 18, 1, '12 - 75 cl bottles', 263.50, 17, 0, 15, false),
(39, 'Chartreuse verte', 18, 1, '750 cc per bottle', 18.00, 69, 0, 5, false),
(40, 'Boston Crab Meat', 19, 8, '24 - 4 oz tins', 18.40, 123, 0, 30, false),
(41, 'Jacks New England Clam Chowder', 19, 8, '12 - 12 oz cans', 9.65, 85, 0, 10, false),
(42, 'Singaporean Hokkien Fried Mee', 20, 5, '32 - 1 kg pkgs.', 14.00, 26, 0, 0, true),
(43, 'Ipoh Coffee', 20, 1, '16 - 500 g tins', 46.00, 17, 10, 25, false),
(44, 'Gula Malacca', 20, 2, '20 - 2 kg bags', 19.45, 27, 0, 15, false),
(45, 'Rogede sild', 21, 8, '1k pkg.', 9.50, 5, 70, 15, false),
(46, 'Spegesild', 21, 8, '4 - 450 g glasses', 12.00, 95, 0, 0, false),
(47, 'Zaanse koeken', 22, 3, '10 - 4 oz boxes', 9.50, 36, 0, 0, false),
(48, 'Chocolade', 22, 3, '10 pkgs.', 12.75, 15, 70, 25, false),
(49, 'Maxilaku', 23, 3, '24 - 50 g pkgs.', 20.00, 10, 60, 15, false),
(50, 'Valkoinen suklaa', 23, 3, '12 - 100 g bars', 16.25, 65, 0, 30, false),
(51, 'Manjimup Dried Apples', 24, 7, '50 - 300 g pkgs.', 53.00, 20, 0, 10, false),
(52, 'Filo Mix', 24, 5, '16 - 2 kg boxes', 7.00, 38, 0, 25, false),
(53, 'Perth Pasties', 24, 6, '48 pieces', 32.80, 0, 0, 0, true),
(54, 'Tourtière', 25, 6, '16 pies', 7.45, 21, 0, 10, false),
(55, 'Pâté chinois', 25, 6, '24 boxes x 2 pies', 24.00, 115, 0, 20, false),
(56, 'Gnocchi di nonna Alice', 26, 5, '24 - 250 g pkgs.', 38.00, 21, 10, 30, false),
(57, 'Ravioli Angelo', 26, 5, '24 - 250 g pkgs.', 19.50, 36, 0, 20, false),
(58, 'Escargots de Bourgogne', 27, 8, '24 pieces', 13.25, 62, 0, 20, false),
(59, 'Raclette Courdavault', 28, 4, '5 kg pkg.', 55.00, 79, 0, 0, false),
(60, 'Camembert Pierrot', 28, 4, '15 - 300 g rounds', 34.00, 19, 0, 0, false),
(61, 'Sirop dérable', 29, 2, '24 - 500 ml bottles', 28.50, 113, 0, 25, false),
(62, 'Tarte au sucre', 29, 3, '48 pies', 49.30, 17, 0, 0, false),
(63, 'Vegie-spread', 7, 2, '15 - 625 g jars', 43.90, 24, 0, 5, false),
(64, 'Wimmers gute Semmelknödel', 12, 5, '20 bags x 4 pieces', 33.25, 22, 80, 30, false),
(65, 'Louisiana Fiery Hot Pepper Sauce', 2, 2, '32 - 8 oz bottles', 21.05, 76, 0, 0, false),
(66, 'Louisiana Hot Spiced Okra', 2, 2, '24 - 8 oz jars', 17.00, 4, 100, 20, false),
(67, 'Laughing Lumberjack Lager', 16, 1, '24 - 12 oz bottles', 14.00, 52, 0, 10, false),
(68, 'Scottish Longbreads', 8, 3, '10 boxes x 8 pieces', 12.50, 6, 10, 15, false),
(69, 'Gudbrandsdalsost', 15, 4, '10 kg pkg.', 36.00, 26, 0, 15, false),
(70, 'Outback Lager', 7, 1, '24 - 355 ml bottles', 15.00, 15, 10, 30, false),
(71, 'Flotemysost', 15, 4, '10 - 500 g pkgs.', 21.50, 26, 0, 0, false),
(72, 'Mozzarella di Giovanni', 14, 4, '24 - 200 g pkgs.', 34.80, 14, 0, 0, false),
(73, 'Röd Kaviar', 17, 8, '24 - 150 g jars', 15.00, 101, 0, 5, false),
(74, 'Longlife Tofu', 4, 7, '5 kg pkg.', 10.00, 4, 20, 5, false),
(75, 'Rhönbräu Klosterbier', 12, 1, '24 - 0.5 l bottles', 7.75, 125, 0, 25, false),
(76, 'Lakkalikööri', 23, 1, '500 ml', 18.00, 57, 0, 20, false),
(77, 'Original Frankfurter grüne Soße', 12, 2, '12 boxes', 13.00, 32, 0, 15, false);

-- Dane do tabeli Customers (91 klientów - pierwsze 20)
INSERT INTO Customers VALUES
('ALFKI', 'Alfreds Futterkiste', 'Maria Anders', 'Sales Representative', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany', '030-0074321', '030-0076545'),
('ANATR', 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Owner', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico', '(5) 555-4729', '(5) 555-3745'),
('ANTON', 'Antonio Moreno Taquería', 'Antonio Moreno', 'Owner', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico', '(5) 555-3932', NULL),
('AROUT', 'Around the Horn', 'Thomas Hardy', 'Sales Representative', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK', '(171) 555-7788', '(171) 555-6750'),
('BERGS', 'Berglunds snabbköp', 'Christina Berglund', 'Order Administrator', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden', '0921-12 34 65', '0921-12 34 67'),
('BLAUS', 'Blauer See Delikatessen', 'Hanna Moos', 'Sales Representative', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany', '0621-08460', '0621-08924'),
('BLONP', 'Blondesddsl père et fils', 'Frédérique Citeaux', 'Marketing Manager', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France', '88.60.15.31', '88.60.15.32'),
('BOLID', 'Bólido Comidas preparadas', 'Martín Sommer', 'Owner', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain', '(91) 555 22 82', '(91) 555 91 99'),
('BONAP', 'Bon app', 'Laurence Lebihan', 'Owner', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France', '91.24.45.40', '91.24.45.41'),
('BOTTM', 'Bottom-Dollar Markets', 'Elizabeth Lincoln', 'Accounting Manager', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada', '(604) 555-4729', '(604) 555-3745'),
('BSBEV', 'B''s Beverages', 'Victoria Ashworth', 'Sales Representative', 'Fauntleroy Circus', 'London', NULL, 'EC2 5NT', 'UK', '(171) 555-1212', NULL),
('CACTU', 'Cactus Comidas para llevar', 'Patricio Simpson', 'Sales Agent', 'Cerrito 333', 'Buenos Aires', NULL, '1010', 'Argentina', '(1) 135-5555', '(1) 135-4892'),
('CENTC', 'Centro comercial Moctezuma', 'Francisco Chang', 'Marketing Manager', 'Sierras de Granada 9993', 'México D.F.', NULL, '05022', 'Mexico', '(5) 555-3392', '(5) 555-7293'),
('CHOPS', 'Chop-suey Chinese', 'Yang Wang', 'Owner', 'Hauptstr. 29', 'Bern', NULL, '3012', 'Switzerland', '0452-076545', NULL),
('COMMI', 'Comércio Mineiro', 'Pedro Afonso', 'Sales Associate', 'Av. dos Lusíadas, 23', 'São Paulo', 'SP', '05432-043', 'Brazil', '(11) 555-7647', NULL),
('CONSH', 'Consolidated Holdings', 'Elizabeth Brown', 'Sales Representative', 'Berkeley Gardens 12 Brewery', 'London', NULL, 'WX1 6LT', 'UK', '(171) 555-2282', '(171) 555-9199'),
('DRACD', 'Drachenblut Delikatessen', 'Sven Ottlieb', 'Order Administrator', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany', '0241-039123', '0241-059428'),
('DUMON', 'Du monde entier', 'Janine Labrune', 'Owner', '67, rue des Cinquante Otages', 'Nantes', NULL, '44000', 'France', '40.67.88.88', '40.67.89.89'),
('EASTC', 'Eastern Connection', 'Ann Devon', 'Sales Agent', '35 King George', 'London', NULL, 'WX3 6FW', 'UK', '(171) 555-0297', '(171) 555-3373'),
('ERNSH', 'Ernst Handel', 'Roland Mendel', 'Sales Manager', 'Kirchgasse 6', 'Graz', NULL, '8010', 'Austria', '7675-3425', '7675-3426');

-- Dane do tabeli Employees (9 pracowników)
INSERT INTO Employees VALUES
(1, 'Davolio', 'Nancy', 'Sales Representative', 'Ms.', '1948-12-08', '1992-05-01', '507 - 20th Ave. E. Apt. 2A', 'Seattle', 'WA', '98122', 'USA', '(206) 555-9857', '5467', 'Education includes a BA in psychology from Colorado State University in 1970.', 2, 'http://accweb/emmployees/davolio.bmp'),
(2, 'Fuller', 'Andrew', 'Vice President, Sales', 'Dr.', '1952-02-19', '1992-08-14', '908 W. Capital Way', 'Tacoma', 'WA', '98401', 'USA', '(206) 555-9482', '3457', 'Andrew received his BTS commercial in 1974 and a Ph.D. in international marketing from the University of Dallas in 1981.', NULL, 'http://accweb/emmployees/fuller.bmp'),
(3, 'Leverling', 'Janet', 'Sales Representative', 'Ms.', '1963-08-30', '1992-04-01', '722 Moss Bay Blvd.', 'Kirkland', 'WA', '98033', 'USA', '(206) 555-3412', '3355', 'Janet has a BS degree in chemistry from Boston College (1984).', 2, 'http://accweb/emmployees/leverling.bmp'),
(4, 'Peacock', 'Margaret', 'Sales Representative', 'Mrs.', '1937-09-19', '1993-05-03', '4110 Old Redmond Rd.', 'Redmond', 'WA', '98052', 'USA', '(206) 555-8122', '5176', 'Margaret holds a BA in English literature from Concordia College (1958) and an MA from the American Institute of Culinary Arts (1966).', 2, 'http://accweb/emmployees/peacock.bmp'),
(5, 'Buchanan', 'Steven', 'Sales Manager', 'Mr.', '1955-03-04', '1993-10-17', '14 Garrett Hill', 'London', NULL, 'SW1 8JR', 'UK', '(71) 555-4848', '3453', 'Steven Buchanan graduated from St. Andrews University, Scotland, with a BSC degree in 1976.', 2, 'http://accweb/emmployees/buchanan.bmp'),
(6, 'Suyama', 'Michael', 'Sales Representative', 'Mr.', '1963-07-02', '1993-10-17', 'Coventry House Miner Rd.', 'London', NULL, 'EC2 7JR', 'UK', '(71) 555-7773', '428', 'Michael is a graduate of Sussex University (MA, economics, 1983) and the University of California at Los Angeles (MBA, marketing, 1986).', 5, 'http://accweb/emmployees/davolio.bmp'),
(7, 'King', 'Robert', 'Sales Representative', 'Mr.', '1960-05-29', '1994-01-02', 'Edgeham Hollow Winchester Way', 'London', NULL, 'RG1 9SP', 'UK', '(71) 555-5598', '465', 'Robert King served in the Peace Corps and traveled extensively before completing his degree in English at the University of Michigan in 1992.', 5, 'http://accweb/emmployees/davolio.bmp'),
(8, 'Callahan', 'Laura', 'Inside Sales Coordinator', 'Ms.', '1958-01-09', '1994-03-05', '4726 - 11th Ave. N.E.', 'Seattle', 'WA', '98105', 'USA', '(206) 555-1189', '2344', 'Laura received a BA in psychology from the University of Washington.', 2, 'http://accweb/emmployees/davolio.bmp'),
(9, 'Dodsworth', 'Anne', 'Sales Representative', 'Ms.', '1966-01-27', '1994-11-15', '7 Houndstooth Rd.', 'London', NULL, 'WG2 7LT', 'UK', '(71) 555-4444', '452', 'Anne has a BA degree in English from St. Lawrence College.', 5, 'http://accweb/emmployees/davolio.bmp');

-- Dane do tabeli Shippers
INSERT INTO Shippers VALUES
(1, 'Speedy Express', '(503) 555-9831'),
(2, 'United Package', '(503) 555-3199'),
(3, 'Federal Shipping', '(503) 555-9931');

-- Dane do tabeli Orders (przykładowe 50 zamówień)
INSERT INTO Orders VALUES
(10248, 'ALFKI', 5, '1996-07-04 00:00:00', '1996-08-01 00:00:00', '1996-07-16 00:00:00', 3, 32.38, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
(10249, 'ANATR', 6, '1996-07-05 00:00:00', '1996-08-16 00:00:00', '1996-07-10 00:00:00', 1, 11.61, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10250, 'ANTON', 4, '1996-07-08 00:00:00', '1996-08-05 00:00:00', '1996-07-12 00:00:00', 2, 65.83, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
(10251, 'AROUT', 3, '1996-07-08 00:00:00', '1996-08-05 00:00:00', '1996-07-15 00:00:00', 1, 41.34, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
(10252, 'BERGS', 4, '1996-07-09 00:00:00', '1996-08-06 00:00:00', '1996-07-11 00:00:00', 2, 51.30, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10253, 'BLAUS', 3, '1996-07-10 00:00:00', '1996-07-24 00:00:00', '1996-07-16 00:00:00', 2, 58.17, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany'),
(10254, 'BLONP', 5, '1996-07-11 00:00:00', '1996-08-08 00:00:00', '1996-07-23 00:00:00', 2, 22.98, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10255, 'BOLID', 9, '1996-07-12 00:00:00', '1996-08-09 00:00:00', '1996-07-15 00:00:00', 3, 148.33, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain'),
(10256, 'BONAP', 3, '1996-07-15 00:00:00', '1996-08-12 00:00:00', '1996-07-17 00:00:00', 2, 13.97, 'Bon app', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10257, 'BOTTM', 4, '1996-07-16 00:00:00', '1996-08-13 00:00:00', '1996-07-22 00:00:00', 3, 81.91, 'Bottom-Dollar Markets', '23 Tsawassen Blvd.', 'Tsawassen', 'BC', 'T2F 8M4', 'Canada'),
(10258, 'ERNSH', 1, '1996-07-17 00:00:00', '1996-08-14 00:00:00', '1996-07-23 00:00:00', 1, 140.51, 'Ernst Handel', 'Kirchgasse 6', 'Graz', NULL, '8010', 'Austria'),
(10259, 'CENTC', 4, '1996-07-18 00:00:00', '1996-08-15 00:00:00', '1996-07-25 00:00:00', 3, 3.25, 'Centro comercial Moctezuma', 'Sierras de Granada 9993', 'México D.F.', NULL, '05022', 'Mexico'),
(10260, 'AROUT', 4, '1996-07-19 00:00:00', '1996-08-16 00:00:00', '1996-07-29 00:00:00', 1, 55.09, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
(10261, 'ALFKI', 4, '1996-07-19 00:00:00', '1996-08-16 00:00:00', '1996-07-30 00:00:00', 2, 3.05, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
(10262, 'ANATR', 8, '1996-07-22 00:00:00', '1996-08-19 00:00:00', '1996-07-25 00:00:00', 3, 48.29, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10263, 'ERNSH', 9, '1996-07-23 00:00:00', '1996-08-20 00:00:00', '1996-07-31 00:00:00', 3, 146.06, 'Ernst Handel', 'Kirchgasse 6', 'Graz', NULL, '8010', 'Austria'),
(10264, 'BLONP', 6, '1996-07-24 00:00:00', '1996-08-21 00:00:00', '1996-08-23 00:00:00', 3, 3.67, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10265, 'BLONP', 2, '1996-07-25 00:00:00', '1996-08-22 00:00:00', '1996-08-12 00:00:00', 1, 55.28, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10266, 'BONAP', 3, '1996-07-26 00:00:00', '1996-09-06 00:00:00', '1996-07-31 00:00:00', 3, 25.73, 'Bon app', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10267, 'DRACD', 4, '1996-07-29 00:00:00', '1996-08-26 00:00:00', '1996-08-06 00:00:00', 1, 208.58, 'Drachenblut Delikatessen', 'Walserweg 21', 'Aachen', NULL, '52066', 'Germany'),
(10268, 'BERGS', 8, '1996-07-30 00:00:00', '1996-08-27 00:00:00', '1996-08-02 00:00:00', 3, 66.29, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10269, 'BLAUS', 5, '1996-07-31 00:00:00', '1996-08-14 00:00:00', '1996-08-09 00:00:00', 1, 4.56, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany'),
(10270, 'BONAP', 1, '1996-08-01 00:00:00', '1996-08-29 00:00:00', '1996-08-02 00:00:00', 1, 136.54, 'Bon app', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10271, 'ALFKI', 6, '1996-08-01 00:00:00', '1996-08-29 00:00:00', '1996-08-30 00:00:00', 2, 4.54, 'Alfreds Futterkiste', 'Obere Str. 57', 'Berlin', NULL, '12209', 'Germany'),
(10272, 'ANATR', 6, '1996-08-02 00:00:00', '1996-08-30 00:00:00', '1996-08-06 00:00:00', 2, 98.03, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10273, 'ANTON', 3, '1996-08-05 00:00:00', '1996-09-02 00:00:00', '1996-08-12 00:00:00', 3, 76.07, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
(10274, 'AROUT', 6, '1996-08-06 00:00:00', '1996-09-03 00:00:00', '1996-08-16 00:00:00', 1, 6.01, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
(10275, 'BLONP', 1, '1996-08-07 00:00:00', '1996-09-04 00:00:00', '1996-08-09 00:00:00', 1, 26.93, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10276, 'BOLID', 8, '1996-08-08 00:00:00', '1996-08-22 00:00:00', '1996-08-15 00:00:00', 3, 13.84, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain'),
(10277, 'BONAP', 2, '1996-08-09 00:00:00', '1996-09-06 00:00:00', '1996-08-13 00:00:00', 3, 125.77, 'Bon app', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10278, 'BERGS', 8, '1996-08-12 00:00:00', '1996-09-09 00:00:00', '1996-08-16 00:00:00', 2, 92.69, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10279, 'BLAUS', 8, '1996-08-13 00:00:00', '1996-09-10 00:00:00', '1996-08-16 00:00:00', 2, 25.83, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany'),
(10280, 'BERGS', 2, '1996-08-14 00:00:00', '1996-09-11 00:00:00', '1996-09-12 00:00:00', 1, 8.98, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10281, 'ANATR', 4, '1996-08-14 00:00:00', '1996-08-28 00:00:00', '1996-08-21 00:00:00', 1, 2.94, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10282, 'ANATR', 4, '1996-08-15 00:00:00', '1996-09-12 00:00:00', '1996-08-21 00:00:00', 1, 12.69, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10283, 'BLONP', 3, '1996-08-16 00:00:00', '1996-09-13 00:00:00', '1996-08-23 00:00:00', 3, 84.81, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10284, 'BOLID', 4, '1996-08-19 00:00:00', '1996-09-16 00:00:00', '1996-08-27 00:00:00', 1, 76.56, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain'),
(10285, 'ANTON', 1, '1996-08-20 00:00:00', '1996-09-17 00:00:00', '1996-08-26 00:00:00', 2, 76.83, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
(10286, 'ANTON', 8, '1996-08-21 00:00:00', '1996-09-18 00:00:00', '1996-08-30 00:00:00', 3, 229.24, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
(10287, 'BLONP', 8, '1996-08-22 00:00:00', '1996-09-19 00:00:00', '1996-08-28 00:00:00', 3, 12.76, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10288, 'BERGS', 4, '1996-08-23 00:00:00', '1996-09-20 00:00:00', '1996-09-03 00:00:00', 1, 7.45, 'Berglunds snabbköp', 'Berguvsvägen 8', 'Luleå', NULL, 'S-958 22', 'Sweden'),
(10289, 'BLAUS', 7, '1996-08-26 00:00:00', '1996-09-23 00:00:00', '1996-08-28 00:00:00', 3, 22.77, 'Blauer See Delikatessen', 'Forsterstr. 57', 'Mannheim', NULL, '68306', 'Germany'),
(10290, 'COMMI', 8, '1996-08-27 00:00:00', '1996-09-24 00:00:00', '1996-09-03 00:00:00', 1, 79.70, 'Comércio Mineiro', 'Av. dos Lusíadas, 23', 'São Paulo', 'SP', '05432-043', 'Brazil'),
(10291, 'ANTON', 6, '1996-08-27 00:00:00', '1996-09-24 00:00:00', '1996-09-04 00:00:00', 2, 6.27, 'Antonio Moreno Taquería', 'Mataderos 2312', 'México D.F.', NULL, '05023', 'Mexico'),
(10292, 'BONAP', 1, '1996-08-28 00:00:00', '1996-09-25 00:00:00', '1996-09-02 00:00:00', 2, 1.35, 'Bon app', '12, rue des Bouchers', 'Marseille', NULL, '13008', 'France'),
(10293, 'BOLID', 1, '1996-08-29 00:00:00', '1996-09-26 00:00:00', '1996-09-11 00:00:00', 3, 21.18, 'Bólido Comidas preparadas', 'C/ Araquil, 67', 'Madrid', NULL, '28023', 'Spain'),
(10294, 'ANATR', 4, '1996-08-30 00:00:00', '1996-09-27 00:00:00', '1996-09-05 00:00:00', 2, 147.26, 'Ana Trujillo Emparedados y helados', 'Avda. de la Constitución 2222', 'México D.F.', NULL, '05021', 'Mexico'),
(10295, 'AROUT', 2, '1996-09-02 00:00:00', '1996-09-30 00:00:00', '1996-09-10 00:00:00', 2, 1.15, 'Around the Horn', '120 Hanover Sq.', 'London', NULL, 'WA1 1DP', 'UK'),
(10296, 'BLONP', 6, '1996-09-03 00:00:00', '1996-10-01 00:00:00', '1996-09-11 00:00:00', 1, 0.12, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France'),
(10297, 'BLONP', 5, '1996-09-04 00:00:00', '1996-10-16 00:00:00', '1996-09-10 00:00:00', 2, 5.74, 'Blondesddsl père et fils', '24, place Kléber', 'Strasbourg', NULL, '67000', 'France');

-- Dane do tabeli Order Details (przykładowe szczegóły zamówień)
INSERT INTO `Order Details` VALUES
(10248, 11, 14.00, 12, 0.00),
(10248, 42, 9.80, 10, 0.00),
(10248, 72, 34.80, 5, 0.00),
(10249, 14, 18.60, 9, 0.00),
(10249, 51, 42.40, 40, 0.00),
(10250, 41, 7.70, 10, 0.00),
(10250, 51, 42.40, 35, 0.15),
(10250, 65, 16.80, 15, 0.15),
(10251, 22, 16.80, 6, 0.05),
(10251, 57, 15.60, 15, 0.05),
(10252, 20, 64.80, 40, 0.05),
(10252, 33, 2.00, 25, 0.05),
(10252, 60, 27.20, 40, 0.00),
(10253, 31, 10.00, 20, 0.00),
(10253, 39, 14.40, 42, 0.00),
(10253, 49, 16.00, 40, 0.00),
(10254, 24, 3.60, 15, 0.15),
(10254, 55, 19.20, 21, 0.15),
(10254, 74, 8.00, 21, 0.00),
(10255, 2, 15.20, 20, 0.00),
(10255, 16, 13.90, 35, 0.00),
(10255, 36, 15.20, 25, 0.00),
(10255, 59, 44.00, 30, 0.00),
(10256, 53, 26.20, 15, 0.00),
(10256, 77, 10.40, 12, 0.00),
(10257, 27, 35.10, 25, 0.00),
(10257, 39, 14.40, 6, 0.00),
(10257, 77, 10.40, 15, 0.00),
(10258, 2, 15.20, 50, 0.20),
(10258, 5, 17.00, 65, 0.20),
(10258, 32, 25.60, 6, 0.20),
(10259, 21, 8.00, 10, 0.00),
(10259, 37, 20.80, 1, 0.00),
(10260, 41, 7.70, 16, 0.25),
(10260, 57, 15.60, 50, 0.00),
(10260, 62, 39.40, 15, 0.25),
(10260, 70, 12.00, 21, 0.25),
(10261, 21, 8.00, 20, 0.00),
(10261, 35, 14.40, 20, 0.00),
(10262, 5, 17.00, 12, 0.20),
(10262, 7, 24.00, 15, 0.00),
(10262, 56, 30.40, 2, 0.00),
(10263, 16, 13.90, 60, 0.25),
(10263, 24, 3.60, 28, 0.00),
(10263, 30, 20.70, 60, 0.25),
(10263, 74, 8.00, 36, 0.25),
(10264, 2, 15.20, 35, 0.00),
(10264, 41, 7.70, 25, 0.15),
(10265, 17, 31.20, 30, 0.00),
(10265, 70, 12.00, 20, 0.00);

-- =====================================================
-- WERYFIKACJA DANYCH
-- =====================================================

-- Sprawdzenie liczby rekordów w tabelach
SELECT 'Categories' as table_name, COUNT(*) as record_count FROM Categories
UNION ALL
SELECT 'Suppliers', COUNT(*) FROM Suppliers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Shippers', COUNT(*) FROM Shippers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order Details', COUNT(*) FROM `Order Details`;

-- =====================================================
-- UWAGI DOTYCZĄCE UŻYCIA W DATABRICKS
-- =====================================================
-- 1. Ten skrypt tworzy tabele w formacie Delta Lake (USING DELTA)
-- 2. Databricks nie obsługuje kluczy obcych (FOREIGN KEY) - zostały pominięte
-- 3. Typy danych zostały dostosowane do Spark SQL:
--    - NVARCHAR -> STRING
--    - MONEY -> DECIMAL(10,2)
--    - BIT -> BOOLEAN
--    - DATETIME -> TIMESTAMP
--    - SMALLINT -> INT
-- 4. Aby uruchomić skrypt w notebooku Databricks, użyj komendy:
--    %sql
--    [treść skryptu]
-- 5. Dane są przykładowe i uproszczone - w pełnej bazie Northwind jest więcej rekordów
-- 6. Do kompletnej bazy danych można dodać więcej zamówień i klientów według potrzeb

-- =====================================================
-- KONIEC SKRYPTU
-- =====================================================
