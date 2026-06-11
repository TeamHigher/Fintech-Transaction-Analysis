# Fintech-Transaction-Analysis
SQL analysis of 5,000 fintech transactions using SSMS

Fintech Transaction Analysis — SQL Project
This project analyses 5,000 financial transactions from a Nigerian fintech platform using SQL Server, joining transaction data with user demographics to uncover patterns in revenue, behaviour and platform performance.
Six business questions were investigated: transaction success rates across the platform, revenue and volume by transaction purpose, monthly revenue trends, failed transaction distribution by banking partner, the impact of KYC verification on user transaction behaviour, and fee rate analysis by currency.
Key findings include: payment transactions carry the highest average value despite lower volume, suggesting a high-value customer segment worth prioritising; failed transactions are evenly distributed across all seven banking partners, pointing to a systemic platform issue rather than a specific integration problem; KYC-verified users represent only 27% of the user base yet their average transaction value is virtually identical to unverified users, indicating volume rather than verification drives revenue; and fee rates are consistent across NGN, EUR, USD and GBP at between 1.23% and 1.27%, reflecting a near-flat fee structure across currencies.
Tools used: SQL Server (SSMS) — joins, aggregations, window functions, date functions, CASE statements
