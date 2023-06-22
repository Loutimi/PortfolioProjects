--Looking at everything on the Covid Deaths table
SELECT * FROM CovidDeaths

SELECT Location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
Order by 1,2


--Looking at Total Cases vs Total Deaths
--It shows the possibility of dying if you contract covid in Nigeria
SELECT Location,sum(new_cases) TotalCases,sum(cast(new_deaths as int)) TotalDeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage
FROM PortfolioProject..CovidDeaths
Where Location='Nigeria'
Group by Location
Order by 1,2


--Showing Total Cases,Total Deaths and the rate at which people with COVID for each country in Africa are dying
SELECT Location,sum(new_cases)TotalCases,sum(cast(new_deaths as int)) TotalDeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage
FROM PortfolioProject..CovidDeaths
Where Continent='Africa'
Group by location
Order by 3 desc



--Looking at Total Cases vs Population
--Shows what percentage of population has covid in Nigeria
SELECT Location,date,total_cases,population,(total_cases/population)*100 PercentageOfCovidCases
FROM PortfolioProject..CovidDeaths
Where Location='Nigeria'
Order by 1,2 desc


--Showing countries with the highest infections in Africa
SELECT Location,Population,max(total_cases) HighestInfectionCount
FROM PortfolioProject..CovidDeaths
Where Continent='Africa'
Group by Location,population
Order by 3 desc


--Looking at countries with highest infection rate compared to population
SELECT Location,Population,MAX(total_cases) HighestInfectionCount,(MAX(total_cases)/population)
*100 PercentageOfCovidCases
FROM PortfolioProject..CovidDeaths
Group by Location,Population
Order by PercentageOfCovidCases desc


--Looking at African countries with highest infection rate compared to population
SELECT Location,Population,MAX(total_cases) HighestInfectionCount,(MAX(total_cases)/population)
*100 PercentageOfCovidCases
FROM PortfolioProject..CovidDeaths
Where continent='Africa'
Group by Location,Population
Order by PercentageOfCovidCases desc


--Showing countries with highest Death Count
SELECT Location,MAX(cast(total_deaths as int)) TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent is NOT NULL
Group by Location
Order by TotalDeathCount desc


--Showing African countries with highest Death Count
SELECT Location,MAX(cast(total_deaths as int)) TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent='Africa'
Group by Location
Order by TotalDeathCount desc


--Showing continents with the highest Death Count
SELECT Continent,MAX(cast(total_deaths as int)) TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent is NOT NULL
Group by Continent
Order by TotalDeathCount desc


--Total cases vs Total deaths vs Death percentage for the world
SELECT sum(new_cases) TotalCases,sum(cast(new_deaths as int)) TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is NOT NULL
Order by 1,2


--Global Numbers
SELECT Date,sum(new_cases) TotalCases,sum(cast(new_deaths as int)) TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 DeathPercentage
FROM PortfolioProject..CovidDeaths
Where continent is NOT NULL
Group by date
Order by 1,2


--Showing Total Population vs Vaccination
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))OVER(PARTITION BY dea.location Order by dea.location,dea.date)PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVac vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is NOT NULL
Order by 2,3


--Using CTE to find the Percentage of People Vaccinated
With PopvsVac (Continent,Location,Date,Population,New_vaccinations,PeopleVaccinated) as
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))OVER(PARTITION BY dea.location Order by dea.location,dea.date)PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVac vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is NOT NULL
)
SELECT *,(PeopleVaccinated/Population)*100 PercentPopulationVaccinated
FROM PopvsVac


--Creating view to store data for later data visualizations
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))OVER(PARTITION BY dea.location Order by dea.location,dea.date)PeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVac vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is NOT NULL

--
CREATE VIEW DeathRateInAfricanCountries as
SELECT Location,sum(new_cases)TotalCases,sum(cast(new_deaths as int)) TotalDeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 DeathPercentage
FROM PortfolioProject..CovidDeaths
Where Continent='Africa'
Group by location

--
CREATE VIEW ContinentDeathCount as
SELECT Continent,MAX(cast(total_deaths as int)) TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE Continent is NOT NULL
Group by Continent