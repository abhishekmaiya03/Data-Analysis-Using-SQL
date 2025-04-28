-- Task 

/*
Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system.
 Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
 The procedure should function as follows: 
 The stored procedure should take the book_id as an input parameter.
 The procedure should first check if the book is available (status = 'yes').
 If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
 If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

select * from books;
select * from issued_status;

 
DELIMITER $$
DROP PROCEDURE IF EXISTS issue_book $$
CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(30),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(30)
)
Begin 
		-- Declare variables
		DECLARE v_status varchar(30);
        
		-- All the code
        -- Checking if the book is avaliable 'yes'
        select 
			status 
            into
            v_status
        from books 
        where isbn = p_issued_book_isbn;
        
        if v_status = 'yes' then 
        
			insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
				values(p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn,p_issued_emp_id); 
                
			UPDATE books
				SET status = 'no'
			WHERE isbn = p_issued_book_isbn;
                
                SELECT CONCAT('Book records added successfully for book isbn: ', p_issued_book_isbn) AS message;

         
        
        else
				SELECT CONCAT('sorry to inform youthe book you have requested is unavaliable book_isbn: ', p_issued_book_isbn) AS message;
        end if;


end $$
delimiter ;

-- '978-0-553-29698-2' -- yes    978-0-375-41398-8 -- no

select * from books;
select * from issued_status;

call issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');  -- for yes column

call issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');
