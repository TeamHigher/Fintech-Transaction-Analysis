
===================================================
--Question 1: What is the overall transaction 
--success rate by status?
===================================================
--Purpose: Understand platform reliability and 
--identify the proportion of failed transactions

SELECT status, COUNT(*) AS transaction_count,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM transactionz
GROUP BY status
ORDER BY transaction_count DESC;

--INSIGHT:
/*Transaction outcomes are evenly distributed across states, with 33.80% failed, 33.46% pending,
and 32.74% successful. However, failure is the most common outcome, indicating that only about 
one-third of transactions complete successfully. This suggests potential inefficiencies
in the transaction pipeline and highlights an opportunity to improve system reliability 
and completion rates.*/
==================================================================================================


=============================================================
--Question 2: Which transaction purpose generates
--the most revenue?
=============================================================
-- Purpose: Identify which transaction types drive the most 
-- revenue and highest average value to inform product and 
-- marketing prioritisation decisions.

SELECT 
    purpose,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM transactionz
GROUP BY purpose
ORDER BY total_revenue DESC;

--INSIGHT:
/*While transfers lead in volume and total revenue, payment transactions carry
the highest average transaction value at =N=254,139 — suggesting a smaller but higher-value 
customer segment. A business prioritising revenue efficiency over volume should focus acquisition 
and retention efforts on payment transaction users.*/
===================================================================================================


=============================================================
--Question 3: What is the monthly revenue trend?
=============================================================
-- Purpose: Analyse seasonal patterns in transaction volume 
-- and revenue across the year to support financial planning 
-- and campaign timing decisions.
=============================================================
SELECT 
    DATENAME(month, date) AS month_name,
    MONTH(date) AS month_number,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM transactionz
GROUP BY DATENAME(month, date), MONTH(date)
ORDER BY month_number;

--INSIGHT:
/*January and February lead in volume and total revenue, while December records 
the highest average transaction value despite ranking fourth overall — consistent with 
seasonal high-value festive transactions. The gap between the top three months is narrow, 
suggesting relatively stable monthly performance with a seasonal spike in transaction quality 
toward year end.*/
=================================================================================================

===============================================================
--Question 4: Which bank processes the highest
--volume of failed transactions?
===============================================================
-- Purpose: Identify whether transaction failures are 
-- concentrated in specific banking partners or distributed 
-- evenly across the platform to determine if the issue is 
-- systemic or integration-specific.
===============================================================

SELECT 
    bank_name,
    COUNT(*) AS failed_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total_failures
FROM transactionz
WHERE status = 'Failed'
GROUP BY bank_name
ORDER BY failed_transactions DESC;

--INSIGHT:
/*Failed transactions are evenly distributed across all seven banks, with Zenith Bank 
recording the highest volume and First Bank the lowest — a difference of just 18 transactions. 
The absence of any single outlier suggests the failure issue is systemic rather than 
bank-specific, pointing to a platform-level or network problem rather than a specific 
banking partner integration issue.*/
=================================================================================================

================================================================
--Question 5: Do KYC-verified users transact 
--differently from unverified users?
================================================================
-- Purpose: Determine whether KYC verification status 
-- influences user spending behaviour and transaction value, 
-- to assess the commercial impact of the verification process.

SELECT 
    CASE u.isKYCVerified 
        WHEN 1 THEN 'Verified' 
        WHEN 0 THEN 'Not Verified' 
    END AS KYC_Status,
    COUNT(t.transaction_id) AS transaction_count,
    ROUND(SUM(t.amount), 2) AS total_revenue,
    ROUND(AVG(t.amount), 2) AS avg_transaction_value,
    ROUND(AVG(t.fees), 2) AS avg_fee
FROM userz u
INNER JOIN transactionz t
    ON u.id = t.user_id
GROUP BY u.isKYCVerified
ORDER BY total_revenue DESC;

--INSIGHT:
/*Unverified users account for 73% of all transactions and generate significantly 
higher total revenue (₦957M vs ₦283M) — driven entirely by volume, not transaction value. 
Average transaction value is virtually identical between both groups (₦248,380.22 vs ₦247,761.54), 
disproving the assumption that KYC verification correlates with higher spending. Verified users
pay marginally higher average fees (₦3,113 vs ₦3,100). The platform's primary revenue growth 
opportunity lies in increasing the verified user base, which currently represents only 27% of users.*/
========================================================================================================

=============================================================
--Question 6 — the final one: What is the average
--transaction fee rate by currency?
=============================================================
-- Purpose: Evaluate whether the platform applies consistent 
-- fee rates across all currencies or whether certain 
-- currencies carry a higher cost burden for users.

SELECT 
    currency,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_transaction_value,
    ROUND(AVG(fees), 2) AS avg_fee,
    ROUND(AVG(fees) * 100.0 / AVG(amount), 2) AS avg_fee_rate_percentage
FROM transactionz
GROUP BY currency
ORDER BY avg_fee_rate_percentage DESC;

--INSIGHT:
/*Fee rates are consistent across all four currencies, ranging narrowly 
between 1.23% and 1.27% — indicating a near-flat fee structure regardless of currency. 
NGN transactions carry the highest average value and fee rate, while GBP carries the lowest
fee rate despite above-average transaction values. The even distribution of transaction volume
across currencies suggests a geographically diverse user base with no single currency 
dominating platform activity.*/
=================================================================================================


