--returns number of orders each month ,quarter and year
select
extract(month from order_date) as month,
extract(quarter from order_date) as quarter,
extract (year from order_date) as year,
count(*) as orders
from sparrow_apparels.orders
group by month,quarter,year
order by year asc, month asc;

--------------------------------------------------------------------------------------------
-- returns Number of Orders and items by Product Type and Size, Packaging and Size, Clients
---------------------------------------------------------------------------------------------
/*Product Type and Size*/
select 
product_type,
count(*) as orders,
sum(s) as small,
sum(m) as medium,
sum(l) as large,
sum(xl) as extralarge,
sum(total_quantity) as total_items
from `sparrow_apparels.orders`
group by product_type
order by orders desc;

/*Packaging and Size*/
select 
packaging,
count(*) as orders,
sum(s) as small,
sum(m) as medium,
sum(l) as large,
sum(xl) as extralarge,
sum(total_quantity) as total_items
from `sparrow_apparels.orders`
group by packaging
order by orders desc;

/*Orders and Order items by Client*/
select
o.client_code,
c.client_name,
count(*) as orders,
sum(o.total_quantity) as total_items,
from sparrow_apparels.orders o
left join sparrow_apparels.clients c
on o.client_code=c.Client_Code
group by o.client_code,c.Client_Name
order by orders desc;
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
