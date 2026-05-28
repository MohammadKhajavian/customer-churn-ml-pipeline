-- FILE NAME : 02_feature_engineering.sql
-- PURPOSE   : Build a VIEW combining all 3 tables for machine learning

USE churn_ml;

DROP VIEW IF EXISTS v_ml_features;

CREATE VIEW v_ml_features AS
SELECT
    c.customer_id,
    c.age,
    c.tenure_months,
    CASE WHEN c.gender = 'Male' THEN 1 ELSE 0 END AS gender_male,
    CASE
        WHEN c.region = 'Seoul'   THEN 0
        WHEN c.region = 'Busan'   THEN 1
        WHEN c.region = 'Daegu'   THEN 2
        WHEN c.region = 'Incheon' THEN 3
        ELSE 4
    END AS region_encoded,
    u.monthly_logins,
    u.avg_session_min,
    u.features_used,
    u.support_tickets,
    b.monthly_charge,
    b.payment_delay_days,
    CASE WHEN c.tenure_months < 6 THEN 1 ELSE 0 END AS is_new_customer,
    ROUND(
        (u.monthly_logins  * 0.4)
      + (u.avg_session_min * 0.01)
      + (u.features_used   * 0.5)
      - (u.support_tickets * 0.3)
    , 2) AS engagement_score,
    CASE
        WHEN u.support_tickets >= 3 AND u.monthly_logins <= 3 THEN 1
        ELSE 0
    END AS high_risk_flag,
    c.churned
FROM customers   c
JOIN usage_stats u ON u.customer_id = c.customer_id
JOIN billing     b ON b.customer_id = c.customer_id;

SELECT * FROM v_ml_features LIMIT 5;

SELECT
    CASE WHEN churned=1 THEN 'Churned' ELSE 'Stayed' END AS group_label,
    ROUND(AVG(age), 1)              AS avg_age,
    ROUND(AVG(tenure_months), 1)    AS avg_tenure,
    ROUND(AVG(monthly_logins), 1)   AS avg_logins,
    ROUND(AVG(engagement_score), 2) AS avg_engagement,
    ROUND(AVG(payment_delay_days),1)AS avg_pay_delay,
    COUNT(*)                        AS total
FROM v_ml_features
GROUP BY churned;