# SQL Script Documentation: Winback Location Analysis

## **Overview**
This script analyzes restaurant locations that have exited the network and later rejoined. It identifies the earliest rejoin date for each brand and calculates the gap between exit and return.

## **Table Variable Definition**
```sql
DECLARE @Rest_Loc_Primary TABLE (
    Id INT NOT NULL,
    Restaurant_Name NVARCHAR(50),
    Address NVARCHAR(50),
    Starting_Date NVARCHAR(50),
    OutOfBusiness_Date NVARCHAR(50)
)
```
### **Purpose**
Stores restaurant location data using a table variable, allowing temporary data manipulation within the scope of the script.

### **Data Insertion**
```sql
INSERT INTO @Rest_Loc_Primary (ID, Restaurant_Name, Address, Starting_Date, OutOfBusiness_Date)
VALUES (...)
```
Populates restaurant data, including their opening and closing dates.

## **Common Table Expressions (CTEs)**
### **1. ExtractedBrand**
Extracts brand names and converts dates for analysis.
```sql
;WITH ExtractedBrand AS (
    SELECT
        ID,
        Restaurant_Name,
        Address,
        CASE 
            WHEN CHARINDEX(' - ', Restaurant_Name) > 0 
            THEN LTRIM(RTRIM(LEFT(Restaurant_Name, CHARINDEX(' - ', Restaurant_Name))))
            ELSE LTRIM(RTRIM(Restaurant_Name)) 
        END AS Brand_Name,
        TRY_CAST(Starting_Date AS Date) AS StartDate,
        TRY_CAST(ISNULL(NULLIF(OutOfBusiness_Date, ''), '2100-01-01') AS Date) AS OOBDate 
    FROM @Rest_Loc_Primary
)
```
- Extracts **Brand_Name** from `Restaurant_Name` by trimming extra characters.
- Converts `Starting_Date` and `OutOfBusiness_Date` to the `DATE` format.

### **2. LastExit**
Determines the last recorded exit date for each restaurant location.
```sql
LastExit AS (
    SELECT			
        Restaurant_Name,
        Brand_Name,
        Address,
        StartDate,
        ROW_NUMBER() OVER (PARTITION BY Restaurant_Name, Brand_Name, Address ORDER BY StartDate DESC) AS rn,
        MAX(OOBDate) AS Last_OOBDate
    FROM ExtractedBrand
    GROUP BY Restaurant_Name, Brand_Name, Address, StartDate
)
```
- Uses `ROW_NUMBER()` to rank locations based on exit order.
- Finds the **latest** recorded exit date using `MAX(OOBDate)`.

### **3. EarliestRejoin**
Identifies the earliest rejoin date per brand **after their last recorded exit**.
```sql
EarliestRejoin AS (
    SELECT
        e.Restaurant_Name, 
        le.Address, 
        e.Brand_Name,
        MIN(le.StartDate) AS First_Rejoin_Date 
    FROM ExtractedBrand e
    JOIN LastExit le 
        ON e.Brand_Name = le.Brand_Name
        AND e.Restaurant_Name = le.Restaurant_Name
    WHERE rn = 1 AND le.StartDate > e.OOBDate
    GROUP BY e.Brand_Name, e.Restaurant_Name, le.Address
)
```
- Uses `MIN(StartDate)` to identify the earliest comeback for each brand.
- Ensures locations are analyzed **only after their last exit**.

### **4. Final Result: Winback Locations**
```sql
SELECT
    l.Restaurant_Name,
    l.Address,
    l.Brand_Name,
    l.Last_OOBDate AS Exit_Date,
    r.First_Rejoin_Date AS Rejoin_Date,
    DATEDIFF(DAY, l.Last_OOBDate, r.First_Rejoin_Date) AS Days_Between_Exit_And_Rejoin
FROM LastExit l
JOIN EarliestRejoin r 
    ON l.Brand_Name = r.Brand_Name 
    AND l.Restaurant_Name = r.Restaurant_Name 
    AND l.Address = r.Address
WHERE DATEDIFF(DAY, l.Last_OOBDate, r.First_Rejoin_Date) >= 30  
ORDER BY Brand_Name, Days_Between_Exit_And_Rejoin
```
### **Purpose**
- Identifies locations that rejoined after **at least 30 days**.
- Calculates the duration between their exit and rejoin dates.

### **Key Features**
- Uses `DATEDIFF()` to compute the number of days between exit and return.
- Filters out locations with **less than a 30-day gap**.
- Provides an ordered result by brand name and **time gap between exit and return**.
