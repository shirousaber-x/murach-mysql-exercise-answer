-- NO 8
SELECT
	vendor_name,
    vendor_contact_last_name,
    vendor_contact_first_name
FROM vendors
ORDER BY 
	vendor_contact_last_name ASC,
    vendor_contact_first_name ASC;

-- NO 9
SELECT 
	CONCAT(vendor_contact_last_name, ', ', vendor_contact_first_name) AS name
FROM vendors
WHERE vendor_contact_last_name REGEXP '^[ABCE]'
ORDER BY name ASC;

-- NO 10
SELECT
	invoice_due_date AS `Due Date`,
    invoice_total AS `Invoice Total`,
    ROUND(10.0/100 * invoice_total, 1) AS '10%',
    invoice_total + ROUND(10.0/100 * invoice_total, 1) AS `Plus 10%`
FROM invoices
WHERE invoice_total BETWEEN 500 AND 1000
ORDER BY invoice_due_date DESC;

-- NO 11
SELECT 
	invoice_number,
    invoice_total,
    payment_total + credit_total AS payment_credit_total,
    invoice_total - payment_total - credit_total AS balance_due
FROM invoices
WHERE invoice_total - payment_total - credit_total > 50
ORDER BY balance_due DESC
LIMIT 5;

-- NO 12
SELECT 
	invoice_number,
    invoice_date,
    invoice_total - payment_total - credit_total AS balance_due,
    payment_date
FROM invoices
WHERE payment_date IS NULL;

-- NO 13
SELECT
	DATE_FORMAT(CURRENT_DATE(), '%c-%d-%Y') AS `current_date`;
    
-- NO 14
SELECT
	50000 AS starting_principal,
    ROUND(6.5 * 50000, 1) AS interest,
    50000 + ROUND(6.5/100 * 50000, 1) AS principal_plus_interest;

