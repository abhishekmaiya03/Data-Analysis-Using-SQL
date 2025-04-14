# world life expectancy project Data cleaning and EDA

SELECT * FROM world_life_expectancy.worldlifeexpectancy;

-- to check duplicates
select Country, Year, concat(Country, year), count(concat(Country, year))
from worldlifeexpectancy
group by Country, Year, concat(Country, year)
Having count(concat(Country, year))>1; 

 
select *  
from (
select Row_ID,
concat(Country, year),
row_number() over(partition by concat(Country, year) order by concat(Country, year)) as Row_Num
from worldlifeexpectancy
) as Row_table
where Row_Num>1 
; 

-- to delete duplicates.  

delete from worldlifeexpectancy
where Row_ID in (
select Row_ID 
from ( 
select Row_ID,
concat(Country, year),
row_number() over(partition by concat(Country, year) order by concat(Country, year)) as Row_Num
from worldlifeexpectancy
) as Row_table
where Row_Num>1 
);

-- check for blankc in ststus column and fill developed/developing
SELECT * FROM 
worldlifeexpectancy
where Status = '';

SELECT distinct(Status) FROM 
worldlifeexpectancy
where Status <> '';

select distinct(Country) FROM 
worldlifeexpectancy
where Status = 'Developing'
;


update worldlifeexpectancy
set Status='Developing'
where Country in (
				select distinct(Country) 
                FROM worldlifeexpectancy 
				where Status = 'Developing'
				);
  
  update worldlifeexpectancy t1
  join worldlifeexpectancy t2
  on t1.Country = t2.Country
  set t1.Status = 'Developing'
  where t1.Status = ''
  and t2.Status <>''
  and t2.Status = 'Developing'
  ; 

SELECT * FROM 
worldlifeexpectancy
where Status = '';

Select * 
from worldlifeexpectancy
where Country = 'United States of America';

 update worldlifeexpectancy t1
  join worldlifeexpectancy t2
  on t1.Country = t2.Country
  set t1.Status = 'Developed'
  where t1.Status = ''
  and t2.Status <>''
  and t2.Status = 'Developed'
  ; 

SELECT * FROM 
worldlifeexpectancy
where Status = '';

-- Missing values in Life expentancy.
 select * 
 from worldlifeexpectancy
where `Life expectancy` = ''
 ;
 
 select Country, Year, `Life expectancy`
 from worldlifeexpectancy
 where `Life expectancy` = ''
 ;
 
 select t1.Country, t1.Year, t1.`Life expectancy`, t2.Country, t2.Year, t2.`Life expectancy`,
 t3.Country, t3.Year, t3.`Life expectancy`,
 round((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
  from worldlifeexpectancy t1
 join worldlifeexpectancy t2
	on t1.Country = t2.Country
    and t1.year=t2.Year-1
 join worldlifeexpectancy t3
	on t1.Country = t3.Country
    and t1.year=t3.Year+1
    where t1.`Life expectancy` ='';
    
    
    
update worldlifeexpectancy t1
 join worldlifeexpectancy t2
	on t1.Country = t2.Country
    and t1.year=t2.Year-1
 join worldlifeexpectancy t3
	on t1.Country = t3.Country
    and t1.year=t3.Year+1
set t1.`Life expectancy`= round((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` =''; 
    
    
select * 
 from worldlifeexpectancy;
    
 