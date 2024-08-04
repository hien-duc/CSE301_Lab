USE SaleManagerment;

-- 1. SQL statement returns the cities (only distinct values) from both the "Clients" and the "salesman" table.
SELECT 
    city
FROM
    clients 
UNION SELECT 
    city
FROM
    salesman;
-- 2. SQL statement returns the cities (duplicate values also) both the "Clients" and the "salesman" table.
SELECT 
    city
FROM
    clients 
UNION ALL SELECT 
    city
FROM
    salesman;
-- 3. SQL statement returns the Ho Chi Minh cities (only distinct values) from the "Clients" and the "salesman" table.
SELECT 
    city
FROM
    clients
WHERE
    city = 'Ho Chi Minh' 
UNION SELECT 
    city
FROM
    salesman
WHERE
    city = 'Ho Chi Minh';
-- 4. SQL statement returns the Ho Chi Minh cities (duplicate values also) from the "Clients" and the "salesman" table.
SELECT 
    city
FROM
    clients
WHERE
    city = 'Ho Chi Minh' 
UNION ALL SELECT 
    city
FROM
    salesman
WHERE
    city = 'Ho Chi Minh';
-- 5. SQL statement lists all Clients and salesman.
SELECT 
    client_number AS ID, client_name AS 'Name'
FROM
    clients 
UNION ALL SELECT 
    salesman_number, salesman_name
FROM
    salesman;
-- 6. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with information: ID, Name, City and Type.
SELECT 
    *
FROM
    (SELECT 
        client_number AS ID,
            client_name AS 'Name',
            city,
            'Client' AS Type
    FROM
        clients
    WHERE
        city = 'HaNoi' UNION ALL SELECT 
        salesman_number AS ID,
            salesman_name AS 'Name',
            city,
            'Salesman' AS Type
    FROM
        salesman
    WHERE
        city = 'HaNoi') AS T;
-- 7. Write a SQL query to find those salesman and clients who have placed more than one order. Return ID, name and order by ID.
SELECT 
    c.client_number AS ID,
    c.client_name AS 'Name',
    city,
    'Client' AS Type
FROM
    clients c
        INNER JOIN
    salesorder so ON c.client_number = so.client_number
GROUP BY c.client_number
HAVING COUNT(so.order_number) > 1 
UNION ALL SELECT 
    s.salesman_number AS ID,
    s.salesman_name AS 'Name',
    city,
    'Salesman' AS Type
FROM
    salesman s
        INNER JOIN
    salesorder so ON s.salesman_number = so.salesman_number
GROUP BY s.salesman_number
HAVING COUNT(so.order_number) > 1
ORDER BY ID;
-- 8. Retrieve Name, Order Number (order by order number) and Type of client or salesman with the client names who placed orders and the salesman names who processed those orders.
SELECT 
    CASE 
        WHEN c.Client_Name IS NOT NULL THEN c.Client_Name
        ELSE s.Salesman_Name
    END AS Name,
    so.Order_Number,
    CASE 
        WHEN c.Client_Name IS NOT NULL THEN 'Client'
        ELSE 'Salesman'
    END AS Type
FROM SalesOrder so
LEFT JOIN Clients c ON so.Client_Number = c.Client_Number
LEFT JOIN Salesman s ON so.Salesman_Number = s.Salesman_Number
ORDER BY so.Order_Number;
-- 9. Write a SQL query to create a union of two queries that shows the salesman, cities, and target_Achieved of all salesmen. Those with a target of 60 or greater will have the words 'High Achieved', while the others will have the words 'Low Achieved'.
SELECT 
    salesman_name,
    city,
    target_achieved,
    CASE
        WHEN target_achieved >= 60 THEN 'High Achieved'
    END AS achievement
FROM
    salesman
WHERE
    target_Achieved >= 60 
UNION ALL SELECT 
    salesman_name,
    city,
    target_achieved,
    CASE
        WHEN target_achieved < 60 THEN 'Low Achieved'
    END AS achievement
FROM
    salesman
WHERE
    target_Achieved < 60;
-- 10. Write query to creates lists all products (Product_Number AS ID, Product_Name AS Name,
-- Quantity_On_Hand AS Quantity) and their stock status. Products with a positive quantity in stock are
-- labeled as 'More 5 pieces in Stock'. Products with zero quantity are labeled as ‘Less 5 pieces in Stock'.
SELECT 
    Product_Number AS ID,
    Product_Name AS Name,
    Quantity_On_Hand AS Quantity,
    CASE
        WHEN quantity_on_hand > 1 THEN 'More 5 pieces in Stock'
        ELSE 'Less 5 pieces in Stock'
    END AS StockStatus
FROM
    product
-- 11. Create a procedure stores get_clients_by_city () saves the all Clients in table. Then Call procedure stores.
DELIMITER //
create procedure get_clients_by_city(IN cityin VARCHAR(30))
begin
    SELECT * from clients where city = cityin;
end //
DELIMITER;
call get_clients_by_city("HaNoi");
-- 12. Drop get_clients _by_city () procedure stores.
drop procedure get_clients_by_city;
-- 13. Create a stored procedure to update the delivery status for a given order number. Change value delivery status of order number “O20006” and “O20008” to “On Way”.
DELIMITER //
create procedure update_delivery_status(In order1 VARCHAR(15), order2 VARCHAR(15))
begin
    UPDATE salesorder SET delivery_status = 'On Way' WHERE order_number = order1;
    UPDATE salesorder SET delivery_status = 'On Way' WHERE order_number = order2;
