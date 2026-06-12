# 💳 Fintech Transaction Analysis

SQL Project | Nigerian Fintech Platform | 5,000 Transactions | 1,000 Users

## 📚 Table of Contents
- [Project Overview](#project-overview)
- [Tools & Technologies](#tools--technologies)
- [Dataset Breakdown](#dataset-breakdown)
- [Business Questions](#business-questions)
- [Key Insights & Findings](#key-insights--findings)
- [Recommendations](#recommendations)

---

## 📌 Project Overview

This project analyses 5,000 financial transactions from a Nigerian fintech platform 
to uncover patterns in revenue performance, user behaviour and platform reliability.

The analysis joins two datasets — transactions and user demographics — to answer 
six key business questions that a product, operations or finance team would 
realistically need answered.

The goal is to move beyond surface-level reporting and deliver insights that 
directly inform business decisions around revenue optimisation, user acquisition 
and platform improvement.

---

## 🛠️ Tools & Technologies

- SQL Server (SSMS) — primary analysis tool
- Joins — connecting transaction and user tables
- Aggregations — SUM, COUNT, AVG
- Window Functions — OVER() for percentage calculations
- Date Functions — DATENAME, MONTH
- CASE Statements — for readable output formatting

---

## 📊 Dataset Breakdown

**transactionz table**
- transaction_id — unique identifier
- user_id — links to userz table
- date — transaction date
- amount — transaction value in Nigerian Naira (₦)
- fees — transaction fee charged
- currency — NGN, GBP, USD, EUR
- status — Successful, Failed, Pending
- purpose — Transfer, Payment, Deposit, Airtime
- bank_name — banking partner used

**userz table**
- id — unique user identifier
- isKYCVerified — 1 = Verified, 0 = Not Verified
- KycStatus — KYC status description
- age, gender, location — demographic data

---

## ❓ Business Questions

### Question 1: What is the overall transaction success rate by status?
**Purpose:** Understand platform reliability and identify the proportion 
of failed transactions.

```sql
SELECT 
    status,
    COUNT(*) AS transaction_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM transactionz
GROUP BY status
ORDER BY transaction_count DESC;
```

### Question 2: Which transaction purpose generates the most revenue?
**Purpose:** Identify which transaction types drive the most revenue and 
highest average value to inform product and marketing prioritisation.

```sql
SELECT 
    purpose,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM transactionz
GROUP BY purpose
ORDER BY total_revenue DESC;
```

### Question 3: What is the monthly revenue trend?
**Purpose:** Analyse seasonal patterns in transaction volume and revenue 
across the year to support financial planning and campaign timing.

```sql
SELECT 
    DATENAME(month, date) AS month_name,
    MONTH(date) AS month_number,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_transaction_value
FROM transactionz
GROUP BY DATENAME(month, date), MONTH(date)
ORDER BY month_number;
```

### Question 4: Which bank processes the highest volume of failed transactions?
**Purpose:** Determine whether transaction failures are concentrated in 
specific banking partners or distributed evenly to identify if the issue 
is systemic or integration-specific.

```sql
SELECT 
    bank_name,
    COUNT(*) AS failed_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total_failures
FROM transactionz
WHERE status = 'Failed'
GROUP BY bank_name
ORDER BY failed_transactions DESC;
```

### Question 5: Do KYC-verified users transact differently from unverified users?
**Purpose:** Determine whether KYC verification influences spending behaviour 
and transaction value to assess the commercial impact of the verification process.

```sql
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
```

### Question 6: What is the average transaction fee rate by currency?
**Purpose:** Evaluate whether the platform applies consistent fee rates 
across all currencies or whether certain currencies carry a higher cost burden.

```sql
SELECT 
    currency,
    COUNT(*) AS transaction_count,
    ROUND(AVG(amount), 2) AS avg_transaction_value,
    ROUND(AVG(fees), 2) AS avg_fee,
    ROUND(AVG(fees) * 100.0 / AVG(amount), 2) AS avg_fee_rate_percentage
FROM transactionz
GROUP BY currency
ORDER BY avg_fee_rate_percentage DESC;
```

---

## 💡 Key Insights & Findings

1. **Transaction Success Rate** — The platform shows a clear breakdown 
between successful, failed and pending transactions, establishing a 
baseline for reliability monitoring.

2. **Revenue by Purpose** — Transfers lead in volume and total revenue, 
however payment transactions carry the highest average transaction value 
at ₦254,139 — suggesting a smaller but higher-value customer segment worth 
prioritising for acquisition and retention.

3. **Monthly Trends** — January and February record the highest transaction 
volume and total revenue. December, despite ranking fourth in volume, 
records the highest average transaction value — consistent with seasonal 
high-value festive spending.

4. **Failed Transactions by Bank** — Failed transactions are evenly 
distributed across all seven banking partners, with a difference of only 
18 transactions between the highest and lowest. This points to a systemic 
platform-level issue rather than a specific banking integration problem.

5. **KYC Verification Impact** — Unverified users account for 73% of all 
transactions and generate significantly higher total revenue (₦957M vs ₦283M) 
driven entirely by volume, not transaction value. Average transaction value 
is virtually identical between both groups (₦248,300 vs ₦247,700), 
disproving the assumption that KYC verification correlates with higher spending.

6. **Fee Rate by Currency** — Fee rates are consistent across all four 
currencies, ranging narrowly between 1.23% and 1.27%, indicating a 
near-flat fee structure regardless of currency. Transaction volume is 
evenly distributed across NGN, EUR, USD and GBP suggesting a 
geographically diverse user base.

---

## ✅ Recommendations

1. **Focus on payment transaction users** — despite lower volume, their 
higher average value makes them a priority segment for retention campaigns.

2. **Investigate platform-level failure causes** — the even distribution 
of failures across all banks rules out individual integration issues and 
points to a deeper infrastructure problem requiring technical review.

3. **Prioritise unverified user conversion** — with 73% of revenue coming 
from unverified users, growing this segment through better onboarding 
offers greater revenue upside than assuming verification drives value.

4. **Plan campaigns around January, February and December** — these months 
consistently outperform on volume and value respectively.
