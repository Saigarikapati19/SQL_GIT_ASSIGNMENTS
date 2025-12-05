create table Customers( 
    CustID INT PRIMARY KEY, 
    CustName VARCHAR(100), 
    Email VARCHAR(200), 
    City VARCHAR(100) 
)
INSERT INTO Customers (CustID, CustName, Email, City) VALUES
(1, 'Amit Sharma', 'amit.sharma@gmail.com', 'Mumbai'),
(2, 'Ravi Kumar', 'ravi.kumar@yahoo.com', 'Delhi'),
(3, 'Priya Singh', 'priya.singh@gmail.com', 'Pune'),
(4, 'John Mathew', 'john.mathew@hotmail.com', 'Bangalore'),
(5, 'Sara Thomas', 'sara.thomas@gmail.com', 'Kochi'),
(6, 'Nidhi Jain', 'nidhi.jain@gmail.com', NULL);
select * from Customers
 -----------------------------------------------------------------
 create table Products( 
    ProductID INT PRIMARY KEY, 
    ProductName VARCHAR(100), 
    Price DECIMAL(10,2), 
    Stock INT CHECK(Stock >= 0) 
)
INSERT INTO Products (ProductID, ProductName, Price, Stock) VALUES
(101, 'Laptop Pro 14', 75000, 15),
(102, 'Laptop Air 13', 55000, 8),
(103, 'Wireless Mouse', 800, 50),
(104, 'Mechanical Keyboard', 3000, 20),
(105, 'USB-C Charger', 1200, 5),
(106, '27-inch Monitor', 18000, 10),
(107, 'Pen Drive 64GB', 600, 80);
select * from Products
---------------------------------------------------------------------------------------
create table Orderss( 
    OrderID INT PRIMARY KEY, 
    CustID INT FOREIGN KEY REFERENCES Customers(CustID), 
    OrderDate DATE, 
    Status VARCHAR(20) 
) 
INSERT INTO Orderss(OrderID, CustID, OrderDate, Status) VALUES
(5001, 1, '2025-01-05', 'Pending'),
(5002, 2, '2025-01-10', 'Completed'),
(5003, 1, '2025-01-20', 'Completed'),
(5004, 3, '2025-02-01', 'Pending'),
(5005, 4, '2025-02-15', 'Completed'),
(5006, 5, '2025-02-18', 'Pending');
select * from Orderss
-------------------------------------------------------------------------------------------
create table OrderDetails( 
    DetailID INT PRIMARY KEY, 
    OrderID INT FOREIGN KEY REFERENCES Orderss(OrderID), 
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID), 
    Qty INT CHECK(Qty > 0) 
)
INSERT INTO OrderDetails (DetailID, OrderID, ProductID, Qty) VALUES
(9001, 5001, 101, 1),
(9002, 5001, 103, 2),
 
(9003, 5002, 104, 1),
(9004, 5002, 103, 1),
 
(9005, 5003, 102, 1),
(9006, 5003, 105, 1),
(9007, 5003, 103, 3),
 
(9008, 5004, 106, 1),
 
(9009, 5005, 107, 4),
(9010, 5005, 104, 1),
 
(9011, 5006, 101, 1),
(9012, 5006, 107, 2);
select * from OrderDetails
-----------------------------------------------------------------------------------------------------------
create table Payments( 
    PaymentID INT PRIMARY KEY, 
    OrderID INT FOREIGN KEY REFERENCES Orderss(OrderID), 
    Amount DECIMAL(10,2), 
    PaymentDate DATE 
)
INSERT INTO Payments (PaymentID, OrderID, Amount, PaymentDate) VALUES
(7001, 5002, 3300, '2025-01-11'),
(7002, 5003, 62000, '2025-01-22'),
(7003, 5005, 4500, '2025-02-16');
select * from Payments
-------------------------------------------------------------------------------
select * from Products
select * from Orderss
select * from OrderDetails
select * from Payments
select * from Customers
--------------------------------------------------------------------------------
--1..List customers who placed an order in the last 30 days. 
select c.CustName from Customers c
join Orderss o on c.CustID = o.OrderID
where o.orderdate >= dateadd(day, -30, getdate());
-------------------------------------------------------------------
 --2..Display top 3 products that generated the highest total sales amount. (Use aggregate + joins)
