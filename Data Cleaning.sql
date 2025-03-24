create database coffee_shop_sales_db;
select *from coffee_shop_sales;
desc coffee_shop_sales;

---------------------------------------------------------DATA_CLEANING--------------------------------------------------------------------------------------

-- Changing the data type of transaction_date from text to date------------------------------------------------- 

UPDATE coffee_shop_sales
SET transaction_date= STR_TO_DATE(transaction_date,'%d-%m-%Y');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_date DATE;


-- Changing the data type of transaction_time from text to time-------------------------------------------------

UPDATE coffee_shop_sales
SET transaction_time= STR_TO_DATE(transaction_time,'%H:%i:%s');

ALTER TABLE coffee_shop_sales
MODIFY COLUMN transaction_time TIME;


-- Change column name and set data type--------------------------------------------------------------------------

ALTER TABLE coffee_shop_sales
CHANGE COLUMN ï»¿transaction_id transaction_id INT;

