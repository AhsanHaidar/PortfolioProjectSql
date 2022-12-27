Select*
from PortfolioProject1..covidDeaths
Where continent is not null
order by 3,4

Select*
from PortfolioProject1..CovidVaccinations
Where continent is not null
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject1..covidDeaths
Where continent is not null
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject1..covidDeaths
where location like '%afghanistan%'
order by 2,3;

Select location, total_cases, population, (total_cases/population)*100 as Death_percentage
from PortfolioProject1..covidDeaths
where location like '%India%'
order by 1,2;

Select location, population, max(total_cases) as HighestInfected_Count, max(total_cases/population)*100 as percentage_population
from PortfolioProject1..covidDeaths
group by location,population
order by percentage_population desc;

Select continent, max(cast(total_deaths as int)) as Total_Death
from PortfolioProject1..covidDeaths
Where continent is not null
group by continent 
order by Total_Death desc;

Select continent, min(cast(total_deaths as int)) as least_Death
from PortfolioProject1..covidDeaths
Where continent is not null
group by continent 
order by least_Death;


Select SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Death, SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as Death_Per
from PortfolioProject1..covidDeaths
Where continent is not null
Order by 1,2;


Select*
from PortfolioProject1..CovidVaccinations vac
Join PortfolioProject1..CovidDeaths dea
  On dea.location=vac.location
  and dea.date=vac.date


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) Over(Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
Where dea.continent is not null
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac


Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into PercentPopulationVaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) Over(Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
Where dea.continent is not null

Select*
from PercentPopulationVaccinated


Use PortfolioProject1
go
Create View PrecenPopulationVaccinated as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
Sum(Convert(int,vac.new_vaccinations)) Over(Partition by dea.Location Order by dea.location,dea.date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
  On dea.location=vac.location
  and dea.date=vac.date
Where dea.continent is not null

Select*
from PrecenPopulationVaccinated
