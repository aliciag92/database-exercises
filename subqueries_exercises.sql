-Use sub queries to find information in the employees database
-Create a file named subqueries_exercises.sql and craft queries to return the results for the following criteria:

#1. Find all the current employees with the same hire date as employee 101010 using a sub-query.
SELECT emp_no, first_name, last_name, hire_date
FROM employees
WHERE hire_date = 
	(SELECT hire_date
	FROM employees
	WHERE emp_no = '101010');

#2. Find all the titles ever held by all current employees with the first name Aamod.
SELECT first_name, last_name, title 
FROM employees
JOIN titles USING (emp_no)
WHERE emp_no IN 
	(SELECT emp_no
	FROM titles
	WHERE to_date > curdate() and first_name = 'Aamod');

#3. How many people in the employees table are no longer working for the company? Give the answer in a comment in your code.
SELECT *
FROM employees
WHERE emp_no NOT IN
	(SELECT emp_no
	FROM dept_emp
	WHERE to_date < now()); #59900

#4. Find all the current department managers that are female. List their names in a comment in your code.
SELECT first_name, last_name, gender
FROM employees
JOIN dept_manager USING (emp_no)
WHERE emp_no IN
	(SELECT emp_no
	FROM dept_manager
	WHERE to_date > curdate() AND gender = 'F'); #Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil

#5. Find all the employees who currently have a higher salary than the companies overall, historical average salary.
SELECT AVG(salary)
from employees
JOIN salaries USING (emp_no);

SELECT first_name, last_name, salary
FROM employees
JOIN salaries USING (emp_no)
WHERE emp_no IN 
	(SELECT emp_no
	FROM salaries
	WHERE salaries.to_date > curdate() AND salary > 63810.7448)
AND salaries.to_date > curdate();

#6. How many current salaries are within 1 standard deviation of the current highest salary? (Hint: you can use a built in function to calculate the standard deviation.) What percentage of all salaries is this?
select
 (Select count(salary)
 from salaries
 where salary > (
        Select 
        max(salary) - STDDEV(salary)
        from salaries
        Where to_date > curdate())
 AND to_date > curdate())
 /
 (select
 count(salary)
 from salaries
 Where to_date > curdate())
 *100;



-BONUS

#1. Find all the department names that currently have female managers.
SELECT dept_name
FROM employees
JOIN dept_manager USING (emp_no)
JOIN departments USING (dept_no)
WHERE emp_no IN 
	(SELECT emp_no
	FROM dept_manager 
	WHERE to_date > curdate() AND gender = 'F');

#2. Find the first and last name of the employee with the highest salary.
SELECT first_name, last_name, salary
FROM employees
JOIN salaries USING (emp_no)
WHERE emp_no IN 
	(SELECT emp_no
	FROM salaries
	WHERE to_date > curdate())
ORDER BY salary DESC
LIMIT 1;

#3. Find the department name that the employee with the highest salary works in.
SELECT first_name, last_name, salary, dept_name
FROM employees
JOIN salaries USING (emp_no)
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
WHERE emp_no IN 
	(SELECT emp_no
	FROM salaries
	WHERE to_date > curdate())
ORDER BY salary DESC
LIMIT 1;