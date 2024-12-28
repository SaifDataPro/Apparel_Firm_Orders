/* Number of Orders and items by time frame - Month, Qtr, Year*/

--return number of orders each month and year

select
extract(month from order_date) as month,
extract (year from order_date) as year,
count(*) as orders
from sparrow_apparels.orders
group by month,year
order by year asc, month asc;

-----------------------------------------------------------------------------
/*Number of Orders and items by Product Type, size, Packaging, Clients*/

--returns the list of products and their order count
select 
product_type,
count(*) as orders,
sum(s) as small,
sum(m) as medium,
sum(l) as large,
sum(xl) as extra_large
from `sparrow_apparels.orders`
group by product_type
order by orders desc;

--returns the list of products and their order count by packaging type
select 
product_type,
sum(case when packaging = 'Basic' then 1 else 0 end ) Basic,
sum(case when packaging = 'Economical' then 1 else 0 end ) Economical,
sum(case when packaging = 'Gift-wrap' then 1 else 0 end ) Gift_wrap,
count(*) as total_orders
from `sparrow_apparels.orders`
group by product_type
order by total_orders desc ;

--returns list of clients with their order count, sorted by most orders first
select
o.client_code,
c.client_name,
count(*) as orders
from sparrow_apparels.orders o
left join sparrow_apparels.clients c
on o.client_code=c.Client_Code
group by o.client_code,c.Client_Name
order by orders desc;
----------------------------------------------------------------------------------
/* What is the average order size and average order value for each client?*/

--return list of orders and avg order items, avg order value by each client
select
o.client_code,
c.client_name,
count(*) as orders,
round(avg(total_quantity),2) as avg_order_size,
round(avg(quote_price*total_quantity),2) as avg_order_value,
from sparrow_apparels.orders o
left join sparrow_apparels.clients c
on o.client_code=c.Client_Code
group by o.client_code,c.Client_Name
order by avg_order_value desc,orders desc,avg_order_size desc;

--return a list that shows cost price for each product type
select 
p.product_type,
--round(p.Total_Cost,2) as manhour_cost,
--round(f.cost,2) as fabric_cost,
round((p.Total_Cost+f.cost+10),2) as total_cost_basic,
round((p.Total_Cost+f.cost+25),2) as total_cost_economical,
round((p.Total_Cost+f.cost+50),2) as total_cost_gift_wrap
from `sparrow_apparels.unit_cost_production` p
left join `sparrow_apparels.unit_cost_fabric` f on p.product_type = f.product_type

-----------------------------------------------------------------------------------------------
/* What is the Profit by Order, by Product type, by Client ?*/
  
--returns a list of orders by their profit value
select
order_id,
quote_price*total_quantity as sellig_price,
(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity as cost_price,
round((quote_price*total_quantity-(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity),2) as profit
from `sparrow_apparels.orders`
order by profit desc

--returns a list of clients by their profit value
with orders_profit
as (select
order_id,
client_code,
quote_price*total_quantity as selling_price,
(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity as cost_price,
round((quote_price*total_quantity-(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity),2) as profit
from `sparrow_apparels.orders`
order by profit desc)

select
client_code,
sum(selling_price) as selling_price,
sum(cost_price) as cost_price,
sum(profit) as profit
from orders_profit
group by client_code
order by profit desc

--returns a list of product type by their profit value
with orders_profit 
as (select
order_id,
product_type,
quote_price*total_quantity as selling_price,
(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity as cost_price,
round((quote_price*total_quantity-(unit_cost_of_production+fabric_cost+packaging_material_cost)*total_quantity),2) as profit
from `sparrow_apparels.orders`
order by profit desc)

select
product_type,
 sum(selling_price) as selling_price,
 sum(cost_price) as cost_price,
 sum(profit) as profit
from orders_profit
group by product_type
order by profit desc
----------------------------------------------------------------------------------
  
/*How much man hour was consumed each month for orders booked in the same month?*/

select 
extract(month from order_date) as month,
extract (year from order_date) as year,
count(order_id) as orders_booked,
sum(days_to_fulfill_order)*8 as manhours_consumed,
(24*8-sum(days_to_fulfill_order)*8) as balance_manhours
from `sparrow_apparels.orders`
group by 1,2