select top 3 p.ProductName, sum(od.Qty * p.Price) as TotalSales
from Products p
join OrderDetails od on p.ProductID = od.ProductID
group by p.ProductName
order by TotalSales desc;
-------------------------------------------------------------------------
--3. For each city, show number of customers and total order count.
select 
c.City,
count(distinct  c.CustID) as NoOfCustomers,
count(o.OrderID) as TotalOrders
from Customers c
left join Orderss o on c.CustID = o.CustID
group by c.City
order by TotalOrders desc;
--------------------------------------------------------------
--4..Retrieve orders that contain more than 2 different products. 
select OrderID
from OrderDetails
group by OrderID
having count(distinct ProductID) > 2;
--------------------------------------------------------------------------------
--Show orders where total payable amount is greater than 10,000. 
--(Hint: SUM(Qty * Price)) 
select o.orderid, sum(od.qty * p.price) as ordertotal from Orderss o
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
group by o.orderid having sum(od.qty * p.price) > 10000;
----------------------------------------------------------------------------------------------
--6..  List customers who ordered the same product more than once.
select CustID, ProductID from Orderss o
join OrderDetails od on o.OrderID = od.OrderID
group by CustID, ProductID having count(*) > 1;
---------------------------------------------------------------------------
--7.. Display employee-wise order processing details 
--(Assume Orders table has EmployeeID column)
select c.CustID, c.CustName, count(o.OrderID) as OrderProcessing from Customers c
join Orderss o on c.CustID = o.CustID
group by c.CustID, c.CustName
order by OrderProcessing desc;
----------------------------------------------------------------------
---VIEWS-----
--Create a view vw_LowStockProducts 
--Show only products with stock < 5. 
--View should be WITH SCHEMABINDING and Encrypted
create view dbo.vw_LowStockProducts 
with schemabinding, encryption as
select p.ProductID,p.ProductName,p.Stock from dbo.products as p where p.stock > 5;

select * from dbo.vw_LowStockProducts;
-----------------------------------------------------------------------------------
--Functions
--Create a table-valued function: fn_GetCustomerOrderHistory(@CustID) 
--Return: OrderID, OrderDate, TotalAmount.
create function fn_GetCustomerOrderHistory (@custid int) 
returns table
as
return
(
    select o.OrderID, o.orderdate, sum(od.qty * p.price) as totalamount
    from Orderss o
    join orderdetails od on o.orderid = od.orderid
    join products p on od.productid = p.productid
    where o.custid = @custid
    group by o.orderid, o.orderdate
);
select * from fn_GetCustomerOrderHistory(1);
-----------------------------------------------------------------------
--2.Create a function fn_GetCustomerLevel(@CustID)  
--Total purchase > 1,00,000 ? "Platinum" 
-- 50,000–1,00,000 ? "Gold" 
--Else ? "Silver" 
create function  fn_GetCustomerLevel(@custid int) 
returns varchar(30) as
begin
declare @total decimal(10,2);
declare @Level varchar(30);
select @total = sum(od.qty * p.price) from Orderss o
join orderdetails od on o.orderid = od.orderid
join products p on od.productid = p.productid where o.custid = @custid;
if @total > 100000 return 'platinum';
if @total >= 50000 return 'gold';
return 'silver';
end;
select CustID, CustName, dbo.fn_GetCustomerLevel(1) as Level
from Customers;
--------------------------------------------------------------------------------------
----procedures
---1..-Create a stored procedure to update product price Rules: 
-- Old price must be logged in a PriceHistory table 
--New price must be > 0 
--If invalid, throw custom error. 
create procedure UpdatePrice
@ProductID int,
@NewPrice decimal(10,2)
as
begin
    
    If @NewPrice <= 0
    begin
        throw 50003, 'Invalid price. Price must be greater than 0.', 1;
        return;
    end
    insert into PriceHistory values (ProductID, OldPrice, ChangeDate)
    select ProductID, Price, getdate()
    from Products
    where ProductID = @ProductID;
    update Products
    set Price = @NewPrice
    where ProductID = @ProductID;
