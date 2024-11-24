--schema is like a folder where as database is like a drive eg. C drive in windows. we can create multiple schemas in a single database.

-- regexp in oracle:

-- Write a solution to find the users who have valid emails.
-- A valid e-mail has a prefix name and a domain where:
-- The prefix name is a string that may contain letters (upper or lower case), digits, underscore '_', period '.', and/or dash '-'. The prefix name must start with a letter.
-- The domain is '@leetcode.com'.
-- ^ -> start of string
-- [a-zA-Z] -> upper or lower case letter
-- [a-zA-Z0-9_.-] -> includes upper or lower case letter, numbers or _ or - or .
-- '*' -> can be any number of occurances
-- $ -> end of string
	
select *
from users
where regexp_like(mail,'^[a-zA-Z][a-zA-Z0-9._-]*@leetcode[.]com$');
-- o/p: sally.come@leetcode.com

--DDL > Data Defnition Language
/*
create table employees(
emp_id integer,
emp_name varchar(100),
emp_no number(10)
);
drop table employees;

--ALTER statement
*/

--DML > Data manipulation language
insert into employees values (1,'Tushar',8419997411);
insert into employees values (2,'Aman',9867525253);
insert into employees values (3,'Ajay',8965742278);
insert into employees values (4,'Noor',9867556324);
delete from employees;
--Update statement

--Delete statement 

--DQL > data querying language, if ur not changing any data or table then its DQL
SELECT e.*,rowid,rownum FROM employees e where rownum < 2;  --rowid is unique row id for each row, rownum is the series vise number to each row.

-- top, limit is used in other databases eg, MSSQL.
SELECT TOP (5) * 
FROM Employees 
ORDER BY Salary DESC;

SELECT * 
FROM Employees 
ORDER BY Salary DESC
limit 10;

rename employee to employees;   --renaming table

SELECT * FROM employees order by emp_name desc, emp_id desc;-- for each column we have to specify asc or desc. it will give first preference to first column.

SELECT * FROM employees;

alter table employees 
add joining_date date default '27-03-2023' not null;


alter table employees 
drop column joining_date;


alter table employees 
modify joining_date timestamp;  --datetime datatype is in MYSQL
--datatype should be compatible, if table is empty then we can convert datatype to any other datatype.

insert into employees values (5,'Jane',7598632545,'26-04-2023 06:07:26 AM');


SELECT * FROM orders;



-- Constraints
--1. default constraint
--2. check constraint, it is used to restrict data to specific values while inserting.
--3. unique constraint
--4. not null constraint
--5. primary key constraint, it is the combination of unique + not null.

drop table e_orders;
create table e_orders(
order_id integer not null ,--removing unique bc composite primary key is used below.
o_date date,
prod_name varchar2(10),
total decimal(6,2),
payment_method varchar2(20) check (payment_method in ('UPI','Credit Card')),
discount number(2) check (discount < 20),
category varchar2(10) default 'Mens Wear',
primary key (order_id,prod_name)
);

SELECT * FROM e_orders;
--insert into e_orders values(1,'26-04-2023','headphones',1200,'Cash Payment');   -- Error: check constraint (SYSTEM.SYS_C0010756) violated
--insert into e_orders values(null,'26-04-2023','headphones',1200,'Cash Payment');    --Error: cannot insert NULL
--insert into e_orders values(1,'26-04-2023','headphones',1200,'UPI',25); --Error: check constraint (SYSTEM.SYS_C0010759) violated
--insert into e_orders values(1,'26-04-2023','speakers',1000,'UPI',19);   --Error:  unique constraint (SYSTEM.SYS_C0010763) violated
insert into e_orders values(1,'26-04-2023','speakers',1000,'UPI',19,'Kids Wear');
insert into e_orders(order_id,o_date,prod_name,total,payment_method,discount)
values(1,'26-04-2023','mask',1000,'UPI',19);

insert into e_orders(order_id,o_date,prod_name,total,payment_method,discount)
values(1,'26-04-2023','mask',1020,default,19);

alter table e_orders
modify prod_name varchar2(20);

alter table e_orders
add discount number(20);

--filters
--where clause
SELECT o.*, sysdate, current_date,CURRENT_TIMESTAMP FROM e_orders o;    --sysdate to get current date and time, if NLS setting is set to only date then it will date.

SELECT TRUNC(SYSDATE) AS current_date FROM DUAL; --to get only date.

--MS SQL date
SELECT GETDATE(); -- to get date and time
select cast(getdate() as date); --to get only date

SELECT * FROM e_orders where prod_name > 'mask';    -- filter is done based on ASCII value of each characters

SELECT * FROM orders;

--LIKE operator
--WILDCARD characters
SELECT * FROM orders;
SELECT * FROM orders where customer_name like '%Gut%';
SELECT * FROM orders where upper(customer_name) like '%GUT%';
SELECT * FROM orders where customer_name like '_l%';        -- starts with one character
SELECT * FROM orders where customer_name like '__l%';       -- starts with two characters
SELECT * FROM orders where customer_name like 'S%%' escape '%';     --consider % as a character of a string


--NULL filter
--we don't use = with null because it is a unknown value. thats why we use is special keyword.
--'' -> empty string
--,,(two commas) -> null means unknown
select * from orders where orderid is null;

update orders 
set city = null --we are not comparng it, setting it thats why we use =.
where order_id in ('CA-2020-152156','CA-2020-138688');
commit;

SELECT * FROM orders where city is null;

SELECT * FROM orders where city is not null;


--Aggregation
SELECT * FROM orders;
--group by
--group  by clause is smilar to distinct clause
select count(*) as count,sum(sales), max(sales) as max_sales, min(profit) as min_profit, avg(profit) as avg_profit, 
region 
from orders group by region order by count desc;
--we can only use nonaggregate columns with group by

select count(*), count(order_id), count(distinct order_id) from orders;--we can't pass more than one column inside count function, but it can achieved by using subquery.
select count(*), count(order_id), approx_count_distinct(order_id) from orders;--approx_count_distinct() function is more efficient than count(distinct column) function.
SELECT region FROM orders group by region;  -- group by can be worked as distinct keyword.

--GROUP BY
select sub_category, sum(sales) as total_sales
from orders
where profit > 50
group by sub_category
having sum(sales) > 10000
order by total_sales desc
fetch first 10 rows only;

--order of execution-> from, where, group by, having, select, order by
--WHERE condition is used with nonaggregated column only
--HAVING can be used with aggregated or non aggregated columns
--if there is a need of using aggregated column then we use HAVING clause.

select *
from orders;

select SHIP_MODE, CATEGORY, SUB_CATEGORY,sum(quantity) as total_quantity
from orders
where profit > 50
group by SHIP_MODE,CATEGORY, SUB_CATEGORY
having CATEGORY = 'Furniture'   --we can put any column in having clause not just aggregated function.
order by SHIP_MODE desc
fetch first 10 rows only;
--HAVING can be used with aggregated or non aggregated columns

select sub_category, sum(sales) as total_sales
from orders
where profit > 50
group by sub_category
having sum(sales) > 10000
order by total_sales desc
fetch first 10 rows only;

