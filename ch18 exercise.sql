-- NO 2
CREATE USER ray@localhost IDENTIFIED BY 'temp'
	PASSWORD EXPIRE INTERVAL 90 DAY;
    
GRANT SELECT, INSERT, UPDATE
ON ap.vendors
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE
ON ap.invoices
TO ray@localhost
WITH GRANT OPTION;

GRANT SELECT, INSERT
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- NO 3
SHOW GRANTS FOR ray@localhost;

-- NO 5 (RUN AS ray@localhost)
SELECT vendor_id
FROM vendors;

-- NO 6 (RUN AS ray@localhost)
DELETE FROM vendors
WHERE vendor_id = 1;

-- NO 8
GRANT UPDATE 
ON ap.invoice_line_items
TO ray@localhost
WITH GRANT OPTION;

-- NO 9
CREATE USER dorothy IDENTIFIED BY 'sesame';

CREATE ROLE ap_user;

GRANT SELECT, INSERT, UPDATE
ON ap.*
TO ap_user;

GRANT ap_user
TO dorothy;

-- NO 10 (RUN AS dorothy)
SHOW GRANTS;

-- NO 12 (RUN AS dorothy)
SELECT CURRENT_ROLE();

-- NO 13 (RUN AS dorothy)
SELECT CURRENT_ROLE();

-- NO 14
SET DEFAULT ROLE ap_user TO dorothy;

