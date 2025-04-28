/*
In a library management system, it is important to accurately track when members return borrowed books. 
Your task is to create a stored procedure in MySQL called add_return_records. 
This procedure should take the return ID, issued ID, and the quality of the returned book as input parameters. 
When called, it must insert a new record into the return_status table with the current date and the provided information. 
It should then fetch the ISBN and book title linked to the issued ID from the issued_status table. 
After retrieving this information, the procedure must update the books table, setting the status of the returned book back to 'yes' to indicate that the book is now available for borrowing again. 
Finally, the procedure should display a thank you message to the user, mentioning the name of the returned book. 
Your procedure must handle these operations automatically to ensure fast and error-free updates to the system.


*/



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