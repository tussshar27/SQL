select * from credit_card_transactions;

select min(transaction_date), max(transaction_date) from credit_card_transactions;  --from 04-10-2013 to 26-05-2015

select distinct exp_type from credit_card_transactions;
/*
Bills
Food
Entertainment
Grocery
Fuel
Travel
*/

select distinct card_type from credit_card_transactions;
/*
Gold
Platinum
Silver
Signature
*/

select count(distinct city) from credit_card_transactions; --count 986

--1- write a query to print top 5 cities with highest spends 
--and their percentage contribution of total credit card spends 
with A1 as
(
select city, sum(amount) as total_spend
from credit_card_transactions
group by city
order by total_spend desc
--order by 2 desc
)
, B1 as 
(
select sum(amount) as total_amount from credit_card_transactions    --4074833373
)
select a.*,b.*, round((a.total_spend/b.total_amount)*100,4) as percentage_contribution  --if we get op as 0 that means its taking integer only of eg. 0.4; so multiply total_spend*1.0 to convert it in float or do apply cast function
from A1 a,B1 b      --cross join because B1 has only single value otherwise we have to use other join
--from A1 a inner join B1 b on 1=1      --same as above cross join
--also since there is no common column in B1 so there is no way to apply inner join in it.
order by a.total_spend desc 
fetch first 5 rows only;

--NOTE: CROSS JOIN: every row of table1 will join with every row of table2.
--suppose, table1:2rows, table2:10rows then 2*10=20rows in total after cross join.
--NOTE: bigint-64bit, int-32bit

--2- write a query to print highest spend month and amount spent in that month for each card type
with A1 as
(
select card_type, extract(year from transaction_date) year,extract(month from transaction_date) month, sum(amount) as total_spend
from credit_card_transactions
group by card_type,extract(year from transaction_date),extract(month from transaction_date)
)
, B1 as
(
select a.*, rank() over(partition by a.card_type order by a.total_spend desc) as rnk
from A1 a
)
select * from B1 where rnk = 1;


--3- write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1,000,000 total spends(We should have 4 rows in the o/p one for each card type)

select * from credit_card_transactions;

with A1 as
(
select c.*, sum(c.amount) over(partition by c.card_type order by c.transaction_date,c.transaction_id) amount_spend
from credit_card_transactions c
)
, B1 as
(
select a.* 
from A1 a 
where a.amount_spend > 1000000
)
select * from (
select b.*, rank() over(partition by card_type order by b.amount_spend) rnk
from B1 b
)
where rnk=1;

--4- write a query to find city which had lowest percentage spend for gold card type

with A1 as
(
select city, card_type, sum(amount) amount_spend
from credit_card_transactions
group by city, card_type
having card_type='Gold'
)
, B1 as
(
select sum(amount) total_amount
from credit_card_transactions
group by card_type 
having card_type='Gold'
)
select * from (
select a.*,b.*, round((a.amount_spend/b.total_amount)*100,6) percentage_spend
from A1 a, B1 b
order by a.amount_spend
)
where rownum=1;

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with A1 as
(
select city, exp_type, sum(amount) amount_spend
from credit_card_transactions
group by city, exp_type
)
, B1 as
(
select a.*
, rank() over(partition by a.city order by a.amount_spend) asc_rnk
, rank() over(partition by a.city order by a.amount_spend desc) desc_rnk
from A1 a
)
select c.city
, max(case when asc_rnk=1 then exp_type end) as lowest_expense_type     --bydefault it will give else values as null
, max(case when desc_rnk=1 then exp_type end) as highest_expense_type   --bydefault it will give else values as null
from
(
select b.*
from B1 b
where asc_rnk=1 or desc_rnk=1
) c
group by c.city
;

--6- write a query to find percentage contribution of spends by females for each expense type
with A1 as
(
select exp_type, gender, sum(amount) amount_spend
from credit_card_transactions
group by exp_type, gender
having gender='F'
)
, B1 as
(
select exp_type, sum(amount) total_amount
from credit_card_transactions
group by exp_type
)
select a.*, b.total_amount,round((a.amount_spend/b.total_amount)*100,4) as percentage_contribution
from A1 a
inner join B1 b
on (a.exp_type=b.exp_type);


--7- which card and expense type combination saw highest month over month percent growth in Jan-2014
with A1 as
(
select card_type, exp_type, extract(year from transaction_date) year, extract(month from transaction_date) month, sum(amount) total_amount
from credit_card_transactions
group by card_type, exp_type, extract(year from transaction_date), extract(month from transaction_date)
)
, B1 as
(
select a.*, lag(a.total_amount,1) over(partition by a.card_type, a.exp_type order by a.year, a.month) prev_month_spend
from A1 a
)
select b.*, round((b.total_amount-b.prev_month_spend)/b.prev_month_spend,4) as month_on_month_growth
from B1 b
where b.year=2014 and b.month=1
order by (b.total_amount-b.prev_month_spend)/b.prev_month_spend desc
fetch first 1 row only;


--8- during weekends which city has highest total spend to total no of transcations ratio 
select b.*, (b.total_spend/b.total_transaction) ratio from (
select city, count(transaction_date) total_transaction, sum(amount) total_spend
from credit_card_transactions
where to_char(to_date(transaction_date,'DD-MM-YYYY'),'D') in (1,7)
group by city
) b
order by ratio desc
fetch first 1 row only;


--select to_char(date '1998-03-27','DAY') from dual;

--9- which city took least number of days to reach its 500th transaction after the first transaction in that city
select e.*, (e.target_trans-e.first_trans) trans from (
select city, min(transaction_date) first_trans, max(transaction_date) target_trans from
(
select d.*
from (
select c.*, row_number() over(partition by c.city order by c.transaction_date, c.transaction_id) rn
from credit_card_transactions c
) d
where d.rn=1 or d.rn=500
)
group by city
having count(*)=2
) e
order by trans
fetch first 1 row only
;

--above query written using CTE
with A1 as
(
select c.*, row_number() over(partition by c.city order by c.transaction_date, c.transaction_id) rn
from credit_card_transactions c
)
, B1 as
(
select * from A1 
where rn=1 or rn=500
)
, C1 as
(
select city, min(transaction_date) first_trans, max(transaction_date) target_trans 
from B1
group by city
having count(*)=2
)
select c.*, (c.target_trans-c.first_trans) trans from C1 c
order by trans
fetch first 1 row only
;



--SOLVE QUESTIONS OF ASSIGNMENT, DATALEMUR AND ANKIT BANSAL'S SQL 50 QUESTIONS PLAYLIST TO CRACK ANY COMPANY INTERVIEW WHETHER THAT BE MICROSOFT, GOOGLE, AMAZON, ETC.
