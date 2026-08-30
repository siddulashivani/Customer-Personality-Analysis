----> Step 1: Create the staging table

CREATE  TABLE raw_customers(
id INT, 
year_birth INT,
education VARCHAR(30),
marital_status VARCHAR(30),
income NUMERIC,
kidhome INT,
teenhome INT,
dt_custome DATE,
recency INT,
nmtwines INT,
mntfruits INT,
mntmeatproducts INT,
mntfishproducts INT,
mntsweetproducts INT,
mntgoldproducts INT,
numdealspurchases INT,
numwebpurchases INT,
numcatalogpurchases INT,
numstorepurchases INT,
numwebvisitsmonth INT,
acceptedcmp3 INT,
acceptedcmp4 INT,
acceptedcmp5 INT,
acceptedcmp1 INT,
acceptedcmp2 INT,
complain INT,
response INT,
age INT,
total_spend INT
);

----> Step 3: Loading your CSV

SELECT COUNT(*) AS rows_loaded FROM raw_customers;

-----> Step 4: Build the 4 related tables

SELECT column_name FROM information_schema.columns
WHERE table_name = 'raw_customers'
ORDER BY ordinal_position;

ALTER TABLE raw_customers RENAME COLUMN dt_custome TO dt_customer;

CREATE TABLE customers AS
SELECT id, year_birth, age, education, marital_status, income,
       kidhome, teenhome, dt_customer, recency, complain
FROM raw_customers;

SELECT column_name FROM information_schema.columns
WHERE table_name = 'raw_customers'
ORDER BY ordinal_position;

ALTER TABLE raw_customers RENAME COLUMN nmtwines TO mntwines;
ALTER TABLE raw_customers RENAME COLUMN mntgoldproducts TO mntgoldprods;

CREATE TABLE spending AS
SELECT id, 'Wines' AS category, mntwines AS amount FROM raw_customers
UNION ALL SELECT id, 'Fruits', mntfruits FROM raw_customers
UNION ALL SELECT id, 'Meat', mntmeatproducts FROM raw_customers
UNION ALL SELECT id, 'Fish', mntfishproducts FROM raw_customers
UNION ALL SELECT id, 'Sweets', mntsweetproducts FROM raw_customers
UNION ALL SELECT id, 'Gold', mntgoldprods FROM raw_customers;


CREATE TABLE purchases AS
SELECT id, 'Deals' AS channel, numdealspurchases AS count FROM raw_customers
UNION ALL SELECT id, 'Web', numwebpurchases FROM raw_customers
UNION ALL SELECT id, 'Catalog', numcatalogpurchases FROM raw_customers
UNION ALL SELECT id, 'Store', numstorepurchases FROM raw_customers
UNION ALL SELECT id, 'WebVisits', numwebvisitsmonth FROM raw_customers;


CREATE TABLE campaigns AS
SELECT id, 'Campaign1' AS campaign, acceptedcmp1 AS accepted FROM raw_customers
UNION ALL SELECT id, 'Campaign2', acceptedcmp2 FROM raw_customers
UNION ALL SELECT id, 'Campaign3', acceptedcmp3 FROM raw_customers
UNION ALL SELECT id, 'Campaign4', acceptedcmp4 FROM raw_customers
UNION ALL SELECT id, 'Campaign5', acceptedcmp5 FROM raw_customers
UNION ALL SELECT id, 'Campaign6_Latest', response FROM raw_customers;

SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL SELECT 'spending', COUNT(*) FROM spending
UNION ALL SELECT 'purchases', COUNT(*) FROM purchases
UNION ALL SELECT 'campaigns', COUNT(*) FROM campaigns;

------> Query 1 — Total spend by education (JOIN + GROUP BY)
-- Question: Which education group generates the most total spend?

SELECT 
c.education,
    ROUND(SUM(s.amount)::numeric, 2) AS total_spend,
	ROUND(AVG(s.amount)::numeric, 2) AS avg_per_category
FROM customers c
JOIN spending s ON c.id = s.id
GROUP BY c.education
ORDER BY total_spend DESC;

SELECT COUNT(*) FROM customers;

-------> Query 2: Top category by marital status (JOIN + 2-column GROUP BY)

SELECT 
    c.marital_status, 
    s.category, 
    ROUND(SUM(s.amount)::numeric, 2) AS total_amount
FROM customers c
JOIN spending s 
    ON c.id = s.id
GROUP BY c.marital_status, s.category
ORDER BY c.marital_status DESC, total_amount DESC;

--------> Query 3: Campaign responders' income vs. overall (JOIN + subquery)
SELECT
  (SELECT ROUND(AVG(income)::numeric, 2) 
FROM customers) AS overall_avg_income,
  ROUND(AVG(c.income)::numeric, 2) AS responder_avg_income
FROM customers c
JOIN campaigns cp ON c.id = cp.id
WHERE cp.campaign = 'Campaign6_Latest' AND cp.accepted = 1;

---------> Query 4: Web purchases by education (JOIN + WHERE + GROUP BY)

SELECT c.education, 
	ROUND(AVG(p.count)::numeric, 2) AS avg_web_purchases
FROM customers c
JOIN purchases p ON c.id = p.id
WHERE p.channel = 'Web'
GROUP BY c.education
ORDER BY avg_web_purchases DESC;

--------> Query 5: Campaign acceptance rates (aggregation)

SELECT campaign, 
	ROUND(AVG(accepted)::numeric * 100, 2) AS acceptance_rate_pct,
SUM(accepted) AS total_accepted
FROM campaigns
GROUP BY campaign
ORDER BY acceptance_rate_pct DESC;

---------> Query 6: High spender count (subquery)

SELECT COUNT(DISTINCT id) AS high_spenders
FROM (SELECT id, SUM(amount) AS cust_total 
FROM spending GROUP BY id) t
WHERE cust_total > (SELECT AVG(amount) * 6 FROM spending);

---------> Query 7: Complaint rate by education (GROUP BY)

SELECT education, 
	ROUND(AVG(complain)::numeric * 100, 2) AS complaint_rate_pct,
COUNT(*) AS num_customers
FROM customers
GROUP BY education
ORDER BY complaint_rate_pct DESC;

---------> Query 8: Top 5 customers by spend (subquery + JOIN + LIMIT)

SELECT c.id, c.education, c.marital_status, c.income, t.cust_total
FROM (SELECT id, SUM(amount) AS cust_total 
FROM spending GROUP BY id
ORDER BY cust_total DESC LIMIT 5) t
JOIN customers c ON c.id = t.id
ORDER BY t.cust_total DESC;

---------> Query 9: Store vs. web by age group (JOIN + CASE + GROUP BY)

SELECT
  CASE WHEN c.age < 35 THEN 'Under 35'
       WHEN c.age BETWEEN 35 AND 54 THEN '35-54'
       ELSE '55+' END AS age_group,
p.channel, ROUND(AVG(p.count)::numeric, 2) AS avg_purchases
FROM customers c
JOIN purchases p ON c.id = p.id
WHERE p.channel IN ('Web', 'Store')
GROUP BY age_group, p.channel
ORDER BY age_group, p.channel;

----------> Query 10: Childless high-spenders' income (nested subquery)

SELECT COUNT(*) AS childless_high_spenders, 
	ROUND(AVG(c.income)::numeric, 2) AS avg_income
FROM customers c
WHERE c.kidhome = 0 AND c.teenhome = 0
AND c.id IN (
    SELECT id FROM spending GROUP BY id
    HAVING SUM(amount) > (SELECT AVG(t.total) 
    FROM (SELECT SUM(amount) AS total 
	FROM spending GROUP BY id) t)
);



