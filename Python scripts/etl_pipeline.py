
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text
from getpass import getpass
from urllib.parse import quote_plus

# Project paths
RAW = Path(r"D:\indian-ecommerce-analytics\data\raw")

# MySQL connection
password = getpass("Enter MySQL root password: ")

engine = create_engine(
    f"mysql+pymysql://root:{quote_plus(password)}"
    "@localhost:3306/indian_ecommerce"
)

# Parent tables first, child tables later
tables = [
    "customers",
    "products",
    "marketing_campaigns",
    "orders",
    "order_items",
    "payments",
    "shipments",
    "returns",
    "customer_reviews"
]

# Check whether all tables are empty before loading
try:
    with engine.connect() as conn:
        for table in tables:
            count = conn.execute(
                text(f"SELECT COUNT(*) FROM `{table}`")
            ).scalar()

            if count > 0:
                raise RuntimeError(
                    f"Table '{table}' already contains {count} rows. "
                    "Stop to avoid duplicate loading."
                )

    print("\nAll destination tables are empty.")
    
    total_records = 0

    # Load CSV files in dependency order
    with engine.begin() as conn:

        for table in tables:

            file_path = RAW / f"{table}.csv"

            print(f"\nLoading: {table}")

            if not file_path.exists():
                raise FileNotFoundError(file_path)

            df = pd.read_csv(
                file_path,
                encoding="utf-8-sig",
                low_memory=False
            )

            # Insert data into existing MySQL table
            df.to_sql(
                name=table,
                con=conn,
                if_exists="append",
                index=False,
                chunksize=1000
            )

            loaded = len(df)
            total_records += loaded

            print(f"Successfully loaded: {loaded:,} records")

    print("\n" + "=" * 45)
    print("ETL PROCESS COMPLETED")
    print("Total records loaded:", f"{total_records:,}")
    print("=" * 45)

except Exception as error:
    print("\nETL FAILED:", error)
    print("Database transaction rolled back if loading failed.")

finally:
    engine.dispose()