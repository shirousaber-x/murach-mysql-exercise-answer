-- no 1
select invoice_total, round(invoice_total, 1),
	round(invoice_total, 0), truncate(invoice_total, 0)
from invoices;

-- no 2
select start_date,
	date_format(start_date, '%b/%y/%d'),
    date_format(start_date, '%c/%e/%y'),
    date_format(start_date, '%h:%i %p')
from date_sample;

-- no 3
select vendor_name,
	upper(vendor_name),
    vendor_phone,
    right(vendor_phone, 4) as last_digits,
    if(vendor_phone is null, 
		null, 
        concat_ws('.', substring(vendor_phone, 2, 3), 
					substring(vendor_phone, 7, 3), 
					substring(vendor_phone, 11, 4)
					)
		) as phone_with_dots,
	if(locate(' ', vendor_name) > 0, 
		if(locate(' ', vendor_name, locate(' ', vendor_name) + 1) = 0,
			substring(vendor_name, locate(' ', vendor_name) + 1),
			substring(vendor_name, 
						locate(' ', vendor_name) + 1, 
						locate(' ', vendor_name, locate(' ', vendor_name) + 1) - locate(' ', vendor_name) - 1)
			),
		''
        ) as second_word
from vendors;

-- no 4
select invoice_number, invoice_date,
	date_add(invoice_date, interval 30 day),
    payment_date,
    datediff(payment_date, invoice_date) as days_to_pay,
    month(invoice_date),
    year(invoice_date)
from invoices
where invoice_date between '2018-05-01' and '2018-05-31';

-- no 5
select emp_name,
	regexp_substr(emp_name, '[a-z]*') as first_name,
    regexp_substr(emp_name, '[a-z|\'-| ]*', regexp_instr(emp_name, ' ') + 1) as last_name
from string_sample;

-- no 6
select invoice_number,
	invoice_total - payment_total - credit_total as balance_due,
    rank() over(order by (invoice_total - payment_total - credit_total) desc)
from invoices
where invoice_total - payment_total - credit_total > 0

	