--all aggregate functions won't cont null values.
--only count(*) will take all values including null.
SELECT * FROM orders;
SELECT count(city) FROM orders;--9991
SELECT count(*) FROM orders;-9994
SELECT count(*) FROM orders where city is not null;--9991

select * from orders;


--day 4 assignment
update orders
set city=null
where order_id in ('CA-2020-161389' , 'US-2021-156909');
commit;

select * from orders where city is null;

select category, sum(profit), min(order_date), max(order_date) 
from orders 
group by category;

select sub_category,avg(profit), max(profit),max(profit)/2 from orders
group by sub_category;
having avg(profit) > max(profit)/2;

create table exams
(
student_id int,
subject varchar(20),
marks int
);

insert all
into exams values (1,'Chemistry',91)
into exams values (1,'Physics',91)
into exams values (1,'Maths',92)
into exams values (2,'Chemistry',80)
into exams values (2,'Physics',90)
into exams values (3,'Chemistry',80)
into exams values (3,'Maths',80)
into exams values (4,'Chemistry',71)
into exams values (4,'Physics',54)
into exams values (5,'Chemistry',79)
select * from dual;
commit;

select * from exams;

select student_id, marks, count(*) as total_rows
from exams
where subject in ('Chemistry','Physics')
group by student_id, marks
having count(*) = 2 ;

select category, count(PRODUCT_NAME)
from orders
group by category;

select sub_category, sum(quantity) as total_quantity
from orders
where region = 'West'
group by sub_category
order by total_quantity desc
fetch first 5 rows only;

select region, ship_mode, sum(sales) as total_sales from orders
where order_date between '01-01-2020' and '31-12-2020'
group by region, ship_mode
order by region;



select student_id,marks,count(*) from exams
group by student_id,marks;

----------db joins--------------------

--inner join
--only give records which are common on both tables
select * 
from employee e
inner join dept d on e.dept_id = d.dep_id;


--left join
--give all the records from left table and if the data from right table does not match with left table then it will put null in that column.

SELECT * FROM employee;
SELECT * FROM dept;

--if you join two tables without giving any condition then it will be cross join


select * 
from eployee, dept;     -- cross join example

select * 
from employee 
inner join dept on 1=1;     --alternate method for cross join


--left join
select * 
from employee e
left join dept d on e.dept_id = d.dep_id;

--right join
select * 
from dept d
right outer join employee e on e.dept_id = d.dep_id;

--both the above joins will give same output.
--on condition order does not matter



--full outer join
select * 
from eployee e
full outer join dept d on e.dept_id = d.dep_id;

--join of more than two tables
select * 
from employee e
left join dept d on e.dept_id = d.dep_id    --order of execution : (Top-Bottom Approach) left join -> inner join
inner join people p on p.region = e.region;     --we can join people table with any one of previous tables.
--we can join n number of tables together.


--day 5 exercise
create table employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);
select * from employee;

