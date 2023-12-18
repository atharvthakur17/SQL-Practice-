--select first_name , salary
--from EmployeeDemo
--inner join EmployeeSalary
--on EmployeeDemo.empid=EmployeeSalary.empid
--order by salary desc


--select job_title, avg(salary) as avgsal
--from EmployeeDemo
--full outer join EmployeeSalary
--on EmployeeDemo.empid=EmployeeSalary.empid
--where job_title = 'salesman'
--group by job_title
