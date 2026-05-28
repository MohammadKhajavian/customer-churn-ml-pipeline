# ================================================================
# FILE NAME : churn_model.py
# PURPOSE   : Connect to MySQL, load data, train churn model
# ================================================================

import pandas as pd
from sqlalchemy import create_engine, text
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score
from sklearn.preprocessing import StandardScaler
from urllib.parse import quote_plus

# ----------------------------------------------------------------
# STEP 1 — Database connection settings
# ----------------------------------------------------------------

DB_USER     = "root"
DB_PASSWORD = "m21102110MM@@"   # your exact password
DB_HOST     = "localhost"
DB_PORT     = 3306
DB_NAME     = "churn_ml"

# This handles special characters like @ in your password
encoded_password = quote_plus(DB_PASSWORD)

engine = create_engine(
    f"mysql+pymysql://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

print("=" * 50)
print("STEP 1: Connecting to MySQL...")
print("=" * 50)

try:
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print("✓ Connection successful!")
except Exception as e:
    print(f"✗ Connection failed: {e}")
    exit()

# ----------------------------------------------------------------
# STEP 2 — Load data from the view
# ----------------------------------------------------------------

print("\n" + "=" * 50)
print("STEP 2: Loading data from v_ml_features view...")
print("=" * 50)

query = """
    SELECT
        age, tenure_months, gender_male, region_encoded,
        monthly_logins, avg_session_min, features_used,
        support_tickets, monthly_charge, payment_delay_days,
        is_new_customer, engagement_score, high_risk_flag,
        churned AS target
    FROM v_ml_features
"""

df = pd.read_sql(query, engine)

print(f"✓ Data loaded successfully!")
print(f"  Total rows    : {len(df)}")
print(f"  Total columns : {len(df.columns)}")
print(f"\n  First 3 rows preview:")
print(df.head(3).to_string(index=False))

# ----------------------------------------------------------------
# STEP 3 — Train the model
# ----------------------------------------------------------------

print("\n" + "=" * 50)
print("STEP 3: Training the model...")
print("=" * 50)

X = df.drop(columns=["target"])
y = df["target"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled  = scaler.transform(X_test)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train_scaled, y_train)
print("✓ Model trained successfully!")

# ----------------------------------------------------------------
# STEP 4 — Evaluate the model
# ----------------------------------------------------------------

print("\n" + "=" * 50)
print("STEP 4: Model evaluation")
print("=" * 50)

y_pred   = model.predict(X_test_scaled)
accuracy = accuracy_score(y_test, y_pred)

print(f"  Accuracy: {accuracy:.0%}")
print(f"\n  Full report:")
print(classification_report(y_test, y_pred,
      target_names=["Stayed (0)", "Churned (1)"]))

# ----------------------------------------------------------------
# STEP 5 — Feature importance
# ----------------------------------------------------------------

print("=" * 50)
print("STEP 5: Feature importance")
print("=" * 50)

importances = pd.Series(
    model.feature_importances_, index=X.columns
).sort_values(ascending=False)

for feature, score in importances.items():
    bar = "|" * int(score * 50)
    print(f"  {feature:<22} {score:.3f}  {bar}")

# ----------------------------------------------------------------
# STEP 6 — Predict a new customer
# ----------------------------------------------------------------

print("\n" + "=" * 50)
print("STEP 6: Predicting a new customer")
print("=" * 50)

new_customer = pd.DataFrame([{
    "age": 27, "tenure_months": 2, "gender_male": 1,
    "region_encoded": 1, "monthly_logins": 1,
    "avg_session_min": 3.5, "features_used": 1,
    "support_tickets": 4, "monthly_charge": 19.99,
    "payment_delay_days": 20, "is_new_customer": 1,
    "engagement_score": 0.5, "high_risk_flag": 1
}])

new_scaled  = scaler.transform(new_customer)
prediction  = model.predict(new_scaled)[0]
probability = model.predict_proba(new_scaled)[0]

print(f"  Prediction       : {'WILL CHURN ⚠️' if prediction == 1 else 'Will STAY ✅'}")
print(f"  Churn probability: {probability[1]:.0%}")
print(f"  Stay  probability: {probability[0]:.0%}")