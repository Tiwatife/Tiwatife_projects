--To get the average release year for games in each genre
SELECT[genre_name], AVG([release_year]) AS 'AVG_REL_YEAR'
FROM game_platform AS GP
JOIN game_publisher AS GPS ON GP.game_publisher_id = GPS.id
JOIN game AS Ga ON GPS.game_id = Ga.id
JOIN genre AS Ge ON Ga.genre_id = Ge.id
GROUP BY[genre_name];

--Retrieve the top 5 publishers with the highest total sales across all regions
SELECT TOP(5) [publisher_name], SUM([num_sales]) AS 'total_sales'
FROM region_sales AS RS
JOIN game_platform  AS GP ON RS.game_platform_id =  GP.id
JOIN game_publisher AS GPS ON GP.game_publisher_id = GPS.id
JOIN publisher AS P ON GPS.publisher_id = P.id
GROUP BY [publisher_name]
ORDER BY total_sales DESC

--Find the platform with the highest number of games released
SELECT TOP 1 [platform_name], COUNT(*) AS 'ASS'
FROM[dbo].[platform]
JOIN game_platform AS GP ON [platform].id = GP.platform_id
JOIN game_publisher AS GPS ON GP.game_publisher_id = GPS.game_id
JOIN game AS Ga ON GPS.game_id = Ga.id
GROUP BY [platform_name]
ORDER BY ASS DESC

--Calculate the percentage of games released in each genre compared to the total
--number of games
SELECT[genre_name],COUNT(*) AS 'game_count', (COUNT(*) * 100 / (SELECT COUNT(*) FROM [dbo].[game])) AS PERCENTAGE
FROM game
JOIN genre ON [dbo].[game].genre_id= [dbo].[genre].id
GROUP BY [genre_name]
ORDER BY PERCENTAGE DESC

--Retrieve games with a performance rating of 4 or higher and their corresponding
--average sales
SELECT[game_name], AVG([num_sales]) AS 'avg_sales'
FROM [dbo].[region_sales] AS RS
JOIN game_platform AS GP ON RS.[game_platform_id] = GP.[id]
JOIN game_publisher AS GPS ON GP.[game_publisher_id] = GPS.[id]
JOIN game AS Ga ON GPS.[game_id] = Ga.[id]
GROUP BY [game_name]
ORDER BY avg_sales DESC


--Find the average number of sales for games released on each platform and sort
them in ascending order
SELECT[platform_name], AVG([num_sales]) AS 'AVG_SALES'
FROM [dbo].[region_sales] AS RS
JOIN game_platform AS GP ON RS.[game_platform_id] = GP.[id]
JOIN platform AS P ON GP.[platform_id] = P.[id]
GROUP BY[platform_name]
ORDER BY AVG_SALES ASC

--Calculate the total sales for each genre and platform combination
SELECT[genre_name], [platform_name], SUM([num_sales]) AS 'total_sales'
FROM genre
JOIN game AS Ga ON genre.[id] = Ga.[genre_id]
JOIN game_publisher AS GP ON Ga.[id] = GP.[game_id]
JOIN game_platform AS GPS ON GP.[id] = GPS.[game_publisher_id]
JOIN platform AS P ON GPS.[platform_id] = P.[id]
JOIN region_sales AS RS ON GPS.[id] = RS.[game_platform_id]
GROUP BY[genre_name], [platform_name]
ORDER BY total_sales DESC

SELECT[genre_name], [platform_name], SUM([num_sales]) AS 'total_sales'
FROM region AS R
JOIN region_sales AS RS ON R.[id] = RS.[region_id]
JOIN game_platform AS GP ON RS.[game_platform_id] = GP.[id]
JOIN game_publisher AS GPS ON GP.[game_publisher_id] = GPS.[id]
JOIN game AS Ga ON GPS.[game_id] = Ga.[id]
JOIN genre AS Ge ON Ga.genre_id = Ge.id
JOIN platform AS P ON GP.[platform_id] = P.[id]
GROUP BY[genre_name], [platform_name]
ORDER BY total_sales DESC

 --Retrieve games with the highest sales in each region
WITH highest_sales AS (
SELECT[game_name], [region_name], [num_sales],
ROW_NUMBER()
OVER(PARTITION BY [region_name] ORDER BY [num_sales] DESC) AS 'Rank'
FROM region AS R
JOIN region_sales AS RS ON R.[id] = RS.[region_id]
JOIN game_platform AS GP ON RS.[game_platform_id] = GP.[id]
JOIN game_publisher AS GPS ON GP.[game_publisher_id] = GPS.[id]
JOIN game AS Ga ON GPS.[game_id] = Ga.[id]
)
SELECT[game_name], [region_name], [num_sales]
FROM highest_sales
WHERE Rank=1
ORDER BY [num_sales] DESC

--Calculate the average sales for games in each genre and sort them in descending
order
SELECT[genre_name], AVG([num_sales]) AS 'avg_sales'
FROM region_sales AS RS
JOIN game_platform  AS GP ON RS.game_platform_id =  GP.id
JOIN game_publisher AS GPS ON GP.game_publisher_id = GPS.id
JOIN game AS Ga ON GPS.[game_id] = Ga.[id]
JOIN genre AS Ge ON Ga.genre_id = Ge.id
GROUP BY [genre_name]
ORDER BY avg_sales DESC

 ---Retrieve games with the highest number of sales in a specific region
SELECT TOP 5 [game_name], ([num_sales]), [region_name]
FROM region AS R
JOIN region_sales AS RS ON R.[id] = RS.[region_id]
JOIN game_platform AS GP ON RS.[game_platform_id] = GP.[id]
JOIN game_publisher AS GPS ON GP.[game_publisher_id] = GPS.[id]
JOIN game AS Ga ON GPS.[game_id] = Ga.[id]
WHERE region_name = 'Japan'
ORDER BY [num_sales] DESC
