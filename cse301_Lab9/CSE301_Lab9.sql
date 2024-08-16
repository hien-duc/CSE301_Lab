USE HumanResourcesManagement;

-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employees add CONSTRAINT chk_gender check (gender = 'Nam' or gender ='Nu');

-- 2. Check constraint to value of salary > 0.
alter table employees add CONSTRAINT chk_salary check (salary > 0);

-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con
-- gai”, “Me ruot”, “Cha ruot”. 
alter table relative add CONSTRAINT chk_relationship CHECK( relationship in ("Con trai", "Congai", "Me ruot", "Cha ruot"));

-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above
-- 30,000 in room 5.
SELECT * from employees where salary > 25.000 and departmentID = 4;

-- 2. Provide full names of employees in HCM city.
select lastname, middleName, firstName from employees where address like "%TPHCM";

-- 3. Indicate the date of birth of Dinh Ba Tien staff.
select dateOfbirth from employees where concat(lastname, " ", middlename, " ", firstname) = "Dinh Ba Tien";

-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this
-- employee is directly managed by "Nguyen Thanh Tung".
SELECT DISTINCT e.lastName, e.middleName, e.firstName
FROM EMPLOYEES e
JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
JOIN PROJECTS p ON a.projectID = p.projectID
WHERE e.departmentID = 5
AND p.projectName = 'San pham X'
AND e.managerID = (SELECT employeeID FROM EMPLOYEES 
                   WHERE lastName = 'Nguyen' AND middleName = 'Thanh' AND firstName = 'Tung');
                   
-- 5. Find the names of department heads of each department.
select e.lastname, e.middleName, e.firstName from employees e JOIN department d on
e.managerID = d.managerID;

-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName,
-- departmentID, date0fEmployment.
select projectID, projectName, projectAddress, departmentName, p.departmentID, dateOfEmployment from
projects p join department d on p.departmentID = p.departmentID;

-- 7. Find the names of female employees and their relatives
SELECT lastName, middleName, firstName from employees e join
relative r on e.employeeID = r.employeeID where e.gender = 'Nu';

-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead
-- department (departmentID), the full name of the manager (lastName, middleName,
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the
-- Employees.
SELECT p.projectID, p.departmentID, e.lastName, e.middleName, e.firstName, e.address, e.dateOfBirth
FROM PROJECTS p
JOIN DEPARTMENT d ON p.departmentID = d.departmentID
JOIN EMPLOYEES e ON d.managerID = e.employeeID
WHERE p.projectAddress = 'HA NOI';

-- 9. For each employee, include the employee's full name and the employee's line manager.
SELECT e.lastName, e.middleName, e.firstName, 
       m.lastName AS managerLastName, m.middleName AS managerMiddleName, m.firstName AS managerFirstName
FROM EMPLOYEES e
LEFT JOIN EMPLOYEES m ON e.managerID = m.employeeID;

-- 10. For each employee, indicate the employee's full name and the full name of the head of the
-- department in which the employee works.
SELECT e.lastName, e.middleName, e.firstName,
       m.lastName AS deptHeadLastName, m.middleName AS deptHeadMiddleName, m.firstName AS deptHeadFirstName
FROM EMPLOYEES e
JOIN DEPARTMENT d ON e.departmentID = d.departmentID
JOIN EMPLOYEES m ON d.managerID = m.employeeID;

-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of
-- the projects in which the employee participated, if any.
SELECT e.lastName, e.middleName, e.firstName, p.projectName
FROM EMPLOYEES e
LEFT JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
LEFT JOIN PROJECTS p ON a.projectID = p.projectID;

-- 12. For each scheme, list the scheme name (projectName) and the total number of hours
-- worked per week of all employees attending that scheme.
SELECT p.projectName, SUM(a.workingHour) AS totalHours
FROM PROJECTS p
LEFT JOIN ASSIGNMENT a ON p.projectID = a.projectID
GROUP BY p.projectID, p.projectName;

-- 13. For each department, list the name of the department (departmentName) and the average
-- salary of the employees who work for that department.
SELECT d.departmentName, AVG(e.salary) AS avgSalary
FROM DEPARTMENT d
JOIN EMPLOYEES e ON d.departmentID = e.departmentID
GROUP BY d.departmentID, d.departmentName;

-- 14. For departments with an average salary above 30,000, list the name of the department and
-- the number of employees of that department.
SELECT d.departmentName, COUNT(e.employeeID) AS employeeCount
FROM DEPARTMENT d
JOIN EMPLOYEES e ON d.departmentID = e.departmentID
GROUP BY d.departmentID, d.departmentName
HAVING AVG(e.salary) > 30000;

-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh'
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
SELECT DISTINCT p.projectID
FROM PROJECTS p
LEFT JOIN ASSIGNMENT a ON p.projectID = a.projectID
LEFT JOIN EMPLOYEES e ON a.employeeID = e.employeeID
LEFT JOIN DEPARTMENT d ON p.departmentID = d.departmentID
LEFT JOIN EMPLOYEES dm ON d.managerID = dm.employeeID
WHERE e.lastName = 'Dinh' OR dm.lastName = 'Dinh';

-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives.
SELECT e.lastName, e.middleName, e.firstName
FROM EMPLOYEES e
JOIN RELATIVE r ON e.employeeID = r.employeeID
GROUP BY e.employeeID, e.lastName, e.middleName, e.firstName
HAVING COUNT(r.relativeName) > 2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
SELECT e.lastName, e.middleName, e.firstName
FROM EMPLOYEES e
LEFT JOIN RELATIVE r ON e.employeeID = r.employeeID
WHERE r.employeeID IS NULL;

-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
SELECT e.lastName, e.middleName, e.firstName
FROM EMPLOYEES e
JOIN DEPARTMENT d ON e.employeeID = d.managerID
JOIN RELATIVE r ON e.employeeID = r.employeeID
GROUP BY e.employeeID, e.lastName, e.middleName, e.firstName;

-- 19. Find the surname (lastName) of unmarried department heads.
SELECT e.lastName
FROM EMPLOYEES e
JOIN DEPARTMENT d ON e.employeeID = d.managerID
LEFT JOIN RELATIVE r ON e.employeeID = r.employeeID AND r.relationship = 'Vo chong'
WHERE r.employeeID IS NULL;

-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary
-- is above the average salary of the "Research" department.
SELECT e.lastName, e.middleName, e.firstName
FROM EMPLOYEES e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM EMPLOYEES
    WHERE departmentID = (SELECT departmentID FROM DEPARTMENT WHERE departmentName = 'Nghien cuu')
);

