
from pathlib import Path
import pandas as pd

RAW = Path(r"D:\indian-ecommerce-analytics\data\raw")

def load(name):
    return pd.read_csv(RAW / name, encoding="utf-8-sig",
                       low_memory=False)

orders = load("orders.csv")
customers = load("customers.csv")
items = load("order_items.csv")
products = load("products.csv")
payments = load("payments.csv")
shipments = load("shipments.csv")
returns = load("returns.csv")
reviews = load("customer_reviews.csv")
campaigns = load("marketing_campaigns.csv")

# Check whether key columns contain duplicate IDs
key_checks = [
    ("orders", orders, "order_id"),
    ("customers", customers, "customer_id"),
    ("order_items", items, "order_item_id"),
    ("products", products, "product_id"),
    ("payments", payments, "payment_id"),
    ("shipments", shipments, "shipment_id"),
    ("returns", returns, "return_id"),
    ("customer_reviews", reviews, "review_id"),
    ("marketing_campaigns", campaigns, "campaign_id"),
]

print("=== PRIMARY KEY CHECKS ===")
for name, df, key in key_checks:
    print(f"{name}: duplicate {key} = {df[key].duplicated().sum()}")

# Check whether referenced IDs exist in the parent dataset
def check_reference(child, child_col, parent, parent_col, label):
    actual_ids = child[child_col].dropna()
    valid_ids = set(parent[parent_col].dropna())
    orphan_count = (~actual_ids.isin(valid_ids)).sum()
    print(f"{label}: unmatched records = {orphan_count}")

print("\n=== RELATIONSHIP CHECKS ===")

check_reference(orders, "customer_id", customers, "customer_id",
                "Orders -> Customers")

check_reference(items, "order_id", orders, "order_id",
                "Order Items -> Orders")

check_reference(items, "product_id", products, "product_id",
                "Order Items -> Products")

check_reference(payments, "order_id", orders, "order_id",
                "Payments -> Orders")

check_reference(shipments, "order_id", orders, "order_id",
                "Shipments -> Orders")

check_reference(returns, "order_id", orders, "order_id",
                "Returns -> Orders")

check_reference(returns, "customer_id", customers, "customer_id",
                "Returns -> Customers")

check_reference(returns, "product_id", products, "product_id",
                "Returns -> Products")

check_reference(reviews, "order_id", orders, "order_id",
                "Reviews -> Orders")

check_reference(reviews, "customer_id", customers, "customer_id",
                "Reviews -> Customers")

check_reference(reviews, "product_id", products, "product_id",
                "Reviews -> Products")

check_reference(orders, "campaign_id", campaigns, "campaign_id",
                "Orders -> Campaigns")

print("\nValidation completed.")
