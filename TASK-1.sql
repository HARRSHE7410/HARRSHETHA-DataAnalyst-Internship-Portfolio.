USE company;

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    dob DATE,
    email VARCHAR(100),
    signup_date VARCHAR(50)
);

INSERT INTO customers (id, name, dob, email, signup_date) VALUES
(146, 'Alice', '1990-05-12', 'alice@example.com', '12/05/2025'),
(254, 'Bob', NULL, 'bob@example.com', '2025-05-12'),
(344, 'Charlie', '1985-08-20', 'charlie@example.com', '12-08-2025'),
(497, 'Maya', '1993-05-12', 'maya@example.com', '12/05/2025'),
(547, 'David', '2000-01-15', 'david@example.com', '15-01-2025');

-- Turn off strict date validation for this run
SET sql_mode = 'NO_ENGINE_SUBSTITUTION';

-- Drop and create cleaned table
DROP TABLE IF EXISTS clean_customers;

CREATE TABLE clean_customers AS
SELECT DISTINCT
    id,
    name,
    dob,
    email,

    CASE
        WHEN signup_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            THEN STR_TO_DATE(signup_date, '%Y-%m-%d')
        WHEN signup_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(signup_date, '%d/%m/%Y')
        WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
            THEN STR_TO_DATE(signup_date, '%d-%m-%Y')
        ELSE NULL
    END AS signup_date_standardized,

    TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS customer_age
FROM customers
WHERE dob IS NOT NULL;

SELECT * FROM customers;

SELECT * FROM clean_customers;