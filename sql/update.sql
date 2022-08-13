INSERT INTO currency_stg SELECT DISTINCT name, currency FROM country_stg;

MERGE INTO currency prod USING currency_stg stg
ON prod.name = stg.name
WHEN MATCHED THEN
UPDATE SET name = stg.name, currency = stg.currency
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.name, stg.currency);


MERGE INTO continent prod USING continent_stg stg
ON prod.continent_full_name = stg.continent_full_name
WHEN MATCHED THEN
UPDATE SET continent_code = stg.continent_code, continent_full_name = stg.continent_full_name
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.continent_code, stg.continent_full_name);


MERGE INTO country prod USING country_stg stg
ON prod.name = stg.name
AND prod.native = stg.native
WHEN MATCHED THEN
update SET name = stg.name,native = stg.native, phone = stg.phone, continent = stg.continent, capital = stg.capital,currency = stg.currency, languages = stg.languages, continents = stg.continents, country_code = stg.country_code
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.name, stg.native, stg.phone, stg.continent, stg.capital, stg.currency, stg.languages, stg.continents, stg.country_code);


MERGE INTO country2to3 prod USING country2to3_stg stg
ON prod.country_code_3 = stg.country_code_3
WHEN MATCHED THEN
UPDATE SET country_code_2 = stg.country_code_2,  country_code_3  = stg.country_code_3 
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.country_code_2, stg.country_code_3);


MERGE INTO country3to2 prod USING country3to2_stg stg
ON prod.country_code_3 = stg.country_code_3
WHEN MATCHED THEN
UPDATE SET country_code_2 = stg.country_code_2,  country_code_3  = stg.country_code_3 
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.country_code_3, stg.country_code_2);


MERGE INTO language prod USING language_stg stg
ON prod.name = stg.name
AND prod.native = stg.native
WHEN MATCHED THEN
update SET name = stg.name,native = stg.native, rtl = stg.rtl, country_code = stg.country_code
WHEN NOT MATCHED THEN 
INSERT VALUES (stg.name, stg.native, stg.rtl, stg.country_code);

