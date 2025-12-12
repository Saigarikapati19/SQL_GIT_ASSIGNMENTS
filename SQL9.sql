--LEN()
SELECT LEN('SQL Server') AS LengthResult;

--CONCAT()
SELECT CONCAT('Hello ', 'World') AS FullText;

--REPLACE()
SELECT REPLACE('SQL SERVER TRAINING', 'SERVER', 'Database') AS NewText;

--SUBSTRING()
SELECT SUBSTRING('Microsoft SQL Server', 11, 3) AS ExtractedText;



select SUBSTRING('helloworld',2,3)

 --UPPER()
SELECT UPPER('sql server') AS UpperCaseText;

-- LOWER()
SELECT LOWER('SQL SERVER') AS LowerCaseText;

-- RIGHT()
SELECT RIGHT('SQLSERVER', 6) AS LastCharacters;

--LEFT()
SELECT LEFT('DATABASE', 4) AS FirstCharacters;

SELECT * FROM Sales

--MAX()
SELECT MAX(SaleAmount) AS MaxAmount FROM Sales;

--MIN()
SELECT MIN(SaleAmount) AS MinAmount FROM Sales;

-- SUM()
SELECT SUM(SaleAmount) AS TotalAmount FROM Sales;

--COUNT()
SELECT COUNT(*) AS TotalRows FROM Sales;

-- AVG()
SELECT AVG(SaleAmount) AS AverageAmount FROM Sales;

-- Numeric Functions
--SQRT()
SELECT SQRT(144) AS SquareRoot;

-- ROUND()
SELECT ROUND(123.4567, 2) AS RoundedValue;
-- Output: 123.46

 select POWER(2, 3);
-- Output: 8

-- RAND()
SELECT RAND() AS RandomNumber;       -- Random number between 0 and 1

------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
--CAST FUNCTIONS AND CONVERT FUNCTIONS
DECLARE  @x INT
SET @x= 10
--PRINT 'YOU HAVE ENTERED ' + CAST(@x AS VARCHAR)  CAST
PRINT 'YOU HAVE ENTERED' + CONVERT(VARCHAR(10),@X)  --CONVERT

-------FORMATING
DECLARE @a DATE
SET @a= '1-1-2000'
--PRINT 'YOU HAVE ENTERED' + CAST(@a AS VARCHAR)
PRINT 'YOU HAVE ENTERED ' + CONVERT(VARCHAR(10),@a,101)
PRINT 'YOU HAVE ENTERED ' + CONVERT(VARCHAR(10),@a,102)
PRINT 'YOU HAVE ENTERED ' + CONVERT(VARCHAR(10),@a,103)
PRINT 'YOU HAVE ENTERED ' + CONVERT(VARCHAR(10),@a,104)
PRINT 'YOU HAVE ENTERED ' + CONVERT(VARCHAR(10),@a,105)

------------SCALAR FUNCTION
CREATE FUNCTION FN_SS (@a INT, @B INT)
RETURNS INT
AS
BEGIN
DECLARE @c INT
SET @c = @a * @b 
RETURN @c
END

SELECT dbo.FN_SS(19,18)