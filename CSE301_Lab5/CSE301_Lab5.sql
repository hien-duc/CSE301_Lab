-- Create and use the database
DROP DATABASE IF EXISTS SaleManagerment;
CREATE DATABASE SaleManagerment;
USE SaleManagerment;

-- Create Clients table
CREATE TABLE Clients (
    Client_Number VARCHAR(10) PRIMARY KEY CHECK (Client_Number LIKE 'C%'),
    Client_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25),
    Amount_Paid DECIMAL(15,4),
    Amount_Due DECIMAL(15,4)
);

-- Create Product table
CREATE TABLE Product (
    Product_Number VARCHAR(15) PRIMARY KEY CHECK (Product_Number LIKE 'P%'),
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Quantity_On_Hand INT NOT NULL,
    Quantity_Sell INT NOT NULL,
    Sell_Price DECIMAL(15,4) NOT NULL,
    Cost_Price DECIMAL(15,4) NOT NULL CHECK (Cost_Price != 0)
);

-- Create Salesman table
CREATE TABLE Salesman (
    Salesman_Number VARCHAR(15) PRIMARY KEY CHECK (Salesman_Number LIKE 'S%'),
    Salesman_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25) DEFAULT 'Vietnam',
    Salary DECIMAL(15,4) NOT NULL CHECK (Salary != 0),
    Sales_Target INT NOT NULL CHECK (Sales_Target != 0),
    Target_Achieved INT,
    Phone CHAR(10) NOT NULL UNIQUE
);

-- Create SalesOrder table
CREATE TABLE SalesOrder (
    Order_Number VARCHAR(15) PRIMARY KEY CHECK (Order_Number LIKE 'O%'),
    Order_Date DATE,
    Client_Number VARCHAR(15),
    Salesman_Number VARCHAR(15),
    Delivery_Status CHAR(15) CHECK (Delivery_Status IN ('Delivered', 'On Way', 'Ready to Ship')),
    Delivery_Date DATE,
    Order_Status VARCHAR(15) CHECK (Order_Status IN ('In Process', 'Successful', 'Cancelled')),
    FOREIGN KEY (Client_Number) REFERENCES Clients(Client_Number),
    FOREIGN KEY (Salesman_Number) REFERENCES Salesman(Salesman_Number),
    CHECK (Delivery_Date >= Order_Date)
);

-- Create SalesOrderDetails table
CREATE TABLE SalesOrderDetails (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    FOREIGN KEY (Order_Number) REFERENCES SalesOrder(Order_Number),
    FOREIGN KEY (Product_Number) REFERENCES Product(Product_Number)
);

