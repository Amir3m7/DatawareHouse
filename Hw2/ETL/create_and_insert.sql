
CREATE TABLE Province(
    ProvinceCode INT PRIMARY KEY,
    ProvinceDescription NVARCHAR(255) NOT NULL
);

CREATE TABLE SupervisionBranch (
    SupervisionCode INT PRIMARY KEY,
    SupervisionDescription NVARCHAR(255) NOT NULL,
    ProvinceCode INT,
    FOREIGN KEY (ProvinceCode) REFERENCES Province(ProvinceCode)
);

CREATE TABLE Branch (
    BranchCode INT PRIMARY KEY,
    BranchName NVARCHAR(255) NOT NULL,
    SupervisionCode INT,
    FOREIGN KEY (SupervisionCode) REFERENCES SupervisionBranch(SupervisionCode)
);

CREATE TABLE Currency (
    CurrencyCode INT PRIMARY KEY,
    CurrencyDescription NVARCHAR(50) NOT NULL
);

CREATE TABLE CustomerType (
    CustomerType INT PRIMARY KEY,
    CustomerTypeDescription NVARCHAR(255) NOT NULL
);

CREATE TABLE Customer (
    CustomerCode BIGINT PRIMARY KEY,
    CustomerName NVARCHAR(255) NOT NULL,
    Branch INT,
    CustomerType INT,
    NationalID NVARCHAR(50),
    Job NVARCHAR(255),
    ContactNumber NVARCHAR(50),
    FOREIGN KEY (Branch) REFERENCES Branch(BranchCode),
    FOREIGN KEY (CustomerType) REFERENCES CustomerType(CustomerType)
);

CREATE TABLE LoanType (
    SubLoanType INT PRIMARY KEY,
    SubLoanDescription NVARCHAR(255) NOT NULL,
    LoanType INT,
    LoanTypeDescription NVARCHAR(255) NOT NULL
);

CREATE TABLE Loan (
    LoanNumber BIGINT PRIMARY KEY,
    CustomerNumber BIGINT,
    SubLoanType INT,
    Branch INT,
    Currency INT,
    ApprovalDate DATE,
    Amount DECIMAL(18, 2),
    LoanDuration INT,
    Status NVARCHAR(50),
    FOREIGN KEY (CustomerNumber) REFERENCES Customer(CustomerCode),
    FOREIGN KEY (SubLoanType) REFERENCES LoanType(SubLoanType),
    FOREIGN KEY (Branch) REFERENCES Branch(BranchCode),
    FOREIGN KEY (Currency) REFERENCES Currency(CurrencyCode)
);

CREATE TABLE Installment (
    InstallmentNumber BIGINT PRIMARY KEY,
    LoanNumber BIGINT,
    DueDate DATE,
    PrincipalAmount DECIMAL(18, 2),
    InterestAmount DECIMAL(18, 2),
    FOREIGN KEY (LoanNumber) REFERENCES Loan(LoanNumber)
);

CREATE TABLE RelationType (
    RelationType INT PRIMARY KEY,
    RelationDescription NVARCHAR(255) NOT NULL
);

CREATE TABLE CustomerLoanRelation (
    CustomerCode BIGINT,
    LoanNumber BIGINT,
    RelationType INT,
    PRIMARY KEY (CustomerCode, LoanNumber, RelationType),
    FOREIGN KEY (CustomerCode) REFERENCES Customer(CustomerCode),
    FOREIGN KEY (LoanNumber) REFERENCES Loan(LoanNumber),
    FOREIGN KEY (RelationType) REFERENCES RelationType(RelationType)
);

CREATE TABLE BankPayment (
    LoanNumber BIGINT,
    PaymentDate DATE,
    PaymentAmount DECIMAL(18, 2),
    PRIMARY KEY (LoanNumber, PaymentDate),
    FOREIGN KEY (LoanNumber) REFERENCES Loan(LoanNumber)
);

CREATE TABLE CustomerPayment (
    LoanNumber BIGINT,
    InstallmentNumber BIGINT,
    PaymentDate DATE,
    PrincipalPayment DECIMAL(18, 2),
    InterestPayment DECIMAL(18, 2),
    PenaltyPayment DECIMAL(18, 2),
    PRIMARY KEY (LoanNumber, InstallmentNumber, PaymentDate),
    FOREIGN KEY (LoanNumber) REFERENCES Loan(LoanNumber),
    FOREIGN KEY (InstallmentNumber) REFERENCES Installment(InstallmentNumber)
);

