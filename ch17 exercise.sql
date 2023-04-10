-- no 9
INSERT INTO invoices
VALUES (DEFAULT, 1, 1, NOW(), 3000, 3000, 0, 2, NOW(), NOW());

-- no 10
SET GLOBAL general_log = ON;

SELECT @@general_log;

-- no 11
SELECT * FROM invoices;

-- no 13
SET GLOBAL general_log = OFF;

SELECT @@general_log;