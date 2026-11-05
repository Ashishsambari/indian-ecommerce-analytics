
from sqlalchemy import create_engine
from getpass import getpass
from urllib.parse import quote_plus

password = getpass("Enter your MySQL root password: ")

engine = create_engine(
    "mysql+pymysql://root:"
    + quote_plus(password)
    + "@localhost:3306/indian_ecommerce"
)

try:
    with engine.connect() as connection:
        result = connection.exec_driver_sql(
            "SELECT DATABASE(), VERSION()"
        )
        print("Connected successfully:", result.fetchone())
except Exception as error:
    print("Connection failed:", error)