-- Corrected Dimension Tables

CREATE TABLE Branch_dim (
    Branch_Code INT,
    Branch_Name NVARCHAR(255),
    SupervisoryName NVARCHAR(255),
    SupervisionCode INT,
    ProvinceCode INT,
    ProvinceDescription NVARCHAR(255)
);

CREATE TABLE Customer_dim (
    SurrogateKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerCode BIGINT,
    CustomerName NVARCHAR(255),
    CustomerBranch INT,
    CustomerTypeCode INT,
    CustomerTypeDescription NVARCHAR(255),
    NationalId NVARCHAR(50),
    Job NVARCHAR(255),
    PhoneNumber NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    CurrentFlag NVARCHAR(50)
);

CREATE TABLE Relationship_dim (
    RelationshipType INT,
    RelationshipTypeDescription NVARCHAR(255)
);

CREATE TABLE Loan_dim (
    LoanNumber BIGINT,
    CustomerID BIGINT,
    CustomerName NVARCHAR(255),
    LoanTypeCode INT,
    LoanTypeDescription NVARCHAR(255),
    SubLoanTypeCode INT,
    SubLoanTypeDescription NVARCHAR(255),
    BranchCode INT,
    CurrencyCode INT,
    CurrencyDescription NVARCHAR(50),
    ApprovalDate DATE,
    LoanAmount DECIMAL(18, 2),
    LoanTerm INT,
    Status NVARCHAR(255)
);

CREATE TABLE Installment_dim (
    InstallmentCode BIGINT,
    LoanNumber BIGINT,
    DueDate DATE,
    PrincipalAmount DECIMAL(18, 2),
    InterestAmount DECIMAL(18, 2),
    LoanCustomerID BIGINT,
    LoanSubLoanTypeCode INT,
    LoanBranchCode INT,
    LoanCurrencyCode INT,
    LoanApprovalDate DATE,
    LoanAmount DECIMAL(18, 2),
    LoanTerm INT,
    LoanStatus NVARCHAR(255)
);

CREATE TABLE Date_dim (
    DateKey INT,
    SolarDateKey INT,
    GregorianYear INT,
    SolarYear INT,
    GregorianQuarter INT,
    SolarQuarter INT,
    GregorianMonth INT,
    SolarMonth INT,
    GregorianWeekDay INT,
    SolarWeekDay INT
);

CREATE TABLE LoanType_dim (
    LoanSubType INT,
    LoanSubTypeDescription NVARCHAR(255),
    LoanType INT,
    LoanTypeDescription NVARCHAR(255)
);


-- Insert data into Province
INSERT INTO Homework2.dbo.Province(ProvinceCode, ProvinceDescription)
VALUES
(1, 'Province 1'), (2, 'Province 2'), (3, 'Province 3'), (4, 'Province 4'), (5, 'Province 5'),
(6, 'Province 6'), (7, 'Province 7'), (8, 'Province 8'), (9, 'Province 9'), (10, 'Province 10'),
(11, 'Province 11'), (12, 'Province 12'), (13, 'Province 13'), (14, 'Province 14'), (15, 'Province 15'),
(16, 'Province 16'), (17, 'Province 17'), (18, 'Province 18'), (19, 'Province 19'), (20, 'Province 20'),
(21, 'Province 21'), (22, 'Province 22'), (23, 'Province 23'), (24, 'Province 24'), (25, 'Province 25'),
(26, 'Province 26'), (27, 'Province 27'), (28, 'Province 28'), (29, 'Province 29'), (30, 'Province 30');

