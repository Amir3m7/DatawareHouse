CREATE TABLE DailyFactCustomer(

    customer_id int not null,

    KeyDate date not null,

    BranchCode INT not null,

    LoanNumber bigINT not null,

    InstallmentCode bigINT not null,

    AmountMoney INT ,

    TotalMoneyPaid INT ,

    TotalMoneyHaveToPaid INT ,

    number_of_nstallments_paid INT,

    Number_Of_Installments_Have_ToPaid INT,

);


-- Insert data into DailyFactCustomer
INSERT INTO DailyFactCustomer (customer_id, KeyDate, BranchCode, LoanNumber, InstallmentCode, AmountMoney, TotalMoneyPaid, TotalMoneyHaveToPaid, number_of_nstallments_paid, Number_Of_Installments_Have_ToPaid)
VALUES
(1001, '2023-01-01', 1, 1000001, 2000001, 1000, 5000, 10000, 1, 12),
(1002, '2023-01-01', 1, 1000001, 2000001, 1000, 5000, 10000, 1, 12),
(1003, '2023-01-01', 1, 1000001, 2000001, 1000, 5000, 10000, 1, 12),


(1002, '2023-01-02', 2, 1000002, 2000002, 2000, 10000, 20000, 2, 24),
(1003, '2023-01-03', 3, 1000003, 2000003, 3000, 15000, 30000, 3, 36),
(1004, '2023-01-04', 4, 1000004, 2000004, 4000, 20000, 40000, 4, 48),
(1005, '2023-01-05', 5, 1000005, 2000005, 5000, 25000, 50000, 5, 60),
(1006, '2023-01-06', 6, 1000006, 2000006, 6000, 30000, 60000, 6, 72),
(1007, '2023-01-07', 7, 1000007, 2000007, 7000, 35000, 70000, 7, 84),
(1008, '2023-01-08', 8, 1000008, 2000008, 8000, 40000, 80000, 8, 96),
(1009, '2023-01-09', 9, 1000009, 2000009, 9000, 45000, 90000, 9, 108),
(1010, '2023-01-10', 10, 1000010, 2000010, 10000, 50000, 100000, 10, 120),
(1011, '2023-01-11', 11, 1000011, 2000011, 11000, 55000, 110000, 11, 132),
(1012, '2023-01-12', 12, 1000012, 2000012, 12000, 60000, 120000, 12, 144),
(1013, '2023-01-13', 13, 1000013, 2000013, 13000, 65000, 130000, 13, 156),
(1014, '2023-01-14', 14, 1000014, 2000014, 14000, 70000, 140000, 14, 168),
(1015, '2023-01-15', 15, 1000015, 2000015, 15000, 75000, 150000, 15, 180),
(1016, '2023-01-16', 16, 1000016, 2000016, 16000, 80000, 160000, 16, 192),
(1017, '2023-01-17', 17, 1000017, 2000017, 17000, 85000, 170000, 17, 204),
(1018, '2023-01-18', 18, 1000018, 2000018, 18000, 90000, 180000, 18, 216),
(1019, '2023-01-19', 19, 1000019, 2000019, 19000, 95000, 190000, 19, 228),
(1020, '2023-01-20', 20, 1000020, 2000020, 20000, 100000, 200000, 20, 240);








-- CREATE PARTITION FUNCTION [DailyPartitionFunction](date) AS RANGE RIGHT
-- FOR VALUES (N'2023-01-11', N'2023-01-12', N'2023-01-13', 
--            N'2023-01-14', N'2023-01-15', N'2023-01-16', 
--            N'2023-01-17', N'2023-01-18', N'2023-01-19', 
--            N'2023-01-20')
-- GO



DECLARE @startDate datetime2 = '2023-01-01'; -- Start date for partitions
DECLARE @endDate datetime2 = '2023-12-29'; -- End date for partitions
DECLARE @DailyPartitionFunction nvarchar(max) =
    N'CREATE PARTITION FUNCTION DailyPartitionFunction (date)
    AS RANGE RIGHT FOR VALUES (';
DECLARE @i datetime2 = @startDate; 

WHILE @i < @endDate
BEGIN
    SET @DailyPartitionFunction += '''' + CAST(@i AS nvarchar(10)) + '''' + N', ';
    SET @i = DATEADD(DAY, 1, @i);
END

SET @DailyPartitionFunction += '''' + CAST(@i AS nvarchar(10)) + '''' + N');';
EXEC sp_executesql @DailyPartitionFunction;
GO




-- Create partition scheme for KeyDate
CREATE PARTITION SCHEME DailyPartitionScheme
AS PARTITION DailyPartitionFunction ALL TO ([PRIMARY]);
GO

-- Create partitioned primary key on table DailyFactCustomer using partition scheme
ALTER TABLE [dbo].[DailyFactCustomer]
ADD CONSTRAINT [PK_DailyFactCustomer_Partition_KeyDate_customer_id_BranchCode_LoanNumber_InstallmentCode_]
PRIMARY KEY  (
    [KeyDate] ASC,
    [customer_id]

)
WITH (ONLINE = OFF) -- Change to ONLINE = ON if using SQL Server Enterprise Edition
ON DailyPartitionScheme([KeyDate]);
GO







SELECT 
    o.name AS TableName,
    i.name AS IndexName,
    p.partition_number,
    fg.name AS FileGroupName,
    p.rows AS RowCoun,
    au.total_pages * 8 / 1024.0 AS TotalMB,
    au.used_pages * 8 / 1024.0 AS UsedMB,
    au.data_pages * 8 / 1024.0 AS DataMB
FROM 
    sys.objects o
    INNER JOIN sys.indexes i ON o.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units au ON p.partition_id = au.container_id
    INNER JOIN sys.filegroups fg ON fg.data_space_id = au.data_space_id
WHERE 
    o.name = 'DailyFactCustomer'  -- Replace with your table name
    AND o.type = 'U'
ORDER BY 
    p.partition_number;




ALTER TABLE [dbo].[DailyFactCustomer] 
DROP CONSTRAINT [PK_DailyFactCustomer_Partition_KeyDate] WITH ( ONLINE = OFF )
GO

DROP TABLE [dbo].[DailyFactCustomer]
GO

DROP PARTITION SCHEME DailyPartitionScheme
GO

DROP PARTITION FUNCTION [DailyPartitionFunction]
GO


