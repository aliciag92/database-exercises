#-Create a file named temporary_tables.sql to do your work for this exercise.

#1. Using the example from the lesson, re-create the employees_with_departments table.
USE easley_1260;

CREATE TEMPORARY TABLE emps_w_depts AS 
	(SELECT *
	FROM employees.employees_with_departments);

SELECT *
FROM emps_w_depts;


#1a. Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
ALTER TABLE emps_w_depts
ADD full_name VARCHAR(100);

SELECT *
FROM emps_w_depts;


#1b. Update the table so that full name column contains the correct data
UPDATE emps_w_depts
SET full_name = CONCAT(first_name, ' ', last_name);

SELECT *
FROM emps_w_depts;


#1c. Remove the first_name and last_name columns from the table.
ALTER TABLE emps_w_depts
DROP COLUMN first_name;

ALTER TABLE emps_w_depts
DROP COLUMN last_name;

SELECT *
FROM emps_w_depts;


#1d. What is another way you could have ended up with this same table?
ALTER TABLE emps_w_depts 
DROP COLUMN first_name,
DROP COLUMN last_name;


#2.Create a temporary table based on the payment table from the sakila database.
CREATE TEMPORARY TABLE sak_pay AS
	(SELECT *
	FROM sakila.payment);

select *
from sak_pay;


#2a. Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. For example, 1.99 should become 199.
ALTER TABLE sak_pay
ADD new_amount INT;

UPDATE sak_pay
SET new_amount = amount * 100;

ALTER TABLE sak_pay
DROP COLUMN amount;

ALTER TABLE sak_pay
CHANGE COLUMN new_amount amount int;

#another solution:
select *
from sakila.payment;
CREATE TEMPORARY TABLE new_payment1 AS (
		SELECT *
		FROM sakila.payment);
select *
from new_payment1;
# Write the SQL necessary to transform the amount column such that it is stored as an integer representing the number of cents of the payment. 
# For example, 1.99 should become 199.
Alter table new_payment1 
modify AMOUNT DECIMAL(10, 4);
UPDATE new_payment1
SET AMOUNT = AMOUNT * 100;
Alter table new_payment1 
modify AMOUNT INT;

#3. Find out how the current average pay in each department compares to the overall, historical average pay. 
CREATE TEMPORARY TABLE dept_salaries AS
	(SELECT emp_no, first_name, last_name, dept_name, salary, to_date
	FROM employees.employees_with_departments
	JOIN employees.salaries USING (emp_no));
	
Select *
from dept_salaries;

#finds companies overall salary
SELECT AVG(salary)
FROM dept_salaries; #63805.4005
#finds the companies overall salary

SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Sales' AND to_date > curdate(); #88842.1590
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Marketing' AND to_date > curdate(); #80014.6861
 
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Finance' AND to_date > curdate(); #78644.9069
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Human Resources' AND to_date > curdate(); #63795.0217

SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Production' AND to_date > curdate(); #67841.9487
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Development' AND to_date > curdate(); #67665.6241
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Quality Management' AND to_date > curdate(); #65382.0637
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Research' AND to_date > curdate(); #67932.7147
	
SELECT AVG(salary), dept_name
	FROM dept_salaries
	WHERE dept_name = 'Customer Service' AND to_date > curdate(); #66971.3536

#In order to make the comparison easier, you should use the Z-score for salaries. 
#In terms of salary, what is the best department right now to work for? The worst? Best is Sales and worst is Human resources.


#alternate solution
-- Obtain the average histortic salary and the historic standard deviation of salary
-- Write the numbers down:
-- 63,810 historic average salary
-- 16,904 historic standard deviation
select avg(salary) as avg_salary, std(salary) as std_salary
from employees.salaries	;

create temporary table current_info as (
	select dept_name, avg(salary) as department_current_average
	from employees.salaries
	join employees.dept_emp using(emp_no)
	join employees.departments using(dept_no)
	where employees.dept_emp.to_date > curdate()
	and employees.salaries.to_date > curdate()
	group by dept_name
);

