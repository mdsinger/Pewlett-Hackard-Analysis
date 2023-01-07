-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);
CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	PRIMARY KEY (emp_no, dept_no)
);


DROP TABLE dept_manager
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);
--Create Retirement Titles Table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1/1/1952' AND '12/31/1955'
ORDER BY emp_no, to_date DESC;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (ret.emp_no) ret.emp_no,
ret.first_name,
ret.last_name,
ret.title

INTO unique_titles
FROM retirement_titles as ret
WHERE ret.to_date = '01-01-9999'
ORDER BY ret.emp_no, ret.to_date DESC;

--Create a table of most recent job titles about to retire

SELECT COUNT (u.title), u.title
INTO retiring_titles 
FROM unique_titles as u
GROUP BY u.title
ORDER BY COUNT (u.title) DESC

--Create a mentorship eligibility table with employees born between 1 Jan 1965 and 31 Dec 1965

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date
INTO employment_dates
FROM employees as e
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE e.birth_date BETWEEN '1/1/1965' AND '12/31/1965' AND de.to_date = '1/1/9999';

SELECT ed.emp_no,
	ed.first_name,
	ed.last_name,
	ed.birth_date,
	ed.from_date,
	ed.to_date,
	t.title
INTO mentorship_eligibility
FROM employment_dates as ed
INNER JOIN titles as t
ON ed.emp_no = t.emp_no
WHERE t.to_date = '1/1/9999'
ORDER BY emp_no;
