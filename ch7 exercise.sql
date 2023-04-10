use ap;

-- no 1
SELECT DISTINCT vendor_name
FROM vendors 
WHERE vendor_id IN (SELECT DISTINCT vendor_id FROM invoices)
ORDER BY vendor_name;

-- no 2
SELECT invoice_number, invoice_total
FROM invoices
WHERE payment_total > (SELECT AVG(payment_total)
					   FROM invoices
                       WHERE payment_total > 0)
ORDER BY invoice_total DESC;

-- no 3
SELECT account_number, account_description
FROM general_ledger_accounts gli
WHERE NOT EXISTS (
					SELECT * 
					FROM invoice_line_items 
					WHERE account_number = gli.account_number
				 )
ORDER BY account_number;

-- no 4
SELECT vendor_name, invoice_id, 
	invoice_sequence, line_item_amount
FROM invoice_line_items ili JOIN invoices
	USING (invoice_id) JOIN vendors
    USING (vendor_id)
WHERE EXISTS (
	SELECT *
    FROM invoice_line_items
    WHERE invoice_id = ili.invoice_id
    GROUP BY invoice_id
    HAVING COUNT(invoice_sequence) > 1
)
ORDER BY vendor_name, invoice_id, invoice_sequence;

-- no 5
SELECT SUM(largest_unpaid) AS sum_largest_unpaid
FROM (
		SELECT vendor_id, MAX(invoice_total) AS largest_unpaid
		FROM invoices 
		WHERE payment_total = 0
		GROUP BY vendor_id
	 ) t;

-- no 6
SELECT vendor_name, vendor_city, vendor_state
FROM vendors
GROUP BY vendor_state, vendor_city
HAVING COUNT(vendor_city) = 1
ORDER BY vendor_state, vendor_city;

-- no 7
SELECT vendor_name, invoice_number, 
	invoice_date, invoice_total
FROM vendors v JOIN invoices i USING (vendor_id)
WHERE invoice_date = (SELECT MIN(invoice_date)
					  FROM invoices
                      WHERE vendor_id = v.vendor_id
					 )
ORDER BY vendor_name;

-- no 8
SELECT vendor_name, invoice_number, 
	oldest_invoice AS invoice_date, invoice_total
FROM
(
	SELECT vendor_name, invoice_number,
		MIN(invoice_date) as oldest_invoice, invoice_total
    FROM vendors JOIN invoices USING (vendor_id)
	GROUP BY vendor_id
) t
ORDER BY vendor_name;

-- no 9
WITH largest_unpaid_vendors AS
(
	SELECT vendor_id, MAX(invoice_total) as largest_unpaid
    FROM invoices
    WHERE payment_date IS NULL
    GROUP BY vendor_id
)
SELECT SUM(largest_unpaid) AS largest_unpaid_sum
FROM largest_unpaid_vendors;
