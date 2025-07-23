drop table if exists zepto;

create table zepto_v2 (
sku_id SERIAL PRIMARY KEY,
ï»¿Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);


--data exploration

--count of rows
select count(*) from zepto_v2;

--sample data

SELECT * FROM zepto_v2
LIMIT 10;

--null values


SELECT *
FROM zepto_v2
WHERE 
   ï»¿Category IS NULL OR ï»¿Category = '' OR
    name IS NULL OR name = '' OR
    mrp IS NULL OR
    discountPercent IS NULL OR
    availableQuantity IS NULL OR
    discountedSellingPrice IS NULL OR
    weightInGms IS NULL OR
    outOfStock IS NULL OR
    quantity IS NULL;

--different product categories
SELECT DISTINCT ï»¿Category
FROM zepto_v2
ORDER BY ï»¿Category;


--products in stock vs out of stock


SELECT 
    CASE 
        WHEN outOfStock = TRUE THEN 'Out of Stock'
        WHEN outOfStock = FALSE THEN 'In Stock'
        ELSE 'Unknown'
    END AS stock_status,
    COUNT(*) AS total_products
FROM zepto_v2
GROUP BY outOfStock;


--product names present multiple times

SELECT name, COUNT(*) AS "Number of SKUs"
FROM zepto_v2
GROUP BY name
HAVING count(*) > 1
ORDER BY count(*) DESC;


--products with price = 0

SELECT * FROM zepto_v2
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto_v2
WHERE mrp = 0;

--convert paise to rupees

UPDATE zepto_v2
SET mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto_v2;

--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto_v2
ORDER BY discountPercent DESC
LIMIT 10;



-- Q2: Products with High MRP but Out of Stock

SELECT DISTINCT name, mrp
FROM zepto_v2
WHERE outOfStock ='TRUE'

	AND mrp > 300
ORDER BY mrp DESC;


--Q3.Calculate Estimated Revenue for each category

SELECT ï»¿Category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_v2
GROUP BY ï»¿Category
ORDER BY total_revenue;


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SELECT DISTINCT name, mrp, discountPercent
FROM zepto_v2
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

SELECT ï»¿Category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto_v2
GROUP BY ï»¿Category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto_v2
WHERE weightInGms >= 100
ORDER BY price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto_v2;

--Q8.What is the Total Inventory Weight Per Category 

SELECT ï»¿Category,
SUM (weightInGms * availableQuantity) AS total_weight
FROM zepto_v2
GROUP BY ï»¿Category
ORDER BY total_weight;
