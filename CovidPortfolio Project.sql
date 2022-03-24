
---testing data

SELECT * FROM coviddeaths


SELECT location, date, new_cases, total_cases, total_deaths, population FROM coviddeaths ORDER BY
1,2;



--Looking at total cases v total deaths and percentage death to cases for nigeria
 
 SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 deathpercentage
 FROM coviddeaths
 WHERE location='Nigeria'

 --comparing population to total cases

  
 SELECT location, date, total_cases, total_deaths, population, (total_cases/population)*100 percentageinfection
 FROM coviddeaths
 WHERE location='Nigeria'

 ---

 --Looking at African countries with highest infection count compared to population

 SELECT location, population, MAX(cast(total_cases as bigint)) infectioncount, 
 (MAX(cast(total_cases as bigint))/(population)*100) percentageinfection
 FROM coviddeaths
 WHERE continent='Africa'
 GROUP BY location, population
 ORDER BY percentageinfection DESC

--Seychelles, wow!

 
 --Looking at highestdeaths

  SELECT location, population, MAX(cast(total_deaths as bigint)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 ORDER BY totaldeathcount DESC



 --Top 5 highest deaths in Africa

 
  SELECT TOP 5 location, population, MAX(cast(total_deaths as bigint)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' AND continent IS NOT NULL
 GROUP BY location, population
 ORDER BY totaldeathcount DESC

 --Top 5 lowest deaths

  SELECT TOP 5 location, population, MAX(cast(total_deaths as int)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 ORDER BY totaldeathcount asc

 --percentage death i.e, death count compared to infection




 SELECT location, population, MAX(cast(total_cases as bigint)) infectioncount, 
 MAX(cast(total_deaths as bigint)) deathcount,
 (MAX(cast(total_deaths as bigint))/MAX(cast(total_cases as bigint)+0.0001))*100 percentagedeath
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population
 order by percentagedeath desc





 ---Total Vaccination by African countries
 
 SELECT dea.location , dea.population,
 MAX(cast(vac.total_vaccinations as bigint)) totalvaccination
FROM coviddeaths dea JOIN covidvaccs vac
 ON dea.location=vac.location
 WHERE dea.continent='Africa'
 GROUP BY dea.location, dea.population 
 order by totalvaccination desc
 






 

 
 

 -- Creating Tables 

 Drop table if exists vaccinationsacrossAfrica
 Create Table vaccinationsacrossAfrica
 (location nvarchar(255), population bigint, 
  totalvaccination bigint)

 Insert into vaccinationsacrossAfrica
 SELECT dea.location , dea.population,
 MAX(cast(vac.total_vaccinations as bigint)) totalvaccination
FROM coviddeaths dea JOIN covidvaccs vac
 ON dea.location=vac.location
 WHERE dea.continent='Africa'
 GROUP BY dea.location, dea.population 




 SELECT * FROM vaccinationsacrossAfrica
 ORDER BY totalvaccination DESC

 ------Table for infections
  
  Drop table if exists infections
Create table infections
(location nvarchar(255), population bigint,
infectioncount bigint)

Insert into infections
  SELECT location, population, MAX(cast(total_cases as bigint)) infectioncount
 FROM coviddeaths
 WHERE continent='Africa'
 GROUP BY location, population

 SELECT * FROM infections
 order by infectioncount desc

 ----table for total deaths

 drop table if exists totaldeath
 create table totaldeath
 (location nvarchar(255), population bigint, totaldeathcount bigint)
Insert into totaldeath
 SELECT location, population, MAX(cast(total_deaths as bigint)) totaldeathcount
 FROM coviddeaths
 WHERE continent='Africa' AND continent IS NOT NULL
 GROUP BY location, population

 select * from totaldeath
 


 
  


 --- table for percentage death to infection
 
 Drop Table if exists deathpercentage
 Create Table deathpercentage
 (location varchar(255), population bigint, totalinfection bigint, totaldeathcount bigint,
 percentagedeath decimal(10,4))

 Insert into deathpercentage

 SELECT location, population,  
 MAX(cast(total_cases as bigint)) totalinfection,
 MAX(cast(total_deaths as bigint)) totaldeathcount,
 (MAX(cast(total_deaths as bigint))/MAX(cast(total_cases as bigint)+0.001))*100 percentagedeath
 FROM coviddeaths
 WHERE continent='Africa' 
 GROUP BY location, population

 select * from deathpercentage
 order by percentagedeath desc

 
 UPDATE  deathpercentage SET percentagedeath=0 WHERE percentagedeath IS NULL
  UPDATE  deathpercentage SET totaldeathcount=0 WHERE totaldeathcount IS NULL



 ---table for infection percentage to population

 drop table if exists infectionpercentage

 create table infectionpercentage
 (location varchar(255), population bigint,
 infectioncount bigint,
 percentageinfection decimal(10,4))
 
 insert into  infectionpercentage
 SELECT location, population, MAX(total_cases) infectioncount, 
 (MAX(total_cases)/population) *100 percentageinfection
 FROM coviddeaths
 WHERE continent='Africa'
 GROUP BY location, population
 
 SELECT * FROM  infectionpercentage
 order by percentageinfection desc

 UPDATE  infectionpercentage SET percentageinfection=0 WHERE percentageinfection IS NULL




 SELECT SUM(totalinfection) infectionsum, 
 SUM(totaldeathcount) deathsum,
  SUM(totalvaccination) vaccinationsum 
 from deathpercentage 
 join vaccinationsacrossAfrica on deathpercentage.location=vaccinationsacrossAfrica.location

 drop table if exists sumofnumbers
 create table sumofnumbers
 (infectionsum bigint, deathsum bigint, vaccinationsum bigint)

 insert into sumofnumbers
 SELECT SUM(totalinfection) infectionsum, 
 SUM(totaldeathcount) deathsum,
  SUM(totalvaccination) vaccinationsum 
 from deathpercentage 
 join vaccinationsacrossAfrica on deathpercentage.location=vaccinationsacrossAfrica.location

 select * from sumofnumbers
