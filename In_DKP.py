

import pandas as pd

df = pd.read_csv(r"C:\Documents\in_dkp\orders1.csv")

print(df.isnull().sum())

df_cleaned = df.dropna(subset=['order_id', 'customer_id', 'order_date'])

duplicates = df_cleaned[df_cleaned.duplicated(subset=['order_id'], keep=False)]
print("Dữ liệu trùng lặp:")
print(duplicates)

df_cleaned.to_csv("cleaned_orders.csv", index=False)

#-----

