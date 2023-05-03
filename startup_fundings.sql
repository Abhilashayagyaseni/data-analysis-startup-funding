select count(*) from projects.startup_fundings;

#################################################   DATA FROM JAN-2015 TO JAN-2020  ####################################################
/*
1. TOP 10 START-UPS THAT RAISED HIGHEST FUND FROM MARKET
2. MOST FAVOURABLE CITY FOR START-UPS IN INDIA
3. STARTUP THAT RAISED MONEY MORE THAN 2 TIMES IN A YEAR
4. START-UPS RELATED TO E-COMMERCE SERVICES 
5. HIGHEST FUNDED START-UPS IN EACH CITY
6. START_UPS THAT RAISED MONEY MORE THAN 5 TIMES 
7. TOP 10 HIGHEST FUNDED INDUSTRY VERTICALS
8. START-UPS THAT RAISED TOTAL MONEY MORE THAN 500M USD
9. START-UPS THAT RAISED MORE THAN 200M USD IN SINGLE ROUND
10. ALL INVESTOR'S NAME OF HIGHEST FUNDED START-UP "FLIPKART"
11. CROWD FUNDED START-UPS AND INVESTOR'S NAME
12. MOST COMMON INVESTMENT TYPE
13. START-UPS IN WHICH TATA GROUP INVESTED 
14. TOTAL FUNDS PROVIDED EVERY YEAR TO STARTUPS
15. MOST STARTUPS BELONGS TO WHICH INDUSTRY VERTICAL
*/










##### 1. TOP 10 START-UPS THAT RAISED HIGHEST FUND FROM MARKET  #####

select startup_name, 
       round(sum(amount_usd),0) as fund_million_USD
from projects.startup_fundings 
group by startup_name
order by fund_million_USD desc
limit 10;





#### 2. MOST FAVOURABLE CITY FOR START-UPS IN INDIA  ####

select City_Location, 
       count(Startup_Name) as total_startups
from projects.startup_fundings 
group by City_Location
order by total_startups desc
LIMIT 3;





#### 3. STARTUP THAT RAISED MONEY MORE THAN 2 TIMES IN A YEAR  ####

select DISTINCT(extract(year from date)) as year, 
       Startup_Name, 
       count(amount_USD)
from projects.startup_fundings 
group by year, startup_name
having count(Amount_USD)>1;





#### 4. START-UPS RELATED TO E-COMMERCE SERVICES  ####

select Startup_Name, 
       Industry_Vertical
from projects.startup_fundings 
where Industry_Vertical like '%ecommerce%';





#### 5. HIGHEST FUNDED START-UPS IN EACH CITY  ####

with top_rank as(
select City_Location, 
       Startup_Name,
       sum(amount_usd) as tot_amount,
       dense_rank() over(partition by City_Location order by sum(Amount_usd) desc ) as _rank
from projects.startup_fundings
group by 1,2 )

select * from top_rank
where _rank = 1 and tot_amount != 0 
order by tot_amount desc;





#### 6. START_UPS THAT RAISED MONEY MORE THAN 5 TIMES  ####

select Startup_Name, 
	   count(Amount_USD) as tot_no_fund
from projects.startup_fundings 
group by Startup_Name
having count(Amount_USD) > 5
order by tot_no_fund desc;





#### 7. TOP 10 HIGHEST FUNDED INDUSTRY VERTICALS  ####

with vertical 
as  (select Industry_Vertical,
            sum(Amount_USD) as amount,
            count(startup_name) as tot_startups
from projects.startup_fundings 
group by Industry_Vertical)

select Industry_Vertical,
	   amount
from vertical
order by Amount desc
limit 10;





#### 8. START-UPS THAT RAISED TOTAL MONEY MORE THAN 500M USD  ####

select startup_name, 
       round((SUM(Amount_USD)),0) as tot_fund, 
       count(Amount_USD) as funding_round
from projects.startup_fundings 
group by Startup_Name
having tot_fund >= 500
order by tot_fund desc;





#### 9. START-UPS THAT RAISED MORE THAN 200M USD IN SINGLE ROUND ####

select startup_name, 
       Amount_USD
from projects.startup_fundings 
where Amount_USD >= 200 
order by Amount_USD desc;





#### 10. ALL INVESTOR'S NAME OF HIGHEST FUNDED START-UP "flipkart"  ####

select Investors_Name
from projects.startup_fundings 
where Startup_Name = "flipkart";



#### 11. CROWD FUNDED START-UPS AND INVESTOR'S NAME  #### 

select Startup_Name, 
       Investors_Name, 
       Investment_Type
from projects.startup_fundings 
where Investment_Type like '%crowd%';



#### 12. MOST COMMON INVESTMENT TYPE  ##### 

select investment_type, 
       count(investment_type) as total_no
from projects.startup_fundings 
group by investment_type
order by total_no desc
LIMIT 2 ;



#### 13. START-UPS IN WHICH TATA GROUP INVESTED  ####

select Startup_Name, 
       Investors_Name
from projects.startup_fundings 
where Investors_Name like '%tata%';





#### 14. TOTAL FUNDS PROVIDED EVERY YEAR TO STARTUPS ####

select sum(amount_usd) as total_fund ,
       extract(year from date) as years
from projects.startup_fundings
group by years;




#### 15. MOST STARTUPS BELONGS TO WHICH INDUSTRY VERTICAL ####

select Industry_Vertical,
       count( startup_name) as tot_startups
from projects.startup_fundings
where Industry_Vertical != 'not specified'
group by Industry_Vertical
order by count( startup_name) desc
<<<<<<< HEAD
limit 5;
=======
limit 5;
>>>>>>> 5a3d9ffc8af2db5407557628ef6689a7281e175f
