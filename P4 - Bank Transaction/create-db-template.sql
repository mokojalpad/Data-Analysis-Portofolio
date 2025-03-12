-- Create Database
CREATE DATABASE bank_transaction
    DEFAULT CHARACTER SET = 'utf8mb4';

-- Select database to activated
USE bank_transaction;

-- Create table transaction
CREATE TABLE transaction (
    TransactionID VARCHAR(20),
    AccountID VARCHAR(20),
    TransactionAmount DECIMAL(10, 2),
    TransactionDate DATETIME,
    TransactionType VARCHAR(10),
    Location VARCHAR(20),
    DeviceID VARCHAR(10),
    IPAddress VARCHAR(20),
    MerchantID VARCHAR(10),
    Channel VARCHAR(20),
    CustomerAge INT,
    CustomerOccupation VARCHAR(35),
    TransactionDuration INT,
    LoginAttempts INT,
    AccountBalance DECIMAL(15, 2),
    PreviousTransactionDate DATETIME
);

-- Import data from folder
LOAD DATA INFILE 'D:\\LEARNING\\Data Analyst\\Project\\P4 - Bank Transaction\\bank_transactions_data_2.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(TransactionID, AccountID, TransactionAmount, TransactionDate, TransactionType, Location, 
DeviceID, IPAddress, MerchantID, Channel, CustomerAge, CustomerOccupation, TransactionDuration,
LoginAttempts, AccountBalance, PreviousTransactionDate
);

-- Delete duplicate data
DELETE t1
FROM transactions t1
JOIN transactions t2
ON t1.TransactionID = t2.TransactionID
AND t1.AccountID = t2.AccountID
AND t1.TransactionDate = t2.TransactionDate
AND t1.TransactionAmount = t2.TransactionAmount
WHERE t1.TransactionID > t2.TransactionID;

-- Change date format
UPDATE transactions
SET 
TransactionDate = STR_TO_DATE(TransactionDate, '%Y-%m-%d %H:%i:%s'),
PreviousTransactionDate = STR_TO_DATE(PreviousTransactionDate, '%Y-%m-%d %H:%i:%s')
WHERE TransactionDate IS NOT NULL AND PreviousTransactionDate IS NOT NULL;

-- Count transaction per account
SELECT AccountID, SUM(TransactionAmount) AS TotalSpent
FROM transactions
GROUP BY AccountID;

-- Calculate average transaction duration per transaction type
SELECT TransactionType, AVG(TransactionDuration) AS AVGTransactionDuration
FROM transactions
GROUP BY TransactionType;

-- Check Unique Data
SELECT DISTINCT transactionid
FROM transactions
ORDER BY transactionid ASC;

-- Filter Date
SELECT *
FROM transactions
WHERE TransactionDate < '2024-01-01';

-- Export database to CSV
-- Header
SELECT 'TransactionID', 'AccountID', 'TransactionAmount', 'TransactionDate', 'TransactionType', 'Location', 'DeviceID', 'IPAddress', 'MerchantID', 'Channel', 'CustomerAge', 'CustomerOccupation', 'TransactionDuration', 'LoginAttempts', 'AccountBalance', 'PreviousTransactionDate'
INTO OUTFILE 'D:\\LEARNING\\Data Analyst\\Project\\P4 - Bank Transaction\\clean_data_bank_transaction_header.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Data
SELECT * 
INTO OUTFILE 'D:\\LEARNING\\Data Analyst\\Project\\P4 - Bank Transaction\\clean_data_bank_transaction_data.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM transactions
WHERE TransactionDate < '2024-01-01';
