import pandas as pd
import pyodbc

# Kết nối SQL Server
conn = pyodbc.connect("DRIVER={SQL Server};SERVER='...';DATABASE=PinelineDkp;UID='...';PWD=...")


df = pd.read_excel(r"C:\Documents\in_dkp\customersz.xlsx")

# Chuẩn hóa dữ liệu: Xóa khoảng trắng, chuyển email về chữ thường
df["email"] = df["email"].str.strip().str.lower()
df["phone"] = df["phone"].str.replace(r"\D", "", regex=True)  # Chỉ giữ số

# insert SQL Server
for index, row in df.iterrows():
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO customers (name, email, phone)
        VALUES ('ad', 'email', '0')
    """, row["name"], row["email"], row["phone"])
    conn.commit()

print("Inserted!")

#-----------

