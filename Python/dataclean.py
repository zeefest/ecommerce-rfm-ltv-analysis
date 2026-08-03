import pandas as pd

# Data load karein
df = pd.read_csv('Data.csv', encoding='ISO-8859-1')

print("1. Raw Rows:", len(df))

# Missing CustomerID wali rows remove karein
df_clean = df.dropna(subset=['CustomerID']).copy()

# CustomerID ko integer string format mein layein
df_clean['CustomerID'] = df_clean['CustomerID'].astype(int).astype(str)

# Valid transactions filter karein (Quantity and UnitPrice greater than 0)
df_clean = df_clean[(df_clean['Quantity'] > 0) & (df_clean['UnitPrice'] > 0)]

# InvoiceDate ko Datetime Object banayein
df_clean['InvoiceDate'] = pd.to_datetime(df_clean['InvoiceDate'])

# Total Monetary Value calculate karein
df_clean['TotalAmount'] = df_clean['Quantity'] * df_clean['UnitPrice']

print("2. Cleaned Rows:", len(df_clean))

# Cleaned data ko CSV mein save karein
df_clean.to_csv('cleaned_data.csv', index=False)
print("✅ Saved as 'cleaned_data.csv'")