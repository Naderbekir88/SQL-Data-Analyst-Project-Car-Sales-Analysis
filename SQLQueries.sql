-- How many Cars were sold in each state
select	state,
		count(*) as [Number of cars]
from car_prices
group by state

select * from car_prices
where len(state ) >2;

-- Creating a temporary table to store Vaild car prices data
 -- Creating a temporary table to store valid car prices data
SELECT 
    'year' AS Manufactor_Year,
    make,
    model,
    trim,
    body,
    transmission,
    vin,
    state,
    condition,
    odometer,
    color,
    interior,
    seller,
    mmr,
    sellingprice,
    saledate,
    SUBSTRING(saledate, 12, 4) AS Sales_Year,
    SUBSTRING(saledate, 5, 3) AS SalesMonth,
    SUBSTRING(saledate, 9, 2) AS Sales_by_Day,
    CAST (CASE SUBSTRING(saledate, 5, 3)
        WHEN 'Jan' THEN 1
        WHEN 'Feb' THEN 2
        WHEN 'Mar' THEN 3
        WHEN 'Apr' THEN 4
        WHEN 'May' THEN 5
        WHEN 'Jun' THEN 6
        WHEN 'Jul' THEN 7
        WHEN 'Aug' THEN 8
        WHEN 'Sep' THEN 9
        WHEN 'Oct' THEN 10
        WHEN 'Nov' THEN 11
        WHEN 'Dec' THEN 12
        ELSE NULL -- Handle any unexpected values
    END AS int)AS sale_month
INTO #Car_Prices_Valid
FROM car_prices
WHERE body != 'Navitgation'
    AND make != ''
	AND saledate != '';

 
--drop table #Car_Prices_Valid
-- Which Kind of Cars are most popular ? | How many sales have been made for each make & model?
select 
make,
model,
count(*)
from #Car_Prices_Valid
group by make,model
order by count(*) desc

-- WHat is the AVG Sales Price for car for each state

select state,
AVG(sellingprice) AS [AVG Sales Price ]
from #Car_Prices_Valid
group by state
order by AVG(sellingprice) ASC




-- Avg Sales price for sold cars in each month and Year ?
select state,
AVG(sellingprice) AS [AVG Sales Price ]
from #Car_Prices_Valid
group by state
order by AVG(sellingprice) ASC

-- -- Avg Sales price for sold cars in each month and Year ?

select	Sales_Year,
		sale_month,
		AVG(sellingprice) As AVG_Selling_Price
from #Car_Prices_Valid
group by Sales_Year,sale_month
order by Sales_Year,sale_month;


select sale_month,
count(*)
from #Car_Prices_Valid
group by sale_month
order by sale_month ASC;


-- Top 5 most selling models within each body type (Number of sales) ?
select	make, model,body,
		count(*) AS Number_of_sales
FROM #Car_Prices_Valid
Group BY make, model,body
ORDER BY body,count(*) desc;