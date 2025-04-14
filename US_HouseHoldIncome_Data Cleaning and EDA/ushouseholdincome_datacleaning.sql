-- Created schema us_projects
-- uploaded y=table using import wizard
-- data downloaded from govt website

select * 
from us_project.ushouseholdincome;

select * 
from us_project.ushouseholdincomestatistics;

-- changing first column header
alter table ushouseholdincomestatistics rename column `ï»¿id` to `id`;

select count(id)
from us_project.ushouseholdincome;

select count(id) 
from us_project.ushouseholdincomestatistics;

-- Data Cleaning
-- 1. looking for duplicates 
-- for ushouseholdincome
select id, count(id)
from us_project.ushouseholdincome
group by id
having count(id)>1;

select * 
from (
 select row_id,
 id, 
 row_number() over(partition by id order by id) row_num
 from us_project.ushouseholdincome
 ) duplicates
 where row_num>1
 ;

delete from ushouseholdincome
where row_id IN (
select row_id 
from (
 select row_id,
 id,  
 row_number() over(partition by id order by id) row_num
 from us_project.ushouseholdincome
 ) duplicates
 where row_num > 1)
 ;

-- for ushouseholdincomestatistic checking duplicates

select id, count(id)
from us_project.ushouseholdincomestatistics
group by id
having count(id)>1;



-- 2. standardizing
 select * 
 from us_project.ushouseholdincome;
 
 select State_Name, count(State_Name)
 from us_project.ushouseholdincome
 group by State_Name;

 select distinct State_Name
 from us_project.ushouseholdincome
 order by 1;
 
 update us_project.ushouseholdincome
 set State_Name= 'Georgia'
 where State_name = 'georia';

update us_project.ushouseholdincome
 set State_Name= 'Alabama'
 where State_name = 'alabama';

select *
 from us_project.ushouseholdincome
 where County = 'Autauga County'
 order by 1;
 
Update us_project.ushouseholdincome
set Place = 'Autaugaville'
where County = 'Autauga County'
and City = 'Vinemont';

select type, count(type)
 from us_project.ushouseholdincome
 group by type;
 #order by 1;

update us_project.ushouseholdincome
set type = 'Borough'
where type = 'Boroughs';


select ALand, AWater
from us_project.ushouseholdincome
where AWater= 0 or AWater = '' or AWater is null
;

select ALand, AWater
from us_project.ushouseholdincome
where ALand= 0 or ALand = '' or ALand is null
;


