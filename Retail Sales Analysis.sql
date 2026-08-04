#Retail Sales Analysis

use product_order;

# A. Data Exploration

select * from `orders 4`;

select * from `product-supplier`;

select distinct(count(`Order ID`)) from `orders 4`;
#The orders 4 dataset contains 11999 records.

select distinct(count(`ï»¿Product ID`)) from `product-supplier`;
#The product-supplier dataset contains 5504 unique Products.

select min(str_to_date(`Date Order was placed`, '%d-%b-%y')) as Start_Date, max(str_to_date(`Date Order was placed`, '%d-%b-%y')) as End_Date from `orders 4`;
#The range of dataset is between 2017-01-01 to 2017-06-02.

select distinct(`Product Category`) from `product-supplier`;
#This dataset contains these different categories Children Outdoors Children Sports, Clothes, Shoes, Outdoors, Assorted Sports Articles, Golf, Indoor Sports, Racket Sports, 
#Running - Jogging, Swim Sports, Team Sports, Winter Sports etc.

select distinct(`Supplier Name`) from `product-supplier`;
#This dataset contains 64 Suppliers.

select * from `orders 4` where `ï»¿Customer ID` is null or `Customer Status` is null or `Date Order was placed` is null or `Delivery Date` is null or `Order ID` is null
or `Product ID` is null or `Quantity Ordered` is null or `Total Retail Price for This Order` is null or `Cost Price Per Unit` is null;
# No null values in orders 4 Table.

select * from `product-supplier` where `ï»¿Product ID` is null or `Product Line` is null or `Product Category` is null or `Product Group` is null or `Product Name` is null 
or `Supplier Country` is null or `Supplier Name` is null or `Supplier ID` is null;
#No null values in product-supplier Table.

select `Order ID`, count(*) as Duplicate_Count from `orders 4` group by `Order ID` having count(*) > 1;
#No duplicate Order IDs found

select pr.`ï»¿Product ID`, pr.`Product Name` from `product-supplier` pr left join `orders 4` o on pr.`ï»¿Product ID` = o.`Product ID` where o.`Product ID` is null; 
#From this dataset 2907 products are never ordered.

# B. Sales Analysis

select round(sum(`Total Retail Price for This Order`),2) from `orders 4`;
#Total sales are 147405.

select sum(`Quantity Ordered`) from `orders 4`;
#Total 17272 Quantity Sold.

select round(avg(`Total Retail Price for This Order`)) as Average_Order_Value from `orders 4`;
#Average Order Value is 122.

select round(max(`Total Retail Price for This Order`)) as Highest_Order_Value from `orders 4`;
#Highest Order Value is 3496.

select round(min(`Total Retail Price for This Order`)) as Lowest_Order_Value from `orders 4`;
#Lowest Order Value is 1. 

select monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_name, round(sum(`Total Retail Price for This Order`)) as sales from `orders 4`
group by monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')), month(str_to_date(`Date Order was placed`, '%d-%b-%y'))
order by month(str_to_date(`Date Order was placed`, '%d-%b-%y'));
#Monthly sales are accodingly 286773, 239349, 224319, 319439, 376750, 20779 for six months from January to june.

