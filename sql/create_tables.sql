-- Creation of continent
CREATE TABLE IF NOT EXISTS continent (
    continent_code char(2),
    continent_full_name varchar(50)
    );

CREATE TABLE IF NOT EXISTS continent_stg (
    continent_code char(2),
    continent_full_name varchar(50));


CREATE TABLE IF NOT EXISTS country2to3 (
    country_code_2 char(2),
    country_code_3 char(3));

CREATE TABLE IF NOT EXISTS country2to3_stg (
    country_code_2 char(2),
    country_code_3 char(3));

CREATE TABLE IF NOT EXISTS country3to2 (
    country_code_3 char(3),
    country_code_2 char(2));

CREATE TABLE IF NOT EXISTS country3to2_stg (
    country_code_3 char(3),
    country_code_2 char(2));

CREATE TABLE IF NOT EXISTS country (
    name varchar(100),
    native varchar(100),
    phone varchar(100),
    continent varchar(100),
    capital varchar(100),
    currency varchar(100),
    languages varchar(100),
    continents varchar(100),
     country_code varchar(100)
    );

CREATE TABLE IF NOT EXISTS country_stg (
    name varchar(100),
    native varchar(100),
    phone varchar(100),
    continent varchar(100),
    capital varchar(100),
    currency varchar(100),
    languages varchar(100),
    continents varchar(100),
    country_code varchar(100)
    );


CREATE TABLE IF NOT EXISTS language (
    name varchar(100),
    native varchar(100),
    rtl varchar(100),
    country_code varchar(100)
    );


CREATE TABLE IF NOT EXISTS language_stg (
    name varchar(100),
    native varchar(100),
    rtl varchar(100),
    country_code varchar(100)
    );

CREATE TABLE IF NOT EXISTS currency_stg (
    name varchar(100),
    currency varchar(100)
    );

CREATE TABLE IF NOT EXISTS currency (
    name varchar(100),
    currency varchar(100)
    );