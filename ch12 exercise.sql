-- no 1
create or replace view open_items as
select vendor_name, invoice_number, invoice_total,
	invoice_total - payment_total - credit_total as balance_due
from vendors join invoices using (vendor_id)
where invoice_total - payment_total - credit_total > 0
order by vendor_name;

-- no 2
select *
from open_items
where balance_due >= 1000;

-- no 3
create or replace view open_items_summary as
select vendor_name, count(balance_due) as open_item_count,
	sum(balance_due) as open_item_total
from open_items
where balance_due > 0
group by vendor_name
order by open_item_total desc;

-- no 4
select *
from open_items_summary
limit 5;

-- no 5
create or replace view vendor_address as
select vendor_id, vendor_address1, vendor_address2, 
	vendor_city, vendor_state, vendor_zip_code
from vendors;

-- no 6
update vendor_address
set vendor_address1 = '1990 Westwood Blvd',
	vendor_address2 = 'Ste 260'
where vendor_id = 4;

