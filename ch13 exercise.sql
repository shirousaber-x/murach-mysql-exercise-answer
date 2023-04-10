DROP PROCEDURE IF EXISTS test;

-- no 1
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE outstanding_balance_due_count_var INT;

    SELECT COUNT(*)
    INTO outstanding_balance_due_count_var
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 5000;
    
    SELECT CONCAT(outstanding_balance_due_count_var, 
					' invoices exceed $5,000.') AS message;
END//

DELIMITER ;

CALL test();

-- no 2
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE balance_due_count_var INT;
    DECLARE balance_due_sum_var INT;
    
    SELECT COUNT(*), SUM(invoice_total - payment_total - credit_total)
    INTO balance_due_count_var, balance_due_sum_var
    FROM invoices
    WHERE invoice_total - payment_total - credit_total > 0;
    
    IF balance_due_sum_var > 30000 THEN
		SELECT CONCAT('Balance due count is ', balance_due_count_var,
						'. Total balance due is ', balance_due_sum_var) AS message;
	ELSE 
		SELECT 'Total balance due is less than $30,000.' AS message;
	END IF;	
END//

DELIMITER ;

CALL test();

-- no 3
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE result_var INT DEFAULT 1;
    DECLARE cnt_var INT DEFAULT 2;
    
    WHILE cnt_var <= 10 DO
		SET result_var = result_var * cnt_var;
        SET cnt_var = cnt_var + 1;
	END WHILE;
    
    SELECT CONCAT('The factorial of 10 is: ', FORMAT(result_var, 0)) AS result;
END//

DELIMITER ;

CALL test();

-- no 4
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE vendor_name_var VARCHAR(100);
    DECLARE invoice_number_var VARCHAR(100);
    DECLARE balance_due_var DECIMAL(9, 2);
	DECLARE row_not_found BOOLEAN DEFAULT FALSE;
    DECLARE result_string_var VARCHAR(1000) DEFAULT '';

	DECLARE vendors_invoices_cursor CURSOR FOR
		SELECT vendor_name, invoice_number, 
			   invoice_total - payment_total - credit_total AS balance_due
        FROM vendors JOIN invoices USING (vendor_id)
        WHERE invoice_total - payment_total - credit_total >= 5000
        ORDER BY balance_due DESC;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
    
	OPEN vendors_invoices_cursor;
    
    fetching_loop : LOOP
		FETCH vendors_invoices_cursor 
        INTO vendor_name_var, invoice_number_var, balance_due_var;
        
        IF row_not_found = TRUE THEN 
			LEAVE fetching_loop;
		END IF;
        
		SET result_string_var = CONCAT(result_string_var, balance_due_var, '|',
                        invoice_number_var, '|',
                        vendor_name_var, '//');
	END LOOP fetching_loop;
	
    CLOSE vendors_invoices_cursor;
    
    SELECT result_string_var AS result;
END//

DELIMITER ;

CALL test();

-- no 5
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE EXIT HANDLER FOR 1048
		SELECT 'Row was not updated - column cannot be null.' AS message;
	
    UPDATE invoices
    SET invoice_due_date = NULL
    WHERE invoice_id = 1;
    
    SELECT '1 row was updated.' AS message;
END//

DELIMITER ;

CALL test();

-- no 6
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE i INT;
    DECLARE prime_candidate, divisor INT;
    DECLARE is_prime BOOLEAN DEFAULT TRUE;
    DECLARE result VARCHAR(1000) DEFAULT '2';
    
    SET prime_candidate = 3;
    
    WHILE prime_candidate <= 100 DO
		SET divisor = SQRT(prime_candidate);
        SET is_prime = TRUE;
		dividing_loop : LOOP
			IF divisor <= 1 OR is_prime = FALSE THEN
				LEAVE dividing_loop;
			END IF;
			IF prime_candidate MOD divisor = 0 THEN
				SET is_prime = FALSE;
			END IF;
			SET divisor = divisor - 1;
        END LOOP dividing_loop;
        
        IF is_prime = TRUE THEN
			SET result = CONCAT_WS(' | ', result, prime_candidate);
		END IF;
        
        SET is_prime = TRUE,
			prime_candidate = prime_candidate + 1;
    END WHILE;
    
    SELECT result AS prime_to_100;
END//

DELIMITER ;

CALL test();

-- no 7
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	DECLARE vendor_name_var VARCHAR(100);
    DECLARE invoice_number_var VARCHAR(100);
    DECLARE category_var VARCHAR(100);
    DECLARE balance_due_var DECIMAL(9, 2);
	DECLARE row_not_found BOOLEAN DEFAULT FALSE;
    DECLARE result_string_var VARCHAR(1000) DEFAULT '';

	DECLARE vendors_invoices_cursor CURSOR FOR
		SELECT vendor_name, invoice_number, 
			   invoice_total - payment_total - credit_total AS balance_due
        FROM vendors JOIN invoices USING (vendor_id)
        WHERE invoice_total - payment_total - credit_total >= 5000
        ORDER BY balance_due DESC;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
    
	OPEN vendors_invoices_cursor;
    
    fetching_loop : LOOP
		FETCH vendors_invoices_cursor 
        INTO vendor_name_var, invoice_number_var, balance_due_var;
        
        IF row_not_found = TRUE THEN 
			LEAVE fetching_loop;
		END IF;
        
        SET category_var = '';
        
        IF balance_due_var >= 20000 THEN
			SET category_var = '$20,000 or More';
		ELSEIF balance_due_var >= 10000 THEN
			SET category_var = '$10,000 to $20,000';
		ELSEIF balance_due_var >= 5000 THEN
			SET category_var = '$5,000';
		END IF;
        
		SET result_string_var = 
			CONCAT(result_string_var, 
					category_var, ': ',
					balance_due_var, '|',
					invoice_number_var, '|',
					vendor_name_var, '//');
                        
	END LOOP fetching_loop;
	
    CLOSE vendors_invoices_cursor;
    
    SELECT result_string_var AS result;
END//

DELIMITER ;

CALL test();