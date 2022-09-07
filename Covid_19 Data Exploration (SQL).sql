/*

Covid 19 Data Exploration 

*/


SELECT * 
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


SELECT * 
FROM PortfolioProject..CovidVaccinations
order by 3,4

-- Select Data that we are going to be starting with

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
where Location like '%india%'
and continent is not null
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population with Covid

SELECT Location, date, total_cases,Population , (total_cases/population)*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
--where Location like '%states%'
where continent is not null
order by 1,2

-- Countries with highest Infection Rate compared to Population

SELECT Location, MAX(total_cases) as HighestInfectionCount,Population , MAX((total_cases/population))*100 as InfectedPercentage
FROM PortfolioProject..CovidDeaths
where continent is not null
--where Location like '%india%'
Group By Location,Population
order by InfectedPercentage DESC

-- Countries with highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as bigint)) as TotalDeathCount 
FROM PortfolioProject..CovidDeaths
--where Location like '%india%'
where continent is not null
Group By Location
order by TotalDeathCount DESC

-- BREAKING THINGS DOWN BY CONTINENT

-- Continents with highest Death Count per Population

SELECT continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount 
FROM PortfolioProject..CovidDeaths
--where Location like '%india%'
where continent is not null
Group By continent
order by TotalDeathCount DESC



-- GLOBAL NUMBERS

SELECT sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(New_Cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--where Location like '%india%'
where continent is not null
--group by date
order by 1,2



-- Total Population vs Vaccination
-- Shows Percentage of Population that has received atleast 1 covid vaccine


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

