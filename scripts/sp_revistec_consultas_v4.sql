/*
Proyect II: RevisTEC (SQL Server 2017)

Bases de Datos, Área Acádemica de Ingenería en Computadores

Semestre II, 2017

Members:
	Ricardo Chang Villalobos - 2014040801
	Gustavo Fallas Carrera - 2014035394
	Pablo García Brenes - 2015083681
	Randy Martínez Sandí - 2014047395

Index:
	1- Declaration of SPs, SFs and triggers.
    2- Executing the SPs and SFs.
*/

-- Creation of the database --
USE revistec;
GO

----------Start: Declaration of SPs, SFs and triggers.----------

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Reads all clients
-- =============================================
CREATE PROCEDURE sp_getAllClients
AS 
BEGIN
	DECLARE @XML AS XML;
    DECLARE @hDoc AS INT;
    DECLARE @SQL NVARCHAR (MAX);

    SELECT @XML = XMLData FROM Client
    EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

    SELECT IdClient, Name, Address
    FROM OPENXML(@hDoc, 'ROOT/Clients/Client')
    WITH 
    (
    IdClient [varchar](50) '@IdClient',
    Name [varchar](100) '@Name',
    Address [varchar](100) 'Address'
    )
    EXEC sp_xml_removedocument @hDoc
END
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Add new magazine
-- =============================================
CREATE PROCEDURE sp_addMagazine
(
	@name varchar(256),
	@price int,
	@date Date,
	@idMagazine INT OUTPUT
)
AS
BEGIN
	DECLARE @idOutput table ( ID int );


	INSERT INTO Magazine(Name, Price, EditionDate) 
	OUTPUT Inserted.IdMagazine INTO @idOutput
	VALUES (@name, @price, @date);

	SET @idMagazine = (SELECT ID FROM @idOutput);
	
RETURN
END
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Add Address
-- =============================================
CREATE PROCEDURE sp_addAddress
(
	@country VARCHAR(256),
	@province VARCHAR(256),
	@city VARCHAR(256),
	@zipCode int,
	@idAddress int OUTPUT
)
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @idOutput table ( ID int );

	INSERT INTO Address(Country, Province, City, ZipCode)
	OUTPUT Inserted.IdAddress INTO @idOutput
	VALUES(@country, @province, @city, @zipCode);

	SET @idAddress = (SELECT ID FROM @idOutput);
	COMMIT TRANSACTION
RETURN 
END
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Add Local
-- =============================================
CREATE PROCEDURE sp_addLocal
(	
	@name VARCHAR(256),
	@country VARCHAR(256),
	@province VARCHAR(256),
	@city VARCHAR(256),
	@zipCode int,
	@idLocal int OUTPUT
)
AS
BEGIN

	BEGIN TRANSACTION 

	DECLARE @idOutput table ( ID int );
	DECLARE @idAddress int

	EXEC sp_addAddress @country, @province, @city, @zipCode, @idAddress = @idAddress OUTPUT;
	
	INSERT INTO Local(Name, IdAddress)
	OUTPUT Inserted.IdLocal INTO @idOutput
	VALUES(@name, @idAddress);

	SET @idLocal = (SELECT ID FROM @idOutput);
	COMMIT TRANSACTION
RETURN
END
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Add Client
-- =============================================
CREATE PROCEDURE sp_addClient
(	
	@name VARCHAR(256),
	@idClient INT OUTPUT
)
AS
BEGIN
	DECLARE @idOutput table ( ID int );

	INSERT INTO Client(Name)
	OUTPUT Inserted.IdClient INTO @idOutput
	VALUES(@name);

	SET @idClient = (SELECT ID FROM @idOutput);
RETURN
END
GO

