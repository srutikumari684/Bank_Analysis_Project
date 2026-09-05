use project;

Drop table if exists bank_data;

/*--------------------------------------------------------------------BANK ANALYTICS 18 SQL QUERIES---------------------------------------------------------------------- */

CREATE TABLE bank_data (
    account_id INT,
    age_min INT,
    age_max INT,
    bh_name VARCHAR(100),
    bank_name VARCHAR(100),
    branch_name VARCHAR(100),
    caste VARCHAR(50),
    center_id INT,
    city VARCHAR(100),
    client_id INT,
    client_name VARCHAR(150),
    close_client VARCHAR(10),
    close_date DATE,
    credit_officer_name VARCHAR(100),
    date_of_birth DATE,
    disb_by VARCHAR(100),
    disbursed_date DATE,
    disbursed_date_year YEAR,
    gender_id VARCHAR(10),
    home_ownership VARCHAR(50),
    loan_status VARCHAR(50),
    loan_transferdate DATE,
    next_meeting_date DATE,
    product_code VARCHAR(50),
    grade VARCHAR(10),
    sub_grade VARCHAR(10),
    product_id INT,
    purpoe_category VARCHAR(100),
    region_name VARCHAR(100),
    religion VARCHAR(50),
    verification_status VARCHAR(50),
    state_abbr VARCHAR(10),
    state_name VARCHAR(100),sakila
    transfer_logic VARCHAR(50),
    is_delinquent_loan VARCHAR(10),
    is_default_loan VARCHAR(10),
    age_t INT,
    delinq_2_yrs INT,
    application_type VARCHAR(50),
    loan_amount FLOAT,
    funded_amount FLOAT,
    funded_amount_inv FLOAT,
    term VARCHAR(20),
    interest_rate FLOAT,
    total_payment FLOAT,
    total_payment_inv FLOAT,
    total_rec_prncp FLOAT,
    total_fees FLOAT,
    total_rrec_int FLOAT,
    total_rec_late_fee FLOAT,
    recoveries FLOAT,
    collection_recovery_fee FLOAT
);

select * from bank_data;

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'D:/EXCELR CLASS/Project/PROJECT/Banking Project/Data/CSV fromat/bank_Data.csv'
INTO TABLE bank_data
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM bank_data;

/* 1 -------------------------- Total Loan Amount Funded ------------------------ 
--------------------Measures the total value of all loans disbursed--------------*/

SELECT SUM(loan_amount) AS total_loan_amount_funded FROM bank_data;

/* 2 -------------------------- Total Loans ------------------------ 
--------------------Tracks the number of loans issued---------------*/

SELECT COUNT(account_id) AS total_loans FROM bank_data;

/* 3-------------------------- Total Collection ------------------------ 
------------Reflects total amount collected (principal + interest)--------*/

SELECT SUM(total_payment) AS total_collection FROM bank_data;

/* 4-------------------------- Total Interest ------------------------ 
--------------------Total interest earned from all loans-------------*/

SELECT SUM(total_rrec_int) AS total_interest FROM bank_data;

/* 5---------------------- Branch-Wise Performance ------------------------ 
---------------------Revenue and performance by branch.-------------------*/

SELECT branch_name, SUM(total_payment) AS total_collection, SUM(total_rrec_int) AS total_interest 
FROM bank_data 
GROUP BY branch_name;

/* 6------------------------------State-Wise Loan------------------------ 
---------------------Shows geographic distribution of loans -------------------*/

SELECT state_name, COUNT(loan_amount) AS total_loans, SUM(loan_amount) AS total_amount 
FROM bank_data 
GROUP BY state_name
ORDER BY total_loans desc;

/* 7------------------Religion-Wise Loan Distribution------------------- 
---------Monitors loan distribution across religious demographics-------------*/

SELECT religion, COUNT(account_id) AS total_loans, SUM(loan_amount) AS total_amount 
FROM bank_data 
GROUP BY religion
ORDER BY total_loans desc;

/* 8------------------ Product Group-Wise Loan ------------------- 
---------Categorizes by product (e.g., personal, home, vehicle)-------------*/

SELECT purpoe_category, COUNT(account_id) AS total_loans, SUM(loan_amount) AS total_amount 
FROM bank_data 
GROUP BY purpoe_category
ORDER BY total_loans desc;

/* 9------------------ Disbursement Trend ------------------- 
---------Tracks changes in loan disbursements over time -------------*/

SELECT YEAR(disbursed_date) AS year, MONTH(disbursed_date) AS month, SUM(loan_amount) AS total_disbursed 
FROM bank_data 
GROUP BY year, month  
ORDER BY year, month asc;

/* 10------------------ Grade-Wise Loan ------------------- 
--------- Assesses portfolio risk by borrower credit grades -------------*/

SELECT grade, COUNT(account_id) AS total_loans, SUM(loan_amount) AS total_amount 
FROM bank_data 
GROUP BY grade
ORDER BY total_loans desc;

/* 11------------------ Default Loan Count ------------------- 
-------------------- Counts loans in default -------------*/

SELECT COUNT(is_default_loan) AS default_loan_count 
FROM bank_data 
WHERE is_default_loan = 'YES';

/* 12-------------- Delinquent Client Count ------------------- 
---------- Tracks borrowers with missed payments -------------*/

SELECT COUNT(DISTINCT client_id) AS delinquent_clients 
FROM bank_data 
WHERE is_delinquent_loan = 'YES';

/* 13-------------- Delinquent Loan Rate ------------------- 
------- Percentage of loans overdue in the portfolio. -------------*/

SELECT 
CONCAT(ROUND((COUNT(CASE WHEN is_delinquent_loan = 'Yes' THEN 1 END) / COUNT(*)) * 100, 2), '%') 
AS delinquent_rate
FROM bank_data;

