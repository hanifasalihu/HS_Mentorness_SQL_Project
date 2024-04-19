# HS_Mentorness_SQL_Project

An internship project using SQL to analyse a sales dataset provided by Mentorness.

![image](https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/assets/157046638/001a94d9-df2f-4efe-be12-9ea78b24dc5c)


## Table of Content

- [ Project Overview](#project-overview)
- [ Purposes Of The Project](#purposes-of-the-project)
- [About Data](#about-data)
- [Process Workflow](Process-Workflow)
- [Data Preparation](Data-Preparation)
- [Exploratory Data Analysis Process](#exploratory-data-analysis-process)
- [Data Vizualization](#data-vizualization)
- [Recommendations](#recommendations)
- [Limitations](#limitations)
- [Conclusions](#conclusions)


## Project Overview

The sales dataset will be used to explore the relationships between various aspects of the business, show the data manipulated, analyzed, and formulate strategies for operational growth.
This sales data plays a pivotal role in driving informed decisions and optimizing processes in this company. 
PostgreSQL & PowerBI was used for analysis and visualization.


## Purposes Of The Project

This project aims to gain insight into the data, explore the sales data from customers, products, orders, and delivery personnel to uncover valuable insights, identify patterns and provide data-driven recommendations. 

## About Data

The dataset was obtained from the google link provided by Mentorness via email. The sales dataset comprises five interconnected tables:customer, delivery person, pincode, product & orders.

[Download Here]https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/blob/main/Mentorness-Sales_Dataset.xlsx


## Process Workflow

▪ Step 1: Data Collection & Preparation

▪ STEP 2: Data Exploration & Transformation

▪ Step 3: Analysis & Querying

▪ Step 4: Recommendation & Conclusion


 ## **Data Preparation:**  

▪ Create Database

▪ Create 5 tables, using queries

▪ Import data from MS Excel to PostgreSQL

▪ Analyze Data



## **Exploratory Data Analysis Process:** 
#### This is the aim of the project. To use questions to analyze the data. Commence Exploratory data analysis ( 19 questions was provided for analysis)


1.  How many customers do not have DOB information
2.  How many customers are there in each pincode and gender combination?
3.  Print product name and mrp for products which have more than 50000 MRP?
4.  How many delivery personal are there in each pincode?
5.  For each Pin code, print the count of orders, sum of total amount paid, average amount paid,
    maximum amount paid, minimum amount paid for the transactions which were paid by 'cash'. Take only 'buy' order types
6.  For each delivery_person_id, print the count of orders and total amount paid for product_id = 12350 or 12348 and total units > 8. Sort the output by total amount paid       in descending order. Take only 'buy' order        types
7.  Print the Full names (first name plus last name) for customers that have email on "gmail.com"?
8.  Which pincode has average amount paid more than 150,000? Take only 'buy' order types
9.  Create following columns from order_date data - Order_date, - Order day, - Order month, - Order year
10. How many total orders were there in each month and how many of them were returned? Add a column for return rate too.
    return rate = (100.0 * total return orders) / total buy orders.Hint: You will need to combine SUM() with CASE WHEN
11. How many units have been sold by each brand? Also get total returned units for each brand.
12. How many distinct customers and delivery boys are there in each state?
13. For every customer, print how many total units were ordered, how many units were ordered from their primary_pincode and how many were ordered not from the
    primary_pincode. Also calulate the percentage of total units which were ordered from primary_pincode(remember to multiply the numerator by 100.0).
    Sort by the percentage column in descending order.
14. For each product name, print the sum of number of units, total amount paid, total displayed selling price, total mrp of these units, 
    and finally the net discount from selling price.(i.e. 100.0 - 100.0 * total amount paid / total displayed selling price) &
    the net discount from mrp (i.e. 100.0 - 100.0 * total amount paid / total mrp).
15. For every order_id (exclude returns), get the product name and calculate the discount percentage from selling price. 
    Sort by highest discount and print only those rows where discount percentage was above 10.10%.
16. Using the per unit procurement cost in product_dim, find which product category has made the most profit in both absolute amount and percentage. Absolute Profit =           Total Amt Sold - Total Procurement. Cost          Percentage Profit = 100.0 * Total Amt Sold / Total Procurement Cost - 100.0
17. For every delivery person(use their name), print the total number of order ids (exclude returns) by month in separate columns
    i.e. there should be one row for each delivery_person_id and 12 columns for every month in the year.
18. For each gender - male and female - find the absolute and percentage profit (like in Q15) by product name
19. Generally the more numbers of units you buy, the more discount seller will give you.
    For 'Dell AX420' is there a relationship between number of units ordered and average discount from selling price? Take only 'buy' order types.


## SQL Queries

![image](https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/assets/157046638/27280120-00fc-400b-b9f7-8fe0c89631f5)

[Download Here](https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/blob/main/Mentorness_SalesDatabse_SQL_Query.sql)


### Data Vizualization
 *Check Presentation file also.
 ![Dashboard 01sql](https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/assets/157046638/0e49b366-910d-42e8-9425-27655905d830)
 ![Dashboard 02sql](https://github.com/hanifasalihu/HS_Mentorness_SQL_Project/assets/157046638/8708a8a8-e22e-47f6-a72b-a592620a2ce6)


### Recommendations

▪ Review product profitability data and identify most/least profitable products or categories.

▪ Analyze delivery personnel order volumes by month. Reallocate resources, adjust routes for efficiency, and plan staffing for peak periods.

▪ Identify high-value customers ordering from their primary Pin codes. Use them for loyalty programs, personalized promotions.


### Limitations

▪ Limited customer information like demographics, purchase history.

▪ Absence of external factors like economic conditions, seasonality, and market trends and purchasing behavior.

▪ Limited time period analysis, preventing identification of trends, patterns, and anomalies over different time frames.


### Conclusions

▪ Additional information to the dataset to enable personalized promotions and targeted marketing strategies.

▪ Incorporate competitor data, including product offerings, pricing, and market share information, to facilitate benchmarking and develop effective competitive strategies.

▪ Introduce time-based analysis to identify trends, patterns, over different time periods, enabling more informed decision-making and strategic planning.



