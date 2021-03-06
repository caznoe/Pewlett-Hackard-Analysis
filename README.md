# Pewlett Hackard Analysis
In this challenge, I was provided with csv files of employee and company data to analyze the number of potential upcoming employee retirements within the hypothetical company, Pewlett-Hackard. The company did not have a central point of data to quickly realize the upcoming retirements. In preparation for the potentially large number, the company also wanted to look into the possibility of starting a mentorship program and needed data on potential participants in the program. This is a project for UC Berkeley Data Analytics Boot Camp.

In order to provide concise information for the company, I took the six separate csv files and created tables using PostgreSQL and pgAdmin 4. I first created an ERD to visualize where the tables had overlapping information. (Please see ERD below.) I joined tables using both left join and inner join to correctly compile the data to see how many current staff members were close to retirement based on age. I then evaluated the potential retirees by their departments and titles. Due to the data being stored in separate files, the lists needed to be de-duplicated using partitions. The largest issue with this was due to the file of titles that contained every title held for each employee. I had to ensure that the analysis included only the current title and salary of the employee and that they were a current employee of the company using the ```Where``` function in the queries.

At the conclusion of the analysis, I am providing a list of current employees who are potentially retiring soon along with their salary and job titles. This list is provided in [Retiring by Title](retiring_by_title.csv) and it shows that 72,458 of the 300,024 employees from the employee file may soon be eligible for retirement. What this does not consider are employees leaving before retirement and employees potentially working beyond the analyzed retirement age range. Through compiling the list of employees born in 1965 for a potential mentorship program, there are 1,549 eligible employees. The list is provided in [Mentorship Eligible](membership_eligible.csv). This age range is very limited and expanding the age range would give many more eligible employees.  

### Tech Used
- PostgreSQL
- pgAdmin 4

![ERD Visual](/images/EmployeeDB.png)


