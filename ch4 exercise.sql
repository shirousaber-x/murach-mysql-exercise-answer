-- NO 1
SELECT * 
FROM vendors v INNER JOIN invoices i
	ON v.vendor_id = i.vendor_id;

-- NO 2
SELECT 
	vendor_name,
    invoice_number,
    invoice_date,
    invoice_total - payment_total - credit_total AS balance_due
FROM vendors v INNER JOIN invoices i
	USING (vendor_id)
WHERE invoice_total - payment_total - credit_total <> 0
ORDER BY vendor_name;

-- NO 3
SELECT 
	vendor_name,
    default_account_number AS default_account,
    account_description AS `description`
FROM 
	general_ledger_accounts g INNER JOIN
    vendors v
ON account_number = default_account_number
ORDER BY account_description, vendor_name;

-- NO 4
SELECT 
    vendor_name,
    invoice_date,
    invoice_number,
    invoice_sequence AS li_sequence,
    line_item_amount AS li_amount
FROM
    vendors v
        INNER JOIN
    invoices i USING (vendor_id)
        INNER JOIN
    invoice_line_items il USING (invoice_id)
ORDER BY vendor_name , invoice_date , invoice_number , invoice_sequence;

-- NO 5
SELECT 
    v1.vendor_id,
    v1.vendor_name,
    CONCAT(v1.vendor_contact_first_name,
            ' ',
            v1.vendor_contact_last_name) AS contact_name
FROM
    vendors v1
        INNER JOIN
    vendors v2 ON v1.vendor_id <> v2.vendor_id
        AND v1.vendor_contact_last_name = v2.vendor_contact_last_name
ORDER BY v1.vendor_contact_last_name;

-- NO 6
SELECT 
    g.account_number, account_description
FROM
    general_ledger_accounts g
        LEFT JOIN
    invoice_line_items i ON g.account_number = i.account_number
WHERE
    invoice_id IS NULL
ORDER BY g.account_number;
    
-- NO 7
SELECT 
	vendor_name, 'CA' AS vendor_state
FROM vendors
WHERE vendor_state = 'CA'
UNION
SELECT
	vendor_name, 'Outside CA' AS vendor_state
FROM vendors
WHERE vendor_state <> 'CA'
ORDER BY vendor_name;
