-- What does the raw dataset of car prices look like?
select * from car_prices;

-- Are there any invalid or malformed state values in the dataset?
select*
from car_prices
where length(state)>2;

-- Are there any vehicle listings that are not misclassified under the body type 'Navigation'?
select*
from car_prices
where body != 'Navigation';

 -- What is the distribution of cars by body type?

select body, count(*) from car_prices
group by body;

-- Can we clean and filter the dataset to only include valid, usable entries?

drop table car_prices_valid;
CREATE temporary Table car_prices_valid As
select *
from car_prices
where body!= 'Navigation'
and make !="";

-- Which make and model combinations appear most frequently in the dataset?
Select
make,
model,
count(*)
from car_prices_valid
group by make,model
order by count(*) desc;

-- Are there any records missing manufacturer (make) data?

select *
from car_prices_valid
where make="";

-- What is the average car selling price in each state?
select
state,
avg(sellingprice) as avg_selling_price
from car_prices_valid
group by state
order by avg_selling_price asc;

-- What does the cleaned dataset look like after filtering?
select *
from car_prices_valid;

-- How can we extract year, month, and day from a saledate field in text format?
select 
saledate,
mid(saledate,12,4) as sale_year,
mid(saledate,5,3) as sale_monthname,
mid(saledate,9,2) as sale_day,
case mid(saledate,5,3)
	when 'Jan' then 1
    when 'Feb' then 2
    when 'Mar' then 3
    when 'Apr' then 4
    when 'May' then 5
    when 'Jun' then 6
    when 'Jul' then 7
    when 'Aug' then 8
    when 'Sep' then 9
    when 'Oct' then 10
    when 'Nov' then 11
    when 'Des' then 12
    else 'None'
    END as sale_month
from car_prices_valid
limit 1000;

-- an we enrich the cleaned dataset with parsed date information and renamed columns?
drop table car_prices_valid;
CREATE temporary Table car_prices_valid As
select 
`year` as manufactured_year,
make,
model,
trim, 
body,
transmission,
vin, 
state,
`condition` as car_condition,
odometer,
color, 
interior,
seller,
mmr,
sellingprice,
saledate,
mid(saledate,12,4) as sale_year,
mid(saledate,5,3) as sale_monthname,
mid(saledate,9,2) as sale_day,
case mid(saledate,5,3)
	when 'Jan' then 1
    when 'Feb' then 2
    when 'Mar' then 3
    when 'Apr' then 4
    when 'May' then 5
    when 'Jun' then 6
    when 'Jul' then 7
    when 'Aug' then 8
    when 'Sep' then 9
    when 'Oct' then 10
    when 'Nov' then 11
    when 'Des' then 12
    else 'None'
    END as sale_month
from car_prices
where body!= 'Navigation'
and make !=""
and saledate!="";


select *
from car_prices_valid;

-- What are the average selling prices by month and year?
select
sale_year,
sale_month,
avg(sellingprice) as avg_selling_price
from car_prices_valid
group by sale_year, sale_month
order by sale_year, sale_month;

-- In which months do most car sales occur?
select sale_month, count(*)
from car_prices_valid
group by sale_month
order by sale_month asc;

-- How many cars are sold in each month by name?
select 
sale_monthname,
count(*)
from car_prices_valid
group by sale_monthname;

--  Are there any records where the month name could not be extracted?
select * 
from car_prices_valid
where sale_monthname = "";

-- What are the top 5 most sold models in each body type category?
select
make,
model,
body,
num_sales,
body_rank
from(
select
make,
model,
body,
count(*) as num_sales,
dense_rank() over(partition by body order by count(*) desc) as body_rank
from car_prices_valid
group by make, model, body

)s
where body_rank<=5;

-- Which cars sold for significantly more than their model average?

Select 
make,
model,
vin, 
sale_year,
sale_month,
sale_day,
sellingprice,
avg_model,
sellingprice/avg_model as price_ratio
from(
Select 
make,
model,
vin, 
sale_year,
sale_month,
sale_day,
sellingprice,
avg(sellingprice) over(partition by make, model) as avg_model
from car_prices_valid
)s
where sellingprice>avg_model
order by sellingprice/avg_model desc;

-- How do sales and average prices vary by car condition group?
select
case 
	when car_condition between 0 and 9 then '0 to 9'
    when car_condition between 10 and 19 then '10 to 19'
    when car_condition between 20 and 29 then '20 to 29'
    when car_condition between 30 and 39 then '30 to 39'
    when car_condition between 40 and 49 then '40 to 49'
end as car_condition_bucket,
count(*) as num_sales,
avg(sellingprice) as avg_selling_price
from car_prices_valid
group by car_condition_bucket
order by car_condition_bucket;

-- How do car sales and average prices vary across different odometer ranges?
select 
case
	 WHEN odometer < 100000 THEN '0 - 99,999'
    WHEN odometer < 200000 THEN '100,000 - 199,999'
    WHEN odometer < 300000 THEN '200,000 - 299,999'
    WHEN odometer < 400000 THEN '300,000 - 399,999'
    WHEN odometer < 500000 THEN '400,000 - 499,999'
    WHEN odometer < 600000 THEN '500,000 - 599,999'
    WHEN odometer < 700000 THEN '600,000 - 699,999'
    WHEN odometer < 800000 THEN '700,000 - 799,999'
    WHEN odometer < 900000 THEN '800,000 - 899,999'
    WHEN odometer < 1000000 THEN '900,000 - 999,999'
end as odometer_bucket,
count(*) as num_sales,
avg(sellingprice) as avg_selling_price
from car_prices_valid
group by odometer_bucket
order by odometer_bucket;


-- For each car make, how many models exist, and what are their price statistics?
select 
make,
count(distinct model) as num_model,
count(*) as num_sales,
min(sellingprice) as min_price,
max(sellingprice) as max_price,
avg(sellingprice) as avg_price
from car_prices_valid
group by make
order by avg_price;

-- Are there VINs (vehicles) that appear more than once — indicating duplicates or multiple sales?
select 
manufactured_year,
make,
model,
trim, 
body,
transmission,
vin, 
state,
car_condition,
odometer,
color, 
interior,
seller,
mmr,
sellingprice, 
saledate,
sale_year,
sale_monthname,
sale_day,
vin_sales
from (
select 
manufactured_year,
make,
model,
trim, 
body,
transmission,
vin, 
state,
car_condition,
odometer,
color, 
interior,
seller,
mmr,
sellingprice, 
saledate,
sale_year,
sale_monthname,
sale_day,
count(*) over(partition by vin) as vin_sales
from car_prices_valid
)s
where vin_sales >1;





