-- Create columns to hold the average salary, std, and the zscore
alter table current_info add average float(10,2);
alter table current_info add standard_deviation float(10,2);
alter table current_info add zscore float(10,2);

update current_info set average = 63810;
update current_info set standard_deviation = 16904;

-- z_score  = (avg(x) - x) / std(x) */
update current_info 
set zscore = (department_current_average - historic_avg) / historic_std;

select * from current_info
order by zscore desc;

#alternate solution
-- Historic average and standard deviation b/c the problem says "use historic average"
-- 63,810 historic average salary
-- 16,904 historic standard deviation
create temporary table historic_aggregates as (
	select avg(salary) as avg_salary, std(salary) as std_salary
	from employees.salaries	
);

create temporary table current_info as (
	select dept_name, avg(salary) as department_current_average
	from employees.salaries
	join employees.dept_emp using(emp_no)
	join employees.departments using(dept_no)
	where employees.dept_emp.to_date > curdate()
	and employees.salaries.to_date > curdate()
	group by dept_name
);

select * from current_info;

alter table current_info add historic_avg float(10,2);
alter table current_info add historic_std float(10,2);
alter table current_info add zscore float(10,2);

update current_info set historic_avg = (select avg_salary from historic_aggregates);
update current_info set historic_std = (select std_salary from historic_aggregates);

select * from current_info;

update current_info 
set zscore = (department_current_average - historic_avg) / historic_std;

select * from current_info
order by zscore desc;

#alternate solution
/* Exercise 3 More complicated version where we compare the zscores and averages from both historic and current:
We calculate historic average and historic standard deviation in order to produce historic zscores
We also calcyulate current average and current standard deviation in order to produce current zscores
Find out how the current average pay in each department compares to the overall, historical average pay. 
In order to make the comparison easier, you should use the Z-score for salaries. 
In terms of salary, what is the best department right now to work for? The worst? 
z_score  = (avg(x) - x) / std(x) */

use easley_1260;

-- Produce the query to get current avg and current stddev
-- 72,012 is the average
-- 17,309 is the standard deviation
-- Create a table to hold the results
create temporary table current_aggregates as (
    select avg(salary) as avg_salary, std(salary) as std_salary
    from employees.salaries	
    where employees.salaries.to_date > curdate()
);

create temporary table current_info as (
	select dept_name, avg(salary) as department_current_average
	from employees.salaries
	join employees.dept_emp using(emp_no)
	join employees.departments using(dept_no)
	where employees.dept_emp.to_date > curdate()
	and employees.salaries.to_date > curdate()
	group by dept_name
);

select * from current_info;

alter table current_info add current_company_avg float(10,2);
alter table current_info add current_company_std float(10,2);
alter table current_info add current_company_zscore float(10,2);

select * from current_info;

update current_info set current_company_avg = (select avg_salary from current_aggregates);
update current_info set current_company_std = (select std_salary from current_aggregates);

select * from current_info;

update current_info 
set current_company_zscore = (department_current_average - current_company_avg) / current_company_std;

select * from current_info;

-- Now, let's calculate historic stuff!

-- Historic average and standard deviation
-- 63,810 historic average salary
-- 16,904 historic standard deviation
create temporary table historic_aggregates as (
	select avg(salary) as avg_salary, std(salary) as std_salary
	from employees.salaries	
);

create temporary table historic_info as (
	select dept_name, avg(salary) as department_historic_average
	from employees.salaries
	join employees.dept_emp using(emp_no)
	join employees.departments using(dept_no)
	group by dept_name
);

alter table historic_info add historic_company_avg float(10,2);
alter table historic_info add historic_company_std float(10,2);
alter table historic_info add historic_company_zscore float(10,2);

update historic_info set historic_company_avg = (select avg_salary from historic_aggregates);
update historic_info set historic_company_std = (select std_salary from historic_aggregates);

update historic_info 
set historic_company_zscore = (department_historic_average - historic_company_avg) / historic_company_std;


select dept_name, historic_company_zscore, current_company_zscore
from historic_info
join current_info using(dept_name);