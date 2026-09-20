create database Instakart;
SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM customerss
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'stores', COUNT(*) FROM stores
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL
SELECT 'promotions', COUNT(*) FROM promotions
UNION ALL
SELECT 'returns', COUNT(*) FROM returns;
-- Duplicate Customer
select customer_id,count(*)
from customerss
group by customer_id
having count(*)>1;
--- duplicate products
SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
--- customer with no orders
select c.customer_id

FROM customerss c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
select * from customerss;

--- orders with no shipments

SELECT o.order_id
FROM orders o
LEFT JOIN shipments s
ON o.order_id = s.order_id
WHERE s.shipment_id IS NULL;
--- Invalid Returns
SELECT r.*
FROM returns r
LEFT JOIN order_items oi
ON r.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL;

--- Total Revenue
Select round(sum(amount),2) as total_rev
from payments;
--- total orders
SELECT COUNT(*) AS total_orders
FROM orders;

--- Total Customers
SELECT COUNT(*) AS total_customers
FROM customerss;
--- Average Order Value
SELECT ROUND(AVG(amount),2) AS avg_order_value
FROM payments;

--- Average Order Value
SELECT ROUND(AVG(amount),2) AS avg_order_value
FROM payments;
-- Orders Per Customer
select  customer_id, count(*) as total_ordrs
from orders
group by 1
order by 2 desc;
-- Top 10 Customers by Spending
select c.customer_id ,sum(p.amount) as total_payment
from customerss c join orders o
on c.customer_id=o.customer_id
join payments p
on p.order_id=o.order_id
group by customer_id
order by total_payment desc;
SELECT
c.customer_id,

ROUND(SUM(p.amount),2) AS total_spent
FROM customerss c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10; 
select * from payments;

-- worst selling product
select p.product_id, sum(oi.qty) as total_quantity
from products p join order_items oi
group by 1
limit 10;

-- Revenue by city

SELECT
s.city,
ROUND(SUM(pay.amount),2) AS revenue
FROM stores s
JOIN orders o
ON s.store_id=o.store_id
JOIN payments pay
ON o.order_id=pay.order_id
GROUP BY s.city
ORDER BY revenue DESC;
--- revenue by suppliers
SELECT 
    sup.supplier_id, ROUND(SUM(oi.qty * oi.price), 2) AS revenue
FROM
    suppliers sup
        JOIN
    products p ON sup.supplier_id = p.supplier_id
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY sup.supplier_id
ORDER BY revenue DESC;


-- Monthly Sales
SELECT
YEAR(o.order_date) AS year,
MONTH(o.order_date) AS month,
ROUND(SUM(p.amount),2) AS revenue
FROM payments p join orders o 
on p.order_id=p.order_id
GROUP BY 1,2

ORDER BY year,month;

--- Daily Sales Trend

SELECT
(o.order_date),
ROUND(SUM(p.amount),2) AS revenue
FROM payments p join orders o 
GROUP BY 1
ORDER BY 1;

--- Customer-wise Revenue

SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.amount),2) AS total_spent
FROM customerss c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC;
--- Category-wise Orders

SELECT
    c.category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
ON oi.product_id=p.product_id
JOIN categories c
ON p.category_id=c.category_id
GROUP BY c.category_name
ORDER BY total_orders DESC;

-- Average Quantity Sold Per Product
SELECT
    p.product_id,
    ROUND(AVG(oi.qty),2) AS avg_quantity
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_id
ORDER BY avg_quantity DESC;

SELECT
    product_id,
    ROUND(AVG(qty),2) AS avg_quantity
FROM 
order_items 

GROUP BY product_id
ORDER BY avg_quantity DESC;
--- Average Quantity Sold Per Product
select p.product_id,
ROUND(AVG(oi.qty),2) AS avg_quantity
FROM products p
JOIN order_items oi
ON p.product_id=oi.product_id
group by 1
ORDER BY avg_quantity DESC;
--- Top 5 Categories by Revenue
select  c.category_name, round(AVG(oi.qty*oi.qty)) as Revenue
FROM categories c
JOIN products p
ON c.category_id=p.category_id
JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY c.category_name
ORDER BY revenue DESC
LIMIT 5;
---- Customers Spending Above Average
SELECT
    c.customer_id,
    SUM(p.amount) total_spent
FROM customerss c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY c.customer_id
HAVING total_spent >
(select avg(amount)
from  payments
);
--- Customers With More Than 5 Orders
SELECT
    customer_id,
    COUNT(order_id) total_orders
