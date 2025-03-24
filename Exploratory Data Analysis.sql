---------------------------------------------------------COFFEE_SHOP_SALES_ANALYSIS--------------------------------------------------------------------------


-- TOTAL SALES ANALYSIS-------------------------------------------------------------------------

-- Total sales for each respective month
SELECT MONTH(transaction_date) AS Month, ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM coffee_shop_sales
GROUP BY 
MONTH(transaction_date);

# OR
SELECT MONTH(transaction_date), CONCAT((ROUND(SUM(unit_price * transaction_qty)))/1000,"K") AS Total_Sales
FROM coffee_shop_sales
GROUP BY
MONTH(transaction_date);


-- Month on month (MoM) increase or decrease in sales
SELECT MONTH(transaction_date) AS Month, -- Month number
ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales, -- Total Sales Column
ROUND(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) AS Sales_Diff, -- Monthly Sales difference
(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) / 
LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);
------------------------------------------
# OR by applying CTE
------------------------------------------    
WITH MonthlySales AS (
    SELECT 
        MONTH(transaction_date) AS Month,
        CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),"K") AS Total_Sales
    FROM coffee_shop_sales
    WHERE MONTH(transaction_date) IN (4,5)
    GROUP BY MONTH(transaction_date)
)
SELECT 
    Month,Total_Sales,
    (Total_Sales - LAG(Total_Sales) OVER(ORDER BY Month)) / LAG(Total_Sales) OVER(ORDER BY Month) * 100 AS MoM_percentage
FROM MonthlySales;

# NOW------------------
SELECT MONTH(transaction_date) AS Month, -- Month number
ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales, -- Total Sales Column
ROUND(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) AS Sales_Diff, -- Monthly Sales difference
(SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) /
LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);



-- TOTAL ORDERS ANALYSIS---------------------------------------------------------------------------

-- Total number of orders for each respective month
SELECT MONTH(transaction_date) AS Month, COUNT(*) AS Total_Orders
FROM coffee_shop_sales
GROUP BY 
MONTH(transaction_date);

-- Month on month (MoM) increase or decrease in orders
SELECT MONTH(transaction_date) AS Month, -- Month number
COUNT(*) AS Total_Orders, -- Total Sales Column
(COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date))) AS Orders_Diff, -- Monthly orders difference
(COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

# NOW------------------
SELECT MONTH(transaction_date) AS Month, -- Month number
COUNT(*) AS Total_Orders, -- Total Sales Column
(COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date))) AS Orders_Diff, -- Monthly orders difference
(COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(*), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);



-- TOTAL QUANTITY SOLD ANALYSIS------------------------------------------

-- Total quantity sold for each respective month
SELECT MONTH(transaction_date) AS Month, SUM(transaction_qty) AS Total_Quantity_Sold
FROM coffee_shop_sales
GROUP BY 
MONTH(transaction_date);

-- Month on month (MoM) increase or decrease in orders
SELECT MONTH(transaction_date) AS Month, -- Month number
SUM(transaction_qty) AS Total_Quantity_Sold, -- Total Quantity Sold Column
(SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) AS Qty_Sold_Diff, -- Monthly quantity sold difference
(SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
WHERE MONTH(transaction_date) IN (4,5)
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

# NOW--------------------
SELECT MONTH(transaction_date) AS Month, -- Month number
SUM(transaction_qty) AS Total_Quantity_Sold, -- Total Quantity Sold Column
(SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) AS Qty_Sold_Diff, -- Monthly quantity sold difference
(SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS MoM_percentage -- Percentage

FROM coffee_shop_sales
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);



-- DETAILED METRICS OF SALES, QUANTITY and TOTAL ORDERS OVER A SPECIFIC DAY-----------------------------------------
SELECT
CONCAT(ROUND(COUNT(*)/1000,1),"K") AS Total_Orders,
CONCAT(ROUND(SUM(transaction_qty)/1000,1),"K") AS Total_Qty_Sold,
CONCAT("$",ROUND(SUM(unit_price * transaction_qty)/1000,1),"K") AS Total_Sales
FROM coffee_shop_sales
WHERE transaction_date='2023-03-27';



-- SALES ANALYSIS BY WEEKDAYS & WEEKENDS---------------------------------------------------------------------------
-- Weekdays - Mon to Fri
-- Weekends - Sat & Sun
-- Sun = 1, Mon = 2, Tue = 3,.....,Sat = 7

SELECT 
CASE 
    WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
END AS day_type,
CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Total_Sales
FROM coffee_shop_sales
WHERE Month(transaction_date)=2 -- Feb Month 
GROUP BY 
CASE 
    WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END;

# NOW------------------------
SELECT MONTH(transaction_date) AS Month_num,MONTHNAME(transaction_date) AS Month,
    CONCAT(ROUND(SUM(CASE WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN unit_price * transaction_qty ELSE 0 END)/1000,1),"K") AS Weekend_Sales,
    CONCAT(ROUND(SUM(CASE WHEN DAYOFWEEK(transaction_date) BETWEEN 2 AND 6 THEN unit_price * transaction_qty ELSE 0 END)/1000,1),"K") AS Weekday_Sales
FROM coffee_shop_sales
GROUP BY MONTH(transaction_date),MONTHNAME(transaction_date)
-- if we run upto this we will get months in chronological order because they are already in that order, but if they were not then--
ORDER BY MONTH(transaction_date);



-- SALES ANALYSIS BY STORE LOCATION FOR A SPECIFIC MONTH----------------------------------------------------------------
SELECT store_location,
CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Total_Sales
FROM coffee_shop_sales
WHERE Month(transaction_date)=6 -- June month
GROUP BY store_location
ORDER BY SUM(unit_price*transaction_qty) DESC; -- always condition by the original not the Aliases
-- we are not sorting through ALIAS Total_Sales becoz Total_Sales is a concatenated string, MySQL sorts it alphabetically, not numerically



-- DAILY SALES PER DAY IN A PARTICULAR MONTH-------------------------------------------------------------------------------
SELECT DAY(transaction_date) AS Day,
SUM(unit_price*transaction_qty) AS Total_Daily_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=5 -- May month
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date);



