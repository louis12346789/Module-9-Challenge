-- ------------------------------------------------------------------
-- QUERIES
-- ------------------------------------------------------------------

-- 1. List the employee number, last name, first name, sex, and salary of each employee
SELECT emp_no AS "Employee Number", last_name AS "Last Name", first_name AS "First Name", sex AS "Sex",
(SELECT salary AS "Salary"
	FROM salaries
	WHERE employees.emp_no = salaries.emp_no)
FROM employees;


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
-- REFERENCED STACKOVERFLOW #42269987 for casting as string
SELECT first_name AS "First Name", last_name AS "Last Name", hire_date AS "Hire Date" 
FROM employees
WHERE CAST(hire_date AS VARCHAR) LIKE '1986%';


-- 3. List the manager of each department along with their department number, department name, 
--    employee number, last name, and first name.
SELECT dept_no AS "Department Number",
(SELECT departments.dept_name AS "Department Name"
	FROM departments
	WHERE dept_manager.dept_no = departments.dept_no),
		emp_no AS "Employee Number", 
		(SELECT employees.first_name AS "Manager First Name"
			FROM employees
			WHERE dept_manager.emp_no = employees.emp_no),
			(SELECT employees.last_name AS "Manager Last Name"
				FROM employees
				WHERE dept_manager.emp_no = employees.emp_no)
FROM dept_manager;


-- 4. List the department number for each employee along with that employee's employee number, 
--    last name, first name, and department name
SELECT dept_no AS "Department Number", emp_no As "Employee Number",
(SELECT last_name AS "Last Name"
	FROM employees
	WHERE dept_emp.emp_no = employees.emp_no),
	(SELECT first_name AS "First Name"
		FROM employees
		WHERE dept_emp.emp_no = employees.emp_no),
		(SELECT dept_name AS "Department Name"
			FROM departments
			WHERE dept_emp.dept_no = departments.dept_no)
FROM dept_emp;


-- 5. List first name, last name and sex of each employee whose first name is Hercules and whose
--    last name begins with the letter B.
SELECT first_name AS "First Name", last_name AS "Last Name", sex AS "Sex"
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';


-- 6. List each employee in the Sales department, inclduing their employee number, last name, and first name.
SELECT emp_no AS "Employee Number", last_name AS "Last Name", first_name AS "First Name"
FROM employees
WHERE emp_no IN(
	SELECT emp_no 
	FROM dept_emp
	WHERE dept_no IN(
		SELECT dept_no 
		FROM departments
		WHERE dept_name = 'Sales'
	)
);


-- 7. List each employee in the Sales and Development Departments, including their employee number,
--    last name, first name, and department name.

SELECT e.emp_no AS "Employee Number", e.last_name AS "Last Name", e.first_name AS "First Name", dp.dept_name AS "Department Name"
FROM employees AS e
LEFT JOIN dept_emp AS d ON
d.emp_no = e.emp_no
LEFT JOIN departments AS dp ON
dp.dept_no = d.dept_no
WHERE e.emp_no IN(
	SELECT emp_no 
	FROM dept_emp
	WHERE dept_no IN(
		SELECT dept_no 
		FROM departments
		WHERE dept_name = 'Sales' OR dept_name = 'Development'
	)
) AND dp.dept_name = 'Sales' OR dp.dept_name = 'Development';
-- NEEDED TO ADD SECOND PART OF 'WHERE' TO NARROW TO 'Sales'/'Development' AGAIN SINCE SOME EMPLOYEES FOR THOSE DEPARTMENTS ALSO 
-- WORKED FOR OTHER DEPARTMENTS AND THE OTHER DEPARTMENTS WERE ALSO SHOWING IN THE QUERY


-- 8. List the frequency counts, in descending order, of all the employee last names 
--    (that is, how many employees share each last name)

SELECT last_name AS "Last Name", COUNT(last_name) AS "Last Name Count"
FROM employees
GROUP BY last_name
ORDER BY "Last Name Count" DESC;