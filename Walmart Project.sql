CREATE DATABASE IF NOT EXISTS WALMART_SALES;

CREATE TABLE IF NOT EXISTS sales ( 
 invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
 branch VARCHAR(3) NOT NULL,
 city VARCHAR(30) NOT NULL,
 customer_type VARCHAR(30) NOT NULL,
 gender VARCHAR(10) NOT NULL ,
 product_line VARCHAR(100) NOT NULL,
 unit_price DECIMAL(10,2) NOT NULL,
 quantity INT NOT NULL ,
 VAT FLOAT(6,4) NOT NULL ,
 total DECIMAL(10,2) NOT NULL ,
 date DATE NOT NULL ,
 time TIMESTAMP NOT NULL ,
 payment_method DECIMAL(10,2) NOT NULL ,
 cogs DECIMAL(10,2) NOT NULL ,
 gross_margin_percentage FLOAT(11,9) NOT NULL,
 gross_income DECIMAL(10,2) ,
 rating FLOAT(2,1));
 
 SELECT * FROM SALES;
 -- ADDING NEW COLUMM time_of_day
 SELECT Time ,
        ( CASE 
               WHEN 'Time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
               WHEN 'Time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
               ELSE "Evening"
               END) AS time_of_day
FROM sales;
ALTER TABLE sales
ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
); 

-- ADD A NEW day_name COLUMN ----------
SELECT Date, DAYNAME(Date)
FROM sales;

ALTER TABLE sales
ADD COLUMN  day_name VARCHAR(30);

UPDATE sales
SET day_name = DAYNAME(date);

-- ADDING MONTH NAME COLUMN ------------
SELECT Date, MONTHNAME(Date) 
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = MONTHNAME(Date);

-- GENERIC QUESTIONS ANSWERS -----------
-- HOW MANY UNIQUE CITIES DOES THE  DATA HAVE --
SELECT DISTINCT(City) FROM sales;

-- IN WHICH CITY IS EACH BRANCH---------
SELECT DISTINCT City, branch 
FROM sales;

-- QUESTION ON PRODUCTS------------------
-- 1) HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE?-- 6 ------
SELECT DISTINCT product_line
FROM sales;
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- 2. What is the most common payment method?-- CASH -- ----------
SELECT SUM(Quantity) as qty, Payment
FROM sales
GROUP BY Payment
ORDER BY qty DESC;

-- 3. What is the most selling product line?--------
SELECT SUM(Quantity) AS qty, product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- 4. What is the total revenue by month? --------------
SELECT month_name AS month, SUM(Total) AS Total_revenue
FROM sales
GROUP BY month_name
ORDER BY Total_revenue DESC;

-- 5. What month had the largest COGS?-------
SELECT SUM(cogs) AS TOTAL, month_name as month
FROM sales
GROUP BY month_name
ORDER BY TOTAL DESC;

-- 6. What product line had the largest revenue?-----------
SELECT SUM(Total) AS total_revenue, product_line 
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 5. What is the city with the largest revenue?-------------
SELECT city, SUM(Total) as total_revenue
FROM sales
GROUP BY City
ORDER BY total_revenue DESC;

-- 6. What product line had the largest VAT?--------
SELECT product_line, AVG(VAT) AS VAT 
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

-- 7. Fetch each product line and add a column to those -------
-- product line showing "Good", "Bad". Good if its greater than average sales------
SELECT AVG(Quantity) AS AVG_SALES
FROM sales;
SELECT product_line,
       CASE
           WHEN  AVG(Quantity) > 5 THEN "Good"
       ELSE "Bad"
	END AS result
FROM sales
GROUP BY product_line;
       
-- 8. Which branch sold more products than average product sold?------
SELECT Branch, SUM(Quantity) 
FROM sales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM sales);

-- 9. What is the most common product line by gender?------
SELECT Gender, product_line,COUNT(Gender) AS CNT
FROM sales
GROUP BY Gender, product_line
ORDER BY Gender DESC;

-- 12. What is the average rating of each product line?---------
SELECT ROUND(AVG(Rating),1) AS AVG_RT, product_line
FROM sales
GROUP BY product_line
ORDER BY AVG_RT;

-- -----------------------------------------------------------
-- --------------------------------------------------
-- QUESTIONS ON SALES ----------
-- 1. Number of sales made in each time of the day per weekday-------
SELECT time_of_day,day_name, COUNT(*) AS SALES
FROM sales
WHERE day_name = "monday" 
GROUP BY time_of_day, day_name
ORDER BY SALES DESC;

-- 2. Which of the customer types brings the most revenue?------------
SELECT customer_type , ROUND(SUM(Total),2) AS REVENUE
FROM sales
GROUP BY customer_type
ORDER BY REVENUE;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?------
SELECT ROUND(AVG(VAT),2) AS LTP, City
FROM sales
GROUP BY City
ORDER BY LTP DESC;

-- 4. Which customer type pays the most in VAT?----
SELECT customer_type, ROUND(AVG(VAT),2) AS MST
FROM sales
GROUP BY customer_type
ORDER BY MST DESC;

-- for changing column name  ALTER TABLE sales RENAME COLUMN `Customer type` TO customer_type;----

-- CUSTOMER ANALYSIS ------------------------------------------------
-- --------------------------------------------------------
-- 1. How many unique customer types does the data have?-------------------------------
SELECT DISTINCT customer_type 
FROM sales;

-- 2. How many unique payment methods does the data have?------------
SELECT DISTINCT Payment
FROM sales;

-- 3. What is the most common customer type?----
SELECT customer_type, COUNT(*) AS CNT
FROM sales
GROUP BY customer_type
ORDER BY CNT DESC;

-- 4. Which customer type buys the most?------
SELECT customer_type , COUNT(*)
FROM sales
GROUP BY customer_type;

-- 5. What is the gender of most of the customers?----------
SELECT Gender, COUNT(*) 
FROM sales
GROUP BY Gender;

-- 6. What is the gender distribution per branch?---------------
SELECT Branch,Gender,
       COUNT(*) AS gender_count,
       COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY Branch) AS gender_percentage
FROM sales
GROUP BY Branch, Gender;

-- 7. Which time of the day do customers give most ratings?----------
SELECT time_of_day, ROUND(AVG(Rating),2) AS most_ratings
FROM sales
GROUP BY time_of_day
ORDER BY most_ratings DESC;

-- 8. Which time of the day do customers give most ratings per branch?-------
SELECT time_of_day, Branch,ROUND(AVG(Rating),2) AS most_ratings
FROM sales
GROUP BY time_of_day,Branch
ORDER BY most_ratings DESC;

-- 9. Which day fo the week has the best avg ratings?---------
SELECT day_name, ROUND(AVG(Rating),2) AS AVRG
FROM sales
GROUP BY day_name 
ORDER BY AVRG DESC;

-- 10. Which day of the week has the best average ratings per branch?-------
SELECT day_name,Branch, ROUND(AVG(Rating),2) AS best_avg_rating
FROM sales
GROUP BY day_name, Branch
ORDER BY best_avg_rating DESC;



select * from sales;
