select * from customer_sales_python_clean_file;


SELECT gender , sum(purchase_amount) as total_revenue from customer_sales_python_clean_file GROUP BY gender; -- Q1

select customer_id, purchase_amount from customer_sales_python_clean_file where discount_applied = 'Yes' and purchase_amount >= (
  SELECT AVG ( purchase_amount) fromcustomer_sales_python_clean_file);  -- Q2
  
  select item_purchased , round(AVG (review_rating) , 2 ) as Avg_RAting from customer_sales_python_clean_file GROUP BY item_purchased ORDER
  BY Avg_RAting DESC  LIMIT 5; -- Q3
  
  SELECT shipping_type , round(AVG(purchase_amount) , 2 ) as shipping_avg  from customer_sales_python_clean_file
  where shipping_type in ('Standard' , 'Express') GROUP BY shipping_type;  -- Q4
  
  SELECT subscription_sta ,  COUNT(customer_id) as count_customers , 
  round(AVG(purchase_amount) , 2) AS avg_subs ,  sum(purchase_amount) as total_revenue from customer_sales_python_clean_file
  GROUP BY  subscription_sta ORDER BY total_revenue DESC ;  -- Q5
  
  select item_purchased  , round(100.0 * sum(case when discount_applied = 'Yes' then 1  else 0 end ) / count(*) , 2 )
  as discount_apply  from customer_sales_python_clean_file  GROUP BY  item_purchased ORDER BY discount_applied LIMIT 5 ;  -- Q6
                                                                               
WITH segmented AS (SELECT customer_id, CASE WHEN previous_purchas <= 3 THEN 'New'WHEN previous_purchas <= 15 THEN 'Returning'
ELSE 'Loyal' END AS customer_segment FROM customer_sales_python_clean_file) SELECT customer_segment, COUNT(*) AS number_of_customers
FROM segmented GROUP BY customer_segment;  -- Q7

with item_numbers as (SELECT item_purchased , category , COUNT(customer_id)as customer_count ,  RANK()OVER (PARTITION BY category 
ORDER BY COUNT(customer_id) DESC) AS rank_category FROM customer_sales_python_clean_file group by item_purchased) 
select item_purchased , category , customer_count , rank_category from item_numbers order by category , rank_category  LIMIT 4 ;  -- Q8

select case when previous_purchas > 5 then 'repeated customers (>5)' else 'rare customers (<=5)'end  as sub_buyers , 
count(*) as customer_sales_python_clean_file , sum(case when subscription_sta = 'Yes' then 1 else 0 end ) as subscribed,
round(100.0 * sum(case when subscription_sta = 'Yes' then 1 else 0 end)/ count(*) , 2) 
as subscriped_percentage from customer_sales_python_clean_file group by sub_buyers ;  -- Q9

select case when age BETWEEN 13 and 18 then 'Teen' when age between 20 and  50 then 'Adult'
else 'Senoir' end as Age_Grp , sum(purchase_amount) as Revenue , round(100.0*sum(purchase_amount)/
SUM(SUM(purchase_amount))  over() , 2 ) as Revenue_Contribution from customer_sales_python_clean_file
group by  Age_Grp order by  Revenue DESC ;   -- Q10



