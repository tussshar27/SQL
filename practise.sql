`--NOTE: CASE statement is used to split the values into multiple columns

--video 1
--Q. find win and loss teams
--NOTE: first we have to calculate wins of teams then we can get the total count and losses.

SELECT * FROM icc_world_cup;

with A1 as(
select team_1 as team_name, case when team_1=winner then 1 else 0 end as win_flag from icc_world_cup
union all
select team_2, case when team_2=winner then 1 else 0 end as win_flag from icc_world_cup
)
select team_name, count(*) as matches_played, sum(win_flag) as win, count(*)-sum(win_flag) as loss from A1
group by team_name;

--video 2
--Q. find new and repeat customers count
create table customer_ordersinsert into users values(
order_id integer,
customer_id integer,
order_date date,
order_amount integer
,'yyyy-mm-dd');
insert into customer_orders values(1,100,to_date('2022-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2000,'yyyy-mm-dd');;
insert into customer_orders values(2,200,to_date('2022-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2500,'yyyy-mm-dd');;
insert into customer_orders values(3,300,to_date('2022-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2100,'yyyy-mm-dd');;
insert into customer_orders values(4,100,to_date('2022-01-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2000,'yyyy-mm-dd');;
insert into customer_orders values(5,400,to_date('2022-01-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2200,'yyyy-mm-dd');;
insert into customer_orders values(6,500,to_date('2022-01-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2700,'yyyy-mm-dd');;
insert into customer_orders values(7,100,to_date('2022-01-03','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),3000,'yyyy-mm-dd');;
insert into customer_orders values(8,400,to_date('2022-01-03','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),1000,'yyyy-mm-dd');;
insert into customer_orders values(9,600,to_date('2022-01-03','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),3000,'yyyy-mm-dd');;
commit;
SELECT * FROM customer_orders;

--first find the min order date for each customerid then we can compare it to get the solution.
--NOTE: whenever aggregate solution is asked then it needs a AGGREGATE CASE statement in it.
with A1 asinsert into users values(
SELECT 
customer_id, min(order_date) min_order_date
FROM customer_orders 
group by customer_id
)
, B1 asinsert into users values(
select co.*, a.min_order_date 
from customer_orders co 
inner join A1 a 
on a.customer_id=co.customer_id
)
select order_date
,sum(case when order_date=min_order_date then 1 else 0 end) as new_customer
,sum(case when order_date!=min_order_date then 1 else 0 end) as old_customer
,sum(case when order_date=min_order_date then order_amount end) as order_amount_of_new_cust
,sum(case when order_date!=min_order_date then order_amount end) as order_amount_of_old_cust
from B1 
group by order_date;

--video 3
--Q. find the most number of floor visits
create table entriesinsert into users values( 
name varchar(20,'yyyy-mm-dd');,
address varchar(20,'yyyy-mm-dd');,
email varchar(20,'yyyy-mm-dd');,
floor int,
resources varchar(10,'yyyy-mm-dd');,'yyyy-mm-dd');

insert into entries valuesinsert into users values('A','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('A@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),1,to_date('CPU','yyyy-mm-dd'),'yyyy-mm-dd');
insert into entries valuesinsert into users values('A','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('A1@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),1,to_date('CPU','yyyy-mm-dd'),'yyyy-mm-dd');
insert into entries valuesinsert into users values('A','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('A2@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),2,to_date('DESKTOP','yyyy-mm-dd'),'yyyy-mm-dd');
insert into entries valuesinsert into users values('B','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('B@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),2,to_date('DESKTOP','yyyy-mm-dd'),'yyyy-mm-dd');
insert into entries valuesinsert into users values('B','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('B1@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),2,to_date('DESKTOP','yyyy-mm-dd'),'yyyy-mm-dd');
insert into entries valuesinsert into users values('B','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('Bangalore','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('B2@gmail.com','yyyy-mm-dd'),'yyyy-mm-dd'),1,to_date('MONITOR','yyyy-mm-dd'),'yyyy-mm-dd');
commit;
SELECT * FROM entries;

with A1 asinsert into users values(
select 
name
,count(1) as total_visits
,listagg(distinct resources,to_date(','yyyy-mm-dd'),'yyyy-mm-dd'),to_date(') as resources_used
from entries
group by name
)
, B1 asinsert into users values(
select * frominsert into users values(
select 
name, floor, count(1) max_visits, rank() over(partition by name order by count(1) desc) as rnk
from entries
group by name, floor
) where rnk = 1
)
select 
a.name, a.total_visits, a.resources_used, b.floor most_visited_floor, b.max_visits
from A1 a inner join B1 b
on a.name = b.name;

--video 4
--Q. date question

--video 5
--Q. Pareto principleinsert into users values(80/20 Rule) means 80% of consequences comes from 20% of causes.
with A1 asinsert into users values(
select sum(sales) * 0.8 as req_sum from orders    --1837760.688
)
, B1 asinsert into users values(
select ab.*, sum(ab.product_sales) over(order by ab.product_sales desc) as roll_sum frominsert into users values(
select 
product_id, sum(sales) product_sales
from orders
group by product_id
order by product_sales desc
) ab
)
select * from B1,A1 where B1.roll_sum <= A1.req_sum;

selectinsert into users values(413*1.0 / 1862) * 100 from dual;    --its close to 22%

--video 6
--Q. find the sum of friends score which is greater than 100.

select * from friend;
select * from person;

with A1 asinsert into users values(
select f.personid, count(f.friendid) sum_of_friends, sum(p.score) as total_friend_score
from person p
inner join friend f
on f.friendid=p.personid    --getting all the friend details
group by f.personid
having sum(p.score) > 100
)
select a.personid, pe.name, max(a.sum_of_friends) no_of_friends, sum(a.total_friend_score) total_friend_score
from person pe inner join A1 a 
on pe.personid=a.personid 
group by a.personid, pe.name;

--video 7
Create table  Tripsinsert into users values(id int, client_id int, driver_id int, city_id int, status varchar(50,'yyyy-mm-dd');, request_at varchar(50,'yyyy-mm-dd');,'yyyy-mm-dd');
Create table Usersinsert into users values(users_id int, banned varchar(50,'yyyy-mm-dd');, role varchar(50,'yyyy-mm-dd');,'yyyy-mm-dd');
Truncate table Trips;
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('1','yyyy-mm-dd'),'yyyy-mm-dd'), '1','yyyy-mm-dd'),'yyyy-mm-dd'), '10','yyyy-mm-dd'),'yyyy-mm-dd'), '1','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-01','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('2','yyyy-mm-dd'),'yyyy-mm-dd'), '2','yyyy-mm-dd'),'yyyy-mm-dd'), '11','yyyy-mm-dd'),'yyyy-mm-dd'), '1','yyyy-mm-dd'),'yyyy-mm-dd'), 'cancelled_by_driver','yyyy-mm-dd'),'yyyy-mm-dd'), '2013-10-01','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('3','yyyy-mm-dd'),'yyyy-mm-dd'), '3','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), '6','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-01','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('4','yyyy-mm-dd'),'yyyy-mm-dd'), '4','yyyy-mm-dd'),'yyyy-mm-dd'), '13','yyyy-mm-dd'),'yyyy-mm-dd'), '6','yyyy-mm-dd'),'yyyy-mm-dd'), 'cancelled_by_client','yyyy-mm-dd'),'yyyy-mm-dd'), '2013-10-01','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('5','yyyy-mm-dd'),'yyyy-mm-dd'), '1','yyyy-mm-dd'),'yyyy-mm-dd'), '10','yyyy-mm-dd'),'yyyy-mm-dd'), '1','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-02','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('6','yyyy-mm-dd'),'yyyy-mm-dd'), '2','yyyy-mm-dd'),'yyyy-mm-dd'), '11','yyyy-mm-dd'),'yyyy-mm-dd'), '6','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-02','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('7','yyyy-mm-dd'),'yyyy-mm-dd'), '3','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), '6','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-02','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('8','yyyy-mm-dd'),'yyyy-mm-dd'), '2','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-03','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('9','yyyy-mm-dd'),'yyyy-mm-dd'), '3','yyyy-mm-dd'),'yyyy-mm-dd'), '10','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), 'completed',to_date('yyyy-mm-dd'), '2013-10-03','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Tripsinsert into users values(id, client_id, driver_id, city_id, status, request_at) valuesinsert into users values('10','yyyy-mm-dd'),'yyyy-mm-dd'), '4','yyyy-mm-dd'),'yyyy-mm-dd'), '13','yyyy-mm-dd'),'yyyy-mm-dd'), '12','yyyy-mm-dd'),'yyyy-mm-dd'), 'cancelled_by_driver','yyyy-mm-dd'),'yyyy-mm-dd'), '2013-10-03','yyyy-mm-dd'),'yyyy-mm-dd');
Truncate table Users;
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('1','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'client','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('2','yyyy-mm-dd'),'yyyy-mm-dd'), 'Yes','yyyy-mm-dd'),'yyyy-mm-dd'), 'client','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('3','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'client','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('4','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'client','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('10','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'driver','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('11','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'driver','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('12','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'driver','yyyy-mm-dd'),'yyyy-mm-dd');
insert into Usersinsert into users values(users_id, banned, role) valuesinsert into users values('13','yyyy-mm-dd'),'yyyy-mm-dd'), 'No','yyyy-mm-dd'),'yyyy-mm-dd'), 'driver','yyyy-mm-dd'),'yyyy-mm-dd');
commit;

--Q. find cancellation rate of requests with unbanned users(client and driver) for each date. round it to two decimal.
--the cancellation rate is computed by dividing the number of cancelled requests with unbanned users by the total number of requests with unbanned users on that day.
select * from trips;
select * from users;

select t.request_at,
count(case when status ininsert into users values('cancelled_by_client','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('cancelled_by_driver') then 1 else null end) as cancelled_count
,count(1) as total_trips
,round((1.0 * count(case when status ininsert into users values('cancelled_by_client','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('cancelled_by_driver') then 1 else null end) / count(1)) * 100, 2) as cancelled_percent
from trips t
inner join users c on t.client_id = c.users_id  --connecting client column
inner join users d on t.driver_id = d.users_id  --connecting driver column
where c.banned='No' and d.banned='No'
group by t.request_at;

--video 8   --leetcode hard
create table players
(player_id int,
group_id int,'yyyy-mm-dd');

insert into players valuesinsert into users values(15,1,'yyyy-mm-dd');
insert into players valuesinsert into users values(25,1,'yyyy-mm-dd');
insert into players valuesinsert into users values(30,1,'yyyy-mm-dd');
insert into players valuesinsert into users values(45,1,'yyyy-mm-dd');
insert into players valuesinsert into users values(10,2,'yyyy-mm-dd');
insert into players valuesinsert into users values(35,2,'yyyy-mm-dd');
insert into players valuesinsert into users values(50,2,'yyyy-mm-dd');
insert into players valuesinsert into users values(20,3,'yyyy-mm-dd');
insert into players valuesinsert into users values(40,3,'yyyy-mm-dd');

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int,'yyyy-mm-dd');

insert into matches valuesinsert into users values(1,15,45,3,0,'yyyy-mm-dd');;
insert into matches valuesinsert into users values(2,30,25,1,2,'yyyy-mm-dd');
insert into matches valuesinsert into users values(3,30,15,2,0,'yyyy-mm-dd');;
insert into matches valuesinsert into users values(4,40,20,5,2,'yyyy-mm-dd');
insert into matches valuesinsert into users values(5,35,50,1,1,'yyyy-mm-dd');
commit;

--Q. find the winner who scored max in each group, in case of tie then take score with lowest player id.
SELECT * FROM players;
SELECT * FROM matches;

with A1 asinsert into users values(
select player_id, sum(score) sum_of_score frominsert into users values(
select first_player as player_id, first_score as score from matches
union all
select second_player as player_id, second_score as score from matches
)
group by player_id
)
, B1 asinsert into users values(
select p.group_id, a.player_id, a.sum_of_score
,rank() over(partition by p.group_id order by a.sum_of_score desc, a.player_id asc) rnk
from A1 a
inner join players p
on a.player_id=p.player_id
)
select * from B1 where rnk = 1;

-- video 9
--Q. find for each seller whether the brand of 2nd item sold by date is their favourite or not.
--if there is no 2nd item then put No.
create table users2insert into users values(
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50,'yyyy-mm-dd');,'yyyy-mm-dd');

 create table orders2insert into users values(
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 ,'yyyy-mm-dd');

 create table items2
insert into users values(
 item_id        int     ,
 item_brand     varchar(50,'yyyy-mm-dd');
 ,'yyyy-mm-dd');

 insert into users2 valuesinsert into users values(1,to_date('2019-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('Lenovo','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into users2 valuesinsert into users values(2,to_date('2019-02-09','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('Samsung','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into users2 valuesinsert into users values(3,to_date('2019-01-19','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('LG','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into users2 valuesinsert into users values(4,to_date('2019-05-21','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('HP','yyyy-mm-dd'),'yyyy-mm-dd');

 insert into items2 valuesinsert into users values(1,to_date('Samsung','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into items2 valuesinsert into users values(2,to_date('Lenovo','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into items2 valuesinsert into users values(3,to_date('LG','yyyy-mm-dd'),'yyyy-mm-dd');
 insert into items2 valuesinsert into users values(4,to_date('HP','yyyy-mm-dd'),'yyyy-mm-dd');

 insert into orders2 valuesinsert into users values(1,to_date('2019-08-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),4,1,2,'yyyy-mm-dd');
 insert into orders2 valuesinsert into users values(2,to_date('2019-08-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2,1,3,'yyyy-mm-dd');
 insert into orders2 valuesinsert into users values(3,to_date('2019-08-03','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),3,2,3,'yyyy-mm-dd');
 insert into orders2 valuesinsert into users values(4,to_date('2019-08-04','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),1,4,2,'yyyy-mm-dd');
 insert into orders2 valuesinsert into users values(5,to_date('2019-08-04','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),1,3,4,'yyyy-mm-dd');
 insert into orders2 valuesinsert into users values(6,to_date('2019-08-05','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),2,2,4,'yyyy-mm-dd');
commit;
select * from users2;
select * from items2;
select * from orders2;

--first we have to take only the second records and then apply join over it.
--NOTE: we have taken right join in order to include all the records form users2 table.
with A1 asinsert into users values(
select a.* frominsert into users values(
select b.* 
, rank() over(partition by b.seller_id order by b.order_date asc) as rnk
from orders2 b
)a
where a.rnk = 2
)
select --ab.*, it.item_brand, us.favorite_brand, 
us.user_id as seller_id
, case when it.item_brand = us.favorite_brand then 'Yes' else 'No' end as second_item_fav_brand
from A1 ab 
inner join items2 it on ab.item_id=it.item_id
right join users2 us on ab.seller_id=us.user_id
order by us.user_id;


--video 10
--Q.
--NOT SOLVED
create table tasksinsert into users values(
date_value date,
state varchar(10,'yyyy-mm-dd');
,'yyyy-mm-dd');

insert into tasks  valuesinsert into users values(to_date('2019-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('success','yyyy-mm-dd'),'yyyy-mm-dd');
insert into tasks  valuesinsert into users values(to_date('2019-01-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('success','yyyy-mm-dd'),'yyyy-mm-dd');
insert into tasks  valuesinsert into users values(to_date('2019-01-03','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('success','yyyy-mm-dd'),'yyyy-mm-dd');
insert into tasks  valuesinsert into users values(to_date('2019-01-04','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('fail','yyyy-mm-dd'),'yyyy-mm-dd');
insert into tasks  valuesinsert into users values(to_date('2019-01-05','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('fail','yyyy-mm-dd'),'yyyy-mm-dd');
insert into tasks  valuesinsert into users values(to_date('2019-01-06','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('success','yyyy-mm-dd'),'yyyy-mm-dd');
commit;

SELECT * FROM tasks;


SELECT t.*
, row_number() over(partition by t.state order by t.date_value) rn
,add_months(date_value,2)
FROM tasks t
order by date_value;
--add_days function is not available in oracle.


--video 10
--Q. 
--add_days() not supported in oracle to add date to existing date.
select * from tasks;

--video 11
--Q./* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
--and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
--and both mobile and desktop together for each date.
*/

create table spending 
(
user_id int,
spend_date date,
platform varchar(10,'yyyy-mm-dd');,
amount int
,'yyyy-mm-dd');

insert into spending values(1,to_date('2019-07-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('mobile','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into spending values(1,to_date('2019-07-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('desktop','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into spending values(2,to_date('2019-07-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('mobile','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into spending values(2,to_date('2019-07-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('mobile','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into spending values(3,to_date('2019-07-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('desktop','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into spending values(3,to_date('2019-07-02','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('desktop','yyyy-mm-dd'),'yyyy-mm-dd'),100,'yyyy-mm-dd');;
commit;

SELECT * FROM spending;

select
spend_date
, 'both' as platform
,sum(amount) as total_amount
,count(distinct user_id) as total_users
from spending
group by spend_date, user_id
having count(distinct platform) = 2

union all

select
spend_date
,max(platform) as platform
,sum(amount) as total_amount
,count(distinct user_id) as total_users
from spending
group by spend_date, user_id
having count(distinct platform) = 1

union all

select 
distinct spend_date
,to_date('both' as platform
,0 as total_amount
,null as total_users
from spending
order by spend_date         --order by clause should be mentioned in last query of union all queries.
;

--video 12
-- recursive CTE
--NOT SOLVED
with A1insert into users values(num) as 
(
    select 1 as num from dual   -- anchor query
    
    union all
    
    select num + 1      -- recursive query
    from A1
    where num < 7       -- filter to stop the recursion
    
)
select num from A1;
/*
anchor: 1
num=1, 2
num=2, 3
.
.
.
num=5, 6
*/

create table salesinsert into users values(
product_id int,
period_start date,
period_end date,
average_daily_sales int
,'yyyy-mm-dd');

insert into sales values(1,to_date('2019-01-25','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date('2019-02-28','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),100,'yyyy-mm-dd');;
insert into sales values(2,to_date('2018-12-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date(to_date('2020-01-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),10,'yyyy-mm-dd');;
insert into sales values(3,to_date('2019-12-01','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),to_date(to_date('2020-01-31','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('yyyy-mm-dd'),1,'yyyy-mm-dd');
commit;

--COPIED FROM YOUTUBE COMMENT
with d_datesinsert into users values(dates,max_dates)
as
(
select min(period_start) 'mm-dd-yy's, max(period_end) as max_dates  from sales
union all
select dates+1 'mm-dd-yy's,max_dates from d_dates
where dates<max_dates
) --select * from d_dates;
select s.product_id, extract(year from dates) report_year,sum(s.average_daily_sales) as tot_amt
from d_dates dd
inner join sales s 
on dates between s.period_start and s.period_end
group by s.product_id, extract(year from dates)
order by  s.product_id, extract(year from dates,'yyyy-mm-dd');

--video 13
--Q. which item pair of 2 are bought the most from website.
drop table orders;

create table orders
(
order_id int,
customer_id int,
product_id int
,'yyyy-mm-dd');
insert into orders VALUES(1, 1, 1,'yyyy-mm-dd');
insert into orders VALUES(1, 1, 2,'yyyy-mm-dd');
insert into orders VALUES(1, 1, 3,'yyyy-mm-dd');
insert into orders VALUES(2, 2, 1,'yyyy-mm-dd');
insert into orders VALUES(2, 2, 2,'yyyy-mm-dd');
insert into orders VALUES(2, 2, 4,'yyyy-mm-dd');
insert into orders VALUES(3, 1, 5,'yyyy-mm-dd');
commit;

create table productsinsert into users values(
id int,
name varchar(10,'yyyy-mm-dd');
,'yyyy-mm-dd');
insert into products VALUES(1, 'A','yyyy-mm-dd'),'yyyy-mm-dd');
insert into products VALUES(2, 'B','yyyy-mm-dd'),'yyyy-mm-dd');
insert into products VALUES(3, 'C','yyyy-mm-dd'),'yyyy-mm-dd');
insert into products VALUES(4, 'D','yyyy-mm-dd'),'yyyy-mm-dd');
insert into products VALUES(5, 'E','yyyy-mm-dd'),'yyyy-mm-dd');
commit;

SELECT * FROM orders;
SELECT * FROM products;

--we are doing self-join since we need pair of items from same order id.
with A1 as 
(
select o.*, p.name
from orders o inner join products p on o.product_id = p.id
)
select --a.order_id, a.customer_id, 
a.name ||' ,to_date('|| b.name as pair, count(1) as pair_purchase_freq
from A1 a inner join A1 b on a.order_id = b.order_id 
where --a.order_id = 1 and                  --we first run it for order_id=1 in order to get the idea of dataafter applying below filter as well.
a.product_id != b.product_id and a.product_id > b.product_id    --removing duplicates
group by a.name, b.name
;


--video 14
--Q. prime subscription rate by product action.
--Q. find users who have upgraded to prime membership from amazon music within 30 days of signing up.
drop table users;
create table users
(
user_id integer,
name varchar(20,'yyyy-mm-dd');,
join_date date
,'yyyy-mm-dd');
insert into users values(1, 'Jon','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-14-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd'); 
insert into users values(2, 'Jane','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-14-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd');
insert into users values(3, 'Jill','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-15-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd'); 
insert into users values(4, 'Josh','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-15-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd'); 
insert into users values(5, 'Jean','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-16-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd'); 
insert into users values(6, 'Justin','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-17-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd');
insert into users values(7, 'Jeremy','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('2-18-20','yyyy-mm-dd'),'yyyy-mm-dd'), 'mm-dd-yy'),'yyyy-mm-dd');
commit;

create table events
(
user_id integer,
type varchar(10,'yyyy-mm-dd');,
access_date date
,'yyyy-mm-dd');

insert into events values(1, 'Pay','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-1-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd'); 
insert into events values(2, 'Music','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-2-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd'); 
insert into events values(2, 'P','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-12-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd');
insert into events values(3, 'Music','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-15-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd'); 
insert into events values(4, 'Music','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-15-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd'); 
insert into events values(1, 'P','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-16-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd'); 
insert into events values(3, 'P','yyyy-mm-dd'),'yyyy-mm-dd'), to_date('3-22-20' ,to_date('mm-dd-yy'),'yyyy-mm-dd');
commit;

select * from users;
select * from events;

with A1 as
(
select u.*, e.type, e.access_date
from users u inner join events e on u.user_id = e.user_id
)
,B1 as
(
select 
a.user_id, a.name, a.join_date, a.type, b.type, b.access_date, to_date(b.access_date,to_date('dd-mm-yyyy')-to_date(a.join_date,to_date('dd-mm-yyyy') as date_diff 
from A1 a left join A1 b on a.user_id = b.user_id and b.type = 'P' --considering left table for music and right table for P 
where a.type = 'Music'     -- chronolgy: where -> join condition -> select
)
select * from B1;


with A1 as
(
select u.*, e.type, e.access_date
from users u inner join events e on u.user_id = e.user_id
)
,B1 as
(
select 
a.user_id, a.name, a.join_date, a.type as type1, b.type as type2, b.access_date, to_date(b.access_date,to_date('dd-mm-yyyy')-to_date(a.join_date,to_date('dd-mm-yyyy') as date_diff 
from A1 a left join A1 b on a.user_id = b.user_id and b.type = 'P' 
where a.type = 'Music'    
)
, C1 as
(
select count(distinct user_id) as total_users, count(case when date_diff < 30 then 1 end) as within_month from B1
)
select within_month, total_users, round(1.0*within_month/total_users,4)*100 as perc_users from C1;

--video 15
--Q. find customer retention and customer churn metrics
--customer retention means repeat buyers and customer churn means the opposite of it.
--SKIPPED QUESTION, NEED TO SOLVE
create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
,'yyyy-mm-dd');

insert into transactions values (1,1,to_date(to_date('2020-01-15','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (2,1,to_date(to_date('2020-02-10','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (3,2,to_date(to_date('2020-01-16','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (4,2,to_date(to_date('2020-02-25','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (5,3,to_date(to_date('2020-01-10','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (6,3,to_date(to_date('2020-02-20','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (7,4,to_date(to_date('2020-01-20','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
insert into transactions values (8,5,to_date(to_date('2020-02-20','yyyy-mm-dd'),'yyyy-mm-dd'),150,'yyyy-mm-dd');
commit;
--retention as per month:
--since jan is first month so there will be 0 retention.

--month - cust_id -> count
--jan - 0 -> 0 count
--feb - 1 , 2 , 3 -> 3 counts
select * from transactions;

select last_month.cust_id, extract(month from last_month.order_date) - extract(month from this_month.order_date) --extract(month from this_month.order_date) as month_date, count(distinct last_month.cust_id) as count
from transactions this_month
left join transactions last_month 
on this_month.cust_id = last_month.cust_id and (extract(month from last_month.order_date) - extract(month from this_month.order_date)) = 1;
group by extract(month from this_month.order_date,'yyyy-mm-dd');


select *
from transactions this_month
inner join transactions last_month
on this_month.cust_id = last_month.cust_id
;


--video 16
--SKIPPED QUESTION, NEED TO SOLVE


--video 17
--Q. Get the second most recent activity. and if there is only one activity then return that.
create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values ('Alice','yyyy-mm-dd'),'Travel',to_date('2020-02-12','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('2020-02-20','yyyy-mm-dd'),'yyyy-mm-dd'));
insert into UserActivity values ('Alice','yyyy-mm-dd'),'Dancing',to_date('2020-02-21','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('2020-02-23','yyyy-mm-dd'),'yyyy-mm-dd'));
insert into UserActivity values ('Alice','yyyy-mm-dd'),'Travel',to_date('2020-02-24','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('2020-02-28','yyyy-mm-dd'),'yyyy-mm-dd'));
insert into UserActivity values ('Bob','yyyy-mm-dd'),'Travel',to_date('2020-02-11','yyyy-mm-dd'),'yyyy-mm-dd'),to_date('2020-02-18','yyyy-mm-dd'),'yyyy-mm-dd'));
commit;

select * from UserActivity;

with A1 as
(
select u.*,
count(1) over(partition by u.username) as total_count
, rank() over(partition by u.username order by u.startdate) as rnk
from UserActivity u
)
select * from A1 where (total_count = 1 and rnk = 1) or rnk = 2;

--video 18
--Q. to find billiing amount by bill_hrs and bill_rate till a particular date
create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);

insert into billings values('Sachin',to_date('01-JAN-1990','yyyy-mm-dd'),'dd-mon-yyyy'),25);
insert into billings values('Sehwag',to_date('01-JAN-1989','yyyy-mm-dd'),'dd-mon-yyyy'), 15);
insert into billings values('Dhoni',to_date('01-JAN-1989','yyyy-mm-dd'),'dd-mon-yyyy'), 20);
insert into billings values('Sachin',to_date('05-Feb-1991','yyyy-mm-dd'),'dd-mon-yyyy'), 30);

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values('Sachin',to_date('01-JUL-1990','yyyy-mm-dd'),'dd-mon-yyyy') ,3);
insert into HoursWorked values ('Sachin', to_date('01-AUG-1990','yyyy-mm-dd'),'dd-mon-yyyy'), 5);
insert into HoursWorked values ('Sehwag',to_date('01-JUL-1990','yyyy-mm-dd'),'dd-mon-yyyy'), 2);
insert into HoursWorked values ('Sachin',to_date('01-JUL-1991','yyyy-mm-dd'),'dd-mon-yyyy'), 4);
commit;

select * from billings;
select * from HoursWorked;

with A1 as (
select b.*
,lead(b.bill_date,1,to_date('9999-12-31','yyyy-mm-dd'),'yyyy-mm-dd')) over(partition by b.emp_name order by b.bill_date) as lead_date
from billings b
)
select h.emp_name, sum(h.bill_hrs * a.bill_rate)
from hoursworked h
inner join A1 a
on h.emp_name=a.emp_name and work_date between bill_date and lead_date
group by h.emp_name;


--video 19
--Q. spotify case study
CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed',to_date('2022-01-01','yyyy-mm-dd'),'India');
insert into activity values (1,'app-purchase',to_date('2022-01-02','yyyy-mm-dd'),'India');
insert into activity values (2,'app-installed',to_date('2022-01-01','yyyy-mm-dd'),'USA');
insert into activity values (3,'app-installed',to_date('2022-01-01','yyyy-mm-dd'),'USA');
insert into activity values (3,'app-purchase',to_date('2022-01-03','yyyy-mm-dd'),'USA');
insert into activity values (4,'app-installed',to_date('2022-01-03','yyyy-mm-dd'),'India');
insert into activity values (4,'app-purchase',to_date('2022-01-03','yyyy-mm-dd'),'India');
insert into activity values (5,'app-installed',to_date('2022-01-03','yyyy-mm-dd'),'SL');
insert into activity values (5,'app-purchase',to_date('2022-01-03','yyyy-mm-dd'),'SL');
insert into activity values (6,'app-installed',to_date('2022-01-04','yyyy-mm-dd'),'Pakistan');
insert into activity values (6,'app-purchase',to_date('2022-01-04','yyyy-mm-dd'),'Pakistan');
commit;

select * from activity;

--Q1. find total activity users for each day.
select event_date, count(distinct user_id) as total_active_users 
from activity
group by event_date;

--Q2. find total activity users for week. --NEED TO WORK
select a.*, to_char(to_date(a.event_date,'dd-mm-yyyy'),'WW') as week
from activity a;

select 
*
,to_char(to_date('31-12-2024','dd-mm-yyyy'),'WW')
--,to_char(to_date('31-12-2024','dd-mm-yyyy'),'IW')
from dual;


--Q3.find date wise total no. of users who made the purchase on same day the day they installed the app.

with A1 as (
select event_date, count(user_id) as total_users from
(
select event_date, user_id, count(distinct event_name)
from activity
group by event_date, user_id
having count(distinct event_name) = 2
)
group by event_date
)
select ac.event_date,max(a.total_users) as no_of_users
from activity ac
left join A1 a 
on ac.event_date=a.event_date
group by ac.event_date
order by ac.event_date;

--without using join
select event_date, count(new_user) as total_users from
(
select event_date, user_id, case when count(distinct event_name)=2 then user_id else null end as new_user
from activity
group by event_date, user_id
)
group by event_date
;

--Q4. find percentage of paid users in India, USA and any other country should be tagged as others.
with A1 as (
select case when country in ('India','USA') then country else 'others' end as new_country, count(distinct user_id) as no_of_users
from activity
where event_name='app-purchase'
group by case when country in ('India','USA') then country else 'others' end 
)
, B1 as (
select sum(no_of_users) as total_users
from A1
)
select new_country, (min(no_of_users)/max(total_users))*100 as percentage_users
from A1, B1
group by new_country
;

--IMP
--Q5. among all the users who installed the app on a given day, how many did in app purchase on the very next day.
select 
b.event_date
, count(case when (b.event_date-b.lag_date)=1 and b.event_name='app-purchase' and b.lag_event_name='app-installed' then user_id else null end) as user_count
--b.event_date, count(case when (b.event_date-b.lag_date)=1 then b.user_id else null end) as user_count 
from (
select a.*
, lag(a.event_date,1,a.event_date) over(partition by a.user_id order by a.event_date) as lag_date 
, lag(a.event_name,1,a.event_name) over(partition by a.user_id order by a.event_date) as lag_event_name 
from activity a
) b
group by b.event_date
;

--Q20. to find 3 or more consecutive seats.
-- using 3 methods:
--1. lead,lag
--2. advance aggregation
--3. analytical row number function

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values(1,'N');
insert into bms values(2,'Y');
insert into bms values(3,'N');
insert into bms values(4,'Y');
insert into bms values(5,'Y');
insert into bms values(6,'Y');
insert into bms values(7,'N');
insert into bms values(8,'Y');
insert into bms values(9,'Y');
insert into bms values(10,'Y');
insert into bms values(11,'Y');
insert into bms values(12,'N');
insert into bms values(13,'Y');
insert into bms values(14,'Y');
commit;

--method 1
with A1 as (
select b.*
, lag(b.is_empty,1) over(order by b.seat_no) as  lag_1
, lag(b.is_empty,2) over(order by b.seat_no) as  lag_2
, lead(b.is_empty,1) over(order by b.seat_no) as  lead_1
, lead(b.is_empty,2) over(order by b.seat_no) as  lead_2
from bms b
)
select *
from A1
where (is_empty='Y' and lead_1='Y' and lead_2='Y') or (lag_1='Y' and is_empty='Y' and lead_1='Y' ) or (lag_1='Y' and lag_2='Y' and is_empty='Y')
;

--method 2
with A1 as (
select 
b.*
,sum(case when b.is_empty='Y' then 1 else 0 end) over(order by b.seat_no rows between 2 preceding and current row) as sum_1
,sum(case when b.is_empty='Y' then 1 else 0 end) over(order by b.seat_no rows between 1 preceding and 1 following) as sum_2
,sum(case when b.is_empty='Y' then 1 else 0 end) over(order by b.seat_no rows between current row and 2 following) as sum_3
from bms b
)
select *
from A1
where sum_1=3 or sum_2=3 or sum_3=3
;

--method 3
with A1 as (
select b.*
,row_number() over(order by b.seat_no) as rn
from bms b
where is_empty='Y'
)
, B1 as (
select a.*, a.seat_no-a.rn as diff 
from A1 a
)
, C1 as (
select b.diff, count(1)
from B1 b
group by b.diff
having count(1)>=3
)
select * from B1 where diff in (select diff from C1);

--video 22
--Q. find students with same marks in physics and chemistry.
drop table exams;
create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91);
insert into exams values (1,'Physics',91);
insert into exams values (2,'Chemistry',80);
insert into exams values (2,'Physics',90);
insert into exams values (3,'Chemistry',80);
insert into exams values (4,'Chemistry',71);
insert into exams values (4,'Physics',54);
commit;

select student_id
from exams
where subject in ('Chemistry','Physics')
group by student_id
having count(distinct subject)=2 and count(distinct marks)=1;

--video 23
Q. find the cities where covid cases are increasing continuously.
create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI',to_date('2022-01-01','yyyy-mm-dd'),100);
insert into covid values('DELHI',to_date('2022-01-02','yyyy-mm-dd'),200);
insert into covid values('DELHI',to_date('2022-01-03','yyyy-mm-dd'),300);

insert into covid values('MUMBAI',to_date('2022-01-01','yyyy-mm-dd'),100);
insert into covid values('MUMBAI',to_date('2022-01-02','yyyy-mm-dd'),100);
insert into covid values('MUMBAI',to_date('2022-01-03','yyyy-mm-dd'),300);

insert into covid values('CHENNAI',to_date('2022-01-01','yyyy-mm-dd'),100);
insert into covid values('CHENNAI',to_date('2022-01-02','yyyy-mm-dd'),200);
insert into covid values('CHENNAI',to_date('2022-01-03','yyyy-mm-dd'),150);

insert into covid values('BANGALORE',to_date('2022-01-01','yyyy-mm-dd'),100);
insert into covid values('BANGALORE',to_date('2022-01-02','yyyy-mm-dd'),300);
insert into covid values('BANGALORE',to_date('2022-01-03','yyyy-mm-dd'),200);
insert into covid values('BANGALORE',to_date('2022-01-04','yyyy-mm-dd'),400);
commit;

with A1 as (
select c.* 
,rank() over(partition by c.city order by c.days) as rnk_date
,rank() over(partition by c.city order by c.cases) as rnk_cases
,rank() over(partition by c.city order by c.days) - rank() over(partition by c.city order by c.cases) as diff
from covid c
)
select city
from A1
group by city
having count(distinct diff)=1 and min(diff)=0;

--video 24
--Q. Google SQL Interview Question
--find companies who have atleast 2 users who speaks English and German both.
create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English');
insert into company_users values (1,1,'German');
insert into company_users values (1,2,'English');
insert into company_users values (1,3,'German');
insert into company_users values (1,3,'English');
insert into company_users values (1,4,'English');
insert into company_users values (2,5,'English');
insert into company_users values (2,5,'German');
insert into company_users values (2,5,'Spanish');
insert into company_users values (2,6,'German');
insert into company_users values (2,6,'Spanish');
insert into company_users values (2,7,'English');
commit;

select * from company_users;

with A1 as (
select company_id, user_id
from company_users
where language in ('English','German')
group by company_id, user_id
having count(distinct language)=2
)
select company_id from A1 
group by company_id 
having count(1)>=2;

--V.IMP
--video 25
--Meesho Hackerrank SQL Question
--Q. find how many products falls into customer budget , in case of clash choose the less costly product.
drop table products;
create table products
(
product_id varchar(20) ,
cost int
);
truncate table products;
insert into products values ('P1',200);
insert into products values ('P2',300);
insert into products values ('P3',500);
insert into products values ('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400);
insert into customer_budget values (200,800);
insert into customer_budget values (300,1500);
commit;

select * from products;
select * from customer_budget;

with A1 as (
select p.*
, sum(p.cost) over(order by p.cost) as running_sum
from products p
)
select customer_id, budget, count(1) as no_of_products, listagg(product_id,',') as list_of_products
from customer_budget cb
left join A1 a on a.running_sum < cb.budget
group by customer_id, budget
order by customer_id;






