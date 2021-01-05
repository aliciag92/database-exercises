- Create a file named join_exercises.sql to do your work in.

Join Example Database
#1. Use the join_example_db. Select all the records from both the users and roles tables.
USE join_example_db;

SELECT *
from users;

SELECT *
FROM roles;



#2. Use join, left join, and right join to combine results from the users and roles tables as we did in the lesson. Before you run each query, guess the expected number of results.
SELECT *
FROM users
JOIN roles ON users.id = roles.id;

SELECT *
FROM users
LEFT JOIN roles ON users.id = roles.id;

SELECT *
FROM users
RIGHT JOIN roles ON users.id = roles.id;



#3. Although not explicitly covered in the lesson, aggregate functions like count can be used with join queries. Use count and the appropriate join type to get a list of roles along with the number of users that has the role. Hint: You will also need to use group by in the query.
SELECT roles.name, COUNT (*)
FROM users
JOIN roles ON users.id = roles.id;
GROUP BY roles.name;
???
(needs work)




Employees Database
#1. Use the employees database.
USE employees;



#2. Using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of the current manager for that department.
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Department Manager'
FROM employees
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_manager.dept_no
WHERE to_date > curdate()
ORDER BY 'Department Name';

  Department Name    | Department Manager
 --------------------+--------------------
  Customer Service   | Yuchang Weedman
  Development        | Leon DasSarma
  Finance            | Isamu Legleitner
  Human Resources    | Karsten Sigstam
  Marketing          | Vishwani Minakawa
  Production         | Oscar Ghazalie
  Quality Management | Dung Pesch
  Research           | Hilary Kambil
  Sales              | Hauke Zhang



#3. Find the name of all departments currently managed by women.
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Department Manager'
FROM employees
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_manager.dept_no
WHERE to_date > curdate() AND gender = 'F'; 

Department Name | Manager Name
----------------+-----------------
Development     | Leon DasSarma
Finance         | Isamu Legleitner
Human Resources | Karsetn Sigstam
Research        | Hilary Kambil



#4. Find the current titles of employees currently working in the Customer Service department.
SELECT title, count(*)
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN titles ON titles.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE titles.to_date > curdate() AND dept_name = 'Customer Service'
GROUP BY title;

Title              | Count
-------------------+------
Assistant Engineer |    68
Engineer           |   627
Manager            |     1
Senior Engineer    |  1790
Senior Staff       | 11268
Staff              |  3574
Technique Leader   |   241



#5. Find the current salary of all current managers.
SELECT departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Name', Salary
FROM employees
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_manager.dept_no
JOIN salaries ON salaries.emp_no = dept_manager.emp_no
WHERE salaries.to_date > curdate() AND dept_manager.to_date > curdate();

Department Name    | Name              | Salary
-------------------+-------------------+-------
Customer Service   | Yuchang Weedman   |  58745
Development        | Leon DasSarma     |  74510
Finance            | Isamu Legleitner  |  83457
Human Resources    | Karsten Sigstam   |  65400
Marketing          | Vishwani Minakawa | 106491
Production         | Oscar Ghazalie    |  56654
Quality Management | Dung Pesch        |  72876
Research           | Hilary Kambil     |  79393
Sales              | Hauke Zhang       | 101987



#6. Find the number of current employees in each department.
SELECT departments.dept_no, dept_name, count(*) AS num_employees
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_emp.to_date > curdate()
group by departments.dept_no;

+---------+--------------------+---------------+
| dept_no | dept_name          | num_employees |
+---------+--------------------+---------------+
| d001    | Marketing          | 14842         |
| d002    | Finance            | 12437         |
| d003    | Human Resources    | 12898         |
| d004    | Production         | 53304         |
| d005    | Development        | 61386         |
| d006    | Quality Management | 14546         |
| d007    | Sales              | 37701         |
| d008    | Research           | 15441         |
| d009    | Customer Service   | 17569         |
+---------+--------------------+---------------+



#7. Which department has the highest average salary? Hint: Use current not historic information.
SELECT departments.dept_name, AVG(salary) AS average_salary
FROM employees
JOIN dept_emp on dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON salaries.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date > curdate() AND salaries.to_date > curdate()
GROUP BY departments.dept_name
ORDER BY average_salary DESC
LIMIT 1;

+-----------+----------------+
| dept_name | average_salary |
+-----------+----------------+
| Sales     | 88852.9695     |
+-----------+----------------+



#8. Who is the highest paid employee in the Marketing department?
SELECT first_name, last_name
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON salaries.emp_no = dept_emp.emp_no
WHERE departments.dept_name = 'Marketing' AND salaries.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Akemi      | Warwick   |
+------------+-----------+



#9. Which current department manager has the highest salary?
SELECT first_name, last_name, salary, dept_name
FROM employees
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_manager.dept_no
JOIN salaries ON salaries.emp_no = dept_manager.emp_no
WHERE dept_manager.to_date > curdate() AND salaries.to_date > curdate()
ORDER BY salary DESC
LIMIT 1;

+------------+-----------+--------+-----------+
| first_name | last_name | salary | dept_name |
+------------+-----------+--------+-----------+
| Vishwani   | Minakawa  | 106491 | Marketing |
+------------+-----------+--------+-----------+



#10. Bonus Find the names of all current employees, their department name, and their current manager''s name.
SELECT CONCAT(employees.first_name, ' ', employees.last_name) AS 'Employee Name', departments.dept_name AS 'Department Name', CONCAT(employees.first_name, ' ', employees.last_name) AS 'Manager Name'
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN dept_manager ON dept_manager.emp_no = employees.emp_no
JOIN departments ON departments.dept_no = dept_manager.dept_no
WHERE dept_emp.to_date > curdate() and dept_manager.to_date > curdate(); 
??? (needs work)

240,124 Rows

Employee Name | Department Name  |  Manager Name
--------------|------------------|-----------------
 Huan Lortz   | Customer Service | Yuchang Weedman

 .....



#11. Bonus Who is the highest paid employee within each department.
SELECT first_name, last_name, salary, dept_name
FROM employees
JOIN dept_emp ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN salaries ON salaries.emp_no = dept_emp.emp_no
WHERE salaries.to_date > curdate()
ORDER BY salary DESC;
??? (needs work)