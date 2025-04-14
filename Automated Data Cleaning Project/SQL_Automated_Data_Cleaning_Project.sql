-- Automated Data Cleaning

Select *
from ushouseholdincome;

Select *
from ushouseholdincome_CLeaned;


--  DATA Cleaning
-- 1. Remove duplicates
DELETE from ushouseholdincome
where 
	row_id in (
    select row_id 
from ( 
	select row_id, id, 
    Row_Number() over(
    partition by id
    order by id) as row_num
    from ushouseholdincome
    ) duplicates
    where row_num>1
    );

-- 2. Fixing some data quality issues by fixing typos and general standardization

UPDATE ushouseholdincome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE ushouseholdincome
SET County = UPPER(County);

UPDATE ushouseholdincome
SET City = UPPER(City);

UPDATE ushouseholdincome
SET Place = UPPER(Place);

UPDATE ushouseholdincome
SET State_Name = UPPER(State_Name);

UPDATE ushouseholdincome
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE ushouseholdincome
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';

-- Creating copy of original table for automation

delimiter $$
drop procedure if exists copy_and_clean_data;
create procedure copy_and_clean_data()
begin
-- creating our table
create table if not exists `ushouseholdincome_cleaned` (
  `row_id` int DEFAULT NULL,
  `id` int DEFAULT NULL,
  `State_Code` int DEFAULT NULL,
  `State_Name` text,
  `State_ab` text,
  `County` text,
  `City` text,
  `Place` text,
  `Type` text,
  `Primary` text,
  `Zip_Code` int DEFAULT NULL,
  `Area_Code` int DEFAULT NULL,
  `ALand` int DEFAULT NULL,
  `AWater` int DEFAULT NULL,
  `Lat` double DEFAULT NULL,
  `Lon` double DEFAULT NULL,
  `TimeStamp` TIMESTAMP DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- copy data to new table
insert into ushouseholdincome_cleaned
select * , current_timestamp
from ushouseholdincome;


--  DATA Cleaning
-- 1. Remove duplicates
	DELETE from ushouseholdincome_cleaned
	where 
		row_id in (
		select row_id 
	from ( 
		select row_id, id, 
		Row_Number() over(
		partition by id, `TimeStamp` 
		order by id, `TimeStamp`) as row_num
		from ushouseholdincome_cleaned
		) duplicates
		where row_num>1
		);

-- 2. Fixing some data quality issues by fixing typos and general standardization

	UPDATE ushouseholdincome_cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE ushouseholdincome_cleaned
	SET County = UPPER(County);

	UPDATE ushouseholdincome_cleaned
	SET City = UPPER(City);

	UPDATE ushouseholdincome_cleaned
	SET Place = UPPER(Place);

	UPDATE ushouseholdincome_cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE ushouseholdincome_cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE ushouseholdincome_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';

end $$
delimiter ;

select * from ushouseholdincome_cleaned;

call copy_and_clean_data();


-- create event
drop event run_data_cleaning;
create event run_data_cleaning
	on schedule every 30 day
    do call copy_and_clean_data(); 

-- to check event
select distinct timestamp
from ushouseholdincome_cleaned;




































































-- Debugging or checking (original first)

		select row_id, id , row_num
	from ( 
		select row_id, id, 
		Row_Number() over(
		partition by id
		order by id) as row_num
		from ushouseholdincome
		) duplicates
		where row_num>1;
        
select count(row_id)
from ushouseholdincome;

select State_Name, count(State_Name)
from ushouseholdincome
group by State_Name;

call copy_and_clean_data();

-- Debugging or checking (cleaned)

select row_id, id , row_num
	from ( 
		select row_id, id, 
		Row_Number() over(
		partition by id
		order by id) as row_num
		from ushouseholdincome_cleaned
		) duplicates
		where row_num>1;
        
select count(row_id)
from ushouseholdincome_cleaned;

select State_Name, count(State_Name)
from ushouseholdincome_cleaned
group by State_Name;