-- Insert data into SupervisionBranch
INSERT INTO Homework2.dbo.SupervisionBranch (SupervisionCode, SupervisionDescription, ProvinceCode)
VALUES
(1, 'Supervision 1', 1), (2, 'Supervision 2', 2), (3, 'Supervision 3', 3), (4, 'Supervision 4', 4), (5, 'Supervision 5', 5),
(6, 'Supervision 6', 6), (7, 'Supervision 7', 7), (8, 'Supervision 8', 8), (9, 'Supervision 9', 9), (10, 'Supervision 10', 10),
(11, 'Supervision 11', 11), (12, 'Supervision 12', 12), (13, 'Supervision 13', 13), (14, 'Supervision 14', 14), (15, 'Supervision 15', 15),
(16, 'Supervision 16', 16), (17, 'Supervision 17', 17), (18, 'Supervision 18', 18), (19, 'Supervision 19', 19), (20, 'Supervision 20', 20),
(21, 'Supervision 21', 21), (22, 'Supervision 22', 22), (23, 'Supervision 23', 23), (24, 'Supervision 24', 24), (25, 'Supervision 25', 25),
(26, 'Supervision 26', 26), (27, 'Supervision 27', 27), (28, 'Supervision 28', 28), (29, 'Supervision 29', 29), (30, 'Supervision 30', 30),
(31, 'Supervision 31', 1), (32, 'Supervision 32', 2), (33, 'Supervision 33', 3), (34, 'Supervision 34', 4), (35, 'Supervision 35', 5),
(36, 'Supervision 36', 6), (37, 'Supervision 37', 7), (38, 'Supervision 38', 8), (39, 'Supervision 39', 9), (40, 'Supervision 40', 10);

-- Insert data into Branch
INSERT INTO Homework2.dbo.Branch (BranchCode, BranchName, SupervisionCode)
VALUES
(1, 'Branch 1', 1), (2, 'Branch 2', 2), (3, 'Branch 3', 3), (4, 'Branch 4', 4), (5, 'Branch 5', 5),
(6, 'Branch 6', 6), (7, 'Branch 7', 7), (8, 'Branch 8', 8), (9, 'Branch 9', 9), (10, 'Branch 10', 10),
(11, 'Branch 11', 11), (12, 'Branch 12', 12), (13, 'Branch 13', 13), (14, 'Branch 14', 14), (15, 'Branch 15', 15),
(16, 'Branch 16', 16), (17, 'Branch 17', 17), (18, 'Branch 18', 18), (19, 'Branch 19', 19), (20, 'Branch 20', 20),
(21, 'Branch 21', 21), (22, 'Branch 22', 22), (23, 'Branch 23', 23), (24, 'Branch 24', 24), (25, 'Branch 25', 25),
(26, 'Branch 26', 26), (27, 'Branch 27', 27), (28, 'Branch 28', 28), (29, 'Branch 29', 29), (30, 'Branch 30', 30),
(31, 'Branch 31', 31), (32, 'Branch 32', 32), (33, 'Branch 33', 33), (34, 'Branch 34', 34), (35, 'Branch 35', 35),
(36, 'Branch 36', 36), (37, 'Branch 37', 37), (38, 'Branch 38', 38), (39, 'Branch 39', 39), (40, 'Branch 40', 40),
(41, 'Branch 41', 1), (42, 'Branch 42', 2), (43, 'Branch 43', 3), (44, 'Branch 44', 4), (45, 'Branch 45', 5),
(46, 'Branch 46', 6), (47, 'Branch 47', 7), (48, 'Branch 48', 8), (49, 'Branch 49', 9), (50, 'Branch 50', 10),
(51, 'Branch 51', 11), (52, 'Branch 52', 12), (53, 'Branch 53', 13), (54, 'Branch 54', 14), (55, 'Branch 55', 15),
(56, 'Branch 56', 16), (57, 'Branch 57', 17), (58, 'Branch 58', 18), (59, 'Branch 59', 19), (60, 'Branch 60', 20),
(61, 'Branch 61', 21), (62, 'Branch 62', 22), (63, 'Branch 63', 23), (64, 'Branch 64', 24), (65, 'Branch 65', 25),
(66, 'Branch 66', 26), (67, 'Branch 67', 27), (68, 'Branch 68', 28), (69, 'Branch 69', 29), (70, 'Branch 70', 30),
(71, 'Branch 71', 31), (72, 'Branch 72', 32), (73, 'Branch 73', 33), (74, 'Branch 74', 34), (75, 'Branch 75', 35),
(76, 'Branch 76', 36), (77, 'Branch 77', 37), (78, 'Branch 78', 38), (79, 'Branch 79', 39), (80, 'Branch 80', 40),
(81, 'Branch 81', 1), (82, 'Branch 82', 2), (83, 'Branch 83', 3), (84, 'Branch 84', 4), (85, 'Branch 85', 5),
(86, 'Branch 86', 6), (87, 'Branch 87', 7), (88, 'Branch 88', 8), (89, 'Branch 89', 9), (90, 'Branch 90', 10),
(91, 'Branch 91', 11), (92, 'Branch 92', 12), (93, 'Branch 93', 13), (94, 'Branch 94', 14), (95, 'Branch 95', 15),
(96, 'Branch 96', 16), (97, 'Branch 97', 17), (98, 'Branch 98', 18), (99, 'Branch 99', 19), (100, 'Branch 100', 20);

