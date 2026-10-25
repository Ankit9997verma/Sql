--  give me all customers who did not place any orders 

SELECT 
C.CUSTOMER_ID,
c.first_name,
c.last_name,
c.email,
o.status
from customers AS c
LEFT JOIN orders as o ON o.customer_id = c.customer_id
WHERE o.status IS NULL ;

--  give me orders which is not gets paid 

SELECT * from orders as o
LEFT join payments as p ON p.order_id = o.order_id
WHERE p.status IS NULL ;


select * from orders;
select * from order_items ; 
select * from products ;
select * from customers;
select * from categories;
--  give information about the all orders thst are there in the db
--  include   info about order_items , products , customer , category the products belongs to .

SELECT 
   o.order_id ,
   o.status,
   oi.product_id,
   oi.unit_price,
   p.product_name ,
   p.price ,
   c.category_name,
   cu.first_name
 from orders as o
 LEFT JOIN order_items as oi ON oi.order_id = o.order_id
 LEFT JOIN products as p ON p.product_id = oi.product_id
 LEFT JOIN categories as c ON c.category_id = p.category_id
 LEFT JOIN customers as cu ON cu.customer_id = o.customer_id 

--  give the infoabout the employees including their manager's info 
select * from employees;
SELECT 
emp.first_name as "Employee first name ",
emp.last_name as " emp last name ",
manager_tbl.first_name as "Mnager first name ",
manager_tbl.last_name as "Manager last name "
 from employees as emp 
left join employees as manager_tbl on emp.manager_id = manager_tbl.employee_id ; 

--  db aggregation 

--  give me total customer on our platform .

SELECT
     COUNT(*) as cust_cnt,
     COUNT(phone) AS cust_with_phone_number
       
from customers;

SELECT COUNT(DISTICT country) from customers;

-- total revenue of company 

SELECT 
      order_item_id,
      quantity,
      unit_price,
      quantity * unit_price as total_selling_value

from order_items;

SELECT SUM(quantity * unit_price) from order_items;

--  give average price of product acoss all products .

SELECT ROUND(AVG(price),2 )as avg_price
 FROM products;

--  GIve min and max price across products 

SELECT * from products ORDER BY price ;

SELECT MIN(price) as min_price , MAX(price) as max_price from products ; 

-- gropu by and having 
--  give me tota number of products in each category 

SELECT * from products ORDER BY category_id ; 

SELECT category_id , COUNT(*) from products
GROUP BY category_id ;

--  give me total number of active and inactive product in each categtrty 


SELECT category_id ,is_active, COUNT(*)
FROM products 
GROUP BY category_id, is_active;


--  give me the total number of products in each category 
--  include category name in the results 

SELECT 
      p.category_id ,
      c.category_name , COUNT(*)
FROM products as p 
LEFT JOIN categories as c on c.category_id = p.category_id
GROup BY p.category_id , c.category_name;      

-- give me total number of products in each category
--  and give me having > 5 products 

SELECT category_id , COUNT(*) FROM products
GROUP BY category_id
HAVING COUNT(*) > 5;

-- find departments having more than one employee 
--  where their combined salary of whole department exceeds 200000 rs.

SELECT * from departments ;
SELECT * FROM employees;

SELECT 
     department_id,
     COUNT(*),
     SUM(salary) as total_dep_salery
  from employees
  GROUP BY department_id
  Having count(*) > 1 AND SUM(salary) > 200000;


-- find departments having more than one managed employee 
--  where their combined salary of whole department exceeds 200000 rs.

SELECT 
     department_id,
     COUNT(*),
     SUM(salary) as total_dep_salery
  from employees
  where manager_id IS NOT NULL 
  GROUP BY department_id
  Having count(*) > 1 AND SUM(salary) > 200000;

-- give me all the customer having at least one cancelled order 

select * from customers;
select * from order_items;
select * from orders ;


SELECT * FROM customers as c 
LEFT JOIN orders as o ON o.customer_id = c.customer_id
WHERE o.status ='cancelled';


select o.customer_id , count(*) AS cancelled_orders
from orders as o
where o.status= 'cancelled'
GROUP BY o.customer_id
having count(*) >= 1;

-- if geeting hardcodind that customer is cancelled 
--  but gets wrong if a new data for cancelled get adding 

SELECT * FROM customers
WHERE customer_id IN(7, 9 ,18);

select customer_id from orders WHERE status ='cancelled';

-- sub-query ...

SELECT * FROM customers
WHERE customer_id IN(
    select customer_id from orders WHERE status ='cancelled'
);

-- give me all the products which are having price > averrage price across all products

select * from products;

Select product_id,product_name , price from products
where price >=(
      Select Round(AVG(price),3) as avg
       from products 
);

--  give me revenue sales in ccategory levels 
select * from categories;
select * from products ;
select * from orders;
select * from order_items ;

select 
      p.category_id,
      SUM(oi.quantity * oi.unit_price) as category_sales
 from order_items as oi 
LEFT JOIN products as p ON p.product_id = oi.product_id
GROUP BY p.category_id
Having SUM(oi.quantity * oi.unit_price) > 500;


-- gainving the above question haveing average sales > 5000
--  can be done by using having 
--  but we are using subquery 

select * from (
    select 
      p.category_id,
      SUM(oi.quantity * oi.unit_price) as category_sales
 from order_items as oi 
LEFT JOIN products as p ON p.product_id = oi.product_id
GROUP BY p.category_id

)
where category_sales >=500;

--  also add category name 

select * from (
    select 
      p.category_id stat_id,
      SUM(oi.quantity * oi.unit_price) as category_sales
 from order_items as oi 
LEFT JOIN products as p ON p.product_id = oi.product_id
GROUP BY p.category_id
) as category_stats
LEFT join categories as c on c.category_id = category_stats.stat_id
where category_sales >=500;
 