create table dept(
    dep_id int,
    dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');
select * from dept;

--exercise
select * from employee;
select * from dept;
select * from returns;
select * from orders;

--WRONG
select o.region, count(r.RETURN_REASON)
from orders o
inner join returns r
on o.order_id = r.order_id
group by region
;
select region,count(distinct o.order_id) as no_of_return_orders
from orders o
inner join returns r on o.order_id=r.order_id
group by region
;

--check
select o.CATEGORY,o.sales
from orders o
left join returns r
on o.order_id = r.order_id
group by o.CATEGORY,o.sales;
having r.RETURN_REASON is not null
;
select category,sum(o.sales) as total_sales
from orders o
left join returns r on o.order_id=r.order_id
where r.order_id is null
group by category
;

select d.dep_name,avg(e.salary),count(rownum)
from employee e 
inner join dept d
on e.dept_id = d.dep_id
group by d.dep_name;

--Question1
--write a query to print dep names where none of the emplyees have same salary.
select d.dep_name
from employee e 
inner join dept d
on e.dept_id = d.dep_id
group by dep_name
having count(salary) != count(distinct salary)
;

--TEST
select o.SUB_CATEGORY,r.RETURN_REASON, count(distinct o.SUB_CATEGORY)
from orders o
left join returns r
on o.order_id = r.order_id
group by o.SUB_CATEGORY,r.RETURN_REASON
having return_reason IN ('Bad Quality',
'Others',
'Wrong Items') and return_reason is not null
order by SUB_CATEGORY
;
select o.sub_category
from orders o
inner join returns r on o.order_id=r.order_id
group by o.sub_category
having count(distinct r.return_reason)=3
;

--TEST
select o.city,r.return_reason
from orders o
inner join returns r
on o.order_id = r.order_id
group by o.city
having r.return_reason is null
;
select city,count(r.order_id)--,count(o.order_id)
from orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0
;

select distinct o.sub_category, o.sales
from orders o 
inner join returns r
on o.order_id = r.order_id
where o.region = 'East'
order by o.sales desc
fetch first 3 rows only;

select DEP_ID,dep_name 
from employee e 
right join dept d
on e.dept_id = d.dep_id
where emp_id is null;

select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;

select emp_name
from employee e 
left join dept d
on e.dept_id = d.dep_id
where dep_name is null;

select * from employee;
--Question2
--find the manager names of all the employees
--consider self join as operation between two identical tables
--if we have to make a jon between two columns of a single table then virtually we have to consider two identical tables and make a join.

--join manager_id of table1 to emp_id of table2
select e1.emp_id as emp_id, e2.emp_id as manager_id, e2.emp_name as manager_name
from employee e1
inner join employee e2 
on e1.manager_id = e2.emp_id;

--Question3
--find manager whose salary is lesser than its employee
select e1.emp_id as emp_id, e2.emp_id as manager_id, e2.emp_name as manager_name
from employee e1
inner join employee e2 
on e1.manager_id = e2.emp_id
where e1.salary > e2.salary;


--Aggregate function
--min,max,avg,count()    -- it will works with all numbers
--min,max         --it will work with date


select * from employee;

select dept_id, avg(salary) average_sal
from employee
group by dept_id;

--LISTAGG aggregate function used to aggregate string i.e to aggregate all the rows of same group to a single row.
-- without LISTAGG
select dept_id, EMP_NAME, salary --in Microsoft SQL, its STRING_AGG
from employee
order by dept_id;

--please refer above code output with below code output to understand it.
--with LISTAGG
select dept_id, LISTAGG(EMP_NAME,'|') as list_of_emp      --in Microsoft SQL, its STRING_AGG
from employee
group by dept_id
order by dept_id;

select dept_id, LISTAGG(EMP_NAME,'|') within group (order by salary) as list_of_emp      --as the name within group suggests, it will sort the values within group.
from employee
group by dept_id;

--date function
select * from orders;
select order_id, order_date, extract(year from order_date)  --datepart(year,order_date) is used in MS SQL
, extract(month from order_date), extract(day from order_date)
from orders;

select order_id, order_date, extract(year from order_date)  --datepart(year,order_date) is used in MS SQL
,add_months(order_date,5)       --dateadd(month,5,order_date) --function is in MSSQL
--,add_day(order_date,5)
from orders
where extract(year from order_date) = 2020;

--there is no datediff() function in oracle, instead we use arithmetic function to_date() for subtraction
--datediff(day,order_date,sip_date) in MS SQL


--CASE - WHEN - ELSE - END statement
--BETWEEN clause includes the boundaries
--case statement is a dynamic column
--in SQL, we dont have if-else so we use case-when
--case statement follows top to bottom approach
--thats why a number which is less than 100 is not consider in <250 and <400
--NOTE: ELSE statement is must in CASE statement, otherwise it will delete all the rows which are not mentioned in case statement.
--it should always end with END statement or else it ill throw error.
select order_id, profit,
case                        --dynamic column
when profit < 100 then 'low profit'
when profit < 250 then 'medium profit'
when profit < 400 then 'high profit'
else 'very high profit'
end as profit_category
from orders;

select order_id, profit,
case
when profit < 0 then 'loss'
when profit < 100 then 'low profit'
when profit >=100 and profit < 250 then 'medium profit'
when profit >=250 and profit < 400 then 'high profit'
else 'very high profit'
end as profit_category
from orders;


--UPDATE QUERY USING CASE - WHEN STATEMENT
update orders 
set amount=case when item='Keyboard' then 1000 
				when item='Mouse' then 500 
                when item='Monitor' then 5000 
                else amount end;
                
                
-- add column to existing table   
alter table employee
add dob date;


--String Function
select * from orders;

SELECT SUBSTR('Oracle Substring', -16, 6) AS Substring FROM dual;
-- Result: "Oracle"

select order_id, 
customer_name,
trim('    tushar    '),
reverse(customer_name),
replace(order_id,'CA-','TA'),
translate(order_id,'CA','sN'),  --one to one character mapping
length(customer_name),
--left(customer_name,4)             --oracle does'nt have left fncton like MSSQL have.
--right(customer_name,4)       ,      --oracle does'nt have right fncton like MSSQL have.
substr(customer_name,2) text ,      --index starts with 1
substr(customer_name,2,4) text2 ,
substr(customer_name,-6) text3  ,   --it will count from end and goes till start
substr(customer_name,3,6),
instr(customer_name,' ') as char_index,     --it will give position of first occurance
instr(customer_name,'C') as char_index,      --it will give position of first occurance
concat(concat(order_id,'-'),customer_name),
order_id||'-'||customer_name,            --double bar, same as above
substr(customer_name,1,instr(customer_name,' ')),    --it will print till where first space is occuring
substr(customer_name,1,instr(customer_name,'e'))    --it will print till where first r is occuring
--replace(col,'AT','TA'),
--translate(col,'NMP','WER'),
--substr(col,2,5),
--substr(col,-5),
--substr(col,4),
--instr(col,'R'),
--concat(col,col2),
--substr(col,1,instr(col,' ')
from orders;

--NVL has 2 parameters and it replaces null values with argument
select order_id, city, 
nvl(city,'unknown'),      --in MSSQL its ISNULL
state,region,
coalesce(city,'unknown'),      --in COALESCE function, we can pass more than one argument
coalesce(city,state,region,'unknown') ,    --if city is null then state value, if state is null then region value, if region is also null then passing string argument
coalesce(city,state,region),      
nvl(sales,1),
--nvl(sales,'AB')   ---error
coalesce(sales,1)
--coalesce(sales,'bh')  ---error
from orders
where city is null;

--NVL2 has 3 parameters and if the 1st parameter value is NULL then exp1 otherwise exp2.
select NVL2(NULL, 1, 2) from dual; --returns 2 because the first argument is null.
select NVL2(1, 'ABC', 'XYZ') from dual; --returns ‘ABC’ because the first argument is not null.

--CAST & ROUND function
select order_id,sales, 
cast(sales as int),   --converting float to int in query. --it also do round to the value
round(sales),        --round to zero integer after decimal. --same as above
round(sales,'1')     --round to one integer after decimal.
from orders
fetch first 5 rows only;


--set queries
--difference between JOIN and UNION or other set operators are Join will combine column of tables where as set operator will combine two or more tables
-- join combine columns from two tables; whereas, union (set operations) will have same no. of columns of a single table but combined rows from two tables.

create table orders_west
(
order_id int,
region varchar2(10),
sales int
);
create table orders_east
(
order_id int,
region varchar2(10),
sales int
);

insert into orders_west values(1,'west',100);
insert into orders_west values(2,'west',200);
insert into orders_west values(3,'east',300);
insert into orders_east values(3,'east',300);
insert into orders_east values(4,'east',300);
insert into orders_east values(7,'east',200);
insert into orders_east values(5,'east',500);
commit;
--DELETE FROM orders_west WHERE region = 'east';

select * from orders_west;
select * from orders_east;
--whle performing union all, make sure that the number of columns and the dataype should be same for both the tables.



--only union all will give u everything, intersect, minus, union will remove duplicates
select * from orders_west   --4rows, without duplicates
union
select * from orders_east;

select * from orders_west   --5rows, all rows including duplicates
union all
select * from orders_east;

select distinct * from orders_west   --5rows, all rows including duplicates
union all
select distinct * from orders_east;

select * from orders_west   --common rows between tables
intersect
select * from orders_east;

select * from orders_west   --orders_west - orders_east
except      --same as minus
select * from orders_east;

select * from orders_west   --orders_west - orders_east
minus      --same as except
select * from orders_east;

--day 7 exercise

create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

select * from icc_world_cup
union all
select * from icc_world_cup;

select customer_name,
substr(customer_name,1,instr(customer_name,' ')) as first_name,
substr(customer_name,instr(customer_name,' ')) as last_name
from orders;

--date datatype stores both time and date
create table drivers
(
id varchar2(10), 
start_time date, 
end_time date, 
start_loc varchar2(10), 
end_loc varchar2(10)
);

--display only time portion of date-time value by altering session
alter session set NLS_DATE_FORMAT = 'HH24:MI:SS';


select * from drivers;
insert into drivers values('dri_1', to_date('09:00:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), to_date('09:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'a','b');
insert into drivers values('dri_1',to_date('09:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), to_date('10:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'b','c');
insert into drivers values('dri_1',to_date('11:00:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'),to_date('11:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'd','e');
insert into drivers values('dri_1',to_date('12:00:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'),to_date('12:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'f','g');
insert into drivers values('dri_1', to_date('13:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), to_date('14:30:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'c','h');
insert into drivers values('dri_2', to_date('12:15:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'),to_date('12:40:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'f','g');
insert into drivers values('dri_2',to_date('13:15:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'),to_date('14:15:00','yyyy-mm-dd hh:mi:ss'));'hh24:mi:ss'), 'c','h');
commit;

select d1.*,d2.*
from drivers d1
join drivers d2
on d1.id = d2.id and d1.end_time=d2.start_time and d1.end_loc = d2.start_loc;
group by id;


-- join combine columns from separate tables; whereas, union operations combine rows from separate tables.
--union all example

--VIEW
create view orders_vw as
select * from orders where region = 'East';

select * from orders_vw;

alter table dept 
add constraint primary_key primary key (dep_id);

--Foreign Key
--NOTE: to apply foreign key constraint, the column of other table must be primary key first.
create table emp
(
emp_id int,
name varchar2(10),
dep_id int not null references dept(dep_id)     --foreign key constraint
);

--since above table is dependent on dept table, therefore we cant update or delete dep_id record which is dependent in emp table
insert into emp values (1,'aman',100);
insert into emp values (2,'tushar',200);
--insert into emp values (1,'aman',500);  --ERROR, since its foreign key and 50 is not present in dept table.

select * from emp;
select * from dept;


create table dept1
(
id int generated always as identity,    --autosubstituted and auto incremented
dep_id int,
dep_name varchar2(10)
);

insert into dept1(dep_id, dep_name) values(10,'HR');

select * from dept1;



--WITH clause, SUBQUERY
select * from orders;

--find order_id who has sales more than average sales
select order_id, sum(sales) 
from orders
group by order_id
having sum(sales) >
(
select avg(total_sales) from
(select order_id, sum(sales) as total_sales 
from orders
group by order_id)
);

select * from orders where order_id = 'US-2019-134026';

select * from dept;

-- subquery
select e.*,(select avg(salary) as avg_sal from employee) from employee e
where dept_id not in (select dep_id from dept);
NOTE: for NOT IN, If the inner query has any NULL value then it will give zero records. so to rectify this use below query.
select e.*,(select avg(salary) as avg_sal from employee) from employee e
where dept_id not in (select dep_id from dept where dep_id is not null);

-- left join
select *
from employee e 
left join dept d
on e.dept_id = d.dep_id
where d.dep_id is null;


--teamname,noofmatches,won,loss
select team_name,count(*) as noofmatches,sum(status) as win,count(*)-sum(status) as loss from
(
select team_1 as team_name,case when team_1=winner then 1 else 0 end as status from icc_world_cup
union all
select team_2 as team_name,case when team_2=winner then 1 else 0 end from icc_world_cup
)
group by team_name;

--CTE common table expression
with A1 as
(
select team_1 as team_name,case when team_1=winner then 1 else 0 end as status from icc_world_cup
union all
select team_2 as team_name,case when team_2=winner then 1 else 0 end from icc_world_cup
)
,B1 as (select team_name  from A1)-- above CTE is referred here
--B1 will not be executed by DB because its not been called.
select team_name,count(*) as noofmatches,sum(status) as win,count(*)-sum(status) as loss
from A1
group by team_name;


--day 9 exercise
--NOTE: Apart from columns of a particlar table from WITH clause, nothing will come in select query. we can call other tables too.

--Question6 
--write a query to print product id and total sales of highest selling products (by no of units sold) in each category
select distinct category from orders;

select product_id, total_sales from (
select *, dense_rank() over(partition by category_name order by no_of_sales) as rnk from (
select c.category_name, o.product_id, count(o.sales) no_of_sales, sum(o.quantity) as total_sales
from orders o
inner join category c
on o.order_id = c.order_id
group by c.category_name, o.product_id
)
)where rnk = 1
;

--we have frst created query to get the total sales quantity of each product, now next we will find the max quantity of sales done for product.
with A1 as
(
select category, product_id, sum(quantity) as total_quantity
from orders
group by category, product_id
)
, B1 as
(
select category,max(total_quantity) as max_quantity from A1 group by category
)
select A1.*, B1.max_quantity from A1 inner join B1 on A1.category = B1.category where A1.total_quantity = B1.max_quantity; -- group by product_id ;

--5- write a query to print emp name, salary and dep id of highest salaried employee overall
select * from employee;
select emp_name,salary,dept_id from employee
where salary = (select max(salary) from employee);


--4- write a query to print emp name, salary and dep id of highest salaried employee in each department 
with A1 as (
select dept_id,max(salary) as max_sal from employee
group by dept_id
)
, B1 as (
select emp_name, salary, dept_id from employee
)
select A1.dept_id, A1.max_sal ,B1.emp_name from A1 inner join B1 on A1.dept_id = B1.dept_id where B1.salary = A1.max_sal;


--3- write a query to find employees whose age is more than average age of all the employees.
select * from employee where emp_age > (select avg(emp_age) from  employee);


--2- write a query to find employees whose salary is more than average salary of employees in their department
with A1 as
(
select dept_id, avg(salary) as avg_sal from employee group by dept_id 
)
, B1 as
(
select * from employee
)
select * from A1 inner join B1 on A1.dept_id = B1.dept_id where B1.salary > A1.avg_sal;


--1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.

with A1 as 
(
select customer_id, count(distinct order_id) as total_count from orders group by customer_id
)
select * from A1 where total_count > (select avg(total_count) from A1);
----------------------------------------------------------------------------------------------

-- WINDOW Functions (over())
--when we use * in select query, we should assign alias or else it will give error in oracle
select * from employee; 

select * from employee
order by dept_id, salary desc; -- it will do first dept_id asc and salary desc

--Q. rank from highest salary
--in row_number() or rank() or dense_rank(), compulsory we have to use order by
select e.*,
row_number() over(order by salary desc) as rn
from employee e;

--creating window of dept_id
select
e.*,
row_number() over( partition by dept_id order by salary desc) as rn
from employee e;

--if there are duplicates   , since row_number gives unique number to each row whether its duplicate or not.
select
e.*,
row_number() over( partition by dept_id order by salary desc, emp_id asc) as rn     -- it is useful in rank(), dense_rank()
from employee e;                        --in order by, execution is from left to right


--Q. print top 2 ranks of each department
--since where clause runs before of select clause, we can't use where condition to get the output.
select
e.*,
row_number() over( partition by dept_id order by salary desc, emp_id asc) as rn
from employee e;
--where rn <=2;     --error


select * from employee;
select emp_id, emp_name, sum(salary) from employee group by emp_id, emp_name;

--NOTE: Also, we cannot use HAVING without GROUP BY
--NOTE: by default aggregate function needs more than one value for max, min, avg, sum functions as the name suggest it need more than one value to compare i.e group by function is used.
--Therefore, using subquery we can achieve it.
select * from
(select
e.*,
row_number() over( partition by dept_id order by salary desc, emp_id asc) as rn
from employee e) where rn <=2;
 
--Q. find top 2 ranks
with A1 as
(select
e.*,
row_number() over( partition by dept_id order by salary desc, emp_id asc) as rn
from employee e)
select * from A1 
where rn <=2;

--partition creates seperate cabin window
--chronology: partition by -> order by clause will work.
--in SELECT query, the execution is from left to right
select
e.*
, row_number() over(order by salary desc, emp_id asc) as rn    --passing emp_id to make to unique
, row_number() over(order by salary desc) as rn2
, rank() over(order by salary desc, emp_id asc) as rk
, rank() over(order by salary desc) as rk2     -- it will skip next number
, dense_rank() over(order by salary desc) as drk   -- it will not skip next number
, row_number() over(partition by dept_id order by salary asc) as rn3   --it ill print number in desc
, row_number() over(partition by dept_id order by salary desc) as rn3   --it ill print number in desc
, row_number() over(partition by dept_id, salary order by salary asc) as rn3   --it ill print number in desc
, rank() over(partition by dept_id, salary order by salary desc) as rn3 --all 1 because all are unique, and starting 2 rows are same therefore it will skip 2 for it.
, dense_rank() over(partition by dept_id, salary order by salary desc) as rn3 --all 1 because all are unique and duplicate from 2nd row, and starting 2 rows are duplicate therefore it will skip 2 for it.
from employee e;


-- Q. find top 5 products in each category
select * from orders;--01:09 vdo

with A1 as (
select category, product_id, sum(sales) as sum_of_sales
from orders
group by category, product_id
)
, B1 as (
select a.*, dense_rank() over(partition by category order by sum_of_sales desc) as rank
from A1 a
--where rank <3;  --we cant use identifier from select clause into where clause, since WHERE runs first than SELECT
--therefore creating B1 to fetch value in where clause
)
select * from B1 
where rank <= 5;

--if the question was to find top 5 salaires of employees then there is no need to aggregate first in below query



--LEAD and LAG windows function
--it will print next value for lead and previous value for lag.
--it needs one or two parameters
select e.*,
lead(salary,1) over(order by salary) as lead_sal  
,lead(salary,2) over(order by salary) as lead_sal  
,lag(salary,1) over(order by salary) as lag_sal  
,lag(salary,2) over(order by salary) as lag_sal  
from employee e;

select e.*,
lead(salary,1) over(partition by dept_id order by salary) as lead_sal   --default value is assigned
from employee e;

--last row will be null since there is no next value but we can assign defalut value to it
select e.*,
lead(salary,1,salary) over(order by salary) as lead_sal --if there is null value then current salary as default value will be assigned
from employee e;

select e.*,
lead(salary,1,9999) over(partition by dept_id order by salary) as lead_sal   -- 9999 default value is assigned
from employee e;

select e.*,
lead(salary,2) over(order by salary) as lead_sal
from employee e;

--lag is reverse of lead
select e.*,
lag(salary,1) over(order by salary) as lag_sal
from employee e;

--we can use lag instead of lead and generate the same reult or vice-versa
-- Q. To get salary of person higher to your current salary
select e.*,
lead(salary,1) over(order by salary asc) as lead_sal
from employee e;

select e.*,
lag(salary,1) over(order by salary desc) as lag_sal
from employee e;

--salary lower than yours curent

select e.*
,lead(salary,1) over(order by salary desc) as lead_lower_sal
,lead(salary) over(order by salary desc) as lead_lower_sal      -- by default its 1
,lag(salary,1) over(order by salary) as lag_lower_sal
,lag(salary) over(order by salary) as lag_lower_sal             -- by default its 1
from employee e;


select e.*,
first_value(salary) over(order by salary desc) as first_sal,
last_value(salary) over(order by salary desc) as last_sal   --it will print same value       -- it will consider unbounded preceeding and current value
from employee e;


--day 10 exercise

--1- write a query to print 3rd highest salaried employee details for each department (give preference to younger employee in case of a tie). 
--In case a department has less than 3 employees then print the details of highest salaried employee in that department.
with A1 as
(
select e.*,row_number() over(partition by dept_id order by salary desc) as rn from employee e
)
, B1 as 
(
select dept_id, count(*) as total_emp from employee group by dept_id
)
select a.dept_id, a.salary,a.rn, b.total_emp
from A1 a
inner join B1 b
on a.dept_id = b.dept_id
where rn = 3 or (total_emp < 3 and rn = 1);--highest sal 1


--2- write a query to find top 3 and bottom 3 products by sales in each region.
--with A1 as
--(
--select o.*, rank() over(partition by region order by sales desc) as top_sales_rn from orders o
--)
--, B1 as
--(
--select o.*, rank() over(partition by region order by sales asc) as bottom_sales_rn from orders o
--)
--select a.*,a.top_sales_rn ,b.bottom_sales_rn, case when a.top_sales_rn < 4 then 'Top 3' when b.bottom_sales_rn < 4 then 'Bottom 3' end as Top_bottom
--from A1 a
--inner join B1 b
--on a.region = b.region
--where a.top_sales_rn < 4 or b.bottom_sales_rn < 4;

--first we have to do summation of sales then we have to generate rank on it   

--one with clause will  alwasy be for sum if sales question is asked
with region_sales as (
select region,product_id,sum(sales) as sales
from orders
group by region,product_id
)
,rnk as 
(
select r.*, rank() over(partition by region order by sales desc) as drn, rank() over(partition by region order by sales asc) as arn
from region_sales r
)
select region,product_id,sales,case when drn <=3 then 'Top 3' else 'Bottom 3' end as top_bottom
from rnk
where drn <=3 or arn<=3;


--select * from orders;
--select * from
--(
--select o.*
--, rank() over(partition by region order by sales desc) as rn
--from orders o
--)
--where rn <4;


--3- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.

with sbc_sales as (
select sub_category,to_char(order_date,'yyyyMM') as year_month, sum(sales) as sales
from orders
group by sub_category,to_char(order_date,'yyyyMM')
)
, prev_month_sales as (
select *,lag(sales) over(partition by sub_category order by year_month) as prev_sales
from sbc_sales
)
select  top 1 * , (sales-prev_sales)/prev_sales as mom_growth
from prev_month_sales
where year_month='202001'
order by mom_growth desc;

--The purpose of the Oracle TO_CHAR function is to convert either a number or a date value to a string value. It works similar to the TO_DATE function and TO_NUMBER function. This function takes either a number or a date as an input, and converts it to a string value to be displayed or processed accordingly.
select o.*, to_char(order_date,'yyyyMM') from orders o;
select o.*, extract(year from order_date) from orders o;


--4- write a query to print top 3 products in each category by year over year sales growth in year 2020.




--5- create below 2 tables 

--write a query to get start time and end time of each call from above 2 tables.Also create a column of call duration in minutes.  Please do take into account that
--there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.

drop table call_end_logs;
create table call_end_logs
(
phone_number varchar(10),
start_time timestamp
);
select * from call_end_logs;
insert into call_end_logs values ('PN1',to_timestamp('2022-01-01 10:20:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN1',to_timestamp('2022-01-01 16:25:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN2',to_timestamp('2022-01-01 12:30:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-02 10:00:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-02 12:30:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-03 09:20:00','yyyy-mm-dd hh:mi:ss'));
commit;

create table call_end_logs
(
phone_number varchar(10),
end_time timestamp
);

insert into call_end_logs values ('PN1',to_timestamp('2022-01-01 10:45:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN1',to_timestamp('2022-01-01 17:05:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN2',to_timestamp('2022-01-01 12:55:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-02 10:20:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-02 12:50:00','yyyy-mm-dd hh:mi:ss'));
insert into call_end_logs values ('PN3',to_timestamp('2022-01-03 09:40:00','yyyy-mm-dd hh:mi:ss'));
commit;

select * from call_start_logs;
select * from call_end_logs;

--windows function can also be used to create primary key
with A1 as
(
select s.*
, row_number() over(partition by phone_number order by start_time) as rn 
from call_start_logs s
)
, B1 as
(
select e.*
, row_number() over(partition by phone_number order by end_time) as rn 
from call_end_logs e
)
select s.phone_number, s.start_time, e.end_time, e.end_time - s.start_time as duration --,to_char(s.start_time,'hh:mi:ss'),to_char(e.end_time,'hh:mi:ss') 
from
A1 s
inner join 
B1 e
on s.phone_number = e.phone_number and s.rn = e.rn;     --acting as a primary key


--AGGREGATION using WINDOWS function

--Q. to print avg salary for each department, it should print all rows of table with avg value.
with A1 as
(
select dept_id, avg(salary) as avg_salary
from employee
group by dept_id
)
, B1 as
(
select * from employee
)
select b.*,a.avg_salary
from A1 a
inner join B1 b
on a.dept_id = b.dept_id;

--below query works same as above query
--it doesn't matter to use order by in aggregate windows function
select e.*
,max(salary) over() as max_salary    --working as a subquery
,avg(salary) over() as avg_salary    --working as a subquery
,avg(salary) over(partition by dept_id) as avg_salary    --working as a subquery
,min(salary) over(partition by dept_id) as min_salary    --working as a subquery
,max(salary) over(partition by dept_id) as max_salary    --working as a subquery
,count(salary) over(partition by dept_id) as count_of__salary    --working as a subquery
from employee e;

--if we mention ORDER BY in aggregate function then it will do RUNNING operation
select e.*,
sum(salary) over(partition by dept_id) as sum_salary
,avg(salary) over(partition by dept_id) as avg_salary    
,sum(salary) over(partition by dept_id order by emp_age) as sum_sal_orderby --running sum : current value gets add up with next value in sum().
,sum(salary) over(order by emp_age) as sum_sal_orderby
from employee e;

select e.*
--,max(salary) over(partition by dept_id) as max_salary    --working as a subquery
--,max(salary) over(partition by dept_id order by emp_age) as max_sal_orderby --RUNNING max
,max(salary) over(order by emp_age) as max_sal_orderby
,max(salary) over(order by emp_age desc) as max_sal_orderby     --this query will run first then above query.
from employee e;


select e.* 
,sum(salary) over(order by emp_id) as rolling_sum_salary
--below query will take rolling sum of preceding 2 rows
,sum(salary) over(order by emp_id rows between 2 preceding and current row) as rolling_sum_salary
--below query will sum 1 preceding and 1 following along with current row
,sum(salary) over(order by emp_id rows between 1 preceding and 1 following) as rolling_sum_salary
,sum(salary) over(partition by dept_id order by emp_id rows between 1 preceding and 1 following) as rolling_sum_salary
--below query will take sum of from its 5th row till 10th row
,sum(salary) over(order by emp_id rows between 5 following and 10 following) as rolling_sum_salary
from employee e;


select e.* 
--both the below queries will work and give same output
,sum(salary) over(order by emp_id) as rolling_sum_salary
,sum(salary) over(order by emp_id rows between unbounded preceding and current row) as rolling_sum_salary

--below query takes sum of all rows
,sum(salary) over(order by emp_id rows between unbounded preceding and unbounded following) as rolling_sum_salary

--both below query wll work the same
,sum(salary) over(partition by dept_id) as rolling_sum_salary
,sum(salary) over(partition by dept_id order by emp_id rows between unbounded preceding and unbounded following) as rolling_sum_salary
from employee e;


--practice
select e.emp_id, e.emp_age,e.dept_id, e.salary
,sum(salary) over(partition by dept_id) as sum_partitionby  --sum of all in that particular partition
,sum(salary) over(order by emp_age) as sum_orderby      -- running sum = one previous value of sum(salary) + current value of salary, like a triangle
,sum(salary) over(partition by dept_id order by emp_age) as sum_partition_order
,sum(salary) over(order by emp_age rows between 2 preceding and current row) as preceding_currentrow -- running sum, --2 preceding of salary will addup to current salary value.
,sum(salary) over(order by emp_age rows between 1 preceding and 1 following) as preceding_following -- running sum, --1 preceding will addup to current row and 1 following values.
,sum(salary) over(order by emp_age rows between current row and 1 following) as currentrow_following -- running sum, -- addup to current row and 1 following values.
,sum(salary) over(order by emp_age rows between unbounded preceding and current row) as unb_preceding_currentrow -- running sum,all preceding value will addup to current row values.
,sum(salary) over(order by emp_age rows between current row and unbounded following) as currentrow_unb_foll -- running sum, --current row will addup till last following value values.
from employee e;

select e.emp_id, e.emp_age,e.dept_id, e.salary
--both the below queries are same
,sum(salary) over(order by emp_age rows between unbounded preceding and unbounded following) as currentrow_unb_fol -- running sum, --toget sum of all rows in each row.
,sum(salary) over() as sum_orderby      -- running sum
from employee e;


select * from employee;
select e.*
,first_value(salary) over(order by salary) as first_sal_value
,first_value(salary) over(order by salary desc) as last_sal_value   --working as a last_value
--below query will consider from unbounded preceding to current row, therefore it tqkes curret row as last row and display the same value
,last_value(salary) over(order by salary) as last_sal_value   --working as a last_value
,last_value(salary) over(order by salary rows between current row and unbounded following) as last_sal_value   --working as a last_value    --15000
,last_value(salary) over(order by salary desc rows between current row and unbounded following) as last_sal_value   --working as a last_value   --5000
from employee e;

--NOTE: for aggregate function its always rows between unbounded preceding and current row


select row_id from orders;


--NOTE: in CTE or subquery you cannot use order by, therefore it should be used in select clause
--in Oracle order by is running with CTE

--Q. to find sum of previous one quarter
with A1 as
(
select extract(year from order_date) as year, extract(month from order_date) as month, sum(sales) as sum_sales
from orders 
group by extract(year from order_date), extract(month from order_date) 
--order by year,month
)
select a.*, sum(sum_sales) over(order by year,month rows between 2 preceding and current row) as rolling_sum
from A1 a;


--day 11 exercise

--1- write a sql to find top 3 products in each category by highest rolling 3 months total sales for Jan 2020.

--NOTE: whenever question on sales is asked then first create sum of sales for individual product id and then work further on that.
--chronology:    group by sales -> rolling_sum -> rank -> top 3

with A1 as      --created sum of individual product sales
(
select o.category, o.product_id, extract(year from order_date) yo, extract(month from order_date) mo, sum(sales) as sum_of_sales
from orders o
group by o.category, o.product_id, extract(year from order_date) , extract(month from order_date) 
)
, B1 as
(
select a.*, sum(sum_of_sales) over(partition by category order by sum_of_sales rows between 2 preceding and current row) as rolling_sales
from A1 a
)
select * from
(
select b.*, dense_rank() over(partition by category order by rolling_sales desc) as rank
from B1 b
)
where rank < 4;

--with A1 as
--(
--select o.category, o.product_id, extract(year from o.order_date) as yo ,extract(month from o.order_date) as mo, sum(sales) as sum_sales
--from orders o
--group by o.category, o.product_id, extract(year from o.order_date), extract(month from o.order_date)
--)
--,B1 as
--(
--select a.*
--,sum(a.sum_sales) over(partition by a.category, a.product_id order by a.yo, a.mo rows between 2 preceding and current row) as rolling_sum
--from A1 a
--)
--select * from (
--select b.*,rank() over(partition by b.category order by b.rolling_sum desc) as rn from B1 b
--where b.yo=2020 and b.mo=1) A
--where rn<=3;


--2- write a query to find products for which month over month sales has never declined.
with A1 as
(
select o.product_id,extract(year from o.order_date) as yo ,extract(month from o.order_date) as mo, sum(o.sales) sales
from orders o
group by o.product_id,extract(year from o.order_date) ,extract(month from o.order_date)
)
, B1 as
(
select a.*, lag(a.sales,1) over(partition by product_id order by a.yo, a.mo) as prev_month_sales
from A1 a
)
--select distinct b.product_id
--from B1 b
--where b.prev_month_sales < b.sales;
select distinct product_id from B1 where product_id not in
(select product_id from B1 where sales<prev_month_sales group by product_id);



with xxx as (select product_id,datepart(year,order_date) as yo,datepart(month,order_date) as mo, sum(sales) as sales
from orders 
group by product_id,datepart(year,order_date),datepart(month,order_date))
,yyyy as (
select *,lag(sales,1,0) over(partition by product_id order by yo,mo) as prev_sales
from xxx)
select distinct product_id from yyyy where product_id not in
(select product_id from yyyy where sales<prev_sales group by product_id);



--3- write a query to find month wise sales for each category for months where sales is more than the combined sales of previous 2 months for that category.
with A1 as
(
select o.category, extract(year from o.order_date) as yo, extract(month from o.order_date) as mo, sum(sales) as sum_of_sales
from orders o
group by o.category, extract(year from o.order_date), extract(month from o.order_date)
--order by extract(year from o.order_date), extract(month from o.order_date);
)
, B1 as
(
select a.*, sum(a.sum_of_sales) over(partition by category order by a.yo, a.mo rows between 2 preceding and 1 preceding) as prev_2_sales
from A1 a
)
select b.* 
from B1 b
where b.sum_of_sales > b.prev_2_sales ;


--PROCEDURE
--NOTE: if else statement will work in stored procedure only and not in SQL query. 
--To perform DML operations, we use stored procedure
--it accepts some input from parameters (if any) do some operations and may or may not returns a value.

--paramters are of 3 types:
--IN (default)  : receives value
--OUT           : send value
--IN OUT        : receives and send value

--EXAMPLE
--create or replace NONEDITIONABLE procedure proc1(E IN NUMBER,S OUT NUMBER)
--is
--begin
--
--    SELECT salary into S from employee where emp_id=E;
--
--end;

select * from employee;
SELECT salary from employee where emp_id=5;


VARIABLE S NUMBER;
EXECUTE PROC1(5,:S);    --S is output variable
PRINT :S                --after successfully executing above procedure, printing output variable

--FUNCTION
--A user defined function accepts some input perform some calculations and must return a value.

--calling user defined function through sql query
SELECT CALC(10,20,'/') FROM dual;

--TO CALL FUNCTION FROM SQL PROMPT
VARIABLE K NUMBER;
EXECUTE :K := CALC(10,20,'/');
PRINT :K 
;

--PIVOT AND UNPIVOT
--many database don't have pivot in it.
select * from orders;

--Q. to get the sales of each category in 2020 and 2021
--aggregate fucntion using case statament
select o.category
,sum(case when extract(year from o.order_date)=2020 then o.sales end) sales_in_2020
,sum(case when extract(year from o.order_date)=2021 then o.sales end) sales_in_2021
from orders o
group by o.category;

select * from
(
select o.category, extract(year from o.order_date) as year, o.sales
from orders o
) A1
pivot
(
sum(sales)      --alias should not be mentioned, else it will throw error.
for year in (2020,2021)
)B1;





--Q. To find max sales of each category in each region for year 2020,2021
select o.category, o.region
, max(case when extract(year from o.order_date)=2020 then o.sales end) max_2020
, max(case when extract(year from o.order_date)=2021 then o.sales end) max_2021
from orders o
group by o.category, o.region;

--same code is done using pivot
--PIVOT will automatically group the columns which we want.
select * from
(
select category, region, extract(year from order_date) year, sales    --clean columns
from orders
)A1
pivot(
sum(sales)
for year in (2020,2021)     -- for - in statement in pivot.
)B1;


--Q. to find sum of sales for each category for region south and east.
select category, sum(sales)
from orders
where region in ('South','East')
group by category;

select category
,sum(case when region='South' then sales end) sum1
,sum(case when region='East' then sales end) sum2
from orders
group by category;

select * from
(
select category, region, sales
from orders
)A1
pivot
(
sum(sales)
for region in ('South','East')
)B1;


select o.category
,sum(case when extract(year from o.order_date)=2020 then o.sales end) as sales_2020
,sum(case when extract(year from o.order_date)=2021 then o.sales end) as sales_2021
from orders o
group by o.category; 

--same as above query
select * from
(
select o.category, extract(year from o.order_date) as yod, o.sales
from orders o
) t1
pivot 
(
sum(sales) 
for yod in (2020,2021)  --whatever you give here, that many number of columns are created.
) t2;

--same as above query
select * from
(
select o.category, o.region, o.sales
from orders o
) t1
pivot 
(
sum(sales) 
for region in ('West','East','eastwest')  --whatever you give here, that many number of columns are created.    --if eastwest value is not present in table then also it will print with null values.
) t2;

--commit;
--rollback;
--begin transaction
--end


--NOTE: database snapshot is taken by the dba to keep backup of it.

--Advanced Insert, Update, Exist, non exist
create table employee_bkp_20230705 as select * from employee;
create table dept_bkp_20230705 as select * from dept;
select * from employee;
select * from dept;

update employee
set salary=salary*1.1
where dept_id = (select dep_id from dept where dep_name='HR');
commit;

alter table employee add dept_name varchar2(20);

--update employee           -- works in MS SQL, doesn't work in oracle.
--set dept_name = dep_name
--from employee e
--inner join 
--dept d
--on e.dept_id = d.dep_id;

merge into employee e
using dept d
on (e.dept_id = d.dep_id)
when matched then update set e.dept_name = d.dep_name;

merge into employee e
using dept d
on (e.dept_id=d.dep_id)
when matched then update set e.salary=e.salary*1.2
where d.dep_name='IT';          --where e.dept_name='IT';   





merge into employee e
using dept d
on (e.dept_id = d.dep_id)
when matched then update set e.dept_name = d.dep_name
                  delete where e.manager_id=6;
rollback;

select * from employee;

delete from employee
where dept_id not in (select dep_id from dept);
rollback;

--EXISTS

--exists gives true or false, if its true for particular row then it will show output
select * from employee e
where exists (select 1 from dept d where e.dept_id=d.dep_id);

--the outer query wll run for each row inner query and fetch the output
in IN opertor, inner query is run only single time but in EXISTS the inner query will run for each row of outer query.
--it is similar to IN

--opposite of exists
select * from employee e
where not exists (select 1 from dept d where e.dept_id=d.dep_id);

--TRANSACTION
--COMMIT;
--ROLLBACK;
--SAVEPOINT;

select * from employee;

update employee set emp_name='TusharAnnam' where emp_id=1;
commit;

update employee set emp_name='Jay' where emp_id=4;
rollback;

update employee set emp_name='Aman' where emp_id=2;
savepoint A1;

update employee set emp_name='Manoj' where emp_id=7;
savepoint B1;

rollback to A1;


--INDEXES
--Data is searched in a Binary tree structure
--when we give primary key, clustered index is automatically created.
--in clustered index, data is sort by only one column and are unique.
--in non clustered index, data is stored in a key-value pair and are non-unique. key is the column data and value is the address of that data
--Clustered index is called "index organized table" (IOT) in Oracle - which in my opinion is the better name as it makes it absolutely clear that the index and the table are the same physical thing (which is the reason why we can have only one clustered index in SQL Server)
drop table emp_index;

--clustered index
create table emp_index
(
emp_id int,
emp_name varchar2(10),
salary int,
primary key(emp_id)
)
organization index;

--both are same way to create primary key
create table emp_index
(
emp_id int primary key,
emp_name varchar2(10),
salary int
)
organization index;

insert into emp_index values (1,'Tushar', 10000);
insert into emp_index values (3,'Aman', 3000);
insert into emp_index values (2,'Jay', 4000);
insert into emp_index values (4,'Shubh', 5000);
insert into emp_index values (8,'Roy', 50000);
insert into emp_index values (6,'Hena', 6000);
commit;

select * from emp_index where emp_id=3 and salary=3000;

--NORMAL index ( non clustered index) --we can create non clustered index on multiple columns
create index idx_emp_name_salary on emp_index(emp_name,salary);
--drop index idx_emp_name_salary;
select * from dba_indexes where lower(table_name)='emp_index';

--NOTE: When you use index then your inserts will be slow
--to skip the slowness, we can drop the index and create again for every insert.
--Unique index will be little bit faster than non unique index since the value will not be duplicate in unique index so the index will search for only single time.
--press F10 on query to know explain pla, cost of execution with index

--Q. How to delete duplicates
create table emp_dup
(
emp_id int,
emp_name varchar2(20),
create_time timestamp
);


select * from emp_dup;
insert into emp_dup values(1,'Tushar',sysdate);
insert into emp_dup values(2,'Aman',sysdate);
insert into emp_dup values(3,'Jay',sysdate);
insert into emp_dup values(1,'Tushar',sysdate);
insert into emp_dup values(3,'Jay',sysdate);
insert into emp_dup values(1,'Tushar',sysdate);
commit;

delete from emp_dup where (emp_id, create_time) IN 
(
select emp_id, min(create_time) as create_time   --, count(emp_id)    --duplicate record
from emp_dup
group by emp_id --, emp_name
having count(emp_id)>1
)
;
rollback;

--Q. to keep the latest value and delete all the past multiple duplicates of a single value
delete from emp_dup where (emp_id, create_time) not in
(
select emp_id, max(create_time) as create_time
from emp_dup
group by emp_id
);
commit;


--TABLEAU
select category, sum(sales) from orders group by category;


select category, sub_category, sum(sales), sum(quantity) as qty
from orders
where region='East' and segment='Corporate'
group by category, sub_category
having sum(quantity) between 100 and 1000
order by qty desc;

select sub_category, region, sum(sales)
from orders
group by sub_category, region;

select extract(year from order_date), region, sum(sales) from orders group by extract(year from order_date), region order by extract(year from order_date), region;


--running sum
with A1 as
(
select extract(year from order_date), sum(sales) as sum_sales from orders group by extract(year from order_date)
)
select a.*, sum(a.sum_sales) over(order by a.sum_sales) from A1 a;


--JOINS

--cross join
--in cross join, no matter what columns you have within the two tables, it creates join and show all the columns in the output. It don't take common column just like other joins.
--there is no need of where clause.
--1.
select * from (
select * from employee where dept_id=100),
--no nomenclature is common between two tables
(select * from dept where dep_id between 100 and 500);

--2.
select * 
from employee, dept;    --cross join

--inner join
--it gives all the columns of both the tables but only for common matched condition
select * 
from employee e
inner join
dept d
on e.dept_id = d.dep_id;

--left outer join
--in left outer join, all the row values are taken from the left table and common row values are taken from the right table.
--so the row whch is present in right table but nnot present in left table will be null in output.
select *
from employee e
left outer join
dept d
on e.dept_id = d.dep_id;

--right outer join
--vice-versa of left outer join
select *
from employee e
right outer join
dept d
on e.dept_id = d.dep_id;

--full outer join
--it is the combination of both left and right oter join.
--if the columns are not matchinfg then null values will be there.
select *
from employee e
full outer join
dept d
on e.dept_id = d.dep_id;


--PROJECT 1 

select * from credit_card_transactions;

--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
select city, sum(amount) amt
from credit_card_transactions
group by city
order by amt desc;

--2- write a query to print highest spend month and amount spent in that month for each card type
with A1 as
(
select card_type, extract(year from transaction_date) as year, extract(month from transaction_date) as month, sum(amount)as sum_amount
from credit_card_transactions
group by card_type, extract(year from transaction_date), extract(month from transaction_date)
)
, B1 as
(
select a.*, dense_rank() over(partition by a.card_type order by a.sum_amount desc) as rank
from A1 a
)
select *
from B1
where rank = 1;

--3- write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
select * from credit_card_transactions;

select card_type, max(sum) from (
select s.*, sum(s.amount) over(partition by card_type order by s.amount asc) as sum
from credit_card_transactions s) group by card_type;


--4- write a query to find city which had lowest percentage spend for gold card type
select city, sum(amount) sm
from credit_card_transactions
where card_type='Gold'
group by city
order by sm;

with A1 as
(
select city, sum(amount) as sum_amt
from credit_card_transactions
where card_type='Gold'
group by city
)
, B1 as
(
select a.*, dense_rank() over(order by a.sum_amt) rnk
from A1 a
)
select * from B1 where rnk=1;

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with I1 as
(
select city,exp_type, sum(amount) am
from credit_card_transactions
group by city,exp_type
)
, A1 as
(
select city,max(am) max1,min(am) min1
from I1
group by city
)
select i.city
,case when i.am=a.max1 then i.exp_type end as highest
,case when i.am=a.min1 then i.exp_type end as lowest
from I1 i
inner join A1 a
on (i.city=a.city);
 
 
 
--6- write a query to find percentage contribution of spends by females for each expense type

select * from credit_card_transactions;





