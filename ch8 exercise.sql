use ap;

-- no 1
SELECT invoice_total,
	FORMAT(invoice_total, 1),
    CONVERT(invoice_total, SIGNED),
    CAST(invoice_total AS SIGNED)
FROM invoices;

-- no 2
SELECT invoice_date,
	CAST(invoice_date AS DATETIME),
    CAST(invoice_date AS CHAR(7))
FROM invoices;