-- Insert data into Clients table
INSERT INTO Clients VALUES
('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000,5000),
('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000,3000),
('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong ',7000,3200),
('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000,0),
('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000,150),
('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000,1300),
('C107','Nguyen Thanh','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong ',15000,1000),
('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000,8000),
('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000,1000);

-- Insert data into Product table
INSERT INTO Product VALUES
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);

-- Insert data into Salesman table
INSERT INTO Salesman VALUES
('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000,50,35,'0902361123'),
('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000,100,110,'0903216542'),
('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500,40,30,'0904589632'),
('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500,70,72,'0908654723'),
('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,60,48,'0903213659'),
('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000,80,55,'0907853497');

-- Insert data into SalesOrder table
INSERT INTO SalesOrder VALUES
('O20001','2022-01-15','C101','S003','Delivered','2022-02-10','Successful'),
('O20002','2022-01-25','C102','S003','Delivered','2022-02-15','Cancelled'),
('O20003','2022-01-31','C103','S002','Delivered','2022-04-03','Successful'),
('O20004','2022-02-10','C104','S003','Delivered','2022-04-23','Successful'),
('O20005','2022-02-18','C101','S003','On Way',null,'Cancelled'),
('O20006','2022-02-22','C105','S005','Ready to Ship',null,'In Process'),
('O20007','2022-04-03','C106','S001','Delivered','2022-05-08','Successful'),
('O20008','2022-04-16','C102','S006','Ready to Ship',null,'In Process'),
('O20009','2022-04-24','C101','S004','On Way',null,'Successful'),
('O20010','2022-04-29','C106','S006','Delivered','2022-05-08','Successful'),
('O20011','2022-05-08','C107','S005','Ready to Ship',null,'Cancelled'),
('O20012','2022-05-12','C108','S004','On Way',null,'Successful'),
('O20013','2022-05-16','C109','S001','Ready to Ship',null,'In Process'),
('O20014','2022-05-16','C110','S001','On Way',null,'Successful');

-- Insert data into SalesOrderDetails table
INSERT INTO SalesOrderDetails VALUES
('O20001','P1001',5),
('O20001','P1002',4),
('O20002','P1007',10),
('O20003','P1003',12),
('O20004','P1004',3),
('O20005','P1001',8),
('O20005','P1008',15),
('O20005','P1002',14),
('O20006','P1002',5),
('O20007','P1005',6),
('O20008','P1004',8),
('O20009','P1008',2),
('O20010','P1006',11),
('O20010','P1001',9),
('O20011','P1007',6),
('O20012','P1005',3),
('O20012','P1001',2),
('O20013','P1006',10),
('O20014','P1002',20);

-- Insert additional Salesman data
INSERT INTO Salesman VALUES
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'),
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

-- Insert additional SalesOrder data
INSERT INTO SalesOrder VALUES
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');

-- Insert additional SalesOrderDetails data
INSERT INTO SalesOrderDetails VALUES
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

-- innner join
SELECT SO.Order_Number, C.Client_Name, S.Salesman_Name
FROM SalesOrder SO
INNER JOIN Clients C ON SO.Client_Number = C.Client_Number
INNER JOIN Salesman S ON SO.Salesman_Number = S.Salesman_Number;

-- left join
SELECT C.Client_Name, SO.Order_Number
FROM Clients C
LEFT JOIN SalesOrder SO ON C.Client_Number = SO.Client_Number;

-- right join
SELECT S.Salesman_Name, SO.Order_Number
FROM SalesOrder SO
RIGHT JOIN Salesman S ON SO.Salesman_Number = S.Salesman_Number;

-- cross join
SELECT C.Client_Name, P.Product_Name
FROM Clients C
CROSS JOIN Product P;

-- seft join
SELECT S1.Salesman_Name AS Salesman1, S2.Salesman_Name AS Salesman2, S1.City
FROM Salesman S1
INNER JOIN Salesman S2 ON S1.City = S2.City AND S1.Salesman_Number < S2.Salesman_Number;

-- 1 Display the clients (name) who lives in same city.
SELECT client_name from clients where city in (SELECT city from clients GROUP BY city HAVING count(city) >=2)
ORDER BY city;
-- 2 Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
SELECT client_name, c.city from clients c inner join salesman s on c.city = s.city where c.city = 'Thu Dau Mot';
-- 3 Display  client  name,  client  number,  order  number,  salesman  number,  and  product  number  for  each  order.
SELECT c.client_Name, c.client_Number, so.order_number, so.salesman_number, sod.product_number from clients c 
INNER JOIN salesorder so on c.client_number = so.client_number
INNER JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number;
-- 4 Find each order (client_number, client_name, order_number) placed by each client.
SELECT c.client_number, client_name, order_number from clients c LEFT JOIN salesorder on c.client_number = c.client_number;
-- 5 Display the details of clients (client_number, client_name) and the number of orders which is paid by them. 
SELECT c.client_number, c.client_name, COUNT(so.order_number) AS Order_Count from clients c
left join salesorder so on c.client_number = so.client_number
GROUP BY C.Client_Number, C.Client_Name;


-- 6 Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
SELECT c.client_number, c.client_name , COUNT(so.order_number) AS Order_Count from clients c
inner join salesorder so on c.client_number = so.client_number
GROUP BY c.client_number, c.client_name
HAVING COUNT(so.order_number) >= 2;

-- 7  Display details of clients who have paid for more than 1 order in descending order of client_number.
SELECT c.client_number, c.client_name , COUNT(so.order_number) AS Order_Count from clients c
inner join salesorder so on c.client_number = so.client_number
GROUP BY c.client_number, c.client_name
HAVING COUNT(so.order_number) > 1
ORDER BY c.client_number DESC;


-- 8  Find the salesman names who sells more than 20 products.
SELECT s.salesman_name , SUM(sod.order_quantity) from salesman s 
inner join salesorder od on s.salesman_number = od.salesman_number
inner join salesorderdetails sod on  od.order_number = sod.order_number
GROUP BY s.salesman_name
HAVING (SUM(sod.order_quantity)) > 20;


-- 9 Display  the  client  information  (client_number,  client_name)  and  order  number  of  those  clients  who have order status is cancelled.
SELECT c.client_number,  c.client_name , so.order_number from clients c inner join salesorder so
on c.client_number = so.client_number where so.order_status = 'cancelled';

-- 10 Display  client  name,  client  number  of  clients  C101  and  count  the  number  of  orders  which  were received “successful”.
SELECT c.client_name, c.client_number , COUNT(so.order_status) from clients c inner join salesorder so
on c.client_number = so.client_number AND so.order_status = 'successful'
where c.client_number = 'C101'
GROUP BY c.client_name, c.client_number;


-- 11 Count the number of clients orders placed for each product
SELECT p.product_name, p.product_number, COUNT(sod.order_number) from product p
inner JOIN salesorderdetails sod on p.product_number = sod.product_number
GROUP BY p.product_name, p.product_number;


-- 12 Find product numbers that were ordered by more than two clients then order in descending by product number.
SELECT sod.product_number from salesorderdetails sod
inner join salesorder so on sod.order_number = so.order_number
GROUP BY sod.product_number
HAVING count(DISTINCT so.client_number) > 2
ORDER BY sod.product_number DESC;



-- 13 Find the salesman’s names who is getting the second highest salary.
SELECT salesman_name,salary from salesman WHERE salary not in (SELECT MAX(salary) from salesman) ORDER BY salary DESC limit 1;



-- 14 Find the salesman’s names who is getting second lowest salary.
SELECT salesman_name,salary from salesman WHERE salary not in (SELECT min(salary) from salesman) ORDER BY salary ASC limit 1;


-- 15 Write  a  query  to  find  the  name  and  the  salary  of  the  salesman  who  have  a  higher  salary  than  the salesman whose salesman number is S001.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary > (SELECT Salary FROM Salesman WHERE Salesman_Number = 'S001');

-- 16.  Write a query to find the name of all salesman who sold the product has number: P1002. 
SELECT DISTINCT s.salesman_name from salesman s inner join salesorder so on s.salesman_number = so.salesman_number 
inner join salesorderdetails sod on so.order_number = sod.order_number
where sod.product_number = 'P1002';


-- 17.  Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”. 
SELECT s.salesman_name from salesman s inner join salesorder so on s.salesman_number = so.salesman_number 
WHERE so.client_number = 'C108' and so.delivery_status = 'delivered';

-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal to 5.
SELECT DISTINCT P.Product_Name
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
WHERE SOD.Order_Quantity = 5;

-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
SELECT DISTINCT S.Salesman_Name, S.Salesman_Number
FROM Salesman S
JOIN SalesOrder SO ON S.Salesman_Number = SO.Salesman_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
JOIN Product P ON SOD.Product_Number = P.Product_Number
WHERE P.Product_Name IN ('Pen', 'TV', 'Laptop');

-- 20. Lists the salesman's name sold product with a product price less than 800 and Quantity_On_Hand more than 50.
SELECT DISTINCT S.Salesman_Name
FROM Salesman S
JOIN SalesOrder SO ON S.Salesman_Number = SO.Salesman_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
JOIN Product P ON SOD.Product_Number = P.Product_Number
WHERE P.Sell_Price < 800 AND P.Quantity_On_Hand > 50;

-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary > (SELECT AVG(Salary) FROM Salesman);

-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the average amount paid.
SELECT Client_Name, Amount_Paid
FROM Clients
WHERE Amount_Paid > (SELECT AVG(Amount_Paid) FROM Clients);

-- 23. Find the product price that was sold to Le Xuan.
SELECT DISTINCT P.Sell_Price
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
JOIN SalesOrder SO ON SOD.Order_Number = SO.Order_Number
JOIN Clients C ON SO.Client_Number = C.Client_Number
WHERE C.Client_Name = 'Le Xuan';

-- 24. Determine the product name, client name and amount due that was delivered.
SELECT P.Product_Name, C.Client_Name, C.Amount_Due
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
JOIN SalesOrder SO ON SOD.Order_Number = SO.Order_Number
JOIN Clients C ON SO.Client_Number = C.Client_Number
WHERE SO.Delivery_Status = 'Delivered';

-- 25. Find the salesman's name and their product name which is cancelled.
SELECT S.Salesman_Name, P.Product_Name
FROM Salesman S
JOIN SalesOrder SO ON S.Salesman_Number = SO.Salesman_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
JOIN Product P ON SOD.Product_Number = P.Product_Number
WHERE SO.Order_Status = 'Cancelled';

-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
SELECT P.Product_Name, P.Sell_Price, SO.Delivery_Status
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
JOIN SalesOrder SO ON SOD.Order_Number = SO.Order_Number
JOIN Clients C ON SO.Client_Number = C.Client_Number
WHERE C.Client_Name = 'Nguyen Thanh';

-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information for each customer.
SELECT P.Product_Name, P.Sell_Price, S.Salesman_Name, SO.Delivery_Status, SOD.Order_Quantity, C.Client_Name
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
JOIN SalesOrder SO ON SOD.Order_Number = SO.Order_Number
JOIN Salesman S ON SO.Salesman_Number = S.Salesman_Number
JOIN Clients C ON SO.Client_Number = C.Client_Number;

-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been successful but the items have not yet been delivered to the client.
SELECT S.Salesman_Name, P.Product_Name, SO.Order_Date
FROM Salesman S
JOIN SalesOrder SO ON S.Salesman_Number = SO.Salesman_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
JOIN Product P ON SOD.Product_Number = P.Product_Number
WHERE SO.Order_Status = 'Successful' AND SO.Delivery_Status != 'Delivered';

-- 29. Find each clients' product which is on the way.
SELECT C.Client_Name, P.Product_Name
FROM Clients C
JOIN SalesOrder SO ON C.Client_Number = SO.Client_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
JOIN Product P ON SOD.Product_Number = P.Product_Number
WHERE SO.Delivery_Status = 'On Way';

-- 30. Find salary and the salesman's names who is getting the highest salary.
SELECT Salesman_Name, Salary
FROM Salesman
WHERE Salary = (SELECT MAX(Salary) FROM Salesman);

-- 31. Find salary and the salesman's names who is getting second lowest salary.
SELECT Salesman_Name, Salary
FROM Salesman
ORDER BY Salary ASC
LIMIT 1 OFFSET 1;

-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more than 9.
SELECT DISTINCT P.Product_Name
FROM Product P
JOIN SalesOrderDetails SOD ON P.Product_Number = SOD.Product_Number
WHERE SOD.Order_Quantity > 9;

-- 33. Find the name of the customer who ordered the same item multiple times.
SELECT C.Client_Name
FROM Clients C
JOIN SalesOrder SO ON C.Client_Number = SO.Client_Number
JOIN SalesOrderDetails SOD ON SO.Order_Number = SOD.Order_Number
GROUP BY C.Client_Number, C.Client_Name, SOD.Product_Number
HAVING COUNT(*) > 1;

-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average salary and works in any of Thu Dau Mot city.
SELECT Salesman_Name, Salesman_Number, Salary
FROM Salesman
WHERE Salary < (SELECT AVG(Salary) FROM Salesman) AND City = 'Thu Dau Mot';

-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than the salary of all the salesman have (Order_status = 'Cancelled'). Sort the results of the salary of the lowest to highest.
SELECT S.Salesman_Name, S.Salesman_Number, S.Salary
FROM Salesman S
WHERE S.Salary > ALL (
    SELECT DISTINCT S2.Salary
    FROM Salesman S2
    JOIN SalesOrder SO ON S2.Salesman_Number = SO.Salesman_Number
    WHERE SO.Order_Status = 'Cancelled'
)
ORDER BY S.Salary ASC;

-- 36. Write a query to find the 4th maximum salary on the salesman's table.
SELECT DISTINCT Salary
FROM Salesman
ORDER BY Salary DESC
LIMIT 1 OFFSET 3;

-- 37. Write a query to find the 3rd minimum salary in the salesman's table.
SELECT DISTINCT Salary
FROM Salesman
ORDER BY Salary ASC
LIMIT 1 OFFSET 2;

