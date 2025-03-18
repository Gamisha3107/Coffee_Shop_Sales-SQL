select * from coffee_shop_sales;
 
 -- Total Sales
select concat((round(sum(unit_price * transaction_qty)))/1000 ,"K") as Total_Sales
from coffee_shop_sales
where month(transaction_date) = 2; 		-- feb month

-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH              MOM(month on month)
-- selected month/current month(CM) = 5 & previous month(PM) = 4 
select 
month(transaction_date) as Month,		-- no. of month
round(sum(unit_price * transaction_qty)) as Total_Sales,
(sum(unit_price * transaction_qty) - lag(sum(unit_price * transaction_qty),1)		-- month sales difference
over(order by month(transaction_date))) / lag(sum(unit_price * transaction_qty),1)		-- division by PM
over(order by month(transaction_date)) * 100 as mom_increase_percentage			-- percentage
from coffee_shop_sales
where month(transaction_date) in (2,3)				-- for month of feb(PM) & March(CM)
group by month(transaction_date)
order by month(transaction_date);

-- Total Orders
select count(transaction_id) as Total_Orders
from coffee_shop_sales
where month(transaction_date) = 5; 		-- May month

-- TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH
select 
month(transaction_date) as Month,		-- no. of month
round(count(transaction_id)) as Total_Orders,
(count(transaction_id)- lag(count(transaction_id), 1)		-- month sales difference
over(order by month(transaction_date))) / lag(count(transaction_id),1)		-- division by PM
over(order by month(transaction_date)) * 100 as mom_increase_percentage			-- percentage
from coffee_shop_sales
where month(transaction_date) in (4,5)				-- for month of Apr(PM) & May(CM)
group by month(transaction_date)
order by month(transaction_date);

-- Total Qty Sold
select sum(transaction_qty) as Total_Qty_Solds
from coffee_shop_sales
where month(transaction_date) = 6; 		-- June month

-- TOTAL QUANTITY SOLD KPI - MOM DIFFERENCE AND MOM GROWTH
select 
month(transaction_date) as Month,		-- no. of month
round(sum(transaction_qty)) as Total_Qty_Solds,
(sum(transaction_qty)- lag(sum(transaction_qty), 1)		-- month sales difference
over(order by month(transaction_date))) / lag(sum(transaction_qty),1)		-- division by PM
over(order by month(transaction_date)) * 100 as mom_increase_percentage			-- percentage
from coffee_shop_sales
where month(transaction_date) in (5,6)				-- for month of May(PM) & Jun(CM)
group by month(transaction_date)
order by month(transaction_date);

-- Calender Table 
select 
concat(round(sum(unit_price * transaction_qty)/1000,1) ,"K") as Total_Sales,
concat(round(count(transaction_id)/1000,1) ,"K") as Total_Orders,
concat(round(sum(transaction_qty)/1000,1) ,"K") as Total_Qty_Solds
from coffee_shop_sales
where transaction_date = "2023-03-11";				-- 11 Mar 2023

-- SALES BY WEEKDAY / WEEKEND:
select
case when dayofweek(transaction_date) in (1,7) then "Weekend"
else "Wekdays"
end as Day_type,
concat(round(sum(unit_price * transaction_qty)/1000,1),'K') as Total_Sales
from coffee_shop_sales
where month(transaction_date) = 3		-- Mar month
group by case when dayofweek(transaction_date) in (1,7) then "Weekend"
else "Wekdays"
end

-- SALES BY STORE LOCATION
select
store_location,
concat(round(sum(unit_price * transaction_qty)/1000,2),'k') as Total_Sales
from coffee_shop_sales
where month(transaction_date) = 6		-- Jun Month
group by store_location
order by sum(unit_price * transaction_qty) desc;

-- SALES TREND OVER PERIOD
select
concat(round(avg(Total_Sales)/1000,2),'K') as Avg_Sales
from
(
	select sum(unit_price * transaction_qty) as Total_Sales
	from coffee_shop_sales
	where month(transaction_date) = 4 	-- Apr month
	group by transaction_date
) as Inner_query;

-- DAILY SALES FOR MONTH SELECTED
select 
day(transaction_date) as Day_of_month,
round(Sum(unit_price * transaction_qty),2) as Total_Sales
from coffee_shop_sales
where month(transaction_date) = 5 		-- May month
group by transaction_date
order by transaction_date;

-- COMPARING DAILY SALES WITH AVERAGE SALES – IF GREATER THAN “ABOVE AVERAGE” and LESSER THAN “BELOW AVERAGE”
select Day_of_month,
case when total_sales > avg_sales then "Above Average"
when total_sales < avg_sales then "Below Average"
else "Average"
end as Sales_Status, total_sales
from 
( 
	select
    day(transaction_date) as Day_of_Month,
    round(sum(unit_price * transaction_qty),2) as Total_Sales,
    avg(sum(unit_price * transaction_qty)) over () as Avg_Sales
    from coffee_shop_sales
    where month(transaction_date) = 3 		-- Mar month
group by day(transaction_date)
) as sales_data
order by Day_of_Month;

-- SALES BY PRODUCT CATEGORY
select
product_category,
round(sum(unit_price * transaction_qty),2) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 1
group by product_category
order by sum(unit_price * transaction_qty) desc;

-- SALES BY PRODUCTS (TOP 10)
select
product_type,
round(sum(unit_price * transaction_qty),2) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 5 and product_category = 'Coffee'
group by product_type
order by sum(unit_price * transaction_qty) desc limit 10;

-- SALES BY DAY | HOUR
select
round(sum(unit_price * transaction_qty),2) as Total_Sales,
sum(transaction_qty) as Total_Qty,
count(*) as Total_orders
from coffee_shop_sales
where dayofweek(transaction_date) = 2		-- Monday
and month(transaction_date) = 5			-- Mar month
and hour(transaction_time) = 8			-- Hours no 8

-- TO GET SALES FOR ALL HOURS FOR MONTH OF MAY
select
hour(transaction_time) as Hour_of_day,
round(sum(unit_price * transaction_qty),2) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 2 		-- Feb month
group by hour(transaction_time)
order by hour(transaction_time);

-- TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
select
case
when dayofweek(transaction_date) = 2 then 'Monday'
when dayofweek(transaction_date) = 3 then 'Tuesday'
when dayofweek(transaction_date) = 4 then 'Wednesday'
when dayofweek(transaction_date) = 5 then 'Thursday'
when dayofweek(transaction_date) = 6 then 'Friday'
when dayofweek(transaction_date) = 7 then 'Saturday'
else 'Sunday'
end as Day_of_Week,
Round(sum(unit_price * transaction_qty)) as Total_sales
from coffee_shop_sales
where month(transaction_date) = 4		-- Apr month
group by case
when dayofweek(transaction_date) = 2 then 'Monday'
when dayofweek(transaction_date) = 3 then 'Tuesday'
when dayofweek(transaction_date) = 4 then 'Wednesday'
when dayofweek(transaction_date) = 5 then 'Thursday'
when dayofweek(transaction_date) = 6 then 'Friday'
when dayofweek(transaction_date) = 7 then 'Saturday'
else 'Sunday'
end;