-- Insert data into CustomerType
INSERT INTO Homework2.dbo.CustomerType (CustomerType, CustomerTypeDescription)
VALUES
(1, 'Individual'), (2, 'Corporate'), (3, 'Government'), (4, 'Non-Profit'), (5, 'Small Business'),
(6, 'Large Business'), (7, 'Medium Business'), (8, 'Micro Business'), (9, 'Start-up'), (10, 'Freelancer'),
(11, 'Consultant'), (12, 'Service Provider'), (13, 'Manufacturer'), (14, 'Retailer'), (15, 'Wholesaler'),
(16, 'Distributor'), (17, 'Supplier'), (18, 'Contractor'), (19, 'Partner'), (20, 'Affiliate');

-- Insert data into Customer
INSERT INTO Homework2.dbo.Customer (CustomerCode, CustomerName, Branch, CustomerType, NationalID, Job, ContactNumber)
VALUES
(1, 'Customer 1', 1, 1, '1234567890', 'Job 1', '09123456789'), (2, 'Customer 2', 2, 2, '1234567891', 'Job 2', '09123456788'),
(3, 'Customer 3', 3, 3, '1234567892', 'Job 3', '09123456787'), (4, 'Customer 4', 4, 4, '1234567893', 'Job 4', '09123456786'),
(5, 'Customer 5', 5, 5, '1234567894', 'Job 5', '09123456785'), (6, 'Customer 6', 6, 6, '1234567895', 'Job 6', '09123456784'),
(7, 'Customer 7', 7, 7, '1234567896', 'Job 7', '09123456783'), (8, 'Customer 8', 8, 8, '1234567897', 'Job 8', '09123456782'),
(9, 'Customer 9', 9, 9, '1234567898', 'Job 9', '09123456781'), (10, 'Customer 10', 10, 10, '1234567899', 'Job 10', '09123456780');
-- ... (repeat similar entries up to 100)

-- Insert data into Currency
INSERT INTO Homework2.dbo.Currency (CurrencyCode, CurrencyDescription)
VALUES
(1, 'USD'), (2, 'EUR'), (3, 'IRR'), (4, 'JPY'), (5, 'GBP'),
(6, 'CAD'), (7, 'AUD'), (8, 'CHF'), (9, 'CNY'), (10, 'INR'),
(11, 'BRL'), (12, 'MXN'), (13, 'RUB'), (14, 'ZAR'), (15, 'SGD'),
(16, 'HKD'), (17, 'NOK'), (18, 'SEK'), (19, 'DKK'), (20, 'MYR');

-- Insert data into LoanType
INSERT INTO Homework2.dbo.LoanType (SubLoanType, SubLoanDescription, LoanType, LoanTypeDescription)
VALUES
(1, 'Personal Loan', 1, 'Consumer Loan'), (2, 'Home Loan', 1, 'Consumer Loan'),
(3, 'Car Loan', 1, 'Consumer Loan'), (4, 'Student Loan', 1, 'Consumer Loan'),
(5, 'Business Loan', 2, 'Commercial Loan'), (6, 'Agriculture Loan', 2, 'Commercial Loan'),
(7, 'Construction Loan', 2, 'Commercial Loan'), (8, 'Export Loan', 2, 'Commercial Loan'),
(9, 'Import Loan', 2, 'Commercial Loan'), (10, 'Working Capital Loan', 2, 'Commercial Loan'),
(11, 'Equipment Loan', 2, 'Commercial Loan'), (12, 'Microfinance Loan', 3, 'Microfinance Loan'),
(13, 'SME Loan', 3, 'Microfinance Loan'), (14, 'Venture Capital Loan', 3, 'Microfinance Loan'),
(15, 'Development Loan', 3, 'Microfinance Loan'), (16, 'Bridge Loan', 4, 'Short-term Loan'),
(17, 'Payday Loan', 4, 'Short-term Loan'), (18, 'Overdraft', 4, 'Short-term Loan'),
(19, 'Line of Credit', 4, 'Short-term Loan'), (20, 'Invoice Financing', 4, 'Short-term Loan');