-- =============================================
-- Author:	All members
-- Create date:  -	-
-- Description:	Add Contract
-- =============================================
CREATE PROCEDURE sp_addContract
(
	@nameClient VARCHAR(256),
	@deliveryRecurrence INT,
	@Payment int,
	@PayRecurrence int,
	@amountLocal INT,
	@nameLocal VARCHAR(256),
	@country VARCHAR(256),
	@province VARCHAR(256),
	@city VARCHAR(256),
	@zipCode int,
	@nameMagazine VARCHAR(256),
	@priceMagazine INT,
	@EditionDate Date
)
AS
BEGIN TRY 
	
	BEGIN TRANSACTION 

	DECLARE @idLocal INT;
	DECLARE @idClient INT;
	DECLARE @idMagazine INT;

	EXEC sp_addLocal @nameLocal, @country, @province, @city, @zipCode, @idLocal = @idLocal OUTPUT;
		
	EXEC sp_addClient @nameClient, @idClient = @idClient OUTPUT;

	EXEC sp_addMagazine @nameMagazine, @priceMagazine, @EditionDate, @idMagazine = @idMagazine OUTPUT;

	INSERT INTO Client_Magazine_Local(IdClient, IdMagazine, IdLocal, DeliveryRecurrence)
	VALUES(@idClient, @idMagazine, @idLocal, @deliveryRecurrence);

	INSERT INTO Contract(IdClient, Payment, PayRecurrence, AmountLocal)
	VALUES(@idClient, @Payment, @PayRecurrence, @amountLocal);
	
	COMMIT TRANSACTION
END TRY


BEGIN CATCH
	-- Determine if an error occurred.  
  IF @@TRANCOUNT > 0  
     ROLLBACK TRANSACTION;

  -- Return the error information.  
  DECLARE @ErrorMessage nvarchar(4000),  @ErrorSeverity int;  
  SELECT @ErrorMessage = ERROR_MESSAGE(),@ErrorSeverity = ERROR_SEVERITY();  
  RAISERROR(@ErrorMessage, @ErrorSeverity, 1); 
 

END CATCH
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	View Contract
-- =============================================  
CREATE VIEW view_contract 
AS	
	SELECT Client.Name AS NombreCliente, Magazine.Name AS NombreRevista, Local.Name AS NombreLocal, Address.ZipCode AS Code
	FROM Client
	INNER JOIN Client_Magazine_Local ON Client_Magazine_Local.IdClient = Client.IdClient
	INNER JOIN Magazine ON Magazine.IdMagazine = Client_Magazine_Local.IdMagazine
	INNER JOIN Local ON Local.IdLocal = Client_Magazine_Local.IdLocal
	INNER JOIN Address ON Address.IdAddress = Local.IdAddress;
GO

-- =============================================
-- Author:nAll members
-- Create date:  -	-
-- Description:	Get Id Local
-- =============================================  
CREATE FUNCTION sf_getIdLocal
(
	@name VARCHAR(256)
)
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @idLocal int;

	SET @idLocal = (SELECT idLocal 
					FROM Local L
					WHERE L.Name = @name);
	
	RETURN (@idLocal);
END
GO 

-- =============================================
-- Author:		All members
-- Create date: --
-- Description:	Get Best Employee Local
				-- Consulta
				-- 4 JOINS 
				-- 2 Funciones agregadas
				-- 3 Subqueries 
				-- 1 CASE 
				-- 1 CONVERT
				-- 1 ORDER BY 
				-- 1 Funcion  
				-- Someterla a SEEP (Show Estimated Execution Plan)
-- =============================================
CREATE PROCEDURE sp_getBestEmployeeLocal
(
	@nameLocal VARCHAR(256)
)
AS
BEGIN
SELECT TOP 1 NameEmployee, NameMagazine, MAX(AmountMagazine) AS Amount
FROM
	(
		SELECT NameEmployee, NameMagazine, COUNT(NameMagazine) AS AmountMagazine
		FROM
			(
				SELECT  (Convert(nvarchar(50),P.FirstName) + '  ' + Convert(nvarchar(50),P.LastName)) AS NameEmployee, E.SSN AS SsnEmployee,
				(M.Name) AS NameMagazine --, R.ArriveDate AS YearRegister
				FROM Person P
				INNER JOIN Employee E ON P.IdPerson = E.IdPerson 
				INNER JOIN Register R ON E.IdEmployee = R.IdEmployee 
				INNER JOIN Client_Magazine_Local CML 
				INNER JOIN Local L ON CML.IdLocal = L.IdLocal
				INNER JOIN Magazine M ON CML.IdMagazine = M.IdMagazine ON R.IdLocal = L.IdLocal
				WHERE L.IdLocal  = (SELECT [dbo].[sf_getIdLocal](@nameLocal))
			)
		AS Result1
		GROUP BY NameEmployee, NameMagazine
	)
	AS Result2
	GROUP BY NameEmployee, NameMagazine
	ORDER BY Amount DESC;	
