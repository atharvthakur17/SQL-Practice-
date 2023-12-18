select age,gender,first_name,empid 
from EmployeeDemo

union

select age,gender,first_name,empid 
from WareHouseEmpDemo

order by empid 



