
import pandas as pd

# Sample data for dim_calendar table
dim_calendar = pd.DataFrame({
    "date_id": pd.date_range(start="2024-01-01", periods=10, freq="D").strftime("%Y-%m-%d"),
    "year": [2024] * 10,
    "month": [1] * 10,
    "day": list(range(1, 11)),
    "weekday": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"]
})

# Sample data for fact_sales table
fact_sales = pd.DataFrame({
    "sale_id": range(1, 11),
    "customer_id": range(101, 111),
    "date_id": pd.date_range(start="2024-01-01", periods=10, freq="D").strftime("%Y-%m-%d"),
    "amount": [100.50, 200.75, 150.00, 175.25, 220.30, 90.00, 135.60, 180.90, 199.99, 250.45]
})

# Sample data for customers table
customers = pd.DataFrame({
    "customer_id": range(101, 111),
    "name": ["John Doe", "Jane Smith", "Alice Johnson", "Bob Brown", "Charlie White", "David Green", "Eve Black", "Frank Blue", "Grace Yellow", "Hank Orange"],
    "email": [f"user{i}@example.com" for i in range(1, 11)],
    "signup_date": pd.date_range(start="2023-01-01", periods=10, freq="M").strftime("%Y-%m-%d")
})

# Save to CSV files
dim_calendar_file = "/Users/or.bohadana/Github_Repo/terrafrom-aws-module/dim_calendar.csv"
fact_sales_file = "/Users/or.bohadana/Github_Repo/terrafrom-aws-module/fact_sales.csv"
customers_file = "/Users/or.bohadana/Github_Repo/terrafrom-aws-module/customers.csv"

dim_calendar.to_csv(dim_calendar_file, index=False)
fact_sales.to_csv(fact_sales_file, index=False)
customers.to_csv(customers_file, index=False)

dim_calendar_file, fact_sales_file, customers_file
