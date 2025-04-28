select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;	
select * from members;

-- project task

-- CRUD operations

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn, book_title, category, rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


-- Task 2: Update an Existing Member's Address
update members
set member_address = '125 Main st'
where member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.


 delete from issued_status
 where issued_id = 'IS121';
  delete from issued_status
 where issued_id = 'IS101';
 
-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status
where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id, 
count(issued_id) as total_book_issued 
from issued_status
group by issued_emp_id
having total_book_issued>1;



-- CTAS (create table as Select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

create table book_cnts
as
select 
b.isbn,
b.book_title,
count(ist.issued_id) as no_issued
from books as b
join 
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1, 2;

select * from book_cnts;

-- Task 7. Retrieve All Books in a Specific Category:

select *
from books
where category ='Classic';


-- Task 8: Find Total Rental Income by Category:

select 
	b.category,
    sum(b.rental_price),
    count(*) 
from books as b
join
issued_status as ist
on ist.issued_book_isbn = b.isbn
group by 1;


-- List Members Who Registered in the Last 180 Days:


insert into members(member_id,member_name,member_address,reg_date)
values 
('C118', 'sam', '145 Main St', '2024-06-01'),
('C119', 'john', '133 Main St', '2024-05-01');

SELECT *
FROM members
WHERE reg_date >= CURDATE() - INTERVAL 180 DAY;


-- List Employees with Their Branch Manager's Name and their branch details:

select 
e1.*,
b.manager_id,
e2.emp_name as manager
from employees as e1
join 
branch as b 
on b.branch_id = e1.branch_id
join employees as e2
on b.manager_id = e2.emp_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table books_price_greater_than_seven
as
select * from books
where rental_price >7;

select * from books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

select distinct ist.issued_book_name
from issued_status as ist
left join 
return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null;

-- SQL Project - Library Management system

select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from return_status;	
select * from members;

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

-- issued_status == member table == books == return_status
-- filter books which is return
-- overdue >30 

select 
ist.issued_member_id, 
m.member_name, 
bk.book_title,
ist.issued_date,
rs.return_date,
DATEDIFF(CURDATE(), ist.issued_date) as over_dues_days
from 
issued_status as ist
join 
members as m
on m.member_id=ist.issued_member_id
join 
books as bk
on bk.isbn = ist.issued_book_isbn
left join
return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_date is null
	and 
    DATEDIFF(CURDATE(), ist.issued_date)>30
 order by 1;   
  --------------------------------------------------------
--  Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).

 select * from issued_status
 where issued_book_isbn = '978-0-451-52994-2';
  select * from  books
  where isbn = '978-0-451-52994-2';
  
  update books
  set status = 'no'
  where isbn = '978-0-451-52994-2';
  
select * from return_status
where issued_id ='IS130';

--

insert into return_status(return_id, issued_id, return_date, book_quality)
values
('RS125', 'IS130', current_date(), 'good');
select * from return_status
where issued_id ='IS130';

update books
set status = 'yes'
where isbn = '978-0-451-52994-2';

-- Stored Procedures

DELIMITER $$
DROP PROCEDURE IF EXISTS add_return_records $$
CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(30),
    IN p_issued_id VARCHAR(30),
    IN p_book_quality VARCHAR(30)
)
BEGIN
    -- Declare variables
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);
    
    -- Insert into return_status
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);
    
    -- Fetch issued book ISBN and title into variables
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;
    
    -- Update book status to 'yes' (available)
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;
    
    -- Instead of RAISE NOTICE (PostgreSQL), use SELECT in MySQL
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
    
END $$
DELIMITER ;


-- issued_id = 'IS135'
-- ISBN= '978-0-307-58837-1'
-- Testing functions
select * from books
where isbn = '978-0-307-58837-1';


select * from issued_status
where issued_book_isbn = '978-0-307-58837-1'; 

select * from return_status
where issued_id = 'IS135'; 

-- calling a function
call add_return_records('RS138','IS135','Good')
;

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

select * 
from branch;
select * from issued_status;
select * from employees;
select * from books;
select * from return_status;

create table branch_reports
as
select 
	b.branch_id,
    b.manager_id,
    count(ist.issued_id) as number_book_issued,
    count(rs.return_id) as number_book_returned,
    sum(bk.rental_price) as total_revenue
from issued_status as ist
join
employees as e
on e.emp_id = ist.issued_emp_id
join 
branch as b
on e.branch_id = b.branch_id
left join
return_status as rs
on rs.issued_id = ist.issued_id
join 
books as bk
on ist.issued_book_isbn = bk.isbn
group by 1,2;


select *
from branch_reports;


-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

create table active_members 
as
select * 
from members
where member_id in
(SELECT 
    distinct(issued_member_id)
FROM 
    issued_status
WHERE 
    issued_date > CURDATE() - INTERVAL 2 MONTH);
    
-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

select * 
from books as b;
select * 
from issued_status;

select 
	e.emp_name,
    b.*,
    count(ist.issued_id)as no_book_issued
from issued_status as ist
join 
employees e
on e.emp_id = ist.issued_emp_id
join branch as b
on e.branch_id = b.branch_id
group by 1,2;

-- Task 19 (important task)









