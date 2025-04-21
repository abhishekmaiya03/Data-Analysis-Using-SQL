use restaurant_db;

-- 1.  View the menu_items table

select *
from menu_items;

-- 2. Find the number of items on menu

select count(*)
from menu_items;

-- 3. what are the least and most expensive items on menu?

select * 
from menu_items
order by price;

select * 
from menu_items
order by price desc;

-- 4. How many italian dishes on menu.
select category, count(*)
from menu_items
group by category;

-- 5. what are the least and most expensive italian dishes on menu?
select * 
from menu_items
where category = 'Italian'
order by price; 

select * 
from menu_items
where category = 'Italian'
order by price desc; 

-- 6. How many dishes are in each category?
select category, count(*)
from menu_items
group by category;

-- 7. what is the average dish price within each category?

select category, avg(price) as avg_price
from menu_items
group by category;


-- -----------------------------------------------------------------
-- 1. View the order_details table
select *
from order_details;

-- 2 what is the date range of table?

select *
from order_details
order by order_date;

-- 3. how many orders were made within date range?

select count(distinct order_id) from order_details;

-- 4. How many items were ordered within this date?

select count(*) 
from order_details;

-- 5. which orders had most number of items?
 
 select order_id, count(item_id) as num_items
 from order_details
 group by order_id
 order by num_items desc;
 
 -- 6 how many orders were more than 12?
 
 select count(*) from
 (select order_id, count(item_id) as num_items
 from order_details
 group by order_id
 having num_items>12) as num_orders;
 
 ---------------------------------------------------------------------------------------------------------------
 -- Analyse customer behaviour
 
 -- 1. combine the menu_items and order_details table into a single table
 
 select *
 from menu_items;
 
  select *
 from order_details;
 
 select * 
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id;
 
 -- 2. what are the least and most ordered items?what categories were they in?
 
select item_name, category, count(order_details_id) as num_purchases 
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id
    group by item_name, category
    order by num_purchases desc;
    
    select item_name, category, count(order_details_id) as num_purchases 
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id
    group by item_name, category
    order by num_purchases;
    
-- 3. What were the top 5 orders that spent most money?

 select order_id, sum(price) as total_spend
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id
    group by order_id 
    order by total_spend desc
    limit 5;
    
-- 4 view the details of the highest spend order. what insights can you gather from the information?
    
select category, count(item_id) as num_items
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id
    where order_id = 440
    group by category;
    
-- view the details of the top 5 highest spend orders.

select order_id, category, count(item_id) as num_items
 from order_details od
 left join menu_items mi
	on od.item_id = mi.menu_item_id
    where order_id in (440, 2075, 1957, 330, 2675)
    group by order_id, category;

    
