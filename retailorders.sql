select * from orders;

------top 10 heighest revenue generating product
select top 10 product_id,sum(sale_price)as sales
from orders
group by product_id
order by sum(sale_price) desc;

----top 5 heighest selling product in each region
with cte as(
select region,product_id,sum(sale_price) as sales
from orders
group by region,product_id)
select* from(
select *,rank()over(partition by region order by sales desc) as rn
from cte) a
where rn<6;

----month over month growth camparission for 2022 and 2023 sales
with cte as(
select year(order_date) as years,month(order_date) as months,sum(sale_price) as sales
from orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
)
select months,sum(case when years=2022 then sales else 0 end),sum(case when years=2023 then sales else 0 end)
from cte
group by months
order by months;

-----for each category which month as hieghtest sales
with cte as(
select category,format(order_date,'yyyyMM') as months,sum(sale_price) as sales
from orders
group by category,format(order_date,'yyyyMM')
)
select category,months,sales,rn
from(select *,rank()over(partition by category order by sales desc) as rn
from cte) b
where rn=1;

---which sub category had heightest growth by profit in 2023 campare to 2022
with cte as(
select sub_category ,sum(sale_price) as price,year(order_date) as years
from orders
group by sub_category , year(order_date)),
--order by sub_category , year(order_date))
cte2 as(
select sub_category,sum(case when years=2022 then price else 0 end) as year2022,sum(case when years=2023 then price else 0 end) as year2023
from cte
group by sub_category)
select top 1 *,year2023-year2022 as profits
from cte2
order by profits desc