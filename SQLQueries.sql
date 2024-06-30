--Q1. How many Cars were sold in each state
select	state,
		count(*) as [Number of cars]
from car_prices
group by state

select * from car_prices
where len(state ) >2;

 --Q2. Creating a temporary table to store valid car prices data
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
	AND saledate != ''
	And condition !='';

 
-- drop table #Car_Prices_Valid
--Q3. Which Kind of Cars are most popular ? | How many sales have been made for each make & model?
select 
make,
model,
count(*)
from #Car_Prices_Valid
group by make,model
order by count(*) desc

-- Q4. WHat is the AVG Sales Price for car for each state

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

-- Q5. Avg Sales price for sold cars in each month and Year ?

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


--Q6 Top 5 most selling models within each body type (Number of sales)
SELECT	make,
		model, 
		body, 
		Number_of_sales, 
		bodyRank
FROM (
    SELECT make, model, body,
           COUNT(*) AS Number_of_sales,
           RANK() OVER (PARTITION BY body ORDER BY COUNT(*) DESC) AS bodyRank
    FROM #Car_Prices_Valid
    GROUP BY make, model, body
) AS ranked_models
WHERE bodyRank <= 5
ORDER BY body, Number_of_sales DESC;

-- Q7 sales price higher than model average and How much higher
select	make,
		model,
		vin,
		Sales_Year,
		sale_month, 
		Sales_by_Day,
		sellingprice, 
		Avg_Model,
		sellingprice / Avg_Model as Price_ratio  -- How much higher they are the avg
from (
select	make,
		model,
		vin,
		Sales_Year,
		sale_month, 
		Sales_by_Day,
		sellingprice, 
		Avg(sellingprice) over (partition by make,model) As Avg_Model  	-- Avg for sub-groups of data 
FROM #Car_Prices_Valid) As RankedModel
where sellingprice > Avg_Model
order by sellingprice / Avg_Model  desc;

-- Q8 How does this condition impact the sales price and how many are sold ?
select Car_Condition_buckets,
		condition,
		count(*) As Num_Sales,
		AVG(sellingprice) AS Avg_sales_price
	from (
		select	
			CASE
				when condition between 0  and  9 then  '0 to 9'
				when condition between 10 and 19 then '10 to 19'
				when condition between 20 and 29 then '20 to 29'
				when condition between 30 and 39 then '30 to 39'
				when condition between 40 and 49 then '40 to 49'
		END AS Car_Condition_buckets,
				condition,
				sellingprice
	FROM #Car_Prices_Valid
	) as subQuery
group by Car_Condition_buckets,condition
ORDER BY condition ASC;

--  brand details NUmber of unique model that has been sold
select	make,
		count(distinct model)	  AS [Number of models],
		count(*)		  AS [Number of Sales],
		MIN(sellingprice) AS [Min price],
		max(sellingprice) AS [Max price],
		AVG(sellingprice) AS [AVG price] 
from #Car_Prices_Valid
group by make
order by [AVG price] desc
-- the top brands by the AVG price are Rolls-Royce, Ferrari and Lamborghini.