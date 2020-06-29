-- Find employees who will be elgible for retirement
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
    
SELECT * FROM retirement_info

DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_retirement
FROM current_emp as ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM department_retirement

-- Create Employee Information List
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employees as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT * FROM manager_info

-- List of department retirees
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name	
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employees AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info

-- List of Sales department retirees
SELECT di.emp_no,
di.first_name,
di.last_name,
di.dept_name
INTO sales_dept
FROM dept_info as di
WHERE (di.dept_name = 'Sales');

SELECT * FROM sales_dept

-- List of Sales and Development department retirees
SELECT di.emp_no,
di.first_name,
di.last_name,
di.dept_name
INTO sales_development
FROM dept_info as di
WHERE di.dept_name IN ('Sales', 'Development');

SELECT * FROM sales_development

-- CHALLENGE

-- Number of retiring employees by title
SELECT e.emp_no, 
	e.first_name, 
	e.last_name,
	tl.title,
	tl.from_date,
	tl.to_date,
	s.salary
INTO retiring_title
FROM employees as e
INNER JOIN titles as tl
ON (e.emp_no = tl.emp_no)
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (tl.to_date = '9999-01-01')
;

SELECT * FROM retiring_title

-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 to_date,
 title,
 salary
INTO current_title
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 to_date,
 title,
 salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM current_title

-- Employees eligible for the mentorship program.
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	tl.title,
	tl.from_date,
	tl.to_date
INTO mentorship_program
FROM employees as e
INNER JOIN titles as tl
ON (e.emp_no = tl.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (tl.to_date = '9999-01-01');

SELECT * FROM mentorship_program

-- Partition data to remove duplicates
SELECT emp_no, 
	first_name,
	last_name,
	title,
	to_date
INTO mentorship_eligible
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 title,
 to_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship_program
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM mentorship_eligible

