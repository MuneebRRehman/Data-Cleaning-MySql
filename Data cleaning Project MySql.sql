select *
from layoffs;

-- Creating Table --

create table layoffs_staging_practice
like layoffs;

-- Inserting data in New table --


insert into layoffs_staging_practice
Select *
from layoffs;

Select *
from layoffs_staging_practice;


Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) As row_num
from layoffs_staging_practice;

Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) As row_num
from layoffs_staging_practice;

with duplicate_cte as
(
Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) As row_num
from layoffs_staging_practice
)
select *
from duplicate_cte
where row_num >1;





CREATE TABLE `layoffs_staging3` (
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


select *
from layoffs_staging3;

-- Inserting data in New table --

insert into layoffs_staging3
Select *,
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) As row_num
from layoffs_staging_practice;

select *
from layoffs_staging3;

-- Remoing Duplicates -- 


delete
from layoffs_staging3
where row_num >1;

-- Triming  Data ---

select company, trim(company)
from layoffs_staging3;

update layoffs_staging3
set company = trim(company);

select *
from layoffs_staging3;


-- Strandaradizing Data --


select distinct industry
from layoffs_staging3
order by 1;

update layoffs_staging3
set industry = 'Crypto'
where industry like 'Crypto%';

select distinct industry
from layoffs_staging3
order by 1;

select distinct country
from layoffs_staging3;

update layoffs_staging3
set country = trim( trailing '.' from country)
where country like 'United States%';

select distinct country
from layoffs_staging3;


select `date`,
str_to_date(`date`, ('%m/%d/%Y'))
from layoffs_staging3;

update layoffs_staging3
set `date` = str_to_date(`date`, ('%m/%d/%Y'));


alter table layoffs_staging3
modify column `date` date;

update layoffs_staging3
set industry = null
where industry = '';

select * 
from layoffs_staging3
where industry is Null;

select  * 
from layoffs_staging3 t1
Join layoffs_staging3 t2
	On t1.company = t2.company
where t1.industry is Null
And t2.industry is not Null;

update layoffs_staging3 t1
Join layoffs_staging3 t2
	On t1.company = t2.company
set t1.industry =  t2.industry
where t1.industry is Null
And t2.industry is not Null;

select * 
from layoffs_staging3
where industry is Null;

-- Remoimg Columns --

select * 
from layoffs_staging3;

delete
from layoffs_staging3
where total_laid_off is Null
And percentage_laid_off is Null;

alter table layoffs_staging3
drop column row_num;

select * 
from layoffs_staging3;