-- AVERAGE SALES PER DAY IN A PARTICULAR MONTH--------------------------------------------------------------------------------
SELECT CONCAT(ROUND(AVG(Total_Daily_Sales)/1000,1),"K") AS Average_Daily_sales
FROM
(SELECT DAY(transaction_date) AS Day,
SUM(unit_price*transaction_qty) AS Total_Daily_Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=5 -- May month
GROUP BY DAY(transaction_date)
ORDER BY DAY(transaction_date)) AS Daily_Sales;



-- COMPARISON OF EACH DAY SALES WITH THE AVERAGE DAILY SALES OF A PARTICULAR MONTH---------------------------------------------
 SELECT day_of_month,Total_daily_sales,
 CASE
     WHEN Total_daily_sales>avg_sales THEN 'above Average'
     WHEN Total_daily_sales<avg_sales THEN 'below Average'
     ELSE 'Average'
 END AS sales_status
 FROM
 (SELECT DAY(transaction_date) AS day_of_month,
 SUM(unit_price*transaction_qty) AS Total_daily_sales,
 AVG(SUM(unit_price*transaction_qty)) OVER() AS avg_sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date)=5 -- May month
 GROUP BY DAY(transaction_date)) AS Sales_data
 ORDER BY day_of_month;
 


 -- SALES OF DIFFERENT PRODUCT CATEGORIES IN A PARTICULAR MONTH-----------------------------------------------------------
 SELECT product_category,
 CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date)=5 -- May month
 GROUP BY product_category
 ORDER BY SUM(unit_price*transaction_qty) DESC;



-- TOP 10 SELLING PRODUCTS OF COFFEE IN MAY MONTH----------------------------------------------------------------------------
 SELECT product_type,
 CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date)=5 AND product_category='Coffee'
 GROUP BY product_type
 ORDER BY SUM(unit_price*transaction_qty) DESC
 LIMIT 10;
 


 -- TOP 10 SELLING PRODUCTS IN A PARTICULAR MONTH--------------------------------------------------------------------------
 SELECT product_type,
 CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
 FROM coffee_shop_sales
 WHERE MONTH(transaction_date)=5 -- May month
 GROUP BY product_type
 ORDER BY SUM(unit_price*transaction_qty) DESC
 LIMIT 10;

#NOW -- OVERALL TOP 10 SELLING PRODUCTS--------------------------------------
SELECT product_type,
CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
FROM coffee_shop_sales
GROUP BY product_type
ORDER BY SUM(unit_price*transaction_qty) DESC
LIMIT 10;



-- TOTAL SALES,TOTAL QTY SOLD,TOTAL ORDERS WITH RESPECT TO A PARTICULAR MONTH-DAY-HOUR-------------------------------------
SELECT CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales,
SUM(transaction_qty) AS Qty_sold,
COUNT(*) AS No_of_orders
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=5 -- May month
AND DAY(transaction_date)=20 -- 20th May
AND HOUR(transaction_time)=14; -- @ 2 PM to 2:59:59 PM



-- TOTAL SALES,TOTAL QTY SOLD,TOTAL ORDERS WITH RESPECT TO A PARTICULAR MONTH & HOUR ON SUNDAYS-----------------------------
SELECT transaction_date AS Sunday_Date,  
CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1), "K") AS Sales,
SUM(transaction_qty) AS Qty_sold,
COUNT(*) AS No_of_orders
FROM coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- May month 
    AND DAYOFWEEK(transaction_date) = 1 -- Sunday
    AND HOUR(transaction_time) = 14 -- @ 2PM to 2:59:59 PM
GROUP BY transaction_date  -- Group by each Sunday
ORDER BY transaction_date; -- Sort in ascending order



-- DETERMINING PEAK HOURS OF SALES IN A PARTICULAR MONTH--------------------------------------------------------------------
SELECT HOUR(transaction_time) AS Hours,
CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=5 -- May month
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time);



-- DETERMINING PEAK DAYS OF SALES IN A PARTICULAR MONTH---------------------------------------------------------------------
SELECT
CASE
    WHEN DAYOFWEEK(transaction_date)=2 THEN 'Monday'
    WHEN DAYOFWEEK(transaction_date)=3 THEN 'Tueday'
    WHEN DAYOFWEEK(transaction_date)=4 THEN 'Wednesday'
    WHEN DAYOFWEEK(transaction_date)=5 THEN 'Thursday'
    WHEN DAYOFWEEK(transaction_date)=6 THEN 'Friday'
    WHEN DAYOFWEEK(transaction_date)=7 THEN 'Saturday'
    ELSE 'Sunday'
END AS Day_of_Week,
CONCAT(ROUND(SUM(unit_price*transaction_qty)/1000,1),"K") AS Sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date)=5 -- May month
GROUP BY 1;






 
 
 
 
 
 
 