FROM orders
GROUP BY customer_id
HAVING total_orders>5;
-- Customer Segment
select o.customer_id, sum(p.amount) as spending,
case
when sum(p.amount)>1000 THEN 'Platinum'
WHEN SUM(amount)>=5000 THEN 'Gold'
WHEN SUM(amount)>=2000 THEN 'Silver'
ELSE 'Bronze'
end as customer_segment
FROM orders o
JOIN payments p
ON o.order_id=p.order_id
GROUP BY customer_id;
--- Product Price Bucket
SELECT
product_id,
price,
CASE
WHEN price<500 THEN 'Budget'
WHEN price BETWEEN 500 AND 2000 THEN 'Mid Range'
ELSE 'Premium'
END AS price_bucket
FROM products;
----- Customers Who Bought Most Expensive Product
SELECT DISTINCT
c.customer_id

FROM customerss c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items oi
ON o.order_id=oi.order_id
WHERE oi.product_id=
(
SELECT product_id
FROM products
ORDER BY price DESC
LIMIT 1
);
-- Highest Revenue Store

SELECT
store_id
FROM stores
WHERE store_id=
(
SELECT o.store_id
FROM orders o
JOIN payments p
ON o.order_id=p.order_id
GROUP BY store_id
ORDER BY SUM(amount) DESC
LIMIT 1
);
SELECT
customer_id
FROM customerss c
WHERE EXISTS
(
SELECT 1
FROM orders o
WHERE c.customer_id=o.customer_id
);
-- Rank Customers by Total Spending

select c.customer_id, sum(p.amount) as total_payment,
rank() over (order by  sum(p.amount) desc) as cust_rnk
from customerss c join orders o on
c.customer_id=o.customer_id
JOIN payments p
ON o.order_id=p.order_id
GROUP BY c.customer_id;
-- Top Store Every Month
select * from (select year(o.order_date),month(o.order_date),store_id, sum(p.amount) as sales , 
row_number() over (partition by YEAR(order_date),MONTH(order_date)
ORDER BY SUM( p.amount) DESC) rnk
from orders o join payments p 
on o.order_id=p.order_id
GROUP BY
YEAR(order_date),
MONTH(order_date),
store_id) x 
where rnk=1;
-- Customer Lifetime Value

WITH rfm AS
(
SELECT
o.customer_id,
DATEDIFF((SELECT MAX(order_date) FROM orders),MAX(order_date)) AS Recency,
COUNT(DISTINCT o.order_id) AS Frequency,
SUM(p.amount) AS Monetary

FROM orders o
JOIN payments p
ON o.order_id=p.order_id

GROUP BY o.customer_id
)

SELECT *,
CASE
WHEN Recency<=30 AND Frequency>=10 AND Monetary>=10000 THEN 'Champions'
WHEN Recency<=60 AND Frequency>=5 THEN 'Loyal Customers'
WHEN Recency<=90 THEN 'Potential Loyalist'
WHEN Recency>180 THEN 'Lost Customers'
ELSE 'Regular'
END Customer_Segment

FROM rfm;

-- Monthly Active Customers

-- Average Basket Size
SELECT

AVG(total_items) avg_basket

FROM

(

SELECT

order_id,

SUM(qty) total_items

FROM order_items

GROUP BY order_id

)x;


SELECT

customer_id,

AVG(products)

FROM

(

SELECT

o.customer_id,

o.order_id,

COUNT(product_id) products

FROM orders o

JOIN order_items oi

ON o.order_id=oi.order_id

GROUP BY
o.customer_id,
o.order_id

)x

GROUP BY customer_id;
-- Pareto Analysis (80/20)
WITH sales AS
(
SELECT

product_id,

SUM(qty*price) revenue

FROM order_items

GROUP BY product_id
),

pareto AS
(
SELECT

product_id,

revenue,

SUM(revenue)
OVER(
ORDER BY revenue DESC
) cumulative_sales,

SUM(revenue)
OVER() total_sales

FROM sales
)

SELECT

*,

ROUND(
cumulative_sales/
total_sales*100,2
)

cumulative_percent

FROM pareto;
-- ABC Classification
WITH product_sales AS
(
SELECT

product_id,

SUM(qty*price) revenue

FROM order_items

GROUP BY product_id
),

abc AS
(
SELECT

product_id,

revenue,

SUM(revenue)
OVER(
ORDER BY revenue DESC
)

/

SUM(revenue)
OVER()

cumulative

FROM product_sales
)

