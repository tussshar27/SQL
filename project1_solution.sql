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






