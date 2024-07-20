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
('C107','Nguyen Thanh ','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
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