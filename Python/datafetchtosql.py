import pandas as pd
from sqlalchemy import create_engine

# 1. PostgreSQL Database Connection URL
# Format: postgresql://username:password@localhost:5432/database_name
db_url = "postgresql://postgres:1212022@localhost:5432/E-Commerce Customer Lifetime Value (LTV) & RFM Segmentation"
engine = create_engine(db_url)

# 2. Aapki SQL Query
query = """
SELECT 
    CustomerID,
    InvoiceNo,
    InvoiceDate::DATE AS TransactionDate,
    -- Har customer ka pehla order month (Cohort Group)
    TO_CHAR(MIN(InvoiceDate) OVER(PARTITION BY CustomerID), 'YYYY-MM') AS CohortMonth,
    -- Transaction ka month
    TO_CHAR(InvoiceDate, 'YYYY-MM') AS TransactionMonth
FROM raw_retail_sales
WHERE CustomerID IS NOT NULL;
"""

# 3. Data Ko Database Se Load Karein
print("Data fetch ho raha hai...")
df = pd.read_sql(query, engine)

# 4. CSV File Mein Save Karein
df.to_csv("RFM_Segmentation_Output.csv", index=False)
print("CSV File Successfully Save Ho Gayi!")

# 5. Excel File Mein Save Karna Ho Toh (Optional):
# df.to_excel("RFM_Segmentation_Output.xlsx", index=False)