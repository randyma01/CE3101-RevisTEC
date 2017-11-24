/*
Proyect II: RevisTEC (SQL Server 2017)

Bases de Datos, Área Acádemica de Ingenería en Computadores

Semestre II, 2017

Miembros:
	Ricardo Chang Villalobos - 2014040801
	Gustavo Fallas Carrera - 2014035394
	Pablo García Brenes - 2015083681
	Randy Martínez Sandí - 2014047395

Index:
	1- Creation of tables.
    2- Declaracion de SFs.
    3- Executing the SP's.
*/

-- Creation of the database --
CREATE DATABASE revistec;
GO

-- Change to revistec --
USE revistec;
GO

----------Start: Creating tables----------

-- Table for Clients -- 
CREATE TABLE Client(
	IdClient INT IDENTITY PRIMARY KEY,
	Name VARCHAR(256),
	Address VARCHAR(256)
);
GO

-- Table for Magazines -- 
CREATE TABLE Magazine(
	IdMagazine INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(256) NOT NULL,
	Price INT NOT NULL,
	EditionDate DATE NOT NULL,
);
GO

-- Table for Addresses of the Magazines -- 
CREATE TABLE Address(
	IdAddress INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Country VARCHAR(256) NOT NULL,
	Province VARCHAR(256) NOT NULL,
	City VARCHAR(256) NOT NULL,
	ZipCode INTEGER NOT NULL,
);
GO

-- Table for the Routes for the Magazines -- 
CREATE TABLE Route(
	IdRoute INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(256) NOT NULL,
	StartTime DATETIME NOT NULL,
);
GO

-- Table for the Roles for the Persons -- 
CREATE TABLE Role(
	IdRole INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(256) NOT NULL,	
);
GO

-- Table for the Local --
CREATE TABLE Local(
	IdLocal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(256) NOT NULL,
	IdAddress INT NOT NULL,
	FOREIGN KEY (IdAddress) REFERENCES Address(IdAddress)
);
GO

-- Table for Contracts for each Client --
CREATE TABLE Contract(
	IdContract INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdClient INT NOT NULL,	
	Payment INT NOT NULL,
	PayRecurrence INT NOT NULL,
	AmountLocal INT,
	FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);
GO

-- Table for the Persons -- 
CREATE TABLE Person(
	IdPerson INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(256) NOT NULL,	
	LastName VARCHAR(256) NOT NULL,	
	Gender VARCHAR (256) NOT NULL,
	BirthDate DATE NOT NULL,
);
GO

-- Table for Employee of RevisTEC --
CREATE TABLE Employee(
	IdEmployee INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SSN INT NOT NULL,	
	IdRole INT NOT NULL,
	IdPerson INT NOT NULL,
	PhoneNumber INT NOT NULL,
	FOREIGN KEY (IdRole) REFERENCES Role(IdRole),
	FOREIGN KEY (IdPerson) REFERENCES Person(IdPerson)
);
GO

-- Table for the Users --
CREATE TABLE Users(
	IdUser INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdPerson INT NOT NULL,
	Email VARCHAR(256) NOT NULL,
	Password VARCHAR(256) NOT NULL,
	BankAccount INT NOT NULL,
	FOREIGN KEY (IdPerson) REFERENCES Person(IdPerson)
);
GO

-- Table for the Register--
CREATE TABLE Register(
	IdRegistry INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdEmployee INT NOT NULL,
	IdLocal INT NOT NULL,
	ArriveDate DATETIME,
    FOREIGN KEY (IdEmployee) REFERENCES Employee(IdEmployee),
    FOREIGN KEY (IdLocal) REFERENCES Local (IdLocal)
);
GO

/*Revisar esta tabla y comparar con clientlocal*/

-- Table of Client and Magazine --  
CREATE TABLE Client_Magazine_Local(
	IdClient INT NOT NULL,
	IdMagazine INT NOT NULL,
	IdLocal INT NOT NULL,
	DeliveryRecurrence INT NOT NULL,
    FOREIGN KEY (IdMagazine) REFERENCES Magazine(IdMagazine),
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient),
	FOREIGN KEY (IdLocal) REFERENCES Local(IdLocal)
);
GO

-- Table of Route and Address -- 
CREATE TABLE Route_Address(
	IdRoute INT NOT NULL,
	IdAddress INT NOT NULL,
    FOREIGN KEY (IdRoute) REFERENCES Route(IdRoute),
    FOREIGN KEY (IdAddress) REFERENCES Address(IdAddress)
);
GO

-- Table of Subscription of User for digital Magazine --
CREATE TABLE Subscriptions(
	IdUser INT NOT NULL, 
	IdMagazine INT NOT NULL, 
	FOREIGN KEY (IdUser) REFERENCES Users(IdUser),
	FOREIGN KEY (IdMagazine) REFERENCES Magazine(IdMagazine)
);
GO

-- Table of Order Client of Collect Magazine from Client --
CREATE TABLE Order_Client(
	IdEmployee INT NOT NULL,
	IdMagazine INT NOT NULL,
	IdClient INT NOT NULL,
	AmountMagazine INT NOT NULL,
	FOREIGN KEY (IdEmployee) REFERENCES Employee(IdEmployee),
	FOREIGN KEY (IdMagazine) REFERENCES Magazine(IdMagazine),
	FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);
GO

---------- End: Creating Tables----------

---------- Start: Filling tables by bulkcopy----------

-----------------------------------------------------------------
CREATE PROCEDURE sp_allTableFill
AS
BEGIN

-- Filling Person table -- 
    BULK INSERT Person
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Person.txt'
    WITH
    ( 
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Employee table -- 
    BULK INSERT Employee
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Employee.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Address table -- 
    BULK INSERT Address
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Address.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Magazine table --    
    BULK INSERT Magazine
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Magazine.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Users table --
    BULK INSERT Users
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Users.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )
   
-- Filling Local table --
    BULK INSERT Local
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Local.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Roles table --
    BULK INSERT Role
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Role.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

-- Filling Route table --
    BULK INSERT Route
    FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Route.txt'
    WITH
    (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
    )

	BULK INSERT Register
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Register.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)

	BULK INSERT Client_Magazine_Local
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\CML.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)
	BULK INSERT Contract
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Contract.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)
	BULK INSERT Route_Address
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\RouteAddress.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)
	BULK INSERT Subscriptions
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Subscriptions.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)
	BULK INSERT Order_Client
	FROM 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\OrderClient.txt'
	WITH
	(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a'
	)
END
GO

-- Filling Client table --
CREATE PROCEDURE sp_xmlFill
AS
BEGIN 
    DECLARE @xmlData XML;
	SET @xmlData = (SELECT * FROM OPENROWSET (BULK 'T:\2017\II S 2017\CE -  3101\Proyecto Final\txt data\Clients.xml', SINGLE_CLOB) AS x); 

	INSERT INTO Client(Name, Address)
	SELECT 
	C.cl.value('(Name)[1]', 'VARCHAR(256)') Name,
	C.Cl.value('(Address)[1]', 'VARCHAR(256)') Address
	FROM @xmlData.nodes('/Clients/Client') as C(cl);
END 
GO

---------- End: SPs for bulkcopy the tables.-------------


---------- Start: Executing the SPs for bulkcopy the tables.-------------

EXEC sp_allTableFill; 
GO
EXEC sp_xmlFill;
GO
---------- End: Executing the SPs for bulkcopy the tables.-------------