end;
exec UpdatePrice @ProductID = 8, @NewPrice = 8;

--create table PriceHistory
--(
  --  HisID int identity(1,1) primary key,
    --ProductID int not null,
    --OldPrice decimal(10,2) not null,
    --ChangeDate datetime not null default getdate()
--);
---------------------------------------------------------------------------------------------------
--2.. Create a procedure sp_SearchOrders 
--Search orders by: 
--Customer Name 
--City 
--Product Name 
--Date range 
--(Any parameter can be NULL ? Dynamic WHERE)
create procedure dbo.sp_SearchOrders
@CustomerName varchar(100) = null,
@city varchar(100) = null,
@ProductName varchar(100) = null,
@StartDate date = null,
@EndDate date = null
 as
begin
  set nocount on
 
  select
  o.OrderId,o.OrderDate,c.CustName,c.City,p.ProductName,od.Qty,p.Price
  as TotalAmount from Orderss o 
  join Customers c on o.CustId = c.CustId join OrderDetails od on o.OrderId = od.OrderId
  join Products p on od.ProductId = p.ProductId
  where(@CustomerName is null or c.CustName like '%' + @CustomerName + '%')
  and (@City is null or c.City like '%' + @city + '%')
  and (@ProductName is null or p.ProductName like '%' + @ProductName + '%' )
  and(@StartDate is null or o.OrderDate >= @StartDate)
  and (@EndDate is null or o.OrderDate <= @EndDate)
  order by o.OrderDate desc;
end
 
exec dbo.sp_SearchOrders @CustomerName = 'sara'
exec dbo.sp_SearchOrders @City = 'Kochi'
exec dbo.sp_SearchOrders @ProductName = 'monitor';
 
exec dbo.sp_SearchOrders @StartDate = '2025-01-10',@EndDate = '2025-02-05'
exec sp_SearchOrders;
----------------------------------------------------------------------------------------------
---Triggers
--Create a trigger on Products 
--Prevent deletion of a product if it is part of any OrderDetails.
create trigger dbo.trgg_products
on Products
instead of delete
as
begin
if exists (select 1 from deleted as d inner join dbo.orderdetails as od on od.productid = d.productid)
begin
throw 50010, 'cannot delete product(s): referenced in orderdetails.', 1;
return;
end
 delete p from dbo.products as p inner join deleted as d on d.productid = p.productid;
end;
select * from Products where ProductID = 101;
-------------------------------------------------------------------------------------------------------------
--2--- Create an AFTER UPDATE trigger on Payments 
--Log old and new payment values into a PaymentAudit table. 
create table PaymentAudit (
    AuditID int identity(1,1) primary key,
    PaymentID int,
    OldAmount decimal(10,2),
    NewAmount decimal(10,2),
    OldDate date,
    NewDate date,
    ChangedOn datetime default getdate()
);
 select * from PaymentAudit
create trigger trg_PaymentAudit
on Payments
after update
as
begin
     insert into PaymentAudit (PaymentID, OldAmount, NewAmount, OldDate, NewDate)
    select
        d.PaymentID,
        d.Amount as OldAmount,
        i.Amount as NewAmount,
        d.PaymentDate as OldDate,
        i.PaymentDate as NewDate
    from deleted d
    join inserted i on d.PaymentID = i.PaymentID;
end;
update Payments set Amount = 8500, PaymentDate = '2025-02-07' where PaymentID = 7001;
 

select * from PaymentAudit where PaymentID = 9003;
----------------------------------------------------------------------------------------
--Create an INSTEAD OF DELETE trigger on Customers 
--Logic: 
--If customer has orders ? mark status as “Inactive” instead of deleting 
-- If no orders ? allow deletion 
-- 1. Create the trigger
create trigger trg_CustDelControl
on Customers
instead of delete
as
begin
  set nocount on
  update Customers
    set City = 'Inactive'
  where CustId in(
  select d.CustId from deleted d join Orderss o on d.CustId = o.CustId
  )
 
  delete from Customers where CustId in(
  select d.CustId from deleted d
  where not exists(select 1 from Orderss o where o.CustId = d.CustId)
  )
  end
 
  delete from Customers where CustId = 3
  delete from Customers where CustId = 4

  select * from Customers
 