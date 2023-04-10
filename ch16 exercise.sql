-- no 1
DROP TRIGGER IF EXISTS invoices_before_update;

DELIMITER //

CREATE TRIGGER invoices_before_update
	BEFORE UPDATE ON invoices
	FOR EACH ROW
BEGIN
	DECLARE sum_line_item_amount DECIMAL(9,2);

	SELECT SUM(line_item_amount) 
	INTO sum_line_item_amount
	FROM invoice_line_items
	WHERE invoice_id = NEW.invoice_id;

	IF sum_line_item_amount != NEW.invoice_total THEN
		SIGNAL SQLSTATE 'HY000'
			SET MESSAGE_TEXT = 'Line item total must match invoice total.';
	END IF;
    
    IF NEW.payment_total + NEW.credit_total > NEW.invoice_total THEN
		SIGNAL SQLSTATE 'HY000'
			SET MESSAGE_TEXT = 'Payment total plus credit total must match invoice total.';
	END IF;
END//

DELIMITER ;

UPDATE invoices
SET payment_total = 100000
WHERE invoice_id = 1;

-- no 2
CREATE TABLE invoices_audit
(
  vendor_id           INT             NOT NULL,
  invoice_number      VARCHAR(50)     NOT NULL,
  invoice_total       DECIMAL(9,2)    NOT NULL,
  action_type         VARCHAR(50)     NOT NULL,
  action_date         DATETIME        NOT NULL
);

DELIMITER //

CREATE TRIGGER invoices_after_update
	AFTER UPDATE ON invoices
	FOR EACH ROW
BEGIN
	INSERT INTO invoices_audit
    VALUES
		(OLD.vendor_id, OLD.invoice_number, OLD.invoice_total, 
			'UPDATED', CURRENT_DATE);
END//

DELIMITER ;

UPDATE invoices
SET invoice_number = 'xxx'
WHERE invoice_id = 114;

-- no 3
SHOW VARIABLES LIKE 'event_scheduler';

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS insert_test;

DELIMITER //

CREATE EVENT insert_test
ON SCHEDULE EVERY 1 SECOND DO
BEGIN
	DECLARE vendor_id_inc_var INT DEFAULT 1;
    
    SELECT MAX(vendor_id) 
    INTO vendor_id_inc_var
    FROM invoices_audit;

	INSERT INTO invoices_audit
    VALUES (vendor_id_inc_var + 1, 'test', 0, 'test', CURRENT_TIMESTAMP);
END//

DELIMITER ;

SHOW EVENTS;

ALTER EVENT insert_test DISABLE;

SELECT * FROM invoices_audit;