
# **SQL Script Documentation: Hierarchical Location Extraction**

## **Overview**
This script constructs a hierarchical dataset of locations associated with **Top Accounts** by traversing ownership structures in Salesforce. The goal is to:
1. Identify locations linked **directly** or **indirectly** to a top account.
2. Determine the most frequently used **ZIP code** per top account.
3. Select the **most complete** location record per account.

---

## **Common Table Expressions (CTEs)**

### **1. AllLocations** (Hierarchical Ownership Traversal)
This CTE retrieves all location records associated with **Top Accounts** via up to **six levels** of ownership structures.

```sql
WITH AllLocations AS (
    -- Level 1: Direct Locations
    SELECT 
        csv.TopAccount,
        sf.AccountID,
        sf.ParentAccountID,
        sf.LocationType,
        sf.BillingCity,
        sf.BillingStateProvince,
        sf.BillingZipPostalCode,
        sf.Website
    FROM Integrations.SalesForce.SfSync sf
    INNER JOIN Sandbox.FileUpload.TopAccounts csv ON csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = sf.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    WHERE sf.LocationType = 'Location'
```
- Selects locations **directly** associated with a Top Account.
- Joins **Salesforce Sync** (`SfSync`) data with **Top Accounts** (`FileUpload.TopAccounts`).
- Uses `COLLATE SQL_Latin1_General_CP1_CS_AS` to ensure **case-sensitive** string comparisons.

```sql
    UNION ALL

    -- Level 2: Through One Ownership
    SELECT 
        csv.TopAccount,
        loc.AccountID,
        loc.ParentAccountID,
        loc.LocationType,
        loc.BillingCity,
        loc.BillingStateProvince,
        loc.BillingZipPostalCode,
        loc.Website
    FROM Integrations.SalesForce.SfSync own1
    INNER JOIN Sandbox.FileUpload.TopAccounts csv ON csv.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = own1.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    INNER JOIN Integrations.SalesForce.SfSync loc ON loc.ParentAccountID COLLATE SQL_Latin1_General_CP1_CS_AS = own1.AccountID COLLATE SQL_Latin1_General_CP1_CS_AS
    WHERE own1.LocationType = 'Ownership'
    AND loc.LocationType = 'Location'
```
- Expands relationships by **one ownership level**, linking indirect locations.

The same logic is **recursively applied** for levels **3 to 7**, ensuring hierarchical traversal of ownership levels.

---

### **2. ZipCodeCounts** (Most Frequent ZIP Per Top Account)
Identifies the **most frequently used ZIP code** per Top Account.

```sql
ZipCodeCounts AS (
    SELECT 
        TopAccount,
        BillingZipPostalCode,
        COUNT(*) AS ZipCount,
        ROW_NUMBER() OVER (PARTITION BY TopAccount ORDER BY COUNT(*) DESC) AS RankByCount 
    FROM AllLocations
    WHERE BillingZipPostalCode IS NOT NULL
    GROUP BY TopAccount, BillingZipPostalCode
)
```
- **Counts occurrences** of ZIP codes per Top Account.
- Uses `ROW_NUMBER()` to rank ZIP codes **by frequency**.

---

### **3. SelectedLocations** (Most Complete Location Per Top Account)
Filters the **most complete location record** per Top Account.
```sql
SelectedLocations AS (
    SELECT 
        h.TopAccount,
        h.BillingCity,
        h.BillingStateProvince,
        h.BillingZipPostalCode,
        h.Website,
        ROW_NUMBER() OVER (PARTITION BY h.TopAccount ORDER BY 
            CASE 
                WHEN h.BillingCity IS NOT NULL 
                AND h.BillingStateProvince IS NOT NULL 
                AND h.BillingZipPostalCode IS NOT NULL 
                AND h.Website IS NOT NULL THEN 1 ELSE 0 
            END DESC
        ) AS RankByCompleteness
    FROM AllLocations h
    INNER JOIN ZipCodeCounts z ON h.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = z.TopAccount
    WHERE z.RankByCount = 1
    GROUP BY h.TopAccount, h.BillingCity, h.BillingStateProvince, h.BillingZipPostalCode, h.Website
)
```
- **Ranks records** by data completeness (i.e., those containing city, state, ZIP, and website).
- **Selects locations** from accounts with the most frequently used ZIP.

---

### **4. Final Selection**
```sql
SELECT 
    c.*,
    sl.BillingCity AS City,
    sl.BillingStateProvince AS State,
    sl.BillingZipPostalCode AS ZipCode,
    CASE 
        WHEN c.Website = '' OR c.Website IS NULL THEN sl.Website 
        ELSE c.Website 
    END AS Website
FROM Sandbox.FileUpload.TopAccounts c
LEFT JOIN SelectedLocations sl 
    ON sl.TopAccount COLLATE SQL_Latin1_General_CP1_CS_AS = c.TopAccount
    AND sl.RankByCompleteness = 1
```
- Merges **Top Accounts** with their **most complete location records**.
- Ensures missing **website data** is replaced when possible.

---

## **Key Features**
✅ **Hierarchical Location Extraction**: Traverses up to **six ownership levels** to associate indirect locations.  
✅ **ZIP Code Optimization**: Identifies the **most frequently used ZIP** per Top Account.  
✅ **Data Completeness Ranking**: Selects the **most complete location record** using `ROW_NUMBER()`.  
✅ **Case-Sensitive String Handling**: Uses `COLLATE SQL_Latin1_General_CP1_CS_AS` to ensure matching accuracy.  

---
