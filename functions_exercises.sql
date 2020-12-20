#1. Copy the order by exercise and save it as functions_exercises.sql.
USE employees;

#2. Write a query to to find all current employees whose last name starts and ends with 'E'. Use concat() to combine their first and last name together as a single column named full_name.
SELECT concat(first_name, " ", last_name) as full_name
from employees
WHERE last_name LIKE 'e%e';


#3. Convert the names produced in your last query to all uppercase.
SELECT UPPER(concat(first_name, " ", last_name)) as full_name
from employees
WHERE last_name LIKE 'e%e';


#4. Find all previous employees hired in the 90s and born on Christmas. Use datediff() function to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE()),
SELECT first_name, last_name, DATEDIFF(CURDATE(), hire_date) AS days_employed
FROM employees
WHERE hire_date LIKE '199%' and birth_date LIKE '%-12-25';


#5. Find the smallest and largest current salary from the salaries table.
SELECT MIN(salary), MAX(salary)
FROM salaries
WHERE to_date > curdate();

#or

SELECT MIN(salary) as smallest_emp_salary, MAX(salary) as highest_emp_salary
FROM salaries;

#6. Use your knowledge of built in SQL functions to generate a username for all of the current and previous employees. A username should be all lowercase, and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, the month the employee was born, and the last two digits of the year that they were born. Below is an example of what the first 10 rows will look like:
SELECT LOWER(CONCAT(SUBSTR(first_name, 1, 1), SUBSTR(last_name, 1, 4), '_', SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2))) AS username, first_name, last_name, birth_date
FROM employees;

#or

SELECT LOWER(
            CONCAT(
        SUBSTR(first_name, 1, 2),
        SUBSTR(last_name, 1, 4),
        "_",
        SUBSTR(birth_date, 6, 2),
        SUBSTR(birth_date, 3, 2)
            )) AS username, first_name, last_name, birth_date
FROM employees;

#or

SELECT LOWER(
        CONCAT(
    SUBSTR(first_name, 1, 1), 
    SUBSTR(last_name, 1, 4),
    '_', 
    SUBSTR(CAST(birth_date AS CHAR), 6, 2)
        )) AS username, first_name, last_name, birth_date
FROM employees;

#+------------+------------+-----------+------------+
#| username   | first_name | last_name | birth_date |
#+------------+------------+-----------+------------+
#| gface_0953 | Georgi     | Facello   | 1953-09-02 |
#| bsimm_0664 | Bezalel    | Simmel    | 1964-06-02 |
#| pbamf_1259 | Parto      | Bamford   | 1959-12-03 |
#| ckobl_0554 | Chirstian  | Koblick   | 1954-05-01 |
#| kmali_0155 | Kyoichi    | Maliniak  | 1955-01-21 |
#| apreu_0453 | Anneke     | Preusig   | 1953-04-20 |
#| tziel_0557 | Tzvetan    | Zielinski | 1957-05-23 |
#| skall_0258 | Saniya     | Kalloufi  | 1958-02-19 |
#| speac_0452 | Sumant     | Peac      | 1952-04-19 |
#| dpive_0663 | Duangkaew  | Piveteau  | 1963-06-01 |
#+------------+------------+-----------+------------+
#10 rows in set (0.05 sec)