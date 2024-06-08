
CREATE OR ALTER PROCEDURE Update_dimCustomer
AS
BEGIN
    MERGE Homework2.dbo.Customer_dim AS Target
    USING (
        SELECT
            Customer.CustomerCode,
            Customer.CustomerName,
            Customer.Branch,
            Customer.CustomerType,
            CustomerType.CustomerTypeDescription,
            Customer.NationalId,
            Customer.Job,
            Customer.ContactNumber,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM Customer_dim
                    WHERE Customer.CustomerCode = Customer_dim.CustomerCode
                        AND Customer_dim.Job <> Customer.Job
                        AND Customer_dim.CurrentFlag = 1
                ) THEN 1
                ELSE 0
            END AS JobChanged,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + (select count (*) from Customer_dim) AS SurrogateKey
        FROM Customer
        JOIN CustomerType ON CustomerType.CustomerType = Customer.CustomerType
    ) AS x
    ON Target.CustomerCode = x.CustomerCode
        AND Target.CurrentFlag = 1
    WHEN MATCHED AND x.JobChanged = 1 THEN
        UPDATE
        SET Target.CurrentFlag = 0,
            Target.EndDate = GETDATE();

    MERGE Homework2.dbo.Customer_dim AS Target
    USING (
        SELECT
            Customer.CustomerCode,
            Customer.CustomerName,
            Customer.Branch,
            Customer.CustomerType,
            CustomerType.CustomerTypeDescription,
            Customer.NationalId,
            Customer.Job,
            Customer.ContactNumber,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM Customer_dim
                    WHERE Customer.CustomerCode = Customer_dim.CustomerCode
                        AND Customer_dim.Job <> Customer.Job
                        AND Customer_dim.CurrentFlag = 1
                ) THEN 1
                ELSE 0
            END AS JobChanged,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + (select count (*) from Customer_dim) AS SurrogateKey
        FROM Customer
        JOIN CustomerType ON CustomerType.CustomerType = Customer.CustomerType
    ) AS x
    ON Target.CustomerCode = x.CustomerCode AND x.Job = Target.Job
    WHEN NOT MATCHED THEN
        INSERT (SurrogateKey, CustomerCode, CustomerName, CustomerBranch, CustomerTypeCode, CustomerTypeDescription, NationalId, Job, PhoneNumber, StartDate, EndDate, CurrentFlag)
        VALUES (x.SurrogateKey, x.CustomerCode, x.CustomerName, x.Branch, x.CustomerType, x.CustomerTypeDescription, x.NationalId, x.Job, x.ContactNumber, GETDATE(), NULL, 1);
	
END;




delete from Customer_dim

select * from Customer_dim

EXEC Update_dimCustomer

select * from Customer_dim

UPDATE Customer
SET Job = 'Job110'
WHERE CustomerCode = 1;


delete from Homework2.dbo.Customer where CustomerCode =11
INSERT INTO Homework2.dbo.Customer (CustomerCode, CustomerName, Branch, CustomerType, NationalID, Job, ContactNumber)
VALUES
(11, 'Customer 1', 1, 1, '1234567890', 'Job 1', '09123456789');




SET IDENTITY_INSERT Customer_dim ON;

SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    i.name AS IndexName
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
INNER JOIN 
    sys.tables t ON i.object_id = t.object_id
WHERE 
    i.is_unique = 1
    AND i.name = 'UQ__Customer__06678521B5B670AD';




ALTER TABLE dbo.Customer_dim
DROP CONSTRAINT UQ__Customer__06678521B5B670AD;

