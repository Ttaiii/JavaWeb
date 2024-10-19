USE DATABASE employee_management;
-- 1. 查询所有员工的姓名、邮箱和工作岗位。
SELECT first_name,last_name,email,job_title
FROM employees;

-- 2. 查询所有部门的名称和位置。
SELECT dept_name, location 
FROM departments;

-- 3. 查询工资超过70000的员工姓名和工资。
SELECT first_name, last_name, salary 
FROM employees 
WHERE salary > 70000;

-- 4. 查询IT部门的所有员工。
SELECT e.first_name, e.last_name, e.email, e.job_title 
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'IT';

-- 5. 查询入职日期在2020年之后的员工信息。
SELECT * 
FROM employees 
WHERE hire_date > '2020-01-01';

-- 6. 计算每个部门的平均工资。
SELECT d.dept_name, AVG(e.salary) AS avg_salary 
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 7. 查询工资最高的前3名员工信息。
SELECT * 
FROM employees 
ORDER BY salary DESC 
LIMIT 3;

-- 8. 查询每个部门员工数量。
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count 
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 9. 查询没有分配部门的员工。
SELECT * 
FROM employees 
WHERE dept_id IS NULL;

-- 10. 查询参与项目数量最多的员工。
SELECT e.emp_id, e.first_name, e.last_name, COUNT(ep.project_id) AS project_count
FROM employees e
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
GROUP BY e.emp_id
ORDER BY project_count DESC 
LIMIT 1;

-- 11. 计算所有员工的工资总和。
SELECT SUM(salary) AS total_salary 
FROM employees;

-- 12. 查询姓"Smith"的员工信息。
SELECT * 
FROM employees 
WHERE last_name = 'Smith';

-- 13. 查询即将在半年内到期的项目。
SELECT *
FROM projects
WHERE end_date BETWEEN NOW() AND DATE_ADD(NOW(),INTERVAL 6 MONTH);

-- 14. 查询至少参与了两个项目的员工。
SELECT e.emp_id,e.first_name,e.last_name
FROM employees e
JOIN employee_projects ep on e.emp_id=ep.emp_id
GROUP BY e.emp_id
HAVING count(ep.project_id)>=2;

-- 15. 查询没有参与任何项目的员工。
SELECT e.emp_id,e.first_name,e.last_name
FROM employees e
WHERE not EXISTS (
	SELECT *
	FROM employee_projects ep
	WHERE ep.emp_id=e.emp_id
);

-- 16. 计算每个项目参与的员工数量。
SELECT p.project_id,p.project_name,count(ep.emp_id) AS employee_count
FROM employees e
JOIN employee_projects ep on e.emp_id=ep.emp_id
JOIN projects p on ep.project_id=p.project_id
GROUP BY p.project_id;

-- 17. 查询工资第二高的员工信息。
SELECT emp_id,first_name,last_name,salary
FROM (
	SELECT emp_id,first_name,last_name,salary,
				 RANK() OVER (ORDER BY salary DESC) AS salary_rank
	FROM employees
) AS ranked_employees
WHERE salary_rank=2;

-- 18. 查询每个部门工资最高的员工。
SELECT e.emp_id,e.first_name,e.last_name,e.salary as top_salary,d.dept_id,d.dept_name
FROM employees e
JOIN departments d ON e.dept_id=d.dept_id
WHERE (d.dept_id,e.salary) in (
	SELECT dept_id,e.salary
	from employees
	group by dept_id
);

-- 19. 计算每个部门的工资总和,并按照工资总和降序排列。
SELECT d.dept_id,d.dept_name,sum(e.salary) as total_salary
FROM employees e
join departments d on e.dept_id=d.dept_id
group by d.dept_id,d.dept_name
ORDER BY total_salary desc;
			 
-- 20. 查询员工姓名、部门名称和工资。
SELECT E.first_name,E.last_name,D.dept_id,D.dept_name,E.salary
FROM employees E
JOIN departments D ON E.dept_id=D.dept_id;

-- 21. 查询每个员工的上级主管(假设emp_id小的是上级)。
SELECT E1.emp_id,E1.first_name,E1.last_name,E2.emp_id AS manager_id,E2.first_name AS manager_first_name,E2.last_name AS manager_last_name
FROM employees E1
LEFT JOIN employees E2 ON E1.dept_id=E2.dept_id AND E2.emp_id<E1.emp_id;

-- 22. 查询所有员工的工作岗位,不要重复。
SELECT DISTINCT E.job_title
FROM employees E;

-- 23. 查询平均工资最高的部门。
SELECT D.dept_id,D.dept_name,AVG(salary) AS AVG_salary
FROM departments D
JOIN employees E ON D.dept_id=E.dept_id
GROUP BY D.dept_id,D.dept_name
ORDER BY AVG_salary desc
LIMIT 1;

