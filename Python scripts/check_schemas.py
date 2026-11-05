
from pathlib import Path
import pandas as pd

RAW = Path(r"D:\indian-ecommerce-analytics\data\raw")

files = [
    "customers.csv",
    "products.csv",
    "marketing_campaigns.csv",
    "orders.csv",
    "order_items.csv",
    "payments.csv",
    "shipments.csv",
    "returns.csv",
    "customer_reviews.csv"
]

for filename in files:
    path = RAW / filename

    print("\n" + "=" * 50)
    print(filename)
    print("=" * 50)

    if not path.exists():
        print("File not found!")
        continue

    df = pd.read_csv(path, nrows=5, encoding="utf-8-sig")

    print("Columns:")
    for column in df.columns:
        print("-", column)

    print("\nData types:")
    print(df.dtypes.to_string())
