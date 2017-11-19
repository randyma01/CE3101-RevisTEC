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
    3- LLenado de tablas por medio de los SPs  
*/

-- Creation of the database --
CREATE DATABASE revistec;

-- Change to revistec --
USE revistec;

----------Start: Creating tables----------

-- Table for Clients -- 
CREATE TABLE Client(
	IdClient INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	CliName VARCHAR(256) NOT NULL
	--IdDirrecion
);

-- Table for Magazines -- 
CREATE TABLE Magazine(
	IdMagazine INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	MagName VARCHAR(256) NOT NULL,
	MagPice INT NOT NULL,
	MagEditionDate DATE NOT NULL,
);

-- Table for Addresses of the Magazines -- 
CREATE TABLE Addressm(
	IdAddress INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Country VARCHAR(256) NOT NULL,
	Province VARCHAR(256) NOT NULL,
	City VARCHAR(256) NOT NULL,
	ZipCode INTEGER NOT NULL,
);

-- Table for the Routes for the Magazines -- 
CREATE TABLE Routem(
	IdRoute INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RouteName VARCHAR(256) NOT NULL,
	StartTime DATETIME NOT NULL,
);

-- Table for the Roles for the Persons -- 
CREATE TABLE Rolep(
	IdRole INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RoleName VARCHAR(256) NOT NULL,	
);

-- Table for the Local --
CREATE TABLE Local(
	IdLocal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	LocalName VARCHAR(256) NOT NULL,
	IdAddress INT NOT NULL,
	FOREIGN KEY (IdAddress) REFERENCES Addressm(IdAddress)
);

-- Table for Contracts for each Client --
CREATE TABLE Contract(
	IdContract INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdClient INT NOT NULL,	
	Payment INT NOT NULL,
	PayRecurrence INT NOT NULL,
	FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);

-- Table for the Persons -- 
CREATE TABLE Person(
	IdPerson INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(256) NOT NULL,	
	LastName VARCHAR(256) NOT NULL,	
	Gender VARCHAR (256) NOT NULL, --Gender ENUM("M", "F"),
	BirthDate DATE NOT NULL,
);

-- Table for Employee of RevisTEC --
CREATE TABLE Employee(
	IdEmployee INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	SSN INT NOT NULL,	
	IdRole INT NOT NULL,
	IdPerson INT NOT NULL,
	PhoneNumber INT NOT NULL,
	FOREIGN KEY (IdRole) REFERENCES Rolep(IdRole),
	FOREIGN KEY (IdPerson) REFERENCES Person(IdPerson)
);

-- Table for the Users --
CREATE TABLE Users(
	IdUser INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdPerson INT NOT NULL,
	Email VARCHAR(256) NOT NULL,
	Password VARCHAR(256) NOT NULL,
	BankAccount INT NOT NULL,
	FOREIGN KEY (IdPerson) REFERENCES Person(IdPerson)
);

-- Table for the Register--
CREATE TABLE Register(
	IdRegistry INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	RegisterName VARCHAR(256) NOT NULL,
	IdEmployee INT NOT NULL,
	IdLocal INT NOT NULL,
	ArriveDate DATETIME,
    FOREIGN KEY (IdEmployee) REFERENCES Employee(IdEmployee),
    FOREIGN KEY (IdLocal) REFERENCES Local (IdLocal)
);

/*Revisar esta tabla y comparar con clientlocal*/

-- Table of Client and Magazine --  
CREATE TABLE Client_Magazine_Local(
	IdClient INT NOT NULL,
	IdMagazine INT NOT NULL,
	IdLocal INT NOT NULL,
	FOREIGN KEY (IdLocal) REFERENCES Local(IdLocal),
    FOREIGN KEY (IdMagazine) REFERENCES Magazine(IdMagazine),
    FOREIGN KEY (IdClient) REFERENCES Client(IdClient)
);

-- Table of Route and Address -- 
CREATE TABLE Route_Address(
	IdRoute INT NOT NULL,
	IdAddress INT NOT NULL,
    FOREIGN KEY (IdRoute) REFERENCES Routem(IdRoute),
    FOREIGN KEY (IdAddress) REFERENCES Addressm(IdAddress)
);
---------- End: Creating Tables----------


---------- Start: Filling tables by bulkcopy----------

-- Filling Person table -- 
BULK INSERT Person
FROM 'C:\Users\Administrator\Desktop\Persona.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Employee table -- 
BULK INSERT Employee
FROM 'C:\Users\Administrator\Desktop\Empleado.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Addressm table -- 
BULK INSERT Addressm
FROM 'C:\Users\Administrator\Desktop\Dirreccion.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Magazine table --
BULK INSERT Magazine
FROM 'C:\Users\Administrator\Desktop\Revista.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Users table --
BULK INSERT Users
FROM 'C:\Users\Administrator\Desktop\Usuarios.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Local table --
BULK INSERT Local
FROM 'C:\Users\Administrator\Desktop\Local.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Roles table --
BULK INSERT Rolep
FROM 'C:\Users\Administrator\Desktop\Local.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

-- Filling Routem table --
BULK INSERT Routem
FROM 'C:\Users\Administrator\Desktop\Ruta.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO


-- Filling Client table --
BULK INSERT Client
FROM 'C:\Users\Administrator\Desktop\Clientes.txt'
WITH
(
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a'
)
GO

---------- End: Filling tables by bulkcopy -------------

--- testing -- 
SELECT * FROM PERSON;