/* 14-------------- Default Loan Rate ------------------- 
------- Proportion of defaulted loans to the total portfolio -------------*/

SELECT 
CONCAT(ROUND((COUNT(CASE WHEN is_default_loan = 'YES' THEN 1 END) / COUNT(*)) * 100,2),'%') AS default_rate 
FROM bank_data;

/* 15----------------- Loan Status-Wise Loan ------------------- 
------- Breaks down loans by status (active, delinquent, closed) -------------*/

SELECT loan_status, COUNT(account_id) AS total_loans, SUM(loan_amount) AS total_amount 
FROM bank_data 
GROUP BY loan_status
ORDER BY total_loans desc;

/* 16----------------- Age Group-Wise Loan  ------------------- 
----------- Categorizes loans by borrowers’ age groups -------------*/

SELECT 
  CASE 
    WHEN ((age_min + age_max) / 2) < 25 THEN 'Below 25'
    WHEN ((age_min + age_max) / 2) BETWEEN 25 AND 35 THEN '25-35'
    WHEN ((age_min + age_max) / 2) BETWEEN 36 AND 45 THEN '36-45'
    WHEN ((age_min + age_max) / 2) BETWEEN 46 AND 60 THEN '46-60'
    ELSE 'Above 60'
  END AS age_group,
  COUNT(account_id) AS total_loans,
  SUM(loan_amount) AS total_amount
FROM bank_data
GROUP BY age_group
ORDER BY total_amount DESC;

/* 17----------------- Loan Maturity ------------------- 
----------- Tracks the timeline until full repayment -------------*/

---- NOT ABLE TO DO DUE TO DATE COLUMNS ARE BLANK-----

select * from bank_data;
/* 18----------------- No Verified Loans ------------------- 
----------- Identifies loans without proper verification -------------*/

SELECT COUNT(account_id) AS unverified_loans 
FROM bank_data 
WHERE verification_status = 'Not Verified';

-------------------------------------------------------------------------------- END -------------------------------------------------------------------------------


/* -------------------------------------------------------------- DEBIT AND CREDIT 7 QUERIES------------------------------------------------------------------- */

use project;

drop table if exists bank_transactions;



CREATE TABLE bank_transactions (
  customer_id VARCHAR(100),
  customer_name VARCHAR(100),
  account_number BIGINT,
  transaction_date DATE,
  transaction_type VARCHAR(20),
  amount DECIMAL(15,2),
  balance DECIMAL(15,2),
  description VARCHAR(255),
  branch VARCHAR(100),
  transaction_method VARCHAR(50),
  currency VARCHAR(10),
  bank_name VARCHAR(100)
);



select * from bank_transactions;


LOAD DATA LOCAL INFILE 'D:/EXCELR CLASS/Project/PROJECT/Banking Project/Data/CSV fromat/debit_credit_data.csv'
INTO TABLE bank_transactions
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select * from bank_transactions;

SELECT COUNT(*) FROM bank_transactions;


/* 1----------------- Total Credit Amount ------------------- 
----------- Measures the total amount of deposits or credits -------------*/

SELECT ROUND(SUM(Amount),0) AS Total_Credit
FROM bank_transactions
WHERE Transaction_Type = 'Credit';

/* 2 ----------------- Total Debit Amount ------------------- 
----------- Measures the total amount of withdrawals or debits -------------*/

SELECT ROUND(SUM(Amount),0) AS Total_Credit
FROM bank_transactions
WHERE Transaction_Type = 'Debit';

/* 3 ----------------- Credit to Debit Ratio ------------------- 
----------- Shows the ratio of credits to debits, which helps to understand 
whether the bank is receiving more deposits than withdrawals -------------*/

SELECT 
CONCAT(ROUND(SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END) /
SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END),2),'%')
AS Credit_Debit_Ratio
FROM bank_transactions;

/* 4 ----------------- Net Transaction Amount ------------------- 
----------- Measures the net cash flow (positive or negative) for the bank over a period -------------*/

SELECT 
(SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END) -
SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END)) 
AS Net_Transaction_Amount
FROM bank_transactions;

/* 5 ----------------- Account Activity Ratio ------------------- 
----------- Indicates how active a customer is in relation to their balance -------------*/

SELECT 
Account_Number,COUNT(*) / AVG(Balance) AS Account_Activity_Ratio
FROM bank_transactions
GROUP BY Account_Number;

/* 6 ----------------- Transactions per Day / Week / Month ------------------- 
----------- Identifies transaction volume trends over time, helping to detect periods of high or low activity. -------------*/

SELECT 
DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month, COUNT(*) AS Transactions_Per_Month
FROM bank_transactions
GROUP BY Month									/*MONTH*/
ORDER BY Month;

SELECT 
DATE(Transaction_Date) AS Day,COUNT(*) AS Transactions_Per_Day
FROM bank_transactions							
GROUP BY Day								/*DAY*/
ORDER BY Day;

SELECT 
YEAR(Transaction_Date) AS Year,WEEK(Transaction_Date) AS Week_Number,
COUNT(*) AS Transactions_Per_Week
FROM bank_transactions						/*WEEK*/
GROUP BY Year, Week_Number
ORDER BY Year, Week_Number;

/* 7 ----------------- Total Transaction Amount by Branch ------------------- 
----------- Measures the total transaction volume per branch, helping to compare branch performance.
Transaction Volume by Bank -------------*/

SELECT Branch,ROUND(SUM(Amount)) AS Total_Transaction_Amount
FROM bank_transactions
GROUP BY Branch
ORDER BY Total_Transaction_Amount DESC;

 

/*--------------------------------------------------END------------------------------------------------------------------------------------*/











































































































