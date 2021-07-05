-- Consultas para visualizar aen Tableau
-- Foco en datos nacionales (Argentina)


-- Indice de mortalidad
Select location, cast(date as date), total_cases, total_deaths, (total_deaths/total_cases)*100 as Indice_mortalidad
From ProyectoPortfolio..['CovidDeaths']
Where location = 'Argentina'
Order by 1, 2
Go

-- Vacunados en Argentina
Select location, cast(date as date), new_vaccinations
From ProyectoPortfolio..CovidVaccinations
Where location = 'Argentina'
and new_vaccinations is not null
Order by 1, 2
Go

-- Como varia el indice de mortalidad cuando se comienza a vacunar
Select dea.location, cast(dea.date as date), dea.total_cases, dea.total_deaths, vac.new_vaccinations, (dea.total_deaths/dea.total_cases)*100 as Indice_mortalidad
From ProyectoPortfolio..['CovidDeaths'] as dea
Join ProyectoPortfolio..CovidVaccinations as vac
	On dea.location = vac.location
	And dea.date = vac.date
Where dea.location = 'Argentina'
and vac.new_vaccinations is not null
Order by 1, 2
Go