END
GO

-- =============================================
-- Author: All members
-- Create date:  -	-
-- Description:	Bill - Collect money in local
-- =============================================
CREATE PROCEDURE sp_collectInLocal
(
	@nameLocal VARCHAR(256)
)
AS
BEGIN

	DECLARE @amount INT;
	SET @amount = (
					SELECT SUM(M.Price)
					FROM  Client_Magazine_Local  CML
					INNER JOIN Local L ON CML.IdLocal = L.IdLocal 
					INNER JOIN Magazine M ON CML.IdMagazine = M.IdMagazine 
					INNER JOIN Register R ON L.IdLocal = R.IdLocal
					WHERE L.Name = @nameLocal AND MONTH(R.ArriveDate) = MONTH(GETUTCDATE()) - 1
					AND YEAR(R.ArriveDate) = YEAR(GETUTCDATE())
				  );

	Print 'Bill  RevisTEC'
	Print 'Date: ' + RTRIM(CONVERT(Date, GETUTCDATE())) 
	Print '----------------' + CHAR(13)
	Print 'Payment date: ' + RTRIM(YEAR(GETUTCDATE()))+ '/'+RTRIM(MONTH(GETUTCDATE()) - 1)
	Print 'Local: ' + RTRIM(@nameLocal)
	Print 'Total Price: ₡' + RTRIM(@amount)
END
GO

-- =============================================
-- Author: All members
-- Create date: -	-
-- Description:	Bill - Collect money  from contract/client
-- =============================================
CREATE PROCEDURE sp_collectContract
(
	@nameClient VARCHAR(256)
)
AS
BEGIN
	DECLARE @idClient INT;
	DECLARE @amount INT;
	DECLARE @XML AS XML;
	DECLARE @hDoc AS INT;
	DECLARE @SQL NVARCHAR (MAX);
	SELECT @XML = XMLData FROM Client
	EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

	SET @idClient = (SELECT IdClient
					FROM OPENXML(@hDoc, 'ROOT/Clients/Client')
					WITH 
					(
					IdClient [varchar](50) '@IdClient',
					Name [varchar](100) '@Name'
					)
					WHERE Name = 'La Nacion'
					);
	EXEC sp_xml_removedocument @hDoc

	SET @amount = (SELECT Payment FROM Contract
					WHERE IdClient = @idClient);

	Print 'Bill  RevisTEC'
	Print 'Date: ' + RTRIM(CONVERT(Date, GETUTCDATE())) 
	Print '----------------' + CHAR(13)
	Print 'Client: ' + RTRIM('La Nacion')
	Print 'Total Amount: ₡' + RTRIM(@amount)
END
GO

-- =============================================
-- Author: All members
-- Create date: -	-
-- Description:	Bill - Collect money from All Local
				--	Use Cursor Global | Local
-- =============================================
-- Declaración del cursor 
CREATE PROCEDURE sp_createCursorGlobal
AS
BEGIN
	DECLARE cursorBillLocal CURSOR GLOBAL FOR SELECT L.Name ,SUM(M.Price), COUNT(M.Name)
	FROM  Client_Magazine_Local  CML
	INNER JOIN Local L ON CML.IdLocal = L.IdLocal 
	INNER JOIN Magazine M ON CML.IdMagazine = M.IdMagazine 
	INNER JOIN Register R ON L.IdLocal = R.IdLocal
	WHERE YEAR(R.ArriveDate) >= 2009 and YEAR(R.ArriveDate) <= 2010
	GROUP BY L.Name
END
GO