with a as (select monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_name, month(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_no, 
round(sum(`Total Retail Price for This Order`)) as sales from `orders 4`
group by monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')), month(str_to_date(`Date Order was placed`, '%d-%b-%y')))
select month_name, sales, coalesce(lag(sales) over(order by month_no),0) as Previous_Month_Sales, 
round(coalesce(((sales - lag(sales) over(order by month_no)) / lag(sales) over(order by month_no)) * 100,0),2) as MoM_Growth_Percentage from a 
order by month_no;
#This query shows MoM over Growth. 

select month_name, month_no, sales, sum(sales) over(order by month_no) as cumulative_sales
from (select  monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_name, month(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_no, 
sum(`Total Retail Price for This Order`) as sales from `orders 4` group by month_name, month_no) as monthly_data;
#Cumulative Sales of Every month. 

select `Customer Status`, round(sum(`Total Retail Price for This Order`),2) as sales, 
round(sum(sum(`Total Retail Price for This Order`)) over(order by sum(`Total Retail Price for This Order`)),2) as cumulative_sales from `orders 4`
group by `Customer Status` order by sales;
#Cumulative sales by Customer Status.

# C. Product Analysis

select pr.`Product Name`, round(sum(o.`Total Retail Price for This Order`),2) as sales from `orders 4` o join `product-supplier` pr
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by sales desc limit 10;
#Top 10 Products by sales.

select pr.`Product Name`, sum(o.`Quantity Ordered`) as Quantity_Sold from `orders 4` o join `product-supplier` pr
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by Quantity_Sold desc limit 10;
#Top 10 Products by quantity sold.

select pr.`Product Name`, round(sum(o.`Total Retail Price for This Order`),2) as sales from `orders 4` o
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by sales limit 10;
#Bottom 10 products by sales.

select pr.`Product Category`, round(sum(o.`Total Retail Price for This Order`),2) as sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Category`;
#Sales by product category. 

select pr.`Product Name`, round(avg(o.`Total Retail Price for This Order`),2) as Avg_sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name`;
#Average sales per product.

select pr.`Product Name`, round(sum(o.`Total Retail Price for This Order`),2) as Revenue from `orders 4` o
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by Revenue desc limit 1;
#Family Holiday 4 generated the highest revenue. 

select pr.`Product Name`, round(sum(o.`Total Retail Price for This Order`),2) as Revenue from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by Revenue limit 1;
#Gray Latex Children's Swim Cap generated the lowest revenue.

select pr.`Product Name`, sum(o.`Quantity Ordered`) as Quantity from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` having Quantity > 100;
#No single product was ordered more than 100 times. 

select pr.`Product Name` from `product-supplier` pr left join `orders 4` o on o.`Product ID` = pr.`ï»¿Product ID` 
where o.`Product ID` is null;
#Products with no sales. 

select pr.`Product Name`, round(sum(o.`Total Retail Price for This Order`),2) as Sales, dense_rank() over(order by round(sum(o.`Total Retail Price for This Order`),2) desc) as rnk
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name`;
#Rank products by sales. 

# D. Supplier Analysis

select pr.`Supplier Name`, round(sum(`Total Retail Price for This Order`),2) as sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`;
#Sales by Suppliers. 

select pr.`Supplier Name`, sum(o.`Quantity Ordered`) as Quantity from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`;
#Quantity sold by supplier. 

select pr.`Supplier Name`, round(avg(o.`Total Retail Price for This Order`),2) as Avg_sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`;
#Average sales by supplier. 

select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as Sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name` order by Sales desc limit 5;
#Top 5 suppliers by revenue. 

select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as Sales from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name` order by Sales limit 5;
#Bottom 5 suppliers by revenue. 

select pr.`Supplier Name`, count(pr.`ï»¿Product ID`) as Total_Products from `product-supplier` pr group by pr.`Supplier Name`
order by Total_Products desc limit 1;
#Supplier with the most products. 

with a as (select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as sales from `orders 4` o join 
`product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`) 
select `Supplier Name`, sales, concat(round((sales * 100) / sum(sales) over(),2),'%') as contribution from a;
#Supplier contribution to total sales. 

select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as sales, dense_rank() over(order by round(sum(o.`Total Retail Price for This Order`),2)desc) as rnk 
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`;
#Suppliers rank by sales. 

select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as Sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name` having sum(o.`Total Retail Price for This Order`) > 
(select avg(Sales) from 
( select  sum(o.`Total Retail Price for This Order`) as Sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`) as avg_sales );
#Suppliers with total sales above the average sales across all suppliers. 

select pr.`Product Category`, pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as Sales, sum(o.`Quantity Ordered`) as Quantity
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Category`, pr.`Supplier Name` 
order by pr.`Product Category`, Sales desc;
#Compare supplier performance across product categories based on sales and Quantity sold. 

# E. Customer Analysis 

select count(distinct `ï»¿Customer ID`) from `orders 4`;
#Total 9814 unique customers. 

select `ï»¿Customer ID`, round(sum(`Total Retail Price for This Order`),2) as sales from `orders 4` group by `ï»¿Customer ID` order by sales desc limit 10;
#Top 10 customers by spending. 

select `ï»¿Customer ID`, count(distinct `Order ID`) as orders from `orders 4` group by `ï»¿Customer ID` having count(distinct `Order ID`) > 5 order by orders desc;
#Customers with more than 5 orders. 

select `ï»¿Customer ID`, round(sum(`Total Retail Price for This Order`),2) as spending, round(avg(`Total Retail Price for This Order`),2) 
from `orders 4` group by `ï»¿Customer ID`;
#Average spend per customer. 

select `Customer Status`, count(distinct `ï»¿Customer ID`) as customers from `orders 4` group by `Customer Status` order by customers desc;
#Customer status distribution. 

select case when orders = 1 then 'New Customer'
		    else 'Repeat Customer'
            end as customer_type,
count(*) as customers from (
select `ï»¿Customer ID`, count(distinct `Order ID`) as orders from `orders 4` group by `ï»¿Customer ID`) t
group by customer_type;
#Repeat Customers - 1783, New Customers - 8031

select `ï»¿Customer ID`, `Order ID`, `Total Retail Price for This Order` as order_value from `orders 4`
order by `Total Retail Price for This Order` desc limit 1;
#Customer with the highest order value 

select month(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month, count(distinct `ï»¿Customer ID`) as active_customers from `orders 4`
group by month(str_to_date(`Date Order was placed`, '%d-%b-%y')) order by month;
#Monthly active customers 

select `ï»¿Customer ID`, sum(`Total Retail Price for This Order`) as lifetime_sales from `orders 4` 
group by `ï»¿Customer ID` order by lifetime_sales desc;
#Customer lifetime sales

select `ï»¿Customer ID`, round(sum(`Total Retail Price for This Order`),2) as spending, dense_rank() over(order by round(sum(`Total Retail Price for This Order`),2)desc) as rnk 
from `orders 4` group by `ï»¿Customer ID`;
#Rank customers by total spending

# F. Profit Analysis

select `Order ID`, `ï»¿Customer ID`, `Total Retail Price for This Order`, round((`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit
from `orders 4`;
#Profit for each order 

select round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as Profit from `orders 4`;
#Total profit was 781733.28.  

select pr.`Product Category`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Category` order by profit desc;
#Profit by each category

select pr.`Supplier Name`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit 
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by `Supplier Name` order by profit desc;
#Profit by each supplier 

select pr.`Product Name`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` *`Quantity Ordered`),2) as profit 
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by profit desc limit 10;
#Top 10 most profitable products 

