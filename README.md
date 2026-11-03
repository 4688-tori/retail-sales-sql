# retail-sales-sql
# Retail Sales & Customer Intelligence Using PostgreSQL

## 1. Project Overview

This project focuses on analysing retail sales and customer behaviour using PostgreSQL. It uses a fictional electronics retail dataset from Duka Smart Electronics to extract business insights, evaluate sales performance, understand customer purchasing patterns, and support data-driven decision-making.

The project demonstrates SQL skills ranging from basic data retrieval to advanced business intelligence using joins, aggregate functions, subqueries, Common Table Expressions (CTEs), window functions, views, and PL/pgSQL functions.

## 2. Project Objectives

- Analyse overall retail sales performance.
- Identify top-performing products and product categories.
- Evaluate customer purchasing behaviour and spending patterns.
- Analyse revenue and profitability across different locations.
- Identify inactive customers and opportunities for customer retention.
- Use advanced SQL techniques to generate business intelligence reports.

## 3. Tools and Technologies

- **Database:** PostgreSQL
- **Database Management Tool:** pgAdmin 4
- **Query Language:** SQL
- **Procedural Language:** PL/pgSQL
- **Version Control:** Git and GitHub

## 4. Dataset Description

The project uses a fictional retail electronics dataset consisting of two relational tables:

### Customers Table

Contains customer information, including:
- Customer ID
- Customer name
- Gender
- City
- Registration date
- Customer segment

### Orders Table

Contains sales transaction information, including:
- Order ID
- Customer ID
- Order date
- Product name
- Product category
- Quantity
- Unit price
- Cost price
- Discount
- Payment method
- Order status

**Dataset size:**
- 150 customers
- 800 orders

## 5. Database Setup and Installation

Follow these steps to recreate the database.

### Step 1: Create the database

Open pgAdmin 4 and create a PostgreSQL database named:

`retail_analytics`

Alternatively, run:

```sql
CREATE DATABASE retail_analytics;
```

Connect to the newly created database before proceeding.

### Step 2: Create the database tables

Open `schema.sql` in pgAdmin Query Tool and execute the script.

This creates the `customers` and `orders` tables.

### Step 3: Insert the dataset

Execute the customer and order insertion scripts in the following order, if available:

1. `03_insert_customers.sql`
2. `04_insert_orders.sql`

Ensure the tables are created before inserting records.

### Step 4: Verify the data

Execute `05_verify_data.sql` to confirm that the records have been inserted successfully.

Expected dataset counts:
- Customers: 150
- Orders: 800

### Step 5: Run the analysis queries

Open `queries.sql` in pgAdmin Query Tool and execute the queries.

The queries are numbered from Q1 to Q46 and organised according to the assignment sections.

## 6. SQL Analysis Covered

The project contains 46 SQL questions covering the following areas:

| Area | SQL concepts and analysis |
|---|---|
| Basic SQL | SELECT, WHERE, DISTINCT, ORDER BY, LIMIT |
| Aggregate Analysis | COUNT, SUM, AVG, MIN, MAX |
| Grouped Analysis | GROUP BY and HAVING |
| Joins | INNER JOIN and LEFT JOIN |
| Advanced Queries | Subqueries and CTEs |
| Window Functions | RANK, DENSE_RANK, ROW_NUMBER, LAG, NTILE |
| Business Intelligence | Views, PL/pgSQL functions and customer segmentation |
| Management Reporting | Top customers, top products and profitability analysis |

## 7. Business Insights

The analysis generated several important findings:

1. **Product Performance:** Mobile Phones generated the highest category revenue at KSh 6,942,060.65.
2. **Geographical Performance:** Nairobi recorded the highest completed-order revenue at KSh 9,581,980.35.
3. **Customer Segmentation:** VIP customers recorded the highest average spending at KSh 253,251.88 per purchasing customer.
4. **Product Profitability:** Accessories recorded the highest profit margin at approximately 42.39%.
5. **Customer Retention:** 47 customers had not made a completed purchase for more than 90 days as of 30 September 2026.
6. **Revenue Growth:** Monthly revenue increased by approximately 136.43% between January and February 2026.

Detailed findings, business implications and recommendations are documented in `insights.md`.

## 8. Repository Structure

```text
retail-sales-sql/
│
├── README.md
├── schema.sql
├── queries.sql
├── insights.md
│
└── screenshots/
    ├── 01_data_verification.png
    ├── 02_revenue_by_category.png
    ├── 03_top_customers.png
    ├── 04_monthly_revenue_growth.png
    └── 05_category_profitability.png
```

## 9. Author

**Victoria Suewama Ndei**

This project was developed as part of a practical SQL and database analytics learning exercise, demonstrating the application of PostgreSQL in retail sales analysis and business intelligence.
