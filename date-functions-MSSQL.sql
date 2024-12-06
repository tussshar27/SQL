use db_home;
-- datepart, dateadd, datediff
-- Abbreviations are same for all the three functions.
--instead of interval, we can also use abbreviations inside a function.
interval	Abbreviations
year		yy, yyyy
quarter		qq, q
month		mm, m
dayofyear	dy, y
day			dd, d
week		wk, ww
weekday		dw
hour		hh
minute		mi, n
second		ss, s

--1. datepart - what part of the date we required.
--syntax: datepart(interval, date)
select datepart(DAY,'2024-08-31')	--31
--to get the WEEK of the date
select datepart(WEEK,'2024-01-10')	--2th week of this year
--to get the WEEKDAY of the date
select datepart(WEEKDAY,'2024-08-31')	--7th day of week
--to get the month of the date
select datepart(MONTH,'2024-08-31')	--8
--to get the year of the date
select datepart(YEAR,'2024-08-31')	--2024
--to get the DAYOFYEAR of the date
select datepart(DAYOFYEAR,'2024-08-31')	--244
--to get the QUARTER of the date
select datepart(QUARTER,'2024-08-31')	--3
--to get the HOUR of the date
select datepart(HOUR,'2024-08-31 10:09:08')	--10	--for timestamp
--to get the MINUTE of the date
select datepart(MINUTE,'2024-08-31 10:09:08')	--0
--to get the SECOND of the date
select datepart(SECOND,'2024-08-31 10:09:08')	--0
--to get the full month name
SELECT FORMAT(cast('2024-02-09' as date), 'MMMM') AS MonthName;		--capital M, February
SELECT FORMAT(cast('2024-02-09' as date), 'yyyy') AS MonthName;		--2024
SELECT FORMAT(cast('2024-02-09' as date), 'dddd') AS MonthName;		--Friday
--DATENAME() is preferred instead of FORMAT().
--syntax: DATENAME(interval, date)
SELECT DATENAME(MONTH,cast('2024-02-09' as date)) AS MonthName;		--February
SELECT DATENAME(YEAR,cast('2024-02-09' as date)) AS MonthName;		--2024
SELECT DATENAME(DAY,cast('2024-02-09' as date)) AS MonthName;		--9
SELECT DATENAME(WEEKDAY,cast('2024-02-09' as date)) AS MonthName;		--Friday


--2. dateadd - to add interval on the date.
--syntax: dateadd(interval, increment, date)
select dateadd(day,5,'2024-08-05')	--2024-08-10 00:00:00.000	--adding five days
select dateadd(week,2,'2024-08-05')	--2024-08-19 00:00:00.000	--adding two weeks
select dateadd(month,2,'2024-08-05')	--2024-08-19 00:00:00.000	--adding two months
select dateadd(year,2,'2024-08-05')	--2026-08-05 00:00:00.000	--adding two years
select dateadd(yy,2,'2024-08-05')	--2026-08-05 00:00:00.000	--adding two years
select dateadd(weekday,5,'2024-08-05')	--2024-08-10 00:00:00.000	--adding five days 
select dateadd(hour,5,'2024-08-05')	--2024-08-05 05:00:00.000	--adding five hours 
select dateadd(minute,5,'2024-08-05')	--2024-08-05 00:05:00.000	--adding five minutes
--day and weekday both gives same result in dateadd


--3. datediff - to get the difference between two dates
select datediff(day,'2024-08-01','2024-08-10')	--9
select datediff(week,'2024-08-01','2024-08-10')	--1
select datediff(month,'2024-05-01','2024-08-10')--3
select datediff(year,'2020-08-01','2024-08-10')	--4
select datediff(weekday,'01-08-2020','10-08-2024')	--4

Example:
Orders table columns:
order_id, customer_id, order_date, ship_date, days_to_ship

Customers table columns:
customer_id, customer_name, gender, dob

1.Q) get the difference between both the dates
select *, datediff(day, order_date,ship_date) as days_to_ship from orders 

2.Q) how many business days it took to ship excluding saturdays and sundays
select *,
datediff(day,order_date,ship_date) as days_to_ship,
datediff(week,order_date,ship_date) as weeks_between_days,
datediff(day,order_date,ship_date) - 2 * datediff(week,order_date,ship_date) as business_days_to_ship
from orders;

3.Q) calculate the present age of the customer
select getdate();	--2024-08-31 19:45:50.360	--it gives current date and time.

select *, 
getdate(), 
datediff(year,dob,getdate()) as customer_age 
from customers;

4.Q) add business days to the current date excluding weekends

with A1 as (
select 
datediff(day,getdate(),'2024-09-30') as days_between,
2 * datediff(week,getdate(),'2024-09-30') as weekends
)
select getdate(), weekends,
dateadd(day,days_between + weekends,getdate()) as business_date
from A1;

--DATETIME2 is the newer type (introduced in SQL Server 2008) and is generally recommended for new applications due to its greater precision, smaller storage footprint, and a broader range of dates.

CREATE TABLE date_functions_demo (
    id INT ,
    start_date DATE,
    end_date DATE,
    created_at DATETIME2,
    updated_at DATETIME2,
 system_date varchar(10)
);

INSERT INTO date_functions_demo (id,start_date, end_date, created_at, updated_at,system_date) VALUES 
(1,'2024-01-01', '2024-12-31', '2024-01-01 10:00:00', '2024-12-31 23:59:59','12/30/2024'),
(2,'2023-06-15', '2024-06-15', '2023-06-15 08:30:00', '2024-06-15 17:45:00','08/15/2024'),
(3,'2022-05-20', '2023-05-20', '2022-05-20 12:15:00', '2023-05-20 18:00:00','10/21/2024');

select * from date_functions_demo;

--to get the current timestamp (date + time)
select getdate() as currentDateTime;	--2024-09-09 05:28:23.053

--to get the currnet date (excluding time)
select cast(getdate() as date) as currentDate;	--2024-09-09

--to get the current time (excluding date)
select cast(getdate() as time);		--05:29:00.0400000


select start_date, format(start_date,'dd/MM/yyyy') from date_functions_demo;	--NOTE: MM should always be in capital and dd, yyyy should always be in small letters.

select end_date,start_date from date_functions_demo;


