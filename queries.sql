
-- Q1 retrieve all customer records
select * from customers;
-- Q2 Display customer names, cities, and segments
select customer_name, gender, city,customer_segment
from customers;
-- Q3 Find customers living in nairobi
select customer_id,customer_name,city 
from customers
where city ='Nairobi';
--Q4Find customers registered after January1,2025
select customer_id,customer_name,registration_date
from customers
where registration_date > '2025-01-01';
--Q5 Display all unique customer cities
select distinct city
from customers
order by city;
--Q6 Retrieve the 10 most orders
select order_id,order_date,product_category,product_name
from orders 
order by order_date desc
limit 10;
--Q7 Find orders with unit prices above 10000
select order_id,order_date,product_name,product_category,unit_price
from orders
where unit_price >'10000'
limit 10 ;
--Q8 Find customers whose  names start with A
select customer_id,customer_name 
from customers
where customer_name like 'A%';
--Q9 Retrieve ordrers wth quantity between 2 and 5
select order_id,product_name,product_category,quantity
from orders
where quantity between 2 and 5 
limit 20;
--Q10 Find orders paid through M-Pesa
select order_id,customer_id,product_name,product_category,payment_method
from orders
where payment_method ='M-Pesa'
limit 20;
--Q11 Count all customers
select count(*) as total_customers from customers;
--Q12 Count all orders
select count(*) as total_orders from orders;
--Q13 Calculate the complete-order revenue

select
    round(
        sum(quantity * unit_price * (1 - discount / 100)),
        2
    ) as total_revenue
from orders
where order_status = 'Completed';
--Q14Calculate the average completed_order revenue
select order_id,
    round(
        avg(quantity * unit_price * (1 - discount / 100)),
        2
    ) as total_revenue
from orders
where order_status = 'Completed'
group by order_id
order by total_revenue desc
limit 20;
--Q15 Find the highest and lowest product prices
select 
    max(unit_price) as highest_price,
    min(unit_price) as lowest_price
from orders;
--Q16 Calculate revenue by product category
select
    product_category,
    ROUND(sum(quantity * unit_price * (1 - discount / 100)), 2)
    as total_revenue
from orders
where order_status = 'Completed'
group by product_category
order by total_revenue desc;
--Q17 count customer by city
select customer_id, customer_name,city,
count(*) as total_customers
from customers
group by city, customer_id
order by total_customers desc
limit 20;
--Q18 Calculate quantity sold by product
select
   order_id, product_name,
    sum(quantity) as total_quantity_sold
from orders
where order_status = 'Completed'
group by product_name,order_id
order by total_quantity_sold desc;
--Q19 Find categories generating more than KSh 100000 in revenue
select
    order_id,product_category,
    ROUND(sum(quantity * unit_price * (1 - discount / 100)), 2)
    as total_revenue
from orders
where order_status = 'Completed'
group by product_category,order_id
having sum(quantity * unit_price * (1 - discount / 100)) > 100000
order by total_revenue desc
limit 20;
--Q20 Calculate the percentage of cancelled orders
select 
    round(
        count(*) filter (where order_status = 'Cancelled') * 100.0
        / count(*),
        2
    ) as cancelled_order_percentage
from orders;
--	Q21 Display orders with customer name and cities
select
    o.order_id,
    c.customer_name,
    c.city,
    o.product_name,
    o.product_category,
    o.order_date
from orders o
inner join customers c
    on o.customer_id = c.customer_id;
--Q22 calculate total spending by customer
select
    c.customer_id,
    c.customer_name,
    ROUND(
        sum(o.quantity * o.unit_price * (1 - o.discount / 100)),
        2
    ) as total_spending
from customers c
inner join orders o
    on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name
order by  total_spending desc;
--Q23 Identify customers who have never ordered
select
    c.customer_id,
    c.customer_name,
    c.city
from customers c
left join orders o
    on  c.customer_id = o.customer_id
where o.order_id is null;
--Q24 Find the 10-highest spending customers
select 
    c.customer_id,
    c.customer_name,
    ROUND(
        sum(o.quantity * o.unit_price * (1 - o.discount / 100)),
        2
    ) as total_spending
