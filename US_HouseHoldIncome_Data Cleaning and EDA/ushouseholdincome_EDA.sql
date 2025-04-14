-- EDA

select * from us_project.ushouseholdincome;

select * from us_project.ushouseholdincomestatistics;

-- to find largest area by land and water

select State_Name, sum(ALand), sum(AWater)
from us_project.ushouseholdincome
group by State_name
order by 2 desc 
limit 10;

select State_Name, sum(ALand), sum(AWater)
from us_project.ushouseholdincome
group by State_name
order by 3 desc ;

select * 
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
where Mean <> 0;

select u.State_Name, County, Type, `Primary`, Mean, Median
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
where Mean <> 0;

-- to find states/type/primary with highest/lowest average mean and medium of income 

select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by u.State_Name
order by 2
limit 5;

select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by u.State_Name
order by 2 desc
limit 10;

select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by u.State_Name
order by 3 desc
limit 10;

select u.State_Name, round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by u.State_Name
order by 3
limit 10;

select Type, round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by 1
order by 1 desc
limit 20;

select Type, count(Type), round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by 1
order by 4 desc
limit 10;

select *
from us_project.ushouseholdincome
where type='Community';


-- filtering outliers

 select Type, count(Type), round(Avg(Mean),1), round(Avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    where Mean <> 0
group by 1
having count(Type)>100
order by 4 desc
limit 10;


-- querying at city level


select u.State_Name, City, round(avg(Mean),1), round(avg(Median),1)
from us_project.ushouseholdincome u
inner join us_project.ushouseholdincomestatistics us
	on u.id = us.id
    group by u.State_Name, City
    order by round(avg(Mean),1) desc;
    


