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
    Amount_Paid DECIMAL(15 , 4 ),
    Amount_Due DECIMAL(15 , 4 )
);

-- Create Product table
CREATE TABLE Product (
    Product_Number VARCHAR(15) PRIMARY KEY CHECK (Product_Number LIKE 'P%'),
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Quantity_On_Hand INT NOT NULL,
    Quantity_Sell INT NOT NULL,
    Sell_Price DECIMAL(15 , 4 ) NOT NULL,
    Cost_Price DECIMAL(15 , 4 ) NOT NULL CHECK (Cost_Price != 0)
);

-- Create Salesman table
CREATE TABLE Salesman (
    Salesman_Number VARCHAR(15) PRIMARY KEY CHECK (Salesman_Number LIKE 'S%'),
    Salesman_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25) DEFAULT 'Vietnam',
    Salary DECIMAL(15 , 4 ) NOT NULL CHECK (Salary != 0),
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
    Delivery_Status CHAR(15) CHECK (Delivery_Status IN ('Delivered' , 'On Way', 'Ready to Ship')),
    Delivery_Date DATE,
    Order_Status VARCHAR(15) CHECK (Order_Status IN ('In Process' , 'Successful', 'Cancelled')),
    FOREIGN KEY (Client_Number)
        REFERENCES Clients (Client_Number),
    FOREIGN KEY (Salesman_Number)
        REFERENCES Salesman (Salesman_Number),
    CHECK (Delivery_Date >= Order_Date)
);

-- Create SalesOrderDetails table
CREATE TABLE SalesOrderDetails (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    FOREIGN KEY (Order_Number)
        REFERENCES SalesOrder (Order_Number),
    FOREIGN KEY (Product_Number)
        REFERENCES Product (Product_Number)
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
-- DESCRIBE Clients;
-- DESCRIBE Product;
-- DESCRIBE Salesman;
-- DESCRIBE SalesOrder;
-- DESCRIBE SalesOrderDetails;

-- Display the content of all tables
-- SELECT * FROM Clients;
-- SELECT * FROM Product;
-- SELECT * FROM Salesman;
-- SELECT * FROM SalesOrder;
-- SELECT * FROM SalesOrderDetails;

SET SQL_SAFE_UPDATES = 0;

-- 1. How to check constraint in a table?
SELECT 
    CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE
    TABLE_NAME = 'salesman';
-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information about product name and its buying price.
CREATE TABLE ProductCost AS SELECT product_name, cost_price FROM
    productCompute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
alter TABLE product add COLUMN profit float;
update product set profit = (sell_price - cost_Price)/cost_Price * 100;
SELECT * from product;
-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
-- 4,5,6
update salesman set remarks =
    CASE
		WHEN target_achieved>=sales_target*0.75  THEN 'Good'
		else case WHEN target_achieved<sales_target*0.75 and target_achieved>sales_target*0.5   THEN 'Average'
        else  'Poor'
END end;
SELECT * from salesman;
-- 7. Find the total quantity for each product. (Query)
SELECT *,quantity_on_hand+quantity_sell as total_quantity from product ;
-- 8. Add a new column and find the total quantity for each product.
alter TABLE product add COLUMN total_quantity int;
UPDATE product set total_quantity = quantity_on_hand+quantity_sell;
-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
alter TABLE product add COLUMN discount_rate DECIMAL;
UPDATE product 
SET 
    discount_rate = CASE
        WHEN quantity_on_hand >= 10 THEN 10
        ELSE 5
    END;
SELECT * from product;
-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
UPDATE product 
SET 
    discount_rate = CASE
        WHEN quantity_on_hand >= 20 THEN 10
        ELSE CASE
            WHEN quantity_on_hand > 10 THEN 5
            ELSE CASE
                WHEN quantity_on_hand > 5 THEN 3
                ELSE 0
            END
        END
    END;
SELECT * from product;
-- 11. The first number of pin code in the client table should be start with 7.
ALTER TABLE clients ADD CONSTRAINT chk_start_pincode CHECK (pincode LIKE '7%');
-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
DROP VIEW if EXISTS clients_view;
CREATE VIEW clients_view AS
    SELECT 
        *
    FROM
        clients
    WHERE
        city = 'Thu Dau Mot';
-- 13. Drop the “client_view”.
DROP VIEW clients_view;
-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
DROP VIEW if EXISTS clients_order;
CREATE VIEW clients_order AS SELECT c.*,sod.* FROM clients c
inner join salesorder so on c.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number
where c.city = 'Thu Dau Mot';
-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average sell price.
CREATE VIEW Products as SELECT * from product where sell_price > (SELECT avg(sell_price) from product);
-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,product price, quantity order) were sold by them.
DROP VIEW if EXISTS salesman_view;
CREATE VIEW salesman_view AS
    SELECT 
        s.*, p.product_name, sell_price, order_quantity
    FROM
        salesman s
            JOIN
        salesorder so ON s.salesman_number = so.salesman_number
            JOIN
        salesorderdetails sod ON so.order_number = sod.order_number
            JOIN
        product p ON sod.product_number = p.product_number;