from customers c
inner join orders o
    on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name
order by total_spending desc
limit 10;
--Q25 Calculate revenue by customer city
select 
    c.customer_id,c.customer_name,c.city,
    ROUND(
        sum(o.quantity * o.unit_price * (1 - o.discount / 100)),
        2
    ) as total_revenue
from customers c
inner join orders o
    on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by  c.city,c.customer_id
order by total_revenue desc;
--Q26 Identify customers with more than 5 orders
select
    c.customer_id,
    c.customer_name,
    count(o.order_id)as total_orders
from customers c
inner join orders o
    on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having count(o.order_id) > 5
order by total_orders desc;
--Q27 Calculate average customer spending by segment
with customer_spending as (
    select
        c.customer_id,
        c.customer_name,
        c.customer_segment,
        sum(o.quantity * o.unit_price * (1 - o.discount / 100)) as total_spending
    from customers c
    inner join orders o
        on c.customer_id = o.customer_id
    where o.order_status = 'Completed'
    group by c.customer_id, c.customer_name, c.customer_segment
)
select
    customer_segment,
    ROUND(avg(total_spending), 2) as average_customer_spending
from customer_spending
group by customer_segment
order by average_customer_spending desc;
--Q28 Identify the most popular category among VIP customers
select
    o.product_category,
   sum(o.quantity) as total_quantity_sold
from customers c
inner join orders o
    on c.customer_id = o.customer_id
where c.customer_segment = 'VIP'
  and o.order_status = 'Completed'
group by o.product_category
order by total_quantity_sold desc
limit 1;
--Q29 Find customer spending above the average total spending per purchasing customer
with customer_spending as (
    select 
        c.customer_id,
        c.customer_name,
        sum(o.quantity * o.unit_price * (1 - o.discount / 100)) AS total_spending
    from customers c
    inner join orders o
        on c.customer_id = o.customer_id
    where o.order_status = 'Completed'
    group by c.customer_id, c.customer_name
)
select
    customer_id,
    customer_name,
    ROUND(total_spending, 2) as total_spending
from customer_spending
where total_spending > (
    select avg(total_spending)
    from customer_spending
)
order by  total_spending desc;
--Q30Find products priced above the overall average unit price
SELECT
    product_name,
    unit_price
FROM orders
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM orders
)
ORDER BY unit_price DESC;
--Q31
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS total_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue
FROM monthly_revenue
ORDER BY total_revenue DESC
LIMIT 3;
--Q32Find customers purchasing from at least three categories
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.product_category) AS categories_purchased
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.product_category) >= 3
ORDER BY categories_purchased DESC;
--Q33Use a CTE to calculate category revenue, cost, profit, and profit margin
WITH category_performance AS (
    SELECT
        product_category,
        SUM(quantity * unit_price * (1 - discount / 100)) AS revenue,
        SUM(quantity * cost_price) AS total_cost
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT
    product_category,
    ROUND(revenue, 2) AS total_revenue,
    ROUND(total_cost, 2) AS total_cost,
    ROUND(revenue - total_cost, 2) AS total_profit,
    ROUND(
        (revenue - total_cost) / NULLIF(revenue, 0) * 100,
        2
    ) AS profit_margin_percentage
FROM category_performance
ORDER BY total_profit DESC;
--Q34Find customers whose latest completed order is more than 90 days before the latest order date in the dataset
WITH latest_dataset_date AS (
    SELECT MAX(order_date) AS latest_date
    FROM orders
),
customer_latest_order AS (
    SELECT
        customer_id,
        MAX(order_date) AS latest_completed_order
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_name,
    clo.latest_completed_order,
    ldd.latest_date,
    ldd.latest_date - clo.latest_completed_order AS days_since_last_order
FROM customer_latest_order clo
INNER JOIN customers c
    ON clo.customer_id = c.customer_id
CROSS JOIN latest_dataset_date ldd
WHERE ldd.latest_date - clo.latest_completed_order > 90
ORDER BY days_since_last_order DESC;
--Q35Rank customers by spending using RANK()
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS total_spending
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending
ORDER BY spending_rank;
--Q36Number each customer's orders by recency using ROW_NUMBER()
SELECT
    customer_id,
    order_id,
    order_date,
    order_status,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date DESC, order_id DESC
    ) AS order_number
FROM orders
ORDER BY customer_id, order_number;
--Q37Rank products within categories using DENSE_RANK()
WITH product_revenue AS (
    SELECT
        product_category,
        product_name,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS total_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category, product_name
)
SELECT
    product_category,
    product_name,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY product_category
        ORDER BY total_revenue DESC
    ) AS product_rank