SELECT

*,

CASE

WHEN cumulative<=0.80 THEN 'A'

WHEN cumulative<=0.95 THEN 'B'

ELSE 'C'

END category

FROM abc;
-- Store Ranking
SELECT

o.store_id,

SUM(oi.price) sales,

RANK()
OVER(
ORDER BY SUM(oi.price) DESC
)

store_rank

FROM orders o join order_items oi 
on o.order_id=oi.order_id

GROUP BY o.store_id;


-- Revenue Per Employee
WITH revenue AS
(
SELECT
o.store_id,
SUM(oi.price) revenue
FROM orders o join order_items oi
on o.order_id= oi.order_id
GROUP BY o.store_id

),

emp AS
(
SELECT
store_id,
COUNT(*) employees
FROM employees
GROUP BY store_id
)

SELECT

r.store_id,

revenue,

employees,

ROUND(
revenue/employees,2
)

revenue_per_employee

FROM revenue r

JOIN emp e

ON r.store_id=e.store_id;
-- Top Supplier
SELECT

s.supplier_id,

SUM(p.price * oi.qty) revenue

FROM suppliers s

JOIN products p

ON s.supplier_id=p.supplier_id

JOIN order_items oi

ON p.product_id=oi.product_id

GROUP BY s.supplier_id

ORDER BY revenue DESC

LIMIT 10;

-- Highest Return Products
SELECT

r.return_id,

COUNT(*) total_returns

FROM returns r

JOIN order_items oi

ON r.order_item_id=oi.order_item_id



GROUP BY  r.return_id

ORDER BY total_returns DESC;

-- Return %

SELECT

ROUND(

COUNT(DISTINCT r.order_item_id)

/

COUNT(DISTINCT oi.order_item_id)

*100,2

)

return_percentage

FROM order_items oi

LEFT JOIN returns r

ON oi.order_item_id=r.order_item_id;

-- Revenue Contribution
SELECT
category_id,
revenue,
ROUND(
revenue/
SUM(revenue) OVER()*100,2
) contribution
FROM
(
SELECT
c.category_id,
SUM(oi.qty*oi.price) revenue
FROM order_items oi
JOIN products p
ON oi.product_id=p.product_id
JOIN categories c
ON p.category_id=c.category_id
GROUP BY c.category_id
)x;

-- LAST_VALUE


SELECT
    o.order_date,
    p.amount,
    LAST_VALUE(p.amount) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS last_payment
FROM payments p
JOIN orders o
    ON p.order_id = o.order_id;
    
    
-- Store Growth
SELECT

store_id,

YEAR(order_date) year,

MONTH(order_date) month,

SUM(total_amount) sales,

-- Store Ranking


LAG(

SUM(total_amount)

)

OVER(

PARTITION BY store_id

ORDER BY
YEAR(order_date),
MONTH(order_date)

)

previous_month_sales

FROM orders

GROUP BY
store_id,
YEAR(order_date),
MONTH(order_date);


-- Category Contribution %

SELECT

category_id,
revenue,
ROUND(
revenue/
SUM(revenue)
OVER()
*100,2)

contribution
FROM
(

SELECT
c.category_id,

SUM(oi.qty*oi.price) revenue

FROM categories c

JOIN products p

ON c.category_id=p.category_id

JOIN order_items oi

ON p.product_id=oi.product_id

GROUP BY c.category_id

)x;

-- Worst Revenue Month

SELECT

YEAR(o.order_date),

MONTH(o.order_date),

SUM(oi.price) revenue

FROM orders o join order_items oi 
on o.order_id=oi.order_id

GROUP BY
YEAR(o.order_date),
MONTH(o.order_date)

ORDER BY revenue

LIMIT 1;

-- Revenue Growth %
SELECT
o.order_date,
SUM(p.amount) revenue,

ROUND(
(
SUM(p.amount)
-
LAG(SUM(p.amount))
OVER(ORDER BY o.order_date)
)
/
LAG(SUM(p.amount))
OVER(ORDER BY o.order_date)
*100,2) growth_percent

FROM payments p join orders o 
on p.order_id= o.order_id
GROUP BY o.order_date;


-- Next Payment (LEAD)
SELECT
o.order_date,
p.amount,
LEAD(p.amount)
OVER(ORDER BY o.order_date) next_payment
FROM payments p join orders o 
on o.order_id=p.order_id ;