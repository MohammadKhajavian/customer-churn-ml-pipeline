-- FILE NAME : 01_setup_database.sql
-- PURPOSE   : Create the database and fill it with sample data

CREATE DATABASE IF NOT EXISTS churn_ml;
USE churn_ml;

DROP TABLE IF EXISTS billing;
DROP TABLE IF EXISTS usage_stats;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    age           INT,
    gender        VARCHAR(10),
    region        VARCHAR(20),
    tenure_months INT,
    churned       TINYINT(1)
);

CREATE TABLE usage_stats (
    stat_id         INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT,
    monthly_logins  INT,
    avg_session_min FLOAT,
    features_used   INT,
    support_tickets INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE billing (
    billing_id         INT PRIMARY KEY AUTO_INCREMENT,
    customer_id        INT,
    monthly_charge     FLOAT,
    payment_delay_days INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (age, gender, region, tenure_months, churned) VALUES
(25,'Male','Seoul',3,1),(45,'Female','Busan',24,0),
(33,'Male','Daegu',6,1),(52,'Female','Seoul',36,0),
(28,'Female','Busan',2,1),(60,'Male','Incheon',48,0),
(38,'Male','Seoul',12,0),(22,'Female','Busan',1,1),
(47,'Male','Daegu',30,0),(35,'Female','Seoul',9,1),
(41,'Male','Incheon',18,0),(29,'Female','Busan',4,1),
(55,'Male','Seoul',60,0),(31,'Female','Daegu',7,1),
(44,'Male','Busan',15,0),(26,'Female','Seoul',2,1),
(50,'Male','Incheon',42,0),(37,'Female','Busan',11,0),
(23,'Male','Seoul',1,1),(48,'Female','Daegu',20,0),
(34,'Male','Busan',5,1),(61,'Female','Seoul',54,0),
(27,'Male','Incheon',3,1),(43,'Female','Busan',28,0),
(39,'Male','Seoul',14,0),(30,'Female','Daegu',6,1),
(56,'Male','Busan',48,0),(24,'Female','Seoul',2,1),
(46,'Male','Incheon',22,0),(32,'Female','Busan',8,1);

INSERT INTO usage_stats (customer_id, monthly_logins, avg_session_min, features_used, support_tickets) VALUES
(1,2,5.1,1,3),(2,18,32.4,7,0),(3,3,7.2,2,2),(4,22,40.1,9,0),
(5,1,3.5,1,4),(6,25,55.0,10,0),(7,15,28.3,6,1),(8,1,2.1,1,5),
(9,20,35.6,8,0),(10,4,9.8,2,3),(11,17,30.2,7,0),(12,2,4.4,1,3),
(13,28,60.5,10,0),(14,3,6.1,2,2),(15,16,27.9,6,1),(16,1,3.0,1,4),
(17,24,48.7,9,0),(18,14,25.3,5,1),(19,1,2.8,1,5),(20,19,36.4,8,0),
(21,3,8.2,2,3),(22,27,58.1,10,0),(23,2,5.5,1,4),(24,21,39.7,8,0),
(25,16,29.4,6,1),(26,3,7.0,2,2),(27,26,52.3,10,0),(28,1,2.5,1,5),
(29,20,37.8,8,0),(30,3,8.9,2,3);

INSERT INTO billing (customer_id, monthly_charge, payment_delay_days) VALUES
(1,29.99,15),(2,79.99,0),(3,29.99,10),(4,99.99,0),(5,19.99,20),
(6,99.99,0),(7,69.99,2),(8,19.99,25),(9,89.99,0),(10,29.99,12),
(11,79.99,1),(12,19.99,18),(13,99.99,0),(14,29.99,9),(15,69.99,2),
(16,19.99,22),(17,99.99,0),(18,59.99,3),(19,19.99,28),(20,89.99,0),
(21,29.99,11),(22,99.99,0),(23,19.99,19),(24,89.99,0),(25,69.99,2),
(26,29.99,8),(27,99.99,0),(28,19.99,24),(29,89.99,0),(30,29.99,13);

SELECT 'customers'   AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL SELECT 'usage_stats', COUNT(*) FROM usage_stats
UNION ALL SELECT 'billing',     COUNT(*) FROM billing;