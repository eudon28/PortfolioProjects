Select * 
FROM PortfolioProject.dbo.['CovidDeaths']
where continent is not null
ORDER by 3,4

--Select * 
--FROM PortfolioProject.dbo.['CovidVaccinations']
--ORDER by 3,4

-- 1. Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.['CovidDeaths']
order by 1, 2

-- Looking at Total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.['CovidDeaths']
where location like '%malaysia%'
and continent is not null
order by 1, 2

-- Looking at Total Cases vs Population
-- Shows percentage of population with Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as CasePerPopulation
FROM PortfolioProject.dbo.['CovidDeaths']
where location like '%malaysia%'
order by 1, 2

--Looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasePerPopulation
FROM PortfolioProject.dbo.['CovidDeaths']
-- where location like '%malaysia%'
Group by location, population
order by CasePerPopulation desc



-- LST'S BREAK THINGS DOWN BY CONTINENT

-- Showing the continent with the highest death count 
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.['CovidDeaths']
-- where location like '%malaysia%'
where continent is not null
Group by continent
order by TotalDeathCount desc


--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage 
FROM PortfolioProject.dbo.['CovidDeaths']
-- where location like '%malaysia%'
where continent is not null
-- GROUP BY date
order by 1, 2





-- Looking at Total population vs Vaccinations
-- USE CTE

With PopVsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated) as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccination/population)*100
FROM PortfolioProject..['CovidDeaths'] as dea
Join PortfolioProject..['CovidVaccinations'] as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- Order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100 
From PopVsVac



DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

-- TEMP TABLE


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccination/population)*100
FROM PortfolioProject..['CovidDeaths'] as dea
Join PortfolioProject..['CovidVaccinations'] as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
Order by 2, 3

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccination/population)*100
FROM PortfolioProject..['CovidDeaths'] as dea
Join PortfolioProject..['CovidVaccinations'] as vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
-- Order by 2, 3


Select *
From PercentPopulationVaccinated









--Pause at 1:04:31 (Alex Portfolio)



