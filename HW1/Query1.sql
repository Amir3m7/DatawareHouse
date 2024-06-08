--1a
select *
from [ashkan].[dbo].[Sales_details]

--1b
SELECT *
into [Sales_details2]
FROM [ashkan].[dbo].[Sales_details] AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM [ashkan].[dbo].[Sales_details] AS s2
    WHERE 
        s2.BranchId = s.BranchId 
        AND s2.Invoicenum = s.Invoicenum 
        AND (
            SELECT COUNT(DISTINCT CONCAT([Jalali-D], '-', [Jalali-M], '-', [Jalali-Y])) 
            FROM [ashkan].[dbo].[Sales_details] AS s3
            WHERE s3.BranchId = s2.BranchId 
            AND s3.Invoicenum = s2.Invoicenum
        ) > 1
) AND NOT EXISTS (
    SELECT 1
    FROM [ashkan].[dbo].[Sales_details] AS s4
    WHERE 
        s4.BranchId = s.BranchId 
        AND s4.Productid = s.Productid 
        AND s4.Invoicenum = s.Invoicenum
    GROUP BY 
        s4.BranchId, 
        s4.Productid, 
        s4.Invoicenum
    HAVING COUNT(*) > 1
)
select * 
From [ashkan].[dbo].[Sales_details2]

--1c
GO
CREATE OR ALTER PROCEDURE part3 AS
BEGIN
    DROP TABLE IF EXISTS [Sales_details3];

    WITH sale_day AS (
        SELECT 
            [BranchId],
            [Productid],
            SUM(Unitssold) AS Unitssold,
            [Jalali-D],
            [Jalali-M],
            [Jalali-Y]
        FROM 
            [ashkan].[dbo].[Sales_details2]
        GROUP BY 
            [BranchId],
            [Productid],
            [Jalali-D],
            [Jalali-M],
            [Jalali-Y]
    ),
    boxplot AS (
        SELECT 
            *,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Unitssold) OVER (PARTITION BY Branchid, Productid) AS q1,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Unitssold) OVER (PARTITION BY Branchid, Productid) AS q3
        FROM 
            sale_day
    ),
    valid_data AS (
        SELECT 
            *,
            ((q3-q1)*1.5-q1) AS low_valid,
            ((q3-q1)*1.5+q3) AS high_valid
        FROM 
            boxplot
    ),
    final_table AS (
        SELECT 
            [BranchId],
            [Productid],
            [Jalali-D],
            [Jalali-M],
            [Jalali-Y],
            CASE 
                WHEN Unitssold < low_valid OR Unitssold > high_valid THEN 
                    (
          CEILING(AVG(CASE WHEN Unitssold <= high_valid AND Unitssold >= low_valid THEN Unitssold END) OVER (PARTITION BY [BranchId], [Productid]))
                    )
                ELSE 
                    Unitssold
            END AS Units_sold
        FROM 
            valid_data
    )
    SELECT 
        [BranchId],
        [Productid],
        [Jalali-D],
        [Jalali-M],
        [Jalali-Y],
        Units_sold
    INTO 
        Sales_details3
    FROM 
        final_table;
END;

Go 
Exec part3

Select * 
from [ashkan].[dbo].[Sales_details3]