end //
DELIMITER ;
call update_delivery_status("O20006", "020008");
-- drop procedure update_delivery_status;
select * from salesorder;
-- 14. Create a stored procedure to retrieve the total quantity for each product.
DELIMITER //
create procedure total_quantity(IN productIn VARCHAR(25))
begin 
	SELECT quantity_on_hand+quantity_sell as total_quantity from product where product_name = productIn;
end //
DELIMITER ;
-- drop PROCEDURE total_quantity;
call total_quantity("Modem");
-- 15. Create a stored procedure to update the remarks for a specific salesman.
DELIMITER //
create procedure update_remarks(IN salesmanIn VARCHAR(25), remarkIn text)
begin 
	UPDATE salesman set remarks = salesmanIn where salseman_name = salesmanIn;
end //
DELIMITER ;
-- 16. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
DELIMITER //
create procedure find_clients(IN clientIn VARCHAR(25))
begin 
	SELECT * from clients where client_number = clientIn;
end //
DELIMITER ;
-- drop PROCEDURE find_clients;
call find_clients("C102");
-- 17. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name, salary) having salary >15000. Then execute the first 2 rows and the first 4 rows from the salesman table.
drop PROCEDURE salary_salesman;
DELIMITER //
CREATE PROCEDURE salary_salesman(IN limitIn INT)
BEGIN
    SELECT salesman_number, salesman_name, salary
    FROM Salesman
    WHERE salary > 15000
    LIMIT limitIn;
END //
DELIMITER ;
CALL salary_salesman(2);
CALL salary_salesman(4);
-- 18. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
DELIMITER //
CREATE PROCEDURE MySQL_MAX()
BEGIN
    SELECT MAX(salary) from salesman;
END //
DELIMITER ;
-- 19. Create a procedure stores execute finding amount of order_status by values order status of salesorder table.
DELIMITER //
CREATE PROCEDURE finding_amount_of_order_status(IN orderstatusIn VARCHAR(15))
BEGIN
    SELECT COUNT(order_status) from salesorder where Order_Status = orderstatusIn;
END //
DELIMITER ;
-- 20. Create a stored procedure to calculate and update the discount rate for orders.
-- 21. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000; SALARY = 20000.
SELECT 
    SUM(CASE WHEN salary < 20000 THEN 1 ELSE 0 END) AS salary_less_20000,
    SUM(CASE WHEN salary > 20000 THEN 1 ELSE 0 END) AS salary_greater_20000,
    SUM(CASE WHEN salary = 20000 THEN 1 ELSE 0 END) AS salary_equal_20000
FROM Salesman;
-- 22. Create a stored procedure to retrieve the total sales for a specific salesman.
DELIMITER //
CREATE PROCEDURE retrieve_the_total_sales(IN salesmannumberIn VARCHAR(15) )
BEGIN
    SELECT COUNT(*) from salesorder where salesman_number = salesmannumberIn;
END //
DELIMITER ;
-- 23. Create a stored procedure to add a new product: Input variables: Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price.
DELIMITER //
CREATE PROCEDURE add_a_new_product(IN numberIn VARCHAR(15),
    IN nameIn VARCHAR(25),
    IN quantityHandIn INT,
    IN quantitySell INT,
    IN sellpriceIn DECIMAL(15,4),
    IN costpriceIn DECIMAL(15,4))
BEGIN
    INSERT INTO Product (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price)
    VALUES (nameIn,quantityHandIn,quantitySell,sellpriceIn,sellpriceIn,costpriceIn);
END //
DELIMITER ;
-- 24. Create a stored procedure for calculating the total order value and classification:
-- - This stored procedure receives the order code (p_Order_Number) và return the total value
-- (p_TotalValue) and order classification (p_OrderStatus).
-- - Using the cursor (CURSOR) to browse all the products in the order (SalesOrderDetails ).
-- - LOOP/While: Browse each product and calculate the total order value.
-- - CASE WHEN: Classify orders based on total value:
-- Greater than or equal to 10000: "Large"
-- Greater than or equal to 5000: "Midium"
-- Less than 5000: "Small"
DELIMITER //
CREATE PROCEDURE calculate_order_value_and_classify(
    IN p_Order_Number VARCHAR(15),
    OUT p_TotalValue DECIMAL(15,4),
    OUT p_OrderStatus VARCHAR(10)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_Product_Number VARCHAR(15);
    DECLARE v_Order_Quantity INT;
    DECLARE v_Sell_Price DECIMAL(15,4);
    DECLARE v_Product_Total DECIMAL(15,4);

    DECLARE cur CURSOR FOR
        SELECT sod.Product_Number, sod.Order_Quantity, p.Sell_Price
        FROM SalesOrderDetails sod
        JOIN Product p ON sod.Product_Number = p.Product_Number
        WHERE sod.Order_Number = p_Order_Number;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET p_TotalValue = 0;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_Product_Number, v_Order_Quantity, v_Sell_Price;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET v_Product_Total = v_Order_Quantity * v_Sell_Price;
        SET p_TotalValue = p_TotalValue + v_Product_Total;
    END LOOP;

    CLOSE cur;

    CASE
        WHEN p_TotalValue >= 10000 THEN SET p_OrderStatus = 'Large';
        WHEN p_TotalValue >= 5000 THEN SET p_OrderStatus = 'Medium';
        ELSE SET p_OrderStatus = 'Small';
    END CASE;
END //
DELIMITER ;

