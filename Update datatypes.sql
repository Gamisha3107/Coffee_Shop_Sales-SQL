-- How to update datatypes & change field name
select * from coffee_shop_sales;

desc coffee_shop_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales
SET transaction_date = STR_TO_DATE(transaction_date, '%d-%m-%Y');

SET SQL_SAFE_UPDATES = 1;

alter table coffee_shop_sales
modify column transaction_date date;

SET SQL_SAFE_UPDATES = 0;

UPDATE coffee_shop_sales
SET transaction_time = STR_TO_DATE(transaction_time, '%H:%i:%s');

alter table coffee_shop_sales
modify column transaction_time time;

alter table coffee_shop_sales
change column ï»¿transaction_id transaction_id int;