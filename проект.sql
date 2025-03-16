WITH monthly_check AS (
    SELECT 
        ID_client, 
        DATE_FORMAT(date_new, '%Y-%m') AS month_year
    FROM transactions
    WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
    GROUP BY ID_client, month_year
)
SELECT ID_client, COUNT(DISTINCT month_year) AS active_months
FROM monthly_check
GROUP BY ID_client
ORDER BY active_months DESC;

SELECT 
    SUM(Sum_payment) / COUNT(Id_check) AS avg_check
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31';

SELECT 
    SUM(Sum_payment) / 12 AS avg_monthly_purchase
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31';


 SELECT 
    ID_client, 
    COUNT(Id_check) AS total_operations
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY ID_client;

	SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month_year, 
    SUM(Sum_payment) / COUNT(Id_check) AS avg_check
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY month_year;

	SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month_year, 
    COUNT(Id_check) / COUNT(DISTINCT ID_client) AS avg_operations_per_client
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY month_year;

	SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month_year, 
    COUNT(DISTINCT ID_client) AS unique_clients
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY month_year;

	WITH yearly_totals AS (
    SELECT SUM(Sum_payment) AS total_amount, COUNT(Id_check) AS total_transactions
    FROM transactions
    WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
)
SELECT 
    DATE_FORMAT(date_new, '%Y-%m') AS month_year, 
    SUM(Sum_payment) AS month_amount, 
    COUNT(Id_check) AS month_transactions, 
    SUM(Sum_payment) / (SELECT total_amount FROM yearly_totals) AS amount_share, 
    COUNT(Id_check) / (SELECT total_transactions FROM yearly_totals) AS transaction_share
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY month_year;

	SELECT 
    DATE_FORMAT(t.date_new, '%Y-%m') AS month_year, 
    c.gender, 
    COUNT(DISTINCT t.ID_client) AS total_clients, 
    SUM(t.Sum_payment) AS total_spent, 
    COUNT(DISTINCT t.ID_client) * 100.0 / SUM(COUNT(DISTINCT t.ID_client)) OVER (PARTITION BY DATE_FORMAT(t.date_new, '%Y-%m')) AS gender_share
FROM transactions t
JOIN Customers c ON t. ID_client = c.Id_client
WHERE t.date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY month_year, c.gender
ORDER BY month_year;

	SELECT 
    CASE 
        WHEN Age IS NULL THEN 'Нет данных'
        WHEN Age BETWEEN 0 AND 9 THEN '0-9'
        WHEN Age BETWEEN 10 AND 19 THEN '10-19'
        WHEN Age BETWEEN 20 AND 29 THEN '20-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        WHEN Age BETWEEN 60 AND 69 THEN '60-69'
        WHEN Age BETWEEN 70 AND 79 THEN '70-79'
        ELSE '80+'
    END AS age_group,
    COUNT(ID_client) AS client_count,
    SUM(Total_amount) AS total_spent,
    COUNT(ID_client) / (SELECT COUNT(*) FROM Customers) * 100 AS percentage
FROM Customers
GROUP BY age_group
ORDER BY age_group;

	SELECT 
    CONCAT(YEAR(date_new), '-Q', QUARTER(date_new)) AS quarter, 
    COUNT(Id_check) AS total_operations, 
    SUM(Sum_payment) AS total_spent, 
    COUNT(DISTINCT ID_client) AS unique_clients,
    COUNT(Id_check) * 100.0 / SUM(COUNT(Id_check)) OVER () AS operation_share
FROM transactions
WHERE date_new BETWEEN '2015-06-01' AND '2016-05-31'
GROUP BY quarter
ORDER BY quarter;


