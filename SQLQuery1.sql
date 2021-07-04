select location, date, total_cases, new_cases, total_deaths, population
from ProyectoPortfolio..['CovidDeaths']
order by 1, 2
go

-- Indice de mortalidad de contagiados x pais
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Indice_mortalidad
from ProyectoPortfolio..['CovidDeaths']
Where location = 'Argentina'
order by 1, 2
go

-- Porcentaje de la poblacion que contrajo covid-19 
select location, date, population, total_cases, (total_cases/population)*100 as Contagios_respecto_poblacion
from ProyectoPortfolio..['CovidDeaths']
Where location = 'Argentina'
order by 1, 2 
go

--Solo los maximos
select location, population, MAX(total_cases) AS MayorContagioRegistrado, MAX((total_cases/population))*100 as Porcentaje_de_contagiados
from ProyectoPortfolio..['CovidDeaths']
group by location, population
order by Porcentaje_de_contagiados desc
go

--Lista de muertes totales por covid-19 (por pais)
select location, MAX(cast(total_deaths as int)) as MuertesTotales 
from ProyectoPortfolio..['CovidDeaths']
Where continent is not NULL
group by location
order by Muertestotales desc
go

-- Lista de muertes totales (por continente)
select Location, MAX(cast(total_deaths as int)) as MuertesTotales 
from ProyectoPortfolio..['CovidDeaths']
Where continent is  NULL
group by location
order by Muertestotales desc
go

-- CIFRAS GLOBALES 

--Por fecha
select date, SUM(new_cases) as CasosMundialesTotales, SUM(CAST(new_deaths as int)) MuertesMundialesTotales, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 IndiceDeMortalidad
from ProyectoPortfolio..['CovidDeaths']
Where continent is not null
group by date
order by 1, 2
go

--Totales
select SUM(new_cases) as CasosMundialesTotales, SUM(CAST(new_deaths as int)) MuertesMundialesTotales, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 IndiceDeMortalidad
from ProyectoPortfolio..['CovidDeaths']
Where continent is not null
-- group by date
order by 1, 2
go

-- Poblacion total contra vacunados totales

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) SumatoriaDeVacunados
From ProyectoPortfolio..['CovidDeaths'] as dea
Join ProyectoPortfolio..CovidVaccinations as vac
	On dea.location = vac.location
	and dea. date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
Order by 2, 3
go

-- CTE poblacion contra vacunados
With PobVsVac (Continent, Location, Date, Population, new_vaccinations, SumatoriaDeVacunados)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) SumatoriaDeVacunados
From ProyectoPortfolio..['CovidDeaths'] as dea
Join ProyectoPortfolio..CovidVaccinations as vac
	On dea.location = vac.location
	and dea. date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--Order by 2, 3
)
Select *, (SumatoriaDeVacunados/population) *100 as PorcentajeDeVacunados
from PobVsVac 
go

--Caso particular de Argentina

With PobVsVac (Continent, Location, Date, Population, new_vaccinations, SumatoriaDeVacunados)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) SumatoriaDeVacunados
From ProyectoPortfolio..['CovidDeaths'] as dea
Join ProyectoPortfolio..CovidVaccinations as vac
	On dea.location = vac.location
	and dea. date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--Order by 2, 3
)
Select *, (SumatoriaDeVacunados/population) *100 as PorcentajeDeVacunados
from PobVsVac 
Where location = 'Argentina'
go

--Tabla temporal

Drop table if exists #PorcentajeDePoblacionVacunada 
Create table #PorcentajeDePoblacionVacunada
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
new_vaccinations numeric,
SumatoriaDeVacunados numeric
)

Insert into #PorcentajeDePoblacionVacunada 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProyectoPortfolio..['CovidDeaths'] dea
Join ProyectoPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--Order by 2, 3


Select *, (SumatoriaDeVacunados/population) *100 as PorcentajeDeVacunados
from #PorcentajeDePoblacionVacunada
--Where location = 'Argentina'
go


--Creacion de vistas para visualizar 
--Drop view  if exists PorcentajeDePoblacionVacunada

Create view PorcentajeDePersonasVacunada as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From ProyectoPortfolio..['CovidDeaths'] dea
Join ProyectoPortfolio..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
and vac.new_vaccinations is not null
--Order by 2, 3
go

Select *
from PorcentajeDePersonasVacunada
go