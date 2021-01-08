-Use CASE statements or IF() function to explore information in the employees database
-Create a file named case_exercises.sql and craft queries to return the results for the following criteria:
USE employees;

#1. Write a query that returns all employees (emp_no), their department number, their start date, their end date, and a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.
SELECT emp_no, dept_no, from_date, to_date,
	CASE
		WHEN to_date > curdate() THEN 1
		ELSE 0
	END AS is_current_employee
FROM employees
JOIN dept_emp USING (emp_no); #331603

#using if() function:
SELECT emp_no, dept_no, from_date, to_date, 
	IF(to_date = '9999-01-01', 1, 0) AS is_current_employee
FROM dept_emp; #331603. Shows more employees that there actually are. We are getting more cause emp_no is duplicated due to same employee at with multiple departments. 

#to correct this, do subquery:
SELECT emp_no, MAX(to_date) AS max_date
FROM dept_emp
GROUP BY emp_no; #300024

#correct solution:
SELECT dept_emp.dept_no, dept_emp.emp_no, dept_no, from_date, to_date, hire_date,
	IF(to_date = '9999-01-01', 1, 0) AS is_current_employee,
	IF(hire_date = from_date, 1, 0) AS only_one_dept 
FROM dept_emp
JOIN (SELECT emp_no, MAX(to_date) AS max_date
	FROM dept_emp
	GROUP BY emp_no) AS last_dept
ON dept_emp.emp_no = last_dept.emp_no AND dept_emp.to_date = last_dept.max_date
JOIN employees AS e ON e.emp_no = dept_emp.emp_no;


#2. Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.
SELECT first_name, last_name, to_date,
	CASE
		WHEN last_name >= 'A%' AND last_name <= 'H%' THEN 'A-H'
		WHEN last_name >= 'I%' AND last_name <= 'Q%' THEN 'I-Q'
		ELSE 'R-Z'
	END AS alpha_group
FROM employees
JOIN dept_emp USING (emp_no)
order by alpha_group, last_name;

#alternate: 
select first_name, last_name, 
case
	when last_name < 'I' then 'A-H'
	when last_name < 'R' then 'I-Q'
	when last_name > 'Q' then 'R-Z'	
	else null
	end as alpha_group	
from employees;

#alternate solution: Using REGEXP 'Regular Expression' ( ^ = Start of string, | = or ) 
select 
	case 	when last_name REGEXP '^(A|B|C|D|E|F|G|H)' then 'A-H'
			when last_name REGEXP '^(I|J|K|L|M|N|O|P|Q)' then 'I-Q'
			when last_name REGEXP '^(R|S|T|U|V|W|X|Y|Z)' then 'R-Z'
	end as alpha_group,
			count(*)
from employees
group by alpha_group;

#alternate:
select first_name, last_name,
	CASE
		WHEN LEFT(last_name, 1) >= 'A' AND LEFT(last_name, 1) <= 'H' THEN 'A-H'
		WHEN LEFT(last_name, 1) >= 'I' AND LEFT(last_name, 1) <= 'Q' THEN 'I-Q'
		ELSE 'R-Z'
	END as alpha_group
from employees
group by first_name, last_name; 

#The LEFT() function extracts a number of characters from a string (starting from left). If the number exceeds the number of characters in string, it returns string
#Syntax: LEFT(string, number_of_chars)
#Example: Extract 3 characters from a string (starting from left): 
SELECT LEFT('SQL Tutorial', 3) AS ExtractString; #SQL

#Example: Extract 100 characters from a string (starting from left):
SELECT LEFT('SQL Tutorial', 100) AS ExtractString; #SQL Tutorial

#3. How many employees (current or previous) were born in each decade?
SELECT  
	COUNT(CASE
			WHEN birth_date LIKE '195%' THEN 1 END) as "employees_born_in_50s",
	COUNT(CASE
			WHEN birth_date LIKE '196%' THEN 1 END) as "employees_born_in_60s"
FROM employees;

#alternate solution:
-- Oldest birth dates in 1952, 19605 the most recent.
SELECT * 
FROM employees
ORDER BY birth_date DESC
LIMIT 5;

-- Create and count the decade bins.
SELECT
	CASE
		WHEN birth_date LIKE '195%' THEN '50s'
		WHEN birth_date LIKE '196%' THEN '60s'
		ELSE 'YOUNG' 		#good to have an else statement just in case
	END AS decade,
	COUNT(*)
FROM employees
GROUP BY decade;

#-BONUS
#1. What is the current average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
SELECT 
	CASE
		WHEN dept_name IN ('Research', 'Development') THEN 'R&D'
		WHEN dept_name IN ('Sales', 'Marketing') THEN 'Sales & Marketing'
		WHEN dept_name IN ('Production', 'Quality Management') THEN 'Prod & QM'
		WHEN dept_name IN ('Finance', 'Human Resources') THEN 'Finance & HR' 
		ELSE 'Customer Service'
	END AS department_group,
	ROUND(AVG(salary), 2) AS average_salary
FROM salaries
JOIN employees_with_departments ON salaries.emp_no = employees_with_departments.emp_no AND salaries.to_date > CURDATE()
GROUP BY department_group; 
+-------------------+-----------------+
| dept_group        | avg_salary      |
+-------------------+-----------------+
| Customer Service  |                 |
| Finance & HR      |                 |
| Sales & Marketing |                 |
| Prod & QM         |                 |
| R&D               |                 |
+-------------------+-----------------+