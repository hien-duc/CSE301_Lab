use salemanagerment;

-- a) TRIGGER
-- 1. Create a trigger before_total_quantity_update to update total quantity of product when
-- Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004
-- have Quantity_On_Hand = 30, quantity_sell =35.
CREATE 
    TRIGGER  before_total_quantity_update
 BEFORE UPDATE ON Product FOR EACH ROW 
    SET NEW . total_quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
    
UPDATE Product 
SET 
    Quantity_On_Hand = 30,
    Quantity_Sell = 35
WHERE
    Product_Number = 'P1004';

SELECT 
    *
FROM
    product;
-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
ALTER TABLE Salesman ADD COLUMN PER_MARKS DECIMAL(5,2);

CREATE 
    TRIGGER  before_remark_salesman_update
 BEFORE UPDATE ON Salesman FOR EACH ROW 
    SET NEW . PER_MARKS = (NEW.Target_Achieved * 100) / NEW.Sales_Target;
-- 3. Create a trigger before_product_insert to insert a product in product table.
DELIMITER //
CREATE TRIGGER before_product_insert
BEFORE INSERT ON Product
FOR EACH ROW
BEGIN
    IF NOT NEW.Product_Number LIKE 'P%' THEN
        SET NEW.Product_Number = CONCAT('P', NEW.Product_Number);
    END IF;

    IF NEW.Quantity_On_Hand < 0 THEN
        SET NEW.Quantity_On_Hand = 0;
    END IF;
    
    IF NEW.Quantity_Sell < 0 THEN
        SET NEW.Quantity_Sell = 0;
    END IF;

    IF NEW.Sell_Price <= NEW.Cost_Price THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sell price must be greater than cost price';
    END IF;

    SET NEW.Total_Quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell;
END //
DELIMITER ;
-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as
-- "Successful".
DELIMITER //
CREATE TRIGGER before_order_status_update
BEFORE UPDATE ON SalesOrder
FOR EACH ROW
BEGIN
    IF NEW.Order_Status = 'Successful' THEN
        SET NEW.Delivery_Status = 'Delivered';
    END IF;
END; //
DELIMITER ;
-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted.
DELIMITER //
CREATE TRIGGER before_salesman_insert
BEFORE INSERT ON Salesman
FOR EACH ROW
BEGIN
    SET NEW.Remarks = 'Good';
END; //
DELIMITER ;
-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.
DELIMITER //
CREATE TRIGGER before_client_insert
BEFORE INSERT ON Clients
FOR EACH ROW
BEGIN
    IF LEFT(NEW.Pincode, 1) != '7' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pin code must start with 7';
    END IF;
END; //
DELIMITER ;
-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted
CREATE TABLE DeletedClients (
    Client_Number VARCHAR(10) PRIMARY KEY,
    Client_Name VARCHAR(25),
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT,
    Province CHAR(25),
    Amount_Paid DECIMAL(15 , 4 ),
    Amount_Due DECIMAL(15 , 4 ),
    Deleted_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER after_client_delete
BEFORE DELETE ON Clients
FOR EACH ROW
BEGIN
    INSERT INTO DeletedClients (Client_Number, Client_Name, Address, City, Pincode, Province, Amount_Paid, Amount_Due)
    VALUES (OLD.Client_Number, OLD.Client_Name, OLD.Address, 'Unknown', OLD.Pincode, OLD.Province, OLD.Amount_Paid, OLD.Amount_Due);
END; //
DELIMITER ;
DROP TRIGGER after_client_delete;
DELETE FROM clients 
WHERE
    client_number = 'C110';
SELECT 
    *
FROM
    clients;
DELIMITER ;
-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product
-- table.
DELIMITER //
CREATE TRIGGER after_product_insert
AFTER INSERT ON Product
FOR EACH ROW
BEGIN
    UPDATE Product
    SET Profit = (NEW.Sell_Price - NEW.Cost_Price) * NEW.Quantity_Sell,
        Total_Quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell
    WHERE Product_Number = NEW.Product_Number;
END; //
DELIMITER ;
-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted.
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON SalesOrder
FOR EACH ROW
BEGIN
    UPDATE SalesOrder
    SET Delivery_Status = 'On Way'
    WHERE Order_Number = NEW.Order_Number;
END; //
DELIMITER ;
-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) If per_remarks >= 75%, his remarks should be ‘Good’.
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered
-- 'Poor'.
DROP TRIGGER before_remark_salesman_update;
DELIMITER //
CREATE TRIGGER before_remark_salesman_update
BEFORE UPDATE ON Salesman
FOR EACH ROW
BEGIN
    SET NEW.PER_MARKS = (NEW.Target_Achieved * 100) / NEW.Sales_Target;
    IF NEW.PER_MARKS >= 75 THEN
        SET NEW.Remarks = 'Good';
    ELSEIF NEW.PER_MARKS >= 50 THEN
        SET NEW.Remarks = 'Average';
    ELSE
        SET NEW.Remarks = 'Poor';
    END IF;
