
CREATE OR ALTER PROCEDURE Update_dimLoan
As
Begin 
	Merge Loan_dim As Target
	Using (
		Select Loan.[LoanNumber]
		  ,Loan.[CustomerNumber]
		  ,Customer.[CustomerName]
		  ,LoanType.[LoanType]
		  ,LoanType.[LoanTypeDescription]
		  ,LoanType.[SubLoanType]
		  ,LoanType.[SubLoanDescription]
		  ,Loan.[Branch]
		  ,Currency.[CurrencyCode]
		  ,Currency.[CurrencyDescription]
		  ,Loan.[ApprovalDate]
		  ,Loan.[Amount]
		  ,Loan.[LoanDuration]
		  ,Loan.[Status]
		from Loan JOIN LoanType ON  Loan.SubLoanType = LoanType.SubLoanType
				  JOIN Currency  ON Loan.Currency = Currency.CurrencyCode
				  JOIN Customer  ON Loan.CustomerNumber = Customer.CustomerCode
	) AS x
	On (Target.LoanNumber = x.LoanNumber)
	WHEN MATCHED and Target.LoanAmount <> x.Amount THEN
        UPDATE
        SET Target.LoanAmount = x.Amount

	WHEN NOT MATCHED THEN
        INSERT (LoanNumber
		, CustomerID
		, CustomerName
		, LoanTypeCode
		, LoanTypeDescription
		, SubLoanTypeCode
		, SubLoanTypeDescription
		, [BranchCode]
		, CurrencyCode
		, CurrencyDescription
		, ApprovalDate
		, LoanAmount
		, LoanTerm
		, [Status])
        VALUES (
			x.[LoanNumber]
		  ,x.[CustomerNumber]
		  ,x.[CustomerName]
		  ,x.[LoanType]
		  ,x.[LoanTypeDescription]
		  ,x.[SubLoanType]
		  ,x.[SubLoanType]
		  ,x.[Branch]
		  ,x.[CurrencyCode]
		  ,x.[CurrencyDescription]
		  ,x.[ApprovalDate]
		  ,x.[Amount]
		  ,x.[LoanDuration]
		  ,x.[Status]);
End;

Delete from Loan_dim
Delete from Loan where  LoanNumber=101

select * from Loan_dim

Exec Update_dimLoan

INSERT INTO Loan (LoanNumber, CustomerNumber, SubLoanType, Branch, Currency, ApprovalDate, Amount, LoanDuration, Status)
VALUES
(101, 7, 7, 7, 7, '2024-05-28', 5000.00, 24, 'Approved');


UPDATE Loan
SET Amount = 800.00
WHERE LoanNumber = 1;

EXEC Update_dimLoan;

SELECT * FROM Loan_dim;