-- 21. Indicate the name of the department and the full name of the head of the department with
-- the largest number of employees.
SELECT d.departmentName, e.lastName, e.middleName, e.firstName
FROM DEPARTMENT d
JOIN EMPLOYEES e ON d.managerID = e.employeeID
WHERE d.departmentID = (
    SELECT departmentID
    FROM EMPLOYEES
    GROUP BY departmentID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of
-- employees who work on a project in 'HCMC' but the department they belong to is not
-- located in 'HCMC'.
SELECT DISTINCT e.lastName, e.middleName, e.firstName, e.address
FROM EMPLOYEES e
JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
JOIN PROJECTS p ON a.projectID = p.projectID
JOIN DEPARTMENT d ON e.departmentID = d.departmentID
LEFT JOIN DEPARTMENTADDRESS da ON d.departmentID = da.departmentID AND da.address = 'TP HCM'
WHERE p.projectAddress = 'TP HCM' AND da.departmentID IS NULL;

-- 23. Find the names and addresses of employees who work on a scheme in a city but the
-- department to which they belong is not located in that city.
SELECT DISTINCT e.lastName, e.middleName, e.firstName, e.address
FROM EMPLOYEES e
JOIN ASSIGNMENT a ON e.employeeID = a.employeeID
JOIN PROJECTS p ON a.projectID = p.projectID
JOIN DEPARTMENT d ON e.departmentID = d.departmentID
LEFT JOIN DEPARTMENTADDRESS da ON d.departmentID = da.departmentID AND da.address = p.projectAddress
WHERE da.departmentID IS NULL;

-- 24. Create procedure List employee information by department with input data
-- departmentName.
DELIMITER //
CREATE PROCEDURE ListEmployeesByDepartment(IN dept_name VARCHAR(10))
BEGIN
    SELECT e.*
    FROM EMPLOYEES e
    JOIN DEPARTMENT d ON e.departmentID = d.departmentID
    WHERE d.departmentName = dept_name;
END //
DELIMITER ;

-- 25. Create a procedure to Search for projects that an employee participates in based on the
-- employee's last name (lastName).
DELIMITER //
CREATE PROCEDURE SearchProjectsByEmployeeLastName(IN last_name VARCHAR(20))
BEGIN
    SELECT DISTINCT p.*
    FROM PROJECTS p
    JOIN ASSIGNMENT a ON p.projectID = a.projectID
    JOIN EMPLOYEES e ON a.employeeID = e.employeeID
    WHERE e.lastName = last_name;
END //
DELIMITER ;

-- 26. Create a function to calculate the average salary of a department with input data
-- departmentID.
DELIMITER //
CREATE FUNCTION CalculateAvgSalaryByDepartment(dept_id INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_salary
    FROM EMPLOYEES
    WHERE departmentID = dept_id;
    RETURN avg_salary;
END //
DELIMITER ;

-- 27. Create a function to Check if an employee is involved in a particular project input data is
-- employeeID, projectID.
DELIMITER //
CREATE FUNCTION IsEmployeeInvolvedInProject(emp_id VARCHAR(3), proj_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_involved BOOLEAN;
    SELECT EXISTS(
        SELECT 1
        FROM ASSIGNMENT
        WHERE employeeID = emp_id AND projectID = proj_id
    ) INTO is_involved;
    RETURN is_involved;
END //
DELIMITER ;
