-- Create and use the database
DROP DATABASE HumanResourcesManagement;
CREATE DATABASE HumanResourcesManagement;
USE HumanResourcesManagement;

-- Create DEPARTMENT table first (without the managerID foreign key for now)
CREATE TABLE DEPARTMENT (
    departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    dateOfEmployment DATE NOT NULL
);

-- Create EMPLOYEES table
CREATE TABLE EMPLOYEES (
    employeeID VARCHAR(3) PRIMARY KEY,
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT
    -- FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
    -- FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

-- Create other tables
CREATE TABLE DEPARTMENTADDRESS (
    departmentID INT,
    address VARCHAR(30),
    PRIMARY KEY (departmentID, address),
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

CREATE TABLE PROJECTS (
    projectID INT PRIMARY KEY,
    projectName VARCHAR(30) NOT NULL,
    projectAddress VARCHAR(100) NOT NULL,
    departmentID INT,
    FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID)
);

CREATE TABLE ASSIGNMENT (
    employeeID VARCHAR(3),
    projectID INT,
    workingHour FLOAT NOT NULL,
    PRIMARY KEY (employeeID, projectID),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID),
    FOREIGN KEY (projectID) REFERENCES PROJECTS(projectID)
);

CREATE TABLE RELATIVE (
    employeeID VARCHAR(3),
    relativeName VARCHAR(50),
    gender VARCHAR(5) NOT NULL,
    dateOfBirth DATE, 
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY (employeeID, relativeName),
    FOREIGN KEY (employeeID) REFERENCES EMPLOYEES(employeeID)
);

-- Insert data into DEPARTMENT table (without managerID for now)
INSERT INTO DEPARTMENT (departmentID, departmentName, managerID, dateOfEmployment) VALUES
(1, 'Quan ly', '888','1971-06-19'),
(4, 'Dieu hanh', '777', '1985-01-01'),
(5, 'Nghien cuu', '333', '1978-05-22');

-- Insert data into EMPLOYEES table
INSERT INTO EMPLOYEES (employeeID, lastName, middleName, firstName, dateOfBirth, gender, salary, address, managerID, departmentID) VALUES 
('123', 'Dinh', 'Ba', 'Tien', '1995-01-09', 'Nam', 30000, '731 Tran Hung Dao Q1 TPHCM', '333', 5),
('333', 'Nguyen', 'Thanh', 'Tung', '1945-12-08', 'Nam', 40000, '638 Nguyen Van Cu Q5 TPHCM', '888', 5),
('453', 'Tran', 'Thanh', 'Tam', '1962-07-31', 'Nam', 25000, '543 Mai Thi Luu Ba Dinh Ha Noi', '333', 5),
('666', 'Nguyen', 'Manh', 'Hung', '1952-09-15', 'Nam', 38000, '975 Le Lai P3 Vung Tau', '333', 5),
('777', 'Tran', 'Hong', 'Quang', '1959-12-29', 'Nam', 25000, '980 Le Hong Phong Vung Tau', '987', 4),
('888', 'Vuong', 'Ngoc', 'Quyen', '1927-10-10', 'Nu', 55000, '450 Trung Vuong My Tho TG', NULL, 1),
('987', 'Le', 'Thi', 'Nhan', '1931-12-20', 'Nu', 43000, '291 Ho Van Hue QPV TPHCM', '888', 4),
('999', 'Bui', 'Thuy', 'Vu', '1958-07-19', 'Nam', 25000, '332 Nguyen Thai Hoc TAN BINH', '987', 4);

-- Add foreign key to DEPARTMENT after EMPLOYEES is populated
ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID);

ALTER TABLE EMPLOYEES
ADD FOREIGN KEY (managerID) REFERENCES EMPLOYEES(employeeID),
ADD FOREIGN KEY (departmentID) REFERENCES DEPARTMENT(departmentID);

-- Insert data into other tables
INSERT INTO DEPARTMENTADDRESS (departmentID, address) VALUES
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

INSERT INTO PROJECTS (projectID, projectName, projectAddress, departmentID) VALUES
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

INSERT INTO ASSIGNMENT (employeeID, projectID, workingHour) VALUES
('123', 1, 22.5),
('123', 2, 7.5),
('123', 3, 10),
('333', 10, 10),
('333', 20, 10),
('453', 1, 20),
('453', 2, 20),
('666', 3, 40),
('888', 20, 0),
('987', 20, 15);

INSERT INTO RELATIVE (employeeID, relativeName, gender, dateOfBirth, relationship) VALUES
('123', 'Chau', 'Nu', '1978-12-31', 'Con gai'),
('123', 'Duy', 'Nam', '1978-01-01', 'Con trai'),
('123', 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
('333', 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
('333', 'Quang', 'Nu', '1976-04-05', 'Con gai'),
('333', 'Tung', 'Nam', '1973-10-25', 'Con trai'),
('987', 'Dang', 'Nam', '1932-02-29', 'Vo chong');

-- Show the schema of all tables
DESCRIBE EMPLOYEES;
DESCRIBE DEPARTMENT;
DESCRIBE DEPARTMENTADDRESS;
DESCRIBE PROJECTS;
DESCRIBE ASSIGNMENT;
DESCRIBE RELATIVE;

-- Display the content of all tables
SELECT * FROM EMPLOYEES;
SELECT * FROM DEPARTMENT;
SELECT * FROM DEPARTMENTADDRESS;
SELECT * FROM PROJECTS;
SELECT * FROM ASSIGNMENT;
SELECT * FROM RELATIVE;