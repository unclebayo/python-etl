--- Task 1, Continent name and Number of Countries ---
select continent_full_name, count(name) from country c 
left join continent ct on ct.continent_code = c.continent
group by continent_full_name
order by  continent_full_name asc;

--- Task 2, Language name and Countries that speak the language separated by comma ---
select l.name as language, string_agg(c.name, ',') as countries  from country c 
left join language l on LOWER(c.country_code) = l.country_code 
group by l.name
order by 1 ASC;

 
-- Task 3, Country name and number of languages spoken --
select c.name, COUNT(l.name) as lng_count from country c 
left join language l on LOWER(c.country_code) = l.country_code 
group by c.name
order by ct DESC;