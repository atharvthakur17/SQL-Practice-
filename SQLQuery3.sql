

--select job_title, count(job_title) as total_posts,avg(salary) avg_salary
--from EmployeeSalary
--group by job_title
--order by avg_salary desc 

select * from EmployeeDemo

select gender , avg(age)
from EmployeeDemo
group by gender
