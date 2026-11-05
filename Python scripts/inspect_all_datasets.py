from pathlib import Path
import pandas as pd

PROJECT_DIR = Path(r"D:\indian-ecommerce-analytics")
RAW_DIR = PROJECT_DIR / "data" / "raw"

expected_files = [
    "orders.csv",
    "customers.csv",
    "order_items.csv",
    "products.csv",
    "payments.csv",
    "shipments.csv",
    "returns.csv",
    "customer_reviews.csv",
    "marketing_campaigns.csv",
]

for filename in expected_files:
    file_path = RAW_DIR / filename

    print("\n" + "=" * 70)
    print(f"FILE: {filename}")
    print("=" * 70)

    if not file_path.exists():
        print("FILE NOT FOUND — check the filename and folder.")
        continue

    try:
        df = pd.read_csv(
            file_path,
            low_memory=False,
            encoding="utf-8-sig"
        )

        print(f"Rows: {len(df):,}")
        print(f"Columns: {len(df.columns)}")
        print("\nColumn names:")
        print(df.columns.tolist())

        print("\nData types:")
        print(df.dtypes.to_string())

        print("\nMissing values:")
        print(df.isnull().sum().to_string())

        print(f"\nExact duplicate rows: {df.duplicated().sum():,}")

        print("\nSample records:")
        print(df.head(3).to_string(index=False))

    except Exception as exc:
        print(f"Could not inspect this file: {exc}")
