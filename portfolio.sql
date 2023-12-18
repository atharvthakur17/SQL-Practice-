select * from CovidDeaths$
order by 3,4
--select * from CovidVaccinations$
--order by 3,4

select location,date, total_cases,new_cases,total_deaths,population
from CovidDeaths$
order by 1,2

select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent
from CovidDeaths$
where location like '%states%'
order by 1,2


select location,date, total_cases,population,(total_cases/population)*100 as infected_percent
from CovidDeaths$
where location like '%states%'
order by 1,2

select location,population, Max(total_cases) as peak_count ,max( (total_cases/population)*100 )as maximum_infected_percent
from CovidDeaths$
group by location,population
order by 4 desc


select location, max(cast(total_deaths as int)) as total_death_count ,max( (total_deaths/population)*100 )as maximum_dead_percent
from CovidDeaths$
group by location
order by total_death_count desc


select location, max(cast(total_deaths as int)) as total_death_count ,max( (total_deaths/population)*100 )as maximum_dead_percent
from [portfolio ].dbo.CovidDeaths$
where continent is null
group by location
order by total_death_count desc

--showing the continents with death count

select continent, max(cast(total_deaths as int)) as total_death_count 
from [portfolio ].dbo.CovidDeaths$
where continent is not null
group by continent
order by total_death_count desc

--global number per day

select date ,sum( new_cases) dailyCases,sum(cast(new_deaths as int)) dailyDeaths ,  (sum(cast( new_deaths as int))/sum(new_cases))*100 as percent_of_death
from CovidDeaths$
where continent is not null
group by date
order by 1

--whole cases

select sum( new_cases) dailyCases,sum(cast(new_deaths as int)) dailyDeaths ,  (sum(cast( new_deaths as int))/sum(new_cases))*100 as percent_of_death
from CovidDeaths$
where continent is not null
order by 1



select  * 
from CovidVaccinations$ vac join CovidDeaths$  death 
on death.location=vac.location 
   and death.date=vac.date

select  death.continent,death.location,death.date ,vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by death.location order by death.location , death.date) as rolling_people_vaccinated
from CovidVaccinations$ vac 
join CovidDeaths$  death 
on death.location=vac.location 
   and death.date=vac.date
   where death.continent is not null 
order by 2,3

--use CTE 

with popu_VS_vac (continent , location,population , date , new_vaccinations , rolling_people_vaccinated) AS
(select  death.continent,
death.location,
death.population,
death.date ,
vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by death.location order by death.location , death.date) 
as rolling_people_vaccinated

from CovidVaccinations$ vac 
join CovidDeaths$  death 
on death.location=vac.location 
   and death.date=vac.date
   where death.continent is not null )

select *,(rolling_people_vaccinated/population)*100
from popu_VS_vac




--using temp table 
drop table if exists #percent_popu_vaccinated
create table #percent_popu_vaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

insert into #percent_popu_vaccinated
select  death.continent,
death.location,
death.date ,
death.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by death.location order by death.location , death.date) 
as rolling_people_vaccinated

from CovidDeaths$ death   
join CovidVaccinations$ vac
   on death.location=vac.location  
   and death.date=vac.date
where death.continent is not null 

select *
from #percent_popu_vaccinated



--create view to store  data for visualization
create view percent_popu_vaccinated as
select  death.continent,
death.location,
death.date ,
death.population,
vac.new_vaccinations,
sum(cast(vac.new_vaccinations as numeric)) over (partition by death.location order by death.location , death.date) 
as rolling_people_vaccinated

from CovidDeaths$ death   
join CovidVaccinations$ vac
   on death.location=vac.location  
   and death.date=vac.date
where death.continent is not null 

