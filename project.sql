select * 
from layoffs;

-- 1. remove duplicates
-- 2. Standardize data
-- 3. Null or blank values
-- 4. remove colms or rows 

 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
 select * 
from layoffs_staging;




 SELECT *, 
 ROW_NUMBER() OVER(
 PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
 FROM layoffs_staging;
 
 WITH duplicate_cte AS
 (
 SELECT *, 
 ROW_NUMBER() OVER(
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num
 FROM layoffs_staging2
 )
 SELECT * 
 FROM duplicate_cte
 WHERE row_num >1;


SELECT * 
FROM layoffs_staging
WHERE company = 'Casper'
;



WITH duplicate_cte AS
 (
 SELECT *, 
 ROW_NUMBER() OVER(
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num
 FROM layoffs_staging2
 )
 DELETE 
 FROM duplicate_cte
 WHERE row_num >1;
 
 
 CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


 
 INSERT INTO layoffs_staging2
 SELECT *, 
 ROW_NUMBER() OVER(
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num
 FROM layoffs_staging;
 
 DELETE 
 FROM layoffs_staging2
 WHERE row_num>1
 ;
 
 SELECT * 
 FROM layoffs_staging2;
 
-- standardize data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry 
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'
;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'
;


SELECT * 
FROM layoffs_staging2
WHERE country LIKE 'United State%'
ORDER BY 1
;
 
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date`  DATE;

SELECT *
FROM layoffs_staging2;

-- Null values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

select * 
from layoffs_staging2
where industry is null 
or industry = '';

select * 
from layoffs_staging2
where company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is NULL or t1.industry = '')
and t2.industry is not null
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
where t1.industry is NULL
and t2.industry is not null
;



update layoffs_staging2
set industry = null
where industry = '';

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

select * from layoffs_staging2;


-- Explore dataset:
select *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT Company, SUM(total_laid_off)
FROM layoffs_staging2
group by company
order by 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
group by industry
order by 2 DESC
;
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
group by country
order by 2 DESC
;

-- again deleting duplicates


WITH duplicate_cte2 AS(
select *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) as row_num
FROM layoffs_staging3
)
select * 
from duplicate_cte2 
where row_num >1
;


CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` date DEFAULT NULL,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging3;

INSERT INTO layoffs_staging3
select *, ROW_NUMBER() OVER(
 PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised_millions) AS row_num
 FROM layoffs_staging2;
 
 DELETE 
 FROM layoffs_staging3
 WHERE row_num>1
 ;
 
 select * 
 from layoffs_staging3
 where row_num >1;
 
 ALTER TABLE layoffs_staging3
DROP COLUMN row_num;
 
 
-- Continue with project

select *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT Company, SUM(total_laid_off)
FROM layoffs_staging3
group by company
order by 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3
;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
group by industry
order by 2 DESC
;
SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
group by country
order by 2 DESC
;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY  YEAR(`date`)
order by 1 DESC
;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY  stage
order by 2 DESC
;
-- Rolling total

SELECT SUBSTRING(`date`,1,7) as `MONTH`, SUM(total_laid_off)
from layoffs_staging3
where SUBSTRING(`date`,1,7) is not null
group by `MONTH`
order by 1 ASC
;

with rolling_total as 
(
SELECT SUBSTRING(`date`,1,7) as `MONTH`, SUM(total_laid_off) as total_off
from layoffs_staging3
where SUBSTRING(`date`,1,7) is not null
group by `MONTH`
order by 1 ASC
)
select `MONTH`, total_off,
SUM(total_off) OVER (ORDER BY `MONTH`) as rolling
FROM rolling_total
;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
order by 3 DESC;

with company_year (company, years, total_laid_off) as
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)

), company_year_as_rank as
(select *, DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
from company_year 
where years is NOT NULL
)
select * 
from company_year_as_rank
where ranking <=5
;
;



