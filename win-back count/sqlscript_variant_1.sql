
 /*  using TABLE VARIABLE Like an option */


DECLARE @Rest_Loc_Primary TABLE (
		Id INT NOT NULL,
        Restaurant_Name NVARCHAR(50),
		Address NVARCHAR(50),
		Starting_Date NVARCHAR(50),
		OutOfBUsiness_Date NVARCHAR(50))

	INSERT INTO @Rest_Loc_Primary (ID,Restaurant_Name,Address,Starting_Date,OutOfBUsiness_Date)
	VALUES
	 (101,'Restaurant Name _ 1','Restaurant_address', '2017-05-15','2020-05-31')
	,(102,'Restaurant Name _ 2','Restaurant_address','2017-05-15','2020-05-31')
	,(103,'Restaurant Name _ 3','Restaurant_address','2017-05-15','2020-05-31')
	,(104,'Restaurant Name _ 4','Restaurant_address','2017-05-15','2020-05-31')
	,(105,'Restaurant Name _ 5','Restaurant_address','2017-05-15','2020-05-31')
	,(106,'Restaurant Name _ 6','Restaurant_address', '2013-08-01', '2014-07-31')
	,(107,'Restaurant Name _ 7','Restaurant_address', '2013-08-01', '2014-07-31')
	,(108,'Restaurant Name _ 8','Restaurant_address', '2013-08-01', '2014-07-31')
	,(109,'Restaurant Name _ 9','Restaurant_address', '2013-08-01', '2014-07-31')
	,(110,'Restaurant Name _ 10','Restaurant_address', '2013-08-01', '2014-07-31')
	,(111,'Restaurant Name _ 1','Restaurant_address', '2009-04-15', '2020-06-30')
	,(112,'Restaurant Name _ 1','Restaurant_address', '2009-04-15', '2020-06-30')
	,(113,'Restaurant Name _ 1','Restaurant_address', '2009-04-15', '2020-06-30')
	,(114,'Restaurant Name _ 1','Restaurant_address', '2015-04-15', '2020-04-30')
	,(115,'Restaurant Name _ 1','Restaurant_address', '2009-04-15', '2020-06-30')
	
	INSERT INTO @Rest_Loc_Primary (ID,Restaurant_Name,Address,Starting_Date,OutOfBUsiness_Date)
	VALUES
	(116, 'Restaurant Name _ 9', 'Restaurant_address', '2021-06-30','2024-12-31')
	,(117, 'Restaurant Name _ 7', 'Restaurant_address','2020-07-01','')
	,(118, 'Restaurant Name _ 7', 'Restaurant_address','2020-07-01','2024-12-31')
	,(119, 'Restaurant Name _ 7', 'Restaurant_address','2021-05-06','2024-12-31')
	,(120, 'Restaurant Name _ 8', 'Restaurant_address','2020-06-07','')
	,(121, 'Restaurant Name _ 9', 'Restaurant_address', '2014-08-01', '')
	,(122, 'Restaurant Name _ 9', 'Restaurant_address', '2014-08-01', '')
	,(123, 'Restaurant Name _ 9', 'Restaurant_address', '2014-10-31', NULL)
	,(124, 'Restaurant Name _ 9', 'Restaurant_address', '2014-10-31', '2024-12-31')
	,(125, 'Restaurant Name _ 9', 'Restaurant_address', '2014-09-15', '')
	,(126, 'Restaurant Name _ 8', 'Restaurant_address', '2020-07-10', NULL)
	,(127, 'Restaurant Name _ 8', 'Restaurant_address', '2020-07-12', '2024-12-31')
	,(128, 'Restaurant Name _ 8', 'Restaurant_address', '2020-07-31', '')
	,(129, 'Restaurant Name _ 10', 'Restaurant_address', '2020-08-01', '')
	,(130, 'Restaurant Name _ 10', 'Restaurant_address', '2020-07-11', '2024-12-31')


	;WITH ExtractedBrand AS (
    SELECT
        ID,
        Restaurant_Name,
		Address,
		CASE WHEN CHARINDEX(' - ', Restaurant_Name) > 0	 -- alternative like SUBSTRING(Restaurant_Name, 1, CHARINDEX('-', Restaurant_Name + '-') - 1) 
            THEN LTRIM(RTRIM(LEFT(Restaurant_Name, CHARINDEX(' - ', Restaurant_Name)))) 
            ELSE LTRIM(RTRIM(Restaurant_Name)) 
        END AS Brand_Name,
        TRY_CAST(Starting_Date AS Date) AS StartDate,
        TRY_CAST(ISNULL(NULLIF(OutOfBusiness_Date, ''), '2100-01-01') AS Date) AS OOBDate 
    FROM @Rest_Loc_Primary

),
  
LastExit AS (	
    SELECT			
	    Restaurant_Name,
        Brand_Name,
		Address,
		StartDate,
		ROW_NUMBER() OVER (partition by Restaurant_Name,Brand_Name,Address order by StartDate desc) as rn,  -- like alternative place window func. in FROM statement, then directly in WHERE rn = 1
        MAX(OOBDate) AS Last_OOBDate
	FROM ExtractedBrand
    GROUP BY Restaurant_Name, Brand_Name
			,Address,StartDate
	--HAVING MAX(OOBDate) <> '2100-12-31'
),

-- obtaining the earliest StartDate per Brand after the last location has left the network 
EarliestRejoin AS (		--Earliest_StartDate
    SELECT
		e.Restaurant_Name, 
		le.Address, 
        e.Brand_Name,
		min(le.StartDate) AS First_Rejoin_Date		-- going with agg.  MIN(le.StartDate) AS First_Rejoin_Date
    FROM ExtractedBrand e
    JOIN LastExit le ON e.Brand_Name = le.Brand_Name
					AND e.Restaurant_Name = le.Restaurant_Name
					--AND le.StartDate > e.OOBDate		--le.Last_OOBDate would be wrong , because max() creates only 1 row 
    WHERE rn = 1 AND le.StartDate > e.OOBDate
	GROUP BY e.Brand_Name
	,e.Restaurant_Name,le.Address 	
)--,

--Winback_Locations AS (
    SELECT
        --l.ID,
		l.Restaurant_Name,
		l.Address,
        l.Brand_Name,
        l.Last_OOBDate AS Exit_Date,
        r.First_Rejoin_Date AS Rejoin_Date,
        DATEDIFF(DAY, l.Last_OOBDate, r.First_Rejoin_Date) AS Days_Between_Exit_And_Rejoin
    FROM LastExit l
    JOIN EarliestRejoin r ON l.Brand_Name = r.Brand_Name AND l.Restaurant_Name = r.Restaurant_Name AND l.Address = r.Address
    WHERE DATEDIFF(DAY, l.Last_OOBDate, r.First_Rejoin_Date) >= 30  -- 30 days threshold
	ORDER BY Brand_Name, Days_Between_Exit_And_Rejoin
