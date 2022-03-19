
---testing data

SELECT * FROM covidproject..coviddeaths
SELECT location, date, new_cases, total_cases, total_deaths, population FROM coviddeaths ORDER BY
1,2;



--Looking at total cases v total deaths for Nigeria. Percentage shows likelihood of dying
 
 SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 deathpercentage
 FROM coviddeaths
 WHERE location='Nigeria'

 --comparing population to total cases

  
 SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 percentageinfection
 FROM coviddeaths
 WHERE location='Nigeria'


 --Looking at African countries with highest infection rates compared to population

 SELECT location, population, MAX(total_cases) highestinfectioncount, MAX((total_cases/population)*100) percentagehighinfection
 FROM coviddeaths
 WHERE continent='Africa'
 GROUP BY location, population
 ORDER BY percentagehighinfection DESC

--Seychelles, wow!

 
 --Looking at highestdeaths

  SELECT location, population, MAX(cast(total_deaths as int)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 ORDER BY totaldeathcount DESC

 --Top 5 highest deaths in Africa

 
  SELECT TOP 5 location, population, MAX(cast(total_deaths as int)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' AND continent IS NOT NULL
 GROUP BY location, population
 ORDER BY totaldeathcount DESC

 --Top 5 lowest deaths

  SELECT TOP 5 location, population, MAX(cast(total_deaths as int)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 ORDER BY totaldeathcount DESC

 --percentage death i.e, death count compared to population

 SELECT location, population, MAX(cast(total_deaths as int)) totaldeathcount,
 (MAX(cast(total_deaths as int))/population)*100 percentagedeath
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 ORDER BY percentagedeath desc


 ---Total Vaccination by African country
 
 SELECT covidproject..coviddeaths.location, covidproject..coviddeaths.population,
 MAX(cast(covidproject..covidvaccs.total_vaccinations as bigint)) totalvaccination,
  (MAX(cast(covidproject..covidvaccs.total_vaccinations as bigint))/covidproject..coviddeaths.population)*100 percentageofpopulationvaccinated 
 FROM covidproject..coviddeaths JOIN covidproject..covidvaccs 
 ON covidproject..coviddeaths.location=covidproject..covidvaccs.location
 WHERE covidproject..coviddeaths.continent='Africa'
 GROUP BY covidproject..coviddeaths.location, covidproject..coviddeaths.population 
 



 --TEMP TABLE 
 Drop table if exists  #Covid_vaccinationsinAfrica
 Create Table #Covid_vaccinationsinAfrica
 (location nvarchar(255), 
 totalvaccination bigint)

 Insert into #Covid_vaccinationsinAfrica 
 SELECT covidproject..coviddeaths.location,
 MAX(cast(covidproject..covidvaccs.total_vaccinations as bigint)) totalvaccination
 FROM covidproject..coviddeaths JOIN covidproject..covidvaccs 
 ON covidproject..coviddeaths.location=covidproject..covidvaccs.location
 WHERE covidproject..coviddeaths.continent='Africa'
 GROUP BY covidproject..coviddeaths.location
 


 SELECT * FROM #Covid_vaccinationsinAfrica 

 -- Creating a view


 if exists(select 1 from sys.views where name='Covid_vaccinationsinAfrica ' and type='v')
drop view Covid_vaccinationsinAfrica 
go
 Create View Covid_vaccinationsinAfrica AS
 SELECT covidproject..coviddeaths.location,
 MAX(cast(covidproject..covidvaccs.total_vaccinations as bigint)) totalvaccination
 FROM covidproject..coviddeaths JOIN covidproject..covidvaccs 
 ON covidproject..coviddeaths.location=covidproject..covidvaccs.location
 WHERE covidproject..coviddeaths.continent='Africa'
 GROUP BY covidproject..coviddeaths.location
 

 -- Creating Tables 

 Drop table if exists  totalcovid_vaccinationsacrossAfrica
 Create Table totalcovid_vaccinationsacrossAfrica
 (location nvarchar(255), 
 totalvaccination bigint)
 Insert into totalcovid_vaccinationsacrossAfrica
 SELECT covidproject..coviddeaths.location,
 MAX(cast(covidproject..covidvaccs.total_vaccinations as bigint)) totalvaccination
 FROM covidproject..coviddeaths JOIN covidproject..covidvaccs 
 ON covidproject..coviddeaths.location=covidproject..covidvaccs.location
 WHERE covidproject..coviddeaths.continent='Africa'
 GROUP BY covidproject..coviddeaths.location




 SELECT * FROM totalcovid_vaccinationsacrossAfrica
 ORDER BY totalvaccination asc


