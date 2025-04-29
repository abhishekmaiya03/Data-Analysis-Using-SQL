
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);


select * from netflix;

select count(*) as total_count from netflix;


select distinct(type) from netflix;

-- 1. Count the Number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

-- 2. Find the Most Common Rating for Movies and TV Shows

select * from netflix;

select distinct rating from netflix;


select
	type,
	rating
from
(
	select 
		type,
		rating,
		count(*),
		rank () over(partition by type order by count(*) desc) as ranking
	from netflix
	group by 1,2) as t1
where 
	ranking = 1;
-- order by 1,3 desc;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)
select *
from netflix
where type = 'Movie'
		and
	release_year = 2020;
	


-- 4. Find the Top 5 Countries with the Most Content on Netflix


select 
	country,
	count(show_id) as total_content
from netflix
group by 1;

-- this puts each country in the row to each row array respectively
select 
	string_to_array(country, ',') as new_country
from netflix;


select 
	unnest(string_to_array(country, ',')) as new_country
from netflix;
-------------------
select 
	trim(unnest(string_to_array(country, ','))) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

-- 5. Identify the Longest Movie
select * 
from netflix
where 
	type = 'Movie'
	and 
	duration = (select max(duration) from netflix)

-- 6. Find Content Added in the Last 5 Years

select 
	*
	from netflix
	where 
		to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5 years';


select current_date - interval '5 years'


-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select * from netflix
where
	director = 'Rajiv Chilaka'
-- since some rows contains 2 or 3 names 

select * from netflix
where
	director ilike '%Rajiv Chilaka%'


-- 8. List All TV Shows with More Than 5 Seasons

select * from netflix
where 
	type = 'TV Show'
	durations > 5 seasons

-- using split functions

select 
	*
	--split_part(duration, ' ',1) as sessions 
from netflix
where 
	type = 'TV Show'
	and
	split_part(duration, ' ',1)::numeric > 5 

-- 9. Count the Number of Content Items in Each Genre

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


-- 10.Find each year and the average numbers of content release in India on netflix.

 select 
 	extract (year from to_date(date_added,'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric * 100,2) as average_content_per_year
	from netflix
 where country = 'India'
 group by 1;

-- 11. List All Movies that are Documentaries
select *
from netflix
where listed_in ilike '%Documentaries%'


-- Find All Content Without a Director
SELECT * 
FROM netflix
WHERE director IS NULL;


-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Yearssts

select *
from netflix
where casts ilike '%salman khan%'
and release_year >  extract(year from current_date)-10;


-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select 
-- show_id,
-- casts,
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords 

with new_table as
(
select 
*,
	case 	
		when description ilike '%kill%' or description ilike '%violence%' then 'Bad_content'
		else 'Good_content'
	end category
from netflix
)
select
	category,
	count(*) as total_content
from new_table
group by 1;










-- 







 
 


























 


 






