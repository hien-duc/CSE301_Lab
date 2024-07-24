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

-- Show the schema of all tables
DESCRIBE Clients;
DESCRIBE Product;
DESCRIBE Salesman;
DESCRIBE SalesOrder;
DESCRIBE SalesOrderDetails;

-- Display the content of all tables
SELECT * FROM Clients;
SELECT * FROM Product;
SELECT * FROM Salesman;
SELECT * FROM SalesOrder;
SELECT * FROM SalesOrderDetails;

-- 1. Show the all-clients details who lives in “Binh Duong”.
SELECT * from clients where province = 'Binh Duong';
-- 2. Find the client’s number and client’s name who do not live in “Hanoi”.
SELECT * from clients where address <> 'Hanoi';
-- 3. Identify the names of all products with less than 25 in stock.
SELECT * from product where Quantity_On_Hand < 25;
-- 4. Find the product names where company making losses.
SELECT Product_Name from product where Sell_Price < Cost_Price;
-- 5. Find the salesman’s details who are able achieved their target.
SELECT * from salesman where Target_Achieved >= Sales_Target;
-- 6. Select the names and city of salesman who are not received salary between 10000 and 17000.
SELECT Salesman_Name, City from salesman where Salary NOT BETWEEN 10000 AND 17000;
-- 7. Show order date and the clients_number of who bought the product between '2022-01-01' and '2022-02-15'.
SELECT order_date, client_number from salesorder WHERE order_date BETWEEN '2022-01-01' and '2022-02-15';
-- 8. Find the names of cities in clients table where city name starts with "N"
SELECT city from clients where city LIKE 'N%';
-- 9. Display clients’ information whose names have "u" in third position.
SELECT * from clients where client_name like '__u%';
-- 10. Find the details of clients whose names have "u" in second last position.
SELECT * from clients where client_name like '%u_';
-- 11. Find the names of cities in clients table where city name starts with "D" and ends with “n”.
SELECT DISTINCT city from clients where city like 'D%n';
-- 12. Select all clients details who belongs from Ho Chi Minh, Hanoi and Da Lat.
SELECT * from clients where province in ('Ho Chi Minh', 'Hanoi' , 'Da Lat');
-- 13. Choose all clients data who do not reside in Ho Chi Minh, Hanoi and Da Lat.
SELECT * from clients where city not in ('Ho Chi Minh', 'Hanoi' , 'Da Lat');
-- 14. Find the average salesman’s salary.
SELECT avg(salary) from salesman;
-- 15. Find the name of the highest paid salesman.
SELECT salesman_name from salesman where salary in (SELECT MAX(salary) from salesman );
-- 16. Find the name of the salesman who is paid the lowest salary.
SELECT salesman_name from salesman where salary in (SELECT MIN(salary) from salesman );
-- 17. Determine the total number of salespeople employed by the company.
SELECT count(salesman_number) from salesman;
-- 18. Compute the total salary paid to the company's salesman.
SELECT sum(salary) from salesman;
-- 19. Select the salesman’s details sorted by their salary.
SELECT * from salesman ORDER BY salary ASC;
-- 20. Display salesman names and phone numbers based on their target achieved (in ascending order) and their city (in descending order).
SELECT salesman_name, phone from salesman ORDER BY target_achieved ASC, city DESC;
-- 21. Display 3 first names of the salesman table and the salesman’s names in descending order.
SELECT salesman_name from salesman ORDER BY salesman_name DESC LIMIT 3;
-- 22. Find salary and the salesman’s names who is getting the highest salary.
SELECT salary, salesman_name from salesman where salary in(SELECT MAX(salary) from salesman);
-- 23. Find salary and the salesman’s names who is getting second lowest salary.
SELECT Salesman_Name, Salary FROM Salesman WHERE Salary > (SELECT MIN(Salary) FROM Salesman)
ORDER BY Salary ASC
LIMIT 1;
-- 24. Display the first five sales orders in formation from the sales order table.
SELECT * from salesorder LIMIT 5;
-- 25. Display next ten sales order information from sales order table except first five sales order.
SELECT * FROM SalesOrder LIMIT 5, 10;
-- 26. If there are more than one client, find the name of the province and the number of clients in each province, ordered high to low.
SELECT province, COUNT(client_number)
from clients GROUP BY province 
having COUNT(client_number)>1
ORDER BY COUNT(client_number) DESC;
-- 27. Display information clients have number of sales order more than 1.
SELECT c.Client_Number, c.Client_Name, c.City, c.Province, COUNT(s.Order_Number) as Order_Count
FROM Clients c
JOIN SalesOrder s ON c.Client_Number = s.Client_Number
GROUP BY c.Client_Number, c.Client_Name, c.City, c.Province
HAVING COUNT(s.Order_Number) > 1
ORDER BY Order_Count DESC;
-- 28. Display the name and due amount of those clients who lives in “Hanoi”.
SELECT client_name, amount_due from clients where province = 'Hanoi';
-- 29. Find the clients details who has due more than 3000.
SELECT * from clients where amount_due >= 3000;
-- 30. Find the clients name and their province who has no due.
SELECT client_name,province from clients where amount_due = 0;
-- 31. Show details of all clients paying between 10,000 and 13,000.
SELECT * from clients where amount_paid BETWEEN 10000 and 13000;
-- 32. Find the details of clients whose name is “Dat”.
SELECT * from clients where client_name like '%Dat';
-- 33. Display all product name and their corresponding selling price.
SELECT product_name,sell_price from product;
-- 34. How many TVs are in stock?
SELECT quantity_on_hand from product where product_name = 'TV';
-- 35. Find the salesman’s details who are not able achieved their target.
SELECT * from salesman where sales_target > target_achieved;
-- 36. Show all the product details of product number ‘P1005’.
SELECT * from product where product_number = 'P1005';
-- 37. Find the buying price and sell price of a Mouse.
SELECT cost_price, sell_price from product where product_name = 'Mouse';
-- 38. Find the salesman names and phone numbers who lives in Thu Dau Mot.
SELECT salesman_name, phone from salesman where city = 'Thu Dau Mot';
-- 39. Find all the salesman’s name and salary.
SELECT salesman_name,salary from salesman;
-- 40. Select the names and salary of salesman who are received between 10000 and 17000.
SELECT salesman_name,salary from salesman where salary BETWEEN 10000 and 17000;
-- 41. Display all salesman details who are received salary between 10000 and 20000 and achieved their target.
SELECT * from salesman where salary BETWEEN 10000 and 20000 and target_achieved >= sales_target;
-- 42. Display all salesman details who are received salary between 20000 and 30000 and not achieved their target.
SELECT * from salesman where salary BETWEEN 20000 and 30000 and not target_achieved >= sales_target;
-- 43. Find information about all clients whose names do not end with "h".
SELECT * from clients where client_name not like '%h';
-- 44. Find client names whose second letter is 'r' or second last letter 'a'.
SELECT * from clients where client_name like '_r%' or '%a_';
-- 45. Select all clients where the city name starts with "D" and at least 3 characters in length.
SELECT * from clients where city like 'D___%';
-- 46. Select the salesman name, salaries and target achieved sorted by their target_achieved in descending order.
SELECT salesman_name,salary,target_achieved from salesman ORDER BY target_achieved DESC;
-- 47. Select the salesman’s details sorted by their sales_target and target_achieved in ascending order.
SELECT * from salesman ORDER BY sales_target and target_achieved ASC;
-- 48. Select the salesman’s details sorted ascending by their salary and descending by achieved target.
SELECT * from salesman ORDER BY salary ASC , target_achieved DESC;
-- 49. Display salesman names and phone numbers in descending order based on their sales target.
SELECT salesman_name, phone from salesman ORDER BY sales_target DESC;
-- 50. Display the product name, cost price, and sell price sorted by quantity in hand.
SELECT product_name, cost_price, sell_price from product ORDER BY quantity_on_hand ASC;
-- 51. Retrieve the clients’ names in ascending order.
SELECT client_name from clients ORDER BY client_name ASC;
-- 52. Display client information based on order by their city.
SELECT * from clients ORDER BY city ASC;
-- 53. Display client information based on order by their address and city.
SELECT * from clients ORDER BY address,city ASC;
-- 54. Display client information based on their city, sorted high to low based on amount due.
SELECT * from clients ORDER BY city ASC, amount_due DESC;
-- 55. Display the data of sales orders depending on their delivery status from the current date to the old date.
SELECT * FROM SalesOrder ORDER BY Delivery_Status, Order_Date DESC;
-- 56. Display last five sales order in formation from sales order table.
SELECT * FROM SalesOrder
ORDER BY Order_Date DESC, Order_Number DESC
LIMIT 5;
-- 57. Count the pincode in client table.
SELECT COUNT(pincode) from clients;
-- 58. How many clients are living in Binh Duong?
SELECT COUNT(client_number) from clients where province = 'Binh Duong';
-- 59. Count the clients for each province.
SELECT province,COUNT(*) from clients GROUP BY province;
-- 60. If there are more than three clients, find the name of the province and the number of clients in each province.
SELECT Province, COUNT(*) as Client_Count
FROM Clients
GROUP BY Province
HAVING COUNT(*) > 3;
-- 61. Display product number and product name and count number orders of each product more than 1 (in ascending order).
SELECT p.Product_Number, p.Product_Name, COUNT(sod.Order_Number) as Order_Count
FROM Product p
JOIN SalesOrderDetails sod ON p.Product_Number = sod.Product_Number
GROUP BY p.Product_Number, p.Product_Name
HAVING COUNT(sod.Order_Number) > 1
ORDER BY Order_Count ASC;
-- 62. Find products which have more quantity on hand than 20 and less than the sum of average.
SELECT * FROM Product
WHERE Quantity_On_Hand > 20 AND Quantity_On_Hand < (
    SELECT (AVG(Quantity_On_Hand))
    FROM Product
);