-- 24. 查询工资高于其所在部门平均工资的员工。
WITH AvgSalaries AS(
	SELECT emp_id,first_name,last_name,salary,AVG(salary) OVER (PARTITION BY dept_id) AS avg_salary
	FROM employees
)
SELECT emp_id,first_name,last_name,salary,avg_salary
from AvgSalaries
where salary > avg_salary;

-- 25. 查询每个部门工资前两名的员工。
WITH RankedSalaries AS(
	SELECT emp_id,first_name,last_name,salary,dept_id,ROW_NUMBER() over (partition by dept_id order by salary desc) as 'rank'
	from employees
)
SELECT emp_id,first_name,last_name,salary,dept_id
from RankedSalaries
where 'rank'<=2;

-- 26. 查询跨部门的项目(参与员工来自不同部门)。

-- 27. 查询每个员工的工作年限,并按工作年限降序排序。
SELECT emp_id,first_name,last_name,TIMESTAMPDIFF(year,hire_date,CURRENT_DATE) as work_years
FROM employees
ORDER BY work_years DESC;

-- 28. 查询本月过生日的员工(假设hire_date是生日)。
SELECT emp_id,first_name,last_name,hire_date
from employees
where month(hire_date)=month(CURRENT_DATE()) and DAY(hire_date)=day(CURDATE());

-- 29. 查询即将在90天内到期的项目和负责该项目的员工。
SELECT p.project_id,project_name,e.emp_id,e.first_name,e.last_name
from projects p
JOIN employee_projects ep on p.project_id=ep.project_id
JOIN employees e on ep.emp_id=e.emp_id
WHERE p.end_date BETWEEN CURDATE() and DATE_ADD(CURDATE(),INTERVAL 90 DAY);

-- 30. 计算每个项目的持续时间(天数)。
SELECT project_id,project_name,DATEDIFF(end_date, start_date) AS duration_days
FROM projects;

-- 31. 查询没有进行中项目的部门。
WITH Dept_Projects AS(
	SELECT e.dept_id,count(p.project_id) over (partition by e.dept_id) as project_count
	from employees e
	left join employee_projects ep on e.emp_id=ep.emp_id
	left join projects p on ep.project_id=p.project_id
	where p.end_date>CURDATE() or p.end_date is null
)
SELECT dept_id
from Dept_Projects
GROUP BY dept_id
having sum(project_count)=0;

-- 32. 查询员工数量最多的部门。
SELECT dept_id,COUNT(emp_id) AS employee_count
FROM employees
GROUP BY dept_id
ORDER BY employee_count DESC
LIMIT 1;

-- 33. 查询参与项目最多的部门。
WITH ProjectCount AS (
	SELECT E.dept_id,COUNT(DISTINCT EP.project_id) AS project_count
	from employees e
	join employee_projects ep on e.emp_id=ep.emp_id
	GROUP BY e.dept_id
)
SELECT dept_id,project_count
from ProjectCount
order by project_count desc
limit 1;

-- 34. 计算每个员工的薪资涨幅(假设每年涨5%)。
SELECT emp_id,first_name,last_name,salary,salary * POWER(1.05, YEAR(CURDATE()) - YEAR(hire_date)) AS new_salary
FROM employees;

-- 35. 查询入职时间最长的3名员工。
WITH RankedEmployees AS(
	SELECT emp_id,first_name,last_name,hire_date,ROW_NUMBER() over (ORDER BY hire_date asc) as `rank`
	from employees
)
SELECT emp_id,first_name,last_name,hire_date
from RankedEmployees
where `rank`<=3;

-- 36. 查询名字和姓氏相同的员工。
SELECT emp_id,first_name,last_name
from employees
where first_name=last_name;

-- 37. 查询每个部门薪资最低的员工。
WITH DeptMinSalaries AS(
	SELECT emp_id,first_name,last_name,dept_id,salary,ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary ASC) AS `rank`
	FROM employees
)
SELECT emp_id,first_name,last_name,dept_id,salary
FROM DeptMinSalaries
where `rank`=1;

-- 38. 查询哪些部门的平均工资高于公司的平均工资。
WITH DeptAvg AS(
	SELECT dept_id,avg(salary) as dept_avg_salary
	from employees
	group by dept_id
),
CompanyAvg AS(
	SELECT AVG(salary) AS company_avg_salary
	from employees
)
SELECT d.dept_id,d.dept_avg_salary,c.company_avg_salary
from DeptAvg d
join CompanyAvg c on d.dept_avg_salary>c.company_avg_salary;

