create database pizzahut;
select * from pizzas;
 create table orders (
 order_id int not null,
 order_date date not null,
 order_time time not null,
 primary key (order_id));

 create table orders_details (
 order_details_id int not null,
 order_id int not null,
 pizza_id text not null,
 quantity int not null,
 primary key (order_details_id));
 
 
 select * from orders;
 select * from orders_details;
 select * from pizza_types;
 select * from pizzas;
 
-- Retrieve the total number of orders placed.
select count(*) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select 
	round(sum(o.quantity*p.price),2) as total_price
from orders_details as o
join pizzas as p
on o.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select 
	pt.name,
    p.price
from pizza_types as pt
join pizzas as p
	on pt.pizza_type_id = p.pizza_type_id
order by 2 desc
limit 1;

 select * from pizzas;

-- Identify the most common pizza ordered.
select 
	pt.name,
    count(o.order_details_id) as number
from orders_details as o
join pizzas as p
on o.pizza_id = p.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id
group by 1
order by 2 desc;

-- Identify the most common pizza size ordered.
select
	p.size,
    count(o.order_id) as counts
from pizzas as p
join orders_details as o
on p.pizza_id = o.pizza_id
group by 1
order by 2 desc;

-- List the top 5 most ordered pizza types along with their quantities.
 
 SELECT 
    pt.name, SUM(o.quantity) AS quantities
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    orders_details AS o ON p.pizza_id = o.pizza_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
 
-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
select * from orders;
 select * from orders_details;
 select * from pizza_types;
 select * from pizzas;

SELECT 
    pt.category, sum(o.quantity) AS total_quantities
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN 
    orders_details AS o ON p.pizza_id = o.pizza_id
GROUP BY 1
ORDER BY 2 DESC;

-- Determine the distribution of orders_details by hour of the day.
select * from orders;
SELECT 
    EXTRACT(HOUR FROM o.order_time) AS hour,
    COUNT(od.order_id) AS distrubution
FROM
    orders_details AS od
        JOIN
    orders AS o ON od.order_id = o.order_id
GROUP BY 1
ORDER BY 2 DESC;

-- Determine the distribution of orders_details by hour of the day.
SELECT 
    HOUR(order_time), COUNT(*)
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY 1;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(total_quantity_ordered_per_day), 2)
FROM
    (SELECT 
        o.order_date,
            SUM(od.quantity) AS total_quantity_ordered_per_day
    FROM
        orders AS o
    JOIN orders_details AS od ON o.order_id = od.order_id
    GROUP BY 1) AS t1;

-- Determine the top 3 most ordered pizza types based on revenue.
 
 select * from pizza_types;
 
 SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    orders_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.

select pt.category,
round((sum(od.quantity*p.price)/ (select 
	round(sum(od.quantity*p.price),2) as total_sales
from orders_details as od
join pizzas as p
on od.pizza_id = p.pizza_id)) * 100,2) as percent
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join orders_details as od
on od.pizza_id = p.pizza_id
group by 1
order by 2 desc;

-- Analyze the cumulative revenue generated over time.
select order_date, revenue,
sum(revenue) over(order by order_date) as cum_revenue 
from
(select o.order_date,
round(sum(od.quantity*p.price),2) as revenue
from orders_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join orders as o
on o.order_id = od.order_id
group by 1) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select *
from
(select 
category, 
name, 
revenue,
rank() over(partition by category order by revenue desc) as ranks
from 
(select pt.category,
 pt.name,
sum(od.quantity*p.price) as revenue
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join orders_details as od
on od.pizza_id = p.pizza_id
group by 1,2) as a) as b
where ranks<=3;	



  