---Isolation Level Read Uncommited
Create Table test
(
cid int,
cname varchar(20)
)
insert into test values(19,'Ajay'),
						(20,'Vijay')
select * from test

--window 1
select * from test where cid=19
waitfor delay '00:00:10' 
select * from test where cid=19

--window 2
begin transaction
update test set cname='Manideep' 
where cid=20
select * from test

---Isolation Level Read Commited.
select * from test where cid=19
waitfor delay '00:00:10'
select * from test where cid=19

--window 2
begin transaction
update test set cname='Navadeep' 
where cid=19
----------ASSIGNMENTS----------------------------------------
select * from Employees
SELECT * FROM Transactions
SELECT * FROM Sales
SELECT * FROM Departments
SELECT * FROM Customer
--1--Create a table BankAccount with sample records. 
--Write a transaction that transfers money from one account to another. 
--If the source account balance becomes negative, roll back the transaction; otherwise commit.
CREATE TABLE Bank (
    AccountNo INT PRIMARY KEY,
    HolderName VARCHAR(100),
    Balance DECIMAL(10,2)
);
INSERT INTO Bank VALUES 
(10, 'VI', 19000),
(11, 'SP', 7000),
(12, 'SH', 3000);
 SELECT * FROM Bank
Declare @Transformoney Decimal(10,2)=5000;
Declare @SourceAc int=10;
Declare @TargetAc int=11;
 
Begin Transaction
Update Bank Set Balance=Balance-@Transformoney where AccountNo=@SourceAc;
 
Declare @CurrentBalance Decimal(10,2);
Select @CurrentBalance=Balance From Bank where AccountNo=@SourceAc;
 

If(@CurrentBalance<0)
Begin 
print @CurrentBalance;
   Print'Error: Insufficient Balance.Transaction Rolled Back';
   Rollback
End
Else
Begin
   Update Bank Set Balance =Balance+@Transformoney where AccountNo=@TargetAc;
   Print 'Transaction Successfully.Money Transefered';
   Commit;
End
-------------------------------------------------------------------------------------------
--Insert three new records into a table Orders. 
--Create a SAVEPOINT after each insert. 
--rollback only the second insert using the SAVEPOINT, then commit the remaining inserts.
CREATE TABLE Orderss (
     OrderID INT PRIMARY KEY,
     CustomerName VARCHAR(100),
     Amount DECIMAL(10,2)
     );
Begin Transaction;
insert into Orderss values(10011,'CHARAN',1200.0);
Save Transaction Save1;
insert into Orderss values(1002,'KATA',1500.0);
Save Transaction Save2;
insert into Orderss values(1003,'SAB',1800.0);
Save Transaction Save3;
Rollback Transaction Save1;
insert into Orderss values(1004,'THARUN',1800.0);
Commit;
SELECT * FROM Orderss
--------------------------------------------------------------------------------------------------
--Write a transaction that updates prices in a Products table. 
--Introduce a division-by-zero error inside the transaction. 
--Use TRY…CATCH to rollback the transaction and log the error message in a separate 
--ErrorLog table
create table logs
(
logid int identity(1,1),
errormessage varchar(100),
errordate date
)
select * from logs
begin try
begin transaction
update Bank set Balance = Balance + 800 where AccountNo = 10
declare @n int = 10/0
commit transaction
end try
begin catch
rollback transaction
insert into logs values(error_message(),getdate())
print 'Error Occured : '+error_message()
end catch
------------------------------------------------------------
--Create nested transactions: 
--Outer transaction inserts a customer 
--Inner transaction inserts an order for the customer 
--Force an error in the inner transaction 
--Practice observing whether the outer transaction is committed or rolled back.
CREATE TABLE Customers1 (
    CustomerID INT IDENTITY PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL
);
CREATE TABLE Orders1 (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderAmount DECIMAL(10,2) NOT NULL
);
Select * from Customers1
Select * from Orders1

 begin transaction
 insert into customers1 (customername)values('SAI')
 declare  @customerid int = scope_identity()
 begin transaction
begin try
insert into Orders1(customerid,OrderAmount)values(@customerid,2900)
declare @y int =1/0
commit transaction
 commit transaction
  end try
    begin catch
    rollback transaction
     print 'Rolled back the entire transaction due to inner error: ' + ERROR_MESSAGE();
    end catch
