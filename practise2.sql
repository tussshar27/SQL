--SQL

1. Calculate the Rolling Average Sales Over the Last 7 Days
Q: Write a query to calculate the rolling average sales for each day over the
past 7 days.
A: 
select sales_date, sales_amount
, avg(sales_amount) over(order by sales_date rows between 6 preceding and current row) as avg_sales
from orders
;

select date, sales, avg(sales) over(order by date rows between 6 preceding and current row) avg_sales
from orders;

2. Identify the Second-Highest Salary in Each Department
Q: Write a query to find the second-highest salary in each department.
A:
with A1 as (
select emp_id, dept_id, salary, rank() over(partition by dept_id order by salary desc) as salary_rank
from employees e
inner join department d
on e.dept_id=d.dept_id
)
select * from A1
where salary_rank = 2;

select max(salary) 
from employees 
where salary not in / < (select max(salary) from employees group by dept_id) 
group by dept_id;

3. Find Orders Placed Within a Specific Timeframe
Q: Retrieve all orders placed between 9:00 AM and 5:00 PM.
A:
select *
from orders
where datepart(hour,order_date) between 09 and 17
;

select *
from orders
where cast(order_date as time) between '09:00:00' and '17:00:00';

4. Detect Data Gaps for Each Product
Q: Identify dates where no sales were recorded for each product in the sales
table.
A:
select *
from products p
cross join sales s
on p.product_id = s.product_id
where s.sale_date is null;

5. Calculate Cumulative Sum/running sum of Sales by Month
Q: Calculate the cumulative sales by month.
A:
select month, sales_amount, sum(sales_amount) over(order by month) as cumulative_sales
from orders
;

6. Identify Employees in Multiple Departments
Q: Write a query to identify employees assigned to more than one
department.
A:

select emp_id, count(distinct dept_id) as count_of_dept
from employees e
inner join department d
on e.dept_id = d.dept_id
group by emp_id
having count(distinct dept_id) > 1
;

7. Find Products with Zero Sales in the Last Quarter
Q: List all products that had no sales in the last quarter.
A:

two tables: products, sales
with A1 as (
select distinct product_id from sales
where sales_date >= dateadd(quarter,-1,getdate())
)
select * from products where product_id not in (select product_id from A1);

8. Count Orders with Discounts in Each Category
Q: Count the number of orders with discounts in each category.
A:

select category_id, count(order_id) as count_orders
from orders
where discount > 0
group by category_id
;

9. Identify Employees Whose Tenure is Below Average
Q: Find employees with tenure less than the average tenure of all employees.
A:

select emp_id, name, tenure
from employees
where tenure < (select avg(tenure) of employees);

10. Identify the Most Popular Product in Each Category
Q: Find the most popular product in each category based on sales.
A:

with A1 as (
select product_id, catgory_id, sum(sales_amount) as sum_of_sales
from orders
group by product_id, catgory_id
)
, B1 as (
select *, rank() over(partition by category_id order by sum_of_sales desc) as rnk_sales
from A1
)
select * from B1 where rnk_sales = 1;

11. Detect Orders that Exceed a Monthly Threshold
Q: Identify customers that had made orders that exceeded a $10,000 monthly threshold.
A:

select customer_id, sum(sales_amount) as sum_of_sales_amount
from orders 
group by customer_id, datepart(month, order_date)
having sum(sales_amount) > 10000
;

12. Find Customers Who Have Never Ordered a Specific Product
Q: Identify customers who have never ordered product "P123".
A:

select customer_id 
from customers 
where customer_id not in (
select customer_id from orders where product_id = "P123"
);

13. Calculate Each Employee’s Percentage of Departmental Sales
Q: Write a query to calculate each employee's sales as a percentage of total departmental sales.
A:
with A1 as (
select dept_id, emp_id, sum(sales_amount) as sum_of_emp_sales, sum(sum(sales_amount)) over(partition by dept_id) as total_dept_sales
from employees
group by dept_id, emp_id
)
select *, (sum_of_emp_sales/total_dept_sales)*100 as perc_sales
from A1;

IMP:
14. Find Products with Sales Growth Between Two Periods
Q: Write a query to identify products with sales growth from Q1 to Q2.
A:
NOTE: first find sales of products in quarter 1 and 2 then compare both.

with A1 as (
select product_id, name
, sum(case when datepart(quarter, sales_date) = 1 then sales end) as q1_sales
, sum(case when datepart(quarter, sales_date) = 2 then sales end) as q2_sales
from orders
group by product_id, name
)
select product_id, name, q1_sales, q2_sales, q2_sales - q1_sales as sales_growth
from A1
where q2_sales > q1_sales
order by sales_growth;

15. Identify Customers with Consecutive Months of Purchases
Q: Find customers with orders in consecutive months.
A:
NOTE: lead or lag, order by clause is mandatory with the required value column in it.

select 
customer_id, datepart(month,order_date) as month_order
, lag(datepart(month,order_date),1) over(partition by customer_id order by datepart(month,order_date)) as previous_month_order
from customers
where datepart(year,order_date) = 2024 and (month_order = previous_month_order + 1) or 
(month_order = 1 and previous_month_order = 12)
;

16. Calculate Average Order Value (AOV) by Month
Q: Write a query to calculate AOV by month.
A:

select datepart(year,order_date) as year, datepart(month,order_date) as month, avg(order_amount) as avg_order_month
from orders
group by datepart(year,order_date) as year, datepart(month,order_date) as month
;

17. Rank Sales Representatives by Quarterly Performance
Q: Rank sales representatives based on quarterly sales.
A:

select sales_representative_id, datepart(quarter,sales_date), sum(sales)
, rank() over(partition by sales_representative_id order by sum(sales) desc) as rnk
from orders
group by sales_representative_id, datepart(quarter,sales_date)


18. Find the Month with the Highest Revenue in Each Year
Q: Write a query to find the month with the highest revenue for each year.
A:

select month from (
select datepart(year, sales_date) as year, datepart(month, sales_date) as month, sum(revenue) as sum_revenue
, rank() over(partition by datepart(year, sales_date) order by sum(revenue) desc) as rnk
from revenue
group by datepart(year, sales_date) as year, datepart(month, sales_date) as month
) where rnk = 1
;

19. Identify Items with Stockouts
Q: Identify items that experienced stockouts (when stock quantity was zero).
A:

select item_id, date
from stocks
where quantity = 0
;

20. Calculate Average Time Between Orders by Customer
Q: Write a query to calculate the average time between orders for each customer.
A:
--calculate average time between two orders of each customer
--so first we need to find time difference of two orders of each customer then we do average on that number.

with A1 as (
select customer_id, order_date, lag(order_date,1) over(partition by customer_id order by order_date) as previous_order_date
from orders
group by customer_id
)
, B1 as (
select *, datediff(day,order_date,previous_order_date) as interval_days
from A1
)
select customer_id, avg(interval_days) avg_time_diff_of_each_cust
from B1
group by customer_id;
