--Viewing top 5 rows of entire data set containing five different but related tables
SELECT Top 5*
FROM artist;

SELECT Top 5*
FROM product_size;

SELECT Top 5*
FROM work;

SELECT Top 5*
FROM museum;

SELECT Top 5*
FROM subject;

--Checking for NULL values and duplicates in the artist table
SELECT *
FROM artist
WHERE full_name is NULL OR first_name is NULL OR
last_name is NULL OR nationality is NULL OR style is NULL OR birth is NULL OR death is NULL;

SELECT artist_id,full_name,first_name,middle_names,last_name,nationality,style,birth,death, COUNT(*)
FROM artist
GROUP BY artist_id,full_name,first_name,middle_names,last_name,nationality,style,birth,death
HAVING COUNT(*) > 1

--Checking for NULL values and duplicates in the product_size table
SELECT *
FROM product_size
WHERE work_id is NULL OR size_id is NULL OR sale_price is NULL OR regular_price is NULL;

SELECT work_id,size_id,sale_price,regular_price,count(*)
FROM product_size
GROUP BY work_id,size_id,sale_price,regular_price
HAVING count(*) > 1;

--Checking for NULL values and duplicates in the work table
SELECT *
FROM work
WHERE work_id is NULL OR name is NULL OR artist_id is NULL OR style is NULL OR museum_id is NULL

SELECT work_id,name,artist_id,style,museum_id
FROM work
GROUP BY work_id,name,artist_id,style,museum_id
HAVING count(*) > 1

--The total number of distinct name of famous paintings(not taking into consideration the varieties of sizes of each painting available) 
--in each museum and the country its located in
SELECT m.name,country,count(distinct(w.name)) "number of paintings",m.museum_id
FROM work w
JOIN museum m
ON w.museum_id=m.museum_id
GROUP BY m.museum_id,m.name,country
ORDER BY 3 desc;

--Creating a categorical price range
SELECT size_id,subject,sale_price,
CASE
	WHEN sale_price between 10 AND 100 THEN 'Cheap'
	WHEN sale_price between 101 AND 200 THEN 'Affordable'
	WHEN sale_price between 201 AND 500 THEN 'Pricy'
	ELSE 'Expensive'
END 'price category'
FROM product_size p
JOIN subject s
ON p.work_id=s.work_id;

--Changing the data type of the sale price column from varchar to int in order to use aggregate functions on it
ALTER TABLE product_size
ALTER COLUMN sale_price int;

--Average price of famous paintings grouped by their subject
SELECT DISTINCT(subject),avg(sale_price)
OVER(PARTITION BY subject) as average_price
FROM product_size p
JOIN subject s
ON p.work_id=s.work_id
ORDER BY 2 desc;

--The count of famous paintings, total & average price of paintings in each museum
WITH museuminfo as
(SELECT m.name, w.work_id,country, sale_price
FROM product_size p
JOIN work w
ON p.work_id=w.work_id
JOIN museum m
ON w.museum_id=m.museum_id)
SELECT name,count(work_id)'number of famous paintings',country, sum(sale_price) 'total price',sum(sale_price)/count(work_id) as 'average price'
FROM museuminfo
GROUP BY name,country
ORDER BY 4 desc

--Total famous paintings from each nationality
SELECT nationality, count(distinct(name)) "number of paintings"
FROM work w
JOIN artist a
ON w.artist_id=a.artist_id
GROUP BY nationality
ORDER by 2 desc

--Total number of famous paintings from French artists in each museum
SELECT m.name,country, count(distinct(w.name)) "number of paintings"
FROM work w
JOIN artist a
ON w.artist_id=a.artist_id
JOIN museum m
ON w.museum_id=m.museum_id
GROUP BY m.museum_id,m.name,nationality,country
HAVING nationality='French'
ORDER BY 3 desc

--The number of famous paintings grouped by style
SELECT style, count(distinct(name)) "number of paintings"
FROM work
GROUP BY style
ORDER BY "number of paintings" desc;

--To show the most common style of the artists of famous paintings
SELECT style, count(artist_id) "number of artists"
FROM artist
GROUP BY style
ORDER BY "number of artists" desc;

--To show the variation of styles by different nationality of artists  
SELECT nationality, count(distinct(style)) styles
FROM artist
GROUP BY nationality
ORDER BY styles desc;


--To show the number of artists of famous paintings from each country
SELECT nationality, count(artist_id) "number of artists"
FROM artist
GROUP BY nationality
ORDER BY 2 desc;

--To show the count of french artists of famous paintings and their styles
SELECT style, count(style) "number of artists"
FROM artist
GROUP BY style,nationality
HAVING nationality= 'French'
ORDER BY 2 desc;

--To show the most common styles by american artists collected by the museum
SELECT style,count(artist_id) "number of artists"
FROM artist
WHERE nationality='American'
GROUP BY style
ORDER BY "number of artists" desc;

---To show the nationalities of artists that practice Baroque,the most common style 
SELECT nationality,count(nationality) "number of artists"
FROM artist
WHERE style='Baroque'
GROUP BY nationality
ORDER BY 2 desc;

--The count of baroque style paintings owned by museums and their location
SELECT m.museum_id,m.name,country,count(style) "baroque style"
FROM work w
JOIN museum m
ON w.museum_id=m.museum_id
GROUP BY m.museum_id,country,style,m.name,m.museum_id
HAVING style= 'Baroque'
ORDER BY 4 desc

--The count of Impressionism paintings owned by museums and their location
SELECT m.museum_id,m.name,country,count(style) impressionism
FROM work w
JOIN museum m
ON w.museum_id=m.museum_id
GROUP BY m.museum_id,country,style,m.name,m.museum_id
HAVING style= 'Impressionism'
ORDER BY 4 desc

--The numbers of famous paintings from each artist 
SELECT a.artist_id,full_name, count(distinct(name)) "number of paintings"
FROM artist a
JOIN work w
ON a.artist_id=w.artist_id
GROUP BY a.artist_id,full_name,a.artist_id
ORDER BY 3 desc;


--The number of paintings from each nationality
SELECT nationality, count(distinct(name)) "number of paintings"
FROM artist a
JOIN work w
ON a.artist_id=w.artist_id
GROUP BY nationality
ORDER BY "number of paintings" desc;


