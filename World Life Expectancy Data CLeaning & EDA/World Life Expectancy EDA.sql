-- Exploratory Data Analysis

select * 
 from worldlifeexpectancy; 
 
 -- min & max life expectancy of eaxch country 
 
 select Country, 
 min(`Life expectancy`), 
 max(`Life expectancy`), 
 round(max(`Life expectancy`) -  min(`Life expectancy`),1) as Life_increase_15_Years
 from worldlifeexpectancy
 group by Country
 having min(`Life expectancy`) <>0
 and max(`Life expectancy`) <>0
 order by Life_increase_15_Years desc;

 select Country, 
 min(`Life expectancy`), 
 max(`Life expectancy`), 
 round(max(`Life expectancy`) -  min(`Life expectancy`),1) as Life_increase_15_Years
 from worldlifeexpectancy
 group by Country
 having min(`Life expectancy`) <>0
 and max(`Life expectancy`) <>0
 order by Life_increase_15_Years asc;
 
 
 
 -- highest/lowerst avg life expectancy in years
 
select Year, round(AVG(`Life expectancy`),2)
from worldlifeexpectancy
where `Life expectancy` <>0
and `Life expectancy`<>0
group by Year
order by Year
;


select * 
 from worldlifeexpectancy; 
 
 -- Country vs avg Life_exp and avg GDP

select Country, round(AVG(`Life expectancy`),1) as Life_Exp,  round(AVG(GDP),1) as GDP
 from worldlifeexpectancy
 group by Country
 having  Life_Exp >0
 and GDP>0
 order by GDP asc
 ; 
 
 select Country, round(AVG(`Life expectancy`),1) as Life_Exp,  round(AVG(GDP),1) as GDP
 from worldlifeexpectancy
 group by Country
 having  Life_Exp >0
 and GDP>0
 order by GDP desc;
 
 
 
-- Grouping High/low gdp with high/low life expectancy
select 
sum(case when GDP>= 1500 then 1 else 0 end) High_GDP_Count,
avg(case when GDP>= 1500 then `Life expectancy` else null end) High_GDP_Life_expectancy,
sum(case when GDP<= 1500 then 1 else 0 end) Low_GDP_Count,
avg(case when GDP<= 1500 then `Life expectancy` else null end) Low_GDP_Life_expectancy
from worldlifeexpectancy;

-- Corelation low gdp has low avg life expectancy and high gdp has high avg life expectancy. (from above query)

select * 
 from worldlifeexpectancy; 
 
 -- avg life expectancy between developed and developing countries
 
 select Status, round(avg(`Life expectancy`),1)
 from worldlifeexpectancy
 group by Status; 

 select Status, count(distinct Country), round(avg(`Life expectancy`),1) 
 from worldlifeexpectancy
 group by Status;
 

-- BMI vs life expectancy

select Country, round(AVG(`Life expectancy`),1) as Life_Exp,  round(AVG(BMI),1) as BMI 
 from worldlifeexpectancy
 group by Country
 having  Life_Exp >0
 and BMI >0
 order by BMI desc
 ;
 
 
 select Country, round(AVG(`Life expectancy`),1) as Life_Exp,  round(AVG(BMI),1) as BMI 
 from worldlifeexpectancy
 group by Country
 having  Life_Exp >0
 and BMI >0
 order by BMI asc
 ;
 

 -- Rolling total.
 
 select Country,
 Year, 
 `Life expectancy`,
 `Adult Mortality`,
 sum(`Adult Mortality`) over(partition by Country order by Year) as rolling_total
 from worldlifeexpectancy
 where Country like '%United%'; 
 
 
 
 
 