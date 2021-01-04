#1. In your script, use DISTINCT to find the unique titles in the titles table. How many unique titles have there ever been? Answer that in a comment in your SQL file.

#2. Write a query to to find a list of all unique last names of all employees that start and end with 'E' using GROUP BY.

#3. Write a query to to find all unique combinations of first and last names of all employees whose last names start and end with 'E'.

#4. Write a query to find the unique last names with a 'q' but not 'qu'. Include those names in a comment in your sql code.

#5. Add a COUNT() to your results (the query above) and use ORDER BY to make it easier to find employees whose unusual name is shared with others.

#6. Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.

#7. Using your query that generates a username for all of the employees, generate a count employees for each unique username. Are there any duplicate usernames? 

#7. BONUS: How many duplicate usernames are there?

select lower(
	concat(
	substr(first_name, 1, 1),
	substr(last_name, 1, 4),
	"_",
	substr(birth_date, 6, 2),
	substr(birth_date, 3, 2)
	))
as "username", count(*)
from employees
group by username
order by count(*) DESC;