select job_title , avg(salary) as avgsal
from EmployeeDemo
join EmployeeSalary on EmployeeDemo.empid = EmployeeSalary.empid
group by job_title 
--having avg(salary)>45000 
order by avgsal