-- 39. 查询姓名包含"son"的员工信息。
WITH EmployeesWithSubstring AS (
    SELECT emp_id,first_name,last_name,salary
    FROM employees
    WHERE first_name LIKE '%son%' OR last_name LIKE '%son%'
)
SELECT * FROM EmployeesWithSubstring;

-- 40. 查询所有员工的工资级别(可以自定义工资级别)。
WITH SalaryLevels AS (
    SELECT emp_id,first_name,last_name,salary,
    CASE 
         WHEN salary < 40000 THEN '级别 1'
         WHEN salary BETWEEN 40000 AND 60000 THEN '级别 2'
         WHEN salary BETWEEN 60000 AND 80000 THEN '级别 3'
         ELSE '级别 4'
    END AS salary_level
    FROM employees
)
SELECT * FROM SalaryLevels;

-- 41. 查询每个项目的完成进度(根据当前日期和项目的开始及结束日期)。
SELECT project_id,project_name,start_date,end_date,
			 DATEDIFF(CURDATE(),start_date) as DAYS_COMPLETEED,
			 DATEDIFF(end_date,start_date) AS TOTAL_DAYS,
			 (DATEDIFF(CURDATE(),start_date) / DATEDIFF(end_date,start_date)) * 100 as COMPLETION_PERCENT
FROM projects;

-- 42.查询每个经理(假设job_title包含'Manager'的都是经理)管理的员工数量。
SELECT M.emp_id AS manager_id,concat(m.first_name,' ',m.last_name) as manager_name,count(e.emp_id) as employee_count
FROM employees m
LEFT JOIN employees e on e.job_title not LIKE '%Manager%'
WHERE m.job_title LIKE '%Manager%'
GROUP BY m.emp_id,manager_name;

-- 43. 查询工作岗位名称里包含"Manager"但不在管理岗位(salary<70000)的员工。
SELECT emp_id,first_name,last_name,job_title,salary
FROM employees
WHERE job_title LIKE '%Manager%' AND salary < 70000;

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 44. 计算每个部门的男女比例(假设以名字首字母A-M为女性,N-Z为男性)。
SELECT 
    dept_id,
    SUM(CASE WHEN first_name REGEXP '^[A-M]' THEN 1 ELSE 0 END) AS female_count,
    SUM(CASE WHEN first_name REGEXP '^[N-Z]' THEN 1 ELSE 0 END) AS male_count,
    ROUND(SUM(CASE WHEN first_name REGEXP '^[A-M]' THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN first_name REGEXP '^[N-Z]' THEN 1 ELSE 0 END), 0), 2) AS female_to_male_ratio
FROM 
    employees
GROUP BY 
    dept_id;

-- 45. 查询每个部门年龄最大和最小的员工(假设hire_date反应了年龄)。
SELECT dept_id,MIN(hire_date) AS youngest_employee,MAX(hire_date) AS oldest_employee
FROM employees
GROUP BY dept_id;

-- 46. 查询连续3天都有员工入职的日期。
SELECT hire_date
FROM employees
GROUP BY hire_date
HAVING COUNT(DISTINCT DATE(hire_date)) >= 3
ORDER BY hire_date;

-- 47. 查询员工姓名和他参与的项目数量。
SELECT e.emp_id,e.first_name,e.last_name,COUNT(p.project_id) AS project_count
FROM employees e
LEFT JOIN employee_projects ep ON e.emp_id = ep.emp_id
LEFT JOIN projects p ON ep.project_id = p.project_id
GROUP BY e.emp_id;

-- 48. 查询每个部门工资最高的3名员工。
WITH RankedEmployees AS (
    SELECT emp_id,first_name,last_name,dept_id,salary,ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS `rank`
    FROM 
        employees
)
SELECT emp_id,first_name,last_name,dept_id,salary
FROM RankedEmployees
WHERE `rank` <= 3;

-- 49. 计算每个员工的工资与其所在部门平均工资的差值。
WITH DeptAvg AS (
    SELECT dept_id,AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
)
SELECT e.emp_id,e.first_name,e.last_name,e.salary,(e.salary - da.avg_salary) AS salary_difference
FROM employees e
JOIN DeptAvg da ON e.dept_id = da.dept_id;

-- 50. 查询所有项目的信息,包括项目名称、负责人姓名(假设工资最高的为负责人)、开始日期和结束日期。
SELECT p.project_name,CONCAT(e.first_name, ' ', e.last_name) AS manager_name,p.start_date,p.end_date
FROM projects p
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employees e ON ep.emp_id = e.emp_id
WHERE e.emp_id = (
        SELECT ep2.emp_id
        FROM employee_projects ep2
        JOIN employees e2 ON ep2.emp_id = e2.emp_id
        WHERE ep2.project_id = p.project_id
        ORDER BY e2.salary DESC
        LIMIT 1
);