FROM product_revenue
ORDER BY product_category, product_rank;
--Q38 Calculate cumulative monthly revenue
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (ORDER BY sales_month),
        2
    ) AS cumulative_revenue
FROM monthly
ORDER BY sales_month;
--Q39Compare monthly revenue using LAG()
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        LAG(monthly_revenue) OVER (ORDER BY sales_month),
        2
    ) AS previous_month_revenue
FROM monthly
ORDER BY sales_month;
--Q40Calculate month-over-month revenue growth (%)
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(quantity * unit_price * (1 - discount / 100.0)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
),
monthly_comparison AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY sales_month) AS previous_month_revenue
    FROM monthly
)
SELECT
    sales_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS growth_percentage
FROM monthly_comparison
ORDER BY sales_month;
--Q41Divide customers into four spending groups using NTILE(4)
WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS total_spending
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_group
FROM customer_spending
ORDER BY spending_group, total_spending DESC;
--Q42Calculate each category's share of total revenue using window functions
SELECT
    product_category,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS category_revenue,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0))
        / NULLIF(
            SUM(SUM(quantity * unit_price * (1 - discount / 100.0))) OVER (),
            0
        ) * 100,
        2
    ) AS revenue_share_percentage
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY category_revenue DESC;
--43Create and query the monthly sales summary view
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT
    DATE_TRUNC('month', order_date)::DATE AS sales_month,
    COUNT(*) AS total_orders,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100.0)), 2) AS revenue,
    ROUND(SUM(quantity * cost_price), 2) AS total_cost,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0))
        - SUM(quantity * cost_price),
        2
    ) AS profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)::DATE;

-- Select from the view
SELECT *
FROM monthly_sales_summary
ORDER BY sales_month;
--Q44Create a function to calculate a customer's revenue
CREATE OR REPLACE FUNCTION get_customer_revenue(p_customer_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    customer_revenue NUMERIC;
BEGIN
    SELECT COALESCE(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        0
    )
    INTO customer_revenue
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN customer_revenue;
END;
$$;

-- Test with an existing customer ID
SELECT get_customer_revenue(33);

-- Test with a customer ID that does not exist
SELECT get_customer_revenue(9999);
-- Q45: Segment customers based on total completed-order spending

WITH customer_spending AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COALESCE(
            SUM(
                o.quantity * o.unit_price * (1 - o.discount / 100.0)
            ),
            0
        ) AS total_spending
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
       AND o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN total_spending >= 250000 THEN 'High Value'
        WHEN total_spending >= 90000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment
FROM customer_spending
ORDER BY total_spending DESC;
-- Q46A: Top five customers by total spending

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)),
        2
    ) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 5;
-- Q46B: Top five products by revenue

SELECT
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(
        SUM(quantity * unit_price * (1 - discount / 100.0)),
        2
    ) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 5;
-- Q46C: Most profitable product category

SELECT
    product_category,
    ROUND(
        SUM(
            quantity * unit_price * (1 - discount / 100.0)
        ) - SUM(quantity * cost_price),
        2
    ) AS total_profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY total_profit DESC
LIMIT 1;
-- Q46D: Lowest-revenue month

SELECT
    sales_month,
    total_orders,
    revenue,
    total_cost,
    profit
FROM monthly_sales_summary
ORDER BY revenue ASC
LIMIT 1;