-- 17. Creates a view name as sale_view that show all salesman information and product (product names, product price, quantity order) were sold by them with order_status = 'Successful'.
DROP VIEW if EXISTS sale_view;
CREATE VIEW sale_view AS
    SELECT 
        s.*, p.product_name, sell_price, order_quantity
    FROM
        salesman s
            JOIN
        salesorder so ON s.salesman_number = so.salesman_number
            JOIN
        salesorderdetails sod ON so.order_number = sod.order_number
            JOIN
        product p ON sod.product_number = p.product_number
        WHERE order_status = 'Successful';
-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
DROP VIEW if EXISTS sale_amount_view;
CREATE VIEW sale_amount_view AS
    SELECT 
        s.*, SUM(order_quantity) AS total_order
    FROM
        salesman s
            JOIN
        salesorder so ON s.salesman_number = so.salesman_number
            JOIN
        salesorderdetails sod ON so.order_number = sod.order_number
            JOIN
        product p ON sod.product_number = p.product_number
    WHERE
        order_status = 'Successful'
    GROUP BY s.salesman_number
    HAVING total_order >= 20;
-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
ALTER TABLE clients add CONSTRAINT chk_amount_paid CHECK (amount_paid >= 0),
add CONSTRAINT chk_amount_due CHECK (amount_due >= 0);
-- 20. Remove the constraint from pincode;
ALTER TABLE clients DROP CONSTRAINT chk_start_pincode;
-- 21. The sell price and cost price should be unique.
ALTER TABLE product ADD CONSTRAINT chk_sell_price UNIQUE(sell_price),ADD CONSTRAINT chk_cost_price UNIQUE(cost_price);
-- 22. The sell price and cost price should not be unique.
ALTER TABLE product DROP CONSTRAINT chk_sell_price ,DROP CONSTRAINT chk_cost_price;
-- 23. Remove unique constraint from product name.
ALTER TABLE product DROP CONSTRAINT product_name;
-- 24. Update the delivery status to “Delivered” for the product number P1007.
UPDATE salesorder so join salesorderdetails sod on so.order_number = sod.order_number set delivery_status = 'Delivered' 
WHERE sod.product_number = 'P1007';
-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
UPDATE clients 
SET 
    city = 'Phu Hoa',
    address = 'Thu Dau Mot'
WHERE
    client_number = 'C104';
-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
ALTER TABLE product add COLUMN Exp_Date DATE;
-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
ALTER TABLE clients add COLUMN Phone VARCHAR(15);
-- 28. Update remarks as “Good” for all salesman.
UPDATE salesman set remarks = 'Good';
-- 29. Change remarks to "bad" whose salesman number is "S004".
UPDATE salesman 
SET 
    remarks = 'bad'
WHERE
    salesman_number = 'S004';
-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
ALTER TABLE clients MODIFY COLUMN Phone VARCHAR(10);
-- 31. Delete the “Phone” column from “Clients” table.
ALTER TABLE clients DROP COLUMN Phone;
-- 32. alter table Clients drop column Phone;
ALTER TABLE clients DROP COLUMN Phone;
-- 33. Change the sell price of Mouse to 120.
UPDATE product 
SET 
    sell_price = '120'
WHERE
    product_name = 'Mouse';
-- 34. Change the city of client number C104 to “Ben Cat”.
UPDATE clients 
SET 
    city = 'Ben Cat'
WHERE
    client_name = 'C104';
-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15%discount. Othrwise, no discount.
UPDATE product 
SET 
    discount_rate = CASE
        WHEN quantity_on_hand >= 10 THEN 15
        ELSE CASE
            WHEN quantity_on_hand >= 5 THEN 10
        END
    END;
SELECT 
    *
FROM
    product;

