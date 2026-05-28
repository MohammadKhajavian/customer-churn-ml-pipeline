# Customer Churn Prediction — End-to-End ML Pipeline

> **MySQL Database → Feature Engineering → Python → Random Forest → Prediction**

---

## Project Overview

This project builds a complete machine learning pipeline to predict
which customers are likely to cancel their subscription (churn).
It connects a real MySQL database to a Python ML model.

---

## Results

| Metric | Score |
|--------|-------|
| Model Accuracy | 100% |
| Algorithm | Random Forest |
| Training rows | 24 customers |
| Test rows | 6 customers |

---

## Top Churn Signals Found

| Rank | Feature | Importance |
|------|---------|------------|
| 1 | Features Used | 0.170 |
| 2 | Age | 0.145 |
| 3 | Avg Session Minutes | 0.140 |
| 4 | Monthly Logins | 0.120 |
| 5 | Payment Delay Days | 0.106 |

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| MySQL 9.6 | Database |
| MySQL Workbench | SQL editor |
| Python 3.x | ML model |
| pandas | Data processing |
| scikit-learn | Random Forest |
| SQLAlchemy | Database connection |
| PyCharm | Development environment |

---

## How to Run

### 1. Setup Database in MySQL Workbench
Run these files in order:
- sql/01_setup_database.sql
- sql/02_feature_engineering.sql

### 2. Install Python packages
```bash
pip install sqlalchemy pymysql pandas scikit-learn
```

### 3. Update password in churn_model.py
```python
DB_PASSWORD = "your_mysql_password"
```

### 4. Run the model
```bash
python churn_model.py
```

---

## Project Structure

```
customer-churn-ml-pipeline/
├── sql/
│   ├── 01_setup_database.sql
│   └── 02_feature_engineering.sql
├── python/
│   └── churn_model.py
├── results/
│   └── results.txt
└── README.md
```

---

## Author
End-to-end ML pipeline: database design → SQL feature 
engineering → Python ML → prediction output.