-- no 1
create index vendors_vendor_zip_code_ix
	on vendors (vendor_zip_code);
    
-- no 2
drop table if exists members_committees;
drop table if exists members;
drop table if exists committees;

create table if not exists members (
	member_id int primary key auto_increment,
    first_name varchar(45) not null,
    last_name varchar(45) not null,
	address varchar(45) not null,
    city varchar(45) not null,
    state varchar(45),
    phone varchar(45)
);

create table if not exists committees (
	committee_id int primary key auto_increment,
    committee_name varchar(45) not null
);

create table if not exists members_committees (
	member_id int not null,
    committee_id int not null,
    constraint member_id_fk 
		foreign key (member_id) 
        references members (member_id),
    constraint committee_id 
		foreign key (committee_id) 
        references committees (committee_id),
    constraint member_id_committee_id_uq 
		unique (member_id, committee_id)
);

-- no 3
insert into members
values 
	(default, 'John', 'Connor', 'A1', 'C1', 'S1', 'P1'),
    (default, 'Sarah', 'Dragon', 'A2', 'C2', 'S2', 'P2');
    
insert into committees
values
	(default, 'Amber Sarah'),
    (default, 'Shinei Nouzen');

insert into members_committees
values
	(1, 2),
    (2, 1),
    (2, 2);
    
select committee_name, members.last_name, members.first_name
from members join members_committees
		using (member_id)
	 join committees
		using (committee_id)
order by committee_name, members.last_name, members.first_name;
    
-- no 4
alter table members
add column annual_dues decimal(5, 2) default 52.50;

alter table members
add column payment_date date;

-- no 5
alter table committees
modify committee_name varchar(45) not null unique;

-- try to insert duplicate
insert into committees
values
	(default, 'Shinei Nouzen');