CREATE PROCEDURE sp_readCursorGlobal
AS
BEGIN
	DECLARE @totalPrice INT, @amountMagazine INT, @nameLocal VARCHAR(256);
	OPEN cursorBillLocal  
	FETCH cursorBillLocal INTO @nameLocal, @totalPrice, @amountMagazine;
	PRINT 'Bill All Local RevisTEC'
	PRINT 'Date: 2009 - 2010'
	PRINT '-----------------------' +  CHAR(13)
	WHILE(@@FETCH_STATUS= 0) 
	BEGIN 
		PRINT 'Local Name: ' + @nameLocal + ' Total Price: ' + RTRIM(@totalPrice) + ' Amount Magazine: ' + RTRIM(@amountMagazine) 
		FETCH cursorBillLocal INTO @nameLocal, @totalPrice, @amountMagazine;
	END 
	CLOSE cursorBillLocal;
	DEALLOCATE cursorBillLocal;
END
GO

-- =============================================
-- Author:		All members
-- Create date: -	-
-- Description:	Delete Magazine Local
--				Use TRIGGER | MERGE | EXECUTE AS
-- =============================================
CREATE TRIGGER deleteMagazine
ON Client_Magazine_Local
FOR DELETE AS
BEGIN
	PRINT 'Notify Executing trigger. Rows affected: ' + RTRIM(@@ROWCOUNT);
	
	IF EXISTS (SELECT 1 FROM deleted)
	  BEGIN
		PRINT 'Erasing a magazine';
	  END
	ELSE
	  BEGIN
		PRINT 'Magazine does not exist';
	  END
END
GO

-- =============================================
-- Author: All members
-- Create date: -	-
-- Description:	Delete Magazine
-- =============================================
CREATE PROCEDURE sp_deleteMagazine
(
	@nameMagazine VARCHAR(256),
	@nameLocal VARCHAR(256)
)
WITH EXECUTE AS OWNER
AS	
	MERGE Client_Magazine_Local WITH (HOLDLOCK)  AS CML
	USING (SELECT M.IdMagazine AS idMagazine, L.IdLocal As idLocal
			FROM Magazine M, Local L
			WHERE M.Name = @nameMagazine AND L.Name = @nameLocal) AS source(idMagazine, idLocal)
	ON (CML.IdMagazine = source.idMagazine AND CML.IdLocal = source.idLocal)
	WHEN MATCHED THEN 
		DELETE;
GO

---------------------------------------------------------
/* Query - Use AVG | SUBSTRING | LTRIM */
SELECT  U.Email, AVG(M.Price) AS Price, LTRIM(CONCAT('       Email: ', SUBSTRING(U.Email, 9,4)))
FROM  Magazine M 
INNER JOIN Subscipstions S ON M.IdMagazine = S.IdMagazine 
INNER JOIN Users U ON S.IdUser = U.IdUser
GROUP BY U.Email
ORDER BY Price;
---------------------------------------------------------
/* Query - Use UNION | DISTINCT | TOP */
SELECT * FROM (SELECT DISTINCT TOP 1 P.FirstName, P.LastName, (SELECT COUNT(Register.IdEmployee) FROM Register
										WHERE Register.IdEmployee = E.IdEmployee) AS Amount
			FROM  Employee E 
			INNER JOIN Person P ON E.IdPerson = P.IdPerson 
			INNER JOIN Role R ON E.IdRole = R.IdRole 
			INNER JOIN Register Re ON Re.IdEmployee = E.IdEmployee
			ORDER BY Amount DESC
			)AS Result1
UNION
SELECT * FROM (SELECT DISTINCT TOP 1 P.FirstName AS Name, P.LastName, (SELECT COUNT(Subscipstions.IdUser) FROM Subscipstions
												WHERE Subscipstions.IdUser = U.IdUser) AS Amount
			FROM Person P 
			INNER JOIN Users U ON P.IdPerson = U.IdPerson
			INNER JOIN Subscipstions S ON U.IdUser = S.IdUser
			ORDER BY Amount DESC
			)AS Resutl2;
---------------------------------------------------------
----------End: Declaration of SPs, SFs and triggers.----------

----------Start:  Executing the SPs and SFs.----------

EXEC sp_getBestEmployeeLocal 'Local5';

EXEC sp_collectInLocal 'Local5';

EXEC sp_collectContract 'La Nacion';


EXEC sp_createCursorGlobal;
EXEC sp_readCursorGlobal;

EXEC sp_deleteMagazine 'Life', 'Local1';

----------End:  Executing the SPs and SFs..----------
