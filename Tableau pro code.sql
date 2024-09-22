SELECT * FROM customer;
SELECT * FROM date;
SELECT * FROM geography;
SELECT * FROM internetsales;
SELECT * FROM product;
SELECT * FROM productcategory;
SELECT * FROM productsubcategory;



-- Modifying productsubcategory table

ALTER TABLE productsubcategory 
DROP COLUMN productsubcategoryalternatekey;

ALTER TABLE productsubcategory
RENAME COLUMN productsubcategorykey TO subcategorykey;

ALTER TABLE productsubcategory
RENAME COLUMN productcategorykey TO categorykey;




-- Modifying productcategory table
ALTER TABLE productcategory
RENAME COLUMN productcategorykey TO categorykey;

ALTER TABLE productcategory
RENAME COLUMN englishproductcategoryname TO category;

ALTER TABLE productcategory 
DROP COLUMN productcategoryalternatekey;




-- Checking data after modifications
SELECT * FROM customer;
SELECT * FROM date;
SELECT * FROM geography;
SELECT * FROM internetsales;
SELECT * FROM product;
SELECT * FROM productcategory;
SELECT * FROM productsubcategory;


-- Modifying product table
ALTER TABLE product
RENAME COLUMN productsubcategorykey TO subcategorykey;

ALTER TABLE product
RENAME COLUMN englishproductname TO productname;


ALTER TABLE product
DROP COLUMN productalternatekey,
DROP COLUMN color,
DROP COLUMN safetystocklevel, 
DROP COLUMN reorderpoint,
DROP COLUMN size,
DROP COLUMN productline,
DROP COLUMN daystomanufacture,
DROP COLUMN modelname,
DROP COLUMN englishdescription;



-- Checking data after modifications
SELECT * FROM customer;
SELECT * FROM date;
SELECT * FROM geography;
SELECT * FROM internetsales;
SELECT * FROM product;
SELECT * FROM productcategory;
SELECT * FROM productsubcategory;




-- Creating productinfo table
CREATE TABLE productinfo AS
SELECT a.productkey, a.productname, b.* 
FROM product a
FULL JOIN (
    SELECT productsubcategory.*, productcategory.category 
    FROM productcategory
    FULL JOIN productsubcategory
    ON productcategory.categorykey = productsubcategory.categorykey
) b
ON a.subcategorykey = b.subcategorykey;


DROP TABLE product;
DROP TABLE productcategory;
DROP TABLE productsubcategory;



-- Checking new productinfo table
SELECT * FROM productinfo
ORDER BY productkey;



SELECT * FROM customer;
SELECT * FROM geography;



-- Modifying customer table
ALTER TABLE customer ADD COLUMN fullname VARCHAR;

UPDATE customer
SET fullname = (
    SELECT
        CASE
            WHEN gender = 'M' THEN 'Mr'
            WHEN gender = 'F' AND maritalstatus = 'M' THEN 'Mrs'
            WHEN gender = 'F' AND maritalstatus = 'S' THEN 'Ms'
            ELSE ''
        END || ' ' || firstname || ' ' || lastname
    FROM customer c 
    WHERE c.customerkey = customer.customerkey
);





ALTER TABLE customer
DROP COLUMN customeralternatekey,
DROP COLUMN title,
DROP COLUMN firstname,
DROP COLUMN middlename,
DROP COLUMN lastname,
DROP COLUMN namestyle,
DROP COLUMN birthdate, 
DROP COLUMN suffix,
DROP COLUMN emailaddress,
DROP COLUMN totalchildren,
DROP COLUMN numberchildrenathome,
DROP COLUMN spanisheducation, 
DROP COLUMN englisheducation, 
DROP COLUMN frencheducation,
DROP COLUMN englishoccupation,
DROP COLUMN spanishoccupation,
DROP COLUMN frenchoccupation,
DROP COLUMN houseownerflag, 
DROP COLUMN numbercarsowned,
DROP COLUMN addressline1, 
DROP COLUMN addressline2,
DROP COLUMN phone,
DROP COLUMN commutedistance;


-- Creating customergeo table
CREATE TABLE customergeo AS
SELECT a.city, a.stateprovincename, a.englishcountryregionname, b.* 
FROM geography a 
FULL JOIN customer b
ON a.geographykey = b.geographykey;



-- Dropping old tables

DROP TABLE geography;
DROP TABLE customer;


SELECT * FROM customergeo;


ALTER TABLE customergeo
RENAME COLUMN englishcountryregionname TO country;




-- Creating salesbudget table
CREATE TABLE salesbudget ( 
    date DATE,
    budget NUMERIC
);


COPY salesbudget
FROM 'C:\Program Files\PostgreSQL\16\data\Tableau project Sales budget\Sales Budget.csv' DELIMITER ',' CSV HEADER;




-- Checking all tables
SELECT * FROM salesbudget;
SELECT * FROM customergeo;
SELECT * FROM date;
SELECT * FROM internetsales;
SELECT * FROM productinfo;


-- Joining date and internetsales tables
SELECT date.*, internetsales.*
FROM date
INNER JOIN internetsales
ON date.datekey = CAST(internetsales.orderdatekey AS INTEGER);


-- Modifying internetsales and date tables
ALTER TABLE internetsales
ALTER COLUMN orderdate TYPE DATE 
USING orderdate::DATE;

ALTER TABLE internetsales 
ALTER COLUMN shipdate TYPE DATE 
USING shipdate::DATE;

ALTER TABLE date
ALTER COLUMN datekey TYPE VARCHAR;







-- Checking distinct counts
SELECT COUNT(DISTINCT orderdatekey) FROM internetsales; -- 1123 
SELECT COUNT(DISTINCT datekey) FROM date; -- 6939

-- Deleting records from customergeo and internetsales
SELECT * FROM customergeo
WHERE EXTRACT(YEAR FROM datefirstpurchase) < 2021;

DELETE FROM customergeo
WHERE EXTRACT(YEAR FROM datefirstpurchase) < 2021;

SELECT COUNT(DISTINCT datefirstpurchase) FROM customergeo; -- 1123
SELECT COUNT(DISTINCT datefirstpurchase) FROM customergeo; -- 758

SELECT COUNT(DISTINCT orderdate) FROM internetsales; -- 1123 / 758

DELETE FROM internetsales
WHERE EXTRACT(YEAR FROM orderdate) < 2021;




-- Final check of all tables
SELECT * FROM salesbudget;
SELECT * FROM customergeo;
SELECT * FROM date;
SELECT * FROM internetsales;
SELECT * FROM productinfo;