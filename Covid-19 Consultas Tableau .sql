--Consultas usadads en Tableau

--1

select SUM(new_cases) as CasosMundialesTotales, SUM(CAST(new_deaths as int)) MuertesMundialesTotales, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 IndiceDeMortalidad
from ProyectoPortfolio..['CovidDeaths']
Where continent is not null
-- group by date
order by 1, 2
go


--2 
-- Las filas descartadas son para mantener consitencia respecto a la consulta previa

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From ProyectoPortfolio..['CovidDeaths']
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3
select location, population, MAX(total_cases) AS MayorContagioRegistrado, MAX((total_cases/population))*100 as Porcentaje_de_contagiados
from ProyectoPortfolio..['CovidDeaths']
group by location, population
order by Porcentaje_de_contagiados desc
go

--4
select location, population, date, MAX(total_cases) AS MayorContagioRegistrado, MAX((total_cases/population))*100 as Porcentaje_de_contagiados
from ProyectoPortfolio..['CovidDeaths']
group by location, population, date
order by Porcentaje_de_contagiados desc
go