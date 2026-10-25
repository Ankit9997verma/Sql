--  cte

WITH category_stats AS (
    SELECT 
         p.category_id,
         SUM(oi.quantity * oi.unit_price) as Category_sales
    FROM order_items as oi
    LEFT JOIN products as p ON p.product_id = oi.product_id 
    GROUP BY p.category_id     
)
SELECT 
     c.category_name,
     category_stats.category_sales
 from category_stats
LEFT JOIN categories as c ON  c.category_id = category_stats.category_id;

--  cte provides clearity while reading 

with category_stats AS(
SELECT p.category_id , SUM(oi.quantity * oi.unit_price) AS category_sales
    FROM order_items as oi
      LEFT JOIN products as  p ON p.product_id = oi.product_id
      GROUP BY p.category_id 
),
hsc AS(
    SELECT * from category_stats
    ORDER BY category_sales DESC
    LIMIT 1
)
SELECT c.category_name ,
hsc.category_sales
 from hsc
LEFT JOIN categories as c ON c.category_id = hsc.category_id;

--  reusability using cte 
--  give me the total spend of a customer 
--  also give me average spend of all customer /
-- Also  give me flag true or flase basis of if the customer have above average spending  
-- have above average spending 

select * from customers;
select * from categories;
select * from products;
select * from orders;
select * from order_items;


with customer_total AS (
select 
      o.customer_id,
      SUM(oi.quantity * oi.unit_price) as customer_spend
    from orders as o
left join order_items as oi on oi.order_id =o.order_id
WHERE o.status = 'completed'
GROUP BY o.customer_id
)
SELECT 
      ct.customer_id , 
      ct.customer_spend,
      (SELECT ROUND(AVG(customer_spend),2) FROM customer_total),
      ct.customer_spend > (SELECT ROUND(AVG(customer_spend),2) FROM customer_total)
 FROM customer_total as ct;


-- subquery version of the above part 
SELECT
    ct.customer_id,
    ct.customer_spend,
    (SELECT ROUND(AVG(customer_spend), 2)
     FROM (
         SELECT
             o.customer_id,
             SUM(oi.quantity * oi.unit_price) AS customer_spend
         FROM orders AS o
         LEFT JOIN order_items AS oi
             ON oi.order_id = o.order_id
         WHERE o.status = 'completed'
         GROUP BY o.customer_id
     ) AS customer_total
    ) AS avg_customer_spend,

    ct.customer_spend > (
        SELECT ROUND(AVG(customer_spend), 2)
        FROM (
            SELECT
                o.customer_id, 
                SUM(oi.quantity * oi.unit_price) AS customer_spend
            FROM orders AS o
            LEFT JOIN order_items AS oi
                ON oi.order_id = o.order_id
            WHERE o.status = 'completed'
            GROUP BY o.customer_id
        ) AS customer_total
    ) AS spends_above_average

FROM (
    SELECT
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS customer_spend
    FROM orders AS o
    LEFT JOIN order_items AS oi
        ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
    GROUP BY o.customer_id
) AS ct;

--  now we understand using eindow aggregate funtion 
--  why ?
--  because aggregate gunctioon works on reducing the table regardless of thinking aboud the other cloumn of tsb;r
--  exam 

--  give me a totat product's proce sum on catorgory level 

SELECT 
category_id ,
SUM(price) as product_sum 
from products GROUP by category_id ;
--  IN THE ABOVE Example  we are using aggregate function 

--  window function 

SELECT 
      *,
      SUM(price) OVER (partition by category_id) as category_total_price
FROM products;     

--  without effecting or reducing the table structure 
--  givr me average price across all the products 

SELECT *,
AVG(PRICE) OVER () as avg_price 
 FROM products;



--  RANK vs dense rank 

SELECT
    product_name,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS prod_row_num,
    RANK() OVER (ORDER BY price DESC) AS prod_rank,
    DENSE_RANK() OVER (ORDER BY price DESC) AS prod_dense_rank
FROM products;

-- 
--  gve me the list of all human across all table  tha are there inside the community 

SELECT first_name, last_name
FROM employees

UNION ALL

SELECT first_name, last_name
FROM customers;

--  id duplicate allow use the above one 
-- if not use union 
SELECT first_name, last_name
FROM employees

UNION

SELECT first_name, last_name
FROM customers;
