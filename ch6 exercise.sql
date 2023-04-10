-- NO 1
SELECT vendor_id, sum(invoice_total)
FROM invoices
GROUP BY vendor_id;

-- NO 2
SELECT vendor_name, sum(payment_total)
FROM vendors v JOIN invoices i
		ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_id
ORDER BY sum(payment_total) DESC;

-- NO 3
SELECT vendor_name, count(invoice_id), sum(invoice_total)
FROM vendors v JOIN invoices i
		USING (vendor_id)
GROUP BY vendor_id
ORDER BY count(invoice_id) DESC;

-- NO 4
SELECT account_description, count(account_number), sum(line_item_amount)
FROM general_ledger_accounts gla JOIN invoice_line_items ili
		USING (account_number)
GROUP BY account_description
HAVING count(account_number) > 1
ORDER BY sum(line_item_amount) DESC;

-- NO 5
SELECT account_description, count(account_number), sum(line_item_amount)
FROM general_ledger_accounts gla 
	 JOIN invoice_line_items ili
		USING (account_number)
	 JOIN invoices i
		USING (invoice_id)
WHERE invoice_date BETWEEN '2018-04-01' AND '2018-06-30'
GROUP BY account_description
HAVING count(account_number) > 1
ORDER BY sum(line_item_amount) DESC;

-- NO 6
SELECT IF(GROUPING(account_number), 'grand_total', account_number) AS account_number, 
	   SUM(line_item_amount), 
       COUNT(account_number)
FROM invoice_line_items
GROUP BY account_number WITH ROLLUP;

-- NO 7
SELECT vendor_name, COUNT(DISTINCT account_number)
FROM vendors v 
	 JOIN invoices i
		USING (vendor_id)
	 JOIN invoice_line_items ili
		USING (invoice_id)
GROUP BY vendor_id
HAVING COUNT(DISTINCT account_number) > 1;

-- NO 8
SELECT IF(GROUPING(terms_id), 'Grand Total', terms_id) AS terms_id, 
	   IF(GROUPING(vendor_id), 'Terms ID Total', vendor_id) AS vendor_id, 
       MAX(payment_date) AS max_payment_date, 
	   SUM(invoice_total - payment_total - credit_total) AS balance_due
FROM invoices
GROUP BY terms_id, vendor_id WITH ROLLUP;

-- NO 9
SELECT vendor_id, 
	   invoice_total - payment_total - credit_total AS balance_due,
       SUM(invoice_total - payment_total - credit_total) OVER() AS balance_due_sum,
       SUM(invoice_total - payment_total - credit_total) 
		 OVER(PARTITION BY vendor_id ORDER BY 
			  invoice_total - payment_total - credit_total) AS vendor_total
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0;

-- NO 10
SELECT vendor_id, 
	   invoice_total - payment_total - credit_total AS balance_due,
       SUM(invoice_total - payment_total - credit_total) OVER() AS balance_due_sum,
       SUM(invoice_total - payment_total - credit_total) 
		 OVER balance_due_window AS vendor_total,
	   ROUND(AVG(invoice_total - payment_total - credit_total)
		 OVER balance_due_window, 2) AS vendor_average
FROM invoices
WHERE invoice_total - payment_total - credit_total > 0
WINDOW balance_due_window AS (PARTITION BY vendor_id ORDER BY 
			  invoice_total - payment_total - credit_total);
              
-- NO 11
SELECT MONTH(invoice_date) AS month, 
	   SUM(invoice_total) OVER() total_invoices,
	   AVG(SUM(invoice_total)) OVER(ORDER BY MONTH(invoice_date)
			ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS 4_month_avg
FROM invoices
GROUP BY MONTH(invoice_date);