END; //
DELIMITER ;
-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it.
DELIMITER //
CREATE TRIGGER before_order_insert
BEFORE INSERT ON SalesOrder
FOR EACH ROW
BEGIN
    IF NEW.Delivery_Date <= NEW.Order_Date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Delivery date must be after order date';
    END IF;
END; //
DELIMITER ;
-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity).
DELIMITER //
CREATE TRIGGER after_order_detail_insert
AFTER INSERT ON SalesOrderDetails
FOR EACH ROW
BEGIN
    UPDATE Product
    SET Quantity_On_Hand = Quantity_On_Hand - NEW.Order_Quantity
    WHERE Product_Number = NEW.Product_Number;
END; //
DELIMITER ;
-- b) Writing Function:
-- 1. Find the average salesman’s salary.
DELIMITER //
CREATE FUNCTION avg_salesman_salary()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    SELECT AVG(Salary) INTO avg_salary FROM Salesman;
    RETURN avg_salary;
END; //
DELIMITER ;
-- 2. Find the name of the highest paid salesman.
DELIMITER //
CREATE FUNCTION highest_paid_salesman()
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE max_salary_name VARCHAR(25);
    SELECT Salesman_Name INTO max_salary_name
    FROM Salesman
    WHERE Salary = (SELECT MAX(Salary) FROM Salesman);
    RETURN max_salary_name;
END; //
DELIMITER ;
-- 3. Find the name of the salesman who is paid the lowest salary.
DELIMITER //
CREATE FUNCTION lowest_paid_salesman()
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE min_salary_name VARCHAR(25);
    SELECT Salesman_Name INTO min_salary_name
    FROM Salesman
    WHERE Salary = (SELECT MIN(Salary) FROM Salesman);
    RETURN min_salary_name;
END; //
DELIMITER ;
-- 4. Determine the total number of salespeople employed by the company.
DELIMITER //
CREATE FUNCTION total_salespeople()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Salesman;
    RETURN total;
END; //
DELIMITER ;
-- 5. Compute the total salary paid to the company's salesman.
DELIMITER //
CREATE FUNCTION total_salesman_salary()
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2);
    SELECT SUM(Salary) INTO total FROM Salesman;
    RETURN total;
END; //
DELIMITER ;
-- 6. Find Clients in a Province
DELIMITER //
CREATE FUNCTION clients_in_province(province_name CHAR(25))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE client_count INT;
    SELECT COUNT(*) INTO client_count
    FROM Clients
    WHERE Province = province_name;
    RETURN client_count;
END; //
DELIMITER ;
-- 7. Calculate Total Sales
DELIMITER //
CREATE FUNCTION total_sales()
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2);
    SELECT SUM(p.Sell_Price * sod.Order_Quantity) INTO total
    FROM SalesOrderDetails sod
    JOIN Product p ON sod.Product_Number = p.Product_Number
    JOIN SalesOrder so ON sod.Order_Number = so.Order_Number
    WHERE so.Order_Status = 'Successful';
    RETURN total;
END; //
DELIMITER ;
-- 8. Calculate Total Order Amount
DELIMITER //
CREATE FUNCTION order_total_amount(order_num VARCHAR(15))
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15,2);
    SELECT SUM(p.Sell_Price * sod.Order_Quantity) INTO total
    FROM SalesOrderDetails sod
    JOIN Product p ON sod.Product_Number = p.Product_Number
    WHERE sod.Order_Number = order_num;
    RETURN total;
END; //
DELIMITER ;