select pr.`Product Name`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit
from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by profit;
#Least profitable products 

select pr.`Product Name`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`) / sum(`Total Retail Price for This Order`) * 100, 2)
as profit_margin from `orders 4` o join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` order by profit_margin desc;
#Profit Margin by products

select month(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit
from `orders 4` group by month(str_to_date(`Date Order was placed`, '%d-%b-%y')) order by month;
#Monthly profit trend

select round(avg(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as avg_profit 
from `orders 4`;
#Average profit per order

select pr.`Product Name`, round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) as profit,
dense_rank() over(order by round(sum(`Total Retail Price for This Order` - `Cost Price Per Unit` * `Quantity Ordered`),2) desc) as rnk from `orders 4` o 
join `product-supplier` pr on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name`;
#Rank products by profit

# G. Advanced SQL

select pr.`Product Name`, round(sum(`Total Retail Price for This Order`),2) as sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name` having sum(`Total Retail Price for This Order`) > 
(select avg(sales) from
(select sum(`Total Retail Price for This Order`) as sales from `orders 4` group by `Product ID`)t );
#Products with sales above the average

select pr.`Supplier Name`, round(sum(o.`Total Retail Price for This Order`),2) as sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name` having sum(o.`Total Retail Price for This Order`) > 
(select avg(sales) from 
(select sum(o.`Total Retail Price for This Order`) as sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Supplier Name`)t );
#Suppliers whose sales exceed the company average

select monthname(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_name, sum(`Total Retail Price for This Order`) as monthly_sales,
sum(sum(`Total Retail Price for This Order`)) over(order by month(str_to_date(`Date Order was placed`, '%d-%b-%y')))as running_total
from `orders 4` group by month(str_to_date(`Date Order was placed`, '%d-%b-%y')), monthname(str_to_date(`Date Order was placed`, '%d-%b-%y'));
#Running totals of sales

select month_no, sales, round(coalesce(lag(sales) over(order by month_no),0),2) as previous_month_sales from (
select month(str_to_date(`Date Order was placed`, '%d-%b-%y')) as month_no, round(sum(`Total Retail Price for This Order`),2) as sales
from `orders 4` group by month(str_to_date(`Date Order was placed`, '%d-%b-%y')))t;
#Previous month's sales using LAG()

select * from (
select `ï»¿Customer ID`, `Order ID`, (str_to_date(`Date Order was placed`, '%d-%b-%y'))as order_date, 
row_number() over(partition by `ï»¿Customer ID` order by (str_to_date(`Date Order was placed`, '%d-%b-%y'))) as rn
from `orders 4`) t where rn=1;
#First order for each customer

select * from (
select `ï»¿Customer ID`, `Order ID`, (str_to_date(`Date Order was placed`, '%d-%b-%y'))as order_date, 
row_number() over(partition by `ï»¿Customer ID` order by (str_to_date(`Date Order was placed`, '%d-%b-%y'))desc) as rn
from `orders 4`) t where rn=1;
#Last order for each customer

with a as(select pr.`Product Name`, round(sum(`Total Retail Price for This Order`),2) as sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Name`)
select * from
(select `Product Name`, sales, dense_rank() over(order by sales desc) as rnk from a)t where rnk = 2;
#The second highest selling product is Family Holiday 6.

with a as (select pr.`Product Category`, pr.`Product Name`, round(sum(`Total Retail Price for This Order`),2) as sales from `orders 4` o join `product-supplier` pr 
on o.`Product ID` = pr.`ï»¿Product ID` group by pr.`Product Category`, pr.`Product Name`)
select * from
(select `Product Category`, `Product Name`, sales, dense_rank() over(partition by `Product Category` order by sales desc) as rnk from a)t where rnk = 1;
#Top selling product in each category

select `Order ID`,`Total Retail Price for This Order`,
          case when `Total Retail Price for This Order` >= 1000 then 'High'
               when `Total Retail Price for This Order` >= 500 then 'Medium'
               else 'Low'
               end as order_category
from `orders 4`;
#Categorize orders as High, Medium or Low value using CASE.