-- Insert data into Loan
INSERT INTO Homework2.dbo.Loan (LoanNumber, CustomerNumber, SubLoanType, Branch, Currency, ApprovalDate, Amount, LoanDuration, Status)
VALUES
(1, 1, 1, 1, 1, '2023-01-01', 10000.00, 12, 'Approved'), (2, 2, 2, 2, 2, '2023-02-01', 20000.00, 24, 'Approved'),
(3, 3, 3, 3, 3, '2023-03-01', 30000.00, 36, 'Approved'), (4, 4, 4, 4, 4, '2023-04-01', 40000.00, 48, 'Approved'),
(5, 5, 5, 5, 5, '2023-05-01', 50000.00, 60, 'Approved'), (6, 6, 6, 6, 6, '2023-06-01', 60000.00, 72, 'Approved'),
(7, 7, 7, 7, 7, '2023-07-01', 70000.00, 84, 'Approved'), (8, 8, 8, 8, 8, '2023-08-01', 80000.00, 96, 'Approved'),
(9, 9, 9, 9, 9, '2023-09-01', 90000.00, 108, 'Approved'), (10, 10, 10, 10, 10, '2023-10-01', 100000.00, 120, 'Approved');
-- ... (repeat similar entries up to 100)

-- Insert data into Installment
-- Insert data into Installment table
INSERT INTO Homework2.dbo.Installment (InstallmentNumber, LoanNumber, DueDate, PrincipalAmount, InterestAmount)
VALUES
-- Loan 1 Installments
(1, 1, '2023-02-01', 833.33, 66.67), (2, 1, '2023-03-01', 833.33, 66.67),
(3, 1, '2023-04-01', 833.33, 66.67), (4, 1, '2023-05-01', 833.33, 66.67),
(5, 1, '2023-06-01', 833.33, 66.67), (6, 1, '2023-07-01', 833.33, 66.67),
(7, 1, '2023-08-01', 833.33, 66.67), (8, 1, '2023-09-01', 833.33, 66.67),
(9, 1, '2023-10-01', 833.33, 66.67), (10, 1, '2023-11-01', 833.33, 66.67),
(11, 1, '2023-12-01', 833.33, 66.67), (12, 1, '2024-01-01', 833.33, 66.67),

-- Loan 2 Installments
(13, 2, '2023-03-01', 833.33, 66.67), (14, 2, '2023-04-01', 833.33, 66.67),
(15, 2, '2023-05-01', 833.33, 66.67), (16, 2, '2023-06-01', 833.33, 66.67),
(17, 2, '2023-07-01', 833.33, 66.67), (18, 2, '2023-08-01', 833.33, 66.67),
(19, 2, '2023-09-01', 833.33, 66.67), (20, 2, '2023-10-01', 833.33, 66.67),
(21, 2, '2023-11-01', 833.33, 66.67), (22, 2, '2023-12-01', 833.33, 66.67),
(23, 2, '2024-01-01', 833.33, 66.67), (24, 2, '2024-02-01', 833.33, 66.67);


-- Insert data into RelationType
INSERT INTO RelationType (RelationType, RelationDescription)
VALUES
(1, 'Relation Type 1'), (2, 'Relation Type 2'), (3, 'Relation Type 3'), (4, 'Relation Type 4');

-- Insert data into CustomerLoanRelation
INSERT INTO CustomerLoanRelation (CustomerCode, LoanNumber, RelationType)
VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 1),
(6, 6, 2), (7, 7, 3), (8, 8, 4), (9, 9, 1), (10, 10, 2);

-- Insert data into BankPayment and CustomerPayment (assuming these tables are already populated)
-- Make sure the LoanNumber values exist in the Loan table
INSERT INTO BankPayment (LoanNumber, PaymentDate, PaymentAmount)
VALUES
(1, '2023-01-01', 1000.00), (2, '2023-02-01', 2000.00), (3, '2023-03-01', 3000.00);

INSERT INTO CustomerPayment (LoanNumber, InstallmentNumber, PaymentDate, PrincipalPayment, InterestPayment, PenaltyPayment)
VALUES
(1, 1, '2023-01-01', 500.00, 50.00, 0.00), (2, 2, '2023-02-01', 1000.00, 100.00, 10.00),
(3, 3, '2023-03-01', 1500.00, 150.00, 15.00);
